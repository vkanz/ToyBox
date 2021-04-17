program ToyBox;

uses
  Vcl.Forms,
  tbMainForm in 'tbMainForm.pas' {FormMain},
  tbData in 'tbData.pas' {TeamWorkData: TDataModule},
  tbBoardFrame in 'tbBoardFrame.pas' {FrameBoard: TFrame},
  tbDomain in 'tbDomain.pas',
  tbRepo in 'tbRepo.pas',
  tbFileStorage in 'tbFileStorage.pas',
  SerializeUtils in 'SerializeUtils.pas',
  tbTest in 'tbTest.pas',
  tbBoard in 'tbBoard.pas',
  tbLaneFrame in 'tbLaneFrame.pas' {FrameLaneHeader: TFrame},
  tbBoardIntf in 'tbBoardIntf.pas',
  VersionUtils in 'VersionUtils.pas';

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ToyBox';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TTeamWorkData, TeamWorkData);
  Application.Run;
end.
