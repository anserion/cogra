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
//глобальные переменные, такие как сводный холст, слои, мышиные координаты и т.д.
//=====================================================================
unit globals_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, utils_unit, img_unit, img3d_unit, arith_complex;

type
TRealVector=array of real;
TRealMatrix=array of TRealVector;

TIntegerVector=array of integer;
TIntegerMatrix=array of TIntegerVector;

var
WorkIMG: TImg; //промежуточный буфер рисования
Collection: Array of TImg; //коллекция изображений, например, эталоны распознавания
SummaryIMG: TImg; //буфер слияния всех слоев в одно изображение
ReadyToShowIMG: TIMG; //готовое к показу на экране изображение
SelIMG: TImg; //изображение выделения
Layers: array of TImg; //слои (холсты) рисования
LayersTransparency:array of real; //прозрачность слоев(0-непрозрачно, 1- полностью прозрачно)
LayerCode: integer; //номер активного слоя рисования
MouseCoords: array of TPoint; //стек координат точек нажатия мыши
MouseButton: integer; //код нажатой на мыше кнопки
MatrixFilter_k11,MatrixFilter_k12,MatrixFilter_k13,      //коэффициенты матричной фильтрации
MatrixFilter_k21,MatrixFilter_k22,MatrixFilter_k23,      //"глобальные" чтобы не вводить
MatrixFilter_k31,MatrixFilter_k32,MatrixFilter_k33:real; //много чисел при повторных пусках фильтра
affine_a11,affine_a12,affine_a21,affine_a22,affine_a31,affine_a32:real; //коэффициенты аффинного преобразования
area_min_pixels:integer; //min число пикселей в образе
area_contrast_level:integer; //уровень контрастности границ при поиске образов на изображении
global_DFT_width,global_DFT_height:integer; //размеры матрицы преобразования Фурье
mode_3d:boolean; //режим трехмерного моделирования
thetha_3d,phi_3d,dist_3d:real; //углы поворота и удаление от наблюдателя
img3d:Timg3d; //глобальный 3d-объект

procedure AddNewImageToCollection(img:TIMG); //добавление нового изображения в конец коллекции (создается новая копия изображения)
procedure RemoveImageFromCollection(img_num:integer); //удаление изображения из коллекции

procedure FourieMatrixToIMG(S:string; var FMatrix:TIntegerComplexMatrix;
                             var IMG_re,IMG_im,IMG_amp:TIMG);
procedure DFT_IMG_recombination(var img:TIMG); //перестановка квадрантов на изображении спектра ДПФ

implementation

//добавление нового изображения в конец коллекции (создается новая копия изображения)
procedure AddNewImageToCollection(img:TIMG);
begin
  SetLength(Collection,length(Collection)+1);
  Collection[high(Collection)]:=TIMG.Create;
  Collection[high(Collection)].SetSize(img.width,img.height);
  Collection[high(Collection)].parent_x0:=img.parent_x0;
  Collection[high(Collection)].parent_y0:=img.parent_y0;
  Collection[high(Collection)].name:=img.name;
  img.CloneToImg(Collection[high(collection)]);
end;

//удаление изображения из коллекции
procedure RemoveImageFromCollection(img_num:integer);
var i:integer;
begin
  Collection[img_num].done; Collection[img_num]:=nil;
  for i:=img_num to length(Collection)-2 do Collection[i]:=Collection[i+1];
  Collection[length(Collection)-1]:=nil;
  SetLength(Collection,length(Collection)-1);
end;

//визуализация действительной части, мнимой части и модуля
//двумерного массива с комплексными данными
procedure FourieMatrixToIMG(S:string; var FMatrix:TIntegerComplexMatrix;
                             var IMG_re,IMG_im,IMG_amp:TIMG);
var x,y,matrix_width,matrix_height:integer; tmp_C:TComplex;
begin
  matrix_height:=length(FMatrix);
  matrix_width:=length(FMatrix[0]);

  IMG_amp.SetSize(matrix_width,matrix_height);
  IMG_im.SetSize(matrix_width,matrix_height);
  IMG_re.SetSize(matrix_width,matrix_height);

  IMG_amp.name:=S+'.Amp';
  IMG_im.name:=S+'.Im';
  IMG_re.name:=S+'.Re';

  for y:=0 to matrix_height-1 do
  for x:=0 to matrix_width-1 do
  begin
    IMG_re.SetPixel(x,y,FMatrix[y,x].re+high(integer) div 2);
    IMG_im.SetPixel(x,y,FMatrix[y,x].im+high(integer) div 2);
    tmp_C.re:=FMatrix[y,x].re;
    tmp_C.im:=FMatrix[y,x].im;
    IMG_amp.SetPixel(x,y,trunc(c_amp(tmp_c)));
  end;
end;

//перестановка квадрантов на изображении спектра ДПФ
//(максимумы будут в центре, а не по углам)
procedure DFT_IMG_recombination(var img:TIMG);
var img_tmp1,img_tmp2,img_tmp3,img_tmp4:TIMG;
begin
  img_tmp1:=TIMG.Create;
  img_tmp2:=TIMG.Create;
  img_tmp3:=TIMG.Create;
  img_tmp4:=TIMG.Create;
  img_tmp1.SetSize(img.width div 2,img.height div 2);
  img_tmp2.SetSize(img.width div 2,img.height div 2);
  img_tmp3.SetSize(img.width div 2,img.height div 2);
  img_tmp4.SetSize(img.width div 2,img.height div 2);
  img_tmp1.DrawFromImg(img,0,0);
  img_tmp2.DrawFromImg(img,0,img.height div 2);
  img_tmp3.DrawFromImg(img,img.width div 2,0);
  img_tmp4.DrawFromImg(img,img.width div 2,img.height div 2);
  img_tmp1.DrawToImg(img,img.width div 2,img.height div 2);
  img_tmp2.DrawToImg(img,img.width div 2,0);
  img_tmp3.DrawToImg(img,0,img.height div 2);
  img_tmp4.DrawToImg(img,0,0);
  img_tmp1.done;
  img_tmp2.done;
  img_tmp3.done;
  img_tmp4.done;
end;

end.

