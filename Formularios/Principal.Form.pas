unit Principal.Form;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Effects, FMX.Layouts, FMX.MultiView,
  FMX.Controls.Presentation, FMX.Ani, FrameStand, SubjectStand, FormStand,
  System.Actions, FMX.ActnList, FMX.TabControl, FMX.DateTimeCtrls,
  Winapi.Windows, Base.Frame, DateUtils, Midaslib;

type
  TfrmPrincipal = class(TForm)
    pnFundo: TRectangle;
    ltMenu: TLayout;
    pnTitulo: TRectangle;
    ShadowEffect1: TShadowEffect;
    Layout1: TLayout;
    lblTitulo: TLabel;
    btnMenu: TSpeedButton;
    Rectangle1: TRectangle;
    Path11: TPath;
    lytTitul2: TLayout;
    lblTitulo2: TLabel;
    lytFrames: TLayout;
    pnTelas: TRectangle;
    ltFrame: TLayout;
    lytDlg: TLayout;
    rctDlg: TRectangle;
    ActionList1: TActionList;
    acLogin: TChangeTabAction;
    acConfig: TChangeTabAction;
    fm1: TFormStand;
    fs1: TFrameStand;
    mltvwMenu: TMultiView;
    pnMenu: TRectangle;
    sbxMenu: TVertScrollBox;
    rtTelaPedidos: TRectangle;
    caTelaPedidos: TColorAnimation;
    lblIndTelaPedidos: TLabel;
    Layout5: TLayout;
    Path3: TPath;
    Layout7: TLayout;
    rct5: TRectangle;
    Path5: TPath;
    spdbtnSair: TSpeedButton;
    pthSair: TPath;
    crclSair: TCircle;
    stylbkGeral: TStyleBook;
    procedure FormShow(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure pthSairClick(Sender: TObject);
    procedure rtTelaPedidosClick(Sender: TObject);
  private
    FFrameAtual: TframBase;
    procedure OcultarFrameAtual;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Pedidos.Controlador;


{$R *.fmx}



procedure TfrmPrincipal.btnMenuClick(Sender: TObject);
begin
  if mltvwMenu.IsShowed then
  begin
   mltvwMenu.HideMaster;
   ltMenu.Width:= 72;
  end
  else
  begin
   ltMenu.Width:= 250;
   mltvwMenu.ShowMaster;
  end;
  pnTitulo.Repaint;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  mltvwMenu.IsShowed;
  Self.FullScreen := False;
end;


procedure TfrmPrincipal.OcultarFrameAtual;
begin
  if Assigned(FFrameAtual) then
    FFrameAtual.Visible := False;
end;

procedure TfrmPrincipal.pthSairClick(Sender: TObject);
begin
  frmPrincipal.Close;
end;

procedure TfrmPrincipal.rtTelaPedidosClick(Sender: TObject);
begin
  OcultarFrameAtual;
  TPedidosControlador.GetInstance.Exibir(Self);
  TPedidosControlador.GetInstance.Visao.Parent := lytFrames;
  TPedidosControlador.GetInstance.Visao.Align := TAlignLayout.Client;
  FFrameAtual := TPedidosControlador.GetInstance.Visao;
end;

end.
