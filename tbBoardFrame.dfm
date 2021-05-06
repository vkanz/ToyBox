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
    Visible = False
  end
  object GridPanel: TGridPanel
    Left = 0
    Top = 41
    Width = 669
    Height = 356
    Align = alClient
    BevelOuter = bvNone
    Caption = 'GridPanel'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
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
  end
  object PopupMenu_Task: TPopupMenu
    Left = 384
    Top = 112
  end
  object ActionList: TActionList
    Left = 400
    Top = 200
  end
end
