//Copyright 2015 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//=====================================================================
//подпрограммы поддержки трехмерной компьютерной графики
//=====================================================================
unit img3d_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Clipbrd, LCLintf, LCLtype,
  utils_unit, img_unit, arith_complex;

type
tvector3=record x,y,z:real; end;
ttrio=record p1,p2,p3:integer; c1,c2,c3:Int32; n:tvector3; end;

Timg3d=class
  coords:array of tvector3; //координаты вершин
  trios:array of ttrio; //грани объекта
  name:string; //текстовое имя объекта
  n_coords,n_trios:integer; //количество вершин и граней
  constructor create; //конструктор
  destructor done; //деструктор
  procedure SetParams(coords_num,trios_num:integer);
  procedure LoadFromSTL(filename:string); //загрузка объекта из внешнего STL-файла
  procedure SaveToSTL(filename:string); //сохранение объекта во внешний STL-файл
  procedure translate(s:tvector3); //перемещение объекта вдоль вектора s
  procedure rotate_xy(alpha:real); //вращение объекта около оси OZ
  procedure rotate_xz(alpha:real); //вращение объекта около оси OY
  procedure rotate_yz(alpha:real); //вращение объекта около оси OX
  procedure scale_x(k:real); //масштабирование объекта вдоль оси OX
  procedure scale_y(k:real); //масштабирование объекта вдоль оси OY
  procedure scale_z(k:real); //масштабирование объекта вдоль оси OZ
  procedure CalcM(kx,ky,kz,axy,axz,ayz,sx,sy,sz:real); //масштабирование, вращение и перемещение объекта
  procedure Draw3dToImg(img:TImg; mode:integer; draw_axes:boolean); //спроецировать объект на полотно рисования
  procedure CalcNormals; //перерасчет всех нормалей треугольников модели
end;

implementation

//==============================================================
//вспомогательные подпрограммы 3d-арифметики над 3d-векторами
//==============================================================

function product_scalar_3d(v1,v2:tvector3):real;
begin product_scalar_3d:=v1.x*v2.x+v1.y*v2.y+v1.z*v2.z; end;

function add_3d(v1,v2:tvector3):tvector3;
var tmp:tvector3;
begin
  tmp.x:=v1.x+v2.x;
  tmp.y:=v1.y+v2.y;
  tmp.z:=v1.z+v2.z;
  add_3d:=tmp;
end;

function sub_3d(v1,v2:tvector3):tvector3;
var tmp:tvector3;
begin
  tmp.x:=v1.x-v2.x;
  tmp.y:=v1.y-v2.y;
  tmp.z:=v1.z-v2.z;
  sub_3d:=tmp;
end;

function product_const_3d(k:real; v:tvector3):tvector3;
var tmp:tvector3;
begin
  tmp.x:=k*v.x;
  tmp.y:=k*v.y;
  tmp.z:=k*v.z;
  product_const_3d:=tmp;
end;

function length_3d(v:tvector3):real;
begin
  length_3d:=sqrt(sqr(v.x)+sqr(v.y)+sqr(v.z));
end;

function normalize_3d(v:tvector3):tvector3;
var tmp:tvector3; d,d1:real;
begin
  d:=length_3d(v); tmp.x:=0; tmp.y:=0; tmp.z:=0;
  if d>0 then
  begin
    d1:=1.0/d;
    tmp.x:=v.x*d1;
    tmp.y:=v.y*d1;
    tmp.z:=v.z*d1;
  end;
  normalize_3d:=tmp;
end;

function is_same_3d(v1,v2:tvector3):boolean;
var tmp:boolean;
begin
  tmp:=false;
  if (v1.x=v2.x)and(v1.y=v2.y)and(v1.z=v2.z) then tmp:=true;
  is_same_3d:=tmp;
end;

function product_cross_3d(v1,v2:tvector3):tvector3;
var tmp:tvector3;
begin
  tmp.x:=v1.z*v2.y-v1.y*v2.z;
  tmp.y:=v1.x*v2.z-v1.z*v2.x;
  tmp.z:=v1.y*v2.x-v1.x*v2.y;
  product_cross_3d:=tmp;
end;

function normal_3d(p1,p2,p3:tvector3):tvector3;
var v1,v2:tvector3;
begin
  v1.x:=0; v1.y:=0; v1.z:=0;
  v2.x:=0; v2.y:=0; v2.z:=0;
  if (is_same_3d(p1,p2) or is_same_3d(p1,p3) or is_same_3d(p2,p3))=false then
  begin
    v1:=sub_3d(p2,p1);
    v2:=sub_3d(p3,p1);
  end;
  normal_3d:=product_cross_3d(v1,v2);
end;

//==============================================================

constructor TImg3d.create;
begin
  n_coords:=0; n_trios:=0;
  setlength(coords,0); setlength(trios,0);
end;

destructor TImg3d.done;
begin
  Finalize(coords);
  Finalize(trios);
end;

procedure Timg3d.SetParams(coords_num,trios_num:integer);
begin
     n_coords:=coords_num; n_trios:=trios_num;
     setlength(coords,n_coords);
     setlength(trios,n_trios);
end;

procedure Timg3d.translate(s:tvector3);
var i:integer;
begin
     for i:=0 to n_coords-1 do
     begin
       coords[i].x:=coords[i].x+s.x;
       coords[i].y:=coords[i].y+s.y;
       coords[i].z:=coords[i].z+s.z;
     end;
end;

procedure Timg3d.rotate_xy(alpha:real);
var tmp:tvector3; i:integer;
begin
     for i:=0 to n_coords-1 do
     begin
       tmp.x:=coords[i].x*cos(alpha)-coords[i].y*sin(alpha);
       tmp.y:=coords[i].x*sin(alpha)+coords[i].y*cos(alpha);
       tmp.z:=coords[i].z;
       coords[i]:=tmp;
     end;
     CalcNormals;
end;

procedure Timg3d.rotate_xz(alpha:real);
var tmp:tvector3; i:integer;
begin
     for i:=0 to n_coords-1 do
     begin
       tmp.x:=coords[i].x*cos(alpha)-coords[i].z*sin(alpha);
       tmp.y:=coords[i].y;
       tmp.z:=coords[i].x*sin(alpha)+coords[i].z*cos(alpha);
       coords[i]:=tmp;
     end;
     CalcNormals;
end;

procedure Timg3d.rotate_yz(alpha:real);
var tmp:tvector3; i:integer;
begin
     for i:=0 to n_coords-1 do
     begin
       tmp.x:=coords[i].x;
       tmp.y:=coords[i].y*cos(alpha)-coords[i].z*sin(alpha);
       tmp.z:=coords[i].y*sin(alpha)+coords[i].z*cos(alpha);
       coords[i]:=tmp;
     end;
     CalcNormals;
end;

procedure Timg3d.scale_x(k:real);
var i:integer; begin for i:=0 to n_coords-1 do coords[i].x:=k*coords[i].x; CalcNormals; end;

procedure Timg3d.scale_y(k:real);
var i:integer; begin for i:=0 to n_coords-1 do coords[i].y:=k*coords[i].y; CalcNormals; end;

procedure Timg3d.scale_z(k:real);
var i:integer; begin for i:=0 to n_coords-1 do coords[i].z:=k*coords[i].z; CalcNormals; end;

procedure Timg3d.CalcM(kx,ky,kz,axy,axz,ayz,sx,sy,sz:real);
var s:tvector3;
begin
   scale_x(kx);
   scale_y(ky);
   scale_z(kz);
   rotate_xy(axy);
   rotate_yz(ayz);
   rotate_xz(axz);
   s.x:=sx; s.y:=sy; s.z:=sz; translate(s);
   CalcNormals;
end;

//перерасчет всех нормалей треугольников модели
procedure Timg3d.CalcNormals;
var i:integer;
begin
  for i:=0 to n_trios-1 do
    trios[i].n:=Normal_3d(Coords[trios[i].p1],Coords[trios[i].p2],Coords[trios[i].p3]);
end;

procedure Timg3d.LoadFromSTL(filename:string);
var f:file;
    stl_header:array[1..80] of char;
    i:integer;
    i16_tmp:UINT16;
    i32_tmp:UINT32;
    r32_tmp:single;
begin
   assignfile(f,filename);
   reset(f,1);
   blockread(f,stl_header,80);
   blockread(f,i32_tmp,4);
   n_trios:=i32_tmp; n_coords:=n_trios*3;
   SetParams(n_coords,n_trios);
   for i:=0 to n_trios-1 do
   begin
        trios[i].p1:=i*3;
        trios[i].p2:=i*3+1;
        trios[i].p3:=i*3+2;
        trios[i].c1:=255;
        trios[i].c2:=255;
        trios[i].c3:=255;
   end;
   for i:=0 to n_trios-1 do
   begin
        blockread(f,r32_tmp,4); trios[i].n.x:=r32_tmp;
        blockread(f,r32_tmp,4); trios[i].n.y:=r32_tmp;
        blockread(f,r32_tmp,4); trios[i].n.z:=r32_tmp;

        blockread(f,r32_tmp,4); coords[3*i].x:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i].y:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i].z:=r32_tmp;

        blockread(f,r32_tmp,4); coords[3*i+1].x:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i+1].y:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i+1].z:=r32_tmp;

        blockread(f,r32_tmp,4); coords[3*i+2].x:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i+2].y:=r32_tmp;
        blockread(f,r32_tmp,4); coords[3*i+2].z:=r32_tmp;

        blockread(f,i16_tmp,2); trios[i].c1:=i16_tmp;
   end;
   CalcNormals;
   close(f);
end;

//сохранение объекта во внешний STL-файл
procedure Timg3d.SaveToSTL(filename:string);
var f:file;
    stl_header:array[1..80] of char;
    i:integer;
    i16_tmp:UINT16;
    i32_tmp:UINT32;
    r32_tmp:single;
    norm_normal:tvector3;
begin
   assignfile(f,filename);
   rewrite(f,1);
   stl_header:=format('%6s',['solid '])+format('%74s',[name]);
   blockwrite(f,stl_header,80);
   i32_tmp:=n_trios;
   blockwrite(f,i32_tmp,4);

   CalcNormals;
   for i:=0 to n_trios-1 do
   begin
        norm_normal:=normalize_3d(trios[i].n);
        r32_tmp:=norm_normal.x; blockwrite(f,r32_tmp,4);
        r32_tmp:=norm_normal.y; blockwrite(f,r32_tmp,4);
        r32_tmp:=norm_normal.z; blockwrite(f,r32_tmp,4);

        r32_tmp:=coords[trios[i].p1].x; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p1].y; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p1].z; blockwrite(f,r32_tmp,4);

        r32_tmp:=coords[trios[i].p2].x; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p2].y; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p2].z; blockwrite(f,r32_tmp,4);

        r32_tmp:=coords[trios[i].p3].x; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p3].y; blockwrite(f,r32_tmp,4);
        r32_tmp:=coords[trios[i].p3].z; blockwrite(f,r32_tmp,4);

        i16_tmp:=trios[i].c1;
        blockwrite(f,i16_tmp,2);
   end;
   close(f);
end;

procedure Timg3d.Draw3dToImg(img:TImg; mode:integer; draw_axes:boolean);
var p1,p2,p3:tvector3; c1,c2,c3,c:Int32; i:integer; xc,yc:integer;
begin
   img.FillRect(0,0,img.width-1,img.height-1,0);
   xc:=img.width div 2; yc:=img.height div 2;
   for i:=0 to n_trios-1 do
   begin
     if (trios[i].p1<n_coords)and(trios[i].p2<n_coords)and(trios[i].p3<n_coords) then
     begin
     p1:=coords[trios[i].p1]; p2:=coords[trios[i].p2]; p3:=coords[trios[i].p3];
     c1:=trios[i].c1; c2:=trios[i].c2; c3:=trios[i].c3;
     c:=RGBtoColor((red(c1)+red(c2)+red(c3))div 3,
                   (green(c1)+green(c2)+green(c3))div 3,
                   (blue(c1)+blue(c2)+blue(c3))div 3);
//     if p3.z>0 then
       begin
       if mode=1 then img.Triangle(xc+trunc(p1.x),yc+trunc(p1.y),
                                   xc+trunc(p2.x),yc+trunc(p2.y),
                                   xc+trunc(p3.x),yc+trunc(p3.y),
                                   c);
       if mode=2 then img.FlatTriangle(xc+trunc(p1.x),yc+trunc(p1.y),
                                       xc+trunc(p2.x),yc+trunc(p2.y),
                                       xc+trunc(p3.x),yc+trunc(p3.y),
                                       c);
       if mode=3 then img.GuroTriangle(xc+trunc(p1.x),yc+trunc(p1.y),
                                       xc+trunc(p2.x),yc+trunc(p2.y),
                                       xc+trunc(p3.x),yc+trunc(p3.y),
                                       c1,c2,c3);

       end;
     end;
   end;
end;

end.

