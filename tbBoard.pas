unit tbBoard;

interface

uses Vcl.ExtCtrls, Classes, Generics.Collections, Vcl.ControlList, Vcl.StdCtrls, Controls,
  tbDomain, tbBoardIntf;

type
  TtbBoardBuilder = class
  public
    class procedure BuildDefault(ATarget: TtbBoard);
  end;

type
  TPanelHeader = class(TPanel, ItbLaneHeader)
  public
    class function GetLaneHeader(AParent: TWinControl): ItbLaneHeader;
    { ItbLaneHeader }
    procedure SetText(AValue: String);
  end;

type
  TLaneControls = class;

  TLaneShowControl = procedure (ASender: TLaneControls; const AIndex: Integer; AControl: TControl;
   var AVisible: Boolean) of object;

  TLaneControls = class
  private
    FOnShowControl: TLaneShowControl;
  public
    Lane: TtbLane;
    Panel: TPanel;
    Header: ItbLaneHeader;
    ControlList: TControlList;
    Title: TLabel;
    Text: TLabel;
    procedure HandleControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
    property OnShowControl: TLaneShowControl read FOnShowControl write FOnShowControl;
  end;

type
  TtbBoardAdapter = class(TComponent)
  private
    FGridPanel: TGridPanel;
    FBoard: TtbBoard;
    FLanes: TObjectList<TLaneControls>;
    FDomain: TtbDomain;
  protected
    procedure PrepareGrid;
    procedure HandleLaneShowControl(ASender: TLaneControls; const AIndex: Integer; AControl: TControl;
      var AVisible: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw;
    {}
    property GridPanel: TGridPanel read FGridPanel write FGridPanel;
    property Board: TtbBoard read FBoard write FBoard;
    property Domain: TtbDomain read FDomain write FDomain;
  end;

implementation

uses Vcl.Graphics, System.UITypes, SysUtils,
  tbLaneHeaderFrame;

{ TtbBoardBuilder }

class procedure TtbBoardBuilder.BuildDefault(ATarget: TtbBoard);
begin
  ATarget.Clear;
  ATarget.Lanes.Add(TtbLane.Create)
end;

{ TtbBoardAdapter }

constructor TtbBoardAdapter.Create(AOwner: TComponent);
begin
  inherited;
  FLanes := TObjectList<TLaneControls>.Create(True);
end;

destructor TtbBoardAdapter.Destroy;
begin
  FLanes.Free;
  inherited;
end;

procedure TtbBoardAdapter.Draw;
begin
  PrepareGrid;
end;

procedure TtbBoardAdapter.HandleLaneShowControl(ASender: TLaneControls; const AIndex: Integer; AControl: TControl;
  var AVisible: Boolean);
var
  TaskID: Integer;
  Task: TtbTask;
begin
  Assert(FDomain <> nil);
  TaskID := ASender.Lane.GetTaskId(AIndex);
  if FDomain.FindTaskById(TaskID, Task) then
    if AControl = ASender.Title then
      ASender.Title.Caption := Task.Title
    else if AControl = ASender.Text then
      ASender.Text.Caption := Task.Text;

end;

procedure TtbBoardAdapter.PrepareGrid;
var
  LaneControls: TLaneControls;
begin
  Assert(FGridPanel <> nil);
  Assert(FBoard <> nil);

  FGridPanel.ColumnCollection.Clear;
  FGridPanel.RowCollection.Clear;

  FGridPanel.ExpandStyle := emAddColumns;
  FGridPanel.RowCollection.Add;

  FGridPanel.ColumnCollection.BeginUpdate;
  try
    for var Lane in FBoard.Lanes do
    begin
      LaneControls := TLaneControls.Create;
      LaneControls.Lane := Lane;
      LaneControls.OnShowControl := HandleLaneShowControl;
      FLanes.Add(LaneControls);

      FGridPanel.ColumnCollection.Add.SizeStyle := ssPercent;
      {Panel}
      LaneControls.Panel := TPanel.Create(FGridPanel);
      LaneControls.Panel.Parent := FGridPanel;
      LaneControls.Panel.Align := alClient;
      LaneControls.Panel.BevelOuter := bvNone;

      {Header}
      LaneControls.Header := TFrameLaneHeader.GetLaneHeader(LaneControls.Panel);
      LaneControls.Header.SetText(Lane.Title);

      {ControlList}
      LaneControls.ControlList := TControlList.Create(FGridPanel);
      LaneControls.ControlList.Parent := LaneControls.Panel;
      LaneControls.ControlList.Align := alClient;
      with LaneControls.ControlList do
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
        OnShowControl := LaneControls.HandleControlListShowControl;
      end;

      {Title}
      LaneControls.Title := TLabel.Create(FGridPanel);
      LaneControls.ControlList.AddControlToItem(LaneControls.Title);
      LaneControls.Title.Left := 6;
      LaneControls.Title.Top := 6;

      {Text}
      LaneControls.Text := TLabel.Create(FGridPanel);
      LaneControls.ControlList.AddControlToItem(LaneControls.Text);
      LaneControls.Text.Left := 6;
      LaneControls.Text.Top := 40;

      LaneControls.ControlList.ItemCount := Lane.GetCount;

      {}
      FGridPanel.ControlCollection.AddControl(LaneControls.Panel);
    end;

    for var I := 0 to FGridPanel.ColumnCollection.Count - 1 do
      FGridPanel.ColumnCollection[I].Value := 100 div FGridPanel.ColumnCollection.Count;
  finally
    FGridPanel.ColumnCollection.EndUpdate;
  end;
end;

{ TLaneControls }

procedure TLaneControls.HandleControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
begin
  if Assigned(FOnShowControl) then
    FOnShowControl(Self, AIndex, AControl, AVisible);
end;

{ TPanelHeader }

class function TPanelHeader.GetLaneHeader(AParent: TWinControl): ItbLaneHeader;
var
  Instance: TPanelHeader;
begin
  Instance := Create(nil);
  Instance.Parent := AParent;
  Instance.Align := alTop;
  Instance.BevelOuter := bvNone;
  Instance.Height := 24;
  Instance.Font.Style := Instance.Font.Style + [fsBold];
  Instance.Alignment := taCenter;
  Result := Instance;
end;

procedure TPanelHeader.SetText(AValue: String);
begin
  Caption := AValue;
end;

end.
