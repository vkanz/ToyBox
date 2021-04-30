object FrameLane: TFrameLane
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object GridPanel: TGridPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 314
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    Color = clActiveCaption
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
    ParentBackground = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    DesignSize = (
      314
      24)
    object Label_Header: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 284
      Height = 21
      Align = alClient
      Alignment = taCenter
      Caption = '?'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ExplicitWidth = 6
      ExplicitHeight = 13
    end
    object SpeedButton: TSpeedButton
      Left = 290
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
    Top = 30
    Width = 320
    Height = 210
    Align = alClient
    ItemHeight = 60
    ItemMargins.Left = 0
    ItemMargins.Top = 0
    ItemMargins.Right = 0
    ItemMargins.Bottom = 0
    ParentColor = False
    TabOrder = 1
    OnBeforeDrawItem = ControlListBeforeDrawItem
    OnDragDrop = ControlListDragDrop
    OnDragOver = ControlListDragOver
    OnMouseDown = ControlListMouseDown
    OnStartDrag = ControlListStartDrag
    object Shape_ID: TShape
      Left = 2
      Top = 2
      Width = 15
      Height = 15
      Brush.Color = clActiveCaption
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object Label_ID: TLabel
      Left = 6
      Top = 2
      Width = 6
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Caption = '0'
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
      Width = 51
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Label_Title'
      Color = clBlack
      ParentColor = False
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
        'raphicControl on it and adjust properties. This is example of it' +
        'em with multi-line text. You can put any TGraphicControl on it a' +
        'nd adjust properties.'
      Color = clWindow
      EllipsisPosition = epEndEllipsis
      ParentColor = False
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
