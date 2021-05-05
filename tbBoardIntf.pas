unit tbBoardIntf;

interface

uses tbDomain;

type
  ItbPage = interface
    procedure Initialize;
    procedure Finalize;
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
