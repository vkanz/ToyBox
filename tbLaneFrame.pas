unit tbLaneFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ControlList,
  EventBus,
  tbBoardIntf, tbDomain, tbEvents;

type
  TtbLaneHeaderBuilder = class
    //class function GetLaneHeader(ALaneControls: TLaneControls): ItbLaneHeader;
  end;

type
  TFrameLane = class;

  TLaneFrameProcedure = procedure(ASource, ATarget: TFrameLane) of object;

  TFrameLane = class(TFrame {, ItbLaneFrame!!})
    Label_Header: TLabel;
    GridPanel: TGridPanel;
    SpeedButton: TSpeedButton;
    ControlList: TControlList;
    ActionList1: TActionList;
    Action_AddTask: TAction;
    PopupMenu_Header: TPopupMenu;
    AddTask1: TMenuItem;
    Action_DeleteTask: TAction;
    DeleteTask1: TMenuItem;
    procedure SpeedButtonClick(Sender: TObject);
    procedure MenuItem_AddTaskClick(Sender: TObject);
    procedure ControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
    { Drag-n-drop }
    procedure ControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
    {}
    procedure Action_AddTaskExecute(Sender: TObject);
    procedure Action_DeleteTaskExecute(Sender: TObject);
  private
    FTitle: TLabel;
    FText: TLabel;
    {}
    FLane: TtbLane;
    FDomain: TtbDomain;
    FOnMoveItem: TLaneFrameProcedure;
  protected
    procedure SetupControlList;
    procedure Draw;
  public
    constructor Create(AOwner: TComponent); override;
    [Subscribe]
    procedure OnLaneChange(AEvent: ILaneChangeEvent);
    { ItbLaneFrame }
    procedure SetHeaderText(AValue: String);
    procedure SetLane(AValue: TtbLane);
    procedure SetDomain(AValue: TtbDomain);
    property OnMoveItem: TLaneFrameProcedure read FOnMoveItem write FOnMoveItem;
    property Lane: TtbLane read FLane;
  end;

implementation

{$R *.dfm}

uses Types, UITypes;

{ TTaskDragObject }

type
  TTaskDragObject = class(TDragObjectEx)
    LaneControls: TFrameLane;
    constructor Create(ALaneControls: TFrameLane);
  end;

constructor TTaskDragObject.Create(ALaneControls: TFrameLane);
begin
  inherited Create;
  LaneControls := ALaneControls;
end;

{ TFrameLaneHeader }

procedure TFrameLane.ControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  { Manual BeginDrag }
  if (Button = mbLeft) then
    if Sender is TControlList then
      TControlList(Sender).BeginDrag(False);
end;

procedure TFrameLane.ControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  { Creation of DragObject }
  DragObject := TTaskDragObject.Create(Self);
end;

procedure TFrameLane.ControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  { Accepting Drag Object }
  Accept := IsDragObject(Source) and (Source is TTaskDragObject)
    and (Self <> TTaskDragObject(Source).LaneControls); //TODO Moving within one Lane
end;

procedure TFrameLane.ControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  { Dropping }
//  var TargetIndex := Y div (ControlList.Height div
//    (TControlListAux(ControlList).LastDrawItemIndex - TControlListAux(ControlList).FirstDrawItemIndex));
  if IsDragObject(Source) and (Source is TTaskDragObject) then
    if Assigned(FOnMoveItem) then {TODO calculate target ItemIndex}
      FOnMoveItem(TTaskDragObject(Source).LaneControls, Self);
end;

procedure TFrameLane.Action_AddTaskExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := FDomain.GetNextTaskID;
  FDomain.Tasks.Add(TtbTask.Create(Id, 'Task' + Id.ToString, 'New task', '', 1));
  Lane.AddTaskID(Id);
  ControlList.Repaint;
end;

procedure TFrameLane.Action_DeleteTaskExecute(Sender: TObject);
begin
  FDomain.Tasks.DeleteById(FLane.GetTaskId(ControlList.ItemIndex));
end;

procedure TFrameLane.ControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
var
  TaskID: Integer;
  Task: TtbTask;
begin
  if AIndex < ControlList.ItemCount then {It happens!}
  begin
    Assert(FDomain <> nil);
    Assert(Assigned(FLane));
    TaskID := FLane.GetTaskId(AIndex);
    if FDomain.FindTaskById(TaskID, Task) then
      if AControl = FTitle then
        FTitle.Caption := Task.Title
      else if AControl = FText then
        FText.Caption := Task.Text;
  end;
end;

constructor TFrameLane.Create(AOwner: TComponent);
begin
  inherited;
  Name := ''; {TODO make unique name?}
  SetupControlList;
  Label_Header.Font.Style := Label_Header.Font.Style + [fsBold];
end;

procedure TFrameLane.Draw;
begin
  ControlList.ItemCount := FLane.GetCount;
  //ControlList.Repaint;
  Label_Header.Caption := FLane.Title;
end;

procedure TFrameLane.MenuItem_AddTaskClick(Sender: TObject);
begin
//
end;

procedure TFrameLane.OnLaneChange(AEvent: ILaneChangeEvent);
begin
  if AEvent.GetLane = FLane then
    Draw;
end;

procedure TFrameLane.SetDomain(AValue: TtbDomain);
begin
  FDomain := AValue;
end;

procedure TFrameLane.SetHeaderText(AValue: String);
begin
  Label_Header.Caption := AValue;
end;

procedure TFrameLane.SetLane(AValue: TtbLane);
begin
  if FLane <> AValue then
  begin
    if FLane <> nil then
      GlobalEventBus.UnregisterForEvents(Self);

    FLane := AValue;

    if FLane <> nil then
      GlobalEventBus.RegisterSubscriberForEvents(Self);

    Draw;
  end;
end;

procedure TFrameLane.SetupControlList;
begin
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
//    OnShowControl := LaneControls.HandleControlListShowControl;
//    OnMouseDown := LaneControls.HandleControlListMouseDown;
//    OnStartDrag := LaneControls.HandleControlListStartDrag;
//    OnDragOver := LaneControls.HandleControlListDragOver;
//    OnDragDrop := LaneControls.HandleControlListDragDrop;
  end;

  {Title}
  FTitle := TLabel.Create(Self);
  ControlList.AddControlToItem(FTitle);
  FTitle.Left := 6;
  FTitle.Top := 6;

  {Text}
  FText := TLabel.Create(Self);
  ControlList.AddControlToItem(FText);
  FText.Left := 6;
  FText.Top := 40;
end;

procedure TFrameLane.SpeedButtonClick(Sender: TObject);
var
  Pnt: TPoint;
  Btn: TSpeedButton;
begin
  Btn := Sender as TSpeedButton;
  if PopupMenu_Header <> nil then
  begin
    { TODO Calculate menu width }
    Pnt := Point(Btn.Left - 120, Btn.Top + Btn.Height);
    Pnt := Btn.Parent.ClientToScreen(Pnt);
    PopupMenu_Header.Popup(Pnt.X, Pnt.Y)
  end;
end;

end.
