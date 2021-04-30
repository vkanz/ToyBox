unit tbTaskForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls,
  tbDomain,
  tbBoardIntf;

type
  TTaskEditor = class(TInterfacedObject, ItbTaskEditor)
    procedure Edit(ATask: TtbTask);
  end;

type
  TFormEditTask = class(TForm)
    Panel_Bottom: TPanel;
    Button_Ok: TButton;
    Button_Cancel: TButton;
    ActionList: TActionList;
    Action_Ok: TAction;
    Action_Cancel: TAction;
    Edit_Title: TEdit;
    Label_Title: TLabel;
    Memo_Text: TMemo;
    Label_Text: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action_OkExecute(Sender: TObject);
    procedure Action_CancelExecute(Sender: TObject);
  private
    FOriginal,
    FTask: TtbTask;
    procedure ObjectToForm;
    procedure FormToObject;
    procedure ApplyStyle;
  public
    class function EditTask(ATask: TtbTask): Boolean;
  end;

implementation

{$R *.dfm}

uses
  UITypes,{Preventing H2443}
  tbStrings;

{ TFormEditTask }

procedure TFormEditTask.Action_OkExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormEditTask.Action_CancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormEditTask.ApplyStyle;
begin
  //Label_ID.Font.Style := Label_ID.Font.Style + [fsBold];
end;

class function TFormEditTask.EditTask(ATask: TtbTask): Boolean;
var
  Fm: TFormEditTask;
begin
  Fm := TFormEditTask.Create(nil);
  try
    Fm.FOriginal := ATask;
    Fm.FTask := ATask.Clone;
    Result := Fm.ShowModal = mrOK;
    if Result then
    begin
      Fm.FormToObject;
      Result := not Fm.FOriginal.IsEqual(Fm.FTask);
    end;
    if Result then
      Fm.FTask.AssignTo(ATask);
  finally
    Fm.Free;
  end;
end;

procedure TFormEditTask.FormCreate(Sender: TObject);
begin
  Label_Title.Caption := rsTitle;
  Label_Text.Caption := rsText;
  ApplyStyle;
  Action_Cancel.Caption := rsButtonCancel;
end;

procedure TFormEditTask.FormDestroy(Sender: TObject);
begin
  FTask.Free;
end;

procedure TFormEditTask.FormShow(Sender: TObject);
begin
  ObjectToForm;
end;

procedure TFormEditTask.FormToObject;
begin
  FTask.Title := Edit_Title.Text;
  FTask.Text := Memo_Text.Lines.Text;
end;

procedure TFormEditTask.ObjectToForm;
begin
  if FTask.ID = newTaskId then
    Caption := rsNewTask
  else
    Caption := FTask.ID.ToString;
  Edit_Title.Text := FTask.Title;
  Memo_Text.Lines.Text := FTask.Text;
end;

{ TTaskEditor }

procedure TTaskEditor.Edit(ATask: TtbTask);
begin
  TFormEditTask.EditTask(ATask);
end;

end.
