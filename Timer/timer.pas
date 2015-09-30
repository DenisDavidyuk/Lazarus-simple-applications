unit Timer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, dateutils;

const
  DayString: array [0..2] of string = ('дней', 'день', 'дня');
  DefaultDate: string = '31.12.2015 23:59:59';

type

  { TFormTimer }

  TFormTimer = class(TForm)
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItemExit: TMenuItem;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    EndDate: TDateTime;
    DateSelected: boolean;
  public
    { public declarations }
  end;

var
  FormTimer: TFormTimer;

implementation

{$R *.lfm}

{ TFormTimer }

procedure TFormTimer.FormCreate(Sender: TObject);
var s: string;
begin
  FormTimer.Top := Screen.WorkAreaHeight - FormTimer.Height;
  FormTimer.Left := Screen.WorkAreaWidth - FormTimer.Width;

  try
    AssignFile(input, 'timer.txt');
    reset(input);
    readln(s);
    EndDate := StrToDateTime(s);
    CloseFile(input);
  Except
    EndDate := StrToDateTime(DefaultDate);
    DateSelected := false;
    while not DateSelected do
      MenuItem1.Click;
  end;

  Timer1.Enabled := true;
  Timer1Timer(Timer1);
end;

procedure TFormTimer.MenuItem1Click(Sender: TObject);
var
  s: string;
begin
  DateSelected := false;
  s := DateTimeToStr(EndDate);
  if InputQuery('Изменить дату события', 'Введите дату события', s) then begin
    repeat
      try
        DateSelected := true;
        EndDate := StrToDateTime(s);
      except
        DateSelected := false;
        s := DateTimeToStr(EndDate);
        if not InputQuery('Изменить дату события', 'Введите дату события', s) then break;
      end;
    until DateSelected;
    if DateSelected then begin
      AssignFile(output, 'timer.txt');
      rewrite(output);
      writeln(s);
      CloseFile(output);
      Timer1.Enabled := true;
      Timer1Timer(Timer1);
    end;
  end;
end;

procedure TFormTimer.MenuItemExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormTimer.Timer1Timer(Sender: TObject);
var
  d, t: integer;
  diff: TDateTime;
  s: string;
begin
  diff := EndDate - Now;
  d := DaysBetween(EndDate, Now);
  s := '';

  t := 0;
  if d mod 10 = 1 then t := 1;
  if (d mod 10) in [2 .. 4] then t := 2;
  if d div 10 = 1 then t := 0;

  s += IntToStr(d) + ' ' + DayString[t];
  s += #13#10;
  s += TimeToStr(diff);
  Label1.Caption := s;
  if CompareDateTime(EndDate, Now) = -1 then begin
    Timer1.Enabled := false;
    Label1.Caption := '';
  end;
end;

end.

