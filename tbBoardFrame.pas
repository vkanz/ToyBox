unit tbBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.ControlList, Vcl.ExtCtrls, Vcl.Menus, System.Actions, Vcl.ActnList,
  tbDomain, tbBoardIntf, tbRepo, tbBoard, tbLaneFrame;

type
  TFrameBoard = class(TFrame, ItbBoardPage)
    Panel_Top: TPanel;
    GridPanel: TGridPanel;
    Button2: TButton;
    PopupMenu_Task: TPopupMenu;
    ActionList: TActionList;
    Action_TaskEdit: TAction;
    Action_TaskDelete: TAction;
    Action_LaneAddTask: TAction;
    Action_LaneSortByName: TAction;
    Action_LaneSortByCreated: TAction;
    Action_LaneSortAsc: TAction;
    Action_LaneSortDesc: TAction;
    ActionLaneAddTask1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Action_LaneAddTaskExecute(Sender: TObject);
  private
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FBoardAdapter: TtbBoardAdapter;
    FBoard: TtbBoard;
  protected
    procedure CreateDefaultLanes;
    procedure BuildMenu(const ACategory);
    procedure PrepareGridPanel;
    procedure HandleLaneDropItem(ASource, ATarget: TFrameLaneHeader);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function CreatePage(AParent: TWinControl; ADomain: TtbDomain; ARepo: TtbRepo): ItbPage;
    { ItbBoardPage }
    procedure Initialize;
    procedure Finalize;
    procedure AddLane(ALane: TtbLane);
    procedure BeginUpdate;
    procedure EndUpdate;
  end;

implementation

{$R *.dfm}

procedure TFrameBoard.Action_LaneAddTaskExecute(Sender: TObject);
begin
  //
end;

procedure TFrameBoard.AddLane(ALane: TtbLane);
var
  Frm: TFrameLaneHeader;
begin
  GridPanel.ColumnCollection.Add.SizeStyle := ssPercent;
  Frm := TFrameLaneHeader.Create(Self);
  Frm.Parent := GridPanel;
  Frm.Align := alClient;
  Frm.SetLane(ALane);
  Frm.SetDomain(FDomain);
  Frm.OnMoveItem := HandleLaneDropItem;
end;

procedure TFrameBoard.BeginUpdate;
begin
  GridPanel.BeginUpdate;
end;

procedure TFrameBoard.BuildMenu(const ACategory);
begin

end;

procedure TFrameBoard.Button2Click(Sender: TObject);
begin
  var Lane := TtbLane.Create;
  Lane.Title := 'Done';
  FBoard.Lanes.Add(Lane);

  FBoardAdapter.Draw;
end;

constructor TFrameBoard.Create(AOwner: TComponent);
begin
  inherited;
  PrepareGridPanel;
  FBoard := TtbBoard.Create;
  FBoardAdapter := TtbBoardAdapter.Create(Self);
end;

procedure TFrameBoard.CreateDefaultLanes;
begin
//  var Lane := TtbLane.Create;
//  Lane.Title := 'ToDo';
//  Lane.TaskIdList := FDomain.GetAllTasksID;
//  FBoard.Lanes.Add(Lane);
//
//  Lane := TtbLane.Create;
//  Lane.Title := 'InProcess';
//  Lane.TaskIdList := '';
//  FBoard.Lanes.Add(Lane);
//
//  Lane := TtbLane.Create;
//  Lane.Title := 'Done';
//  Lane.TaskIdList := '';
//  FBoard.Lanes.Add(Lane);
end;

class function TFrameBoard.CreatePage(AParent: TWinControl; ADomain: TtbDomain; ARepo: TtbRepo): ItbPage;
var
  Frm: TFrameBoard;
begin
  Frm := TFrameBoard.Create(nil);
  Frm.Parent := AParent;
  Frm.Align := alClient;
  Frm.FRepo := ARepo;
  Frm.FDomain := ADomain;
  Result := Frm as ItbBoardPage;
end;

destructor TFrameBoard.Destroy;
begin
  FBoard.Free;
  inherited;
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

procedure TFrameBoard.Initialize;
begin
  FRepo.GetBoard(FBoard);

  if FBoard.Lanes.Count = 0 then
    CreateDefaultLanes;

  FBoardAdapter.BoardPage := Self;
  FBoardAdapter.Board := FBoard;
  FBoardAdapter.Domain := FDomain;
  FBoardAdapter.Draw;
end;

procedure TFrameBoard.PrepareGridPanel;
begin
  GridPanel.ColumnCollection.Clear;
  GridPanel.RowCollection.Clear;

  GridPanel.ExpandStyle := emAddColumns;
  GridPanel.RowCollection.Add;
end;

procedure TFrameBoard.HandleLaneDropItem(ASource, ATarget: TFrameLaneHeader);
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

end.
