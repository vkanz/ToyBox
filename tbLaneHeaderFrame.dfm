object FrameLaneHeader: TFrameLaneHeader
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object GridPanel: TGridPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Label_Header
        Row = 0
      end
      item
        Column = 1
        Control = SpeedButton
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    DesignSize = (
      320
      24)
    object Label_Header: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 290
      Height = 21
      Align = alClient
      Alignment = taCenter
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 6
      ExplicitHeight = 13
    end
    object SpeedButton: TSpeedButton
      Left = 296
      Top = 1
      Width = 23
      Height = 22
      Anchors = []
      Caption = '...'
      Flat = True
      OnClick = SpeedButtonClick
      ExplicitLeft = 152
      ExplicitTop = 0
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 208
    Top = 160
    object MenuItem_AddTask: TMenuItem
      Caption = 'Create Task'
      OnClick = MenuItem_AddTaskClick
    end
  end
end
