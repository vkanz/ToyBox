unit tbBoardIntf;

interface

uses Controls,
  tbDomain;

type
  ItbLaneHeader = interface
    procedure SetHeaderText(AValue: String);
    procedure SetHeaderParent(AValue: TWinControl; AAlign: TAlign);
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
