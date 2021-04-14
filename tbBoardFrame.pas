unit tbBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.ControlList, Vcl.ExtCtrls,
  tbDomain, tbBoardIntf, tbRepo, tbBoard, Vcl.Menus;

type
  TFrameBoard = class(TFrame, ItbPage)
    Panel_Top: TPanel;
    GridPanel: TGridPanel;
    Button1: TButton;
    Button2: TButton;
    PopupMenu_Task: TPopupMenu;
    MenuItem_AddTask: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure MenuItem_AddTaskClick(Sender: TObject);
  private
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FBoardAdapter: TtbBoardAdapter;
    FBoard: TtbBoard;
  protected
    procedure CreateDefaultLanes;
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

procedure TFrameBoard.MenuItem_AddTaskClick(Sender: TObject);
begin
  //
end;

end.
