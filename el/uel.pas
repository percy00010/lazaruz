unit uel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, Math, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bis: TButton;
    EC1: TEdit;
    EC2: TEdit;
    Fix: TButton;
    FaP: TButton;
    Newt: TButton;
    Sec: TButton;
    TA: TEdit;
    TB: TEdit;
    TE: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Men: TPanel;
    Tab: TStringGrid;
    procedure FaPClick(Sender: TObject);
    procedure FixClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BisClick(Sender: TObject);
    procedure NewtClick(Sender: TObject);
    procedure SecClick(Sender: TObject);
    procedure LoadE();
    procedure Sho();
    procedure ShoN();
  private

  public

  end;

var
  Form1: TForm1;
  ECT: string;
  ECD: string;
  MParse: TParseMath;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     MParse:= TParseMath.Create();
     MParse.AddVariable('x',0.0);
end;

procedure TForm1.Sho();
begin
     Tab.RowCount:=1;
     Tab.ColCount:=8;
     Tab.Cells[0,0]:= 'n';   Tab.Cells[1,0]:= 'a';
     Tab.Cells[2,0]:= 'b';   Tab.Cells[3,0]:= 'x_n';
     Tab.Cells[4,0]:= 's';   Tab.Cells[5,0]:= 'Ea';
     Tab.Cells[6,0]:= 'Er';  Tab.Cells[7,0]:= 'Er(%)';
end;

procedure TForm1.ShoN();
begin
     Tab.RowCount:=1;
     Tab.ColCount:=5;
     Tab.Cells[0,0]:= 'n';   Tab.Cells[1,0]:= 'x_n';
     Tab.Cells[2,0]:= 'Ea';  Tab.Cells[3,0]:= 'Er';
     Tab.Cells[4,0]:= 'Er(%)';
end;

procedure TForm1.LoadE();
begin
     ECT:= EC1.Text;
     ECD:= EC2.Text;
end;

function f(a: real): real;
begin
     MParse.NewValue('x',a);
     MParse.Expression:= ECT;
     Result := MParse.Evaluate();
end;

function fp(a: real): real;
begin
     MParse.NewValue('x',a);
     MParse.Expression:= ECD;
     Result := MParse.Evaluate();
end;

procedure TForm1.BisClick(Sender: TObject);
var Rt,Val,Ea,Er,s,a,b,n: real;
var i: integer;
begin
     Self.LoadE();
     a := StrToFloat(TA.Text); b := StrToFloat(TB.Text); n := StrToFloat(TE.Text);
     Tab.Clear; Self.Sho();
     i:=1; Val:=0; Ea:= n+1;
     if(f(a)*f(b) = 0) then begin
         if(f(a) = 0) then
            ShowMessage('Result: ' + FloatToStr(a))
         else
            ShowMessage('Result: ' + FloatToStr(b));
     end
     else if (f(a)*f(b)<0) then begin
       while(n<Ea) do begin
         Tab.RowCount:= Tab.RowCount+1;
         Rt:= Val;
         Val:= (a+b)/2;
         Ea:= Abs(Rt-Val);
         Er:= Abs(Ea/Val);

         Tab.Cells[0,i]:= FloatToStr(i-1);
         Tab.Cells[1,i]:= FloatToStr(a);
         Tab.Cells[2,i]:= FloatToStr(b);
         Tab.Cells[3,i]:= FloatToStr(Val);
         Tab.Cells[5,i]:= FloatToStr(Ea);
         Tab.Cells[6,i]:= FloatToStr(Er);
         Tab.Cells[7,i]:= FloatToStr(Er*100);

         s:= f(a)*f(Val);
         if(s<0) then begin
             b:= Val;
             Tab.Cells[4,i]:= '-'
         end
         else begin
             a:= Val;
             Tab.Cells[4,i]:= '+';
         end;
         i:=i+1;
       end;
     end
     else
         ShowMessage('No cumple Bolzano');
end;

procedure TForm1.FaPClick(Sender: TObject);
var Rt,Val,Ea,Er,s,a,b,n: real;
var i: integer;
begin
   Self.LoadE();
   a := StrToFloat(TA.Text); b := StrToFloat(TB.Text); n := StrToFloat(TE.Text);
   Tab.Clear; Self.Sho();
   i:=1; Val:=0; Ea:= n+1;
   if(f(a)*f(b) = 0) then begin
         if(f(a) = 0) then
            ShowMessage('Result: ' + FloatToStr(a))
         else
            ShowMessage('Result: ' + FloatToStr(b));
     end
     else if (f(a)*f(b)<0) then begin
       while(n<Ea) do begin
         Tab.RowCount:= Tab.RowCount+1;
         Rt:= Val;
         Val:= (b-((f(b)*(a-b))/(f(a)-f(b))));
         Ea:= Abs(Rt-Val);
         Er:= Abs(Ea/Val);

         Tab.Cells[0,i]:= FloatToStr(i-1);
         Tab.Cells[1,i]:= FloatToStr(a);
         Tab.Cells[2,i]:= FloatToStr(b);
         Tab.Cells[3,i]:= FloatToStr(Val);
         Tab.Cells[5,i]:= FloatToStr(Ea);
         Tab.Cells[6,i]:= FloatToStr(Er);
         Tab.Cells[7,i]:= FloatToStr(Er*100);

             s:= f(a)*f(Val);
         if(s<0) then begin
             b:= Val;
             Tab.Cells[4,i]:= '-'
         end
         else begin
             a:= Val;
             Tab.Cells[4,i]:= '+';
         end;
         i:=i+1;
       end;
     end
     else
         ShowMessage('No cumple Bolzano');

end;

procedure TForm1.FixClick(Sender: TObject);
var Rt,Val,Ea,Er,a,n: real;
var i: integer;
begin
     Self.LoadE();
     a := StrToFloat(TA.Text); n := StrToFloat(TE.Text);
     Tab.Clear; Self.ShoN();
     i:=1; Val:=a; Ea:= n+1; Er:= 0;
     while(n<Ea) do begin
       Tab.RowCount:= Tab.RowCount+1;
       Tab.Cells[1,i]:= FloatToStr(Val);
       Rt:= Val;
       Val:= f(Rt);

       Ea:= Abs(Rt-Val);
       if (Val <> 0) then
          Er:= Abs(Ea/Val)
       else
          Er:= Abs(Ea/(Val+0.0000001));
       Tab.Cells[0,i]:= FloatToStr(i-1);
       Tab.Cells[2,i]:= FloatToStr(Ea);
       Tab.Cells[3,i]:= FloatToStr(Er);
       Tab.Cells[4,i]:= FloatToStr(Er*100);
       i:=i+1;
     end;
end;


procedure TForm1.NewtClick(Sender: TObject);
var Rt,Val,Ea,Er,a,n: real;
var i: integer;
begin
     Self.LoadE();
     a := StrToFloat(TA.Text); n := StrToFloat(TE.Text);
     Tab.Clear; Self.ShoN();
     i:=1; Val:=a; Ea:= n+1; Er:= 0;
     while(n<Ea) do begin
       Tab.RowCount:= Tab.RowCount+1;
       Tab.Cells[1,i]:= FloatToStr(Val);
       Rt:= Val;
       if(fp(Val) = 0.0) then
           Val:= Val-(f(Val)/(fp(Val)+0.00001))
       else
           Val:= Val-(f(Val)/fp(Val));
       Ea:= Abs(Rt-Val);
       Er:= Abs(Ea/Val);
       Tab.Cells[0,i]:= FloatToStr(i-1);
       Tab.Cells[2,i]:= FloatToStr(Ea);
       Tab.Cells[3,i]:= FloatToStr(Er);
       Tab.Cells[4,i]:= FloatToStr(Er*100);
       i:=i+1;
     end;
end;

procedure TForm1.SecClick(Sender: TObject);
var Rt,Val,Ea,Er,a,n,h: real;
var i: integer;
begin
     Self.LoadE();
     a := StrToFloat(TA.Text); n := StrToFloat(TE.Text);
     Tab.Clear; Self.ShoN();
     i:=1; Val:=a; Ea:= n+1; Er:= 0; h:=n/10;
     while(n<Ea) do begin
       Tab.RowCount:= Tab.RowCount+1;
       Tab.Cells[1,i]:= FloatToStr(Val);
       Rt:= Val;
       if ((f(Val+h)-f(Val-h)) = 0.0) then
          Val:= Val-((2*h*f(Val))/(f(Val+h)-f(Val-h) + 0.00001))
       else
           Val:= Val-((2*h*f(Val))/(f(Val+h)-f(Val-h)));
       Ea:= Abs(Rt-Val);
       Er:= Abs(Ea/Val);
       Tab.Cells[0,i]:= FloatToStr(i-1);
       Tab.Cells[2,i]:= FloatToStr(Ea);
       Tab.Cells[3,i]:= FloatToStr(Er);
       Tab.Cells[4,i]:= FloatToStr(Er*100);
       i:=i+1;
     end;
end;

end.

