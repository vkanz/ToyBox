unit tbBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.ControlList, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList,
  Generics.Collections,
  tbDomain, 
  tbBoardIntf, 
  tbRepo, 
  tbBoard, 
  tbLaneFrame;

type
  TFrameBoard = class(TFrame, ItbPage, ItbBoardEditor)
    Panel_Top: TPanel;
    GridPanel: TGridPanel;
    PopupMenu_Task: TPopupMenu;
    ActionList: TActionList;
  private
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FBoard: TtbBoard;
    FTaskEditor: ItbTaskEditor;
    FLaneFrameList: TObjectList<TFrameLane>;
  protected
    procedure CreateDefaultLanes;
    procedure PrepareGridPanel;
    function SupposeNewLaneTitle: String;
    procedure ShowLaneFrames;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function CreatePage(AParent: TWinControl; ADomain: TtbDomain; ARepo: TtbRepo;
      ATaskEditor: ItbTaskEditor): ItbPage;
    { ItbBoardPage }
    procedure Initialize;
    procedure Finalize;
    function GetPageKind: TtbPageKind;
    { ItbBoardEditor }
    procedure AddLane(AExisted: TtbLane; APosition: TtbLanePosition);
    function DeleteLane(ALane: TtbLane): Boolean;
    procedure MoveLane(ALane, AAfterLane: TtbLane);    
    {}
    procedure HandleInputQueryNewLane(Sender: TObject; const Values: array of string; var CanClose: Boolean);
    {}
    procedure AddLaneFrame(ALane: TtbLane);
    procedure BeginUpdate;
    procedure EndUpdate;
  end;

implementation

{$R *.dfm}

uses  UITypes,
  tbStrings;

const
  predefinedLaneCount = 6;
  predefinedLaneTitles: array[0..predefinedLaneCount - 1] of String = (
    rsLaneTitleToDo,
    rsLaneTitleInProcess,
    rsLaneTitleDone,
    rsLaneTitleBacklog,
    rsLaneTitleTesting,
    rsLaneTitleDeploying
  );

procedure TFrameBoard.ShowLaneFrames;
begin
  BeginUpdate;
  try
    FLaneFrameList.Clear;
    GridPanel.ColumnCollection.Clear;
    for var Lane in FBoard.Lanes do
      AddLaneFrame(Lane);
  finally
    EndUpdate;
  end;
end;

function TFrameBoard.SupposeNewLaneTitle: String;
var
  I: Integer;
  TmpTitle: String;
begin
  Result := '';
  for I := 0 to predefinedLaneCount - 1 do
    if FBoard.IndexOfTitle(predefinedLaneTitles[I]) = -1 then
      Exit(predefinedLaneTitles[I]);

  I := 1;  
  while I < 100 do
  begin
    TmpTitle := rsLaneTitleNew + I.ToString;
    if FBoard.IndexOfTitle(TmpTitle) = -1 then
      Result := TmpTitle
    else
      I := I + 1;
  end;
end;  

procedure TFrameBoard.AddLane(AExisted: TtbLane; APosition: TtbLanePosition);
var
  Values: String;
  Idx: Integer;
begin
  Values := SupposeNewLaneTitle;
  if InputQuery(rsCaptionInputNewLane, rsPromptInputNewLane, Values,
    HandleInputQueryNewLane, AExisted) then
  begin    
    var Lane := TtbLane.Create;
    Lane.Title := Values;
    Idx := FBoard.Lanes.IndexOf(AExisted);
    if APosition = TtbLanePosition.Right then
      FBoard.Lanes.Insert(Idx + 1, Lane);
      
    ShowLaneFrames;{Full repaint}
  end;
end;

procedure TFrameBoard.HandleInputQueryNewLane(Sender: TObject; const Values: array of string;
  var CanClose: Boolean);
var
  SearchTitle: String;
begin
  if Length(Values) < 1 then
    CanClose := False
  else
  begin
    SearchTitle := Values[0];
    CanClose := FBoard.IndexOfTitle(SearchTitle) = -1;
    if not CanClose then
      MessageDlg(rsErrorLaneExists, mtError, [mbOK], 0);
  end;
end;

procedure TFrameBoard.AddLaneFrame(ALane: TtbLane);
begin
  GridPanel.ColumnCollection.Add.SizeStyle := ssPercent;
  FLaneFrameList.Add(TFrameLane.Create(nil, FDomain, FRepo, FTaskEditor, Self));
  FLaneFrameList.Last.Parent := GridPanel;
  FLaneFrameList.Last.Align := alClient;
  FLaneFrameList.Last.Lane := ALane;
end;

function TFrameBoard.DeleteLane(ALane: TtbLane): Boolean;
begin
  if FBoard.Lanes.IndexOf(ALane) = -1 then
    raise Exception.Create(rsErrorNonexistentLane);
  if ALane.GetCount > 0 then
  begin
    Result := False;
    MessageDlg(rsErrorNotEmptyLane, mtError, [mbOK], 0)
  end
  else
  begin  
    with TTaskDialog.Create(nil) do
      try
        MainIcon := tdiWarning;
        Caption := rsDialogCaptionDeletion;
        Title := Format(rsDialogTitleDeletionFmt, [ALane.Title]);
        CommonButtons := [tcbYes, tcbNo];
        Flags := [tfPositionRelativeToWindow];
        Result := Execute and (ModalResult = mrYes);
      finally
        Free;
      end; 

    if Result then
    begin
      FBoard.Lanes.Remove(ALane);

      ShowLaneFrames;{Full repaint}      
    end;
  end;
end;

procedure TFrameBoard.MoveLane(ALane, AAfterLane: TtbLane);
var
  CurrentIndex,
  NewIndex: Integer;
begin
  CurrentIndex := FBoard.Lanes.IndexOf(ALane);
  Assert(CurrentIndex >= 0);  
  NewIndex := FBoard.Lanes.IndexOf(AAfterLane) + 1;
  Assert(NewIndex > 0);
  FBoard.Lanes.Move(CurrentIndex, NewIndex);
  
  ShowLaneFrames;{Full repaint}      
end;

procedure TFrameBoard.BeginUpdate;
begin
  GridPanel.BeginUpdate;
end;

constructor TFrameBoard.Create(AOwner: TComponent);
begin
  inherited;
  FLaneFrameList := TObjectList<TFrameLane>.Create(True);
  PrepareGridPanel;
  FBoard := TtbBoard.Create;
end;

destructor TFrameBoard.Destroy;
begin
  FBoard.Free;
  FLaneFrameList.Free;
  inherited;
end;

procedure TFrameBoard.CreateDefaultLanes;
begin
  var Lane := TtbLane.Create;
  Lane.Title := rsLaneTitleToDo;
  Lane.TaskIdList := FDomain.GetAllTasksID;
  FBoard.Lanes.Add(Lane);

  Lane := TtbLane.Create;
  Lane.Title := rsLaneTitleInProcess;
  Lane.TaskIdList := '';
  FBoard.Lanes.Add(Lane);

  Lane := TtbLane.Create;
  Lane.Title := rsLaneTitleDone;
  Lane.TaskIdList := '';
  FBoard.Lanes.Add(Lane);
end;

class function TFrameBoard.CreatePage(AParent: TWinControl; ADomain: TtbDomain; ARepo: TtbRepo;
  ATaskEditor: ItbTaskEditor): ItbPage;
var
  Frm: TFrameBoard;
begin
  Frm := TFrameBoard.Create(nil);
  Frm.Parent := AParent;
  Frm.Align := alClient;
  Frm.FRepo := ARepo;
  Frm.FDomain := ADomain;
  Frm.FTaskEditor := ATaskEditor;
  Result := Frm as ItbPage;
end;

procedure TFrameBoard.EndUpdate;
begin
  { Make Lanes all the same width }
  for var I := 0 to GridPanel.ColumnCollection.Count - 1 do
    GridPanel.ColumnCollection[I].Value := 100 div GridPanel.ColumnCollection.Count;

  GridPanel.EndUpdate;
end;

procedure TFrameBoard.Finalize;
begin
  FRepo.PutBoard(FBoard);
end;

function TFrameBoard.GetPageKind: TtbPageKind;
begin
  Result := TtbPageKind.Board;
end;

procedure TFrameBoard.Initialize;
begin
  FRepo.GetBoard(FBoard);

  if FBoard.Lanes.Count = 0 then
    CreateDefaultLanes;

  ShowLaneFrames;
end;

procedure TFrameBoard.PrepareGridPanel;
begin
  GridPanel.ColumnCollection.Clear;
  GridPanel.RowCollection.Clear;

  GridPanel.ExpandStyle := emAddColumns;
  GridPanel.RowCollection.Add;
end;

end.
