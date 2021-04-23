unit TitleUtils;

interface

uses Graphics, Types;

procedure DrawSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor;
  CurrentPPI, ScreenPPI: Integer);

implementation

uses Windows, GDIPOBJ, GDIPAPI;

{ Modified method from sample: \Samples\Object Pascal\VCL\Titlebar\TitlebarPanel }
procedure DrawSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor;
  CurrentPPI, ScreenPPI: Integer);
var
  LRect: TRect;
  LGPGraphics: GDIPOBJ.TGPGraphics;
  LGPPen: GDIPOBJ.TGPPen;
  LRGBColor, LSize: Integer;
  LColor: Cardinal;
  LGPRect: GDIPAPI.TGPRect;
  LPath: TGPGraphicsPath;
begin
  LRGBColor := ColorToRGB(FGColor);
  LColor := MakeColor(GetRValue(LRGBColor), GetGValue(LRGBColor), GetBValue(LRGBColor));
  LGPGraphics := TGPGraphics.Create(ACanvas.Handle);
  try
    LGPGraphics.SetSmoothingMode(SmoothingModeAntiAlias);
    LGPPen := TGPPen.Create(LColor, CurrentPPI / ScreenPPI);
    try
      LPath := TGPGraphicsPath.Create;
      try
        LPath.Reset;
        LSize := MulDiv(9, CurrentPPI, ScreenPPI);
        LRect := CenteredRect(ARect, Rect(0, 0, LSize div 4, LSize));

        LGPRect := MakeRect(LRect.Left, LRect.Top, LRect.Width, LRect.Height);
        LPath.AddRectangle(LGPRect);
        LGPGraphics.DrawPath(LGPPen, LPath);
      finally
        LPath.Free;
      end;
    finally
     LGPPen.Free;
    end;
  finally
    LGPGraphics.Free;
  end;
end;

end.
