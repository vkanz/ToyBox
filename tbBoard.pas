// *************************************************************************** }
//
// ToyBox task management tool
//
// Copyright (c) 2021-2020
//
// https://github.com/vkanz/toybox
//
// ***************************************************************************

unit tbBoard;

interface

uses Vcl.ExtCtrls, Classes, Generics.Collections, Vcl.ControlList, Vcl.StdCtrls, Controls, Menus,
  tbDomain, tbBoardIntf;

type
  TtbBoardAdapter = class(TComponent)
  private
    FBoard: TtbBoard;
    FPopupMenu: TPopupMenu;
    FBoardPage: ItbBoardPage;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PrepareGrid;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw;
    {}
    property Board: TtbBoard read FBoard write FBoard;
    property BoardPage: ItbBoardPage read FBoardPage write FBoardPage;
  published
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
  end;

implementation

uses Vcl.Graphics, System.UITypes, SysUtils,
{$IFDEF DEBUG}
  Dialogs,
{$ENDIF}
  tbLaneFrame;

{ TtbBoardAdapter }

constructor TtbBoardAdapter.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TtbBoardAdapter.Destroy;
begin

  inherited;
end;

procedure TtbBoardAdapter.Draw;
begin
  PrepareGrid;
end;

procedure TtbBoardAdapter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

end;

procedure TtbBoardAdapter.PrepareGrid;
begin
  Assert(FBoard <> nil);

  FBoardPage.BeginUpdate;
  try
    for var Lane in FBoard.Lanes do
      FBoardPage.AddLaneFrame(Lane);
  finally
    FBoardPage.EndUpdate;
  end;
end;

function NormalizeName(const ATitle: String): String;
begin
  Result := '';
  for var C in ATitle do
    if CharInSet(C, ['A'..'Z', 'a'..'z', 'À'..'ß', 'à'..'ÿ', '0'..'9', '_']) then
      Result := Result + C;
end;


end.
