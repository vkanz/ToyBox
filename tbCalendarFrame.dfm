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
    Height = 217
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
  end
  object Panel_Toolbar: TPanel
    Left = 0
    Top = 217
    Width = 320
    Height = 23
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 223
    object GridPanel_Zoom: TGridPanel
      Left = 264
      Top = 0
      Width = 56
      Height = 23
      Align = alRight
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Button_Less
          Row = 0
        end
        item
          Column = 1
          Control = Button_More
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      DesignSize = (
        56
        23)
      object Button_Less: TSpeedButton
        Left = 2
        Top = 1
        Width = 23
        Height = 21
        Anchors = []
        Caption = '-'
        Flat = True
        OnClick = Button_LessClick
        ExplicitLeft = 288
        ExplicitTop = 8
      end
      object Button_More: TSpeedButton
        Left = 30
        Top = 1
        Width = 23
        Height = 21
        Anchors = []
        Caption = '+'
        Flat = True
        OnClick = Button_MoreClick
        ExplicitLeft = 48
        ExplicitTop = 16
      end
    end
  end
end
