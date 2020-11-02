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

//функция производит поиск границ связных однотонных областей на изображении.
//Возвращаются координаты точек границы (имя функции - число точек).
//граница неравенства цвета соседних точек задается параметром b_level
//предполагается, что в массиве координат выходных точек достаточно места
function DetectBorderPixels(min_pixels,b_level:integer; src_img:TIMG; var P:array of TPoint):integer;

//Поиск векторов по массиву опорных точек для каждого образа
//функция возвращает число найденных векторов
//VectorMinD - минимальная длина вектора
//P - входной массив опорных точек
//V - выходной массив TPoint-номеров точек (начало,конец) векторов
//предполагается, что в выходном массиве векторов достаточно места
function DetectVectors(VectorMinD:integer; P:array of TPoint; var V:array of TPoint):integer;

implementation

//Поиск векторов по массиву опорных точек для каждого образа
//функция возвращает число найденных векторов
//VectorMinD - минимальная длина вектора
//P - входной массив опорных точек
//V - выходной массив TPoint-номеров точек (начало,конец) векторов
//предполагается, что в выходном массиве векторов достаточно места
function DetectVectors(VectorMinD:integer; P:array of TPoint; var V:array of TPoint):integer;
var i,j,k,vv,points_num,vectors_num,img_start,img_end:integer;
    x1,y1,img_vector_start,vector_end:integer;
    D2,min_D2,VectorMinD2:integer;
    flag,flag2:boolean;
begin
  vectors_num:=0;
  points_num:=length(P);
  VectorMinD2:=sqr(VectorMinD);

  x1:=-1; y1:=-1; k:=0;
  while k<points_num do
  begin
    //определяем начало и конец образа
    while ((x1<0)or(y1<0))and(k<points_num) do
    begin
      x1:=P[k].x; y1:=P[k].y;
      k:=k+1;
    end;
    if k=0 then img_start:=0 else img_start:=k-1;
    while (x1>=0)and(y1>=0)and(k<points_num) do
    begin
      x1:=P[k].x; y1:=P[k].y;
      k:=k+1;
    end;
    if k=0 then img_end:=0 else img_end:=k-1;

    //выделяем векторы из массива точек границы образа
    i:=img_start;
    if vectors_num=0 then img_vector_start:=0 else img_vector_start:=vectors_num-1;
    while i<img_end do
    begin
      flag:=false;
      min_D2:=high(integer); //большое число,заведомо большее любых расстояний между точками
      for j:=i+1 to img_end do
      begin
        D2:=sqr(abs(P[i].X)-abs(P[j].X))+sqr(abs(P[i].Y)-abs(P[j].Y));
        if (D2>=VectorMinD2)and(D2<=min_D2) then
        begin
          flag2:=true;
          for vv:=img_vector_start to vectors_num-1 do
              if (V[vv].X=j)and(V[vv].Y=i) then flag2:=false;
          if flag2 then
          begin
            flag:=true;
            min_D2:=D2;
            vector_end:=j;
          end;
        end;
      end;
      if flag then
      begin
        V[vectors_num].X:=i;
        V[vectors_num].Y:=vector_end;
        i:=vector_end;
        vectors_num:=vectors_num+1;
      end;
      i:=i+1;
    end;

    if vectors_num>0 then
    if V[vectors_num-1].Y<>img_end then
    begin
      V[vectors_num].X:=V[vectors_num-1].Y;
      V[vectors_num].Y:=img_end;
      vectors_num:=vectors_num+1;
    end;
  end;

  DetectVectors:=vectors_num;
end;

//функция производит поиск границ связных однотонных областей на изображении.
//Возвращаются координаты точек границы (имя функции - число точек).
//граница неравенства цвета соседних точек задается параметром b_level
//предполагается, что в массиве координат выходных точек P достаточно места
function DetectBorderPixels(min_pixels,b_level:integer; src_img:TIMG; var P:array of TPoint):integer;
var tmp_img,tmp2_img: TIMG; C,C0,C1,C2,C3,C4:Int32;
    images_num,probes_num,points_num,k,x0,y0,x,y,N,xmin,xmax,ymin,ymax:integer;
    i,j,tmp_points_num:integer;
    isFirst:boolean;
begin
  tmp_img:=TIMG.Create;
  tmp_img.SetSize(src_img.width,src_img.height);
  tmp2_img:=TIMG.Create;
  tmp2_img.SetSize(src_img.width,src_img.height);
  src_img.CloneToImg(tmp_img);
  images_num:=0;
  probes_num:=10*((tmp_img.width*tmp_img.height) div min_pixels);
  points_num:=0;

  for k:=1 to probes_num do
  begin
    //начинаем поиск нового образа от случайной точки изображения
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
        //определяем "граничные" точки образа по разнице кодов между точкой образа
        //и любой из смежных с ним точек, записанным процедурой заливки в копию холста
        //первую из найденных точек границы пометим инверсией ее координат
        isFirst:=true; tmp_points_num:=points_num;
        for y:=ymin to ymax do
        for x:=xmin to xmax do
        begin
          //выясняем цвет текущей точки образа
          C:=tmp_img.GetPixel(x,y);
          //если точка принадлежит найденному образу,
          //то анализируем цвета точек вокруг нее
          if C= -images_num-100000 then
          begin
            if x>xmin then C1:=tmp_img.GetPixel(x-1,y) else C1:=0;
            if y>ymin then C2:=tmp_img.GetPixel(x,y-1) else C2:=0;
            if x<xmax then C3:=tmp_img.GetPixel(x+1,y) else C3:=0;
            if y<ymax then C4:=tmp_img.GetPixel(x,y+1) else C4:=0;
            //если любая из соседних точек не принадлежит образу,
            //то текущая точка - граничная и ее надо добавить в результат
            if (C1>=0)or(C2>=0)or(C3>=0)or(C4>=0) then
            begin
              if isFirst then
              begin
                P[points_num].x:= -x;
                P[points_num].y:= -y;
              end
              else
              begin
                P[points_num].x:=x;
                P[points_num].y:=y;
              end;
              isFirst:=false; //первая точка уже точно найдена и записана
              points_num:=points_num+1;
            end;
          end;
        end;
        //располагаем точки границы так, чтобы они находились рядом друг с другом
        //for i:=tmp_points_num to points_num-2 do
        //  for j:=i+1 to points_num-1 do
        //    if ((abs(P[i].X-P[j].X)=1)and(P[i].Y=P[j].Y))or
        //       ((P[i].X=P[j].X)and(abs(P[i].Y-P[j].Y)=1)) then swap(P[i+1],P[j]);
        //увеличиваем счетчик найденных образов
        images_num:=images_num+1;
      end;
    end;
  end;
  tmp_img.done;
  tmp2_img.done;
  DetectBorderPixels:=points_num;
end;

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

