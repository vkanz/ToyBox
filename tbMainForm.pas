unit tbMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList, Vcl.VirtualImage,
  Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.Imaging.pngimage,
  tbDomain, tbBoard, tbRepo, tbBoardIntf, Vcl.TitleBarCtrls;

type
  TForm2 = class(TForm)
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
    TitleBarPanel1: TTitleBarPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DashboardButtonClick(Sender: TObject);
    procedure lblTitleClick(Sender: TObject);
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
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  ShellApi,
  VersionUtils,
  tbTest, tbFileStorage,
  tbBoardFrame;

{ Utils }
procedure ShowWebPage(const AUrl: String);
begin
  ShellExecute(0, 'OPEN', PChar(AUrl), '', '', SW_SHOWNORMAL);
end;

procedure TForm2.DashboardButtonClick(Sender: TObject);
begin
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;

  FCurrentPage := TFrameBoard.CreatePage(Panel_PageContainer, FDomain, FRepo);
  FCurrentPage.Initialize;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveDomainAndBoard;
  CanClose := True;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Panel_PageContainer.Align := alClient;
  SplitView.Opened := False;

  FDomain := TtbDomain.Create;
  FRepo := TtbRepo.Create(TtbFileStorage.Create);

  FRepo.GetDomain(FDomain);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FRepo.Free;
  FDomain.Free;
end;

procedure TForm2.HandleHyperlinkClicked(ASender: TObject);
begin
  if ASender is TTaskDialog then
    ShowWebPage(TTaskDialog(ASender).URL);
end;

procedure TForm2.lblTitleClick(Sender: TObject);
begin
  with TTaskDialog.Create(Self) do
    try
      CustomMainIcon := Application.Icon;
      Caption := 'About ToyBox';
      Title := TProgramVersionInfo.FileDescription; // + #13#10 +
      Text := 'Copyrights: © ' + TProgramVersionInfo.LegalCopyright + #13#10 +
        // ' <a href="https://systemt.ru/">systemt.ru</a>' + #13#10 +
        //'Дата выпуска: ' + VersionUtils.DateOfRelease + #13#10 +
        'Program version: ' + TProgramVersionInfo.ProductVersion + #13#10 +
        'File version: ' + TProgramVersionInfo.FileVersion + #13#10 +
        '<a href="https://www.google.com/search?q=toybox">Home page</a>';
      CommonButtons := [tcbClose];
      Flags := [tfEnableHyperlinks, tfPositionRelativeToWindow, tfUseHiconMain];
      OnHyperlinkClicked := HandleHyperlinkClicked;
      Execute;
    finally
      Free;
    end;
end;

procedure TForm2.MenuVirtualImageClick(Sender: TObject);
begin
  SplitView.Opened := not SplitView.Opened;
end;

procedure TForm2.SaveDomainAndBoard;
begin
  FRepo.PutDomain(FDomain);
  if Assigned(FCurrentPage) then
    FCurrentPage.Finalize;
end;

procedure TForm2.SplitViewClosing(Sender: TObject);
begin
  DashboardButton.Caption := '';
end;

procedure TForm2.SplitViewOpening(Sender: TObject);
begin
  DashboardButton.Caption := '          ' + DashboardButton.Hint;
end;

end.
