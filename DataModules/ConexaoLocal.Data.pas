unit ConexaoLocal.Data;

interface

uses
  System.SysUtils, System.Classes, Base.Data, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Comp.UI, FireDAC.Phys.MySQL, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdtmdlConexaoLocal = class(TdtmdlBase)
    conSistemaVendas: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmdlConexaoLocal: TdtmdlConexaoLocal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdtmdlConexaoLocal.DataModuleCreate(Sender: TObject);
begin
  inherited;
  conSistemaVendas.Close;
  conSistemaVendas.Open;
end;

end.
