unit tbTest;

interface

uses tbboard, tbDomain;
procedure CreateTestData(ADomain: TtbDomain; ABoard: TtbBoard);

implementation

procedure CreateTestData(ADomain: TtbDomain; ABoard: TtbBoard);
var
  Lane: TtbLane;
begin
  Assert(ADomain <> nil);
  { Persons }
  ADomain.Persons.Add(TtbPerson.Create(1, '��� �������', 'tolstoy', '��'));

  { Tasks }
  ADomain.AddTask(TtbTask.CreateParams(1, 'Task1', 'Thsis is just a test task', '', 1));
  ADomain.AddTask(TtbTask.CreateParams(2, 'Task2', 'Another test task', '', 1));
  ADomain.AddTask(TtbTask.CreateParams(3, 'Task3', 'Tasks sprout like mushrooms in the rain', '', 1));

  { Board }
  Lane := TtbLane.Create;
  Lane.Title := 'ToDo';
  Lane.TaskIdList := '1,2';
  ABoard.Lanes.Add(Lane);

  Lane := TtbLane.Create;
  Lane.Title := 'InProcess';
  Lane.TaskIdList := '3';
  ABoard.Lanes.Add(Lane);
end;

end.
