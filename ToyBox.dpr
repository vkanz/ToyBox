program ToyBox;

{.$DEFINE DZHTML}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  tbMainForm in 'tbMainForm.pas' {FormMain},
  tbBoardFrame in 'tbBoardFrame.pas' {FrameBoard: TFrame},
  tbDomain in 'tbDomain.pas',
  tbRepo in 'tbRepo.pas',
  tbFileStorage in 'tbFileStorage.pas',
  SerializeUtils in 'SerializeUtils.pas',
  tbTest in 'tbTest.pas',
  tbBoard in 'tbBoard.pas',
  tbLaneFrame in 'tbLaneFrame.pas' {FrameLane: TFrame},
  tbBoardIntf in 'tbBoardIntf.pas',
  VersionUtils in 'VersionUtils.pas',
  tbUtils in 'tbUtils.pas',
  TitleUtils in 'TitleUtils.pas',
  tbEvents in 'tbEvents.pas',
  tbTaskForm in 'tbTaskForm.pas' {FormEditTask},
  tbStrings in 'tbStrings.pas'
{$IFDEF DZHTML}
  ,Vcl.DzHTMLText in '..\3d-party\Vcl.DzHTMLText.pas'
{$ENDIF}
  ;

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ToyBox';
  //TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
