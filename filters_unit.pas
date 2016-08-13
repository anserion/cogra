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
//подпрограммы цифровой фильтрации растровых изображений
//=====================================================================
unit filters_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Graphics, utils_unit, globals_unit, img_unit, colors_unit,
  arith_complex;

//матричная фильтрация по заданным глобальным коэффициентам
procedure FilterMatrix(img:Timg);
//фильтр наложения нескольких изображений друг на друга с учетом полупрозрачностей
procedure FilterCompose(dst_img:TIMG; src_img:array of TIMG; transparency:array of real);
//регулировка яркости (k-коэффициент усиления/ослабления k=1 - исходная яркость)
procedure FilterBrightness(img:Timg; k:real);
//регулировка контрастности (k-коэффициент усиления/ослабления k=1 - исходная)
procedure FilterContrast(img:Timg; k:real);
//преобразование цветного изображения в градации серого
procedure FilterDesaturation(img:Timg);
//преобразование цветного изображение в черно-белое
//k - порог обесцвечивания (от 0 до 1)
procedure FilterThresold(img:Timg; k:real);
//фильтр размытия
procedure FilterBlur(img:TIMG);
//фильтр выделения контуров
procedure FilterContour(img:TIMG);
//фильтр повышения резкости
procedure FilterSharpen(img:TIMG);
//фильтр зашумления
procedure FilterNoise(img:TIMG; NoisePercent:real);
//фильтр обращения (инверсии) цветов
procedure FilterNegative(img:TIMG);
//фильтр коррекции цветов (умножается на соответствующий коэффициент каждая компонета)
procedure FilterColorCorrection(img:TIMG; k_r,k_g,k_b:real);

implementation

//матричная фильтрация по заданным глобальным коэффициентам
procedure FilterMatrix(img:Timg);
var tmp_IMG:TImg;
begin
tmp_IMG:=TImg.Create;
tmp_IMG.SetSize(img.width,img.height);
img.MatrixFilter(tmp_IMG,
                 MatrixFilter_k11,MatrixFilter_k12,MatrixFilter_k13,
                 MatrixFilter_k21,MatrixFilter_k22,MatrixFilter_k23,
                 MatrixFilter_k31,MatrixFilter_k32,MatrixFilter_k33);
tmp_IMG.CloneToIMG(img);
end;

//фильтр наложения нескольких изображений друг на друга с учетом полупрозрачностей
procedure FilterCompose(dst_img:TIMG; src_img:array of TIMG; transparency:array of real);
var i,x,y,images_num:integer; C,Cs:Int32;
    Rs,Gs,Bs: byte;
    K_emission,K_absorption:real;
begin
  images_num:=length(src_img);
  dst_img.clrscr(0);
//собственно сведение
K_emission:=1;
for i:=images_num-1 downto 0 do
begin
  K_absorption:=K_emission*(1-Transparency[i]);
  K_emission:=K_emission*Transparency[i];
  for y:=0 to dst_img.height-1 do
  for x:=0 to dst_img.width-1 do
  begin
    C:=src_img[i].GetPixel(x,y);
    if C>=0 then
    begin
      Cs:=dst_img.GetPixel(x,y);
      Rs:=trunc((red(Cs)+red(C))*K_absorption);
      Gs:=trunc((green(Cs)+green(C))*K_absorption);
      Bs:=trunc((blue(Cs)+blue(C))*K_absorption);
      dst_img.SetPixel(x,y,RGBtoColor(Rs,Gs,Bs));
    end;
  end;
end;
end;

//регулировка яркости (k-коэффициент усиления/ослабления k=1 - исходная яркость)
procedure FilterBrightness(img:Timg; k:real);
begin
  FilterColorCorrection(img,k,k,k);
end;

//фильтр коррекции цветов (умножается на соответствующий коэффициент каждая компонета)
procedure FilterColorCorrection(img:TIMG; k_r,k_g,k_b:real);
var C:Int32; x,y,r,g,b:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    C:=img.GetPixel(x,y);
    if C>=0 then
    begin
      r:=red(C); g:=green(C); b:=blue(C);
      r:=trunc(r*k_r); g:=trunc(g*k_g); b:=trunc(b*k_b);
      if r<0 then r:=0; if r>255 then r:=255;
      if g<0 then g:=0; if g>255 then g:=255;
      if b<0 then b:=0; if b>255 then b:=255;
      C:=RGBToColor(r,g,b);
      img.SetPixel(x,y,C);
    end;
  end;
end;

//регулировка контрастности (k-коэффициент усиления/ослабления k=1 - исходная)
procedure FilterContrast(img:Timg; k:real);
var C:Int32; x,y,r,g,b:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    C:=img.GetPixel(x,y);
    if C>=0 then
    begin
      r:=red(C); g:=green(C); b:=blue(C);
      R:=trunc((R-128.0)*k+128.0);
      G:=trunc((G-128.0)*k+128.0);
      B:=trunc((B-128.0)*k+128.0);
      if B<0 then B:=0; if B>255 then B:=255;
      if G<0 then G:=0; if G>255 then G:=255;
      if R<0 then R:=0; if R>255 then R:=255;
      C:=RGBToColor(r,g,b);
      img.SetPixel(x,y,C);
    end;
  end;
end;

//преобразование цветного изображения в градации серого
procedure FilterDesaturation(img:Timg);
var C:Int32; x,y,r,g,b,S:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    C:=img.GetPixel(x,y);
    r:=red(C); g:=green(C); b:=blue(C);
    S:=(r+g+b) div 3;
    C:=RGBToColor(S,S,S);
    img.SetPixel(x,y,C);
  end;
end;

//преобразование цветного изображение в черно-белое
//k - порог обесцвечивания (от 0 до 1)
procedure FilterThresold(img:Timg; k:real);
var C:Int32; x,y,r,g,b,S:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    C:=img.GetPixel(x,y);
    r:=red(C); g:=green(C); b:=blue(C);
    S:=(r+g+b) div 3;
    if S/255.0>=k then S:=255 else S:=0;
    C:=RGBToColor(S,S,S);
    img.SetPixel(x,y,C);
  end;
end;

//фильтр размытия
procedure FilterBlur(img:Timg);
var tmp_IMG:Timg;
begin
  tmp_IMG:=TImg.Create;
  tmp_IMG.SetSize(img.width,img.height);
  MatrixFilter_k11:=0;
  MatrixFilter_k12:=0.2;
  MatrixFilter_k13:=0;
  MatrixFilter_k21:=0.2;
  MatrixFilter_k22:=0.2;
  MatrixFilter_k23:=0.2;
  MatrixFilter_k31:=0;
  MatrixFilter_k32:=0.2;
  MatrixFilter_k33:=0;
  img.MatrixFilter(tmp_IMG,
                   MatrixFilter_k11,MatrixFilter_k12,MatrixFilter_k13,
                   MatrixFilter_k21,MatrixFilter_k22,MatrixFilter_k23,
                   MatrixFilter_k31,MatrixFilter_k32,MatrixFilter_k33);
  tmp_IMG.CloneToIMG(img);
  tmp_IMG.done;
end;

//фильтр выделения контуров
procedure FilterContour(img:TIMG);
var tmp_IMG:TImg;
begin
  tmp_IMG:=TImg.Create;
  tmp_IMG.SetSize(SelIMG.width,SelIMG.height);
  MatrixFilter_k11:=0;
  MatrixFilter_k12:=-1;
  MatrixFilter_k13:=0;
  MatrixFilter_k21:=-1;
  MatrixFilter_k22:=4;
  MatrixFilter_k23:=-1;
  MatrixFilter_k31:=0;
  MatrixFilter_k32:=-1;
  MatrixFilter_k33:=0;
  img.MatrixFilter(tmp_IMG,
                   MatrixFilter_k11,MatrixFilter_k12,MatrixFilter_k13,
                   MatrixFilter_k21,MatrixFilter_k22,MatrixFilter_k23,
                   MatrixFilter_k31,MatrixFilter_k32,MatrixFilter_k33);
  tmp_IMG.CloneToIMG(img);
  tmp_IMG.done;
end;

//фильтр повышения резкости
procedure FilterSharpen(img:TIMG);
var tmp_IMG:TImg;
begin
  tmp_IMG:=TImg.Create;
  tmp_IMG.SetSize(SelIMG.width,SelIMG.height);
  MatrixFilter_k11:=0;
  MatrixFilter_k12:=-1;
  MatrixFilter_k13:=0;
  MatrixFilter_k21:=-1;
  MatrixFilter_k22:=5;
  MatrixFilter_k23:=-1;
  MatrixFilter_k31:=0;
  MatrixFilter_k32:=-1;
  MatrixFilter_k33:=0;
  img.MatrixFilter(tmp_IMG,
                   MatrixFilter_k11,MatrixFilter_k12,MatrixFilter_k13,
                   MatrixFilter_k21,MatrixFilter_k22,MatrixFilter_k23,
                   MatrixFilter_k31,MatrixFilter_k32,MatrixFilter_k33);
  tmp_IMG.CloneToIMG(img);
  tmp_IMG.done;
end;

//фильтр зашумления
procedure  FilterNoise(img:TIMG; NoisePercent:real);
var x,y:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    if random*100<NoisePercent then img.SetPixel(x,y,random(256*256*256));
  end;
end;

//фильтр обращения (инверсии) цветов
procedure FilterNegative(img:TIMG);
var C:Int32; x,y,r,g,b:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    C:=img.GetPixel(x,y);
    if C>=0 then
    begin
      r:=red(C); g:=green(C); b:=blue(C);
      C:=RGBToColor(255-r,255-g,255-b);
      img.SetPixel(x,y,C);
    end;
  end;
end;

end.

