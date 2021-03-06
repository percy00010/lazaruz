program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, ST, MMath, Func, DR
  { you can add units after this };

type

  { Taylor }

  Taylor = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Taylor }

procedure Taylor.DoRun;
var
  ErrorMsg: String;
  Taylor: TTaylor;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  Taylor := TTaylor.Create();
  Taylor.Menu();
  {Print(Bisecc(1.8,2.2,5));
  Print(FalPos(1.8,2.2,5));}

  Taylor.Destroy;

  // stop program loop
  Terminate;
end;

constructor Taylor.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Taylor.Destroy;
begin
  inherited Destroy;
end;

procedure Taylor.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: Taylor;
begin
  Application:=Taylor.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

