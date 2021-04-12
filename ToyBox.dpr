program ToyBox;

uses
  Vcl.Forms,
  tbMainForm in 'tbMainForm.pas' {Form2},
  tbData in 'tbData.pas' {TeamWorkData: TDataModule},
  tbBoardFrame in 'tbBoardFrame.pas' {FrameBoard: TFrame},
  tbDomain in 'tbDomain.pas',
  tbRepo in 'tbRepo.pas',
  tbFileStorage in 'tbFileStorage.pas',
  SerializeUtils in 'SerializeUtils.pas' {$R *.res},
  tbTest in 'tbTest.pas',
  tbBoard in 'tbBoard.pas',
  tbLaneHeaderFrame in 'tbLaneHeaderFrame.pas' {FrameLaneHeader: TFrame},
  tbBoardIntf in 'tbBoardIntf.pas',
  tbTaskFrame in 'tbTaskFrame.pas' {FrameTask: TFrame},
  VersionUtils in 'VersionUtils.pas';

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ToyBox';
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TTeamWorkData, TeamWorkData);
  Application.Run;
end.
