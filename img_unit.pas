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
//низкоуровневые функций прямого рисования в видеопамяти битмапа
//=====================================================================
unit img_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Clipbrd, LCLintf, LCLtype, utils_unit, arith_complex;

type
//PInt32=^Int32;
TBrez=array[0..4096,1..2] of integer;

TImg=class
  data:array of Int32; //байты изображения
  red_data_DFT,green_data_DFT,blue_data_DFT: TIntegerComplexMatrix; //БПФ-образ изображения
  FixCoords: array of TPoint; //массив вспомогательных опорных точек
  name:string; //текстовое имя изображения
  width,height:integer; //ширина и высота изображения
  dft_width,dft_height:integer; //ширина и высота фурье-образа изображения
  parent_x0,parent_y0:integer; //рекомендуемые координаты рисования на родительском холсте
  constructor create; //конструктор
  destructor done; //деструктор
  procedure SetSize(new_width,new_height:integer); //установка нового размера полотна рисования
  procedure ReSize(new_width,new_height:integer); //установка нового размера полотна рисования с масштабированием картинки
  procedure SetSizeDFT(new_width,new_height:integer); //установка размеров БПФ-матрицы
  procedure DFTclear; //обнуление БПФ-матриц

  function GetPixelAddress(x,y:integer):Integer; //расчет линейного адреса пиксела в img
  function GetPixelByAddress(address:Int32):Int32; //нахождение цвета пиксела по его линейному адресу
  procedure SetPixelByAddress(address:integer; C:Int32); //изменение цвета пиксела по его линейному адресу
  function CalcAverageColor:Int32; //расчет среднего арифметического яркостных характеристик img

  procedure SetPixel(x,y:integer; C:Int32); //изменение цвета пиксела img
  function GetPixel(x,y:integer):Int32; //выяснение цвета пиксела img
  procedure HorLine(xmin,xmax,y:integer; C:Int32); //рисование горизонтального отрезка заданного цвета
  procedure VerLine(x,ymin,ymax:integer; C:Int32); //рисование вертикального отрезка заданного цвета

  procedure CopyRect(img_dst:TImg; rect_src:TRect; rect_dst:TRect); //копирование прямоугольного участка
  procedure DrawToImg(img_dst:TImg; x0_dst,y0_dst:integer); //рисование на другом холсте
  procedure DrawFromImg(img_src:TImg; x0_src,y0_src:integer); //рисование с другого холста
  procedure CloneToImg(img_dst:TImg); //копирование в img_dst (битмапы одинаковые)
  procedure ScaleToImg(img_dst:TImg); //копирование в img_dst с масштабированием
  procedure RotateToImg(src_x0,src_y0,dst_x0,dst_y0:integer; alpha:real; dst_img:TImg); //копирование в img_dst с поворотом

  procedure FillRect(xmin,ymin,xmax,ymax:integer; C:Int32); //заполнение прямоугольника заданным цветом
  procedure clrscr(C:Int32); //очистка содержимого полотна рисования заданным цветом
  procedure FrameRect(xmin,ymin,xmax,ymax:integer; C:Int32); //рисование прямоугольника заданным цветом
  procedure Circle(x0,y0,r:integer; C:Int32); //рисование окружности
  procedure Ellipse(x0,y0,xr,yr:integer; C:Int32); //рисование эллипса
  procedure Line(x1,y1,x2,y2:integer; C:Int32); //рисование отрезка
  procedure FloodFill(x0,y0:integer; c_old,c_new:Int32); //заполнение замкнутой области выбранным цветом
  procedure FloodFillFuzzy(x0,y0:integer; fuzzy_level:integer; c_old,c_new:Int32); //заполнение замкнутой области выбранным цветом
  procedure turtle(x0,y0:integer; S:string); //"черепашья" графика по командам Бейсиковского Draw
  procedure TextOut(x0,y0:integer; PenColor:Int32; TextToRender:string); //вывод текстовой информации
  procedure Triangle(x1,y1,x2,y2,x3,y3:integer; PenColor:Int32); //рисование контура треугольника
  procedure FlatTriangle(x1,y1,x2,y2,x3,y3:integer; BrushColor:Int32); //рисование треугольника, заполненного заданным цветом
  procedure GuroTriangle(x1,y1,x2,y2,x3,y3:integer; C1,C2,C3:Int32); //рисование треугольника, с интерполяцией цвета внутри по модели Гуро

  procedure AffineTransform(img_dst:TImg; x0,y0,dx,dy,a11,a12,a21,a22,a31,a32:real); //аффинное преобразование на плоскости
  procedure MatrixFilter(img_dst:TImg; k11,k12,k13,k21,k22,k23,k31,k32,k33:real); //матричная фильтрация
  procedure ImgToDFT; //расчет БПФ коэффициентов изображения
  procedure DFTtoImg; //восстановление изображения по БПФ коэффициентам

  procedure CloneImgToBitmap(bitmap_dst:TBitmap); //перебрасывание изображения на внешний битмап
  procedure CloneBitmapToImg(bitmap_src:TBitmap); //перебрасывание изображения из внешнего битмапа
  procedure LoadFromFile(filename:string); //загрузка изображения из файла (формат по расширению)
  procedure SaveToFile(filename:string); //сохранение изображения в файл (формат по расширению)
  procedure CopyFromClipboard; //загрузка изображения из буфера обмена
  procedure CopyToClipboard; //сохранение изображения в буфер обмена
end;

implementation

constructor TImg.create;
begin
  parent_x0:=0; parent_y0:=0;
  width:=0; height:=0;
  dft_width:=0; dft_height:=0;
  data:=nil;
  red_data_DFT:=nil; green_data_DFT:=nil; blue_data_DFT:=nil;
  FixCoords:=nil;
end;

destructor TImg.done;
begin
  Finalize(data);
  Finalize(red_data_DFT); Finalize(green_data_DFT); Finalize(blue_data_DFT);
  Finalize(FixCoords);
end;

procedure TImg.SetSize(new_width,new_height:integer);
begin
  if (new_width>0)and(new_height>0) then
  begin
    parent_x0:=0; parent_y0:=0;
    width:=new_width; height:=new_height;
    SetLength(data,width*height);
  end;
end;

procedure TImg.ReSize(new_width,new_height:integer);
var tmp_img:TIMG;
begin
  if (new_width>0)and(new_height>0) then
  begin
    tmp_img:=TIMG.Create;
    tmp_img.SetSize(new_width,new_height);
    ScaleToImg(tmp_img);
    SetSize(new_width,new_height);
    tmp_img.CloneToImg(self);
    tmp_img.done;
  end else done;
end;

procedure TImg.SetSizeDFT(new_width,new_height:integer);
begin
  if (new_width>0)and(new_height>0) then
  begin
    dft_width:=Power2RoundUp(new_width);
    dft_height:=Power2RoundUp(new_height);
    SetLength(red_data_DFT,dft_height,dft_width);
    SetLength(green_data_DFT,dft_height,dft_width);
    SetLength(blue_data_DFT,dft_height,dft_width);
  end;
end;

//расчет линейного адреса пиксела в img
function TIMG.GetPixelAddress(x,y:integer):Integer;
begin GetPixelAddress:=width*y+x; end;

//нахождение цвета пиксела по его линейному адресу
function TIMG.GetPixelByAddress(address:Int32):Int32;
begin GetPixelByAddress:=data[address]; end;

//изменение цвета пиксела по его линейному адресу
procedure TIMG.SetPixelByAddress(address:integer; C:Int32);
begin data[address]:=C; end;

//изменение цвета пиксела
procedure TIMG.SetPixel(x,y:integer; C:Int32);
begin
  if (x>=0)and(y>=0)and(x<width)and(y<height) then data[x+y*width]:=C;
end;

//выяснение цвета пиксела
function TIMG.GetPixel(x,y:integer):Int32;
begin
  if (x>=0)and(y>=0)and(x<width)and(y<height) then
     GetPixel:=data[x+y*width] else GetPixel:=0;
end;

//копирование прямоугольного участка в img_dst
//области копирования-вставки имеют разные размеры
//масштабирование не производится
//если цвет исходного пикселя "-1", то его копирование не производится
procedure TIMG.CopyRect(img_dst:TImg; rect_src,rect_dst:TRect);
var x,y,WW,HH:integer; C:Int32;
begin
  CorrectRectParams(self.width,self.height,rect_src.left,rect_src.top,rect_src.right,rect_src.bottom);
  CorrectRectParams(img_dst.width,img_dst.height,rect_dst.left,rect_dst.top,rect_dst.right,rect_dst.bottom);
  HH:=min(rect_src.bottom-rect_src.top+1,rect_dst.bottom-rect_dst.top+1);
  WW:=min(rect_src.Right-rect_src.Left+1,rect_dst.Right-rect_dst.Left+1);
  for y:=0 to HH-1 do
  for x:=0 to WW-1 do
  begin
     C:=GetPixel(x+rect_src.Left,y+rect_src.Top);
     if C<>-1 then img_dst.SetPixel(x+rect_dst.Left,y+rect_dst.Top,C);
  end;
end;

//рисование битмапа на img_dst
procedure TIMG.DrawToImg(img_dst:TImg; x0_dst,y0_dst:integer);
begin
CopyRect(img_dst,rect(0,0,width-1,height-1),rect(x0_dst,y0_dst,img_dst.width-1,img_dst.height-1));
end;

//рисование битмапа из img_src
procedure TIMG.DrawFromImg(img_src:TImg; x0_src,y0_src:integer);
begin
img_src.CopyRect(self,rect(x0_src,y0_src,img_src.width-1,img_src.height-1),rect(0,0,width-1,height-1));
end;

//быстрое копирование img_src в img_dst (битмапы одинаковые)
procedure TIMG.CloneToIMG(img_dst:TImg);
var i,N:integer; C:int32;
begin
  if (width=img_dst.width)and(height=img_dst.height) then
  begin
    N:=width*height-1;
    for i:=0 to N do
    begin
       C:=data[i];
       if C<>-1 then img_dst.data[i]:=C;
    end;
  end;
end;

//рисование горизонтального отрезка заданного цвета
procedure TIMG.HorLine(xmin,xmax,y:integer; C:Int32);
var x:integer;
begin
   if (y>=0)and(y<height) then
   begin
     if xmin>xmax then swap(xmin,xmax);
     if (xmax>=0)and(xmin<width) then
     begin
       if xmin<0 then xmin:=0;
       if xmax>=width then xmax:=width-1;
       for x:=xmin to xmax do data[x+y*width]:=C;
     end;
   end;
end;

//рисование вертикального отрезка заданного цвета
procedure TIMG.VerLine(x,ymin,ymax:integer; C:Int32);
var y:integer;
begin
   if (x>=0)and(x<width) then
   begin
     if ymin>ymax then swap(ymin,ymax);
     if (ymax>=0)and(ymin<height) then
     begin
       if ymin<0 then ymin:=0;
       if ymax>=height then ymax:=height-1;
       for y:=ymin to ymax do SetPixel(x,y,C);
     end;
   end;
end;

//заполнение прямоугольника заданным цветом
procedure TIMG.FillRect(xmin,ymin,xmax,ymax:integer; C:Int32);
var y:integer;
begin
  CorrectRectParams(width,height,xmin,ymin,xmax,ymax);
  for y:=ymin to ymax do HorLine(xmin,xmax,y,C);
end;

//очистка содержимого полотна рисования заданным цветом
procedure TIMG.clrscr(C:Int32);
begin FillRect(0,0,Width-1,Height-1,C); end;

//рисование прямоугольника заданным цветом
procedure TIMG.FrameRect(xmin,ymin,xmax,ymax:integer; C:Int32);
begin
  HorLine(xmin,xmax,ymin,C);
  HorLine(xmin,xmax,ymax,C);
  VerLine(xmin,ymin,ymax,C);
  VerLine(xmax,ymin,ymax,C);
end;

//аффинное преобразование на плоскости
procedure TIMG.AffineTransform(img_dst:TImg; x0,y0,dx,dy,a11,a12,a21,a22,a31,a32:real);
var C:Int32;
    xnum,ynum,xx,yy:integer;
    x,y, x_new,y_new:real;
begin
  xnum:=trunc(width/dx);
  ynum:=trunc(height/dy);
  for yy:=0 to ynum-1 do
  for xx:=0 to xnum-1 do
  begin
     x:=xx*dx-x0; y:=yy*dy-y0;
     x_new:=x*a11+y*a21+a31+x0;
     y_new:=x*a12+y*a22+a32+y0;
     C:=GetPixel(trunc(x+x0),trunc(y+y0));
     img_dst.SetPixel(trunc(x_new),trunc(y_new),C);
  end;
end;

//расчет среднего арифметического яркостных характеристик холста
function TIMG.CalcAverageColor:Int32;
var i,N:integer; Rs,Gs,Bs:real; C:Int32;
begin
  N:=width*height;
  if N<>0 then
  begin
    Rs:=0; Gs:=0; Bs:=0;
    for i:=0 to N-1 do
    begin
      C:=data[i];
      Rs:=Rs+red(C); Gs:=Gs+green(C); Bs:=Bs+blue(C);
    end;
    CalcAverageColor:=RGBToColor(trunc(Rs/N),trunc(Gs/N),trunc(Bs/N));
  end else CalcAverageColor:=0;
end;

//копирование из img_src в img_dst с масштабированием
procedure TIMG.ScaleToIMG(img_dst:TImg);
var x_src,y_src,x_dst,y_dst:integer; C:Int32;
    kx,ky:real;
begin
  kx:=width/img_dst.width;
  ky:=height/img_dst.height;
  for y_dst:=0 to img_dst.height-1 do
  begin
    y_src:=trunc(y_dst*ky);
    if y_src<height then
    for x_dst:=0 to img_dst.width-1 do
    begin
      x_src:=trunc(x_dst*kx);
      if x_src<width then
      begin
        C:=GetPixel(x_src,y_src);
        img_dst.SetPixel(x_dst,y_dst,C);
      end;
    end;
  end;
end;

//копирование в img_dst с поворотом
procedure TIMG.RotateToImg(src_x0,src_y0,dst_x0,dst_y0:integer; alpha:real; dst_img:TImg);
var x_dst,y_dst,x_src,y_src:integer;
begin
  for y_dst:=0 to dst_img.height-1 do
  for x_dst:=0 to dst_img.width-1 do
  begin
    x_src:=src_x0+trunc((x_dst-dst_x0)*cos(alpha)-(y_dst-dst_y0)*sin(alpha));
    y_src:=src_y0+trunc((x_dst-dst_x0)*sin(alpha)+(y_dst-dst_y0)*cos(alpha));
    if (x_src>=0)and(y_src>=0)and(x_src<width)and(y_src<height) then
        dst_img.SetPixel(x_dst,y_dst,GetPixel(x_src,y_src));
  end;
end;

//матричная фильтрация
procedure TIMG.MatrixFilter(img_dst:TImg; k11,k12,k13,k21,k22,k23,k31,k32,k33:real);
var x,y:integer;
    C11,C12,C13,C21,C22,C23,C31,C32,C33: Int32;
    R11,R12,R13,R21,R22,R23,R31,R32,R33: integer;
    G11,G12,G13,G21,G22,G23,G31,G32,G33: integer;
    B11,B12,B13,B21,B22,B23,B31,B32,B33: integer;
    R,G,B:integer; C:Int32;
begin
  for y:=1 to height-2 do
  for x:=1 to width-2 do
  begin
     C11:=GetPixel(x-1,y-1);
     C12:=GetPixel(x,y-1);
     C13:=GetPixel(x+1,y-1);
     C21:=GetPixel(x-1,y);
     C22:=GetPixel(x,y);
     C23:=GetPixel(x+1,y);
     C31:=GetPixel(x-1,y+1);
     C32:=GetPixel(x,y+1);
     C33:=GetPixel(x+1,y+1);

     R11:=red(C11); G11:=green(C11); B11:=blue(C11);
     R12:=red(C12); G12:=green(C12); B12:=blue(C12);
     R13:=red(C13); G13:=green(C13); B13:=blue(C13);
     R21:=red(C21); G21:=green(C21); B21:=blue(C21);
     R22:=red(C22); G22:=green(C22); B22:=blue(C22);
     R23:=red(C23); G23:=green(C23); B23:=blue(C23);
     R31:=red(C31); G31:=green(C31); B31:=blue(C31);
     R32:=red(C32); G32:=green(C32); B32:=blue(C32);
     R33:=red(C33); G33:=green(C33); B33:=blue(C33);

     B:=trunc(B11*k11+B12*k12+B13*k13+B21*k21+B22*k22+B23*k23+B31*k31+B32*k32+B33*k33);
     if B<0 then B:=0; if B>255 then B:=255;
     G:=trunc(G11*k11+G12*k12+G13*k13+G21*k21+G22*k22+G23*k23+G31*k31+G32*k32+G33*k33);
     if G<0 then G:=0; if G>255 then G:=255;
     R:=trunc(R11*k11+R12*k12+R13*k13+R21*k21+R22*k22+R23*k23+R31*k31+R32*k32+R33*k33);
     if R<0 then R:=0; if R>255 then R:=255;
     C:=RGBToCOlor(R,G,B);
     img_dst.SetPixel(x,y,C);
  end;
  for x:=0 to width-1 do
  begin
     C:=GetPixel(x,0); img_dst.SetPixel(x,0,C);
     C:=GetPixel(x,height-1); img_dst.SetPixel(x,height-1,C);
  end;
  for y:=0 to height-1 do
  begin
     C:=GetPixel(0,y); img_dst.SetPixel(0,y,C);
     C:=GetPixel(width-1,y); img_dst.SetPixel(width-1,y,C);
  end;
end;

//алгоритм Брезенхема расчета координат точек окружности
function BrezCircle(xc,yc,r:integer; var Brez:TBrez):integer;
var xf,yf,PixelsNum,x1,y1,x2,y2,d1,d2,dx,dy,i:integer;
begin
  i:=1; Brez[i,1]:=xc-r; Brez[i,2]:=yc;
  inc(i); Brez[i,1]:=xc+r; Brez[i,2]:=yc;
  inc(i); Brez[i,1]:=xc; Brez[i,2]:=yc-r;
  inc(i); Brez[i,1]:=xc; Brez[i,2]:=yc+r;
  xf:=xc+r;
  yf:=yc;
  for PixelsNum:=0 to ((3*r) div 4) do
  begin
      x1:=xf-1; x2:=xf;
      y1:=yf-1; y2:=yf-1;

      d1:=(xc-x1)*(xc-x1)+(yc-y1)*(yc-y1)-r*r;
      d2:=(xc-x2)*(xc-x2)+(yc-y2)*(yc-y2)-r*r;

      if (d1<0) then d1:=-d1;
      if (d2<0) then d2:=-d2;

      if (d1<d2) then begin xf:=x1; yf:=y1; end else begin xf:=x2; yf:=y2; end;
      dx:=xf-xc; dy:=yf-yc;

      inc(i); Brez[i,1]:=xc+dx; Brez[i,2]:=yc+dy;
      inc(i); Brez[i,1]:=xc-dx; Brez[i,2]:=yc+dy;
      inc(i); Brez[i,1]:=xc+dx; Brez[i,2]:=yc-dy;
      inc(i); Brez[i,1]:=xc-dx; Brez[i,2]:=yc-dy;
      inc(i); Brez[i,1]:=xc+dy; Brez[i,2]:=yc+dx;
      inc(i); Brez[i,1]:=xc-dy; Brez[i,2]:=yc+dx;
      inc(i); Brez[i,1]:=xc+dy; Brez[i,2]:=yc-dx;
      inc(i); Brez[i,1]:=xc-dy; Brez[i,2]:=yc-dx;
  end;
  BrezCircle:=i;
end;

procedure TIMG.circle(x0,y0,r:integer; C:Int32);
var Brez:TBrez;
    i,np:Integer;
begin
     np:=BrezCircle(x0,y0,r,Brez);
     for i:=1 to np do SetPixel(Brez[i,1],Brez[i,2],C);
end;

//рисование эллипса на img
procedure TIMG.Ellipse(x0,y0,xr,yr:integer; C:Int32);
var tt,xx,yy:integer; t:real;
begin
  for tt:=0 to 628 do
  begin
     t:=tt/100;
     xx:=trunc(x0+xr*cos(t));
     yy:=trunc(y0+yr*sin(t));
     SetPixel(xx,yy,C);
  end;
end;

//алгоритм Брезенхема расчета координат точек отрезка
function BrezLine(x1,y1,x2,y2:integer; var Brez:TBrez):integer;
var dx,dy,ix,iy,x,y,i,j,PlotX,PlotY,Hinc:integer;
    Plot:Boolean;
begin
     dx:=x2-x1; dy:=y2-y1;
     ix:=abs(dx); iy:=abs(dy);
     if ix>iy then Hinc:=ix else Hinc:=iy;
     PlotX:=x1; Ploty:=y1; x:=0; y:=0;
     i:=1; Brez[i,1]:=PlotX; Brez[i,2]:=PlotY;
     for j:=0 to Hinc do
         begin
              x:=x+ix; y:=y+iy; Plot:=false;
              if x>Hinc then
                 begin
                      Plot:=true; x:=x-Hinc;
                      if dx>0 then inc(PlotX);
                      if dx<0 then dec(PlotX);
                 end;
              if y>Hinc then
                 begin
                      Plot:=true; y:=y-Hinc;
                      if dy>0 then inc(PlotY);
                      if dy<0 then dec(PlotY);
                 end;
              if Plot then
                 begin
                      inc(i); Brez[i,1]:=PlotX; Brez[i,2]:=PlotY;
                 end;
         end;
     BrezLine:=i;
end;

//рисование отрезка на img
procedure TIMG.Line(x1,y1,x2,y2:integer; C:Int32);
var i,np: integer; Brez:TBrez;
begin
  if y1=y2 then HorLine(x1,x2,y1,C)
  else if x1=x2 then VerLine(x1,y1,y2,C)
  else
  begin
    np:=BrezLine(x1,y1,x2,y2,Brez);
    for i:=1 to np do SetPixel(Brez[i,1],Brez[i,2],C);
  end;
end;

//заполнение замкнутой области выбранным цветом ("хороший способ")
procedure TIMG.FloodFill(x0,y0:integer; c_old,c_new:Int32);
var c:Int32; x,xmin,xmax:integer;
begin
  if (x0>=0)and(x0<width)and(y0>=0)and(y0<height) then
  begin
    c:=GetPixel(x0,y0);
    if (c>=0)and(c<>c_new)and(c=c_old) then
    begin
      xmin:=x0;
      repeat
        c:=GetPixel(xmin,y0);
        xmin:=xmin-1;
      until (c<0)or(c=c_new)or(c<>c_old)or(xmin<0);
      xmin:=xmin+1;
      xmax:=x0;
      repeat
        c:=GetPixel(xmax,y0);
        xmax:=xmax+1;
      until (c<0)or(c=c_new)or(c<>c_old)or(xmax>=width);
      xmax:=xmax-1;
      HorLine(xmin,xmax,y0,c_new);
      for x:=xmin to xmax do FloodFill(x,y0-1,c_old,c_new);
      for x:=xmin to xmax do FloodFill(x,y0+1,c_old,c_new);
    end;
  end;
end;


//заполнение замкнутой области выбранным цветом (с учетом контрастности границы)
procedure TIMG.FloodFillFuzzy(x0,y0:integer; fuzzy_level:integer; c_old,c_new:Int32);
var c:Int32; x,xmin,xmax:integer;
begin
  if (x0>=0)and(x0<width)and(y0>=0)and(y0<height) then
  begin
    c:=GetPixel(x0,y0);
    if (c>=0)and(c<>c_new)and
       (abs((red(c)+green(c)+blue(c))/3-(red(c_old)+green(c_old)+blue(c_old))/3)<=fuzzy_level)
       then
    begin
      xmin:=x0;
      repeat
        c:=GetPixel(xmin,y0);
        xmin:=xmin-1;
      until (c<0)or(c=c_new)or(xmin<0)or(abs((red(c)+green(c)+blue(c))/3-(red(c_old)+green(c_old)+blue(c_old))/3)>fuzzy_level);
      xmin:=xmin+1;
      xmax:=x0;
      repeat
        c:=GetPixel(xmax,y0);
        xmax:=xmax+1;
      until (c<0)or(c=c_new)or(xmax>=width)or(abs((red(c)+green(c)+blue(c))/3-(red(c_old)+green(c_old)+blue(c_old))/3)>fuzzy_level);
      xmax:=xmax-1;
      HorLine(xmin,xmax,y0,c_new);
      for x:=xmin to xmax do FloodFillFuzzy(x,y0-1,fuzzy_level,c_old,c_new);
      for x:=xmin to xmax do FloodFillFuzzy(x,y0+1,fuzzy_level,c_old,c_new);
    end;
  end;
end;

//рисование контура треугольника
procedure TIMG.Triangle(x1,y1,x2,y2,x3,y3:integer; PenColor:Int32);
begin
     Line(x1,y1,x2,y2,PenColor);
     Line(x2,y2,x3,y3,PenColor);
     Line(x3,y3,x1,y1,PenColor);
end;

//интерполяция цвета внутри горизонтального отрезка
Procedure Gradient(x1,c1,x2,c2:integer; var GrLine: TBrez);
var np1,i,j:integer; line1:TBrez;
begin
     np1:=BrezLine(x1,c1,x2,c2,line1);
     GrLine[1]:=line1[1];
     j:=1;
     for i:=2 to np1 do
         if line1[i,1]<>line1[i-1,1] then
            begin
                 inc(j); GrLine[j]:=line1[i];
            end;
end;

//рисование треугольника, заполненного заданным цветом
procedure TIMG.FlatTriangle(x1,y1,x2,y2,x3,y3:integer; BrushColor:Int32);
var line1,line2,line3: TBrez;
    y:integer;
begin
  if y1>y2 then begin swap(x1,x2); swap(y1,y2); end;
  if y1>y3 then begin swap(x1,x3); swap(y1,y3); end;
  if y2>y3 then begin swap(x2,x3); swap(y2,y3); end;

  Gradient(y1,x1,y2,x2,line1);
  Gradient(y2,x2,y3,x3,line2);
  Gradient(y1,x1,y3,x3,line3);

  for y:=y1 to y2 do Line(line1[y-y1+1,2],y,line3[y-y1+1,2],y,BrushColor);
  for y:=y2 to y3 do Line(line2[y-y2+1,2],y,line3[y-y1+1,2],y,BrushColor);
end;

//рисование треугольника, с интерполяцией цвета внутри по модели Гуро
procedure TIMG.GuroTriangle(x1,y1,x2,y2,x3,y3:integer; C1,C2,C3:Int32);
var line1,line2,line3: TBrez;
    GradR1,GradG1,GradB1,
    GradR2,GradG2,GradB2,
    GradR3,GradG3,GradB3,
    GrLineR,GrLineG,GrLineB: TBrez;
    x,y,h,h1:integer;
    r1,r2,r3,g1,g2,g3,b1,b2,b3, c1r,c1g,c1b,c2r,c2g,c2b:integer;
begin
  if y1>y2 then begin swap(x1,x2); swap(y1,y2); swap(c1,c2); end;
  if y1>y3 then begin swap(x1,x3); swap(y1,y3); swap(c1,c3); end;
  if y2>y3 then begin swap(x2,x3); swap(y2,y3); swap(c2,c3); end;

  Gradient(y1,x1,y2,x2,line1);
  Gradient(y2,x2,y3,x3,line2);
  Gradient(y1,x1,y3,x3,line3);

  r1:=red(c1); g1:=green(c1); b1:=blue(c1);
  r2:=red(c2); g2:=green(c2); b2:=blue(c2);
  r3:=red(c3); g3:=green(c3); b3:=blue(c3);

  Gradient(y1,r1,y2,r2,GradR1);
  Gradient(y2,r2,y3,r3,GradR2);
  Gradient(y1,r1,y3,r3,GradR3);

  Gradient(y1,g1,y2,g2,GradG1);
  Gradient(y2,g2,y3,g3,GradG2);
  Gradient(y1,g1,y3,g3,GradG3);

  Gradient(y1,b1,y2,b2,GradB1);
  Gradient(y2,b2,y3,b3,GradB2);
  Gradient(y1,b1,y3,b3,GradB3);

  h:=0;
  for y:=y1 to y2 do
      begin
           inc(h);
           x1:=line3[h,2]; x2:=line1[h,2];

           c1r:=GradR3[h,2]; c2r:=GradR1[h,2];
           c1g:=GradG3[h,2]; c2g:=GradG1[h,2];
           c1b:=GradB3[h,2]; c2b:=GradB1[h,2];
           if x1>x2 then begin
             swap(x1,x2);
             swap(c1r,c2r); swap(c1g,c2g); swap(c1b,c2b);
           end;
           Gradient(x1,c1r,x2,c2r,GrLineR);
           Gradient(x1,c1g,x2,c2g,GrLineG);
           Gradient(x1,c1b,x2,c2b,GrLineB);
           for x:=x1 to x2 do
             SetPixel(x,y,RGBtoColor(GrLineR[x-x1+1,2],GrLineG[x-x1+1,2],GrLineB[x-x1+1,2]));
      end;
  h1:=0;
  for y:=y2 to y3-1 do
      begin
           inc(h); inc(h1);
           x1:=line3[h,2]; x2:=line2[h1,2];
           c1r:=GradR3[h,2]; c2r:=GradR2[h1,2];
           c1g:=GradG3[h,2]; c2g:=GradG2[h1,2];
           c1b:=GradB3[h,2]; c2b:=GradB2[h1,2];
           if x1>x2 then begin
             swap(x1,x2);
             swap(c1r,c2r); swap(c1g,c2g); swap(c1b,c2b);
           end;
           Gradient(x1,c1r,x2,c2r,GrLineR);
           Gradient(x1,c1g,x2,c2g,GrLineG);
           Gradient(x1,c1b,x2,c2b,GrLineB);
           for x:=x1 to x2 do
             SetPixel(x,y,RGBtoColor(GrLineR[x-x1+1,2],GrLineG[x-x1+1,2],GrLineB[x-x1+1,2]));
      end;
  SetPixel(x3,y3,c3);
end;

//"черепашья" графика по командам Бейсиковского Draw
procedure TIMG.turtle(x0,y0:integer; S:string);
begin
  //заглушка
end;

//Вывод текстовой информации
//рисуем текст через инструменты Bitmap.Canvas (исправить)
procedure TIMG.TextOut(x0,y0:integer; PenColor:Int32; TextToRender:string);
var tmp_bitmap:TBitmap; tmp_img:TIMG;
begin
  tmp_bitmap:=TBitmap.Create;
  tmp_bitmap.SetSize(tmp_bitmap.Canvas.TextWidth(TextToRender),
                     tmp_bitmap.Canvas.TextHeight(TextToRender));
  tmp_bitmap.Canvas.Font.Color:=PenColor;
  tmp_bitmap.Canvas.Brush.Style:=bsClear;
  tmp_bitmap.Canvas.TextOut(0,0,TextToRender);
  tmp_img:=TIMG.Create;
  tmp_img.SetSize(tmp_bitmap.width,tmp_bitmap.height);
  tmp_img.clrscr(-1);
  tmp_IMG.CloneBitmapToImg(tmp_bitmap);
  tmp_IMG.DrawToIMG(self,x0,y0);
  tmp_bitmap.free;
  tmp_img.done;
end;

//перебрасывание изображения из TImg на внешний битмап
procedure TIMG.CloneImgToBitmap(bitmap_dst:TBitmap);
var x,y,dst_bpp:integer; src_ptr: PInt32; dst_ptr:PByte; R,G,B:byte;
begin
  if (width=bitmap_dst.width)and(height=bitmap_dst.height) then
  begin
    bitmap_dst.BeginUpdate(false);
    dst_bpp:=bitmap_dst.RawImage.Description.BitsPerPixel div 8;
    dst_ptr:=bitmap_dst.RawImage.Data;
    src_ptr:=PInt32(data);
    for y:=0 to height-1 do
    for x:=0 to width-1 do
    begin
       R:=(src_ptr^)and 255;
       G:=((src_ptr^)>>8)and 255;
       B:=((src_ptr^)>>16)and 255;
       dst_ptr^:=B; (dst_ptr+1)^:=G; (dst_ptr+2)^:=R;
      inc(dst_ptr,dst_bpp); inc(src_ptr);
    end;
    bitmap_dst.EndUpdate(false);
  end;
end;

//перебрасывание изображения из внешнего битмапа на TImg
procedure TIMG.CloneBitmapToImg(bitmap_src:TBitmap);
var x,y,src_bpp:integer; dst_ptr: PInt32; Src_ptr:PByte; R,G,B:byte;
begin
  if (width=bitmap_src.width)and(height=bitmap_src.height) then
  begin
    src_ptr:=bitmap_src.RawImage.Data;
    src_bpp:=bitmap_src.RawImage.Description.BitsPerPixel div 8;
    dst_ptr:=PInt32(data);
    for y:=0 to height-1 do
    for x:=0 to width-1 do
    begin
      R:=(src_ptr+2)^; G:=(src_ptr+1)^; B:=src_ptr^;
      dst_ptr^:=R+(G<<8)+(B<<16);
      inc(dst_ptr); inc(src_ptr,src_bpp);
    end;
  end;
end;

//загрузка изображения из файла (формат по расширению)
procedure TIMG.LoadFromFile(filename:string);
var tmp_picture: TPicture;
begin
  tmp_picture:=TPicture.Create;
  tmp_picture.LoadFromFile(filename);
  SetSize(tmp_picture.width,tmp_picture.height);
  CloneBitmapToImg(tmp_picture.Bitmap);
  tmp_picture.Free;
end;

//сохранение изображения в файл (формат по расширению)
procedure TIMG.SaveToFile(filename:string);
var tmp_picture:TPicture;
begin
  tmp_picture:=TPicture.Create;
  tmp_picture.bitmap.setsize(Width,Height);
  CloneImgToBitmap(tmp_picture.Bitmap);
  tmp_picture.SaveToFile(filename);
  tmp_picture.free;
end;

//загрузка изображения из буфера обмена
procedure TIMG.CopyFromClipboard;
var tmp_bitmap:TBitmap; tmp_IMG:TIMG; tmp_x0,tmp_y0:integer;
begin
  tmp_bitmap:=TBitmap.Create;
  if Clipboard.HasFormat(PredefinedClipboardFormat(pcfDelphiBitmap)) then
     tmp_bitmap.LoadFromClipboardFormat(PredefinedClipboardFormat(pcfDelphiBitmap));
  if Clipboard.HasFormat(PredefinedClipboardFormat(pcfBitmap)) then
     tmp_bitmap.LoadFromClipboardFormat(PredefinedClipboardFormat(pcfBitmap));
  tmp_x0:=parent_x0; tmp_y0:=parent_y0;
  SetSize(tmp_bitmap.width,tmp_bitmap.height);
  parent_x0:=tmp_x0; parent_y0:=tmp_y0;
  CloneBitmapToImg(tmp_bitmap);
  tmp_bitmap.free;
end;

//сохранение изображения в буфер обмена
procedure TIMG.CopyToClipboard;
var tmp_bitmap:TBitmap;
begin
  tmp_bitmap:=TBitmap.Create;
  tmp_bitmap.SetSize(width,height);
  CloneImgToBitmap(tmp_bitmap);
  Clipboard.assign(tmp_bitmap);
  tmp_bitmap.free;
end;

//расчет БПФ коэффициентов изображения
//перед расчетом изображение масштабируется под размеры ДПФ-матрицы
procedure TIMG.ImgToDFT;
var dft_tmp_t,dft_tmp_f:TComplexMatrix;
    x,y:integer; tmp_img:TIMG;
begin
  //масштабируем входное изображение под размеры БПФ-матрицы
  tmp_img:=TIMG.Create;
  tmp_img.SetSize(dft_width,dft_height);
  ScaleToImg(tmp_img);
  //выделяем память под промежуточные массивы комплексного переменного
  SetLength(dft_tmp_t,dft_height,dft_width);
  SetLength(dft_tmp_f,dft_height,dft_width);
  //красный канал
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    dft_tmp_t[y,x].re:=red(tmp_img.GetPixel(x,y));
    dft_tmp_t[y,x].im:=0;
  end;
  DFT_analys_2D(DFT_tmp_t,DFT_tmp_f);
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    red_data_DFT[y,x].re:=trunc(dft_tmp_f[y,x].re);
    red_data_DFT[y,x].im:=trunc(dft_tmp_f[y,x].im);
  end;
  //зеленый канал
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    dft_tmp_t[y,x].re:=green(tmp_img.GetPixel(x,y));
    dft_tmp_t[y,x].im:=0;
  end;
  DFT_analys_2D(DFT_tmp_t,DFT_tmp_f);
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    green_data_DFT[y,x].re:=trunc(dft_tmp_f[y,x].re);
    green_data_DFT[y,x].im:=trunc(dft_tmp_f[y,x].im);
  end;
  //синий канал
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    dft_tmp_t[y,x].re:=blue(tmp_img.GetPixel(x,y));
    dft_tmp_t[y,x].im:=0;
  end;
  DFT_analys_2D(DFT_tmp_t,DFT_tmp_f);
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    blue_data_DFT[y,x].re:=trunc(dft_tmp_f[y,x].re);
    blue_data_DFT[y,x].im:=trunc(dft_tmp_f[y,x].im);
  end;
  //высвобождаем память
  SetLength(dft_tmp_t,0,0);
  SetLength(dft_tmp_f,0,0);
end;

//восстановление изображения по БПФ коэффициентам
//после восстановления по размерам БПФ-матрицы
//изображение масштабируется к размерам класса
procedure TIMG.DFTtoImg;
var red_dft_tmp_t,green_dft_tmp_t,blue_dft_tmp_t,
    red_dft_tmp_f,green_dft_tmp_f,blue_dft_tmp_f:TComplexMatrix;
    x,y:integer; tmp_img:TIMG;
begin
  tmp_img:=TIMG.Create;
  tmp_img.SetSize(dft_width,dft_height);
  //выделяем память под промежуточные массивы комплексного переменного
  SetLength(red_dft_tmp_t,dft_height,dft_width);
  SetLength(green_dft_tmp_t,dft_height,dft_width);
  SetLength(blue_dft_tmp_t,dft_height,dft_width);
  SetLength(red_dft_tmp_f,dft_height,dft_width);
  SetLength(green_dft_tmp_f,dft_height,dft_width);
  SetLength(blue_dft_tmp_f,dft_height,dft_width);
  //переносим коэффициенты из целочисленных массивов класса в комплексные библиотеки
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    //красный канал
    red_dft_tmp_f[y,x].re:=red_data_DFT[y,x].re;
    red_dft_tmp_f[y,x].im:=red_data_DFT[y,x].im;
    //зеленый канал
    green_dft_tmp_f[y,x].re:=green_data_DFT[y,x].re;
    green_dft_tmp_f[y,x].im:=green_data_DFT[y,x].im;
    //синий канал
    blue_dft_tmp_f[y,x].re:=blue_data_DFT[y,x].re;
    blue_dft_tmp_f[y,x].im:=blue_data_DFT[y,x].im;
  end;
  DFT_syntez_2D(dft_width,dft_height,red_DFT_tmp_f,red_DFT_tmp_t);
  DFT_syntez_2D(dft_width,dft_height,green_DFT_tmp_f,green_DFT_tmp_t);
  DFT_syntez_2D(dft_width,dft_height,blue_DFT_tmp_f,blue_DFT_tmp_t);
  //переводим комплексные коэффициенты в цвет
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
    tmp_img.SetPixel(x,y,RGBToColor(
                                    trunc(red_dft_tmp_t[y,x].re),
                                    trunc(green_dft_tmp_t[y,x].re),
                                    trunc(blue_dft_tmp_t[y,x].re)));
  //масштабируем вышедшее из БПФ изображение
  tmp_img.ScaleToImg(self);
  //высвобождаем память
  SetLength(red_dft_tmp_t,0,0);
  SetLength(green_dft_tmp_t,0,0);
  SetLength(blue_dft_tmp_t,0,0);
  SetLength(red_dft_tmp_f,0,0);
  SetLength(green_dft_tmp_f,0,0);
  SetLength(blue_dft_tmp_f,0,0);
end;

//обнуление БПФ-матриц
procedure TIMG.DFTclear;
var y,x:integer;
begin
  for y:=0 to dft_height-1 do
  for x:=0 to dft_width-1 do
  begin
    red_data_dft[y,x].re:=0; red_data_dft[y,x].im:=0;
    green_data_dft[y,x].re:=0; green_data_dft[y,x].im:=0;
    blue_data_dft[y,x].re:=0; blue_data_dft[y,x].im:=0;
  end;
end;

//=====================================================================
//конец низкоуровневых функций прямого рисования в видеопамяти битмапа
//=====================================================================

end.

