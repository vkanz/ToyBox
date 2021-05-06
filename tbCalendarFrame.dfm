object FrameCalendar: TFrameCalendar
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object CalendarView: TCalendarView
    Left = 0
    Top = 0
    Width = 320
    Height = 212
    Align = alClient
    Date = 44312.000000000000000000
    FirstDayOfWeek = dwMonday
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    HeaderInfo.DaysOfWeekFont.Charset = DEFAULT_CHARSET
    HeaderInfo.DaysOfWeekFont.Color = clWindowText
    HeaderInfo.DaysOfWeekFont.Height = -13
    HeaderInfo.DaysOfWeekFont.Name = 'Segoe UI'
    HeaderInfo.DaysOfWeekFont.Style = []
    HeaderInfo.Font.Charset = DEFAULT_CHARSET
    HeaderInfo.Font.Color = clWindowText
    HeaderInfo.Font.Height = -20
    HeaderInfo.Font.Name = 'Segoe UI'
    HeaderInfo.Font.Style = []
    OnDrawDayItem = CalendarViewDrawDayItem
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 32
    ExplicitHeight = 208
  end
  object Panel_Toolbar: TPanel
    Left = 0
    Top = 212
    Width = 320
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object TrackBar_Weeks: TTrackBar
      AlignWithMargins = True
      Left = 212
      Top = 3
      Width = 100
      Height = 22
      Margins.Right = 8
      Align = alRight
      Max = 8
      Min = 2
      PageSize = 1
      Position = 6
      TabOrder = 0
      TickStyle = tsNone
      OnChange = TrackBar_WeeksChange
      ExplicitLeft = 208
      ExplicitHeight = 20
    end
  end
end
