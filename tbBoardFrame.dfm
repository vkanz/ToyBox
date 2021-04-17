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
    object Button2: TButton
      Left = 384
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 0
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
    object ActionLaneAddTask1: TMenuItem
      Action = Action_LaneAddTask
    end
  end
  object ActionList: TActionList
    Left = 400
    Top = 200
    object Action_TaskEdit: TAction
      Category = 'task'
      Caption = 'Action_TaskEdit'
    end
    object Action_TaskDelete: TAction
      Category = 'task'
      Caption = 'Action_TaskDelete'
    end
    object Action_LaneAddTask: TAction
      Category = 'lane'
      Caption = 'Action_LaneAddTask'
      OnExecute = Action_LaneAddTaskExecute
    end
    object Action_LaneSortByName: TAction
      Category = 'lane'
      Caption = 'Action_LaneSortByName'
    end
    object Action_LaneSortByCreated: TAction
      Category = 'lane'
      Caption = 'Action_LaneSortByCreated'
    end
    object Action_LaneSortAsc: TAction
      Category = 'lane'
      Caption = 'Action_LaneSortAsc'
    end
    object Action_LaneSortDesc: TAction
      Category = 'lane'
      Caption = 'Action_LaneSortDesc'
    end
  end
end
