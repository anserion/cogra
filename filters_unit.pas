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
//медианный фильтр
procedure FilterMedian(img:TIMG; Radius:integer);
//Адаптивный медианный фильтр от соли и перца
procedure FilterAdaptiveMedian(img:TIMG; Radius:integer);
//фильтр зашумления
procedure FilterNoise(img:TIMG; NoisePercent:real);
//фильтр зашумления "солью" NoisePercent пикселей засвечиваются белым цветом
procedure FilterSault(img:TIMG; NoisePercent:real);
//фильтр зашумления "перцем" NoisePercent пикселей засвечиваются черным цветом
procedure FilterPepper(img:TIMG; NoisePercent:real);
//фильтр зашумления "солью и перцем" NoisePercent пикселей засвечиваются
//или белым или черным цветом
procedure FilterSaultPepper(img:TIMG; NoisePercent:real);
//фильтр восстановления изображения от соли и перца
procedure FilterDePepper(img:TIMG; show_triangles:boolean);
//фильтр обращения (инверсии) цветов
procedure FilterNegative(img:TIMG);
//фильтр коррекции цветов (умножается на соответствующий коэффициент каждая компонета)
procedure FilterColorCorrection(img:TIMG; k_r,k_g,k_b:real);
//процедура определения пикового соотношения сигнал/шум
procedure FilterPSNR(img_orig,img_new:TIMG; var PSNR_r,PSNR_g,PSNR_b:real);

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
  tmp_IMG.SetSize(IMG.width,IMG.height);
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
  tmp_IMG.SetSize(IMG.width,IMG.height);
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

//медианный фильтр
procedure FilterMedian(img:TIMG; Radius:integer);
var x,y,i,j,k,N,r,g,b:integer;
    tmp_img,filter_img:TIMG;
    red_data,green_data,blue_data:array of integer;
    C:Int32;
begin
     N:=Radius*Radius;
     tmp_img:=TIMG.create;
     tmp_IMG.SetSize(IMG.width,IMG.height);
     tmp_img.FillRect(0,0,tmp_img.width-1,tmp_img.height-1,0);

     filter_img:=TIMG.create;
     filter_img.SetSize(Radius,Radius);

     setlength(red_data,N);
     setlength(green_data,N);
     setlength(blue_data,N);

     for y:=radius to img.height-radius-1 do
     for x:=radius to img.width-radius-1 do
     begin
       img.CopyRect(filter_img,RECT(x,y,x+radius,y+radius),RECT(0,0,radius-1,radius-1));
       k:=0;
       for i:=0 to radius-1 do
       for j:=0 to radius-1 do
       begin
           C:=filter_img.GetPixel(i,j);
           red_data[k]:=red(C);
           green_data[k]:=green(C);
           blue_data[k]:=blue(C);
           k:=k+1;
       end;

       quick_sort(red_data,0,N-1); r:=red_data[N div 2];
       quick_sort(green_data,0,N-1); g:=green_data[N div 2];
       quick_sort(blue_data,0,N-1); b:=blue_data[N div 2];
       tmp_img.SetPixel(x,y,RGBToColor(r,g,b));
     end;
     tmp_IMG.CloneToIMG(img);

     setlength(red_data,0);
     setlength(green_data,0);
     setlength(blue_data,0);
     tmp_img.done; filter_img.done;
end;

//Адаптивный медианный фильтр от соли и перца
procedure FilterAdaptiveMedian(img:TIMG; Radius:integer);
var x,y,i,j,k,N,r,g,b:integer;
    tmp_img,filter_img:TIMG;
    red_data,green_data,blue_data:array of integer;
    pepper_color,sault_color,C:Int32;
begin
     N:=Radius*Radius;
     pepper_color:=0; sault_color:=65536*255+256*255+255;
     tmp_img:=TIMG.create;
     tmp_IMG.SetSize(IMG.width,IMG.height);
     tmp_img.FillRect(0,0,tmp_img.width-1,tmp_img.height-1,0);

     filter_img:=TIMG.create;
     filter_img.SetSize(Radius,Radius);

     setlength(red_data,N);
     setlength(green_data,N);
     setlength(blue_data,N);

     for y:=radius to img.height-radius-1 do
     for x:=radius to img.width-radius-1 do
     begin
       C:=img.GetPixel(x,y);
       if (C<>pepper_color)and(C<>sault_color) then tmp_img.SetPixel(x,y,C)
          else
       begin
         img.CopyRect(filter_img,RECT(x,y,x+radius,y+radius),RECT(0,0,radius-1,radius-1));
         k:=0; red_data[0]:=0; green_data[0]:=0; blue_data[0]:=0;
         for i:=0 to radius-1 do
         for j:=0 to radius-1 do
         begin
           C:=filter_img.GetPixel(i,j);
           if (C<>pepper_color)and(C<>sault_color) then
           begin
             red_data[k]:=red(C);
             green_data[k]:=green(C);
             blue_data[k]:=blue(C);
             k:=k+1;
           end;
         end;

         quick_sort(red_data,0,k-1); r:=red_data[k div 2];
         quick_sort(green_data,0,k-1); g:=green_data[k div 2];
         quick_sort(blue_data,0,k-1); b:=blue_data[k div 2];
         tmp_img.SetPixel(x,y,RGBToColor(r,g,b));
       end;
     end;
     tmp_IMG.CloneToIMG(img);

     setlength(red_data,0);
     setlength(green_data,0);
     setlength(blue_data,0);
     tmp_img.done; filter_img.done;
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

//фильтр зашумления "солью" NoisePercent пикселей засвечиваются белым цветом
procedure FilterSault(img:TIMG; NoisePercent:real);
var x,y:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    if random*100<NoisePercent then img.SetPixel(x,y,65536*255+256*255+255);
  end;
end;

//фильтр зашумления "перцем" NoisePercent пикселей засвечиваются черным цветом
procedure FilterPepper(img:TIMG; NoisePercent:real);
var x,y:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    if random*100<NoisePercent then img.SetPixel(x,y,0);
  end;
end;

//фильтр зашумления "солью и перцем" NoisePercent пикселей засвечиваются
//или белым или черным цветом
procedure FilterSaultPepper(img:TIMG; NoisePercent:real);
var x,y:integer;
begin
  for y:=0 to img.height-1 do
  for x:=0 to img.width-1 do
  begin
    if random*100<NoisePercent then img.SetPixel(x,y,Random(2)*(65536*255+256*255+255));
  end;
end;

//фильтр восстановления изображения от соли и перца
procedure FilterDePepper(img:TIMG; show_triangles:boolean);

//расчет квадрата расстояния между точками
function distance2(x1,y1,x2,y2:integer):real;
begin distance2:=sqr(x1-x2)+sqr(y1-y2); end;
//расчет площади треугольника по формуле Герона
function S_triangle(a,b,c:real):real;
var p:real;
begin
     p:=(a+b+c)/2;
     S_triangle:=sqrt(p*(p-a)*(p-b)*(p-c));
end;
//определение принадлежности точки треугольнику
// -1 - не принадлежит треугольнику
// 0 - внутри треугольника
// 1 - лежит на стороне 1-2
// 2 - лежит на стороне 1-3
// 3 - лежит на стороне 2-3
// 4 - совпадает с первой вершиной
// 5 - совпадает со второй вершиной
// 6 - совпадает с третьей вершиной
// 7 - треугольник настолько мал, что "совпадает" с точкой
function inside_triangle(x,y,x1,y1,x2,y2,x3,y3:integer):integer;
var xa,xb,xc,ab,ac,bc,S_abc,S_axb,S_axc,S_bxc,epsilon:real; tmp:integer;
begin
     xa:=sqrt(distance2(x,y,x1,y1));
     xb:=sqrt(distance2(x,y,x2,y2));
     xc:=sqrt(distance2(x,y,x3,y3));
     ab:=sqrt(distance2(x1,y1,x2,y2));
     ac:=sqrt(distance2(x1,y1,x3,y3));
     bc:=sqrt(distance2(x2,y2,x3,y3));
     epsilon:=0.001;
     S_abc:=S_triangle(ab,ac,bc);
     S_axb:=S_triangle(ab,xa,xb);
     S_axc:=S_triangle(ac,xa,xc);
     S_bxc:=S_triangle(bc,xb,xc);
     tmp:=-1;
     if abs(S_axb+S_axc+S_bxc-S_abc)<epsilon then tmp:=0;
     if (S_axb<epsilon)or(S_axc<epsilon)or(S_bxc<epsilon)or(S_abc<epsilon) then tmp:=-1;
//     if S_axb<epsilon then tmp:=1;
//     if S_axc<epsilon then tmp:=2;
//     if S_bxc<epsilon then tmp:=3;
//     if (S_axb<epsilon)and(S_axc<epsilon) then tmp:=4;
//     if (S_axb<epsilon)and(S_bxc<epsilon) then tmp:=5;
//     if (S_axc<epsilon)and(S_bxc<epsilon) then tmp:=6;
//     if (S_axb<epsilon)and(S_axc<epsilon)and(S_bxc<epsilon) then tmp:=7;
     inside_triangle:=tmp;
end;

var x,y,i,j,x1,y1,x2,y2,x3,y3,p1,p2,p3,tmp:integer;
    good_points_num,triangles_num,triangle_state:integer;
    c,c1,c2,c3,pepper_color,sault_color:Int32;
    good_points:array of record x,y:integer; c:Int32; end;
    good_points_order:array of integer;
    triangles:array of record p1,p2,p3:integer; end;
begin
     pepper_color:=0; sault_color:=65536*255+256*255+255;
     //подсчет числа неискаженных точек изображения
     good_points_num:=0;
     for y:=0 to img.height-1 do
     for x:=0 to img.width-1 do
     begin
          c:=img.GetPixel(x,y);
          if (c<>pepper_color)and(c<>sault_color) then good_points_num:=good_points_num+1;
     end;
     good_points_num:=good_points_num+4;

     //занесение координат и цветов всех неискаженных точек в массив
     setlength(good_points,good_points_num+1);
     //первые четыре точки - дополнительные (упрощают триангуляцию)
     good_points[1].x:=0; good_points[1].y:=0;
     good_points[2].x:=img.width-1; good_points[2].y:=0;
     good_points[3].x:=0; good_points[3].y:=img.height-1;
     good_points[4].x:=img.width-1; good_points[4].y:=img.height-1;

     good_points[1].c:=img.GetPixel(good_points[1].x,good_points[1].y);
     good_points[2].c:=img.GetPixel(good_points[2].x,good_points[2].y);
     good_points[3].c:=img.GetPixel(good_points[3].x,good_points[3].y);
     good_points[4].c:=img.GetPixel(good_points[4].x,good_points[4].y);
     i:=4;
     for y:=0 to img.height-1 do
     for x:=0 to img.width-1 do
     begin
          c:=img.GetPixel(x,y);
          if (c<>pepper_color)and(c<>sault_color) then
          begin
               i:=i+1;
               good_points[i].x:=x;
               good_points[i].y:=y;
               good_points[i].c:=c;
          end;
     end;

     //триангуляция
     setlength(good_points_order,good_points_num+1);
     for i:=1 to good_points_num do good_points_order[i]:=i;
     //перемешиваем точки-вершины треугольников триангуляции
     for i:=5 to good_points_num do
     begin
       j:=random(good_points_num-5)+5;
       tmp:=good_points_order[i];
       good_points_order[i]:=good_points_order[j];
       good_points_order[j]:=tmp;
     end;

     setlength(triangles,good_points_num*3);
     //первые два треугольника задают ограничивающую оболочку
     triangles_num:=2;
     triangles[1].p1:=1; triangles[1].p2:=2; triangles[1].p3:=3;
     triangles[2].p1:=2; triangles[2].p2:=3; triangles[2].p3:=4;
     //анализируем точки, начиная с пятой, так как первые четыре задают оболочку
     for i:=5 to good_points_num do
     begin
       //берем новую точку для проверки на более глубокую триангуляцию
       x:=good_points[good_points_order[i]].x;
       y:=good_points[good_points_order[i]].y;
       //перебираем все имеющиеся треугольники
       j:=1;
       repeat
         p1:=triangles[j].p1;
         p2:=triangles[j].p2;
         p3:=triangles[j].p3;
         x1:=good_points[p1].x; y1:=good_points[p1].y;
         x2:=good_points[p2].x; y2:=good_points[p2].y;
         x3:=good_points[p3].x; y3:=good_points[p3].y;
         //определяем положение анализируемой точки относительно текущего треугольника
         triangle_state:=inside_triangle(x,y,x1,y1,x2,y2,x3,y3);
         //если точка внутри треугольника, то разбиваем его на 3 треугольника
         if triangle_state=0 then
         begin
           triangles[j].p3:=good_points_order[i];
           triangles_num:=triangles_num+1;
           triangles[triangles_num].p1:=p2;
           triangles[triangles_num].p2:=p3;
           triangles[triangles_num].p3:=good_points_order[i];
           triangles_num:=triangles_num+1;
           triangles[triangles_num].p1:=p1;
           triangles[triangles_num].p2:=p3;
           triangles[triangles_num].p3:=good_points_order[i];
         end;
(*
         //если точка на ребре 1-2, то разбиваем треугольник на два
         if triangle_state=1 then
         begin
           triangles[j].p2:=good_points_order[i];
           triangles_num:=triangles_num+1;
           triangles[triangles_num].p1:=good_points_order[i];;
           triangles[triangles_num].p2:=p2;
           triangles[triangles_num].p3:=p3;
         end;
         //если точка на ребре 1-3, то разбиваем треугольник на два
         if triangle_state=2 then
         begin
           triangles[j].p3:=good_points_order[i];
           triangles_num:=triangles_num+1;
           triangles[triangles_num].p1:=good_points_order[i];;
           triangles[triangles_num].p2:=p2;
           triangles[triangles_num].p3:=p3;
         end;
         //если точка на ребре 2-3, то разбиваем треугольник на два
         if triangle_state=3 then
         begin
           triangles[j].p3:=good_points_order[i];
           triangles_num:=triangles_num+1;
           triangles[triangles_num].p1:=good_points_order[i];;
           triangles[triangles_num].p2:=p1;
           triangles[triangles_num].p3:=p3;
         end;
*)
         j:=j+1;
       until j>triangles_num;
     end;

     //вывод треугольников на экран
     for i:=1 to triangles_num do
     begin
          p1:=triangles[i].p1;
          p2:=triangles[i].p2;
          p3:=triangles[i].p3;
          x1:=good_points[p1].x; y1:=good_points[p1].y; c1:=good_points[p1].c;
          x2:=good_points[p2].x; y2:=good_points[p2].y; c2:=good_points[p2].c;
          x3:=good_points[p3].x; y3:=good_points[p3].y; c3:=good_points[p3].c;
          img.GuroTriangle(x1,y1,x2,y2,x3,y3,c1,c2,c3);
     end;

     //если включен режим демонстрации триангуляции (рисование контуров треугольников)
     if show_triangles then
     for i:=1 to triangles_num do
     begin
          p1:=triangles[i].p1;
          p2:=triangles[i].p2;
          p3:=triangles[i].p3;
          x1:=good_points[p1].x; y1:=good_points[p1].y; c1:=good_points[p1].c;
          x2:=good_points[p2].x; y2:=good_points[p2].y; c2:=good_points[p2].c;
          x3:=good_points[p3].x; y3:=good_points[p3].y; c3:=good_points[p3].c;
          img.Line(x1,y1,x2,y2,Sault_color);
          img.Line(x1,y1,x3,y3,Sault_color);
          img.Line(x2,y2,x3,y3,Sault_color);
          img.Ellipse(x1,y1,2,2,c1);
          img.Ellipse(x2,y2,2,2,c2);
          img.Ellipse(x3,y3,2,2,c3);
     end;

     setlength(good_points,0);
     setlength(good_points_order,0);
     setlength(triangles,0);
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

//процедура определения пикового соотношения сигнал/шум
procedure FilterPSNR(img_orig,img_new:TIMG; var PSNR_r,PSNR_g,PSNR_b:real);
var x,y:integer;
    peakval,MSE_r,MSE_g,MSE_b:real;
    r_orig,r_new,g_orig,g_new,b_orig,b_new:Integer;
    C_orig,C_new:Int32;
begin
     peakval:=255;
     MSE_r:=0; MSE_g:=0; MSE_b:=0;
     for y:=0 to img_orig.height-1 do
     for x:=0 to img_orig.width-1 do
     begin
       C_orig:=img_orig.GetPixel(x,y);
       C_new:=img_new.GetPixel(x,y);
       MSE_r:=MSE_r+sqr(red(C_orig)-red(C_new));
       MSE_g:=MSE_g+sqr(green(C_orig)-green(C_new));
       MSE_b:=MSE_b+sqr(blue(C_orig)-blue(C_new));
     end;
     MSE_r:=MSE_r/(img_orig.width*img_orig.height);
     MSE_g:=MSE_g/(img_orig.width*img_orig.height);
     MSE_b:=MSE_b/(img_orig.width*img_orig.height);

     if MSE_r<>0 then PSNR_r:=10*lg(sqr(peakval)/MSE_r) else PSNR_r:=-1;
     if MSE_g<>0 then PSNR_g:=10*lg(sqr(peakval)/MSE_g) else PSNR_g:=-1;
     if MSE_b<>0 then PSNR_b:=10*lg(sqr(peakval)/MSE_b) else PSNR_b:=-1;
end;

end.

