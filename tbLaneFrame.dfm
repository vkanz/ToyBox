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
      Height = 18
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
      ExplicitTop = 0
    end
  end
  object ControlList: TControlList
    Left = 0
    Top = 24
    Width = 320
    Height = 216
    Align = alClient
    ItemMargins.Left = 0
    ItemMargins.Top = 0
    ItemMargins.Right = 0
    ItemMargins.Bottom = 0
    ParentColor = False
    TabOrder = 1
    OnDragDrop = ControlListDragDrop
    OnDragOver = ControlListDragOver
    OnShowControl = ControlListShowControl
    OnMouseDown = ControlListMouseDown
    OnStartDrag = ControlListStartDrag
  end
end
