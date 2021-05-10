unit tbCalendarFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  tbBoardIntf, Vcl.WinXCalendars, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrameCalendar = class(TFrame, ItbPage)
    CalendarView: TCalendarView;
    Panel_Toolbar: TPanel;
    GridPanel_Zoom: TGridPanel;
    Button_Less: TSpeedButton;
    Button_More: TSpeedButton;
    procedure CalendarViewDrawDayItem(Sender: TObject; DrawParams: TDrawViewInfoParams;
      CalendarViewViewInfo: TCellItemViewInfo);
    procedure Button_LessClick(Sender: TObject);
    procedure Button_MoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    class function CreatePage(AParent: TWinControl): ItbPage;
    { ItbPage }
    procedure Initialize;
    procedure Finalize;
    function GetPageKind: TtbPageKind;
  end;

implementation

{$R *.dfm}

uses DateUtils;

{ TFrameCalendar }

procedure TFrameCalendar.Button_LessClick(Sender: TObject);
begin
  if CalendarView.NumberOfWeeksInView < 8 then
    CalendarView.NumberOfWeeksInView := CalendarView.NumberOfWeeksInView + 1;
end;

procedure TFrameCalendar.Button_MoreClick(Sender: TObject);
begin
  if CalendarView.NumberOfWeeksInView > 2 then
    CalendarView.NumberOfWeeksInView := CalendarView.NumberOfWeeksInView - 1;
end;

procedure TFrameCalendar.CalendarViewDrawDayItem(Sender: TObject; DrawParams: TDrawViewInfoParams;
  CalendarViewViewInfo: TCellItemViewInfo);
var d: integer;
begin
  d := DayOfTheWeek(CalendarViewViewInfo.Date);
  if d in [6, 7] then
  begin
    DrawParams.ForegroundColor := clRed;
    //DrawParams.GroupText := 'grp';
  end;
end;

class function TFrameCalendar.CreatePage(AParent: TWinControl): ItbPage;
var
  Frm: TFrameCalendar;
begin
  Frm := TFrameCalendar.Create(nil);
  Frm.Parent := AParent;
  Frm.Align := alClient;
  Result := Frm as ItbPage;
end;

procedure TFrameCalendar.Finalize;
begin

end;

function TFrameCalendar.GetPageKind: TtbPageKind;
begin
  Result := TtbPageKind.Calendar;
end;

procedure TFrameCalendar.Initialize;
begin

end;

end.
