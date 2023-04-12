unit Pedidos.Data;

interface

uses
  System.SysUtils, System.Classes, Base.Data, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.Client, Datasnap.DBClient, Datasnap.Provider,
  FireDAC.Comp.DataSet;

type
  TdtmdlPedidos = class(TdtmdlBase)
    fdqryCliente: TFDQuery;
    fdqryProdutos: TFDQuery;
    fdqryPedidos: TFDQuery;
    dspCliente: TDataSetProvider;
    dspProdutos: TDataSetProvider;
    fdqryItensPedido: TFDQuery;
    fdmtCache: TFDMemTable;
    dsCache: TDataSource;
    fdsAdapter: TFDSchemaAdapter;
    fdqryProdutoscod_produto: TIntegerField;
    fdqryProdutosdescricao: TStringField;
    fdqryProdutospreco_venda: TFMTBCDField;
    fdqryClientecod_cliente: TIntegerField;
    fdqryClientenome: TStringField;
    fdqryClientecidade: TStringField;
    fdqryClienteuf: TStringField;
    fdqryPedidoscod_nu_pedido: TIntegerField;
    fdqryPedidosdata_emissao: TDateTimeField;
    fdqryPedidoscod_cliente: TIntegerField;
    fdqryPedidosvl_total: TFMTBCDField;
    fdqryProdutosGrid: TFDQuery;
    fdqryProdutosGridcod_pedido_produto: TFDAutoIncField;
    fdqryProdutosGridcod_nu_pedido: TIntegerField;
    fdqryProdutosGridcod_produto: TIntegerField;
    fdqryProdutosGridquantidade: TFMTBCDField;
    fdqryProdutosGridvalor_unit: TFMTBCDField;
    fdqryProdutosGridvalor_total: TFMTBCDField;
    fdqryProdutosGriddescricao: TStringField;
    fdqryProdutosGridpreco_venda: TFMTBCDField;
    fdqryItensPedidocod_pedido_produto: TFDAutoIncField;
    fdqryItensPedidocod_nu_pedido: TIntegerField;
    fdqryItensPedidocod_produto: TIntegerField;
    fdqryItensPedidoquantidade: TFMTBCDField;
    fdqryItensPedidovalor_unit: TFMTBCDField;
    fdqryItensPedidovalor_total: TFMTBCDField;
    fdqryAux: TFDQuery;
    procedure fdqryPedidosBeforePost(DataSet: TDataSet);
    procedure fdqryProdutosGridCalcFields(DataSet: TDataSet);
  private
    FCliente: Integer;
    FValorUnit: Currency;
    FCodigoProduto: Integer;
    FQuantidade: Double;
    FNumPedido: Integer;
    FTotalPedido: Double;
    FIdProdPed: Integer;
    procedure SetCliente(const Value: Integer);
    procedure SetCodigoProduto(const Value: Integer);
    procedure SetQuantidade(const Value: Double);
    procedure SetValorUnit(const Value: Currency);
    procedure SetNumPedido(const Value: Integer);
    procedure SetTotalPedido(const Value: Double);

    procedure SetIdProdPed(const Value: Integer);    { Private declarations }
  public
    { Public declarations }
    procedure InserirPedido;
    procedure InserirProdutos;
    procedure GravarPedido;
    procedure CancelarPedido;
    procedure BuscarCliente(Nome:string);
    procedure BuscarProduto(Nome:string);
    procedure BuscarValorTotal;
    procedure AtualizarGrid;
    procedure ExcluirPedido;
    procedure ExcluirProdutos;
    procedure ExcluirProduto;
    procedure FecharGrid;
    property Cliente: Integer read FCliente write SetCliente;
    property CodigoProduto:Integer read FCodigoProduto write SetCodigoProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property ValorUnit: Currency read FValorUnit write SetValorUnit;
    property NumPedido:Integer read FNumPedido write SetNumPedido;
    property TotalPedido:Double read FTotalPedido write SetTotalPedido;
    property IdProdPed:Integer read FIdProdPed write SetIdProdPed;
  end;

var
  dtmdlPedidos: TdtmdlPedidos;

implementation

uses
  ConexaoLocal.Data;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdtmdlPedidos }

procedure TdtmdlPedidos.AtualizarGrid;
begin
  fdqryProdutosGrid.Close;
  fdqryProdutosGrid.ParamByName('ID').AsInteger :=
                                            fdqryPedidoscod_nu_pedido.AsInteger;
  fdqryProdutosGrid.Open;
end;

procedure TdtmdlPedidos.BuscarCliente(Nome: string);
begin
  fdqryCliente.Close;
  fdqryCliente.ParamByName('nome').AsString := '%'+UpperCase(Nome)+'%';
  fdqryCliente.Open;
end;

procedure TdtmdlPedidos.BuscarProduto(Nome: string);
begin
  fdqryProdutos.Close;
  if StrToIntDef(Nome,0) = 0 then
    fdqryProdutos.MacroByName('where').AsRaw :=
                 'where upper(descricao) like '+#39+'%'+UpperCase(Nome)+'%'+#39
  else
    fdqryProdutos.MacroByName('where').AsRaw :=
                 'where cod_produto = '+Nome;
  fdqryProdutos.Open;

end;

procedure TdtmdlPedidos.BuscarValorTotal;
var
  ValorTotal : Double;
begin
  ValorTotal := 0;
  fdqryProdutosGrid.Close;
  fdqryProdutosGrid.ParamByName('ID').AsInteger := NumPedido;
  fdqryProdutosGrid.Open;
  fdqryProdutosGrid.First;
  while not fdqryProdutosGrid.Eof do
  begin
    ValorTotal := fdqryProdutosGridvalor_unit.AsFloat *
      fdqryProdutosGridquantidade.AsFloat + ValorTotal;
    fdqryProdutosGrid.Next;
  end;
  TotalPedido := ValorTotal;
end;

procedure TdtmdlPedidos.CancelarPedido;
begin
  fdqryItensPedido.Cancel;
  fdqryPedidos.Cancel;
  ExcluirProdutos;
  ExcluirPedido;
  dtmdlConexaoLocal.conSistemaVendas.Rollback;
end;

procedure TdtmdlPedidos.ExcluirPedido;
begin
  fdqryAux.SQL.Clear;
  fdqryAux.Close;
  fdqryAux.SQL.text := 'DELETE pedidos FROM pedidos '+
    'LEFT JOIN produtos_pedidos ON '+
      'produtos_pedidos.cod_nu_pedido = pedidos.cod_nu_pedido '+
        'WHERE produtos_pedidos.cod_nu_pedido IS NULL;';
  fdqryAux.ExecSQL;
end;

procedure TdtmdlPedidos.ExcluirProduto;
begin
  fdqryAux.SQL.Clear;
  fdqryAux.Close;
  fdqryAux.SQL.add('DELETE FROM PRODUTOS_PEDIDOS WHERE cod_pedido_produto = '+
    intToStr(IdProdPed));
  fdqryAux.ExecSQL;
end;

procedure TdtmdlPedidos.ExcluirProdutos;
begin
  fdqryAux.SQL.Clear;
  fdqryAux.Close;
  fdqryAux.SQL.add('DELETE FROM PRODUTOS_PEDIDOS WHERE COD_NU_PEDIDO = '+
    intToStr(NumPedido));
  fdqryAux.ExecSQL;
end;

procedure TdtmdlPedidos.fdqryPedidosBeforePost(DataSet: TDataSet);
begin
  inherited;
  fdqryPedidoscod_cliente.AsInteger := Cliente;
end;

procedure TdtmdlPedidos.fdqryProdutosGridCalcFields(DataSet: TDataSet);
begin
  inherited;
  fdqryProdutosGridvalor_total.AsBCD := fdqryProdutosGridquantidade.AsFloat *
     fdqryProdutosGridvalor_unit.AsBCD;
end;

procedure TdtmdlPedidos.FecharGrid;
begin
  fdqryProdutosGrid.Close;
end;

procedure TdtmdlPedidos.GravarPedido;
begin
  fdqryPedidos.ApplyUpdates(0);
  fdqryItensPedido.ApplyUpdates(0);
  dtmdlConexaoLocal.conSistemaVendas.Commit;
end;

procedure TdtmdlPedidos.InserirPedido;
begin
  dtmdlConexaoLocal.conSistemaVendas.StartTransaction;
  fdqryPedidos.Close;
  fdqryPedidos.Open;
  fdqryPedidos.Last;
  NumPedido := fdqryPedidoscod_nu_pedido.AsInteger;
  fdqryPedidos.Insert;
  fdqryPedidoscod_nu_pedido.AsInteger := NumPedido+1;
  NumPedido := fdqryPedidoscod_nu_pedido.AsInteger;
  fdqryPedidosdata_emissao.AsDateTime := Now;
end;

procedure TdtmdlPedidos.InserirProdutos;
begin
  fdqryItensPedido.Close;
  fdqryItensPedido.Open;
  fdqryItensPedido.Last;

  fdqryItensPedido.Insert;

  fdqryItensPedidocod_nu_pedido.AsInteger :=
                                            fdqryPedidoscod_nu_pedido.AsInteger;
  fdqryItensPedidocod_produto.AsInteger := CodigoProduto;
  fdqryItensPedidoquantidade.AsFloat := Quantidade;
  fdqryItensPedidovalor_unit.AsFloat := ValorUnit;
  fdqryItensPedidovalor_total.AsFloat := ValorUnit * Quantidade;

  if Not (fdqryPedidos.State in dsEditModes) then
    fdqryPedidos.Edit;

  fdqryPedidosvl_total.AsFloat :=  fdqryPedidosvl_total.AsFloat +
                                            fdqryItensPedidovalor_total.AsFloat;
  TotalPedido := fdqryPedidosvl_total.AsFloat;

  fdqryItensPedido.Post;
  fdqryPedidos.Post;
  GravarPedido;
  AtualizarGrid;


end;

procedure TdtmdlPedidos.SetCliente(const Value: Integer);
begin
  FCliente := Value;
end;

procedure TdtmdlPedidos.SetCodigoProduto(const Value: Integer);
begin
  FCodigoProduto := Value;
end;

procedure TdtmdlPedidos.SetIdProdPed(const Value: Integer);
begin
  FIdProdPed := Value;
end;

procedure TdtmdlPedidos.SetNumPedido(const Value: Integer);
begin
  FNumPedido := Value;
end;

procedure TdtmdlPedidos.SetQuantidade(const Value: Double);
begin
  FQuantidade := Value;
end;

procedure TdtmdlPedidos.SetTotalPedido(const Value: Double);
begin
  FTotalPedido := Value;
end;

procedure TdtmdlPedidos.SetValorUnit(const Value: Currency);
begin
  FValorUnit := Value;
end;

end.
