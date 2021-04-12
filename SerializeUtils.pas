unit SerializeUtils;

interface

{ Используется фреймворк MVCFramework, см. shturman.4\Clinic\DMVC\ReadMe.txt }

uses MVCFramework.Serializer.JsonDataObjects, MVCFramework.Serializer.Commons;

function ObjectToJson(AObject: TObject): String;
function ObjectToJsonBeautify(AObject: TObject): String;

{ Объект AObject должен быть предварительно создан }
procedure JsonToObject(const AJson: String; const AObject: TObject);

implementation

{Используются модули Converters, Writers из поставки Delphi:
 x:\Users\Public\Documents\Embarcadero\Studio\19.0\Samples\Object Pascal\RTL\Json
}
uses Converters, Writers;

function ObjectToJson(AObject: TObject): String;
var
  Serializer: TMVCJsonDataObjectsSerializer;
begin
  Serializer := TMVCJsonDataObjectsSerializer.Create;
  try
    Result := Serializer.SerializeObject(AObject, stDefault, [], nil);
  finally
    Serializer.Free;
  end;
end;

procedure JsonToObject(const AJson: String; const AObject: TObject);
var
  Serializer: TMVCJsonDataObjectsSerializer;
begin
  Serializer := TMVCJsonDataObjectsSerializer.Create;
  try
    Serializer.DeserializeObject(AJson, AObject, stDefault, []);
  finally
    Serializer.Free;
  end;
end;

function ObjectToJsonBeautify(AObject: TObject): String;
var
  Minified: String;
begin
  Minified := ObjectToJson(AObject);
  Result := TConverters.JsonReformat(Minified, True);
end;

end.
