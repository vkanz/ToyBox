unit tbDomain;

interface

uses Generics.Collections, Classes,
  tbEvents;

{$SCOPEDENUMS ON}

const
  newTaskId = 0;

type
  TtbPerson = class
  private
    FFullName: String;
    FInitials: String;
    FNickName: String;
    FID: Integer;
  public
    constructor Create(AId: Integer; const AFullName, ANickName, AInitials: String);
    property ID: Integer read FID write FID;
    property FullName: String read FFullName write FFullName;
    property NickName: String read FNickName write FNickName;
    property Initials: String read FInitials write FInitials;
  end;

type
  TtbTaskStatus = (
    Active,
    Archived,
    Deleted
  );

type
  TcbCheckItem = class
  public
    Checked: Boolean;
    Caption: String;
  end;

type
  TtbCheckList = class
  private
    FTitle: String;
  public
    property Title: String read FTitle write FTitle;

  end;

type
  TtbTask = class
  private
    FTitle: String;
    FID: Integer;
    FText: String;
    FTags: String;
    FCreatedBy: Integer;
    FAssignedTo: Integer;
    FStatus: TtbTaskStatus;
  public
    constructor CreateParams(AID: Integer; const ATitle, AText, ATags: String; ACreatedBy: Integer);
    function Clone: TtbTask;
    function IsEqual(ATask: TtbTask): Boolean;
    procedure AssignTo(Dest: TtbTask);
    {}
    property ID: Integer read FID write FID;
    property Title: String read FTitle write FTitle;
    property Text: String read FText write FText;
    property Tags: String read FTags write FTags;
    property CreatedBy: Integer read FCreatedBy write FCreatedBy;
    property AssignedTo: Integer read FAssignedTo write FAssignedTo;
    property Status: TtbTaskStatus read FStatus write FStatus;
  end;

type
  TtbTaskList = class(TObjectList<TtbTask>)
  private
    FUpdateCount: Integer;
    FDictionary: TObjectDictionary<Integer, TtbTask>;
    FDestroying: Boolean;
  protected
    procedure Notify(const Value: TtbTask; Action: TCollectionNotification); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure RebuildDictionary;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DeleteByID(AID: Integer);
    function TryGetByID(AID: Integer; out ATask: TtbTask): Boolean;
    function Exists(AID: Integer): Boolean;
  end;

type
  TtbTaskDict = class(TObjectDictionary<Integer, TtbTask>)
  public
    function FindById(AId: Integer; out ATask: TtbTask): Boolean;
  end;

type
  TtbPersonList = class(TObjectList<TtbPerson>)
  end;

type
  TtbDomain = class
  private
    FLastTaskID: Integer;
    FTasks: TtbTaskList;
    FPersons: TtbPersonList;
  public
    constructor Create;
    destructor Destroy; override;
    function GetNextTaskID: Integer;
    function FindTaskById(AID: Integer; out ATask: TtbTask): Boolean;
    function TaskExists(AID: Integer): Boolean;
    function GetAllTasksID: String;
    procedure BeginUpdate;
    procedure EndUpdate;
    {}
    procedure AddTask(ATask: TtbTask);
    procedure DeleteTasksById(AID: Integer);
    { Persistant properties }
    property Tasks: TtbTaskList read FTasks write FTasks;
    property Persons: TtbPersonList read FPersons write FPersons;
  end;

implementation

uses SysUtils, Math,
  EventBus;

{ TtbDomain }

procedure TtbDomain.AddTask(ATask: TtbTask);
begin
  FTasks.Add(ATask);
  GlobalEventBus.Post(GetEventTaskAdd(ATask));
end;

procedure TtbDomain.BeginUpdate;
begin
  FTasks.BeginUpdate;
end;

constructor TtbDomain.Create;
begin
  FTasks := TtbTaskList.Create;{AOwnsObjects=True}
  FPersons := TtbPersonList.Create;{AOwnsObjects=True}
end;

procedure TtbDomain.DeleteTasksById(AID: Integer);
begin
  FTasks.DeleteByID(AID);
end;

destructor TtbDomain.Destroy;
begin
  FPersons.Free;
  FTasks.Free;
  inherited;
end;

procedure TtbDomain.EndUpdate;
begin
  FLastTaskID := 0;
  for var Enum in FTasks do
    FLastTaskID := Max(Enum.ID, FLastTaskID);
  FTasks.EndUpdate;
end;

function TtbDomain.FindTaskById(AID: Integer; out ATask: TtbTask): Boolean;
begin
  Result := FTasks.TryGetByID(AID, ATask);
end;

function TtbDomain.GetAllTasksID: String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FTasks.Count - 1 do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + FTasks[I].ID.ToString;
  end;
end;

function TtbDomain.GetNextTaskID: Integer;
begin
  FLastTaskID := FLastTaskID + 1;
  Result := FLastTaskID;
end;

function TtbDomain.TaskExists(AID: Integer): Boolean;
begin
  Result := FTasks.Exists(AID);
end;

{ TtbPerson }

constructor TtbPerson.Create(AId: Integer; const AFullName, ANickName, AInitials: String);
begin
  FID := AId;
  FFullName := AFullName;
  FInitials := AInitials;
  FNickName := ANickName;
end;

{ TtbTask }

procedure TtbTask.AssignTo(Dest: TtbTask);
begin
  Dest.FTitle := FTitle;
  Dest.FID := FID;
  Dest.FText := FText;
  Dest.FTags := FTags;
  Dest.FCreatedBy := FCreatedBy;
  Dest.FAssignedTo := FAssignedTo;
  Dest.FStatus := FStatus;
end;

function TtbTask.Clone: TtbTask;
begin
  Result := TtbTask.Create;
  AssignTo(Result);
end;

constructor TtbTask.CreateParams(AID: Integer; const ATitle, AText, ATags: String; ACreatedBy: Integer);
begin
  FID := AID;
  FTitle := ATitle;
  FText := AText;
  FTags := ATags;
  FCreatedBy := ACreatedBy;
  FStatus := TtbTaskStatus.Active;
end;

function TtbTask.IsEqual(ATask: TtbTask): Boolean;
begin
  Result :=
    (FTitle = ATask.FTitle) and
    (FID = ATask.FID) and
    (FText = ATask.FText) and
    (FTags = ATask.FTags) and
    (FCreatedBy = ATask.FCreatedBy) and
    (FAssignedTo = ATask.FAssignedTo) and
    (FStatus = ATask.FStatus);
end;

{ TtbTaskDict }

function TtbTaskDict.FindById(AId: Integer; out ATask: TtbTask): Boolean;
begin
  Result := TryGetValue(AID, ATask);
end;

{ TtbTaskList }

procedure TtbTaskList.BeginUpdate;
begin
  FUpdateCount := FUpdateCount + 1;
end;

constructor TtbTaskList.Create;
const
  ownsNothing = [];
begin
  inherited Create;{Owns=True}
  FDictionary := TObjectDictionary<Integer, TtbTask>.Create(ownsNothing);
end;

procedure TtbTaskList.DeleteByID(AID: Integer);
var
  Task: TtbTask;
begin
  if FDictionary.TryGetValue(AID, Task) then
    Remove(Task);
end;

destructor TtbTaskList.Destroy;
begin
  FDestroying := True;
  FDictionary.Free;
  inherited Destroy;
end;

procedure TtbTaskList.EndUpdate;
begin
  FUpdateCount := FUpdateCount - 1;
  if FUpdateCount = 0 then
    RebuildDictionary;
end;

procedure TtbTaskList.Notify(const Value: TtbTask; Action: TCollectionNotification);
begin
  inherited;
  if (not FDestroying) and (Action = TCollectionNotification.cnRemoved) then
    GlobalEventBus.Post(GetEventTaskChange(Value.ID, TTaskChangeKind.Deleted));
  if FUpdateCount = 0 then
    RebuildDictionary;
end;

procedure TtbTaskList.RebuildDictionary;
begin
  FDictionary.Clear;
  for var Enum in Self do
    FDictionary.Add(Enum.ID, Enum);
end;

function TtbTaskList.TryGetByID(AID: Integer; out ATask: TtbTask): Boolean;
begin
  Result := FDictionary.TryGetValue(AID, ATask);
end;

function TtbTaskList.Exists(AID: Integer): Boolean;
begin
  Result := FDictionary.ContainsKey(AID);
end;

end.
