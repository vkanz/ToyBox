unit tbDomain;

interface

uses Generics.Collections;

{$SCOPEDENUMS ON}

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
    constructor Create(AID: Integer; const ATitle, AText, ATags: String; ACreatedBy: Integer);
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
    function GetAllTasksID: String;
    {}
    property Tasks: TtbTaskList read FTasks write FTasks;
    property Persons: TtbPersonList read FPersons write FPersons;
  end;

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
    function AddTaskID(ATaskID: Integer): Integer;
    procedure RemoveTaskID(ATaskID: Integer);
    property Title: String read FTitle write FTitle;
    property TaskIdList: String read GetTaskIdList write SetTaskIdList;
  end;

type
  TtbLaneList = class(TObjectList<TtbLane>)
  end;

type
  TtbBoard = class
  private
    FLanes: TtbLaneList;
  public
    constructor Create;
    destructor Destroy; override;
    {}
    procedure Clear;
    {}
    property Lanes: TtbLaneList read FLanes;
  end;

implementation

uses SysUtils;

{ TtbDomain }

constructor TtbDomain.Create;
begin
  FTasks := TtbTaskList.Create;{AOwnsObjects=True}
  FPersons := TtbPersonList.Create;{AOwnsObjects=True}
end;

destructor TtbDomain.Destroy;
begin
  FPersons.Free;
  FTasks.Free;
  inherited;
end;

function TtbDomain.FindTaskById(AID: Integer; out ATask: TtbTask): Boolean;
begin
  ATask := nil;
  for var Task in FTasks do
    if Task.ID = AID then
    begin
      ATask := Task;
      Break;
    end;
  Result := ATask <> nil;
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

{ TtbPerson }

constructor TtbPerson.Create(AId: Integer; const AFullName, ANickName, AInitials: String);
begin
  FID := AId;
  FFullName := AFullName;
  FInitials := AInitials;
  FNickName := ANickName;
end;

{ TtbTask }

constructor TtbTask.Create(AID: Integer; const ATitle, AText, ATags: String; ACreatedBy: Integer);
begin
  FID := AID;
  FTitle := ATitle;
  FText := AText;
  FTags := ATags;
  FCreatedBy := ACreatedBy;
  FStatus := TtbTaskStatus.Active;
end;

{ TtbBoard }

procedure TtbBoard.Clear;
begin
  FLanes.Clear;
end;

constructor TtbBoard.Create;
begin
  FLanes := TtbLaneList.Create;
end;

destructor TtbBoard.Destroy;
begin
  FLanes.Free;
  inherited;
end;

{ TtbLane }

function TtbLane.AddTaskID(ATaskID: Integer): Integer;
begin
  Result := FTaskIDs.Add(ATaskID);
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

function TtbLane.GetCount: Integer;
begin
  Result := FTaskIDs.Count;
end;

function TtbLane.GetTaskId(AIndex: Integer): Integer;
begin
  Result := FTaskIds[AIndex];
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
end;

procedure TtbLane.SetTaskIdList(const Value: String);
var
  I: Integer;
begin
  var IDs := Value.Split([',']);
  for I := 0 to Length(IDs) - 1 do
    FTaskIDs.Add(StrToIntDef(IDs[I], 0));
end;

{ TtbTaskDict }

function TtbTaskDict.FindById(AId: Integer; out ATask: TtbTask): Boolean;
begin
  Result := ContainsKey(AId);
  if Result then
    ATask := Self[AID];
end;

end.
