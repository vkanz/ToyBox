unit tbLaneHeaderFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Menus,
  tbBoardIntf, tbBoard;

type
  TFrameLaneHeader = class(TFrame, ItbLaneHeader)
    Label_Header: TLabel;
    GridPanel: TGridPanel;
    SpeedButton: TSpeedButton;
    PopupMenu1: TPopupMenu;
    MenuItem_AddTask: TMenuItem;
    procedure SpeedButtonClick(Sender: TObject);
    procedure MenuItem_AddTaskClick(Sender: TObject);
  private
    FPopupMenu: TPopupMenu;
    FLaneControls: TLaneControls;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetLaneHeader(ALaneControls: TLaneControls): ItbLaneHeader;
    { ItbBoardHeader }
    procedure SetText(AValue: String);
  end;

implementation

{$R *.dfm}

uses Types, UITypes;

{ TFrameLaneHeader }

constructor TFrameLaneHeader.Create(AOwner: TComponent);
begin
  inherited;
  FPopupMenu := PopupMenu1;
end;

class function TFrameLaneHeader.GetLaneHeader(ALaneControls: TLaneControls): ItbLaneHeader;
var
  Instance: TFrameLaneHeader;
begin
  Instance := Create(nil);
  Instance.FLaneControls := ALaneControls;
  Instance.Parent := ALaneControls.Panel;
  Instance.Align := alTop;
  Instance.Height := Instance.GridPanel.Height;
  Instance.Label_Header.Font.Style := Instance.Label_Header.Font.Style + [fsBold];
  Result := Instance;
end;

procedure TFrameLaneHeader.MenuItem_AddTaskClick(Sender: TObject);
begin
//
end;

procedure TFrameLaneHeader.SetText(AValue: String);
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
