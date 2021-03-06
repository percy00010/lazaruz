unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, ColorBox, Grids, ParseMath,
  TAChartUtils, TATools, TACustomSeries, Math;

type

  { TfrmGraficadora }

  TfrmGraficadora = class(TForm)
    DP: TButton;
    PlotearS: TLineSeries;
    DY: TEdit;
    DX: TEdit;
    SOL: TEdit;
    RK: TButton;
    EU: TButton;
    chrGrafica: TChart;
    Area: TAreaSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    N: TEdit;
    EDO: TEdit;
    Funcion: TFuncSeries;
    GroupBox1: TGroupBox;
    STRR: TStringGrid;
    TN: TLabel;
    TEDO: TLabel;
    Panel1: TPanel;
    Plotear: TLineSeries;
    cboxColorFuncion: TColorBox;
    ediIntervalo: TEdit;
    EjeX: TConstantLine;
    EjeY: TConstantLine;
    procedure DPClick(Sender: TObject);
    procedure EUClick(Sender: TObject);
    procedure RKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
    procedure GraficarFuncionConPloteo();
    procedure Plot();
    procedure Init();

  private
    { private declarations }
    Parse  : TparseMath;
    Xminimo, Xmaximo: String;

    function f(x,y: Double; s: string): Double;
    Procedure DetectarIntervalo();

  public
    { public declarations }
  end;

var
  frmGraficadora: TfrmGraficadora;

implementation

{$R *.lfm}

{ TfrmGraficadora }

Procedure TfrmGraficadora.DetectarIntervalo();
var
    PosCorcheteIni, PosCorcheteFin, PosSeparador: Integer;
    PosicionValidad: Boolean;
const
   CorcheteIni = '[';
   CorcheteFin = ']';
   Separador = ';';
begin

 PosCorcheteIni:= Pos( CorcheteIni, ediIntervalo.Text );
 PosCorcheteFin:= pos( CorcheteFin, ediIntervalo.Text );
 PosSeparador:= Pos( Separador, ediIntervalo.Text  );

 PosicionValidad:= ( PosCorcheteIni > 0);
 PosicionValidad:= PosicionValidad and ( PosSeparador > 2);
 PosicionValidad:= PosicionValidad and ( PosCorcheteFin > 3);

 if not PosicionValidad then begin
        ShowMessage( 'Error en el intervalo');
        exit;
 end;
  Xminimo:= Copy( ediIntervalo.Text,
                      PosCorcheteIni + 1,
                      PosSeparador - 2 );
  Xminimo:= Trim( Xminimo );
  Xmaximo:= Copy( ediIntervalo.Text,
                      PosSeparador + 1,
                      Length( ediIntervalo.Text ) - PosSeparador -1  );
 Xmaximo:= Trim( Xmaximo );
end;

function TfrmGraficadora.f(x,y: Double; s: string): Double;
begin
     parse.Expression:= s;
     Parse.NewValue('x', x);
     Parse.NewValue('y', y);
     Result:= Parse.Evaluate();
end;

Procedure TfrmGraficadora.GraficarFuncionConPloteo();
var
    i: Integer;
begin
    Funcion.Active:= false;
    Plotear.ShowPoints:= false;
    Plotear.LinePen.Color:= cboxColorFuncion.Colors[cboxColorFuncion.ItemIndex];

    for i:=1 to STRR.RowCount-1 do begin
       Plotear.AddXY(StrToFloat(STRR.Cells[1,i]), StrToFloat(STRR.Cells[2,i]));
    end;
    Plotear.Active:= true;
end;

procedure TfrmGraficadora.Plot();
begin
 Plotear.Clear;
 if STRR.RowCount<2 then
    exit;

 DetectarIntervalo();
 Self.GraficarFuncionConPloteo();
end;

procedure TfrmGraficadora.Button1Click(Sender: TObject);
begin
 Area.Active:= true;
end;

procedure TfrmGraficadora.FormCreate(Sender: TObject);
begin
  Parse := TparseMath.create;
  parse.AddVariable('x',0.0);
  Parse.AddVariable('y',0.0);
end;

procedure TfrmGraficadora.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TfrmGraficadora.FuncionCalculate(const AX, AY: Double; s: string; out AF: Double);
begin
  AF := Self.f(AX,AY,s);
end;

procedure TfrmGraficadora.Init();
begin
 STRR.Clear();
 STRR.RowCount:= 2;
 STRR.Cells[0,0]:= 'n';  STRR.Cells[1,0]:= 'x_n';  STRR.Cells[2,0]:= 'metodo';    STRR.Cells[3,0]:= 'real';  STRR.Cells[4,0]:= 'error';
 STRR.Cells[0,1]:= '0';  STRR.Cells[1,1]:= DX.Text;  STRR.Cells[2,1]:= DY.Text;  STRR.Cells[3,1]:= DY.Text;  STRR.Cells[4,1]:= '0';
end;

procedure TfrmGraficadora.EUClick(Sender: TObject);
var
    h,xi,xf, xti, yt, myti, myt, tmp: real;
    nt, i: integer;
begin
    nt:= StrToInt(N.Text);
    Self.DetectarIntervalo();
    xi:= StrToFloat(Self.Xminimo); xf:= StrToFloat(Self.Xmaximo);
    h:= (xf-xi)/nt;
    if(DX.Text = Self.Xminimo) then
      h:= h
    else if(DX.Text = Self.Xmaximo) then
      h:= 0-h
    else begin
        ShowMessage('Punto Inicial Mal');
        exit;
    end;

    Self.Init();
    xti:= StrToFloat(DX.Text); yt:= StrToFloat(DY.Text);
    myt:= yt;
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;

      tmp:= myt+(h*Self.f(xti,myt,EDO.Text));
      myti:= myt+(h*((Self.f(xti,myt,EDO.Text)+Self.f(xti+h,tmp,EDO.Text))/2));

      STRR.Cells[0,i+1]:= IntToStr(i);
      STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(myti);
      if(SOL.Text <> '') then begin
        STRR.Cells[3,i+1]:= FloatToStr(Self.f(StrToFloat(STRR.Cells[1,i+1]),StrToFloat(STRR.Cells[2,i+1]),SOL.Text));
      end;
      xti:= xti+h;
      myt:= myti;
    end;
    Self.Plot();
end;

procedure TfrmGraficadora.RKClick(Sender: TObject);
var
    h,xi,xf,xti,yti,k1,k2,k3,k4: real;
    nt, i: integer;
begin
    nt:= StrToInt(N.Text);
    Self.DetectarIntervalo();
    xi:= StrToFloat(Self.Xminimo); xf:= StrToFloat(Self.Xmaximo);
    h:= (xf-xi)/nt;
    if(DX.Text = Self.Xminimo) then     h:= h
    else if(DX.Text = Self.Xmaximo) then    h:= 0-h
    else begin
        ShowMessage('Punto Inicial Mal');
        exit;
    end;

    Self.Init();
    xti:= StrToFloat(DX.Text); yti:= StrToFloat(DY.Text);
    for i:=1 to nt do begin
      STRR.RowCount:= STRR.RowCount+1;
      xti:= StrToFloat(STRR.Cells[1,i]);
      yti:= StrToFloat(STRR.Cells[2,i]);
      k1:= Self.f(xti,yti,EDO.Text);
      k2:= Self.f(xti+(h/2),yti+(k1*h/2),EDO.Text);
      k3:= Self.f(xti+(h/2),yti+(k2*h/2),EDO.Text);
      k4:= Self.f(xti+h,yti+(k3*h),EDO.Text);

      STRR.Cells[0,i+1]:= IntToStr(i);
      STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(yti+(h*(k1 + (2*k2) + (2*k3) + k4)/6));
      if(SOL.Text <> '') then begin
        STRR.Cells[3,i+1]:= FloatToStr(Self.f(StrToFloat(STRR.Cells[1,i+1]),StrToFloat(STRR.Cells[2,i+1]),SOL.Text));
      end;
    end;
    Self.Plot();
end;

procedure TfrmGraficadora.DPClick(Sender: TObject);
var
    nt,i: integer;
    xti,yti,xtf,h,eps,k1,k2,k3,k4,k5,k6,k7,er,z1,y1,s,h1,hmin,hmax: real;
begin
    eps:= 0.001;
    nt:= StrToInt(N.Text);
    Self.DetectarIntervalo();
    xti:= StrToFloat(Self.Xminimo); xtf:= StrToFloat(Self.Xmaximo);
    h:= (xtf-xti)/nt;
    if(DX.Text <> Self.Xminimo) then begin
        ShowMessage('Punto Inicial Mal');
        exit;
    end;
    Self.Init();

    hmin:= 0.001;
    hmax:= 0.1;
    i:= 1;
    while(xti<xtf) do begin
      STRR.RowCount:= STRR.RowCount+1;
      xti:= StrToFloat(STRR.Cells[1,i]);
      yti:= StrToFloat(STRR.Cells[2,i]);

      k1:= h*Self.f(xti,yti,EDO.Text);
      k2:= h*Self.f(xti+(h*0.2),yti+(k1*0.2),EDO.Text);
      k3:= h*Self.f(xti+(h*0.3),yti+(k1*0.075)+(k2*0.225),EDO.Text);
      k4:= h*Self.f(xti+(h*0.8),yti+(k1*0.977777778)-(k2*3.733333333)+(k3*3.555555556),EDO.Text);
      k5:= h*Self.f(xti+(h*0.888888889),yti+(k1*2.952598689)-(k2*11.595793324)+(k3*9.822892852)-(k4*0.290809328),EDO.Text);
      k6:= h*Self.f(xti+h,yti+(k1*2.846275253)-(k2*10.757575758)-(k3*8.906422718)+(k4*0.278409091)-(k5*0.273531304),EDO.Text);
      k7:= h*Self.f(xti+h,yti+(k1*0.091145833)+(k3*0.449236298)+(k4*0.651041667)-(k5*0.322376179)+(k6*0.130952381),EDO.Text);

      y1:= yti+(k1*0.091145833)+(k3*0.449236298)+(k4*0.651041667)-(k5*0.322376179)+(k6*0.130952381);
      z1:= yti+(k1*0.089913194)+(k3*0.453489069)+(k4*0.614062500)-(k5*0.271512382)+(k6*0.089047619)+(k7*0.025);

      STRR.Cells[0,i+1]:= IntToStr(i);
      STRR.Cells[1,i+1]:= FloatToStr(xti+h);
      STRR.Cells[2,i+1]:= FloatToStr(y1);

      er:= abs(z1-y1);
      s:= power(eps*h/(2*er),0.2);
      h1:= s*h;
      if(h1<hmin) then h1:= hmin
      else if(h1>hmax) then h1:= hmax;

      if(SOL.Text <> '') then begin
        STRR.Cells[3,i+1]:= FloatToStr(Self.f(StrToFloat(STRR.Cells[1,i+1]),StrToFloat(STRR.Cells[2,i+1]),SOL.Text));
      end;
      h:= h1;
      i:= i+1;
    end;
    Self.Plot();
end;

end.

//TfrmGraficadora
