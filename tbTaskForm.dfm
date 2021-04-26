object FormEditTask: TFormEditTask
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Task'
  ClientHeight = 276
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label_ID: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Label_ID'
  end
  object Panel_Bottom: TPanel
    Left = 0
    Top = 244
    Width = 450
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      450
      32)
    object Button_Ok: TButton
      Left = 286
      Top = 3
      Width = 75
      Height = 25
      Action = Action_Ok
      Anchors = [akTop, akRight]
      Default = True
      TabOrder = 0
    end
    object Button_Cancel: TButton
      Left = 367
      Top = 3
      Width = 75
      Height = 25
      Action = Action_Cancel
      Anchors = [akTop, akRight]
      Cancel = True
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 200
    Top = 232
    object Action_Ok: TAction
      Caption = 'OK'
    end
    object Action_Cancel: TAction
      Caption = 'Cancel'
    end
  end
end
