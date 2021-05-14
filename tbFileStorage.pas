unit tbFileStorage;

interface

uses tbboard, Classes,
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
    FDomainLink: TtbDomain;
  protected
    property FileNameFull: String read FFileNameFull;
    class procedure SaveHistory(const AFileName: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveTask(ATask: TtbTask);
    { ItbStorage }
    function GetDomain(ATarget: TtbDomain): Boolean;
    procedure PutDomain(ASource: TtbDomain);
    function GetBoard(ATarget: TtbBoard; const ABoardName: String = ''): Boolean;
    procedure PutBoard(ASource: TtbBoard; const ABoardName: String = '');
    procedure ItbStorage.PostTask = SaveTask;
    {}
    property Folder: String read FFolder;
  end;

implementation

uses SysUtils, IOUtils, Types, DateUtils, Generics.Collections, Generics.Defaults,
  SerializeUtils;

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
    FDomainLink := ATarget;
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
  SaveHistory(FFileNameFull);
  FLines.SaveToFile(FFileNameFull);
end;

class procedure TtbFileStorage.SaveHistory(const AFileName: String);
const
  depth = 9;
var
  HistDir: String;
  ClearFileName,
  NewFileName: String;
  FileArr: TStringDynArray;
begin
  HistDir := TPath.Combine(TPath.GetDirectoryName(AFileName), '__history');
  ClearFileName := TPath.GetFileName(AFileName);
  if not TDirectory.Exists(HistDir) then
    TDirectory.CreateDirectory(HistDir);

  FileArr := TDirectory.GetFiles(HistDir, ClearFileName + '.~*~', TSearchOption.soTopDirectoryOnly);
  if Length(FileArr) < depth then
    NewFileName := ClearFileName + '.~' + (Length(FileArr) + 1).ToString + '~'
  else
  begin
    TArray.Sort<String>(FileArr, TDelegatedComparer<String>.Construct(
      function(const Left, Right: String): Integer
      begin
        Result := CompareDateTime(
          TFile.GetLastWriteTime(TPath.Combine(HistDir, Left)),
          TFile.GetLastWriteTime(TPath.Combine(HistDir, Right))
          );
      end)
      );
    NewFileName := FileArr[0];
  end;
  TFile.Copy(AFileName, TPath.Combine(HistDir, NewFileName), True{Owerwrite});
end;

procedure TtbFileStorage.SaveTask(ATask: TtbTask);
begin
  Assert(ATask <> nil);
  if ATask.ID = newTaskId then
  begin
    ATask.ID := FDomainLink.GetNextTaskID;
    FDomainLink.AddTask(ATask);
  end;
  PutDomain(FDomainLink); {Save all the domain}
end;

end.
