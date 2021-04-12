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
    FTasks: TtbTaskList;
    FTasks1: TtbTaskDict;
    FPersons: TtbPersonList;
  public
    constructor Create;
    destructor Destroy; override;
    function FindTaskById(AID: Integer; out ATask: TtbTask): Boolean;
    {}
    property Tasks: TtbTaskList read FTasks write FTasks;
    //property Tasks1: TtbTaskDict read FTasks1 write FTasks1;
    property Persons: TtbPersonList read FPersons write FPersons;
  end;

type
  TtbLane = class
  private
    FTitle: String;
    FTaskIdList: String;
    FTaskIds: TArray<Integer>;
    procedure SetTaskIdList(const Value: String);
  public
    function GetCount: Integer;
    function GetTaskId(AIndex: Integer): Integer;
    property Title: String read FTitle write FTitle;
    property TaskIdList: String read FTaskIdList write SetTaskIdList;
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
  FTasks1 := TtbTaskDict.Create([doOwnsValues]);
  FPersons := TtbPersonList.Create;{AOwnsObjects=True}
end;

destructor TtbDomain.Destroy;
begin
  FPersons.Free;
  FTasks1.Free;
  FTasks.Free;
  inherited;
end;

function TtbDomain.FindTaskById(AID: Integer; out ATask: TtbTask): Boolean;
begin
  //Result := Tasks.FindById(AId, ATask);
  ATask := nil;
  for var Task in FTasks do
    if Task.ID = AID then
    begin
      ATask := Task;
      Break;
    end;
  Result := ATask <> nil;
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

function TtbLane.GetCount: Integer;
begin
  Result := Length(FTaskIds);
end;

function TtbLane.GetTaskId(AIndex: Integer): Integer;
begin
  Result := FTaskIds[AIndex];
end;

procedure TtbLane.SetTaskIdList(const Value: String);
var
  I: Integer;
begin
  FTaskIdList := Value;
  var IDs := FTaskIdList.Split([',']);
  SetLength(FTaskIds, Length(IDs));
  for I := 0 to Length(IDs) - 1 do
    FTaskIds[I] := StrToIntDef(IDs[I], 0);
end;

{ TtbTaskDict }

function TtbTaskDict.FindById(AId: Integer; out ATask: TtbTask): Boolean;
begin
  Result := ContainsKey(AId);
  if Result then
    ATask := Self[AID];
end;

end.
