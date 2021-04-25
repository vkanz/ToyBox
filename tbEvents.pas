unit tbEvents;

interface

type
  ILaneChangeEvent = interface
  ['{0E12DAF4-DDD4-418D-8220-49F1E00C4ACC}']
    function GetLane: TObject;//TtbLane;
  end;

type
  TTaskChangeKind = (Created, Deleted, Modified);

type
  ITaskChangeEvent = interface
  ['{95D3C6EA-D8B1-40BB-82B9-FD3A34BC9DA2}']
    function GetTaskID: Integer;
    function GetChangeKind: TTaskChangeKind;
  end;

function GetLaneChangeEvent(ALane: TObject{TtbLane}): ILaneChangeEvent;
function GetTaskChangeEvent(ATaskID: Integer; AChangeKind: TTaskChangeKind): ITaskChangeEvent;

implementation

type
  TLaneChangeEvent = class(TInterfacedObject, ILaneChangeEvent)
  private
    FLane: TObject; //TtbLane;
  public
    function GetLane: TObject;//TtbLane;
  end;

type
  TTaskChangeEvent = class(TInterfacedObject, ITaskChangeEvent)
  private
    FTaskID: Integer;
    FChangeKind: TTaskChangeKind;
  public
    function GetTaskID: Integer;
    function GetChangeKind: TTaskChangeKind;
  end;

function GetLaneChangeEvent(ALane: TObject{TtbLane}): ILaneChangeEvent;
var
  Obj: TLaneChangeEvent;
begin
  Obj := TLaneChangeEvent.Create;
  Obj.FLane := ALane;
  Result := Obj;
end;

function GetTaskChangeEvent(ATaskID: Integer; AChangeKind: TTaskChangeKind): ITaskChangeEvent;
var
  Obj: TTaskChangeEvent;
begin
  Obj := TTaskChangeEvent.Create;
  Obj.FTaskID := ATaskID;
  Obj.FChangeKind := AChangeKind;
  Result := Obj;
end;

{ TLaneChangeEvent }

function TLaneChangeEvent.GetLane: TObject;//TtbLane;
begin
  Result := FLane;
end;

{ TTaskChangeEvent }

function TTaskChangeEvent.GetChangeKind: TTaskChangeKind;
begin
  Result := FChangeKind;
end;

function TTaskChangeEvent.GetTaskID: Integer;
begin
  Result := FTaskID;
end;

end.
