object FrameLane: TFrameLane
  Left = 0
  Top = 0
  Width = 312
  Height = 240
  ParentShowHint = False
  ShowHint = True
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
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnBeforeDrawItem = ControlListBeforeDrawItem
    OnClick = ControlListClick
    OnDragDrop = ControlListDragDrop
    OnDragOver = ControlListDragOver
    OnKeyUp = ControlListKeyUp
    OnMouseDown = ControlListMouseDown
    OnMouseMove = ControlListMouseMove
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
      ParentShowHint = False
      ShowHint = True
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
      ImageIndex = 2
      ImageName = 'add-column'
      OnExecute = Action_AddLaneExecute
    end
    object Action_DeleteLane: TAction
      Caption = 'Delete Lane'
      ImageIndex = 3
      ImageName = 'delete-column'
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
      end
      item
        Name = 'add-column'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000000097048597300000EC400000EC401952B0E1B000000F949444154388D
              8DD1AF4B044118C6F10F2272980D878AC96410B92072C97F45B0190583822058
              0FA35D83C928FE072A2818B4891ABD6612F1D79D6166616ED9D9BD078699E179
              F7BBF3BE0F41AFF8AC59FB329A8CFB3CB6F118EF83A4660F734D00B8C35545CD
              06FA3940A11F7433DE74FCD122DA6573A2898C4DBCE129EEB7582D17FD655EB0
              8B615C67B88FE70F2C37016684040AC01A8E92FB05A3432CAB8B164E708D179C
              C756B6B0CE7833F8C5B7106D7A1E51AE85AF9A162E9B0070907C702A24301466
              D31907003B784F400F55B5758016A6B08485B2599742A1633CE3B0CA4C012B42
              2AE984079815265FA902D047AFE6153739E31FB1BC4AF4BB5C2A200000000049
              454E44AE426082}
          end>
      end
      item
        Name = 'delete-column'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
              61000000097048597300000EC400000EC401952B0E1B000000EA49444154388D
              8DD13F4A03411CC5F10F2212AC45028A959585A44895C2BB08DE20A914041B1B
              C9013C408EE01524A08D602316A98276A942FC831B8BDD0D9B6166370F8661F7
              BDF9EE6FDE926B8245CDBA96D076B11FA28FD7E239AB64AE70D00480673C4632
              E798A600A57ED14B78BBC5878ED10ECDAD26322EF081F7627F42370CFD2526B8
              C432B2E6386D02ECC9FF400CB0C403EB2586EAA1252F76147877386B0294CAF0
              1379BFD65FEC0AFBF84E8CBFBA421D006E128717E86C0280016695C32FB16C1D
              A0851D9CE028343729F11E6FB88D99554047DE6C1664DAF84AD14BC027863553
              8C53C63F35B0473BABCE48D50000000049454E44AE426082}
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
      end
      item
        CollectionIndex = 2
        CollectionName = 'add-column'
        Disabled = False
        Name = 'add-column'
      end
      item
        CollectionIndex = 3
        CollectionName = 'delete-column'
        Disabled = False
        Name = 'delete-column'
      end>
    ImageCollection = ImageCollection1
    Left = 40
    Top = 176
  end
end
