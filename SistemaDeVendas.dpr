program SistemaDeVendas;

uses
  System.StartUpCopy,
  FMX.Forms,
  Principal.Form in 'Formularios\Principal.Form.pas' {frmPrincipal},
  Base.Data in 'DataModules\Base.Data.pas' {dtmdlBase: TDataModule},
  Base.Frame in 'Frames\Base.Frame.pas' {framBase: TFrame},
  Controlador.Frame in 'Classes\Controlador.Frame.pas',
  Controlador in 'Classes\Controlador.pas',
  Pedidos.Frame in 'Frames\Pedidos.Frame.pas' {framPedidos: TFrame},
  Pedidos.Controlador in 'Classes\Pedidos.Controlador.pas',
  ConexaoLocal.Data in 'DataModules\ConexaoLocal.Data.pas' {dtmdlConexaoLocal: TDataModule},
  Pedidos.Data in 'DataModules\Pedidos.Data.pas' {dtmdlPedidos: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdtmdlBase, dtmdlBase);
  Application.CreateForm(TdtmdlConexaoLocal, dtmdlConexaoLocal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
