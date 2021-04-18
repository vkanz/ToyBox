unit tbRepo;

interface

uses tbDomain;

type
  ItbStorage = interface
    function GetDomain(ATarget: TtbDomain): Boolean;
    procedure PutDomain(ASource: TtbDomain);
    function GetBoard(ATarget: TtbBoard; const ABordName: String = ''): Boolean;
    procedure PutBoard(ATarget: TtbBoard; const ABordName: String = '');
    procedure PutTask(ATask: TtbTask);
  end;

type
  TtbRepo = class
  private
    FStorage: ItbStorage;
  public
    function GetDomain(ATarget: TtbDomain): Boolean;
    procedure PutDomain(ASource: TtbDomain);
    function GetBoard(ATarget: TtbBoard; const ABoardName: String = ''): Boolean;
    procedure PutBoard(ATarget: TtbBoard; const ABoardName: String = '');
    procedure PutTask(ATask: TtbTask);

    constructor Create(AStorage: ItbStorage);
  end;

implementation

{ TtbRepo }

constructor TtbRepo.Create(AStorage: ItbStorage);
begin
  FStorage := AStorage;
end;

function TtbRepo.GetBoard(ATarget: TtbBoard; const ABoardName: String): Boolean;
begin
  Result := FStorage.GetBoard(ATarget, ABoardName)
end;

function TtbRepo.GetDomain(ATarget: TtbDomain): Boolean;
begin
  Result := FStorage.GetDomain(ATarget);
end;

procedure TtbRepo.PutBoard(ATarget: TtbBoard; const ABoardName: String);
begin
  FStorage.PutBoard(ATarget, ABoardName);
end;

procedure TtbRepo.PutDomain(ASource: TtbDomain);
begin
  FStorage.PutDomain(ASource);
end;

procedure TtbRepo.PutTask(ATask: TtbTask);
begin
  FStorage.PutTask(ATask);
end;

end.
