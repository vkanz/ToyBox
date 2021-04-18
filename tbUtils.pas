unit tbUtils;

interface

{Shows file or folder in Explorer}
procedure ShowFile(const APath: String);
procedure ShowWebPage(const AUrl: String);

implementation

uses SysUtils, ShellApi, Windows, Forms;

procedure ShowFile(const APath: String);
var
  Command,
  Path,
  FileName,
  Params : String;
begin
  Command := 'explorer';
  Path := SysUtils.ExtractFilePath(APath);
  FileName := SysUtils.ExtractFileName(APath);

  if FileName = '' then
  begin
    Params := Path;
    if not DirectoryExists(APath) then
      raise SysUtils.Exception.CreateFmt('Папка "%s" не найдена', [APath]);
  end
  else
  begin
    Params := Format('/select, "%s%s"', [Path, FileName]);
    if not FileExists(APath) then
      raise SysUtils.Exception.CreateFmt('Файл "%s" не найден', [APath]);
  end;

  ShellApi.ShellExecute(
     Forms.Application.MainForm.Handle, nil{Operation},
     PChar(Command), PChar(Params), ''{DefaultDir},
     Windows.SW_SHOW{ShowCmd})
end;

procedure ShowWebPage(const AUrl: String);
begin
  ShellExecute(0, 'OPEN', PChar(AUrl), '', '', SW_SHOWNORMAL);
end;

end.
