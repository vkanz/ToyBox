unit tbBoard;

interface

uses Vcl.ExtCtrls, Classes, Generics.Collections, Vcl.ControlList, Vcl.StdCtrls, Controls, Menus,
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
  TLaneIndexProcedure = procedure (ASource, ATarget: TLaneControls) of object;

  TLaneControls = class
  private
    FOnShowControl: TLaneShowControl;
    FOnDropItem: TLaneIndexProcedure;
  public
    Lane: TtbLane;
    Panel: TPanel;
    Header: ItbLaneHeader;
    ControlList: TControlList;
    Title: TLabel;
    Text: TLabel;
    procedure HandleControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
    {Manual BeginDrag}
    procedure HandleControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    {Creation of DragObject}
    procedure HandleControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
    {Accepting Drag Object}
    procedure HandleControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    {Dropping}
    procedure HandleControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
    {}
    property OnShowControl: TLaneShowControl read FOnShowControl write FOnShowControl;
    property OnDropItem: TLaneIndexProcedure read FOnDropItem write FOnDropItem;
  end;

type
  TtbBoardAdapter = class(TComponent)
  private
    FGridPanel: TGridPanel;
    FBoard: TtbBoard;
    FLanes: TObjectList<TLaneControls>;
    FDomain: TtbDomain;
    FPopupMenu: TPopupMenu;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PrepareGrid;
    procedure HandleLaneShowControl(ASender: TLaneControls; const AIndex: Integer; AControl: TControl;
      var AVisible: Boolean);
    procedure HandleLaneDropItem(ASource, ATarget: TLaneControls);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw;
    {}
    property GridPanel: TGridPanel read FGridPanel write FGridPanel;
    property Board: TtbBoard read FBoard write FBoard;
    property Domain: TtbDomain read FDomain write FDomain;
  published
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
  end;

implementation

uses Vcl.Graphics, System.UITypes, SysUtils,
{$IFDEF DEBUG}
  Dialogs,
{$ENDIF}
  tbLaneHeaderFrame;

type
  TTaskDragObject = class(TDragObjectEx)
    LaneControls: TLaneControls;
    constructor Create(ALaneControls: TLaneControls);
  end;

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

procedure TtbBoardAdapter.HandleLaneDropItem(ASource, ATarget: TLaneControls);
var
  TaskID: Integer;
begin
  Assert(FDomain <> nil);
  TaskID := ASource.Lane.GetTaskId(ASource.ControlList.ItemIndex);

  if ASource <> ATarget then
  begin
    ASource.Lane.RemoveTaskID(TaskID);
    ASource.ControlList.ItemCount := ASource.ControlList.ItemCount - 1;
    ASource.ControlList.Repaint;

    ATarget.Lane.AddTaskID(TaskID);
    ATarget.ControlList.ItemCount := ATarget.ControlList.ItemCount + 1;
    ATarget.ControlList.Repaint;
  end
  else
  begin

  end;
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

procedure TtbBoardAdapter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FPopupMenu then
      FPopupMenu := nil
    else if AComponent = FGridPanel then
      FGridPanel := nil;
end;

function NormalizeName(const ATitle: String): String;
begin
  for var C in ATitle do
    if CharInSet(C, ['A'..'Z', 'a'..'z', 'À'..'ß', 'à'..'ÿ', '0'..'9', '_']) then
      Result := Result + C;
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
      LaneControls.OnDropItem := HandleLaneDropItem;
      FLanes.Add(LaneControls);

      FGridPanel.ColumnCollection.Add.SizeStyle := ssPercent;
      {Panel}
      LaneControls.Panel := TPanel.Create(FGridPanel);
      LaneControls.Panel.Parent := FGridPanel;
      LaneControls.Panel.Align := alClient;
      LaneControls.Panel.BevelOuter := bvNone;

      {Header}
      LaneControls.Header := TFrameLaneHeader.GetLaneHeader(LaneControls);
      LaneControls.Header.SetText(Lane.Title);

      {ControlList}
      LaneControls.ControlList := TControlList.Create(FGridPanel);
{$IFDEF DEBUG}
      LaneControls.ControlList.Name := 'ControlList_' + NormalizeName(Lane.Title);
{$ENDIF}
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
        OnMouseDown := LaneControls.HandleControlListMouseDown;
        OnStartDrag := LaneControls.HandleControlListStartDrag;
        OnDragOver := LaneControls.HandleControlListDragOver;
        OnDragDrop := LaneControls.HandleControlListDragDrop;
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

     { Make Lanes all the same width }
    for var I := 0 to FGridPanel.ColumnCollection.Count - 1 do
      FGridPanel.ColumnCollection[I].Value := 100 div FGridPanel.ColumnCollection.Count;
  finally
    FGridPanel.ColumnCollection.EndUpdate;
  end;
end;

{ TLaneControls }

procedure TLaneControls.HandleControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Button = mbLeft) then
    if Sender is TControlList then
      TControlList(Sender).BeginDrag(False);
end;

procedure TLaneControls.HandleControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  DragObject := TTaskDragObject.Create(Self);
end;

procedure TLaneControls.HandleControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := IsDragObject(Source) and (Source is TTaskDragObject)
    and (Self <> TTaskDragObject(Source).LaneControls); //TODO Moving within one Lane
end;

type
  TControlListAux = class(TControlList);

procedure TLaneControls.HandleControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
//  var TargetIndex := Y div (ControlList.Height div
//    (TControlListAux(ControlList).LastDrawItemIndex - TControlListAux(ControlList).FirstDrawItemIndex));
  if IsDragObject(Source) and (Source is TTaskDragObject) then
    if Assigned(FOnDropItem) then {TODO calculate target ItemIndex}
      FOnDropItem(TTaskDragObject(Source).LaneControls, Self);
end;

procedure TLaneControls.HandleControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
begin
  if AIndex < ControlList.ItemCount then {It happens!}
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

{ TTaskDragObject }

constructor TTaskDragObject.Create(ALaneControls: TLaneControls);
begin
  inherited Create;
  LaneControls := ALaneControls;
end;

end.
