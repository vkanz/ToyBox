unit tbBoardIntf;

interface

uses Controls,
  tbDomain;

type
  ItbLaneX = interface
    function GetTaskId(AIndex: Integer): Integer;
  end;

type
  ItbLaneFrame = interface
    procedure SetHeaderText(AValue: String);
    procedure SetLane(AValue: TtbLane);
  end;

type
  ItbTaskCard = interface
  end;

type
  ItbPage = interface
    procedure Initialize;
    procedure Finalize;
  end;

type
  ItbBoardPage = interface(ItbPage)
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure AddLane(ALane: TtbLane);
  end;

implementation

end.
