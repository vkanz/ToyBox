object Frame2: TFrame2
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
    DesignSize = (
      669
      41)
    object Button1: TButton
      Left = 296
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 426
      Top = 10
      Width = 75
      Height = 25
      Anchors = []
      Caption = 'Button2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel_Client: TPanel
    Left = 0
    Top = 41
    Width = 669
    Height = 356
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GridPanel1: TGridPanel
      Left = 0
      Top = 0
      Width = 669
      Height = 356
      Align = alClient
      Caption = 'GridPanel1'
      ColumnCollection = <
        item
          Value = 49.918957327843190000
        end
        item
          Value = 50.081042672156820000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = ControlList1
          Row = 0
        end
        item
          Column = 1
          Control = ControlList2
          Row = 0
        end>
      ExpandStyle = emAddColumns
      RowCollection = <
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAuto
        end>
      TabOrder = 0
      ExplicitTop = 6
      object ControlList1: TControlList
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 327
        Height = 348
        Align = alClient
        ItemCount = 10
        ItemColor = clBtnFace
        ItemMargins.Left = 2
        ItemMargins.Top = 2
        ItemMargins.Right = 2
        ItemMargins.Bottom = 2
        ItemSelectionOptions.HotColorAlpha = 20
        ItemSelectionOptions.SelectedColorAlpha = 30
        ItemSelectionOptions.FocusedColorAlpha = 40
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 216
      end
      object ControlList2: TControlList
        AlignWithMargins = True
        Left = 337
        Top = 4
        Width = 328
        Height = 348
        Align = alClient
        ItemColor = clBtnFace
        ItemWidth = 200
        ItemMargins.Left = 2
        ItemMargins.Top = 2
        ItemMargins.Right = 2
        ItemMargins.Bottom = 2
        ColumnLayout = cltMultiTopToBottom
        ItemSelectionOptions.HotColorAlpha = 20
        ItemSelectionOptions.SelectedColorAlpha = 30
        ItemSelectionOptions.FocusedColorAlpha = 40
        ParentColor = False
        TabOrder = 1
        ExplicitLeft = 226
        ExplicitWidth = 218
        object Label2: TLabel
          AlignWithMargins = True
          Left = 47
          Top = 25
          Width = 146
          Height = 45
          Margins.Left = 10
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          AutoSize = False
          Caption = 'This is example of item with multi-line text.'
          ShowAccelChar = False
          Transparent = True
          WordWrap = True
        end
        object VirtualImage1: TVirtualImage
          AlignWithMargins = True
          Left = 4
          Top = 5
          Width = 30
          Height = 30
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ImageWidth = 0
          ImageHeight = 0
          ImageIndex = -1
        end
        object Label3: TLabel
          Left = 48
          Top = 4
          Width = 25
          Height = 16
          Caption = 'Title'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
      end
    end
  end
end
