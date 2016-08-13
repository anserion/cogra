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
//подпрограммы распознавания образов
//=====================================================================
unit recognition_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, utils_unit, arith_complex, img_unit, globals_unit;

//функция ищет образ на изображении как связанное множество одноцветных точек
//граница неравенства цвета соседних точек задается параметром b_level
function DetectImages(min_pixels,b_level:integer; src_img:TIMG):integer;

//функция на основе критерия квадрата евклидова расстояния ищет ближайший образ
//из коллекции для заданного "неизвестного"образа
//перед поиском осуществляется масштабирование изображений до размеров (DX x DY)
function RecognitionImage(x_img:TIMG; collection:array of TIMG; dx,dy:integer):integer;

implementation

//функция ищет образы на изображении как связанные множества одноцветных точек
//граница неравенства цвета соседних точек задается параметром b_level
//возвращаемое значение - число найденных образов на изображении
function DetectImages(min_pixels,b_level:integer; src_img:TIMG):integer;
var tmp_img,tmp2_img, AreaIMG:TIMG; C,C0:Int32;
    images_num,probes_num,k,x0,y0,x,y,N,xmin,xmax,ymin,ymax:integer;
begin
     tmp_img:=TIMG.Create;
     tmp_img.SetSize(src_img.width,src_img.height);
     tmp2_img:=TIMG.Create;
     tmp2_img.SetSize(src_img.width,src_img.height);
     src_img.CloneToImg(tmp_img);
     images_num:=0;
     probes_num:=10*((tmp_img.width*tmp_img.height) div min_pixels);

     for k:=1 to probes_num do
     begin
       //начиаем поиск нового образа от случайной точки изображения
       x0:=random(tmp_img.width);
       y0:=random(tmp_img.height);
       C0:=tmp_img.GetPixel(x0,y0);
       //если не попали в уже найденный образ, то работаем
       if C0>=0 then
       begin
         //делаем копию холста на случай если образ ложный
         tmp_img.CloneToImg(tmp2_img);
         //выделяем кандидата на образ
         tmp_img.FloodFillFuzzy(x0,y0,b_level,tmp_img.GetPixel(x0,y0),-images_num-100000);
         //считаем число точек в кандидате на образ,
         //параллельно выясняем его размер и положение на холсте
         N:=0;
         xmin:=tmp_img.width; ymin:=tmp_img.height; xmax:=-1; ymax:=-1;
         for y:=0 to tmp_img.height-1 do
         for x:=0 to tmp_img.width-1 do
         begin
           C:=tmp_img.GetPixel(x,y);
           if C= -images_num-100000 then
           begin
             N:=N+1;
             if x<xmin then xmin:=x;
             if x>xmax then xmax:=x;
             if y<ymin then ymin:=y;
             if y>ymax then ymax:=y;
           end;
         end;
         //если число точек в кандидате меньше критического, то образ - ложный
         if N<min_pixels then tmp2_img.CloneToImg(tmp_img)
            else //иначе работаем
         begin
           AreaIMG:=TIMG.Create;
           AreaIMG.SetSize(xmax-xmin,ymax-ymin);
           AreaIMG.parent_x0:=xmin; AreaIMG.parent_y0:=ymin;
           AreaIMG.clrscr(-1);
           //вырезаем образ из холста по отрицательным кодам его пикселей
           //записанным процедурой заливки в копию холста
           for y:=0 to tmp_img.height-1 do
           for x:=0 to tmp_img.width-1 do
           begin
             C:=tmp_img.GetPixel(x,y);
             if C= -images_num-100000 then AreaIMG.SetPixel(x-xmin,y-ymin,src_img.GetPixel(x,y));
           end;
           //добавляем новый образ в коллекцию
           AddNewImageToCollection(AreaIMG);
           AreaIMG.done;
           images_num:=images_num+1;
         end;
       end;
     end;
     tmp_img.done;
     tmp2_img.done;
     DetectImages:=images_num;
end;

//функция расчета "расстояния" между двумя изображениями (одинакового размера)
function distance(img1,img2:TIMG):integer;
var i,N,d2,r1,g1,b1,r2,g2,b2,gray1,gray2:integer; C1,C2:Int32;
begin
  N:=img1.width*img1.height;
  d2:=0;
  for i:=0 to N-1 do
  begin
    C1:=img1.data[i];
    r1:=C1 and 255; g1:=(C1>>8)and 255; b1:=(C1>>16)and 255;
    gray1:=(r1+g1+b1)div 3;
    C2:=img2.data[i];
    r2:=C2 and 255; g2:=(C2>>8)and 255; b2:=(C2>>16)and 255;
    gray2:=(r2+g2+b2)div 3;
    d2:=d2+sqr(gray1-gray2);
  end;
  distance:=d2;
end;

//функция на основе критерия квадрата евклидова расстояния ищет ближайший образ
//из коллекции для заданного "неизвестного"образа
//перед поиском осуществляется масштабирование изображений до размеров (DX x DY)
function RecognitionImage(x_img:TIMG; collection:array of TIMG; dx,dy:integer):integer;
var i,index_nearest,min_d,d:integer;
    tmp_x_img:TIMG; tmp_collection:array of TIMG;
begin
  //создаем масштабированную копию неизвестного изображения
  tmp_x_img:=TIMG.create;
  tmp_x_img.SetSize(dx,dy);
  x_img.ScaleToImg(tmp_x_img);

  //создаем масштабированные копии изображений коллекции
  SetLength(tmp_collection,length(collection));
  for i:=0 to length(tmp_collection)-1 do
  begin
    tmp_collection[i]:=TIMG.create;
    tmp_collection[i].SetSize(dx,dy);
    collection[i].ScaleToImg(tmp_collection[i]);
  end;

  //ищем образ из коллекции с наименьшим расстоянием до неизвестного
  min_d:=high(integer); index_nearest:=-1;
  for i:=0 to length(tmp_collection)-1 do
  begin
    d:=distance(tmp_x_img,tmp_collection[i]);
    if d<min_d then
    begin
      min_d:=d;
      index_nearest:=i;
    end;
  end;

  //уничтожаем копии изображений
  tmp_x_img.done;
  for i:=0 to length(tmp_collection)-1 do tmp_collection[i].done;
  SetLength(tmp_collection,0);

  //возвращаем ответ (индекс наиболее похожего изображения из коллекции)
  RecognitionImage:=index_nearest;
end;

end.

