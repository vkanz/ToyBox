unit tbDBStorage;

interface

uses tbDomain;

type
  TtbDatabaseProcessor = class
    class procedure UpsertTask(ATask: TtbTask);
  end;

implementation

uses SysUtils,
  MVCFramework.Logger,
  MVCFramework.ActiveRecord,
  tbDomainDTO,
  tbTransform;

const
  raiseOnEOF = True;

class procedure TtbDatabaseProcessor.UpsertTask(ATask: TtbTask);
var
  TaskInDB: TtbTaskDTO;
begin
  TaskInDB := nil;
  try
    if not ATask.IsNew then
    begin
      TaskInDB := TMVCActiveRecord.GetByPK<TtbTaskDTO>(ATask.ID, not raiseOnEOF);
      if not Assigned(TaskInDB) then
        raise Exception.CreateFmt('Task.ID=%d is not found in database', [ATask.ID]);

      TtbTransform.TaskToDto(ATask, TaskInDB);
      TaskInDB.Update;
      //Render204NoContent('', 'Task updated');
    end
    else
    begin
      TtbTransform.TaskToDto(ATask, TaskInDB);
      TaskInDB.Insert;
      ATask.ID := TaskInDB.ID;
      //Render201Created(TtbConstants.uriTask + '/' + ATask.ID.ToString);
    end;
  finally
    if Assigned(TaskInDB) then
      TaskInDB.Free;
  end;
end;

end.
