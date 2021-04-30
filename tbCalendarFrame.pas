unit tbCalendarFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  tbBoardIntf, Vcl.WinXCalendars;

type
  TFrameCalendar = class(TFrame, ItbPage)
    CalendarView1: TCalendarView;
    procedure CalendarView1DrawDayItem(Sender: TObject; DrawParams: TDrawViewInfoParams;
      CalendarViewViewInfo: TCellItemViewInfo);
  private
    { Private declarations }
  public
    class function CreatePage(AParent: TWinControl): ItbPage;
    procedure Initialize;
    procedure Finalize;
  end;

implementation

{$R *.dfm}

uses DateUtils;

{ TFrameCalendar }

procedure TFrameCalendar.CalendarView1DrawDayItem(Sender: TObject; DrawParams: TDrawViewInfoParams;
  CalendarViewViewInfo: TCellItemViewInfo);
var d: integer;
begin
  d := DayOfTheWeek(CalendarViewViewInfo.Date);
  if (d = 6) or (d = 7) then
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

procedure TFrameCalendar.Initialize;
begin

end;

end.
