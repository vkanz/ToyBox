unit tbTaskFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList,
  tbDomain, tbBoardIntf;

type
  TFrameTask = class(TFrame, ItbTaskCard)
    ControlList: TControlList;
  private
    FLane: TtbLane;
    procedure SetLane(AValue: TtbLane);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetTaskCard(AParent: TWinControl; ALane: TtbLane): ItbTaskCard;
  end;

implementation

{$R *.dfm}

{ TFrameTask }

constructor TFrameTask.Create(AOwner: TComponent);
begin
  inherited;
  with ControlList do
  begin
    AlignWithMargins := True;
    ItemColor := clBtnFace;
    ItemMargins.Left := 2;
    ItemMargins.Top := 2;
    ItemMargins.Right := 2;
    ItemMargins.Bottom := 2;
    ItemSelectionOptions.HotColorAlpha := 20;
    ItemSelectionOptions.SelectedColorAlpha := 30;
    ItemSelectionOptions.FocusedColorAlpha := 40;
  end;
end;

class function TFrameTask.GetTaskCard(AParent: TWinControl; ALane: TtbLane): ItbTaskCard;
var
  Instance: TFrameTask;
begin
  Instance := Create(nil);
  Instance.Parent := AParent;
  Instance.Align := alClient;
  Instance.SetLane(ALane);
  Result := Instance;
end;

procedure TFrameTask.SetLane(AValue: TtbLane);
begin
  FLane := AValue;
end;

end.
