// *************************************************************************** }
//
// ToyBox task management tool
//
// Copyright (c) 2021-2020
//
// https://github.com/vkanz/toybox
//
// ***************************************************************************
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
    DashboardButton: TButton;
    Panel_PageContainer: TPanel;
    TitleBarPanel: TTitleBarPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DashboardButtonClick(Sender: TObject);
    procedure lblTitleClick(Sender: TObject);
    procedure TitleBarPanelCustomButtons0Click(Sender: TObject);
    procedure TitleBarPanelCustomButtons0Paint(Sender: TObject);
  private
    FDomain: TtbDomain;
    FRepo: TtbRepo;
    FCurrentPage: ItbPage;
  protected
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
  tbTaskForm;

{ Utils }
procedure ShowWebPage(const AUrl: String);
begin
  ShellExecute(0, 'OPEN', PChar(AUrl), '', '', SW_SHOWNORMAL);
end;

procedure TFormMain.DashboardButtonClick(Sender: TObject);
begin
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;

  FCurrentPage := TFrameBoard.CreatePage(Panel_PageContainer, FDomain, FRepo,
    TTaskEditor.Create);
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
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
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

procedure TFormMain.SaveDomainAndBoard;
begin
  FRepo.PutDomain(FDomain);
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;
end;

procedure TFormMain.SplitViewClosing(Sender: TObject);
begin
  DashboardButton.Caption := '';
end;

procedure TFormMain.SplitViewOpening(Sender: TObject);
begin
  DashboardButton.Caption := '          ' + DashboardButton.Hint;
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
