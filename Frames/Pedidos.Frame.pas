unit Pedidos.Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Base.Frame, System.Rtti, FMX.Grid.Style, FMX.Edit, FMX.ScrollBox, FMX.Grid,
  FMX.Layouts, System.Actions, FMX.ActnList, FMX.Controls.Presentation,
  FMX.Objects, Data.DB, Data.Bind.Components, Data.Bind.DBScope,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Grid, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ListBox, Data.Bind.Controls, Fmx.Bind.Navigator;

type
  TframPedidos = class(TframBase)
    lytGrid: TLayout;
    lytProdutos: TLayout;
    lytRodaPe: TLayout;
    grdPedidos: TGrid;
    lblCliente: TLabel;
    edtCliente: TEdit;
    bndsrcdbGridProdutos: TBindSourceDB;
    bndngslstGridProdutos: TBindingsList;
    lnkgrdtdtsrcbndsrcdbGridProdutos: TLinkGridToDataSource;
    bndsrcdbGridCliente: TBindSourceDB;
    schbtnBuscarCliente: TSearchEditButton;
    clrbtnApagarCliente: TClearEditButton;
    lnkflcntrltfldIDCliente: TLinkFillControlToField;
    btnNovoPedido: TButton;
    btnCancelarPedido: TButton;
    btnGravarPedido: TButton;
    pthMoveAcima: TPath;
    pthMoverBaixo: TPath;
    edtcodProduto: TEdit;
    edtQtd: TEdit;
    edtValorUnit: TEdit;
    btnInserirPedidos: TButton;
    lblCodProduto: TLabel;
    lblQuantidade: TLabel;
    lblValorUnit: TLabel;
    bndsrcdbLSTProdutos: TBindSourceDB;
    lnkflcntrltfldProdutos: TLinkFillControlToField;
    actNovo: TAction;
    actCancelar: TAction;
    actSalvar: TAction;
    actAdcionar: TAction;
    lblValorTotal: TLabel;
    lblTotal: TLabel;
    popCliente: TPopup;
    popProdutos: TPopup;
    lytCursorGrid: TLayout;
    lytTotal: TLayout;
    lstbxCliente: TListBox;
    lblCodCliente: TLabel;
    lnkctlprpTextIDCliente: TLinkFillControlToProperty;
    lblIDProduto: TLabel;
    lstbxProdutos: TListBox;
    lnkctlprpIDProdutos: TLinkFillControlToProperty;
    schbtnBuscarProd: TSearchEditButton;
    schbtnBuscarClient: TSearchEditButton;
    btnExcluirProduto: TButton;
    procedure actNovoExecute(Sender: TObject);
    procedure actAdcionarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure edtcodProdutoExit(Sender: TObject);
    procedure edtcodProdutoEnter(Sender: TObject);
    procedure edtQtdEnter(Sender: TObject);
    procedure clrbtnApagarClienteClick(Sender: TObject);
    procedure pthMoveAcimaClick(Sender: TObject);
    procedure pthMoverBaixoClick(Sender: TObject);
    procedure Desabilitar;
    procedure lstbxClienteItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lstbxProdutosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure schbtnBuscarProdClick(Sender: TObject);
    procedure schbtnBuscarClientClick(Sender: TObject);
    procedure btnExcluirProdutoClick(Sender: TObject);
    procedure grdPedidosCellClick(const Column: TColumn; const Row: Integer);
    procedure bndsrcdbGridProdutosSubDataSourceStateChange(Sender: TObject);
  private
    FStatus :string;
    { Private declarations }
    procedure limparCampos;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  framPedidos: TframPedidos;

implementation

uses
  Pedidos.Data, Pedidos.Controlador;

{$R *.fmx}

procedure TframPedidos.actAdcionarExecute(Sender: TObject);
begin
  inherited;
  if FStatus = 'Inserir' then
  begin
    TPedidosControlador.GetInstance.DataModule.CodigoProduto :=
                                                   StrToInt(edtcodProduto.Text);
    TPedidosControlador.GetInstance.DataModule.Quantidade :=
                                                        StrToFloat(edtQtd.Text);
    TPedidosControlador.GetInstance.DataModule.ValorUnit :=
                                                   StrToCurr(edtValorUnit.Text);
    TPedidosControlador.GetInstance.DataModule.InserirProdutos;
    lblTotal.Text :=
      FormatFloat('#.00',TPedidosControlador.GetInstance.DataModule.TotalPedido);
    limparCampos;
  end
  else
  if bndsrcdbGridProdutos.DataSet.State = dsEdit then
  begin
    bndsrcdbGridProdutos.DataSet.FieldByName('valor_total').AsFloat :=
      bndsrcdbGridProdutos.DataSet.FieldByName('quantidade').AsFloat *
        bndsrcdbGridProdutos.DataSet.FieldByName('valor_unit').AsFloat;

    TPedidosControlador.GetInstance.DataModule.IdProdPed :=
      bndsrcdbGridProdutos.DataSet.FieldByName('cod_pedido_produto').AsInteger;

    bndsrcdbGridProdutos.DataSet.Post;
    TPedidosControlador.GetInstance.DataModule.fdqryProdutosGrid.ApplyUpdates(0);
    TPedidosControlador.GetInstance.DataModule.BuscarValorTotal;
    lblTotal.Text :=
      FormatFloat('#.00',
                       TPedidosControlador.GetInstance.DataModule.TotalPedido);
  end;


end;

procedure TframPedidos.actCancelarExecute(Sender: TObject);
begin
  inherited;
  Desabilitar;
  TPedidosControlador.GetInstance.DataModule.CancelarPedido;

end;

procedure TframPedidos.actNovoExecute(Sender: TObject);
begin
  inherited;
  FStatus := 'Inserir';
  Desabilitar;
  TPedidosControlador.GetInstance.DataModule.InserirPedido;
  edtCliente.Enabled := True;
  edtCliente.SetFocus;
end;

procedure TframPedidos.actSalvarExecute(Sender: TObject);
begin
  inherited;
  TPedidosControlador.GetInstance.DataModule.GravarPedido;
  Desabilitar;
end;

procedure TframPedidos.bndsrcdbGridProdutosSubDataSourceStateChange(
  Sender: TObject);
begin
  inherited;
  if bndsrcdbGridProdutos.DataSet.State = dsEdit then
     FStatus := 'Editar'
end;

procedure TframPedidos.btnExcluirProdutoClick(Sender: TObject);
begin
  inherited;
  if FStatus = 'Excluir' then
  begin

    MessageDlg('Tem Certeza que Deseja Excluir?',
      System.UITypes.TMsgDlgType.mtInformation,
      [System.UITypes.TMsgDlgBtn.mbYes,
      System.UITypes.TMsgDlgBtn.mbNo
    ], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYES:
        begin
          TPedidosControlador.GetInstance.DataModule.IdProdPed :=
            bndsrcdbGridProdutos.DataSet.FieldByName('cod_pedido_produto').AsInteger;
          TPedidosControlador.GetInstance.DataModule.ExcluirProduto;
          TPedidosControlador.GetInstance.DataModule.AtualizarGrid;
          TPedidosControlador.GetInstance.DataModule.BuscarValorTotal;
          lblTotal.Text :=
            FormatFloat('#.00',
                       TPedidosControlador.GetInstance.DataModule.TotalPedido);

        end;
      end;
    end);
  end
  else
    MessageDlg('Tem que Selecionar o um item na Grid!',
      TMsgDlgType.mtwarning,[TMsgDlgBtn.mbok],0);

end;

Procedure TframPedidos.clrbtnApagarClienteClick(Sender: TObject);
begin
  inherited;
  edtCliente.Text.Empty;
end;

constructor TframPedidos.Create(AOwner: TComponent);
begin
  inherited;
  Titulo := 'Lançamento de Pedidos';
  Desabilitar;
end;

procedure TframPedidos.Desabilitar;
begin
  edtCliente.Text := EmptyStr;
  edtcodProduto.Text := EmptyStr;
  edtQtd.text := EmptyStr;
  edtValorUnit.text := EmptyStr;
  edtCliente.Enabled := False;
  edtcodProduto.Enabled := False;
  edtQtd.Enabled := False;
  edtValorUnit.Enabled := False;
  btnInserirPedidos.Enabled := False;

  if popCliente.Visible then
    popCliente.Visible := False;

  if popProdutos.Visible then
    popProdutos.Visible := False;
  lblTotal.Text := '0,00';
  TPedidosControlador.GetInstance.DataModule.FecharGrid;
end;

procedure TframPedidos.edtcodProdutoEnter(Sender: TObject);
begin
  inherited;
  edtQtd.SetFocus;
end;

procedure TframPedidos.edtcodProdutoExit(Sender: TObject);
begin
  edtQtd.SetFocus;
end;

procedure TframPedidos.edtQtdEnter(Sender: TObject);
begin
  inherited;
  edtValorUnit.SetFocus;
end;

procedure TframPedidos.grdPedidosCellClick(const Column: TColumn;
  const Row: Integer);
begin
  inherited;
  FStatus := 'Excluir';
end;

procedure TframPedidos.limparCampos;
begin
  edtcodProduto.Text := EmptyStr;
  edtQtd.text := EmptyStr;
  edtValorUnit.text := EmptyStr;
end;

procedure TframPedidos.lstbxClienteItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  inherited;
  edtCliente.Text := lstbxCliente.Selected.Text;
  TPedidosControlador.GetInstance.DataModule.Cliente :=
                                                   StrToInt(lblCodCliente.Text);
  popCliente.Visible := False;
  edtcodProduto.Enabled := True;
  edtQtd.Enabled := True;
  edtValorUnit.Enabled := True;
  btnInserirPedidos.Enabled := True;
  edtcodProduto.SetFocus;
end;

procedure TframPedidos.lstbxProdutosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  inherited;
  edtValorUnit.Text := EmptyStr;
  edtcodProduto.Text := lblIDProduto.Text;
  TPedidosControlador.GetInstance.DataModule.CodigoProduto :=
                                                    StrToInt(lblIDProduto.Text);
  edtValorUnit.Text :=
      FormatFloat('#.00',
        bndsrcdbLSTProdutos.DataSet.FieldByName('preco_venda').AsFloat);
  popProdutos.Visible := False;
  FStatus := 'Inserir';
  edtQtd.text := '1';
  edtQtd.SetFocus;
end;

procedure TframPedidos.pthMoveAcimaClick(Sender: TObject);
begin
  inherited;
  bndsrcdbGridProdutos.datasource.dataset.prior;
end;

procedure TframPedidos.pthMoverBaixoClick(Sender: TObject);
begin
  inherited;
  bndsrcdbGridProdutos.datasource.dataset.next;
end;

procedure TframPedidos.schbtnBuscarClientClick(Sender: TObject);
begin
  inherited;

  if Length(edtCliente.Text) > 0 then
  begin
    TPedidosControlador.GetInstance.DataModule.BuscarCliente(edtCliente.Text);
    popCliente.Visible := True;
  end
  else
  MessageDlg('Tem que Digitar ou codigo ou nome!',
                                  TMsgDlgType.mtwarning,[TMsgDlgBtn.mbok],0);
end;

procedure TframPedidos.schbtnBuscarProdClick(Sender: TObject);
begin
  inherited;

  if Length(edtcodProduto.text) > 0 then
  begin
    TPedidosControlador.GetInstance.DataModule.BuscarProduto(
                                                            edtcodProduto.text);
    popProdutos.Visible := True;
  end
  else
    MessageDlg('Tem que Digitar ou codigo ou nome!',
                                   TMsgDlgType.mtwarning,[TMsgDlgBtn.mbok],0);

end;

end.
