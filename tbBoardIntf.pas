unit tbBoardIntf;

interface

uses tbDomain;

type
  ItbLaneHeader = interface
    procedure SetText(AValue: String);
  end;

type
  ItbTaskCard = interface
  end;

type
  ItbPage = interface
    procedure Initialize;
    procedure Finalize;
  end;

implementation

end.
