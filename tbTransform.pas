unit tbTransform;

interface

uses tbDomain, tbDomainDTO;

type
  TtbTransform = class
    class procedure TaskFromDto(ASource: TtbTaskDTO; ATarget: TtbTask);
    class procedure TaskToDto(ASource: TtbTask; ATarget: TtbTaskDTO);
  end;

implementation

{ TtbTransfor }

class procedure TtbTransform.TaskFromDto(ASource: TtbTaskDTO; ATarget: TtbTask);
begin
  ATarget.ID := ASource.ID;
  ATarget.Title := ASource.Title;
  ATarget.Text := ASource.Text;
  ATarget.Tags := ASource.Tags;
  ATarget.CreatedBy := ASource.Created_By;
  ATarget.AssignedTo := ASource.Assigned_To;
  ATarget.Status := TtbTaskStatus(ASource.Status);
end;

class procedure TtbTransform.TaskToDto(ASource: TtbTask; ATarget: TtbTaskDTO);
begin
  ATarget.ID := ASource.ID;
  ATarget.Title := ASource.Title;
  ATarget.Text := ASource.Text;
  ATarget.Tags := ASource.Tags;
  ATarget.Created_By := ASource.CreatedBy;
  ATarget.Assigned_To := ASource.AssignedTo;
  ATarget.Status := Integer(ASource.Status);
end;

end.
