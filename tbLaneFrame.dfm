object FrameLane: TFrameLane
  Left = 0
  Top = 0
  Width = 312
  Height = 240
  TabOrder = 0
  object GridPanel: TGridPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 306
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
      306
      24)
    object Label_Header: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 276
      Height = 18
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
      OnDragDrop = Label_HeaderDragDrop
      OnDragOver = Label_HeaderDragOver
      OnMouseDown = Label_HeaderMouseDown
      OnStartDrag = Label_HeaderStartDrag
      ExplicitWidth = 6
      ExplicitHeight = 13
    end
    object SpeedButton: TSpeedButton
      Left = 282
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
    Width = 312
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
    OnClick = ControlListClick
    OnDragDrop = ControlListDragDrop
    OnDragOver = ControlListDragOver
    OnKeyUp = ControlListKeyUp
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
    object Button_Edit: TControlListButton
      Left = 112
      Top = 1
      Width = 25
      Height = 25
      Action = Action_EditTask
      Images = VirtualImageList1
      ImageIndex = 0
      ImageName = 'edit2'
      HotImageIndex = 1
      HotImageName = 'edit'
      LinkHotColor = clHighlight
      Style = clbkLink
    end
  end
  object ActionList: TActionList
    Images = VirtualImageList1
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
      ImageIndex = 1
      ImageName = 'edit'
      OnExecute = Action_EditTaskExecute
    end
    object Action_AddLane: TAction
      Caption = 'Add Lane'
      OnExecute = Action_AddLaneExecute
    end
    object Action_DeleteLane: TAction
      Caption = 'Delete Lane'
      OnExecute = Action_DeleteLaneExecute
    end
  end
  object PopupMenu_Header: TPopupMenu
    Left = 192
    Top = 104
    object MenuItem_AddTask: TMenuItem
      Action = Action_AddTask
    end
    object MenuItem_DeleteTask: TMenuItem
      Action = Action_DeleteTask
    end
    object MenuItem_EditTask: TMenuItem
      Action = Action_EditTask
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ActionAddLane1: TMenuItem
      Action = Action_AddLane
    end
    object DeleteLane1: TMenuItem
      Action = Action_DeleteLane
    end
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'edit'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000012000000120804000000FCC746
              DC0000005A4944415428CFCDCAB10D83301000C0EB338459081A86F0380CC030
              96188441B0C4A74AC9D31089AB8FFF9BAC3E79197561CBDAA0D885B05E95D9A1
              2A76DD7455BA70AA8A312B211C86BBD2CDEF2FB4FBF24B6961D1B4BC3CE30BB4
              753CAE4F7FCE540000000049454E44AE426082}
          end>
      end
      item
        Name = 'edit2'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D494844520000001200000012080600000056CE8E
              57000000BC4944415438CBCDD22D4E03411806E0870D07A942720392D615B118
              0C3D0209A2664F31A68243608AC12037E1024D25A6249C01C52645B09B6C9794
              CC4CCDBE6A323F4FBE6F66185BCE924F4CAB1B9458AAC3571E34AD4A3CE31C6F
              B8EEB0220199608BCF76E60AAB6EB988446EF18E3966D8A1C14B7C6BBFC853DB
              CE1EF778C5A53A44428748976F5CA8C3477F6B918834580C91E3151D47EED461
              1DF78F3290BF502672089D800C2FFB2117F9EFD59210830A36BDF1630A32CEFC
              00CF6A3FFFD4E2CDC00000000049454E44AE426082}
          end>
      end>
    Left = 32
    Top = 112
  end
  object VirtualImageList1: TVirtualImageList
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 1
        CollectionName = 'edit2'
        Disabled = False
        Name = 'edit2'
      end
      item
        CollectionIndex = 0
        CollectionName = 'edit'
        Disabled = False
        Name = 'edit'
      end>
    ImageCollection = ImageCollection1
    Left = 40
    Top = 176
  end
end
