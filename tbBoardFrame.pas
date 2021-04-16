unit tbBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.ControlList, Vcl.ExtCtrls,
  tbDomain, tbBoardIntf, tbRepo, tbBoard, Vcl.Menus, System.Actions, Vcl.ActnList;

type
  TFrameBoard = class(TFrame, ItbPage)
    Panel_Top: TPanel;
    GridPanel: TGridPanel;
    Button1: TButton;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function CreatePage(AParent: TWinControl; ADomain: TtbDomain; ARepo: TtbRepo): ItbPage;
    {}
    procedure Initialize;
    procedure Finalize;
  end;

implementation

{$R *.dfm}

procedure TFrameBoard.Action_LaneAddTaskExecute(Sender: TObject);
begin
  //
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
  FBoard := TtbBoard.Create;
  FBoardAdapter := TtbBoardAdapter.Create(Self);
end;

procedure TFrameBoard.CreateDefaultLanes;
begin
  var Lane := TtbLane.Create;
  Lane.Title := 'ToDo';
  Lane.TaskIdList := FDomain.GetAllTasksID;
  FBoard.Lanes.Add(Lane);

  Lane := TtbLane.Create;
  Lane.Title := 'InProcess';
  Lane.TaskIdList := '';
  FBoard.Lanes.Add(Lane);

  Lane := TtbLane.Create;
  Lane.Title := 'Done';
  Lane.TaskIdList := '';
  FBoard.Lanes.Add(Lane);
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
  Result := Frm;
end;

destructor TFrameBoard.Destroy;
begin
  FBoard.Free;
  inherited;
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

  FBoardAdapter.GridPanel := GridPanel;
  FBoardAdapter.Board := FBoard;
  FBoardAdapter.Domain := FDomain;
  FBoardAdapter.Draw;
end;

end.
