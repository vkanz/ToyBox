unit tbBoardIntf;

interface

uses tbDomain, tbBoard;

type
  TtbPageKind = (None, Board, Calendar);

type
  ItbPage = interface
    procedure Initialize;
    procedure Finalize;
    function GetPageKind: TtbPageKind;
  end;

type
  TtbLanePosition = (First, Left, Right, Last);

type
  ItbBoardEditor = interface
    procedure AddLane(ANextTo: TtbLane; APosition: TtbLanePosition);
    function DeleteLane(ALane: TtbLane): Boolean;
    procedure MoveLane(ALane, AAfterLane: TtbLane);
  end;

type
  ItbPersistant = interface
    procedure BeforeLoad;
    procedure AfterLoad;
  end;

type
  ItbTaskEditor = interface
    function Edit(ATask: TtbTask; ANew: Boolean = False): Boolean;
  end;

implementation

end.
