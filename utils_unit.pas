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
//несколько полезных функций, забытых разработчиками FreePascal
//swap(a,b) - обмен переменных, min(a,b), max(a,b) - максимум и минимум
//=====================================================================
unit utils_unit;

{$mode objfpc}{$H+}

interface

procedure swap(var a,b:integer); //обмен содержимого двух ячеек памяти
procedure swap(var a,b:real); //обмен содержимого двух ячеек памяти

function min(a,b:integer):integer; //выбор минимального из двух значений
function min(a,b:real):real; //выбор минимального из двух значений

function max(a,b:integer):integer; //выбор максимального из двух значений
function max(a,b:real):real;

//проверка и в случае необходимости корректировка параметров
//рабочего прямоугольника для, например, битмапа rect(0,0,width-1,height-1)
procedure CorrectRectParams(width,height:integer; var left,top,right,bottom:integer);

//проверка нахождения точки внутри (включая границы) прямоугольника
function PlotInRect(x,y:integer; xmin,ymin,xmax,ymax:integer):boolean;

implementation

//обмен содержимого двух ячеек памяти
procedure swap(var a,b:integer);
var tmp:integer; begin tmp:=a; a:=b; b:=tmp; end;

procedure swap(var a,b:real);
var tmp:real; begin tmp:=a; a:=b; b:=tmp; end;

//выбор минимального из двух значений
function min(a,b:integer):integer;
begin if a<b then min:=a else min:=b; end;

function min(a,b:real):real;
begin if a<b then min:=a else min:=b; end;

//выбор максимального из двух значений
function max(a,b:integer):integer;
begin if a>b then max:=a else max:=b; end;

function max(a,b:real):real;
begin if a>b then max:=a else max:=b; end;

//проверка и в случае необходимости корректировка параметров
//рабочего прямоугольника для, например, битмапа rect(0,0,width-1,height-1)
procedure CorrectRectParams(width,height:integer; var left,top,right,bottom:integer);
begin
  if Left<0 then left:=0;
  if Left>=width then left:=width-1;
  if Right<0 then Right:=0;
  if Right>=width then Right:=width-1;
  if top<0 then top:=0;
  if top>=height then top:=height-1;
  if Bottom<0 then Bottom:=0;
  if Bottom>=height then Bottom:=height-1;

  if Left>Right then swap(Left,Right);
  if Top>Bottom then swap(Top,Bottom);
end;

//проверка нахождения точки внутри (включая границы) прямоугольника
function PlotInRect(x,y:integer; xmin,ymin,xmax,ymax:integer):boolean;
begin PlotInRect:=(x>=xmin)and(x<=xmax)and(y>=ymin)and(y<=ymax); end;

end.

