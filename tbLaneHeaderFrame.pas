unit tbLaneHeaderFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Menus,
  tbBoardIntf, System.Actions, Vcl.ActnList;

type
  TtbLaneHeaderBuilder = class
    //class function GetLaneHeader(ALaneControls: TLaneControls): ItbLaneHeader;
  end;

type
  TFrameLaneHeader = class(TFrame, ItbLaneHeader)
    Label_Header: TLabel;
    GridPanel: TGridPanel;
    SpeedButton: TSpeedButton;
    PopupMenu1: TPopupMenu;
    MenuItem_AddTask: TMenuItem;
    ActionList1: TActionList;
    Action1: TAction;
    procedure SpeedButtonClick(Sender: TObject);
    procedure MenuItem_AddTaskClick(Sender: TObject);
  private
    FPopupMenu: TPopupMenu;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetLaneHeader: ItbLaneHeader;
    { ItbBoardHeader }
    procedure SetHeaderText(AValue: String);
    procedure SetHeaderParent(AValue: TWinControl; AAlign: TAlign);
  end;

implementation

{$R *.dfm}

uses Types, UITypes;

{ TFrameLaneHeader }

constructor TFrameLaneHeader.Create(AOwner: TComponent);
begin
  inherited;
  Label_Header.Font.Style := Label_Header.Font.Style + [fsBold];
  FPopupMenu := PopupMenu1;
end;

class function TFrameLaneHeader.GetLaneHeader: ItbLaneHeader;
begin
  Result := Create(nil);
end;

procedure TFrameLaneHeader.MenuItem_AddTaskClick(Sender: TObject);
begin
//
end;

procedure TFrameLaneHeader.SetHeaderParent(AValue: TWinControl; AAlign: TAlign);
begin
  Parent := AValue;
  Align := AAlign;
  Height := GridPanel.Height;
end;

procedure TFrameLaneHeader.SetHeaderText(AValue: String);
begin
  Label_Header.Caption := AValue;
end;

procedure TFrameLaneHeader.SpeedButtonClick(Sender: TObject);
var
  Pnt: TPoint;
  Btn: TSpeedButton;
begin
  Btn := Sender as TSpeedButton;
  if FPopupMenu <> nil then
  begin
    { TODO Calculate menu width }
    Pnt := Point(Btn.Left - 100, Btn.Top + Btn.Height);
    Pnt := Btn.Parent.ClientToScreen(Pnt);
    FPopupMenu.Popup(Pnt.X, Pnt.Y)
  end;
end;

end.
