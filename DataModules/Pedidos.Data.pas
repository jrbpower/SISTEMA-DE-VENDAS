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
    fdqryProdutosGridcod_produto_1: TIntegerField;
    fdqryProdutosGriddescricao: TStringField;
    fdqryProdutosGridpreco_venda: TFMTBCDField;
    fdqryItensPedidocod_pedido_produto: TFDAutoIncField;
    fdqryItensPedidocod_nu_pedido: TIntegerField;
    fdqryItensPedidocod_produto: TIntegerField;
    fdqryItensPedidoquantidade: TFMTBCDField;
    fdqryItensPedidovalor_unit: TFMTBCDField;
    fdqryItensPedidovalor_total: TFMTBCDField;
    procedure fdqryPedidosBeforePost(DataSet: TDataSet);
  private
    FCliente: Integer;
    FValorUnit: Currency;
    FCodigoProduto: Integer;
    FQuantidade: Double;
    FNumPedido: Integer;
    FTotalPedido: Double;
    procedure SetCliente(const Value: Integer);
    procedure SetCodigoProduto(const Value: Integer);
    procedure SetQuantidade(const Value: Double);
    procedure SetValorUnit(const Value: Currency);
    procedure SetNumPedido(const Value: Integer);
    procedure SetTotalPedido(const Value: Double);
    { Private declarations }
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
    procedure AtualizarProdutos;
    procedure FecharGrid;
    property Cliente: Integer read FCliente write SetCliente;
    property CodigoProduto:Integer read FCodigoProduto write SetCodigoProduto;
    property Quantidade: Double read FQuantidade write SetQuantidade;
    property ValorUnit: Currency read FValorUnit write SetValorUnit;
    property NumPedido:Integer read FNumPedido write SetNumPedido;
    property TotalPedido:Double read FTotalPedido write SetTotalPedido;

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

procedure TdtmdlPedidos.AtualizarProdutos;
begin
  fdqryProdutosGrid.Close;
  fdqryProdutosGrid.ParamByName('ID').AsInteger :=
                                            fdqryPedidoscod_nu_pedido.AsInteger;
  if CodigoProduto <> 0 then
    fdqryProdutosGrid.MacroByName('AND').AsRaw := ' AND PP.COD_PRODUTO = '+
                                                        IntToStr(CodigoProduto);
  fdqryProdutosGrid.Open;
  fdqryProdutosGrid.Edit;
  fdqryProdutosGridquantidade.AsFloat := Quantidade;
  fdqryProdutosGridvalor_unit.AsCurrency := ValorUnit;
  fdqryProdutosGridvalor_total.AsFloat := ValorUnit * Quantidade;
  fdqryProdutosGrid.Post;
  GravarPedido;
  AtualizarGrid;
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
  fdqryItensPedido.Close;
  fdqryItensPedido.ParamByName('cod_nu_pedido').AsInteger := NumPedido;
  fdqryItensPedido.Open;
  fdqryItensPedido.First;
  while not fdqryItensPedido.Eof do
  begin
    ValorTotal := fdqryItensPedidovalor_unit.AsFloat *
                                            fdqryItensPedidoquantidade.AsFloat;
    fdqryItensPedido.Next;
  end;
end;

procedure TdtmdlPedidos.CancelarPedido;
begin
  fdqryItensPedido.Cancel;
  fdqryPedidos.Cancel;
  dtmdlConexaoLocal.conSistemaVendas.Rollback;
end;

procedure TdtmdlPedidos.fdqryPedidosBeforePost(DataSet: TDataSet);
begin
  inherited;
  fdqryPedidoscod_cliente.AsInteger := Cliente;
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
