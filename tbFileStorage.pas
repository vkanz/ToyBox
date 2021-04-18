unit tbFileStorage;

interface

uses Classes,
  tbRepo, tbDomain;

type
  TtbFileStorage = class(TInterfacedObject, ItbStorage)
  private class var
    FInstance: TtbFileStorage;
  public
    class function GetInstance: TtbFileStorage;
  private
    FLines: TStrings;
    FFolder: String;
    FFileNameFull: String;
  protected
    property FileNameFull: String read FFileNameFull;
  public
    constructor Create;
    destructor Destroy; override;
    { ItbStorage }
    function GetDomain(ATarget: TtbDomain): Boolean;
    procedure PutDomain(ASource: TtbDomain);
    function GetBoard(ATarget: TtbBoard; const ABoardName: String = ''): Boolean;
    procedure PutBoard(ASource: TtbBoard; const ABoardName: String = '');
    procedure PutTask(ATask: TtbTask);
    {}
    property Folder: String read FFolder;
  end;

implementation

uses SysUtils, IOUtils, SerializeUtils;

const
  dirHome = 'ToyBox\';
  fnTasks = 'Tasks.txt';
  fnBoard = 'Board.txt';


constructor TtbFileStorage.Create;
begin
  if FInstance = nil then
    FInstance := Self;

  FLines := TStringList.Create;

  FFolder := IncludeTrailingPathDelimiter(TPath.GetHomePath) + dirHome;
  FFileNameFull := FFolder + fnTasks;
end;

destructor TtbFileStorage.Destroy;
begin
  FLines.Free;
  if FInstance = Self then
    FInstance := nil;
  inherited;
end;

function TtbFileStorage.GetBoard(ATarget: TtbBoard; const ABoardName: String = ''): Boolean;
var
  FileName: String;
begin
  if ABoardName.IsEmpty then
    FileName := FFolder + fnBoard
  else
    FileName := FFolder + ABoardName;

  Assert(ATarget <> nil);
  FLines.Clear;
  Result := False;
  if FileExists(FileName) then
    FLines.LoadFromFile(FileName);
  if FLines.Count > 0 then
  begin
    JsonToObject(FLines.Text, ATarget);
    Result := True;
  end;
  FLines.Clear;
end;

procedure TtbFileStorage.PutBoard(ASource: TtbBoard; const ABoardName: String);
var
  FileName: String;
begin
  if ABoardName.IsEmpty then
    FileName := FFolder + fnBoard
  else
    FileName := FFolder + ABoardName;

  if not TDirectory.Exists(FFolder) then
    TDirectory.CreateDirectory(FFolder);

  FLines.Clear;
  FLines.Text := ObjectToJson(ASource);
  FLines.SaveToFile(FileName);
end;

function TtbFileStorage.GetDomain(ATarget: TtbDomain): Boolean;
begin
  Assert(ATarget <> nil);
  FLines.Clear;
  Result := False;
  if FileExists(FFileNameFull) then
    FLines.LoadFromFile(FFileNameFull);
  if FLines.Count > 0 then
  begin
    JsonToObject(FLines.Text, ATarget);
    Result := True;
  end;
  FLines.Clear;
end;

class function TtbFileStorage.GetInstance: TtbFileStorage;
begin
  Result := FInstance;
end;

procedure TtbFileStorage.PutDomain(ASource: TtbDomain);
begin
  if not TDirectory.Exists(FFolder) then
    TDirectory.CreateDirectory(FFolder);

  FLines.Clear;
  FLines.Text := ObjectToJson(ASource);
  FLines.SaveToFile(FFileNameFull);
end;

procedure TtbFileStorage.PutTask(ATask: TtbTask);
begin

end;

end.
