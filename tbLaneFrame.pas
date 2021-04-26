unit tbLaneFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ControlList, Generics.Collections,
  EventBus,
{$IFDEF DZHTML}
  Vcl.DzHTMLText,
{$ENDIF}
  tbBoardIntf,
  tbDomain,
  tbBoard,
  tbEvents;

type
  TtbLaneHeaderBuilder = class
    //class function GetLaneHeader(ALaneControls: TLaneControls): ItbLaneHeader;
  end;

type
  TFrameLane = class;

  TFrameLane = class(TFrame)
    Label_Header: TLabel;
    GridPanel: TGridPanel;
    SpeedButton: TSpeedButton;
    ControlList: TControlList;
    ActionList: TActionList;
    Action_AddTask: TAction;
    PopupMenu_Header: TPopupMenu;
    AddTask1: TMenuItem;
    Action_DeleteTask: TAction;
    DeleteTask1: TMenuItem;
    Action_EditTask: TAction;
    EditTask1: TMenuItem;
    Label_ID: TLabel;
    Shape_ID: TShape;
    Label_Title: TLabel;
    Label_Text: TLabel;
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
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure Action_EditTaskExecute(Sender: TObject);
    procedure ControlListBeforeDrawItems(ACanvas: TCanvas; ARect: TRect);
    procedure ControlListAfterDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
  private
    FVisibleItems: TDictionary<Integer, TRect>;
    FID: TLabel;
    FTitle: TLabel;
    FText: TLabel;
    {}
    FLane: TtbLane;
    FDomain: TtbDomain;
    FTaskEditor: ItbTaskEditor;
  protected
    procedure SetupControlList;
    procedure Draw;
    function GetCurrentTaskID: Integer;
{$IFDEF DZHTML}
    procedure HandleRetrieveImgRes(Sender: TObject; const ResourceName: string;
      Picture: TPicture; var Handled: Boolean);
    procedure HandleLinkClick(Sender: TObject; Link: TDHBaseLink;
      var Handled: Boolean);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent; ATaskEditor: ItbTaskEditor); reintroduce;
    destructor Destroy; override;
    [Subscribe] { must be EventBus in uses }
    procedure OnLaneChange(AEvent: ILaneChangeEvent);
    procedure SetHeaderText(AValue: String);
    procedure SetLane(AValue: TtbLane);
    procedure SetDomain(AValue: TtbDomain);
    property Lane: TtbLane read FLane;
  end;

implementation

{$R *.dfm}

uses Types, UITypes,
  ControlListHelper,
  tbStrings;

{ Utils }

procedure SetText(AControl: TGraphicControl; const AText: String);
begin
  if AControl is TLabel then
    TLabel(AControl).Caption := AText
{$IFDEF DZHTML}
  else if AControl is TDzHTMLText then
    TDzHTMLText(AControl).Lines.Text := AText;
{$ENDIF}
end;

{ TTaskDragObject }

type
  TTaskDragObject = class(TDragObjectEx)
    LaneFrame: TFrameLane;
    constructor Create(ALaneFrame: TFrameLane);
  end;

constructor TTaskDragObject.Create(ALaneFrame: TFrameLane);
begin
  inherited Create;
  LaneFrame := ALaneFrame;
end;

{ TFrameLaneHeader }

procedure TFrameLane.ControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  CtrlLst: TControlList;
  Idx: Integer;
begin
  { Manual BeginDrag }
  if (Button = mbLeft) then
    if Sender is TControlList then
    begin
      CtrlLst := TControlList(Sender);
      Idx := CtrlLst._ItemAtPos(X, Y, FVisibleItems);
      if Idx >= 0 then
        CtrlLst.ItemIndex := Idx;
      if (CtrlLst.ItemIndex >= 0) and (CtrlLst.ItemIndex = Idx) then
        CtrlLst.BeginDrag(False);
    end;
end;

procedure TFrameLane.ControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  CtrlLst: TControlList;
begin
  { Creation of DragObject }
  if Sender is TControlList then
  begin
    CtrlLst := TControlList(Sender);
    DragObject := TTaskDragObject.Create(Self);
  end;
end;

procedure TFrameLane.ControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  { Accepting Drag Object }
  Accept := IsDragObject(Source) and (Source is TTaskDragObject);
end;

procedure TFrameLane.ControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  SourceFrame: TFrameLane;
  TaskID: Integer;
  SourceIndex,
  TargetIndex: Integer;
begin
  { Dropping }
  if IsDragObject(Source) and (Source is TTaskDragObject) then
  begin
    TargetIndex := ControlList._ItemAtPos(X, Y, FVisibleItems);

    if TTaskDragObject(Source).LaneFrame <> Self then
    begin
      SourceFrame := TTaskDragObject(Source).LaneFrame;
      TaskID := SourceFrame.GetCurrentTaskID;
      SourceFrame.Lane.RemoveTaskID(TaskID);
      TargetIndex := Lane.AddTaskID(TaskID, TargetIndex);
    end
    else
    begin
      SourceIndex := ControlList.ItemIndex;
      Lane.Exchange(SourceIndex, TargetIndex);
    end;
    ControlList.ItemIndex := TargetIndex;
  end;
end;

procedure TFrameLane.ControlListBeforeDrawItems(ACanvas: TCanvas; ARect: TRect);
begin
  FVisibleItems.Clear;
end;

procedure TFrameLane.ControlListAfterDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
var
  ItemRect: TRect;
begin
  ItemRect := ControlList._GetItemRect(AIndex);
  FVisibleItems.AddOrSetValue(AIndex, ItemRect);
end;

procedure TFrameLane.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  if (Action = Action_DeleteTask) or (Action = Action_EditTask) then
    TAction(Action).Enabled := ControlList.ItemIndex >= 0
  ;
  Handled := True;
end;

procedure TFrameLane.Action_AddTaskExecute(Sender: TObject);
var
  Id: Integer;
begin
  Id := FDomain.GetNextTaskID;
  FDomain.Tasks.Add(TtbTask.CreateParams(Id, rsTask + Id.ToString, rsNewTask, '', 1));
  Lane.AddTaskID(Id);
  ControlList.Repaint;
end;

procedure TFrameLane.Action_DeleteTaskExecute(Sender: TObject);
begin
  FDomain.Tasks.DeleteById(GetCurrentTaskID);
end;

procedure TFrameLane.Action_EditTaskExecute(Sender: TObject);
var
  Task: TtbTask;
begin
  if FDomain.Tasks.TryGetByID(GetCurrentTaskID, Task) then
    FTaskEditor.Edit(Task)
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
    if FDomain.Tasks.TryGetByID(TaskID, Task) then
      if AControl = FID then
        FID.Caption := Task.ID.ToString
      else if AControl = FTitle then
        FTitle.Caption := Task.Title
      else if AControl = FText then
        FText.Caption := Task.Text
    else
      if AControl = FTitle then
        FTitle.Caption := '<ID=' + TaskID.ToString + ' ' + rsIsNotFound;
  end;
end;

constructor TFrameLane.Create(AOwner: TComponent; ATaskEditor: ItbTaskEditor);
begin
  inherited Create(AOwner);
  FVisibleItems := TDictionary<Integer, TRect>.Create;
  FTaskEditor := ATaskEditor;
  Name := ''; {TODO make unique name?}
  SetupControlList;
  Label_Header.Font.Style := Label_Header.Font.Style + [fsBold];
end;

destructor TFrameLane.Destroy;
begin
  FVisibleItems.Free;
  inherited;
end;

procedure TFrameLane.Draw;
begin
  ControlList.ItemCount := FLane.GetCount;
  //ControlList.Repaint;
  Label_Header.Caption := FLane.Title;
end;

function TFrameLane.GetCurrentTaskID: Integer;
begin
  Assert(ControlList.ItemIndex >= 0);
  Result := FLane.GetTaskId(ControlList.ItemIndex);
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
  end;

  FID := Label_ID;
  FTitle := Label_Title;
  FText := Label_Text;

  ControlList.ItemHeight := 60;
end;

{$IFDEF DZHTML}
procedure TFrameLane.HandleRetrieveImgRes(Sender: TObject; const ResourceName: string;
  Picture: TPicture; var Handled: Boolean);
begin
  Picture.Assign(Application.Icon);
  Handled := True;
end;

procedure TFrameLane.HandleLinkClick(Sender: TObject; Link: TDHBaseLink;
  var Handled: Boolean);
begin
  //
  Handled := True;
end;
{$ENDIF}

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
