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
  TtbBoardBuilder = class
  public
    class procedure BuildDefault(ATarget: TtbBoard);
  end;

type
  TLaneControls = class;

  TLaneShowControl = procedure (ASender: TLaneControls; const AIndex: Integer; AControl: TControl;
    var AVisible: Boolean) of object;
  TLaneIndexProcedure = procedure (ASource, ATarget: TLaneControls) of object;

  TLaneControls = class
  private
    FOnShowControl: TLaneShowControl;
    FOnDropItem: TLaneIndexProcedure;
  public
    Lane: TtbLane;
    Panel: TPanel;
    Header: ItbLaneFrame;
    ControlList: TControlList;
    Title: TLabel;
    Text: TLabel;
    {}
    property OnShowControl: TLaneShowControl read FOnShowControl write FOnShowControl;
    property OnDropItem: TLaneIndexProcedure read FOnDropItem write FOnDropItem;
  end;

type
  TtbBoardAdapter = class(TComponent)
  private
    FBoard: TtbBoard;
    FLanes: TObjectList<TLaneControls>;
    FDomain: TtbDomain;
    FPopupMenu: TPopupMenu;
    FBoardPage: ItbBoardPage;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PrepareGrid;
    procedure HandleLaneDropItem(ASource, ATarget: TLaneControls);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw;
    {}
    property Board: TtbBoard read FBoard write FBoard;
    property Domain: TtbDomain read FDomain write FDomain;
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

{ TtbBoardBuilder }

class procedure TtbBoardBuilder.BuildDefault(ATarget: TtbBoard);
begin
  ATarget.Clear;
  ATarget.Lanes.Add(TtbLane.Create)
end;

{ TtbBoardAdapter }

constructor TtbBoardAdapter.Create(AOwner: TComponent);
begin
  inherited;
  FLanes := TObjectList<TLaneControls>.Create(True);
end;

destructor TtbBoardAdapter.Destroy;
begin
  FLanes.Free;
  inherited;
end;

procedure TtbBoardAdapter.Draw;
begin
  PrepareGrid;
end;

procedure TtbBoardAdapter.HandleLaneDropItem(ASource, ATarget: TLaneControls);
var
  TaskID: Integer;
begin
  Assert(FDomain <> nil);
  TaskID := ASource.Lane.GetTaskId(ASource.ControlList.ItemIndex);

  if ASource <> ATarget then
  begin
    ASource.Lane.RemoveTaskID(TaskID);
    ASource.ControlList.ItemCount := ASource.ControlList.ItemCount - 1;
    ASource.ControlList.Repaint;

    ATarget.Lane.AddTaskID(TaskID);
    ATarget.ControlList.ItemCount := ATarget.ControlList.ItemCount + 1;
    ATarget.ControlList.Repaint;
  end
  else
  begin

  end;
end;

procedure TtbBoardAdapter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

end;

function NormalizeName(const ATitle: String): String;
begin
  Result := '';
  for var C in ATitle do
    if CharInSet(C, ['A'..'Z', 'a'..'z', 'À'..'ß', 'à'..'ÿ', '0'..'9', '_']) then
      Result := Result + C;
end;

procedure TtbBoardAdapter.PrepareGrid;
var
  LaneControls: TLaneControls;
  Lane: TtbLane;
begin
  Assert(FBoard <> nil);

  FBoardPage.BeginUpdate;
  try
    for Lane in FBoard.Lanes do
      FBoardPage.AddLane(Lane);
  finally
    FBoardPage.EndUpdate;
  end;
end;

end.
