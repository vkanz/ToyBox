unit tbBoardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.ControlList, Vcl.ExtCtrls;

type
  TFrame2 = class(TFrame)
    Panel_Top: TPanel;
    Panel_Client: TPanel;
    GridPanel1: TGridPanel;
    ControlList1: TControlList;
    ControlList2: TControlList;
    Label2: TLabel;
    VirtualImage1: TVirtualImage;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure TuneControlList(AControlList: TControlList);
  protected
    procedure HandleControlList1ShowControl(const AIndex: Integer; AControl: TControl;
      var AVisible: Boolean);

  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

function FindParentControlList(AControl: TControl; out AControlList: TControlList): Boolean;
begin
  AControlList := nil;
  repeat
    if AControl <> nil then
      if (AControl.Parent <> nil) and (AControl.Parent is TControlList) then
        AControlList := TControlList(AControl.Parent)
      else
        AControl := AControl.Parent;
  until (AControl = nil) or (AControlList <> nil);
  Result := AControlList <> nil;
end;

procedure TFrame2.Button1Click(Sender: TObject);
var
  B: TButton;
begin
  //GridPanel1.ColumnCollection.Add;
  B := TButton.Create(Self);
  B.Parent := GridPanel1;
  B.Caption := 'qqq';
  GridPanel1.ControlCollection.AddControl(B);
end;

procedure TFrame2.Button2Click(Sender: TObject);
begin
  (Parent as TForm).Caption := 'C=' + GridPanel1.ColumnCollection.Count.ToString +
    'R=' + GridPanel1.RowCollection.Count.ToString;
end;

constructor TFrame2.Create(AOwner: TComponent);
begin
  inherited;
  TuneControlList(ControlList1);
  TuneControlList(ControlList2);
end;

procedure TFrame2.HandleControlList1ShowControl(const AIndex: Integer; AControl: TControl; var AVisible: Boolean);
var
  ControlList: TControlList;
begin
  if FindParentControlList(AControl, ControlList) then
  begin
//    if AControl = Label1 then
//      Label1.Caption := ControlList.Name + 'Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium ' +
//      'doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi';
  end;
end;

procedure TFrame2.TuneControlList(AControlList: TControlList);
begin
  with AControlList do
  begin
    AlignWithMargins := True;
    Align := alClient;
    ItemColor := clBtnFace;
    ItemMargins.Left := 2;
    ItemMargins.Top := 2;
    ItemMargins.Right := 2;
    ItemMargins.Bottom := 2;
    ItemSelectionOptions.HotColorAlpha := 20;
    ItemSelectionOptions.SelectedColorAlpha := 30;
    ItemSelectionOptions.FocusedColorAlpha := 40;
    OnShowControl := HandleControlList1ShowControl;
  end;
end;

end.
