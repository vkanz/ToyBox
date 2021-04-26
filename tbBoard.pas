unit tbBoard;

interface

uses Vcl.ExtCtrls, Classes, Generics.Collections,
  EventBus{Preventing W1074 Unknown custom attributes},
  tbEvents;

type
  TtbLane = class
  private
    FTitle: String;
    FTaskIDs: TList<Integer>;
    procedure SetTaskIdList(const Value: String);
    function GetTaskIdList: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GetCount: Integer;
    function GetTaskId(AIndex: Integer): Integer;
    function AddTaskID(ATaskID: Integer; AIndex: Integer = -1): Integer;
    procedure Exchange(AIndex1, AIndex2: Integer);
    procedure RemoveTaskID(ATaskID: Integer);
    property Title: String read FTitle write FTitle;
    property TaskIdList: String read GetTaskIdList write SetTaskIdList;
  end;

type
  TtbBoard = class;

  TtbLaneList = class(TObjectList<TtbLane>)
  private
    FOwner: TtbBoard;
    FModified: Boolean;
    procedure SetModified(const Value: Boolean);
  protected
    procedure Notify(const Value: TtbLane; Action: TCollectionNotification); override;
  public
    property Modified: Boolean read FModified write SetModified;
  end;

  TtbBoard = class
  private
    FLanes: TtbLaneList;
  protected
    FModified: boolean;
    procedure ChildChanged(ASender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    [Subscribe]
    procedure OnTaskChange(AEvent: ITaskChangeEvent);
    { }
    procedure Clear;
    procedure BeforeLoad;
    procedure AfterLoad;
    { }
    property Lanes: TtbLaneList read FLanes;
  end;

implementation

uses Vcl.Graphics, System.UITypes, SysUtils,
{$IFDEF DEBUG}
  Dialogs,
{$ENDIF}
  tbDomain,
  tbLaneFrame;

{ TtbLane }

function TtbLane.AddTaskID(ATaskID: Integer; AIndex: Integer = -1): Integer;
begin
  if (AIndex = -1) or (FTaskIDs.Count < AIndex - 1) then
    Result := FTaskIDs.Add(ATaskID)
  else
  begin
    FTaskIDs.Insert(AIndex, ATaskID);
    Result :=  AIndex;
  end;
  GlobalEventBus.Post(GetLaneChangeEvent(Self));
end;

constructor TtbLane.Create;
begin
  FTaskIDs := TList<Integer>.Create;
end;

destructor TtbLane.Destroy;
begin
  FTaskIDs.Free;
  inherited;
end;

procedure TtbLane.Exchange(AIndex1, AIndex2: Integer);
begin
  FTaskIDs.Exchange(AIndex1, AIndex2);
  GlobalEventBus.Post(GetLaneChangeEvent(Self));
end;

function TtbLane.GetCount: Integer;
begin
  Result := FTaskIDs.Count;
end;

function TtbLane.GetTaskId(AIndex: Integer): Integer;
begin
  if (0 <= AIndex) and (AIndex < FTaskIds.Count) then
    Result := FTaskIds[AIndex]
  else
    Result := newTaskId;
end;

function TtbLane.GetTaskIdList: String;
var
  Enum: Integer;
begin
  Result := '';
  for Enum in FTaskIds do
    Result := Result + Enum.ToString + ',';
  Result := Copy(Result, 1, Length(Result) - 1);
end;

procedure TtbLane.RemoveTaskID(ATaskID: Integer);
begin
  FTaskIDs.Remove(ATaskID);
  GlobalEventBus.Post(GetLaneChangeEvent(Self));
end;

procedure TtbLane.SetTaskIdList(const Value: String);
var
  I: Integer;
begin
  var IDs := Value.Split([',']);
  for I := 0 to Length(IDs) - 1 do
    FTaskIDs.Add(StrToIntDef(IDs[I], 0));
end;

{ TtbBoard }

procedure TtbBoard.AfterLoad;
begin
  GlobalEventBus.RegisterSubscriberForEvents(Self);
end;

procedure TtbBoard.BeforeLoad;
begin
  GlobalEventBus.UnregisterForEvents(Self);
end;

procedure TtbBoard.ChildChanged(ASender: TObject);
begin

end;

procedure TtbBoard.Clear;
begin
  FLanes.Clear;
end;

constructor TtbBoard.Create;
begin
  FLanes := TtbLaneList.Create;
  FLanes.FOwner := Self;
end;

destructor TtbBoard.Destroy;
begin
  FLanes.Free;
  inherited;
end;

procedure TtbBoard.OnTaskChange(AEvent: ITaskChangeEvent);
begin
  if AEvent.GetChangeKind = TTaskChangeKind.Deleted then
    for var Enum in FLanes do
      if (Enum.FTaskIDs.IndexOf(AEvent.GetTaskID) >= 0) then
        Enum.RemoveTaskID(AEvent.GetTaskID);
end;

{ TtbLaneList }

procedure TtbLaneList.Notify(const Value: TtbLane; Action: TCollectionNotification);
const
  done = [TCollectionNotification.cnAdded, TCollectionNotification.cnExtracted,
    TCollectionNotification.cnRemoved];
begin
  inherited;
  if Action in done then
    SetModified(True);
end;

procedure TtbLaneList.SetModified(const Value: Boolean);
begin
  if FModified <> Value then
  begin
    FModified := Value;
    FOwner.ChildChanged(Self);
  end;
end;

function NormalizeName(const ATitle: String): String;
begin
  Result := '';
  for var C in ATitle do
    if CharInSet(C, ['A'..'Z', 'a'..'z', 'À'..'ß', 'à'..'ÿ', '0'..'9', '_']) then
      Result := Result + C;
end;


end.
