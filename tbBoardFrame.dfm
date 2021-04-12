object FrameBoard: TFrameBoard
  Left = 0
  Top = 0
  Width = 669
  Height = 397
  TabOrder = 0
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 669
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 296
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 384
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GridPanel: TGridPanel
    Left = 0
    Top = 41
    Width = 669
    Height = 356
    Align = alClient
    BevelOuter = bvNone
    Caption = 'GridPanel'
    ColumnCollection = <>
    ControlCollection = <>
    ExpandStyle = emAddColumns
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 1
    ExplicitTop = 8
    ExplicitHeight = 41
  end
end
