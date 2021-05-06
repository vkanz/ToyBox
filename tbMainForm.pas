// *************************************************************************** }
//
// ToyBox task management tool
//
// Copyright (c) 2021-2020
//
// https://github.com/vkanz/toybox
//
// ***************************************************************************
// Pacers:
// https://flowlu.ru/uses/project-task/
unit tbMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList, Vcl.VirtualImage,
  Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.TitleBarCtrls,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.Imaging.pngimage,
  tbDomain,
  tbBoard,
  tbRepo,
  tbEvents,
  tbBoardIntf;

type
  TFormMain = class(TForm)
    SplitView: TSplitView;
    NavPanel: TPanel;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    pnlToolbar: TPanel;
    lblTitle: TLabel;
    MenuVirtualImage: TVirtualImage;
    Panel1: TPanel;
    Image1: TImage;
    Button_Calendar: TButton;
    Panel_PageContainer: TPanel;
    TitleBarPanel: TTitleBarPanel;
    Button_Board: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button_BoardClick(Sender: TObject);
    procedure lblTitleClick(Sender: TObject);
    procedure TitleBarPanelCustomButtons0Click(Sender: TObject);
    procedure TitleBarPanelCustomButtons0Paint(Sender: TObject);
    procedure Button_CalendarClick(Sender: TObject);
  private
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FCurrentPage: ItbPage;
  protected
    procedure SaveState;
    procedure RestoreState;
    procedure HandleHyperlinkClicked(ASender: TObject);
  public
    procedure SaveDomainAndBoard;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  ShellApi, Math,
  EventBus,
  VersionUtils,
  TitleUtils,
  tbStrings,
  tbTest,
  tbUtils,
  tbFileStorage,
  tbBoardFrame,
  tbCalendarFrame,
  tbTaskForm;

{ Utils }
procedure ShowWebPage(const AUrl: String);
begin
  ShellExecute(0, 'OPEN', PChar(AUrl), '', '', SW_SHOWNORMAL);
end;

procedure TFormMain.Button_BoardClick(Sender: TObject);
begin
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;

  FCurrentPage := TFrameBoard.CreatePage(Panel_PageContainer, FDomain, FRepo,
    TTaskEditor.Create);
  FCurrentPage.Initialize;
end;

procedure TFormMain.Button_CalendarClick(Sender: TObject);
begin
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;

  FCurrentPage := TFrameCalendar.CreatePage(Panel_PageContainer);
  FCurrentPage.Initialize;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveDomainAndBoard;
  CanClose := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  Panel_PageContainer.Align := alClient;
  SplitView.Opened := False;

  FDomain := TtbDomain.Create;
  FRepo := TtbRepo.Create(TtbFileStorage.Create);

  FRepo.GetDomain(FDomain);
  RestoreState;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  SaveState;
  FRepo.Free;
  FDomain.Free;
end;

procedure TFormMain.HandleHyperlinkClicked(ASender: TObject);
begin
  if ASender is TTaskDialog then
    ShowWebPage(TTaskDialog(ASender).URL);
end;

procedure TFormMain.lblTitleClick(Sender: TObject);
begin
  with TTaskDialog.Create(Self) do
    try
      CustomMainIcon := Application.Icon;
      Caption := rsAboutToyBox;
      Title := TProgramVersionInfo.FileDescription; // + #13#10 +
      Text := '© ' + TProgramVersionInfo.LegalCopyright + #13#10 +
        // ' <a href="https://systemt.ru/">systemt.ru</a>' + #13#10 +
        //'Date: ' + VersionUtils.DateOfRelease + #13#10 +
        rsProgramVersion + TProgramVersionInfo.ProductVersion + #13#10 +
        rsFileVersion + TProgramVersionInfo.FileVersion + #13#10 +
        '<a href="https://www.google.com/search?q=toybox">Home page</a>';
      CommonButtons := [tcbClose];
      Flags := [tfEnableHyperlinks, tfPositionRelativeToWindow, tfUseHiconMain];
      OnHyperlinkClicked := HandleHyperlinkClicked;
      Execute;
    finally
      Free;
    end;
end;

procedure TFormMain.MenuVirtualImageClick(Sender: TObject);
begin
  SplitView.Opened := not SplitView.Opened;
end;

procedure TFormMain.RestoreState;
begin
  Button_BoardClick(nil);
  Button_Board.SetFocus;
end;

procedure TFormMain.SaveDomainAndBoard;
begin
  FRepo.PutDomain(FDomain);
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;
end;

procedure TFormMain.SaveState;
begin

end;

procedure TFormMain.SplitViewClosing(Sender: TObject);
begin
  Button_Board.Caption := '';
  Button_Calendar.Caption := '';
end;

procedure TFormMain.SplitViewOpening(Sender: TObject);
begin
  Button_Board.Caption := '          ' + Button_Board.Hint;
  Button_Calendar.Caption := '      ' + Button_Calendar.Hint;
end;

procedure TFormMain.TitleBarPanelCustomButtons0Click(Sender: TObject);
begin
  tbUtils.ShowFile(TtbFileStorage.GetInstance.Folder);
end;

procedure TFormMain.TitleBarPanelCustomButtons0Paint(Sender: TObject);
var
  Button: TSystemTitlebarButton;
begin
  if Sender is TSystemTitlebarButton then
  begin
    Button := TSystemTitlebarButton(Sender);
    DrawSymbol(Button.Canvas, Button.ClientRect,
      IfThen(Active, CustomTitleBar.ButtonForegroundColor, CustomTitleBar.ButtonInactiveForegroundColor),
      IfThen(Active, CustomTitleBar.ButtonBackgroundColor, CustomTitleBar.ButtonInactiveBackgroundColor),
      CurrentPPI, Screen.DefaultPixelsPerInch);
  end;
end;

end.
