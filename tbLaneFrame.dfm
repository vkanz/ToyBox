object FrameLane: TFrameLane
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
      ExplicitLeft = 299
      ExplicitTop = -4
    end
  end
  object ControlList: TControlList
    Left = 0
    Top = 24
    Width = 320
    Height = 216
    Align = alClient
    ItemHeight = 60
    ItemMargins.Left = 0
    ItemMargins.Top = 0
    ItemMargins.Right = 0
    ItemMargins.Bottom = 0
    ParentColor = False
    TabOrder = 1
    OnAfterDrawItem = ControlListAfterDrawItem
    OnBeforeDrawItems = ControlListBeforeDrawItems
    OnDragDrop = ControlListDragDrop
    OnDragOver = ControlListDragOver
    OnShowControl = ControlListShowControl
    OnMouseDown = ControlListMouseDown
    OnStartDrag = ControlListStartDrag
    object Shape_ID: TShape
      Left = 4
      Top = 1
      Width = 25
      Height = 19
      Brush.Color = clHighlight
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object Label_ID: TLabel
      Left = 7
      Top = 3
      Width = 18
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Caption = '000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label_Title: TLabel
      Left = 39
      Top = 4
      Width = 266
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Label_Title'
    end
    object Label_Text: TLabel
      AlignWithMargins = True
      Left = 39
      Top = 18
      Width = 266
      Height = 41
      Margins.Left = 10
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 
        'This is example of item with multi-line text. You can put any TG' +
        'raphicControl on it and adjust properties.'
      EllipsisPosition = epEndEllipsis
      ShowAccelChar = False
      Transparent = True
      WordWrap = True
    end
  end
  object ActionList: TActionList
    OnUpdate = ActionListUpdate
    Left = 112
    Top = 112
    object Action_AddTask: TAction
      Caption = 'Add Task'
      OnExecute = Action_AddTaskExecute
    end
    object Action_DeleteTask: TAction
      Caption = 'Delete Task'
      OnExecute = Action_DeleteTaskExecute
    end
    object Action_EditTask: TAction
      Caption = 'Edit Task'
      OnExecute = Action_EditTaskExecute
    end
  end
  object PopupMenu_Header: TPopupMenu
    Left = 192
    Top = 104
    object AddTask1: TMenuItem
      Action = Action_AddTask
    end
    object DeleteTask1: TMenuItem
      Action = Action_DeleteTask
    end
    object EditTask1: TMenuItem
      Action = Action_EditTask
    end
  end
end
