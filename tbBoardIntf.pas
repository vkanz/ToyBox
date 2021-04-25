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
    procedure Edit(ATask: TtbTask);
  end;

implementation

end.
