unit tbMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList, Vcl.VirtualImage,
  tbDomain, tbBoardFrame, tbBoard, tbRepo, Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.Imaging.pngimage;

type
  TForm2 = class(TForm)
    GridPanel: TGridPanel;
    SplitView: TSplitView;
    NavPanel: TPanel;
    Image5: TImage;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    pnlToolbar: TPanel;
    lblTitle: TLabel;
    MenuVirtualImage: TVirtualImage;
    Panel1: TPanel;
    Image1: TImage;
    DashboardButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FDomain: TtbDomain;
    FBoard: TtbBoard;
    FBoardAdapter: TtbBoardAdapter;
    FRepo: TtbRepo;
  public
    procedure SaveDomainAndBoard;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  tbTest, tbFileStorage;

procedure TForm2.Button2Click(Sender: TObject);
begin
  var Lane := TtbLane.Create;
  Lane.Title := 'Done';
  FBoard.Lanes.Add(Lane);
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveDomainAndBoard;
  CanClose := True;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FDomain := TtbDomain.Create;
  FBoard := TtbBoard.Create;
  FBoardAdapter := TtbBoardAdapter.Create(Self);
  FRepo := TtbRepo.Create(TtbFileStorage.Create);

  FRepo.GetDomain(FDomain);
  FRepo.GetBoard(FBoard);
  //CreateTestData(FDomain, FBoard);

  FBoardAdapter.GridPanel := GridPanel;
  FBoardAdapter.Board := FBoard;
  FBoardAdapter.Domain := FDomain;
  FBoardAdapter.Draw;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FRepo.Free;
  FBoard.Free;
  FDomain.Free;
end;

procedure TForm2.MenuVirtualImageClick(Sender: TObject);
begin
  SplitView.Opened := not SplitView.Opened;
end;

procedure TForm2.SaveDomainAndBoard;
begin
  FRepo.PutDomain(FDomain);
  FRepo.PutBoard(FBoard);
end;

procedure TForm2.SplitViewClosing(Sender: TObject);
begin
  DashboardButton.Caption := '';
end;

procedure TForm2.SplitViewOpening(Sender: TObject);
begin
  DashboardButton.Caption := '          '+DashboardButton.Hint;
end;

end.
