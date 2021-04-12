unit VersionUtils;

interface

type
  TProgramVersionInfo = class
  private const
    parStringFileInfo = 'StringFileInfo';
    parFileDescription = 'FileDescription';
    parLegalCopyright = 'LegalCopyright';
    parDateOfRelease = 'DateOfRelease';
    parProductVersion = 'ProductVersion';
    parFileVersion = 'FileVersion';
  public
    class function FileDescription: String;
    class function LegalCopyright: String;
    class function DateOfRelease: String; // Proprietary
    class function ProductVersion: String;
    class function FileVersion: String;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, System.Classes, Math;

(*
  function GetHeader(out AHdr: TVSFixedFileInfo): Boolean;

  var
  BFixedFileInfo: PVSFixedFileInfo;
  RM: TMemoryStream;
  RS: TResourceStream;
  BL: Cardinal;

  begin
  Result := False;
  RM := TMemoryStream.Create;
  try
  RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
  try
  RM.CopyFrom(RS, RS.Size);
  finally
  FreeAndNil(RS);
  end;

  // Extract header
  if not VerQueryValue(RM.Memory, '\\', Pointer(BFixedFileInfo), BL) then
  Exit;

  // Prepare result
  CopyMemory(@AHdr, BFixedFileInfo, Math.Min(sizeof(AHdr), BL));
  Result := True;
  finally
  FreeAndNil(RM);
  end;
  end;
*)

function GetVersionInfo(AIdent: String): String;

type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;

  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  Resources: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;
begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    Resources := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(Resources, Resources.Size);
    finally
      FreeAndNil(Resources);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div SizeOf(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\' + TProgramVersionInfo.parStringFileInfo + '\\' + BLangId + '\\' + AIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;

class function TProgramVersionInfo.FileDescription: String;
begin
  Result := GetVersionInfo(parFileDescription);
end;

class function TProgramVersionInfo.LegalCopyright: String;
begin
  Result := GetVersionInfo(parLegalCopyright);
end;

class function TProgramVersionInfo.DateOfRelease: String;
begin
  Result := GetVersionInfo(parDateOfRelease);
end;

class function TProgramVersionInfo.ProductVersion: String;
begin
  Result := GetVersionInfo(parProductVersion);
end;

class function TProgramVersionInfo.FileVersion: String;
begin
  Result := GetVersionInfo(parFileVersion);
end;

end.
