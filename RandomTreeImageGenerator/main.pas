unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls;

type

  TMyPoint = record
    x, y: integer;
    display: boolean;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    procedure PaintBox1Paint(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    points: array of array of TMyPoint;
    procedure DrawElipse(size, count, dist: integer);
    function Norm(p1, p2: TMyPoint): Double;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PaintBox1Paint(Sender: TObject);
var i, j, m: integer;
begin
  m := 2;
  with PaintBox1.Canvas do begin
    AntialiasingMode := amOn;
    Brush.Color := clWhite;
    FillRect(0, 0, PaintBox1.Width, PaintBox1.Height);
    Brush.Color := clBlack;
    setlength(points, 1, 1);
    points[0][0].x := PaintBox1.Width div 2;
    points[0][0].y := PaintBox1.Height div 2;
    points[0][0].display := True;
    EllipseC(points[0][0].x, points[0][0].y, m*15, m*15);

    {for i:= 1 to 10 do
      DrawElipse(8 - i, 3 * i, 15 * i);}
    DrawElipse(m*8, 6,  m*TrackBar1.Position);
    DrawElipse(m*6, 15, m*TrackBar2.Position);
    DrawElipse(m*4, 20, m*TrackBar3.Position);
    DrawElipse(m*2, 30, m*TrackBar4.Position);
    {for i:= 1 to Width - 1 do
      for j:= 1 to Height - 1 do
        PaintBox1.Canvas.Pixels[i, j] := ((
          ColorToRGB(PaintBox1.Canvas.Pixels[i, j]) +
          ColorToRGB(PaintBox1.Canvas.Pixels[i+1, j]) +
          ColorToRGB(PaintBox1.Canvas.Pixels[i-1, j]) +
          ColorToRGB(PaintBox1.Canvas.Pixels[i, j+1]) +
          ColorToRGB(PaintBox1.Canvas.Pixels[i, j-1])) div 5);}
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;

procedure TForm1.DrawElipse(size, count, dist: integer);
var
  i, j, l: integer;
  a, min: Double;
  min_p: TMyPoint;
begin
  l := Length(points);
  SetLength(points, l + 1);
  with PaintBox1.Canvas do begin
    Pen.Width := 2 * (5 - l);
    setlength(points[l], count+1);
    for i:= 0 to count do begin
      a := 2*pi / count * i;
      points[l][i].x := round(PaintBox1.Width / 2 + dist * cos(a) - dist * sin(a));
      points[l][i].y := round(PaintBox1.Height / 2 + dist * sin(a) + dist * cos(a));
      points[l][i].display := Random(TrackBar5.Position) <> 1;
      if not points[l][i].display then continue;
      min := 1000;
      for j := 0 to High(points[l-1]) do
        if Norm(points[l-1][j], points[l][i]) < min then begin
          min := Norm(points[l-1][j], points[l][i]);
          min_p := points[l-1][j];
        end;
      if not min_p.display then begin
        points[l][i].display := false;
        continue;
      end;
      Line(min_p.x, min_p.y, points[l][i].x, points[l][i].y);
      EllipseC(points[l][i].x, points[l][i].y, size, size);
    end;
  end;
end;

function TForm1.Norm(p1, p2: TMyPoint): Double;
begin
  result := sqrt(sqr(p1.x - p2.x) + sqr(p1.y - p2.y));
end;

end.

