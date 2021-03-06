//Copyright 2015-2018 Andrey S. Ionisyan (anserion@gmail.com)
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

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PrintersDlgs, Forms, Controls, printers,
  Graphics, Dialogs, Menus, ExtCtrls, StdCtrls, FileUtil,
  ExtDlgs, FPCanvas, LCLintf, LCLtype, Grids,
  utils_unit, globals_unit, img_unit, colors_unit, filters_unit,
  functions_unit, recognition_unit, img3d_unit, arith_complex, Types;

type
  { TForm1 }

  TForm1 = class(TForm)
    BrushColorDialog: TColorDialog;
    ButtonFixCoordsNum: TButton;
    ButtonVectorsNum: TButton;
    Button_DFT_params: TButton;
    ButtonAreasParams: TButton;
    ButtonAffineKoeff: TButton;
    ButtonFilterKoeff: TButton;
    CheckBoxShowImages: TCheckBox;
    EditVectorMin: TEdit;
    EditFixCoordsNum: TEdit;
    EditVectorsNum: TEdit;
    Edit_DFT_width: TEdit;
    EditAreasMinPixels: TEdit;
    EditAreasContrast: TEdit;
    EditFilterZnam: TEdit;
    Edit_DFT_height: TEdit;
    GridAffineKoeff: TStringGrid;
    GridCoords: TStringGrid;
    GridVectors: TStringGrid;
    GridFilterKoeff: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    LabelCoords: TLabel;
    LabelVectorPTRS: TLabel;
    Label_3D: TLabel;
    LabelCollection: TLabel;
    LabelAreasMinPixels: TLabel;
    LabelAreasContrast: TLabel;
    LabelFilterZnam: TLabel;
    LabelAffineGrid: TLabel;
    LabelMagnify: TLabel;
    LabelColorBlack: TLabel;
    LabelColorLightness: TLabel;
    LabelColorX: TLabel;
    LabelColorY: TLabel;
    LabelColorZ: TLabel;
    LabelColorCyan: TLabel;
    LabelColorMagenta: TLabel;
    LabelColorYellow: TLabel;
    LabelColorY_gamma: TLabel;
    LabelColorCb: TLabel;
    LabelColorCr: TLabel;
    LabelColorBlue: TLabel;
    LabelColorGreen: TLabel;
    LabelColorHue: TLabel;
    LabelColorRed: TLabel;
    LabelColorSaturation: TLabel;
    LabelColorvalue: TLabel;
    MenuItemSaveSTL: TMenuItem;
    MenuItemFileOpenScale: TMenuItem;
    MenuItemVectorize: TMenuItem;
    MenuItemPsetFixCoords: TMenuItem;
    MenuItemDetectBorderPixels: TMenuItem;
    MenuItemPolygonVectors: TMenuItem;
    MenuItemLoadVectors: TMenuItem;
    MenuItemSaveVectors: TMenuItem;
    MenuItemLoadFixCoords: TMenuItem;
    MenuItemSaveFixCoords: TMenuItem;
    MenuItemPolygonFixCoords: TMenuItem;
    MenuItemGenerateCube3D: TMenuItem;
    MenuItemGenerateTetraedr3D: TMenuItem;
    MenuItemCenter3D: TMenuItem;
    MenuItemService: TMenuItem;
    MenuItem_3D_on_off: TMenuItem;
    MenuItemLoadSTL: TMenuItem;
    MenuItemPrimitivs3D: TMenuItem;
    MenuItem_3D: TMenuItem;
    MenuItemAdaptiveMedianFilterAgain1000: TMenuItem;
    MenuItemAdaptiveMedianFilterAgain100: TMenuItem;
    MenuItemAdaptiveMedianFilterAgain10: TMenuItem;
    MenuItemAdaptiveMedianFilterAgain5: TMenuItem;
    MenuItemAdaptiveMedianFilterAgain1: TMenuItem;
    MenuItemPSNR: TMenuItem;
    MenuItemAdaptiveMedianFilter: TMenuItem;
    MenuItemMedianFilter: TMenuItem;
    MenuItemCircle: TMenuItem;
    MenuItemDePepper: TMenuItem;
    MenuItemDePepperShow: TMenuItem;
    MenuItemSault: TMenuItem;
    MenuItemPepper: TMenuItem;
    MenuItemSaultPepper: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    TextConsole: TMemo;
    MenuItemFractalLandscape: TMenuItem;
    MenuItemFractalMandelbrot: TMenuItem;
    MenuItemRedChannelClean: TMenuItem;
    MenuItemGreenChannelClean: TMenuItem;
    MenuItemBlueChannelClean: TMenuItem;
    MenuItemLayerSize512x512: TMenuItem;
    MenuItemFourieKoeffsClean: TMenuItem;
    MenuItemIMGtoGreenReFourie: TMenuItem;
    MenuItemIMGtoGreenImFourie: TMenuItem;
    MenuItemIMGtoBlueReFourie: TMenuItem;
    MenuItemIMGtoBlueImFourie: TMenuItem;
    MenuItemIMGtoRedReFourie: TMenuItem;
    MenuItemIMGtoRedImFourie: TMenuItem;
    MenuItemOIR: TMenuItem;
    MenuItemFractalJulia: TMenuItem;
    MenuItemClearCollection: TMenuItem;
    MenuItemHighPassFourie: TMenuItem;
    MenuItemCFunction: TMenuItem;
    MenuItemSaveCollection: TMenuItem;
    MenuItemNegative: TMenuItem;
    MenuItemEditCopyToCollection: TMenuItem;
    MenuItemPrint: TMenuItem;
    MenuItemLoadCollection: TMenuItem;
    MenuItemGeneration: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    MenuItemNoise: TMenuItem;
    MenuItemSharpen: TMenuItem;
    MenuItemContour: TMenuItem;
    MenuItemMatrixFilterAgain1: TMenuItem;
    MenuItemMatrixFilterAgain5: TMenuItem;
    MenuItemMatrixFilterAgain10: TMenuItem;
    MenuItemMatrixFilterAgain100: TMenuItem;
    MenuItemMatrixFilterAgain1000: TMenuItem;
    MenuItemMagnify5: TMenuItem;
    MenuItemMagnify10: TMenuItem;
    MenuItemMagnify20: TMenuItem;
    MenuItemMagnify1: TMenuItem;
    MenuItemMagnify2: TMenuItem;
    MenuItemMagnify3: TMenuItem;
    MenuItemLayer2: TMenuItem;
    MenuItemLayer1: TMenuItem;
    MenuItemLayer0: TMenuItem;
    MenuItemLayer: TMenuItem;
    MenuItemMatrixFilter: TMenuItem;
    MenuItemEditCopyFromSummary: TMenuItem;
    MenuItemTFunction: TMenuItem;
    MenuItemThreshold0: TMenuItem;
    MenuItemThreshold90: TMenuItem;
    MenuItemThreshold100: TMenuItem;
    MenuItemThreshold10: TMenuItem;
    MenuItemThreshold20: TMenuItem;
    MenuItemThreshold30: TMenuItem;
    MenuItemThreshold40: TMenuItem;
    MenuItemThreshold50: TMenuItem;
    MenuItemThreshold60: TMenuItem;
    MenuItemThreshold70: TMenuItem;
    MenuItemThreshold80: TMenuItem;
    MenuItemContrastIncrease: TMenuItem;
    MenuItemBrightnessIncrease: TMenuItem;
    MenuItemThreshold: TMenuItem;
    MenuItemDesaturation: TMenuItem;
    MenuItemBrush: TMenuItem;
    MenuItemLayerSize32x32: TMenuItem;
    MenuItemLayerSize640x480: TMenuItem;
    MenuItemLayerSize800x600: TMenuItem;
    MenuItemLayerSize1024x768: TMenuItem;
    MenuItemLayerSize64x64: TMenuItem;
    MenuItemLayerSize256x256: TMenuItem;
    MenuItemLayerSize8x8: TMenuItem;
    MenuItemLayerSize8x16: TMenuItem;
    MenuItemLayerSize256x192: TMenuItem;
    MenuItemLayerSize320x200: TMenuItem;
    MenuItemLayerSize320x240: TMenuItem;
    MenuItemLayerSize512x384: TMenuItem;
    MenuItemLayerSize: TMenuItem;
    MenuItemFFunction: TMenuItem;
    ImageView: TPaintBox;
    PBoxCollection: TPaintBox;
    PanelCollection: TPanel;
    PanelGrids: TPanel;
    PBoxMagnify: TPaintBox;
    PanelColor: TPanel;
    PenColorDialog: TColorDialog;
    LabelPenSize: TLabel;
    LabelLayerTransp: TLabel;
    LabelLayerCode: TLabel;
    LabelFileName: TLabel;
    LabelInstrumentName: TLabel;
    LabelPBoxMainSize: TLabel;
    LabelMouseCoords: TLabel;
    LabelColorPen: TLabel;
    MainMenu: TMainMenu;
    MenuItemTransp0: TMenuItem;
    MenuItemTransp40: TMenuItem;
    MenuItemTransp100: TMenuItem;
    MenuItemTransp90: TMenuItem;
    MenuItemTransp10: TMenuItem;
    MenuItemTransp80: TMenuItem;
    MenuItemTransp20: TMenuItem;
    MenuItemTransp70: TMenuItem;
    MenuItemTransp60: TMenuItem;
    MenuItemTransp30: TMenuItem;
    MenuItemTransp50: TMenuItem;
    MenuItemEditErase: TMenuItem;
    MenuItemFile: TMenuItem;
    MenuItemLine: TMenuItem;
    MenuItemRectangle: TMenuItem;
    MenuItemEllipse: TMenuItem;
    MenuItemBrightnessDecrease: TMenuItem;
    MenuItemContrastDecrease: TMenuItem;
    MenuItemFill: TMenuItem;
    MenuItemInstruments: TMenuItem;
    MenuItemFunction: TMenuItem;
    MenuItemFourieAnalysis: TMenuItem;
    MenuItemFourieSynt: TMenuItem;
    MenuItemAffinne: TMenuItem;
    MenuItemEdit: TMenuItem;
    MenuItemEditCopyFromLayer: TMenuItem;
    MenuItemProcs: TMenuItem;
    MenuItemEditPaste: TMenuItem;
    MenuItemHelpUser: TMenuItem;
    MenuItemHelpProgrammer: TMenuItem;
    MenuItemHelpAbout: TMenuItem;
    MenuItemSearchRegions: TMenuItem;
    MenuItemRecognition: TMenuItem;
    MenuItemAnalysis: TMenuItem;
    MenuItemBlur: TMenuItem;
    MenuItemEditMagnifity: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemLayerTransparency: TMenuItem;
    MenuItemHelpTeacher: TMenuItem;
    MenuItemCrypt: TMenuItem;
    MenuItemLowPassFourie: TMenuItem;
    MenuItemText: TMenuItem;
    MenuItemEditClear: TMenuItem;
    MenuItemFileOpen: TMenuItem;
    MenuItemFileSave: TMenuItem;
    MenuItemSetPixel: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    PanelStatus: TPanel;
    PrintPictureDialog: TPrintDialog;
    SavePictureDialog: TSavePictureDialog;
    ScrollBarCollection: TScrollBar;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    procedure ButtonAffineKoeffClick(Sender: TObject);
    procedure ButtonAreasParamsClick(Sender: TObject);
    procedure ButtonFilterKoeffClick(Sender: TObject);
    procedure ButtonFixCoordsNumClick(Sender: TObject);
    procedure ButtonVectorsNumClick(Sender: TObject);
    procedure Button_DFT_paramsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridCoordsEditingDone(Sender: TObject);
    procedure GridVectorsEditingDone(Sender: TObject);
    procedure ImageViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImageViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageViewMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImageViewMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImageViewPaint(Sender: TObject);
    procedure LabelColorPenClick(Sender: TObject);
    procedure LabelLayerCodeClick(Sender: TObject);
    procedure LabelLayerTranspClick(Sender: TObject);
    procedure LabelPenSizeClick(Sender: TObject);
    procedure MenuItemAdaptiveMedianFilterClick(Sender: TObject);
    procedure MenuItemBlueChannelCleanClick(Sender: TObject);
    procedure MenuItemCenter3DClick(Sender: TObject);
    procedure MenuItemDePepperClick(Sender: TObject);
    procedure MenuItemDePepperShowClick(Sender: TObject);
    procedure MenuItemFileOpenScaleClick(Sender: TObject);
    procedure MenuItemFractalMandelbrotClick(Sender: TObject);
    procedure MenuItemGenerateCube3DClick(Sender: TObject);
    procedure MenuItemGenerateTetraedr3DClick(Sender: TObject);
    procedure MenuItemGreenChannelCleanClick(Sender: TObject);
    procedure MenuItemAffinneClick(Sender: TObject);
    procedure MenuItemBlurClick(Sender: TObject);
    procedure MenuItemBrightnessDecreaseClick(Sender: TObject);
    procedure MenuItemBrightnessIncreaseClick(Sender: TObject);
    procedure MenuItemCFunctionClick(Sender: TObject);
    procedure MenuItemClearCollectionClick(Sender: TObject);
    procedure MenuItemFourieKoeffsCleanClick(Sender: TObject);
    procedure MenuItemFractalJuliaClick(Sender: TObject);
    procedure MenuItemHighPassFourieClick(Sender: TObject);
    procedure MenuItemIMGtoBlueImFourieClick(Sender: TObject);
    procedure MenuItemIMGtoBlueReFourieClick(Sender: TObject);
    procedure MenuItemIMGtoGreenImFourieClick(Sender: TObject);
    procedure MenuItemIMGtoGreenReFourieClick(Sender: TObject);
    procedure MenuItemIMGtoRedImFourieClick(Sender: TObject);
    procedure MenuItemIMGtoRedReFourieClick(Sender: TObject);
    procedure MenuItemLoadFixCoordsClick(Sender: TObject);
    procedure MenuItemLoadSTLClick(Sender: TObject);
    procedure MenuItemLoadVectorsClick(Sender: TObject);
    procedure MenuItemLowPassFourieClick(Sender: TObject);
    procedure MenuItemContourClick(Sender: TObject);
    procedure MenuItemContrastDecreaseClick(Sender: TObject);
    procedure MenuItemContrastIncreaseClick(Sender: TObject);
    procedure MenuItemCryptClick(Sender: TObject);
    procedure MenuItemEditCopyFromLayerClick(Sender: TObject);
    procedure MenuItemEditCopyFromSummaryClick(Sender: TObject);
    procedure MenuItemEditCopyToCollectionClick(Sender: TObject);
    procedure MenuItemEditEraseClick(Sender: TObject);
    procedure MenuItemEditPasteClick(Sender: TObject);
    procedure MenuItemFFunctionClick(Sender: TObject);
    procedure MenuItemFourieAnalysisClick(Sender: TObject);
    procedure MenuItemFourieSyntClick(Sender: TObject);
    procedure MenuItemFunctionClick(Sender: TObject);
    procedure MenuItemHelpProgrammerClick(Sender: TObject);
    procedure MenuItemHelpTeacherClick(Sender: TObject);
    procedure MenuItemHelpUserClick(Sender: TObject);
    procedure MenuItemLayer0Click(Sender: TObject);
    procedure MenuItemLoadCollectionClick(Sender: TObject);
    procedure MenuItemMagnify1Click(Sender: TObject);
    procedure MenuItemMatrixFilterAgain1Click(Sender: TObject);
    procedure MenuItemMedianFilterClick(Sender: TObject);
    procedure MenuItemNegativeClick(Sender: TObject);
    procedure MenuItemNoiseClick(Sender: TObject);
    procedure MenuItemPepperClick(Sender: TObject);
    procedure MenuItemPolygonFixCoordsClick(Sender: TObject);
    procedure MenuItemPolygonVectorsClick(Sender: TObject);
    procedure MenuItemPrintClick(Sender: TObject);
    procedure MenuItemPsetFixCoordsClick(Sender: TObject);
    procedure MenuItemPSNRClick(Sender: TObject);
    procedure MenuItemRecognitionClick(Sender: TObject);
    procedure MenuItemRedChannelCleanClick(Sender: TObject);
    procedure MenuItemSaultClick(Sender: TObject);
    procedure MenuItemSaultPepperClick(Sender: TObject);
    procedure MenuItemSaveCollectionClick(Sender: TObject);
    procedure MenuItemSaveFixCoordsClick(Sender: TObject);
    procedure MenuItemSaveSTLClick(Sender: TObject);
    procedure MenuItemSaveVectorsClick(Sender: TObject);
    procedure MenuItemSearchRegionsClick(Sender: TObject);
    procedure MenuItemSelectAllClick(Sender: TObject);
    procedure MenuItemSharpenClick(Sender: TObject);
    procedure MenuItemTFunctionClick(Sender: TObject);
    procedure MenuItemThreshold0Click(Sender: TObject);
    procedure MenuItemDesaturationClick(Sender: TObject);
    procedure MenuItemEditClearClick(Sender: TObject);
    procedure MenuItemLayerSize8x8Click(Sender: TObject);
    procedure MenuItemHelpAboutClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemFileOpenClick(Sender: TObject);
    procedure MenuItemFileSaveClick(Sender: TObject);
    procedure MenuItemSetPixelClick(Sender: TObject);
    procedure MenuItemTransp0Click(Sender: TObject);
    procedure MenuItemDetectBorderPixelsClick(Sender: TObject);
    procedure MenuItemVectorizeClick(Sender: TObject);
    procedure MenuItem_3D_on_offClick(Sender: TObject);
    procedure PBoxCollectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PBoxCollectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxCollectionPaint(Sender: TObject);
    procedure ScrollBarCollectionChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    ImageViewBitmap:TBitmap; //битмап рисования на PaintBox
    PenColor: TColor; //Цвет рисования
    PenSize: integer; //Размер пера рисования
    TextToRender:string; //текст, вводимый в инструмент рисования "текст"
    InstrumentCode:integer; //Номер инструмента рисования
    ImageFilename:string; //имя обрабатываемого графического файла
    DontComposeLayersFlag: boolean; //флаг отключения перерасчета полупрозрачных наложений слоев рисования
    DontAddComposeToCollectionFlag: boolean; //флаг отключения протоколирования рисования
    ImageViewShiftFlag: boolean; //признак включения перемещения окна просмотра части холста
    SelectionToolInWorkFlag: boolean; //признак работы с инструментом выделения
    TranslateToolInWorkFlag: boolean; //признак работы с инструментом переноса (копирования) выделенной области
    RotateToolInWorkFlag: boolean; //признак работы с инструментом вращения выделенной области
    ScaleToolInWorkFlag: boolean; //признак работы с инструментом масштабирования выделенной области
    InstrumentInWorkFlag: boolean; //признак активности выбранного инструмента
    Move3dInWorkFlag: boolean; //признак включения режима 3D-манипуляций
    MagnifyBitmap: TBitmap; //полотно рисования лупы для связи с PaintBox
    MagnifyIMG: TIMG; //полотно быстрого рисования лупы
    MagnifyScale: real; //коэффициент увеличения лупы
    FirstCollectionItem:integer; //номер первого отображаемого слева изображения коллекции
    procedure RefreshStatusBar; //обновить панель состояния программы
    procedure ComposeImageView; //вывести все слои в область вывода, с доп. информацией
    procedure DrawMagnifyBox(x,y:integer; scale_koeff:real; img:TIMG); //отрисовка пикселей лупы для заданного изображения
    procedure DrawCollectionBox; //рисование изображений коллекции
    procedure DrawSelectionFrame; //отмечаем на сводном изображение область выделения
    procedure RecalcBuffers(new_width,new_height:integer); //пересоздание всех глобальных буферов под заданные размеры
    procedure Img3dToGrids; //отображение координат вертексов и треугольников в таблицах GUI
    procedure FixCoordsToGrids; //отображение координат опорных точек и отрезков в таблицах GUI
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

//отображение координат опорных точек и отрезков в таблицах GUI
procedure TForm1.FixCoordsToGrids;
var i,n:integer;
begin
  if not(mode_3d) then
  begin
    n:=length(Layers[LayerCode].FixCoords);
    EditFixCoordsNum.Text:=IntToStr(n);
    GridCoords.RowCount:=n;
    for i:=0 to n-1 do
    begin
      GridCoords.Cells[0,i]:=IntToStr(i);
      GridCoords.Cells[1,i]:=IntToStr(Layers[LayerCode].FixCoords[i].x);
      GridCoords.Cells[2,i]:=IntToStr(Layers[LayerCode].FixCoords[i].y);
    end;

    n:=length(Layers[LayerCode].Vectors);
    EditVectorsNum.text:=IntToStr(n);
    GridVectors.RowCount:=n;
    for i:=0 to n-1 do
    begin
      GridVectors.Cells[0,i]:=IntToStr(i);
      GridVectors.Cells[1,i]:=IntToStr(Layers[LayerCode].Vectors[i].x);
      GridVectors.Cells[2,i]:=IntToStr(Layers[LayerCode].Vectors[i].y);
    end;
  end;
end;

//отображение координат вертексов и треугольников в таблицах GUI
procedure TForm1.Img3dToGrids;
var i,n:integer;
begin
  if mode_3d then
  begin
      n:=img3d.n_coords;
      EditFixCoordsNum.Text:=IntToStr(n);
      GridCoords.RowCount:=n;
      for i:=0 to n-1 do
      begin
        GridCoords.Cells[0,i]:=IntToStr(i);
        GridCoords.Cells[1,i]:=IntToStr(trunc(img3d.coords[i].x));
        GridCoords.Cells[2,i]:=IntToStr(trunc(img3d.coords[i].y));
        GridCoords.Cells[3,i]:=IntToStr(trunc(img3d.coords[i].z));
      end;

      n:=img3d.n_trios;
      EditVectorsNum.Text:=IntToStr(n);
      GridVectors.RowCount:=n;
      for i:=0 to n-1 do
      begin
        GridVectors.Cells[0,i]:=IntToStr(i);
        GridVectors.Cells[1,i]:=IntToStr(img3d.trios[i].p1);
        GridVectors.Cells[2,i]:=IntToStr(img3d.trios[i].p2);
        GridVectors.Cells[3,i]:=IntToStr(img3d.trios[i].p3);
      end;
  end;
end;

//пересоздание всех глобальных буферов под заданные размеры
procedure TForm1.RecalcBuffers(new_width,new_height:integer);
var i:integer;
begin
  SummaryIMG.ReSize(new_width,new_height);
  WorkIMG.ReSize(new_width,new_height);
  WorkIMG.clrscr(-1);
  ImageViewBitmap.SetSize(new_width,new_height);
  for i:=0 to length(Layers)-1 do Layers[i].ReSize(new_width,new_height);
  SelIMG.ReSize(new_width,new_height);
  ReadyToShowIMG.ReSize(new_width,new_height);
end;

//отмечаем на сводном изображении область выделения
procedure TForm1.DrawSelectionFrame;
begin
ImageView.Canvas.Pen.Width:=1;
ImageView.Canvas.Pen.Color:=clBlue;
ImageView.Canvas.Pen.Style:=psDashDot;
ImageView.Canvas.Frame(SelIMG.parent_x0+SummaryIMG.parent_x0,
                       SelIMG.parent_y0+SummaryIMG.parent_y0,
                       SelIMG.parent_x0+SelIMG.width+SummaryIMG.parent_x0,
                       SelIMG.parent_y0+SelIMG.height+SummaryIMG.parent_y0);
end;

//рисование изображений коллекции
procedure TForm1.DrawCollectionBox;
var i,k:integer; tmp_bitmap:TBitmap; tmp_img:TIMG;
begin
  PBoxCollection.Canvas.Clear;
  tmp_bitmap:=TBitmap.create;
  tmp_bitmap.SetSize(PBoxCollection.height,PBoxCollection.height);
  tmp_img:=TIMG.Create;
  tmp_img.SetSize(PBoxCollection.height,PBoxCollection.height);
  for i:=0 to (PBoxCollection.width div PBoxCollection.Height)-1 do
  begin
    k:=i+FirstCollectionItem;
    if k<length(Collection) then
    begin
      tmp_img.clrscr(-1);
      Collection[k].ScaleToImg(tmp_img);
      tmp_img.CloneImgToBitmap(tmp_bitmap);
      PBoxCollection.Canvas.Draw(i*PBoxCollection.height,0,tmp_bitmap);
      PBoxCollection.Canvas.TextOut(i*PBoxCollection.height,0,Collection[k].name);
    end;
  end;
  tmp_bitmap.free;
  ScrollBarCollection.Max:=length(Collection);
end;

//отрисовка пикселей лупы
procedure TForm1.DrawMagnifyBox(x,y:integer; scale_koeff:real; img:TIMG);
var src_width,src_height:integer;
    tmp_buffer:TIMG;
begin
  if scale_koeff<>0 then scale_koeff:=1/scale_koeff else scale_koeff:=0;
  src_width:=trunc(PBoxMagnify.width*scale_koeff);
  src_height:=trunc(PBoxMagnify.Height*scale_koeff);

  tmp_buffer:=TIMG.Create;
  tmp_buffer.SetSize(src_width,src_height);
  tmp_buffer.DrawFromImg(img,x-(src_width div 2),y-(src_height div 2));
  tmp_buffer.ScaleToIMG(MagnifyIMG);
  tmp_buffer.done;
  MagnifyIMG.CloneImgToBitmap(MagnifyBitmap);
  PBoxMagnify.Canvas.Draw(0,0,MagnifyBitmap);
end;

//вывести все слои в область вывода, с доп. информацией
//например, обозначить область выделения
procedure TForm1.ComposeImageView;
begin
  if not(DontComposeLayersFlag) then FilterCompose(SummaryIMG,Layers,LayersTransparency);
  DontComposeLayersFlag:=false;
  ReadyToShowIMG.clrscr(0);
  SummaryIMG.CloneToImg(ReadyToShowIMG);
  WorkIMG.CloneToIMG(ReadyToShowIMG);
  ReadyToShowIMG.CloneImgToBitmap(ImageViewBitmap);
  ImageView.Canvas.Brush.Style:=bsSolid;
  ImageView.Canvas.Brush.Color:=clGray;
  ImageView.Canvas.FillRect(0,0,ImageView.width,SummaryIMG.parent_y0);
  ImageView.Canvas.FillRect(0,SummaryIMG.parent_y0+SummaryIMG.height,ImageView.width,ImageView.height);
  ImageView.Canvas.FillRect(0,SummaryIMG.parent_y0,SummaryIMG.parent_x0,SummaryIMG.parent_y0+SummaryIMG.height);
  ImageView.Canvas.FillRect(SummaryIMG.parent_x0+SummaryIMG.width,SummaryIMG.parent_y0,ImageView.Width,SummaryIMG.parent_y0+SummaryIMG.height);
  ImageView.Canvas.Draw(SummaryIMG.parent_x0,SummaryIMG.parent_y0,ImageViewBitmap);
  DrawSelectionFrame;
  DontAddComposeToCollectionFlag:= DontAddComposeToCollectionFlag or
        InstrumentInWorkFlag or SelectionToolInWorkFlag or
        RotateToolInWorkFlag or ScaleToolInWorkFlag or
        TranslateToolInWorkFlag or ImageViewShiftFlag or Move3DInWorkFlag;
  if not(DontAddComposeToCollectionFlag) then
  begin
    AddNewImageToCollection(Layers[LayerCode]);
    DrawCollectionBox;
  end;
  DontAddComposeToCollectionFlag:=false;
end;

//обновление содержимого полей панели статуса
procedure TForm1.RefreshStatusBar;
var C:TFullColor; CC:Int32; k:real;
begin
   LabelMouseCoords.caption:='Мышь: '+IntToStr(MouseCoords[0].X)+'x'+IntToStr(MouseCoords[0].Y);
   LabelPBoxMainSize.caption:='Полотно: '+IntToStr(SummaryIMG.width)+'x'+IntToStr(SummaryIMG.height);
   LabelFileName.caption:='Файл: '+ImageFilename;
   LabelLayerCode.caption:='Слой: '+IntToStr(LayerCode);
   LabelLayerTransp.caption:='Прозрачность: '+IntToStr(trunc(100*LayersTransparency[LayerCode]))+'%';
   LabelPenSize.caption:='Перо: '+IntToStr(PenSize)+'px';
   LabelColorPen.color:=PenColor;

   CC:=Layers[LayerCode].GetPixel(MouseCoords[0].X,MouseCoords[0].y);
   C:=ConvertRGBToFull(red(CC)/255.0,green(CC)/255.0,blue(CC)/255.0);

   LabelColorRed.Caption:='R='+FloatToStr(C.red);
   LabelColorGreen.Caption:='G='+FloatToStr(C.green);
   LabelColorBlue.Caption:='B='+FloatToStr(C.blue);

   LabelColorHue.Caption:='H='+FloatToStr(C.hue);
   LabelColorSaturation.Caption:='S='+FloatToStr(C.saturation);
   LabelColorLightness.Caption:='L='+FloatToStr(C.lightness);
   LabelColorValue.Caption:='V='+FloatToStr(C.value);

   LabelColorCyan.Caption:='C='+FloatToStr(C.cyan);
   LabelColorMagenta.Caption:='M='+FloatToStr(C.magenta);
   LabelColorYellow.Caption:='Y='+FloatToStr(C.yellow);
   LabelColorBlack.Caption:='K='+FloatToStr(C.black);

   LabelColorY_gamma.Caption:='Y='+FloatToStr(C.red);
   LabelColorCb.Caption:='U='+FloatToStr(C.Cb);
   LabelColorCr.Caption:='V='+FloatToStr(C.Cr);

   LabelColorX.Caption:='X='+FloatToStr(C.XX);
   LabelColorY.Caption:='Y='+FloatToStr(C.YY);
   LabelColorZ.Caption:='Z='+FloatToStr(C.ZZ);

   LabelMagnify.Caption:='Лупа: x'+FloatToStr(MagnifyScale);

   GridAffineKoeff.Cells[0,0]:=FloatToStr(Affine_a11);
   GridAffineKoeff.Cells[1,0]:=FloatToStr(Affine_a12);
   GridAffineKoeff.Cells[0,1]:=FloatToStr(Affine_a21);
   GridAffineKoeff.Cells[1,1]:=FloatToStr(Affine_a22);
   GridAffineKoeff.Cells[0,2]:=FloatToStr(Affine_a31);
   GridAffineKoeff.Cells[1,2]:=FloatToStr(Affine_a32);

   k:=StrToFloat(EditFilterZnam.text);
   if k=0 then k:=1;
   GridFilterKoeff.Cells[0,0]:=FloatToStr(MatrixFilter_k11*k);
   GridFilterKoeff.Cells[1,0]:=FloatToStr(MatrixFilter_k12*k);
   GridFilterKoeff.Cells[2,0]:=FloatToStr(MatrixFilter_k13*k);
   GridFilterKoeff.Cells[0,1]:=FloatToStr(MatrixFilter_k21*k);
   GridFilterKoeff.Cells[1,1]:=FloatToStr(MatrixFilter_k22*k);
   GridFilterKoeff.Cells[2,1]:=FloatToStr(MatrixFilter_k23*k);
   GridFilterKoeff.Cells[0,2]:=FloatToStr(MatrixFilter_k31*k);
   GridFilterKoeff.Cells[1,2]:=FloatToStr(MatrixFilter_k32*k);
   GridFilterKoeff.Cells[2,2]:=FloatToStr(MatrixFilter_k33*k);

   LabelCollection.Caption:='Коллекция: '+IntToStr(length(Collection))+' образов';

   if mode_3d then Label_3D.Caption:='Режим 3D: включен'+' ('+
                                     IntToStr(img3d.n_coords)+' вертексов, '+
                                     IntToStr(img3d.n_trios)+' треугольников)';
   if not(mode_3d) then Label_3D.Caption:='Режим 3D: выключен';
end;

//иницализация программы
procedure TForm1.FormCreate(Sender: TObject);
var i,j:integer;
begin
  //цвет рисования
  PenColor:=clGreen;
  //размер пера рисования (толщина линий)
  PenSize:=2;
  //инструмент рисования (выключено)
  InstrumentInWorkFlag:=false;
  InstrumentCode:=0;
  //Инструмент выделения выключен
  SelectionToolInWorkFlag:=false;
  //активный слой рисования - нулевой
  LayerCode:=0;
  //создаем хранилище мышиных координат
  SetLength(MouseCoords,10);
  //никаких кнопок на мыше не нажато
  MouseButton:=-1;
  //инициализация коллекции образов
  SetLength(Collection,0);
  //настройка подсистемы распознавания образов
  area_min_pixels:=100;
  area_contrast_level:=100;
  vector_min_d:=10;
  //создаем полотно лупы
  MagnifyIMG:=TIMG.create;
  MagnifyIMG.SetSize(PBoxMagnify.width,PBoxMagnify.height);
  MagnifyBitmap:=TBitmap.Create;
  MagnifyBitmap.SetSize(PBoxMagnify.width,PBoxMagnify.height);
  MagnifyScale:=1;
  //создаем холст сводного изображения
  SummaryIMG:=TImg.Create;
  ReadyToShowIMG:=Timg.Create;
  //создаем слои рисования и сразу их очищаем
  SetLength(Layers,3);
  for i:=0 to length(Layers)-1 do Layers[i]:=TImg.Create;
  //создаем буфер промежуточного рисования
  WorkIMG:=TImg.Create;
  //создаем буфер выделения
  SelIMG:=TImg.create;
  //Создаем пустой рабочий битмап как передаточный узел между TIMG и TCanvas
  ImageViewBitmap:=TBitmap.Create;
  //установка прозрачностей слоев рисования
  SetLength(LayersTransparency,length(Layers));
  //нулевой слой - непрозрачный, остальные - полностью прозрачные
  LayersTransparency[0]:=0;
  for i:=1 to length(Layers)-1 do LayersTransparency[i]:=1;
  RecalcBuffers(256,256);
  Button_DFT_paramsClick(self);
  //DontAddComposeToCollectionFlag:=true;
  //выключаем режим 3D
  mode_3d:=false;
  img3d:=Timg3d.create;
  //инструмент 3D-вращения (выключено)
  Move3dInWorkFlag:=false;
  //первое изображение - пустое
  ComposeImageView;
  //Загружем и прорисовываем изображение lenna.png
  Layers[0].LoadFromFile('lenna.png');
  Layers[0].ReSize(WorkIMG.width,WorkIMG.height);
  ComposeImageView;
  RefreshStatusBar;
  //Опорные точки
  for i:=0 to Length(Layers)-1 do
  begin
    SetLength(Layers[i].FixCoords,100);
    for j:=0 to length(Layers[i].FixCoords)-1 do
    begin
      Layers[i].FixCoords[j].x:=-1;
      Layers[i].FixCoords[j].y:=-1;
    end;
  end;

  GridCoords.RowCount:=length(Layers[0].FixCoords);
  for i:=0 to length(Layers[0].FixCoords)-1 do
  begin
    GridCoords.Cells[0,i]:=IntToStr(i);
    GridCoords.Cells[1,i]:=IntToStr(Layers[LayerCode].FixCoords[i].x);
    GridCoords.Cells[2,i]:=IntToStr(Layers[LayerCode].FixCoords[i].y);
  end;

  //векторы
  for i:=0 to Length(Layers)-1 do
  begin
    SetLength(Layers[i].Vectors,100);
    for j:=0 to length(Layers[i].Vectors)-1 do
    begin
      Layers[i].Vectors[j].x:=-1;
      Layers[i].Vectors[j].y:=-1;
    end;
  end;

  GridVectors.RowCount:=length(Layers[0].Vectors);
  for i:=0 to length(Layers[0].Vectors)-1 do
  begin
    GridVectors.Cells[0,i]:=IntToStr(i);
    GridVectors.Cells[1,i]:=IntToStr(Layers[LayerCode].Vectors[i].x);
    GridVectors.Cells[2,i]:=IntToStr(Layers[LayerCode].Vectors[i].y);
  end;
end;

//если изменено содержимое таблицы опорных точек, то изменить массив опорных точек
procedure TForm1.GridCoordsEditingDone(Sender: TObject);
var i:integer;
begin
  //for i:=0 to GridCoords.RowCount-1 do
  //begin
  //  if mode_3d then
  //  begin
  //    if GridCoords.Cells[1,i]<>'' then img3d.coords[i].x:=StrToFloat(GridCoords.Cells[1,i]);
  //    if GridCoords.Cells[2,i]<>'' then img3d.coords[i].y:=StrToFloat(GridCoords.Cells[2,i]);
  //    if GridCoords.Cells[3,i]<>'' then img3d.coords[i].z:=StrToFloat(GridCoords.Cells[3,i]);
  //  end else
  //  begin
  //    if GridCoords.Cells[1,i]<>'' then Layers[LayerCode].FixCoords[i].x:=StrToInt(GridCoords.Cells[1,i]);
  //    if GridCoords.Cells[2,i]<>'' then Layers[LayerCode].FixCoords[i].y:=StrToInt(GridCoords.Cells[2,i]);
  //  end;
  //end;
  //if mode_3d then begin img3d.Draw3dToImg(Layers[0],1,true); ComposeImageView; end;
end;

//если изменено содержимое таблицы векторов, то изменить массив опорных точек
procedure TForm1.GridVectorsEditingDone(Sender: TObject);
var i:integer;
begin
  //for i:=0 to GridVectors.RowCount-1 do
  //begin
  //  if mode_3d then
  //  begin
  //    if GridVectors.Cells[1,i]<>'' then img3d.trios[i].p1:=StrToInt(GridVectors.Cells[1,i]);
  //    if GridVectors.Cells[2,i]<>'' then img3d.trios[i].p2:=StrToInt(GridVectors.Cells[2,i]);
  //    if GridVectors.Cells[3,i]<>'' then img3d.trios[i].p3:=StrToInt(GridVectors.Cells[3,i]);
  //  end else
  //  begin
  //    if GridVectors.Cells[1,i]<>'' then Layers[LayerCode].Vectors[i].x:=StrToInt(GridVectors.Cells[1,i]);
  //    if GridVectors.Cells[2,i]<>'' then Layers[LayerCode].Vectors[i].y:=StrToInt(GridVectors.Cells[2,i]);
  //  end;
  //end;
  //if mode_3d then begin img3d.Draw3dToImg(Layers[0],1,true); ComposeImageView; end;
end;

procedure TForm1.ButtonFilterKoeffClick(Sender: TObject);
var k:real;
begin
  k:=StrToFloat(EditFilterZnam.text);
  if k<>0 then
  begin
  MatrixFilter_k11:=StrToFloat(GridFilterKoeff.Cells[0,0])/k;
  MatrixFilter_k12:=StrToFloat(GridFilterKoeff.Cells[1,0])/k;
  MatrixFilter_k13:=StrToFloat(GridFilterKoeff.Cells[2,0])/k;
  MatrixFilter_k21:=StrToFloat(GridFilterKoeff.Cells[0,1])/k;
  MatrixFilter_k22:=StrToFloat(GridFilterKoeff.Cells[1,1])/k;
  MatrixFilter_k23:=StrToFloat(GridFilterKoeff.Cells[2,1])/k;
  MatrixFilter_k31:=StrToFloat(GridFilterKoeff.Cells[0,2])/k;
  MatrixFilter_k32:=StrToFloat(GridFilterKoeff.Cells[1,2])/k;
  MatrixFilter_k33:=StrToFloat(GridFilterKoeff.Cells[2,2])/k;
  end;
end;

//Принудительная переустановка числа опорных точек слоя
procedure TForm1.ButtonFixCoordsNumClick(Sender: TObject);
var i,n,n_orig:integer; tmp:array of TPoint; tmp_3d:array of tvector3;
begin
  if mode_3d then
  begin
    n_orig:=GridCoords.RowCount; //(img3d.coords);
    SetLength(tmp_3d,n_orig);
    for i:=0 to n_orig-1 do //tmp_3d[i]:=img3d.Coords[i];
    begin
      if GridCoords.Cells[1,i]<>'' then tmp_3d[i].x:=StrToFloat(GridCoords.Cells[1,i]);
      if GridCoords.Cells[2,i]<>'' then tmp_3d[i].y:=StrToFloat(GridCoords.Cells[2,i]);
      if GridCoords.Cells[3,i]<>'' then tmp_3d[i].z:=StrToFloat(GridCoords.Cells[3,i]);
    end;
    n:=StrToInt(EditFixCoordsNum.text);
    SetLength(img3d.Coords,n); img3d.n_coords:=n;
    if n_orig>n then n_orig:=n;
    for i:=0 to n_orig-1 do img3d.coords[i]:=tmp_3d[i];
    for i:=n_orig to n-1 do
    begin
      img3d.Coords[i].x:=0;
      img3d.Coords[i].y:=0;
      img3d.Coords[i].z:=0;
    end;
    Setlength(tmp_3d,0);
    img3dToGrids;
    img3d.Draw3dToImg(Layers[0],1,true);
    ComposeImageView;
  end else
  begin
    n_orig:=GridCoords.RowCount; //length(Layers[LayerCode].FixCoords);
    SetLength(tmp,n_orig);
    for i:=0 to n_orig-1 do //tmp[i]:=Layers[LayerCode].FixCoords[i];
    begin
      if GridCoords.Cells[1,i]<>'' then tmp[i].x:=StrToInt(GridCoords.Cells[1,i]);
      if GridCoords.Cells[2,i]<>'' then tmp[i].y:=StrToInt(GridCoords.Cells[2,i]);
    end;
    n:=StrToInt(EditFixCoordsNum.text);
    SetLength(Layers[LayerCode].FixCoords,n);
    if n_orig>n then n_orig:=n;
    for i:=0 to n_orig-1 do Layers[LayerCode].FixCoords[i]:=tmp[i];
    for i:=n_orig to n-1 do
    begin
      Layers[LayerCode].FixCoords[i].x:=-1;
      Layers[LayerCode].FixCoords[i].y:=-1;
    end;
    Setlength(tmp,0);
    FixCoordsToGrids;
  end;
end;

//принудительная переустановка числа векторов слоя
procedure TForm1.ButtonVectorsNumClick(Sender: TObject);
var i,n,n_orig:integer; tmp:array of TPoint; tmp_trios:array of ttrio;
begin
  if mode_3d then
  begin
    n_orig:=GridVectors.RowCount; //length(img3d.trios);
    SetLength(tmp_trios,n_orig);
    for i:=0 to n_orig-1 do //tmp_trios[i]:=img3d.trios[i];
    begin
      if GridVectors.Cells[1,i]<>'' then tmp_trios[i].p1:=StrToInt(GridVectors.Cells[1,i]);
      if GridVectors.Cells[2,i]<>'' then tmp_trios[i].p2:=StrToInt(GridVectors.Cells[2,i]);
      if GridVectors.Cells[3,i]<>'' then tmp_trios[i].p3:=StrToInt(GridVectors.Cells[3,i]);
      tmp_trios[i].c1:=255; tmp_trios[i].c2:=255; tmp_trios[i].c3:=255;
    end;
    n:=StrToInt(EditVectorsNum.text);
    SetLength(img3d.trios,n); img3d.n_trios:=n;
    if n_orig>n then n_orig:=n;
    for i:=0 to n_orig-1 do img3d.trios[i]:=tmp_trios[i];
    for i:=n_orig to n-1 do
    begin
      img3d.trios[i].p1:=0;
      img3d.trios[i].p2:=0;
      img3d.trios[i].p3:=0;
      img3d.trios[i].c1:=255;
      img3d.trios[i].c2:=255;
      img3d.trios[i].c3:=255;
    end;
    Setlength(tmp_trios,0);
    img3dToGrids;
    img3d.Draw3dToImg(Layers[0],1,true);
    ComposeImageView;
  end else
  begin
    n_orig:=GridVectors.RowCount; //length(Layers[LayerCode].Vectors);
    SetLength(tmp,n_orig);
    for i:=0 to n_orig-1 do //tmp[i]:=Layers[LayerCode].Vectors[i];
    begin
      if GridVectors.Cells[1,i]<>'' then tmp[i].x:=StrToInt(GridVectors.Cells[1,i]);
      if GridVectors.Cells[2,i]<>'' then tmp[i].y:=StrToInt(GridVectors.Cells[2,i]);
    end;
    n:=StrToInt(EditVectorsNum.text);
    SetLength(Layers[LayerCode].Vectors,n);
    if n_orig>n then n_orig:=n;
    for i:=0 to n_orig-1 do Layers[LayerCode].Vectors[i]:=tmp[i];
    for i:=n_orig to n-1 do
    begin
      Layers[LayerCode].Vectors[i].x:=-1;
      Layers[LayerCode].Vectors[i].y:=-1;
    end;
    Setlength(tmp,0);
    FixCoordsToGrids;
  end;
end;

//принудительная установка некоторых параметров DFT
procedure TForm1.Button_DFT_paramsClick(Sender: TObject);
begin
  global_dft_width:=StrToInt(Edit_DFT_width.text);
  global_dft_height:=StrToInt(Edit_DFT_height.text);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  global_dft_width:=SelIMG.dft_width;
  global_DFT_height:=SelIMG.dft_height;
  Edit_DFT_width.text:=IntToStr(global_dft_width);
  Edit_DFT_height.text:=IntToStr(global_dft_height);
end;

procedure TForm1.ButtonAffineKoeffClick(Sender: TObject);
begin
  Affine_a11:=StrToFloat(GridAffineKoeff.Cells[0,0]);
  Affine_a12:=StrToFloat(GridAffineKoeff.Cells[1,0]);
  Affine_a21:=StrToFloat(GridAffineKoeff.Cells[0,1]);
  Affine_a22:=StrToFloat(GridAffineKoeff.Cells[1,1]);
  Affine_a31:=StrToFloat(GridAffineKoeff.Cells[0,2]);
  Affine_a32:=StrToFloat(GridAffineKoeff.Cells[1,2]);
end;

//Настройка подсистемы распознавания образов
procedure TForm1.ButtonAreasParamsClick(Sender: TObject);
begin
  area_min_pixels:=StrToInt(EditAreasMinPixels.text);
  area_contrast_level:=StrToInt(EditAreasContrast.text);
  vector_min_d:=StrToInt(EditVectorMin.text);
end;

//первичное действие пользователя над окном просмотра части изображения
//нажата какая-то кнопка мыши, возможно с добавчной клавишей CTRL, ALT или SHIFT
procedure TForm1.ImageViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  //сбрасываем все флаги, которые были актуальны при движении мышиного курсора
  //над окном просмотра части изображения
  ImageViewShiftFlag:=false;
  InstrumentInWorkFlag:=false;
  SelectionToolInWorkFlag:=false;
  TranslateToolInWorkFlag:=false;
  RotateToolInWorkFlag:=false;
  ScaleToolInWorkFlag:=false;
  Move3dInWorkFlag:=false;

  //запоминаем код нажатой на мыше кнопки
  MouseButton:=ord(Button);
  //перемещаем стек координат мышиного курсора
  for i:=length(MouseCoords)-1 downto 1 do MouseCoords[i]:=MouseCoords[i-1];
  MouseCoords[0].X:=X-SummaryIMG.parent_x0;
  MouseCoords[0].Y:=Y-SummaryIMG.parent_y0;

  //предполагаем, что пользователь будет работать инструментом рисования
  InstrumentInWorkFlag:=true;
  //если у пользователя другие намерения, то выясняем что именно он хочет
  //при этом флаг намерения использования инструмента рисования сбрасываем
  //ПКМ - сдвиг окна просмотра части изображения
  if (Button=mbRight)and(not(ssShift in Shift))and(not(ssCtrl in Shift)) then
      begin ImageViewShiftFlag:=true; InstrumentInWorkFlag:=false; end;
  //Если включен режим 3D
  if (Button=mbLeft) and mode_3d then
      begin Move3dInWorkFlag:=true; InstrumentInWorkFlag:=false; end;

  //SHIFT+ЛКМ - выделение участка изображения
  if (Button=mbLeft)and(ssShift in Shift)and(not(ssCtrl in Shift)) then
  begin SelectionToolInWorkFlag:=true; InstrumentInWorkFlag:=false; end;
  //CTRL+ЛКМ - перемещение (копирование) выделенного участка изображения
  if (Button=mbLeft)and(ssCtrl in Shift)and(not(ssShift in Shift)) then
  begin TranslateToolInWorkFlag:=true; InstrumentInWorkFlag:=false; end;
  //SHIFT+ПКМ - вращение выделенного участка изображения
  if (Button=mbRight)and(ssShift in Shift)and(not(ssCtrl in Shift)) then
  begin RotateToolInWorkFlag:=true; InstrumentInWorkFlag:=false; end;
  //CTRL+ПКМ - масштабирование выделенного участка изображения
  if (Button=mbRight)and(ssCtrl in Shift)and(not(ssShift in Shift)) then
  begin ScaleToolInWorkFlag:=true; InstrumentInWorkFlag:=false; end;

  //настраиваем промежуточный буфер
  WorkIMG.clrscr(-1);
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  //если пользователь хочет поработать инструментом рисования, то
  //в зависимости от выбранного инструмента делаем предобработку
  if InstrumentInWorkFlag=true then
  begin
    //анализируем, что именно нужно сделать для конкретного инструмента рисования
    case InstrumentCode of
    1: begin //точка
         WorkIMG.FillRect(MouseCoords[0].X-PenSize div 2,
                                MouseCoords[0].Y-PenSize div 2,
                                MouseCoords[0].X+PenSize div 2,
                                MouseCoords[0].Y+PenSize div 2,
                                PenColor);
       end;
    5: begin  //текст
          TextToRender:=InputBox('Введите текст','','');
          if TextToRender<>'' then
          begin
          AddNewImageToCollection(Layers[LayerCode]); DrawCollectionBox;
          Layers[LayerCode].TextOut(MouseCoords[0].X,MouseCoords[0].Y,PenColor,TextToRender);
          end;
       end;
    7: begin //заливка
          Layers[LayerCode].CloneToIMG(WorkIMG);
          WorkIMG.FloodFill(MouseCoords[0].X,MouseCoords[0].Y,
                           WorkIMG.GetPixel(MouseCoords[0].X,MouseCoords[0].Y),
                           PenColor);
        end;
    6: begin //кисточка
         for i:=1 to PenSize do
           WorkIMG.Ellipse(MouseCoords[0].X,MouseCoords[0].Y,i div 2,i div 2, PenColor);
       end;
    end;
    //отрисовываем содержимое буферов
    ComposeImageView;
    RefreshStatusBar;
  end;
end;

//отработка перемещения мышиного курсора над окном просмотра части изображения
procedure TForm1.ImageViewMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var tmp_IMG:TIMG;
    i,tmp_x0,tmp_y0:integer;
    k_scale:real;
    tmp_boolean:boolean;
begin
  ////заносим координаты мышиного курсора в стек координат мышиного курсора
  MouseCoords[0].X:=X-SummaryIMG.parent_x0;
  MouseCoords[0].Y:=Y-SummaryIMG.parent_y0;
  if MouseCoords[0].X<0 then MouseCoords[0].X:=0;
  if MouseCoords[0].X>=SummaryIMG.width then MouseCoords[0].X:=SummaryIMG.width-1;
  if MouseCoords[0].Y<0 then MouseCoords[0].Y:=0;
  if MouseCoords[0].Y>=SummaryIMG.height then MouseCoords[0].Y:=SummaryIMG.height-1;
  //формируем изображение лупы
  DrawMagnifyBox(MouseCoords[0].x,MouseCoords[0].y,MagnifyScale,SummaryIMG);
  //пересчитываем цветовые модели
  RefreshStatusBar;
  //если активирована функция перемещения окна просмотра, то
  if ImageViewShiftFlag=true then
  begin
    SummaryIMG.parent_x0:=SummaryIMG.parent_x0+MouseCoords[0].X-MouseCoords[1].X;
    SummaryIMG.parent_y0:=SummaryIMG.parent_y0+MouseCoords[0].Y-MouseCoords[1].Y;
    //отрисовка
    ImageView.Canvas.Brush.Style:=bsSolid;
    ImageView.Canvas.Brush.Color:=clGray;
    ImageView.Canvas.FillRect(0,0,ImageView.width,SummaryIMG.parent_y0);
    ImageView.Canvas.FillRect(0,SummaryIMG.parent_y0+SummaryIMG.height,ImageView.width,ImageView.height);
    ImageView.Canvas.FillRect(0,SummaryIMG.parent_y0,SummaryIMG.parent_x0,SummaryIMG.parent_y0+SummaryIMG.height);
    ImageView.Canvas.FillRect(SummaryIMG.parent_x0+SummaryIMG.width,SummaryIMG.parent_y0,ImageView.Width,SummaryIMG.parent_y0+SummaryIMG.height);
    ImageView.Canvas.Draw(SummaryIMG.parent_x0,SummaryIMG.parent_y0,ImageViewBitmap);
    DrawSelectionFrame;
  end;

  //если включен режим трехмерного моделирования и 3D-вращений
  if Move3dInWorkFlag then
  begin
    if (MouseCoords[1].X-MouseCoords[0].X)>30 then img3d.rotate_xz(Pi/90);
    if (MouseCoords[1].X-MouseCoords[0].X)<-30 then img3d.rotate_xz(-Pi/90);
    if (MouseCoords[1].Y-MouseCoords[0].Y)>30 then img3d.rotate_yz(Pi/90);
    if (MouseCoords[1].Y-MouseCoords[0].Y)<-30 then img3d.rotate_yz(-Pi/90);
    //img3d.rotate_xz(-Pi*(MouseCoords[1].X-MouseCoords[0].X)/180);
    //img3d.rotate_yz(Pi*(MouseCoords[1].Y-MouseCoords[0].Y)/180);
    img3d.Draw3dToImg(WorkImg,1,true);
    //отрисовка
    tmp_boolean:=DontAddComposeToCollectionFlag;
    DontAddComposeToCollectionFlag:=true;
    DontComposeLayersFlag:=true;
    ComposeImageView;
    RefreshStatusBar;
    DontAddComposeToCollectionFlag:=tmp_boolean;
  end;

  //если активирован инструмент выделения, то
  if SelectionToolInWorkFlag=true then
  begin
    //пересчитываем ширину и высоту выделения
    SelIMG.width:=abs(MouseCoords[1].X-MouseCoords[0].X);
    SelIMG.height:=abs(MouseCoords[1].Y-MouseCoords[0].Y);
    //пересчитываем координаты левого верхнего угла выделения на холсте
    if MouseCoords[0].X<MouseCoords[1].X then SelIMG.parent_x0:=MouseCoords[0].X;
    if MouseCoords[0].X>MouseCoords[1].X then SelIMG.parent_x0:=MouseCoords[1].X;
    if MouseCoords[0].Y<MouseCoords[1].Y then SelIMG.parent_y0:=MouseCoords[0].Y;
    if MouseCoords[0].Y>MouseCoords[1].Y then SelIMG.parent_y0:=MouseCoords[1].Y;
    //сохраняем в буфер выделения выделенную область
    tmp_x0:=SelIMG.parent_x0; tmp_y0:=SelIMG.parent_y0;
    SelIMG.SetSize(SelImg.width,SelImg.height);
    SelIMG.parent_x0:=tmp_x0; SelIMG.parent_y0:=tmp_y0;
    SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
    //отрисовка
    DontComposeLayersFlag:=true;
    ComposeImageView;
    RefreshStatusBar;
  end;

  //если активирован инструмент переноса выделенной части изображения, то
  if TranslateToolInWorkFlag=true then
  begin
    WorkIMG.clrscr(-1);
    SelIMG.DrawToIMG(WorkIMG,
                     MouseCoords[0].X - SelIMG.width div 2,
                     MouseCoords[0].Y - SelIMG.height div 2);
    SelIMG.parent_x0:=MouseCoords[0].X-SelIMG.width div 2;
    SelIMG.parent_y0:=MouseCoords[0].Y-SelIMG.height div 2;
    if SelIMG.parent_x0<0 then SelIMG.parent_x0:=0;
    if SelIMG.parent_y0<0 then SelIMG.parent_y0:=0;
    if SelIMG.parent_x0+SelIMG.width>=WorkIMG.width then SelIMG.parent_x0:=WorkIMG.width-SelIMG.width-1;
    if SelIMG.parent_y0+SelIMG.height>=WorkIMG.height then SelIMG.parent_y0:=WorkIMG.height-SelIMG.height-1;
    //отрисовка
    DontComposeLayersFlag:=true;
    ComposeImageView;
    RefreshStatusBar;
  end;

  //если активирован инструмент вращения выделенной части изображения, то
  if RotateToolInWorkFlag=true then
  begin
    WorkIMG.clrscr(-1);
    SelIMG.RotateToImg(SelIMG.width div 2, SelIMG.height div 2,
                       SelIMG.parent_x0+SelIMG.width div 2,
                       SelIMG.parent_y0+SelIMG.height div 2,
                       (MouseCoords[0].X-MouseCoords[1].X)/SelIMG.width*2*Pi,
                       WorkIMG);
    //отрисовка
    DontComposeLayersFlag:=true;
    ComposeImageView;
    RefreshStatusBar;
  end;

  //если активирован инструмент масштабирования выделенной части изображения, то
  if ScaleToolInWorkFlag=true then
  begin
    WorkIMG.clrscr(-1);
    if SelIMG.height>0 then
       k_scale:=abs(MouseCoords[0].Y-MouseCoords[1].Y)/SelIMG.height
       else k_scale:=0;
    tmp_IMG:=TIMG.create;
    tmp_IMG.SetSize(trunc(k_scale*SelIMG.width),trunc(k_scale*SelIMG.height));
    SelIMG.ScaleToIMG(tmp_IMG);
    tmp_IMG.parent_x0:=SelIMG.parent_x0+(SelIMG.width div 2)-(tmp_IMG.width div 2);
    tmp_IMG.parent_y0:=SelIMG.parent_y0+(SelIMG.height div 2)-(tmp_IMG.height div 2);
    tmp_IMG.DrawToIMG(WorkIMG,tmp_IMG.parent_x0,tmp_IMG.parent_y0);
    tmp_IMG.done;
    //отрисовка
    DontComposeLayersFlag:=true;
    ComposeImageView;
    RefreshStatusBar;
  end;

  //если пользователь проявил намерение работать инструментом рисования, то
  if InstrumentInWorkFlag=true then
  begin
    //в зависимости от выбранного инструмента, рисуем на промежуточном буфере
    case InstrumentCode of
     1: begin //точка
          WorkIMG.clrscr(-1);
          WorkIMG.FillRect(MouseCoords[0].X-PenSize div 2,
                                 MouseCoords[0].Y-PenSize div 2,
                                 MouseCoords[0].X+PenSize div 2,
                                 MouseCoords[0].Y+PenSize div 2,
                                 PenColor);
        end;
     2: begin //отрезок
          WorkIMG.clrscr(-1);
          WorkIMG.Line(MouseCoords[0].X,MouseCoords[0].Y,
                       MouseCoords[1].X,MouseCoords[1].Y,
                       PenColor);
        end;
     3: begin //прямоугольник
          WorkIMG.clrscr(-1);
          WorkIMG.FrameRect(MouseCoords[0].X,MouseCoords[0].Y,
                            MouseCoords[1].X,MouseCoords[1].Y,
                            PenColor);
        end;
     4: begin //эллипс
          WorkIMG.clrscr(-1);
          WorkIMG.Ellipse((MouseCoords[0].X+MouseCoords[1].X)div 2,
                          (MouseCoords[0].Y+MouseCoords[1].Y)div 2,
                          abs((MouseCoords[0].X-MouseCoords[1].X)div 2),
                          abs((MouseCoords[0].Y-MouseCoords[1].Y)div 2),
                          PenColor);
        end;
     7: begin //заливка
          Layers[LayerCode].CloneToIMG(WorkIMG);
          WorkIMG.FloodFill(MouseCoords[0].X,MouseCoords[0].Y,
                            WorkIMG.GetPixel(MouseCoords[0].X,MouseCoords[0].Y),
                            PenColor);
         end;
     6: begin //кисточка
          for i:=1 to PenSize do
            WorkIMG.Ellipse(MouseCoords[0].X,MouseCoords[0].Y,i div 2,i div 2, PenColor);
        end;
     8: begin //окружность
          WorkIMG.clrscr(-1);
          WorkIMG.Circle(MouseCoords[1].X,MouseCoords[1].Y,
                          abs((MouseCoords[0].X-MouseCoords[1].X)div 2),
                          PenColor);
        end;
    end;
  //отрисовка
  DontComposeLayersFlag:=true;
  ComposeImageView;
  RefreshStatusBar;
  end;
end;

//завершающая фаза процесса рисования в окне просмотра части изображения
procedure TForm1.ImageViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    //если были 3D-вращения, то перерисовываем в лучшем качестве
    //if Move3dInWorkFlag then begin img3d.Draw3dToImg(WorkImg,2,true); Img3dToGrids; end;
  if Move3dInWorkFlag then begin img3d.Draw3dToImg(WorkImg,1,true); Img3dToGrids; end;
  //фиксируем результат на слое рисования из промежуточного буфера
  WorkIMG.CloneToIMG(Layers[LayerCode]);
  //сбрасываем все флаги, которые были актуальны при движении мышиного курсора
  //над окном просмотра части изображения
  InstrumentInWorkFlag:=false;
  TranslateToolInWorkFlag:=false;
  RotateToolInWorkFlag:=false;
  ScaleToolInWorkFlag:=false;
  Move3dInWorkFlag:=false;
  //отрисовка
  WorkIMG.clrscr(-1);
  ComposeImageView;
  RefreshStatusBar;
  //сбрасываем все флаги, которые были актуальны при движении мышиного курсора
  //над окном просмотра части изображения
  ImageViewShiftFlag:=false;
  SelectionToolInWorkFlag:=false;
  //отключаем код нажатой на мыше кнопки
  MouseButton:=-1;
end;

//обработка колеса мыши над полотном рисования (уменьшение 3D)
procedure TForm1.ImageViewMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var tmp_boolean:boolean;
begin
   if mode_3d then
   begin
        //Move3dInWorkFlag:=true;
        img3d.scale_x(0.95); img3d.scale_y(0.95); img3d.scale_z(0.95);
        img3d.Draw3dToImg(WorkImg,1,true);
        //отрисовка
        tmp_boolean:=DontAddComposeToCollectionFlag;
        DontAddComposeToCollectionFlag:=true;
        DontComposeLayersFlag:=true;
        ComposeImageView;
        RefreshStatusBar;
        DontAddComposeToCollectionFlag:=tmp_boolean;
   end;
end;

//обработка колеса мыши над полотном рисования (увеличение 3D)
procedure TForm1.ImageViewMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var tmp_boolean:boolean;
begin
   if mode_3d then
   begin
        //Move3dInWorkFlag:=true;
        img3d.scale_x(1.05); img3d.scale_y(1.05); img3d.scale_z(1.05);
        img3d.Draw3dToImg(WorkImg,1,true);
        //отрисовка
        tmp_boolean:=DontAddComposeToCollectionFlag;
        DontAddComposeToCollectionFlag:=true;
        DontComposeLayersFlag:=true;
        ComposeImageView;
        RefreshStatusBar;
        DontAddComposeToCollectionFlag:=tmp_boolean;
   end;
end;

//процедура обновления содержимого полотна рисования
procedure TForm1.ImageViewPaint(Sender: TObject);
begin
  DontAddComposeToCollectionFlag:=true;
  DontComposeLayersFlag:=true;
  ComposeImageView;
end;

//выбор и установка цвета рисования
procedure TForm1.LabelColorPenClick(Sender: TObject);
begin
    if PenColorDialog.Execute then
    begin
         PenColor:=PenColorDialog.Color;
         RefreshStatusBar;
    end;
end;

//установить активный слой рисования
procedure TForm1.LabelLayerCodeClick(Sender: TObject);
begin
  LayerCode:=StrToInt(InputBox('Номер активного слоя',
                               'Номер активного слоя=',
                               IntToStr(LayerCode)));
  if LayerCode<0 then LayerCode:=0;
  if LayerCode>=length(Layers) then LayerCode:=length(Layers)-1;
end;

//установить прозрачность текущего слоя рисования
procedure TForm1.LabelLayerTranspClick(Sender: TObject);
begin
  LayersTransparency[LayerCode]:=0.01*StrToInt(InputBox('Прозрачность слоя',
                                'Прозрачность (0 - абс. непрозрачно) в % =',
                                FloatToStr(100*LayersTransparency[LayerCode])));
  if LayersTransparency[LayerCode]<0 then LayersTransparency[LayerCode]:=0;
  if LayersTransparency[LayerCode]>1 then LayersTransparency[LayerCode]:=1;
end;

//Установка размера пера рисования
procedure TForm1.LabelPenSizeClick(Sender: TObject);
begin
  PenSize:=StrToInt(InputBox('Размер пера рисования',
                             'Введите размер пера в пикселах',
                             IntToStr(PenSize)));
  RefreshStatusBar;
end;

//Адаптивный медианный фильтр от соли и перца
procedure TForm1.MenuItemAdaptiveMedianFilterClick(Sender: TObject);
var i,n,FilterRadius:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterRadius:=StrToInt(InputBox('Радиус фильтрации','Введите радиус фильтрации','5'));
  N:=(Sender as TMenuItem).tag;
  for i:=1 to N do FilterAdaptiveMedian(SelIMG,FilterRadius);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//очистить синий канал цвета изображения
procedure TForm1.MenuItemBlueChannelCleanClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterColorCorrection(SelIMG, 1,1,0);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//центрирование 3D-модели
procedure TForm1.MenuItemCenter3DClick(Sender: TObject);
var i:integer; xc,yc,zc:real;
begin
  if img3d.n_coords>0 then
  begin
       xc:=0; yc:=0; zc:=0;
       for i:=0 to img3d.n_coords-1 do
       begin
            xc:=xc+img3d.coords[i].x;
            yc:=yc+img3d.coords[i].y;
            zc:=zc+img3d.coords[i].z;
       end;
       xc:=xc/img3d.n_coords;
       yc:=yc/img3d.n_coords;
       zc:=zc/img3d.n_coords;
       for i:=0 to img3d.n_coords-1 do
       begin
            img3d.coords[i].x:=img3d.coords[i].x-xc;
            img3d.coords[i].y:=img3d.coords[i].y-yc;
            img3d.coords[i].z:=img3d.coords[i].z-zc;
       end;
       //img3d.Draw3dToImg(Layers[LayerCode],2,true);
       img3d.Draw3dToImg(Layers[LayerCode],1,true);
       ComposeImageView;
  end;
end;

//Восстановление от соли и перца зашумленного изображения
procedure TForm1.MenuItemDePepperClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterDePepper(SelIMG,false);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

procedure TForm1.MenuItemDePepperShowClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterDePepper(SelIMG,true);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//загрузить изображение с масштабированием под размер текущего слоя
procedure TForm1.MenuItemFileOpenScaleClick(Sender: TObject);
var tmp_IMG:TIMG;
begin
  if OpenPictureDialog.Execute then
  begin
       ImageFilename:=OpenPictureDialog.filename;
       tmp_IMG:=TIMG.Create;
       tmp_IMG.LoadFromFile(ImageFilename);
       tmp_IMG.ScaleToIMG(Layers[LayerCode]);
       tmp_IMG.done;
       WorkIMG.clrscr(-1);
       ComposeImageView;
       RefreshStatusBar;
  end;
end;

//рисование фрактала Мандельброта
procedure TForm1.MenuItemFractalMandelbrotClick(Sender: TObject);
var n:integer; z_min,z_max:TComplex;
begin
  n:=StrToInt(InputBox('Фрактал Мандельброта','n=','255'));
  z_min.re:=StrToFloat(InputBox('Фрактал Мандельброта','x_min=','-2'));
  z_min.im:=StrToFloat(InputBox('Фрактал Мандельброта','y_min=','-1.25'));
  z_max.re:=StrToFloat(InputBox('Фрактал Мандельброта','x_max=','0.5'));
  z_max.im:=StrToFloat(InputBox('Фрактал Мандельброта','y_max=','1.25'));
  DrawFractalMandelbrot(SelIMG,z_min,z_max,n);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//генерация координатной модели куба
procedure TForm1.MenuItemGenerateCube3DClick(Sender: TObject);
begin
     img3d.SetParams(8,12);
     img3d.Coords[0].x:=-50; img3d.Coords[0].y:=-50; img3d.Coords[0].z:=-50;
     img3d.Coords[1].x:=50;  img3d.Coords[1].y:=-50; img3d.Coords[1].z:=-50;
     img3d.Coords[2].x:=-50; img3d.Coords[2].y:=50;  img3d.Coords[2].z:=-50;
     img3d.Coords[3].x:=50;  img3d.Coords[3].y:=50;  img3d.Coords[3].z:=-50;
     img3d.Coords[4].x:=-50; img3d.Coords[4].y:=-50; img3d.Coords[4].z:=50;
     img3d.Coords[5].x:=50;  img3d.Coords[5].y:=-50; img3d.Coords[5].z:=50;
     img3d.Coords[6].x:=-50; img3d.Coords[6].y:=50;  img3d.Coords[6].z:=50;
     img3d.Coords[7].x:=50;  img3d.Coords[7].y:=50;  img3d.Coords[7].z:=50;

     img3d.trios[0].p1:=0;   img3d.trios[0].p2:=1;   img3d.trios[0].p3:=2;
     img3d.trios[0].c1:=255; img3d.trios[0].c2:=255; img3d.trios[0].c3:=255;

     img3d.trios[1].p1:=1;   img3d.trios[1].p2:=3;   img3d.trios[1].p3:=2;
     img3d.trios[1].c1:=255; img3d.trios[1].c2:=255; img3d.trios[1].c3:=255;

     img3d.trios[2].p1:=1;   img3d.trios[2].p2:=5;   img3d.trios[2].p3:=3;
     img3d.trios[2].c1:=255; img3d.trios[2].c2:=255; img3d.trios[2].c3:=255;

     img3d.trios[3].p1:=5;   img3d.trios[3].p2:=7;   img3d.trios[3].p3:=3;
     img3d.trios[3].c1:=255; img3d.trios[3].c2:=255; img3d.trios[3].c3:=255;

     img3d.trios[4].p1:=2;   img3d.trios[4].p2:=3;   img3d.trios[4].p3:=6;
     img3d.trios[4].c1:=255; img3d.trios[4].c2:=255; img3d.trios[4].c3:=255;

     img3d.trios[5].p1:=3;   img3d.trios[5].p2:=7;   img3d.trios[5].p3:=6;
     img3d.trios[5].c1:=255; img3d.trios[5].c2:=255; img3d.trios[5].c3:=255;

     img3d.trios[6].p1:=0;   img3d.trios[6].p2:=4;   img3d.trios[6].p3:=1;
     img3d.trios[6].c1:=255; img3d.trios[6].c2:=255; img3d.trios[6].c3:=255;

     img3d.trios[7].p1:=5;   img3d.trios[7].p2:=4;   img3d.trios[7].p3:=1;
     img3d.trios[7].c1:=255; img3d.trios[7].c2:=255; img3d.trios[7].c3:=255;

     img3d.trios[8].p1:=0;   img3d.trios[8].p2:=2;   img3d.trios[8].p3:=4;
     img3d.trios[8].c1:=255; img3d.trios[8].c2:=255; img3d.trios[8].c3:=255;

     img3d.trios[9].p1:=2;   img3d.trios[9].p2:=6;   img3d.trios[9].p3:=4;
     img3d.trios[9].c1:=255; img3d.trios[9].c2:=255; img3d.trios[9].c3:=255;

     img3d.trios[10].p1:=4;   img3d.trios[10].p2:=6;   img3d.trios[10].p3:=5;
     img3d.trios[10].c1:=255; img3d.trios[10].c2:=255; img3d.trios[10].c3:=255;

     img3d.trios[11].p1:=6;   img3d.trios[11].p2:=7;   img3d.trios[11].p3:=5;
     img3d.trios[11].c1:=255; img3d.trios[11].c2:=255; img3d.trios[11].c3:=255;

     //img3d.Draw3dToImg(Layers[LayerCode],2,true);
     img3d.Draw3dToImg(Layers[LayerCode],1,true);
     Img3dToGrids;
     ComposeImageView;
end;

//генерация координатной модели тетраэдра
procedure TForm1.MenuItemGenerateTetraedr3DClick(Sender: TObject);
var R,h:real;
begin
  img3d.SetParams(4,4);
  R:=100*sqrt(6)/4; h:=100*sqrt(2/3);
  img3d.Coords[0].x:=0; img3d.Coords[0].y:=R; img3d.Coords[0].z:=R-h;
  img3d.Coords[1].x:=R*cos(Pi/6);  img3d.Coords[1].y:=R-h; img3d.Coords[1].z:=R-h;
  img3d.Coords[2].x:=-R*cos(Pi/6); img3d.Coords[2].y:=R-h;  img3d.Coords[2].z:=R-h;
  img3d.Coords[3].x:=0;  img3d.Coords[3].y:=0;  img3d.Coords[3].z:=R;

  img3d.trios[0].p1:=0;   img3d.trios[0].p2:=1;   img3d.trios[0].p3:=2;
  img3d.trios[0].c1:=255; img3d.trios[0].c2:=255; img3d.trios[0].c3:=255;

  img3d.trios[1].p1:=0;   img3d.trios[1].p2:=3;   img3d.trios[1].p3:=1;
  img3d.trios[1].c1:=255; img3d.trios[1].c2:=255; img3d.trios[1].c3:=255;

  img3d.trios[2].p1:=0;   img3d.trios[2].p2:=2;   img3d.trios[2].p3:=3;
  img3d.trios[2].c1:=255; img3d.trios[2].c2:=255; img3d.trios[2].c3:=255;

  img3d.trios[3].p1:=1;   img3d.trios[3].p2:=3;   img3d.trios[3].p3:=2;
  img3d.trios[3].c1:=255; img3d.trios[3].c2:=255; img3d.trios[3].c3:=255;

  //img3d.Draw3dToImg(Layers[LayerCode],2,true);
  img3d.Draw3dToImg(Layers[LayerCode],1,true);
  Img3dToGrids;
  ComposeImageView;
end;

//очистить зеленый канал цвета изображения
procedure TForm1.MenuItemGreenChannelCleanClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterColorCorrection(SelIMG, 1,0,1);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//аффинные преобразования на плоскости для области выделения
procedure TForm1.MenuItemAffinneClick(Sender: TObject);
var tmp_IMG:TIMG;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  tmp_IMG:=TImg.Create;
  tmp_IMG.SetSize(SelIMG.width,SelIMG.height);
  SelIMG.AffineTransform(tmp_IMG, SelIMG.width div 2, SelIMG.height div 2, 1,1,
              affine_a11,affine_a12,affine_a21,affine_a22,affine_a31,affine_a32);
  tmp_IMG.CloneToIMG(SelIMG);
  tmp_IMG.done;
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//вызов фильтра размытия изображения
procedure TForm1.MenuItemBlurClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterBlur(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//настройка яркости изображения (уменьшить)
procedure TForm1.MenuItemBrightnessDecreaseClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterBrightness(SelIMG, 0.9);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//настройка яркости изображения (увеличить)
procedure TForm1.MenuItemBrightnessIncreaseClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterBrightness(SelIMG, 1.1);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//рисование комплексной функции комплексного аргумента
procedure TForm1.MenuItemCFunctionClick(Sender: TObject);
var i:integer; z_min,z_max:TComplex; img_re,img_im:TIMG;
begin
  z_min.re:=StrToFloat(InputBox('Комплексная функция','z_min.re=','-5'));
  z_min.im:=StrToFloat(InputBox('Комплексная функция','z_min.im=','-5'));
  z_max.re:=StrToFloat(InputBox('Комплексная функция','z_max.re=','5'));
  z_max.im:=StrToFloat(InputBox('Комплексная функция','z_max.im=','5'));
  img_re:=TIMG.create;
  img_re.SetSize(WorkIMG.width,WorkIMG.height);
  img_re.name:='Re';
  img_im:=TIMG.create;
  img_im.SetSize(WorkIMG.width,WorkIMG.height);
  img_im.name:='Im';
  DrawCFunction(img_re,img_im,z_min,z_max);
  AddNewImageToCollection(img_re);
  AddNewImageToCollection(img_im);
  DrawCollectionBox;
  img_re.done;
  img_im.done;
end;

//очистка коллекции
procedure TForm1.MenuItemClearCollectionClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to high(Collection) do
  begin
    if Collection[i]<>nil then Collection[i].done;
    collection[i]:=nil;
  end;
  SetLength(Collection,0);
  DrawCollectionBox;
end;

//очистка матриц ДПФ
procedure TForm1.MenuItemFourieKoeffsCleanClick(Sender: TObject);
begin
  SelIMG.DFTclear;
end;

//рисование фрактала Жюлиа
procedure TForm1.MenuItemFractalJuliaClick(Sender: TObject);
var n:integer; z_min,z_max,c:TComplex;
begin
  n:=StrToInt(InputBox('Фрактал Жюлиа','n=','256'));
  c.re:=StrToFloat(InputBox('Фрактал Жюлиа','c.re=','0.28'));
  c.im:=StrToFloat(InputBox('Фрактал Жюлиа','c.im=','0.01'));
  z_min.re:=StrToFloat(InputBox('Фрактал Жюлиа','x_min=','-1'));
  z_min.im:=StrToFloat(InputBox('Фрактал Жюлиа','y_min=','-1'));
  z_max.re:=StrToFloat(InputBox('Фрактал Жюлиа','x_max=','1'));
  z_max.im:=StrToFloat(InputBox('Фрактал Жюлиа','y_max=','1'));
  DrawFractalJulia(SelIMG,z_min,z_max,c,n);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  Layers[LayerCode].name:=FloatToStr(c.re)+'+'+FloatToStr(c.im)+'i';
  ComposeImageView;
  Layers[LayerCode].name:='';
end;

procedure TForm1.MenuItemHighPassFourieClick(Sender: TObject);
var y,x:integer;
    new_DFT_x_num,new_DFT_y_num:integer;
    undo_red_DFT_f,undo_green_DFT_f,undo_blue_DFT_f:TIntegerComplexMatrix;
begin
  new_DFT_y_num:=StrToInt(InputBox('ВЧ-фильтр',
             'Очистить по вертикали коэффициентов Фурье в центре ДПФ-матрицы',
                            IntToStr(SelIMG.dft_height)));
  new_DFT_x_num:=StrToInt(InputBox('ВЧ-фильтр',
             'Очистить по горизонтали коэффициентов Фурье в центре ДПФ-матрицы',
                            IntToStr(SelIMG.dft_width)));

  SetLength(undo_red_DFT_f,SelIMG.dft_height,SelIMG.dft_width);
  SetLength(undo_green_DFT_f,SelIMG.dft_height,SelIMG.dft_width);
  SetLength(undo_blue_DFT_f,SelIMG.dft_height,SelIMG.dft_width);

      for y:=0 to SelIMG.dft_height-1 do
      for x:=0 to SelIMG.dft_width-1 do
      begin
         undo_red_dft_f[y,x]:=SelIMG.red_data_dft[y,x];
         undo_green_dft_f[y,x]:=SelIMG.green_data_dft[y,x];
         undo_blue_dft_f[y,x]:=SelIMG.blue_data_dft[y,x];
      end;

      for y:=0 to SelIMG.dft_height-1 do
      for x:=0 to SelIMG.dft_width-1 do
      begin
        SelIMG.red_data_dft[y,x].re:=0; SelIMG.red_data_dft[y,x].im:=0;
        SelIMG.green_data_dft[y,x].re:=0; SelIMG.green_data_dft[y,x].im:=0;
        SelIMG.blue_data_dft[y,x].re:=0; SelIMG.blue_data_dft[y,x].im:=0;
      end;

    for y:=new_DFT_y_num div 2 to SelIMG.dft_height-(new_DFT_y_num div 2)-1 do
    for x:=0 to SelIMG.dft_width-1 do
    begin
      SelIMG.red_data_dft[y,x]:=undo_red_dft_f[y,x];
      SelIMG.green_data_dft[y,x]:=undo_green_dft_f[y,x];
      SelIMG.blue_data_dft[y,x]:=undo_blue_dft_f[y,x];
    end;

    for y:=0 to SelIMG.dft_height-1 do
    for x:=new_DFT_x_num div 2 to SelIMG.dft_width-(new_DFT_x_num div 2)-1 do
    begin
      SelIMG.red_data_dft[y,x]:=undo_red_dft_f[y,x];
      SelIMG.green_data_dft[y,x]:=undo_green_dft_f[y,x];
      SelIMG.blue_data_dft[y,x]:=undo_blue_dft_f[y,x];
    end;

  MenuItemFourieSyntClick(self);

  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
  begin
     SelIMG.red_data_dft[y,x]:=undo_red_dft_f[y,x];
     SelIMG.green_data_dft[y,x]:=undo_green_dft_f[y,x];
     SelIMG.blue_data_dft[y,x]:=undo_blue_dft_f[y,x];
  end;

  SetLength(undo_red_DFT_f,0,0);
  SetLength(undo_green_DFT_f,0,0);
  SetLength(undo_blue_DFT_f,0,0);
end;

//интерпретировать изображение как множество мнимых частей синей ДПФ-матрицы
procedure TForm1.MenuItemIMGtoBlueImFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.blue_data_DFT[y,x].im:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//интерпретировать изображение как множество действительных частей синей ДПФ-матрицы
procedure TForm1.MenuItemIMGtoBlueReFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.blue_data_DFT[y,x].re:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//интерпретировать изображение как множество мнимых частей зеленой ДПФ-матрицы
procedure TForm1.MenuItemIMGtoGreenImFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.green_data_DFT[y,x].im:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//интерпретировать изображение как множество действительных частей зеленой ДПФ-матрицы
procedure TForm1.MenuItemIMGtoGreenReFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.green_data_DFT[y,x].re:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//интерпретировать изображение как множество мнимых частей красной ДПФ-матрицы
procedure TForm1.MenuItemIMGtoRedImFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.red_data_DFT[y,x].im:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//интерпретировать изображение как множество действительных частей красной ДПФ-матрицы
procedure TForm1.MenuItemIMGtoRedReFourieClick(Sender: TObject);
var tmp_img:TIMG; x,y:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  DFT_IMG_recombination(SelIMG);
  SelIMG.SetSizeDFT(global_dft_width,global_dft_height);
  tmp_img:=TIMG.create;
  tmp_img.SetSize(SelIMG.dft_width,SelIMG.dft_height);
  SelIMG.ScaleToImg(tmp_img);
  for y:=0 to SelIMG.dft_height-1 do
  for x:=0 to SelIMG.dft_width-1 do
    SelIMG.red_data_DFT[y,x].re:=tmp_img.GetPixel(x,y);
  tmp_img.done;
end;

//загрузка массива опорных точек из внешнего файла
procedure TForm1.MenuItemLoadFixCoordsClick(Sender: TObject);
var f:text; tmp:string; i,n:integer;
begin
  if OpenDialog1.execute then
  begin
    assignfile(f,OpenDialog1.FileName); reset(f);
    n:=0;
    while not(eof(f)) do begin n:=n+1; readln(f,tmp); end;
    reset(f);

    if mode_3d then
    begin
      SetLength(img3d.Coords,n); img3d.n_coords:=n;
      for i:=0 to n-1 do
        readln(f,img3d.Coords[i].x,img3d.Coords[i].y,img3d.Coords[i].z);
      CloseFile(f);
      img3dToGrids;
      img3d.Draw3dToImg(Layers[0],1,true);
      ComposeImageView;
    end else
    begin
      SetLength(Layers[LayerCode].FixCoords,n);
      for i:=0 to n-1 do
        readln(f,Layers[LayerCode].FixCoords[i].x,Layers[LayerCode].FixCoords[i].y);
      CloseFile(f);
      FixCoordsToGrids;
    end;
  end;
end;

//загрузка 3D-файла в формате STL
procedure TForm1.MenuItemLoadSTLClick(Sender: TObject);
begin
  if mode_3d then
     if OpenDialog1.execute then
     begin
       img3d.LoadFromStl(OpenDialog1.filename);
       Img3dToGrids;
       //img3d.Draw3dToImg(Layers[0],3,true);
       img3d.Draw3dToImg(Layers[0],1,true);
       ComposeImageView;
     end;
  if not(mode_3d) then MessageBox(0,'Включите режим 3D','Включите режим 3D',MB_OK);
end;

//загрузка массива векторов из внешнего файла
procedure TForm1.MenuItemLoadVectorsClick(Sender: TObject);
var f:text; tmp:string; i,n:integer;
begin
  if OpenDialog1.execute then
  begin
    assignfile(f,OpenDialog1.FileName); reset(f);
    n:=0;
    while not(eof(f)) do begin n:=n+1; readln(f,tmp); end;
    reset(f);

    if mode_3d then
    begin
      SetLength(img3d.trios,n); img3d.n_trios:=n;
      for i:=0 to n-1 do
      begin
        readln(f,img3d.trios[i].p1,img3d.trios[i].p2,img3d.trios[i].p3);
        img3d.trios[i].c1:=255; img3d.trios[i].c2:=255; img3d.trios[i].c3:=255;
      end;
      CloseFile(f);
      img3dToGrids;
      img3d.Draw3dToImg(Layers[0],1,true);
      ComposeImageView;
    end else
    begin
      SetLength(Layers[LayerCode].Vectors,n);
      for i:=0 to n-1 do
        readln(f,Layers[LayerCode].Vectors[i].x,Layers[LayerCode].Vectors[i].y);
      CloseFile(f);
      FixCoordsToGrids;
    end;
  end;
end;

//Низкочастотный фильтр (оставить коэффициенты в центре ДПФ-матрицы)
procedure TForm1.MenuItemLowPassFourieClick(Sender: TObject);
var y,x:integer;
    new_DFT_x_num,new_DFT_y_num:integer;
    undo_red_DFT_f,undo_green_DFT_f,undo_blue_DFT_f:TIntegerComplexMatrix;
begin
    new_DFT_y_num:=StrToInt(InputBox('НЧ-фильтр',
               'Оставить по вертикали коэффициентов Фурье в центре ДПФ-матрицы',
                              IntToStr(SelIMG.dft_height)));
    new_DFT_x_num:=StrToInt(InputBox('НЧ-фильтр',
               'Оставить по горизонтали коэффициентов Фурье в центре ДПФ-матрицы',
                              IntToStr(SelIMG.dft_width)));

    SetLength(undo_red_DFT_f,SelIMG.dft_height,SelIMG.dft_width);
    SetLength(undo_green_DFT_f,SelIMG.dft_height,SelIMG.dft_width);
    SetLength(undo_blue_DFT_f,SelIMG.dft_height,SelIMG.dft_width);

    for y:=0 to SelIMG.dft_height-1 do
    for x:=0 to SelIMG.dft_width-1 do
    begin
       undo_red_dft_f[y,x]:=SelIMG.red_data_dft[y,x];
       undo_green_dft_f[y,x]:=SelIMG.green_data_dft[y,x];
       undo_blue_dft_f[y,x]:=SelIMG.blue_data_dft[y,x];
    end;

    for y:=new_DFT_y_num div 2 to SelIMG.dft_height-(new_DFT_y_num div 2)-1 do
    for x:=0 to SelIMG.dft_width-1 do
    begin
      SelIMG.red_data_dft[y,x].re:=0; SelIMG.red_data_dft[y,x].im:=0;
      SelIMG.green_data_dft[y,x].re:=0; SelIMG.green_data_dft[y,x].im:=0;
      SelIMG.blue_data_dft[y,x].re:=0; SelIMG.blue_data_dft[y,x].im:=0;
    end;

    for y:=0 to SelIMG.dft_height-1 do
    for x:=new_DFT_x_num div 2 to SelIMG.dft_width-(new_DFT_x_num div 2)-1 do
    begin
      SelIMG.red_data_dft[y,x].re:=0; SelIMG.red_data_dft[y,x].im:=0;
      SelIMG.green_data_dft[y,x].re:=0; SelIMG.green_data_dft[y,x].im:=0;
      SelIMG.blue_data_dft[y,x].re:=0; SelIMG.blue_data_dft[y,x].im:=0;
    end;

    MenuItemFourieSyntClick(self);

    for y:=0 to SelIMG.dft_height-1 do
    for x:=0 to SelIMG.dft_width-1 do
    begin
       SelIMG.red_data_dft[y,x]:=undo_red_dft_f[y,x];
       SelIMG.green_data_dft[y,x]:=undo_green_dft_f[y,x];
       SelIMG.blue_data_dft[y,x]:=undo_blue_dft_f[y,x];
    end;

    SetLength(undo_red_DFT_f,0,0);
    SetLength(undo_green_DFT_f,0,0);
    SetLength(undo_blue_DFT_f,0,0);
end;

//матричный фильтр выделения контуров
procedure TForm1.MenuItemContourClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterContour(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//настройка контрастности изображения (уменьшить)
procedure TForm1.MenuItemContrastDecreaseClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterContrast(SelIMG, 0.9);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//настройка контрастности изображения (увеличить)
procedure TForm1.MenuItemContrastIncreaseClick(Sender: TObject);
var x,y,R,G,B:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterContrast(SelIMG, 1.1);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//слой0=слой0 xor слой1
procedure TForm1.MenuItemCryptClick(Sender: TObject);
var x,y:integer;
begin
  for y:=0 to Layers[0].height-1 do
  for x:=0 to Layers[0].width-1 do
    Layers[0].SetPixel(x,y,Layers[0].GetPixel(x,y) xor Layers[1].GetPixel(x,y));
  ComposeImageView;
end;

//копировать выделение из текущего слоя в буфер обмена
procedure TForm1.MenuItemEditCopyFromLayerClick(Sender: TObject);
begin
   SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
   SelIMG.CopyToClipboard;
end;

//копировать выделение из сводного изображения в буфер обмена
procedure TForm1.MenuItemEditCopyFromSummaryClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(SummaryIMG,SelIMG.parent_x0,SelIMG.parent_y0);
  SelIMG.CopyToClipboard;
end;

//копировать выделение в коллекцию
procedure TForm1.MenuItemEditCopyToCollectionClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(SummaryIMG,SelIMG.parent_x0,SelIMG.parent_y0);
  AddNewImageToCollection(SelIMG);
  DrawCollectionBox;
end;

//удалить выделенный кусок слоя
procedure TForm1.MenuItemEditEraseClick(Sender: TObject);
begin
  SelIMG.clrscr(0);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//вставить в текущий слой из буфера обмена
procedure TForm1.MenuItemEditPasteClick(Sender: TObject);
begin
  SelIMG.CopyFromClipboard;
  SelIMG.DrawToImg(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//Рисование неявной функции в области выделения
procedure TForm1.MenuItemFFunctionClick(Sender: TObject);
var xmin,xmax,ymin,ymax,epsilon:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  xmin:=StrToFloat(InputBox('Рисование неявно заданной функции','xmin=',FloatToStr(-10)));
  xmax:=StrToFloat(InputBox('Рисование неявно заданной функции','xmax=',FloatToStr(10)));
  ymin:=StrToFloat(InputBox('Рисование неявно заданной функции','ymin=',FloatToStr(-6)));
  ymax:=StrToFloat(InputBox('Рисование неявно заданной функции','ymax=',FloatToStr(6)));
  epsilon:=StrToFloat(InputBox('Рисование неявно заданной функции','epsilon=',FloatToStr(0.1)));
  DrawFFunction(SelIMG,xmin,xmax,ymin,ymax,epsilon,PenColor);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//фурье-анализ области выделения
procedure TForm1.MenuItemFourieAnalysisClick(Sender: TObject);
var img_re,img_im,img_amp:TIMG;
begin
  //расчет коэффициентов Фурье
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  Button_DFT_paramsClick(self);
  SelIMG.ImgToDFT;
  //визуализация коэффициентов фурье в виде изображений коллекции
  img_re:=TIMG.create;
  img_im:=TIMG.create;
  img_amp:=TIMG.create;
  FourieMatrixToIMG('R',SelIMG.red_data_DFT,img_re,img_im,img_amp);
  DFT_IMG_recombination(img_re);
  DFT_IMG_recombination(img_im);
  DFT_IMG_recombination(img_amp);
  AddNewImageToCollection(img_re);
  AddNewImageToCollection(img_im);
  AddNewImageToCollection(img_amp);

  FourieMatrixToIMG('G',SelIMG.green_data_DFT,img_re,img_im,img_amp);
  DFT_IMG_recombination(img_re);
  DFT_IMG_recombination(img_im);
  DFT_IMG_recombination(img_amp);
  AddNewImageToCollection(img_re);
  AddNewImageToCollection(img_im);
  AddNewImageToCollection(img_amp);

  FourieMatrixToIMG('B',SelIMG.blue_data_DFT,img_re,img_im,img_amp);
  DFT_IMG_recombination(img_re);
  DFT_IMG_recombination(img_im);
  DFT_IMG_recombination(img_amp);
  AddNewImageToCollection(img_re);
  AddNewImageToCollection(img_im);
  AddNewImageToCollection(img_amp);

  img_re.done;
  img_im.done;
  img_amp.done;
  DrawCollectionBox;

  //установка визуального контроля статистики DFT
  //Edit_DFT_width.text:=FloatToStr(r_DFT_min_re);
  //Edit_g_min_DFT_re.text:=FloatToStr(g_DFT_min_re);
  //Edit_b_min_DFT_re.text:=FloatToStr(b_DFT_min_re);
  //Edit_DFT_height.text:=FloatToStr(r_DFT_min_im);
  //Edit_g_min_DFT_im.text:=FloatToStr(g_DFT_min_im);
  //Edit_b_min_DFT_im.text:=FloatToStr(b_DFT_min_im);
  //
  //Edit_r_k_DFT_re.text:=FloatToStr(r_DFT_k_re);
  //Edit_g_k_DFT_re.text:=FloatToStr(g_DFT_k_re);
  //Edit_b_k_DFT_re.text:=FloatToStr(b_DFT_k_re);
  //Edit_r_k_DFT_im.text:=FloatToStr(r_DFT_k_im);
  //Edit_g_k_DFT_im.text:=FloatToStr(g_DFT_k_im);
  //Edit_b_k_DFT_im.text:=FloatToStr(b_DFT_k_im);
end;

//фурье-синтез области выделения
procedure TForm1.MenuItemFourieSyntClick(Sender: TObject);
begin
  SelIMG.DFTtoImg;
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//Рисование явной функции в области выделения
procedure TForm1.MenuItemFunctionClick(Sender: TObject);
var xmin,xmax:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  xmin:=StrToFloat(InputBox('Рисование явно заданной функции','xmin=',FloatToStr(-3*Pi)));
  xmax:=StrToFloat(InputBox('Рисование явно заданной функции','xmax=',FloatToStr(3*Pi)));
  DrawFunction(SelIMG,xmin,xmax,PenColor);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//руководство программиста
procedure TForm1.MenuItemHelpProgrammerClick(Sender: TObject);
begin
MessageBox(0,'Руководство программиста в разработке','Руководство программиста',0);
end;

//методические рекомендации
procedure TForm1.MenuItemHelpTeacherClick(Sender: TObject);
begin
MessageBox(0,'Методические рекомендации в разработке','Методические рекомендации',0);
end;

//Руководство пользователя
procedure TForm1.MenuItemHelpUserClick(Sender: TObject);
begin
MessageBox(0,'Руководство пользователя в разработке','Руководство пользователя',0);
end;

//выбор слоя рисования из меню
procedure TForm1.MenuItemLayer0Click(Sender: TObject);
var i:integer;
begin
    LayerCode:=(sender as TMenuItem).tag;
    RefreshStatusBar;

    GridCoords.RowCount:=length(Layers[LayerCode].FixCoords);
    for i:=0 to length(Layers[LayerCode].FixCoords)-1 do
    begin
      GridCoords.Cells[0,i]:=IntToStr(i);
      GridCoords.Cells[1,i]:=IntToStr(Layers[LayerCode].FixCoords[i].x);
      GridCoords.Cells[2,i]:=IntToStr(Layers[LayerCode].FixCoords[i].y);
    end;
end;

//загрузить "много" изображений в коллекцию (например, это эталоны распознавания)
procedure TForm1.MenuItemLoadCollectionClick(Sender: TObject);
var i:integer; img:TIMG;
begin
  If OpenPictureDialog.execute then
  begin
    img:=TImg.Create;
    for i:=0 to OpenPictureDialog.Files.Count-1 do
    begin
       img.name:='i_'+IntToStr(i);
       img.LoadFromFile(OpenPictureDialog.Files.Strings[i]);
       img.parent_x0:=0; img.parent_y0:=0;
       AddNewImageToCollection(img);
    end;
    img.done;
    DrawCollectionBox;
    RefreshStatusBar;
  end;
end;

//выбор типа лупы
procedure TForm1.MenuItemMagnify1Click(Sender: TObject);
begin
  MagnifyScale:=(sender as TMenuItem).tag;
end;

//повторить матричную фильтрацию при тех же самых коэффициентах
procedure TForm1.MenuItemMatrixFilterAgain1Click(Sender: TObject);
var i,N:longint;
begin
  N:=(Sender as TMenuItem).tag;
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  for i:=1 to N do FilterMatrix(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//Медианный фильтр
procedure TForm1.MenuItemMedianFilterClick(Sender: TObject);
var FilterRadius:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterRadius:=StrToInt(InputBox('Радиус фильтрации','Введите радиус фильтрации','3'));
  FilterMedian(SelIMG,FilterRadius);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//фильтр обращения цветов
procedure TForm1.MenuItemNegativeClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterNegative(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;


//зашумление выделенной области
procedure TForm1.MenuItemNoiseClick(Sender: TObject);
var NoiseLevel:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  NoiseLevel:=StrToFloat(InputBox('процент зашумления','Введите процент зашумления','100'));
  FilterNoise(SelIMG,NoiseLevel);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//зашумление пикселями черного цвета
procedure TForm1.MenuItemPepperClick(Sender: TObject);
var NoiseLevel:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  NoiseLevel:=StrToFloat(InputBox('процент зашумления','Введите процент зашумления','100'));
  FilterSaultPepper(SelIMG,NoiseLevel);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//рисование ломаной по таблице опорных точек
procedure TForm1.MenuItemPolygonFixCoordsClick(Sender: TObject);
var i,k,x1,y1,x2,y2:integer;
begin
  if length(Layers[LayerCode].FixCoords)>0 then
  begin
    //ищем первую точку с неотрицательными координатами (старт рисования)
    x1:=-1; y1:=-1; k:=0;
    while ((x1<0)or(y1<0))and(k<length(Layers[LayerCode].FixCoords)) do
    begin
      x1:=Layers[LayerCode].FixCoords[k].x;
      y1:=Layers[LayerCode].FixCoords[k].y;
      k:=k+1;
    end;
    //рисуем отрезки, "перепрыгивая" точки с отрицательными координатами
    for i:=k to length(Layers[LayerCode].FixCoords)-1 do
    begin
      x2:=Layers[LayerCode].FixCoords[i].x; y2:=Layers[LayerCode].FixCoords[i].y;
      if (x2>=0) and (y2>=0) then Layers[LayerCode].Line(x1,y1,x2,y2,PenColor);
      x1:=abs(x2); y1:=abs(y2);
    end;
  end;
  ComposeImageView;
end;

//рисование ломаной по таблице векторов
procedure TForm1.MenuItemPolygonVectorsClick(Sender: TObject);
var i,n,x1,y1,x2,y2,p1,p2:integer;
begin
  n:=length(Layers[LayerCode].FixCoords);
  for i:=0 to length(Layers[LayerCode].Vectors)-1 do
  begin
    p1:=Layers[LayerCode].Vectors[i].x;
    p2:=Layers[LayerCode].Vectors[i].y;
    if (p1>=0) and (p2>=0) and (p1<n) and (p2<n) then
    begin
      x1:=Layers[LayerCode].FixCoords[p1].x;
      y1:=Layers[LayerCode].FixCoords[p1].y;
      x2:=Layers[LayerCode].FixCoords[p2].x;
      y2:=Layers[LayerCode].FixCoords[p2].y;
      if (x1>=0) and (y1>=0) and (x2>=0) and (y2>=0) then
        Layers[LayerCode].Line(x1,y1,x2,y2,PenColor);
    end;
  end;
  ComposeImageView;
end;

//распечатка сводного изображения
procedure TForm1.MenuItemPrintClick(Sender: TObject);
var ScaleX,ScaleY: integer; PaperRect:TRect; bitmap:TBitmap;
begin
  if PrintPictureDialog.execute then
  begin
    bitmap:=TBitmap.Create;
    bitmap.SetSize(SummaryIMG.width,SummaryIMG.height);
    SummaryIMG.CloneImgToBitmap(bitmap);
    with Printer do
    begin
      ScaleX:= GetDeviceCaps(Printer.Canvas.Handle, logPixelsX) div PixelsPerInch;
      ScaleY:= GetDeviceCaps(Printer.Canvas.Handle, logPixelsY) div PixelsPerInch;
      BeginDoc;
        PaperRect:=Rect(0, 0, bitmap.Width * ScaleX, bitmap.Height * ScaleY);
        Canvas.StretchDraw(PaperRect, Bitmap);
      EndDoc;
    end;
    bitmap.free;
  end;
end;

//отрисовать опорные точки
procedure TForm1.MenuItemPsetFixCoordsClick(Sender: TObject);
var i,x,y:integer;
begin
  for i:=0 to length(Layers[LayerCode].FixCoords)-1 do
  begin
    x:=Layers[LayerCode].FixCoords[i].x;
    y:=Layers[LayerCode].FixCoords[i].y;
    if (x>=0)or(y>=0) then Layers[LayerCode].SetPixel(abs(x),abs(y),PenColor);
  end;
  ComposeImageView;
end;

//Определит пиковое соотношение сигнал/шум (слой 1 -оригинал, слой 0 - после обработки)
procedure TForm1.MenuItemPSNRClick(Sender: TObject);
var PSNR_r,PSNR_g,PSNR_b:real; S,s_r,s_g,s_b:string;
begin
     FilterPSNR(Layers[1],Layers[0],PSNR_r,PSNR_g,PSNR_b);
     s_r:='infinity'; s_g:='infinity'; s_b:='infinity';
     if PSNR_r<>-1 then s_r:=FloatToStr(trunc(PSNR_r*10)/10);
     if PSNR_g<>-1 then s_g:=FloatToStr(trunc(PSNR_g*10)/10);
     if PSNR_b<>-1 then s_b:=FloatToStr(trunc(PSNR_b*10)/10);
     S:='R канал: '+s_r+' Дб'+chr(13)+
        'G канал: '+s_g+' Дб'+chr(13)+
        'B канал: '+s_b+' Дб';
     MessageBox(0,Pchar(S),'Пиковое соотношение сигнал/шум',0);
end;

//распознавание выделенной области изображения
procedure TForm1.MenuItemRecognitionClick(Sender: TObject);
var NearestImage:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  //определяем наиболее похожий образ из коллекции
  NearestImage:=RecognitionImage(SelIMG,Collection,16,16);
  if NearestImage>=0 then
  begin
    //подписываем имя на холсте рисования
    WorkIMG.TextOut(SelIMG.parent_x0,SelIMG.parent_y0,clBlue,Collection[NearestImage].name);
    DontAddComposeToCollectionFlag:=true;
    ComposeImageView;
  end;
end;

//Очистить красный канал
procedure TForm1.MenuItemRedChannelCleanClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterColorCorrection(SelIMG, 0,1,1);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//зашумление пикселями белого цвета
procedure TForm1.MenuItemSaultClick(Sender: TObject);
var NoiseLevel:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  NoiseLevel:=StrToFloat(InputBox('процент зашумления','Введите процент зашумления','100'));
  FilterSault(SelIMG,NoiseLevel);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//зашумление пикселями белого и черного цвета
procedure TForm1.MenuItemSaultPepperClick(Sender: TObject);
var NoiseLevel:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  NoiseLevel:=StrToFloat(InputBox('процент зашумления','Введите процент зашумления','100'));
  FilterSaultPepper(SelIMG,NoiseLevel);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//сохранение коллекции
procedure TForm1.MenuItemSaveCollectionClick(Sender: TObject);
var i:integer;
begin
  if SelectDirectoryDialog.execute then
  for i:=0 to length(Collection)-1 do
    Collection[i].SaveToFile(SelectDirectoryDialog.FileName+PathDelim+Collection[i].name+'.jpg');
end;

//сохранение списка опорных точек в внешний файл
procedure TForm1.MenuItemSaveFixCoordsClick(Sender: TObject);
var f:text; i:integer;
begin
  if SaveDialog1.execute then
  begin
    AssignFile(f,SaveDialog1.FileName);
    rewrite(f);
    if mode_3d then
    begin
      for i:=0 to length(img3d.coords)-1 do
        writeln(f,img3d.coords[i].x:8:2,' ',img3d.coords[i].y:8:2,' ',img3d.coords[i].z:8:2);
    end else
    begin
      for i:=0 to length(Layers[LayerCode].FixCoords)-1 do
        writeln(f,Layers[LayerCode].FixCoords[i].x,' ',Layers[LayerCode].FixCoords[i].y);
    end;
    CloseFile(f);
  end;
end;

//сохранение 3d-модели в внешний файл формата STL
procedure TForm1.MenuItemSaveSTLClick(Sender: TObject);
begin
  if mode_3d then
     if SaveDialog1.execute then img3d.SaveToStl(SaveDialog1.filename);
  if not(mode_3d) then MessageBox(0,'Включите режим 3D','Включите режим 3D',MB_OK);
end;

//сохранение списка векторов в внешний файл
procedure TForm1.MenuItemSaveVectorsClick(Sender: TObject);
var f:text; i:integer;
begin
  if SaveDialog1.execute then
  begin
    AssignFile(f,SaveDialog1.FileName);
    rewrite(f);
    if mode_3d then
    begin
      for i:=0 to length(img3d.trios)-1 do
        writeln(f,img3d.trios[i].p1:8,' ',img3d.trios[i].p2:8,' ',img3d.trios[i].p3:8);
    end else
    begin
      for i:=0 to length(Layers[LayerCode].Vectors)-1 do
        writeln(f,Layers[LayerCode].Vectors[i].x,' ',Layers[LayerCode].Vectors[i].y);
    end;
    CloseFile(f);
  end;
end;

procedure TForm1.MenuItemSearchRegionsClick(Sender: TObject);
var i,images_num,old_collection_length:integer;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  old_collection_length:=length(collection);
  images_num:=DetectImages(area_min_pixels,area_contrast_level,SelIMG);
  for i:=old_collection_length to old_collection_length+images_num-1 do
  begin
    Collection[i].name:='i_'+IntToStr(i-old_collection_length);
    Collection[i].parent_x0:=Collection[i].parent_x0+SelIMG.parent_x0;
    Collection[i].parent_y0:=Collection[i].parent_y0+SelIMG.parent_y0;
  end;
  DrawCollectionBox;
  RefreshStatusBar;
end;

//Выделение всего холста
procedure TForm1.MenuItemSelectAllClick(Sender: TObject);
begin
  SelIMG.SetSize(SummaryIMG.width,SummaryIMG.height);
  SelIMG.parent_x0:=0; SelIMG.parent_y0:=0;
  SelIMG.DrawFromIMG(SummaryIMG,0,0);
  DontAddComposeToCollectionFlag:=true;
  ComposeImageView;
end;

//Матричный фильтр повышения резкости
procedure TForm1.MenuItemSharpenClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterSharpen(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//Рисование параметрически заданной функции
procedure TForm1.MenuItemTFunctionClick(Sender: TObject);
var tmin,tmax,dt:real;
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  tmin:=StrToFloat(InputBox('Рисование параметрически заданной функции','tmin=',FloatToStr(-Pi)));
  tmax:=StrToFloat(InputBox('Рисование парметрически заданной функции','tmax=',FloatToStr(Pi)));
  dt:=StrToFloat(InputBox('Рисование парметрически заданной функции','dt=',FloatToStr(0.01)));
  DrawTFunction(SelIMG,tmin,tmax,dt,PenColor);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView;
end;

//Обесцвечивание до ЧБ активного слоя изображения
//критерий обесцвечивания "зашит" в свойстве tag и задается при
//визуальном проектировании меню "обработка-->преобразование в ЧБ"
procedure TForm1.MenuItemThreshold0Click(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterThresold(SelIMG, (sender as TMenuItem).tag/100.0);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView
end;

//Обесцвечивание активного слоя изображения
procedure TForm1.MenuItemDesaturationClick(Sender: TObject);
begin
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  FilterDesaturation(SelIMG);
  SelIMG.DrawToIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  ComposeImageView
end;

//очистка активного слоя риcования
procedure TForm1.MenuItemEditClearClick(Sender: TObject);
begin
  Layers[LayerCode].clrscr(0);
  ComposeImageView;
end;

//подпрограмма выбора и установка размера холста рисования из меню
//размер холста "зашит" в свойстве tag и задается при
//визуальном проектировании меню "слой-->размер холста"
procedure TForm1.MenuItemLayerSize8x8Click(Sender: TObject);
var i,ImageSizeTag:integer;
begin
  ImageSizeTag:=(sender as TMenuItem).tag;
  case ImageSizeTag of
  1: SummaryIMG.ReSize(8,8);
  2: SummaryIMG.ReSize(8,16);
  3: SummaryIMG.ReSize(32,32);
  4: SummaryIMG.ReSize(64,64);
  5: SummaryIMG.ReSize(256,256);
  6: SummaryIMG.ReSize(256,192);
  7: SummaryIMG.ReSize(320,200);
  8: SummaryIMG.ReSize(320,240);
  9: SummaryIMG.ReSize(512,384);
  10: SummaryIMG.ReSize(512,512);
  11: SummaryIMG.ReSize(640,480);
  12: SummaryIMG.ReSize(800,600);
  13: SummaryIMG.ReSize(1024,768);
  end;
  RecalcBuffers(SummaryIMG.width,SummaryIMG.height);
  ComposeImageView;
  RefreshStatusBar;
end;

//подпрограмма вывода окна сведений о программе
procedure TForm1.MenuItemHelpAboutClick(Sender: TObject);
begin
  MessageBox(0,
             'Шаблон программ по дисциплине'+chr(13)+
             '"Компьютерная графика"'+chr(13)+
             'для студентов специальности'+chr(13)+
             '01.03.02 "Прикладная математика и информатика"'+chr(13)+
             ' '+chr(13)+
             'Условия распространения и использования:'+chr(13)+
             'свободное программное обеспечение'+chr(13)+
             '(Apache-2.0 лицензия)'+chr(13)+
             ' '+chr(13)+
             'автор: к.ф.-м.н. Ионисян А.С.'
             ,'О программе',0);
end;

//точка выхода из программы
procedure TForm1.MenuItemExitClick(Sender: TObject);
begin
  close;
end;

//подпрограмма выбора и загрузки внешнего графического файла в активный слой рисования
procedure TForm1.MenuItemFileOpenClick(Sender: TObject);
var tmp_IMG:TIMG;
begin
  if OpenPictureDialog.Execute then
  begin
       ImageFilename:=OpenPictureDialog.filename;
       tmp_IMG:=TIMG.Create;
       tmp_IMG.LoadFromFile(ImageFilename);
       RecalcBuffers(tmp_IMG.width,tmp_IMG.height);
       tmp_IMG.DrawToIMG(Layers[LayerCode],0,0);
       tmp_IMG.done;
       WorkIMG.clrscr(-1);
       ComposeImageView;
       RefreshStatusBar;
  end;
end;

//подпрограмма сохранения сводного изображения во внешний файл
procedure TForm1.MenuItemFileSaveClick(Sender: TObject);
begin
  if SavePictureDialog.Execute then
  begin
       ImageFilename:=SavePictureDialog.filename;
       SummaryIMG.SaveToFile(ImageFileName);
       RefreshStatusBar;
  end;
end;

//подпрограмма выбора инструмента рисования из меню
//код инструмента "зашит" в свойстве tag и задается при
//визуальном проектировании меню "инструменты"
procedure TForm1.MenuItemSetPixelClick(Sender: TObject);
begin
  LabelInstrumentName.Caption:='Инструмент: '+(Sender as TMenuItem).Caption;
  InstrumentCode:=(Sender as TMenuItem).tag;
end;

//подпрограмма выбора прозрачности активного слоя рисования из меню
//прозрачность в процентах "зашита" в свойстве tag и задается при
//визуальном проектировании меню "слой-->прозрачность слоя"
procedure TForm1.MenuItemTransp0Click(Sender: TObject);
begin
  LayersTransparency[LayerCode]:=0.01*(sender as TMenuItem).tag;
  DontAddComposeToCollectionFlag:=true;
  ComposeImageView;
  RefreshStatusBar;
end;

//векторизация изображения
procedure TForm1.MenuItemDetectBorderPixelsClick(Sender: TObject);
var i,points_num:integer; P:array of TPoint;
begin
  SetLength(P,Layers[LayerCode].width*Layers[LayerCode].height);
  SelIMG.DrawFromIMG(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
  points_num:=DetectBorderPixels(area_min_pixels,area_contrast_level,SelIMG,P);
  if points_num>length(Layers[LayerCode].FixCoords) then SetLength(Layers[LayerCode].FixCoords,points_num);
  for i:=0 to points_num-1 do Layers[LayerCode].FixCoords[i]:=P[i];
  Finalize(P);
  EditFixCoordsNum.text:=IntToStr(points_num);
  FixCoordsToGrids;
  ButtonFixCoordsNumClick(self);
end;

//Поиск векторов по массиву опорных точек для каждого образа
//с длиной векторов не менее чем VectorMinD
procedure TForm1.MenuItemVectorizeClick(Sender: TObject);
var i,vectors_num:integer; V:array of TPoint;
begin
  SetLength(V,Layers[LayerCode].width*Layers[LayerCode].height);
  vectors_num:=DetectVectors(Vector_min_d,Layers[LayerCode].FixCoords,V);
  if vectors_num>length(Layers[LayerCode].Vectors) then SetLength(Layers[LayerCode].Vectors,vectors_num);
  for i:=0 to vectors_num-1 do Layers[LayerCode].Vectors[i]:=V[i];
  Finalize(V);
  EditVectorsNum.text:=IntToStr(vectors_num);
  FixCoordsToGrids;
  ButtonVectorsNumClick(self);
end;

//Обработка нажатия кнопки включения/выключения 3D-режима
procedure TForm1.MenuItem_3D_on_offClick(Sender: TObject);
begin
     mode_3d:=not(mode_3d);
     if mode_3d then
     begin
          MenuItem_3D_on_off.Caption:='Выключить режим 3D';
          LabelVectorPTRS.Caption:='Треугольники';
          GridCoords.ColCount:=4;
          GridVectors.ColCount:=4;
          Img3dToGrids;
          img3d.Draw3dToImg(Layers[0],1,true);
          ComposeImageView;
     end;
     if not(mode_3d) then
     begin
          MenuItem_3D_on_off.Caption:='Включить режим 3D';
          LabelVectorPTRS.Caption:='отрезки (векторы)';
          GridCoords.ColCount:=3;
          GridVectors.ColCount:=3;
          FixCoordsToGrids;
     end;
     RefreshStatusBar;
end;

//реакция на движение мыши поверх коллекции изображений
procedure TForm1.PBoxCollectionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var img_num:integer; tmp_img:TIMG;
begin
  //определить номер изображения
  img_num:=(x div PBoxCollection.height)+FirstCollectionItem;

  if img_num<length(Collection) then
  begin
     //отрисовать его в окне лупы
    Collection[img_num].ScaleToIMG(MagnifyIMG);
    MagnifyIMG.CloneImgToBitmap(MagnifyBitmap);
    PBoxMagnify.Canvas.Draw(0,0,MagnifyBitmap);
    //если включен флаг показа на холсте, то отрисовать на холсте
    if CheckBoxShowImages.Checked then
    begin
      WorkIMG.clrscr(-1);
      tmp_IMG:=TIMG.Create;
      tmp_IMG.SetSize(Collection[img_num].width,Collection[img_num].height);
      tmp_IMG.clrscr(-1);
      Collection[img_num].CloneToImg(tmp_IMG);
      //для повышения наглядности сделаем инверсию цветов образа на холсте
      FilterNegative(tmp_IMG);
      tmp_IMG.DrawToImg(WorkIMG,Collection[img_num].parent_x0,Collection[img_num].parent_y0);
      tmp_IMG.done;
      //нарисуем красную рамочку вокруг образа
      WorkIMG.FrameRect(Collection[img_num].parent_x0, Collection[img_num].parent_y0,
                                 Collection[img_num].parent_x0+Collection[img_num].width,
                                 Collection[img_num].parent_y0+Collection[img_num].height,
                                 clRed);
      DontAddComposeToCollectionFlag:=true;
      ComposeImageView;
    end;
  end;
end;

//перенести изображение из коллекции на слой рисования
procedure TForm1.PBoxCollectionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var img_num,i:integer;
begin
  //определить номер изображения
  img_num:=(x div PBoxCollection.height)+FirstCollectionItem;
  if img_num<length(Collection) then
  begin
    //если была нажата ЛКМ, то отрисовать образ на выделенной области
    if Button=mbLeft then
    begin
      Collection[img_num].ScaleToImg(SelIMG);
      SelIMG.DrawToImg(Layers[LayerCode],SelIMG.parent_x0,SelIMG.parent_y0);
      DontAddComposeToCollectionFlag:=true;
      ComposeImageView;
    end;
    //если была нажата ПКМ, то удалить образ из коллекции
    if Button=mbRight then
    begin
      RemoveImageFromCollection(img_num);
      DrawCollectionBox;
      RefreshStatusBar;
    end;
  end;
end;

//перерисовка коллекции изображений
procedure TForm1.PBoxCollectionPaint(Sender: TObject);
begin
//  PBoxCollection.width:=Form1.Width;  //Возникает сильная утечка памяти ????
  DrawCollectionBox;
end;

//прокрутка изображений коллекции
procedure TForm1.ScrollBarCollectionChange(Sender: TObject);
begin
  ScrollBarCollection.max:=high(Collection);
  FirstCollectionItem:=ScrollBarCollection.position;
  DrawCollectionBox;
end;

end.

