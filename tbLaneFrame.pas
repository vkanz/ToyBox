unit tbLaneFrame;

{ TControlList:
https://www.youtube.com/watch?v=T6JW5nodSiI
https://www.developpez.net/forums/d2104107/environnements-developpement/delphi/composants-vcl/10-4-2-nouveau-tcontrollist/
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ControlList, Generics.Collections,
  EventBus,
  tbBoardIntf,
  tbDomain,
  tbRepo,
  tbBoard,
  tbEvents, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TFrameLane = class(TFrame)
    Label_Header: TLabel;
    GridPanel: TGridPanel;
    SpeedButton: TSpeedButton;
    ControlList: TControlList;
    ActionList: TActionList;
    Action_AddTask: TAction;
    PopupMenu_Header: TPopupMenu;
    MenuItem_AddTask: TMenuItem;
    Action_DeleteTask: TAction;
    MenuItem_DeleteTask: TMenuItem;
    Action_EditTask: TAction;
    MenuItem_EditTask: TMenuItem;
    Label_ID: TLabel;
    Shape_ID: TShape;
    Label_Title: TLabel;
    Label_Text: TLabel;
    Button_Edit: TControlListButton;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    Action_AddLane: TAction;
    ActionAddLane1: TMenuItem;
    N1: TMenuItem;
    Action_DeleteLane: TAction;
    DeleteLane1: TMenuItem;
    procedure SpeedButtonClick(Sender: TObject);
    procedure ControlListShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
    { Drag-n-drop Task}
    procedure ControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ControlListDragDrop(Sender, Source: TObject; X, Y: Integer);
    { Drag-n-drop Lane}
    procedure Label_HeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Label_HeaderStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Label_HeaderDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Label_HeaderDragDrop(Sender, Source: TObject; X, Y: Integer);
    {}
    procedure Action_AddTaskExecute(Sender: TObject);
    procedure Action_DeleteTaskExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure Action_EditTaskExecute(Sender: TObject);
    { Draw Item }
    procedure ControlListBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure ControlListClick(Sender: TObject);
    procedure ControlListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Action_AddLaneExecute(Sender: TObject);
    procedure Action_DeleteLaneExecute(Sender: TObject);
  private
    FShapeID: TShape;
    FID: TLabel;
    FTitle: TLabel;
    FText: TLabel;
    {}
    FLane: TtbLane;
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FTaskEditor: ItbTaskEditor;
    FBoardEditor: ItbBoardEditor;
    procedure SetLane(AValue: TtbLane);
    procedure SetDomain(AValue: TtbDomain);
  protected
    procedure SetupControlList;
    procedure SetupIDMark;
    procedure SetupActions;
    procedure Draw;
    function GetCurrentTaskID: Integer;
{$IFDEF DZHTML}
    procedure HandleRetrieveImgRes(Sender: TObject; const ResourceName: string;
      Picture: TPicture; var Handled: Boolean);
    procedure HandleLinkClick(Sender: TObject; Link: TDHBaseLink;
      var Handled: Boolean);
{$ENDIF}
    procedure SetItemHeight(AValue: Integer);
  public
    constructor Create(AOwner: TComponent; ADomain: TtbDomain;
      ARepo: TtbRepo; ATaskEditor: ItbTaskEditor; ABoardEditor: ItbBoardEditor); reintroduce;
    destructor Destroy; override;
    [Subscribe] { must be EventBus in uses }
    procedure OnLaneChange(AEvent: ILaneChangeEvent);
    property Lane: TtbLane read FLane write SetLane;
  end;

implementation

{$R *.dfm}

uses Types, UITypes,
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
  TObjectKind = (Task, Lane);

type
  TTaskDragObject = class(TDragObjectEx)
    LaneFrame: TFrameLane;
    ObjectKind: TObjectKind;
    constructor Create(ALaneFrame: TFrameLane; AObjectKind: TObjectKind);
  end;

constructor TTaskDragObject.Create(ALaneFrame: TFrameLane; AObjectKind: TObjectKind);
begin
  inherited Create;
  LaneFrame := ALaneFrame;
  ObjectKind := AObjectKind;
end;

{ TFrameLaneHeader }

type
  TControlListAux = class(TControlList)
    function ItemIndexAtY(Y: Integer): Integer;
  end;

procedure TFrameLane.ControlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  SenderControlList: TControlList;
  Idx: Integer;
  Rect: TRect;
begin
  { Manual BeginDrag Task}
  if (Button = mbLeft) then
    if Sender is TControlList then
    begin
      SenderControlList := TControlList(Sender);
      Idx := TControlListAux(SenderControlList).FirstDrawItemIndex + Y div
        SenderControlList.ItemHeight;
      if Idx >= 0 then
        SenderControlList.ItemIndex := Idx;

      Rect := Button_Edit.BoundsRect;
      Rect.Offset(0, (Y div SenderControlList.ItemHeight) * SenderControlList.ItemHeight);
      if Rect.Contains(TPoint.Create(X, Y)) then
      begin
        Action_EditTask.Execute;
      end
      else
      begin
        if (SenderControlList.ItemIndex >= 0) and (SenderControlList.ItemIndex = Idx) then
          SenderControlList.BeginDrag(False);
      end;
    end;
end;

procedure TFrameLane.ControlListStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  { Creation of DragObject }
  if Sender is TControlList then
    DragObject := TTaskDragObject.Create(Self, TObjectKind.Task);
end;

procedure TFrameLane.ControlListDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  { Accepting Drag Object }
  Accept := IsDragObject(Source) and (Source is TTaskDragObject) and
    (TTaskDragObject(Source).ObjectKind = TObjectKind.Task);
end;

procedure TFrameLane.ControlListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (Shift = []) then
    if Sender is TControlList then
      TControlList(Sender).ItemIndex := -1;
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
    TargetIndex := TControlListAux(ControlList).FirstDrawItemIndex + Y div ControlList.ItemHeight;

    if TTaskDragObject(Source).LaneFrame <> Self then
    begin
      if TargetIndex > ControlList.ItemCount - 1 then
        TargetIndex := -1;{below the low}

      SourceFrame := TTaskDragObject(Source).LaneFrame;
      TaskID := SourceFrame.GetCurrentTaskID;
      SourceFrame.Lane.RemoveTaskID(TaskID);
      TargetIndex := Lane.AddTaskID(TaskID, TargetIndex);
    end
    else
    begin
      if TargetIndex > ControlList.ItemCount - 1 then
        TargetIndex := ControlList.ItemCount - 1;
      SourceIndex := ControlList.ItemIndex;
      Lane.Exchange(SourceIndex, TargetIndex);
    end;
    ControlList.ItemIndex := TargetIndex;
  end;
end;

procedure TFrameLane.Label_HeaderMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { Manual BeginDrag Lane }
  if (Button = mbLeft) then
    if Sender = Label_Header then
      Label_Header.BeginDrag(False);
end;

procedure TFrameLane.Label_HeaderStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  { Creation of DragObject }
  if Sender = Label_Header then
    DragObject := TTaskDragObject.Create(Self, TObjectKind.Lane);
end;

procedure TFrameLane.Label_HeaderDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  { Accepting Drag Object }
  Accept := IsDragObject(Source) and (Source is TTaskDragObject) and
    (TTaskDragObject(Source).ObjectKind = TObjectKind.Lane) and
    (TTaskDragObject(Source).LaneFrame <> Self);
end;

procedure TFrameLane.Label_HeaderDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  { Dropping }
  if IsDragObject(Source) and (Source is TTaskDragObject) and
    (TTaskDragObject(Source).ObjectKind = TObjectKind.Lane) and
    (TTaskDragObject(Source).LaneFrame <> Self) then
    FBoardEditor.MoveLane(TTaskDragObject(Source).LaneFrame.Lane, Self.Lane);
end;

procedure TFrameLane.ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  if (Action = Action_DeleteTask) or (Action = Action_EditTask) then
    TAction(Action).Enabled := ControlList.ItemIndex >= 0
  ;
  Handled := True;
end;

procedure TFrameLane.Action_AddLaneExecute(Sender: TObject);
begin
  FBoardEditor.AddLane(FLane, TtbLanePosition.Right);
end;

procedure TFrameLane.Action_AddTaskExecute(Sender: TObject);
var
  Id: Integer;
  NewTask: TtbTask;
begin
  NewTask := TtbTask.CreateParams(0, rsTask + Id.ToString, rsNewTask, '', 1);
  if not FTaskEditor.Edit(NewTask, True{New}) then
    NewTask.Free
  else
  begin
    FRepo.PostTask(NewTask); {Obtains ID}
    if NewTask.ID = newTaskId then
      raise Exception.Create('Error obtainig ID');

    if not FDomain.TaskExists(NewTask.ID) then
      FDomain.AddTask(NewTask);

    Lane.AddTaskID(NewTask.Id);
    ControlList.Repaint; {TODO through event}
  end;
end;

procedure TFrameLane.Action_DeleteTaskExecute(Sender: TObject);
begin
  FDomain.DeleteTasksById(GetCurrentTaskID);
end;

procedure TFrameLane.Action_DeleteLaneExecute(Sender: TObject);
begin
  FBoardEditor.DeleteLane(FLane);
end;

procedure TFrameLane.Action_EditTaskExecute(Sender: TObject);
var
  Task: TtbTask;
begin
  //CancelDrag;
  if FDomain.FindTaskByID(GetCurrentTaskID, Task) then
    FTaskEditor.Edit(Task)
end;

procedure TFrameLane.ControlListBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
var
  TaskID: Integer;
  Task: TtbTask;
begin
  if AIndex < ControlList.ItemCount then {It happens!}
  begin
    Assert(FDomain <> nil);
    Assert(Assigned(FLane));
    TaskID := FLane.GetTaskId(AIndex);
    FID.Caption := TaskID.ToString;
    FID.Width := FID.Canvas.TextWidth(FID.Caption); { a kind of muddle with Autosize }
    Button_Edit.Visible := odHotLight in AState;
    if Button_Edit.Visible then
    begin
      Button_Edit.Caption := '';
      Button_Edit.Left := ControlList.Width - Button_Edit.Width - 8;
    end;
    if FDomain.FindTaskByID(TaskID, Task) then
    begin
      FTitle.Caption := Task.Title;
      FText.Caption := Task.Text;
    end
    else
    begin
      FTitle.Caption := '<' + rsTaskNotFound + '>';
      FText.Caption := '';
    end;
    FShapeID.Width := FID.Width + (FID.Left - FShapeID.Left) * 2 + 1;
    Label_Title.Left := FShapeID.Left + FShapeID.Width + 4;
  end;
end;

procedure TFrameLane.ControlListClick(Sender: TObject);
const
  popupOnClick = False;
var
  ScreenPt,
  ClientPt: TPoint;
  Idx: Integer;
  ControlList: TControlListAux;
begin
  if not (Sender is TControlList) or not popupOnClick then
    Exit;
  ControlList := TControlListAux(Sender);
  ScreenPt := Mouse.CursorPos;
  ClientPt := ControlList.ScreenToClient(ScreenPt);
  Idx := ControlList.ItemIndexAtY(ClientPt.Y);
  if Idx > ControlList.ItemCount - 1 then
    ControlList.ItemIndex := -1;
  PopupMenu_Header.Popup(ScreenPt.X, ScreenPt.Y);
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
    if FDomain.FindTaskByID(TaskID, Task) then
      if AControl = FID then
      begin
        FID.Caption := Task.ID.ToString;
        FShapeID.Width := FID.Width + (FID.Left - FShapeID.Left) * 2 + 1;
      end
      else if AControl = FTitle then
        FTitle.Caption := Task.Title
      else if AControl = FText then
        FText.Caption := Task.Text
    else
      if AControl = FTitle then
        FTitle.Caption := '<ID=' + TaskID.ToString + ' ' + rsIsNotFound;
  end;
end;

constructor TFrameLane.Create(AOwner: TComponent; ADomain: TtbDomain;
  ARepo: TtbRepo; ATaskEditor: ItbTaskEditor; ABoardEditor: ItbBoardEditor);
begin
  inherited Create(AOwner);
  //FVisibleItems := TDictionary<Integer, TRect>.Create;
  FRepo := ARepo;
  FTaskEditor := ATaskEditor;
  FBoardEditor := ABoardEditor;
  Name := ''; {TODO make unique name?}
  SetupControlList;
  Label_Header.Font.Style := Label_Header.Font.Style + [fsBold];
  SetDomain(ADomain);
end;

destructor TFrameLane.Destroy;
begin
  //FVisibleItems.Free;
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

procedure TFrameLane.OnLaneChange(AEvent: ILaneChangeEvent);
begin
  if AEvent.GetLane = FLane then
    Draw;
end;

procedure TFrameLane.SetDomain(AValue: TtbDomain);
begin
  FDomain := AValue;
end;

procedure TFrameLane.SetItemHeight(AValue: Integer);
begin
  Label_Text.Height := AValue - Label_Text.Top;
  ControlList.ItemHeight := AValue;
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

procedure TFrameLane.SetupIDMark;
begin
  FShapeID.Top := 2;
  FShapeID.Left := 2;
  FShapeID.Height := 15;
  FShapeID.Width := 15;
  FID.Top := FShapeID.Top;
  FID.Left := FShapeID.Left + 5;
  FID.AutoSize := True;

  Label_Title.Top := FID.Top;
  Label_Text.Top := FID.Top + 16;
  Label_Text.Left := FShapeID.Left;
end;

procedure TFrameLane.SetupActions;
begin
  Action_AddTask.Caption := rsActionCaptionAddTask;
  Action_DeleteTask.Caption := rsActionCaptionDeleteTask;
  Action_EditTask.Caption := rsActionCaptionEditTask;
  Action_AddLane.Caption := rsActionCaptionAddLane;
  Action_DeleteLane.Caption := rsActionCaptionDelLane;
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
  {}
  FID := Label_ID;
  FShapeID := Shape_ID;
  FTitle := Label_Title;
  FText := Label_Text;
  {}
  SetupIDMark;
  SetItemHeight(60);
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

{ TControlListAux }

function TControlListAux.ItemIndexAtY(Y: Integer): Integer;
begin
  Result := FirstDrawItemIndex + Y div ItemHeight;
end;

end.
