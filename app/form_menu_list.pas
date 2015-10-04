(*
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

Copyright (c) Alexey Torgashin
*)
unit form_menu_list;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  LclType,
  LclProc,
  ATStringProc,
  ATSynEdit,
  ATListbox,
  proc_globdata,
  proc_colors;

type
  { TfmGotoList }

  TfmGotoList = class(TForm)
    List: TATListbox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListDrawItem(Sender: TObject; C: TCanvas; AIndex: integer;
      const ARect: TRect);
    procedure ListClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    ResultIndex: integer;
    Items: TStringlist;
  end;

var
  fmGotoList: TfmGotoList;

implementation

{$R *.lfm}

{ TfmGotoList }

procedure TfmGotoList.FormShow(Sender: TObject);
begin
  List.ItemCount:= Items.Count;
end;

procedure TfmGotoList.ListDrawItem(Sender: TObject; C: TCanvas; AIndex: integer;
  const ARect: TRect);
var
  cl: TColor;
  pnt: TPoint;
  //num: integer;
  str: atString;
begin
  if AIndex=List.ItemIndex then
    cl:= GetAppColor('ListSelBg')
  else
    cl:= List.Color;
  c.Brush.Color:= cl;
  c.Pen.Color:= cl;
  c.FillRect(ARect);
  c.Font.Color:= GetAppColor('ListFont');

  pnt:= Point(ARect.Left+4, ARect.Top+1);
  //num:= ptrint(Items.Objects[AIndex]);
  str:= Items[AIndex];
  c.TextOut(pnt.x, pnt.y, Utf8Encode(str));
end;

procedure TfmGotoList.ListClick(Sender: TObject);
begin
  ResultIndex:= List.ItemIndex;
  Close;
end;

procedure TfmGotoList.FormCreate(Sender: TObject);
begin
  List.Font.Name:= UiOps.VarFontName;
  List.Font.Size:= UiOps.VarFontSize;

  self.Color:= GetAppColor('ListBg');
  List.Color:= self.Color;

  self.Width:= UiOps.ListboxWidth;
  List.ItemHeight:= GetDefaultListItemHeight(Canvas);
  Items:= nil;
  ResultIndex:= -1;
end;

procedure TfmGotoList.FormDestroy(Sender: TObject);
begin
end;

procedure TfmGotoList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_down then
  begin
    if List.ItemIndex=List.ItemCount-1 then
      List.ItemIndex:= 0
    else
      List.ItemIndex:= List.ItemIndex+1;
    key:= 0;
  end;
  if key=vk_up then
  begin
    if List.ItemIndex=0 then
      List.ItemIndex:= List.ItemCount-1
    else
      List.ItemIndex:= List.ItemIndex-1;
    key:= 0;
  end;

  if key=VK_HOME then
  begin
    List.ItemIndex:= 0;
    key:= 0;
  end;
  if key=VK_END then
  begin
    List.ItemIndex:= List.ItemCount-1;
    key:= 0;
  end;

  if key=VK_ESCAPE then
  begin
    Close;
    key:= 0;
  end;
  if key=VK_RETURN then
  begin
    if (List.ItemIndex>=0) and (List.ItemCount>0) then
    begin
      ResultIndex:= List.ItemIndex;
      Close;
    end;
    key:= 0;
  end;
end;

end.
