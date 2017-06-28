unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, StdCtrls;

type
  TForm1 = class(TForm)
    Image: TImage;
    Timer: TTimer;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Rotate(M: TPoint; P0: TPoint; Alpha: Real; var X, Y: Integer);
    procedure Figure(Code: Byte; P: TPoint; R: Integer;
                                P0: TPoint; Alpha: Real; Color: TColor);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Center, M0: TPoint;
  AngleX, AngleY, AngleZ: Real;
implementation

{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
  M0.X := Round(Image.Width / 2);
  M0.Y := Round(Image.Height / 2);

  Center.X := M0.X;
  Center.Y := M0.Y + 100;

  with Image.Canvas do
  begin
    Brush.Color := clWhite;
    Rectangle(0, 0, Image.Width, Image.Height);
  end;
end;

procedure TForm1.Rotate(M: TPoint; P0: TPoint; Alpha: Real; var X, Y: Integer);
var
  dX, dY: Integer;
begin
  dX := - P0.X + M.X;
  dY := - P0.Y + M.Y;

  X := Round(P0.X + dX * cos(Alpha) + dY * sin(Alpha));
  Y := Round(P0.Y - dX * sin(Alpha) + dY * cos(Alpha));
end;

procedure TForm1.Figure(Code: Byte; P: TPoint; R: Integer;
                                   P0: TPoint; Alpha: Real; Color: TColor);
var
  I: Integer;
  X, Y: Integer;
  M: TPoint;
begin
  with Image.Canvas do
  begin
    Pen.Width := 1;
    Pen.Color := Color;

    case Code of
    0: begin  // draw circle
        for I := 0 to 360 do
        begin
          M.X := Round(P.X + R * cos(I * PI / 180));
          M.Y := Round(P.Y + R * sin(I * PI / 180));

          Rotate(M, P0, Alpha, X, Y);
          if I = 0 then
            MoveTo(X, Y)
          else
            LineTo(X, Y);
        end;
      end;

    1: begin  // draw astrois
        for I := 0 to 360 do
        begin
          M.X := Round(P.X + R * power(cos(I * PI / 180), 3));
          M.Y := Round(P.Y + R * power(sin(I * PI / 180), 3));

          Rotate(M, P0, Alpha, X, Y);
          if I = 0 then
            MoveTo(X, Y)
          else
            LineTo(X, Y);
        end;
      end;
    end;
  end;
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
  I: Integer;
begin
  with Image.Canvas do
  begin
    Brush.Color := clWhite;
    Rectangle(0, 0, Image.Width, Image.Height);
    Pen.Color := clMaroon;
    Pen.Width := 2;
    Ellipse(M0.X-2, M0.Y-2, M0.X+2, M0.Y+2);
  end;

  // draw circle
  Figure(0, Center, 50, M0, AngleX, clGreen);
  AngleX := AngleX + 0.5;

  // draw astrois
  Figure(1, Center, 60, M0, AngleY, clBlue);
  AngleY := AngleY - 0.1;

  // mix drawing
  Figure(0, Center, 70, M0, AngleZ, clPurple);
  Figure(1, Center, 70, M0, AngleZ, clRed);
  AngleZ := AngleZ + 0.3;

  Image.Canvas.Pen.Color := clBlack;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer.Enabled := True;
end;

end.
