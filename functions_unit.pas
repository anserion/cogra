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

unit functions_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, img_unit, utils_unit, arith_complex;

//рисование явно заданной функции
procedure DrawFunction(img:TImg; xmin,xmax:real; C:Int32);
//рисование неявно заданной функции
procedure DrawFFunction(img:TImg; xmin,xmax,ymin,ymax,epsilon:real; C:Int32);
//рисование параметрически заданной функции
procedure DrawTFunction(img:TImg; tmin,tmax,dt:real; C:Int32);
//рисование комплексной функции комплексного аргумента оттенками серого
procedure DrawCFunction(img_re,img_im:TImg; z_min,z_max:TComplex);
//рисование фрактала Жюлиа
procedure DrawFractalJulia(img:TIMG; z_min,z_max,c:TComplex; n:integer);
//рисование фрактала Мандельброта
procedure DrawFractalMandelbrot(img:TIMG; z_min,z_max:TComplex; n:integer);

implementation

//явно заданная функция для рисования
function f(x:real):real;
begin
     if x<>0 then f:=sin(x)/x else f:=1;
end;

//неявно заданная функция для рисования
function ff(x,y:real):real;
begin
  ff:=x*x/400-y*y/900-1;
end;

//параметрически заданная функция для рисования
procedure ft(t:real; var x,y:real);
begin
  x:=sin(2*t);
  y:=cos(3*t);
end;

//комплексная функция комплексного аргумента для рисования
function fc(z:TComplex):TComplex;
var res1,res2:TComplex;
begin
  c_sqrt(z,res1,res2); fc:=res1;
  //fc:=c_exp(z);
end;

//рисование параметрически заданной функции
procedure DrawTFunction(img:TImg; tmin,tmax,dt:real; C:Int32);
var t,x,y,xmin,xmax,ymin,ymax,xPerPixel,yPerPixel:real;
    tt,xx,yy,xx0,yy0,tnum:integer;
begin
  ft(tmin,xmin,ymin); xmax:=xmin; ymax:=ymin;
  tnum:=trunc((tmax-tmin)/dt);
  for tt:=0 to tnum do
  begin
     t:=tmin+tt*dt;
     ft(t,x,y);
     if x<xmin then xmin:=x;
     if x>xmax then xmax:=x;
     if y<ymin then ymin:=y;
     if y>ymax then ymax:=y;
  end;
  if xmax<>xmin then xPerPixel:=img.width/(xmax-xmin) else xPerPixel:=0;
  if ymax<>ymin then yPerPixel:=img.Height/(ymax-ymin) else yPerPixel:=0;

  ft(tmin,x,y);
  xx0:=trunc(xPerPixel*(x-xmin));
  yy0:=trunc(img.height-yPerPixel*(y-ymin));
  for tt:=0 to tnum do
  begin
       t:=tmin+tt*dt;
       ft(t,x,y);
       xx:=trunc(xPerPixel*(x-xmin));
       yy:=trunc(img.height-yPerPixel*(y-ymin));
       img.Line(xx0,yy0,xx,yy,C);
       xx0:=xx; yy0:=yy;
  end;
end;

//рисование неявно заданной функции
procedure DrawFFunction(img:TImg; xmin,xmax,ymin,ymax,epsilon:real; C:Int32);
var x,y,xPerPixel,yPerPixel:real;
    xx,yy:integer;
begin
  xPerPixel:=(xmax-xmin)/img.width;
  yPerPixel:=(ymax-ymin)/img.height;
  for yy:=0 to img.Height-1 do
  for xx:=0 to img.Width-1 do
  begin
     x:=xx*xPerPixel+xmin;
     y:=yy*yPerPixel+ymin;
     if abs(ff(x,y))<=epsilon then img.SetPixel(xx,yy,C);
  end;
end;

//рисование явно заданной функции
procedure DrawFunction(img:TImg; xmin,xmax:real; C:Int32);
var x,y,ymin,ymax,xPerPixel,yPerPixel:real;
    xx0,yy0,xx,yy:integer;
begin
     xPerPixel:=(xmax-xmin)/img.width;
     ymin:=f(xmin); ymax:=f(xmax);
     for xx:=0 to img.width-1 do
     begin
        x:=xx*xPerPixel+xmin;
        y:=f(x);
        if y<ymin then ymin:=y;
        if y>ymax then ymax:=y;
     end;
     if ymax<>ymin then yPerPixel:=img.Height/(ymax-ymin) else yPerPixel:=0;

     xx0:=0;
     yy0:=trunc(img.height-yPerPixel*(f(xmin)-ymin));
     for xx:=0 to img.width-1 do
     begin
          x:=xx*xPerPixel+xmin;
          yy:=trunc(img.height-yPerPixel*(f(x)-ymin));
          img.Line(xx0,yy0,xx,yy,C);
          xx0:=xx; yy0:=yy;
     end;
end;

//рисование комплексной функции комплексного аргумента
procedure DrawCFunction(img_re,img_im:TImg; z_min,z_max:TComplex);
var xmin,ymin,xmax,ymax,xPerPixel,yPerPixel:real;
    xx,yy:integer;
    z,f:TComplex;
    re_min,re_max,im_min,im_max, re_DeltaC,im_DeltaC:real;
    Re_C,Im_C:Int32;
begin
  xmin:=z_min.re; ymin:=z_min.im;
  xmax:=z_max.re; ymax:=z_max.im;
  if xmin>xmax then swap(xmin,xmax);
  if ymin>ymax then swap(ymin,ymax);
  //рисуем действительную часть результата
  xPerPixel:=(xmax-xmin)/img_re.width;
  yPerPixel:=(ymax-ymin)/img_re.height;
  f:=fc(z_min);
  re_min:=f.re; re_max:=re_min;
  for yy:=0 to img_re.Height-1 do
  for xx:=0 to img_re.Width-1 do
  begin
     z.re:=xx*xPerPixel+xmin;
     z.im:=yy*yPerPixel+ymin;
     f:=fc(z);
     if f.re<re_min then re_min:=f.re;
     if f.re>re_max then re_max:=f.re;
  end;
  if re_max<>re_min then re_DeltaC:=255/(re_max-re_min) else re_DeltaC:=0;
  for yy:=0 to img_re.Height-1 do
  for xx:=0 to img_re.Width-1 do
  begin
     z.re:=xx*xPerPixel+xmin;
     z.im:=yy*yPerPixel+ymin;
     f:=fc(z);
     re_C:=trunc(re_DeltaC*(re_min+f.re));
     img_re.SetPixel(xx,yy,RGBToColor(re_C,Re_C,Re_C));
  end;
  //рисуем мнимую часть результата
  xPerPixel:=(xmax-xmin)/img_im.width;
  yPerPixel:=(ymax-ymin)/img_im.height;
  f:=fc(z_min);
  im_min:=f.im; im_max:=im_min;
  for yy:=0 to img_im.Height-1 do
  for xx:=0 to img_im.Width-1 do
  begin
     z.re:=xx*xPerPixel+xmin;
     z.im:=yy*yPerPixel+ymin;
     f:=fc(z);
     if f.im<im_min then im_min:=f.im;
     if f.im>im_max then im_max:=f.im;
  end;
  if im_max<>im_min then im_DeltaC:=255/(im_max-im_min) else im_DeltaC:=0;
  for yy:=0 to img_im.Height-1 do
  for xx:=0 to img_im.Width-1 do
  begin
     z.re:=xx*xPerPixel+xmin;
     z.im:=yy*yPerPixel+ymin;
     f:=fc(z);
     im_C:=trunc(im_DeltaC*(im_min+f.im));
     img_im.SetPixel(xx,yy,RGBToColor(im_C,im_C,im_C));
  end;
end;

//рисование фрактала Жюлиа
procedure DrawFractalJulia(img:TIMG; z_min,z_max,c:TComplex; n:integer);
var dx,dy,r:real; x,y,i,i_max:integer; z,z1:TComplex; color:Int32;
begin
  dx:=(z_max.re-z_min.re)/img.width;
  dy:=(z_max.im-z_min.im)/img.height;
  i_max:=0;
  for y:=0 to img.height-1 do
    for x:=0 to img.width-1 do
    begin
       color:=0; i:=0;
       z1.re:=x*dx+z_min.re; z1.im:=y*dy+z_min.im;
       r:=c_amp(z1);
       while (r<2)and(i<n) do
       begin
         z:=z1; i:=i+1;
         z1:=c_add(c_sqr(z),c);
         r:=c_amp(z1);
       end;
       if i>i_max then i_max:=i;
    end;

  for y:=0 to img.height-1 do
    for x:=0 to img.width-1 do
    begin
       color:=0; i:=1;
       z1.re:=x*dx+z_min.re; z1.im:=y*dy+z_min.im;
       r:=c_amp(z1);
       while (r<2)and(i<=n) do
       begin
         z:=z1; i:=i+1;
         z1:=c_add(c_sqr(z),c);
         r:=c_amp(z1);
       end;
       color:=RGBToColor(trunc(255*i/i_max),trunc(255*i/i_max),trunc(255*i/i_max));
       img.SetPixel(x,y,color);
    end;
end;

//рисование фрактала Мандельброта
procedure DrawFractalMandelbrot(img:TIMG; z_min,z_max:TComplex; n:integer);
var dx,dy,r:real; x,y,i,i_max:integer; z,c,z1:TComplex; color:Int32;
begin
  dx:=(z_max.re-z_min.re)/img.width;
  dy:=(z_max.im-z_min.im)/img.height;
  i_max:=0;
  for y:=0 to img.height-1 do
    for x:=0 to img.width-1 do
    begin
       color:=0; i:=0;
       c.re:=x*dx+z_min.re; c.im:=y*dy+z_min.im;
       z1.re:=0; z1.im:=0; r:=0;
       while (r<2)and(i<n) do
       begin
         z:=z1; i:=i+1;
         z1:=c_add(c_sqr(z),c);
         r:=c_amp(z1);
       end;
       if i>i_max then i_max:=i;
    end;

  for y:=0 to img.height-1 do
    for x:=0 to img.width-1 do
    begin
       color:=0; i:=1;
       c.re:=x*dx+z_min.re; c.im:=y*dy+z_min.im;
       z1.re:=0; z1.im:=0; r:=0;
       while (r<2)and(i<=n) do
       begin
         z:=z1; i:=i+1;
         z1:=c_add(c_sqr(z),c);
         r:=c_amp(z1);
       end;
       color:=RGBToColor(trunc(255*i/i_max),trunc(255*i/i_max),trunc(255*i/i_max));
       img.SetPixel(x,y,color);
    end;
end;

end.

