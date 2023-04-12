inherited dtmdlPedidos: TdtmdlPedidos
  OldCreateOrder = True
  Height = 523
  Width = 923
  object fdqryCliente: TFDQuery
    CachedUpdates = True
    Connection = dtmdlConexaoLocal.conSistemaVendas
    SQL.Strings = (
      'select '
      '  cod_cliente, '
      '  nome, '
      '  cidade, '
      '  uf '
      'from clientes'
      'where nome like :nome'
      'ORDER BY  nome')
    Left = 24
    Top = 8
    ParamData = <
      item
        Name = 'NOME'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    object fdqryClientecod_cliente: TIntegerField
      FieldName = 'cod_cliente'
      Origin = 'cod_cliente'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqryClientenome: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome'
      Origin = 'nome'
      Size = 250
    end
    object fdqryClientecidade: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'cidade'
      Origin = 'cidade'
      Size = 150
    end
    object fdqryClienteuf: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'uf'
      Origin = 'uf'
      Size = 10
    end
  end
  object fdqryProdutos: TFDQuery
    CachedUpdates = True
    Connection = dtmdlConexaoLocal.conSistemaVendas
    SQL.Strings = (
      'SELECT * FROM PRODUTOS'
      '!where')
    Left = 112
    Top = 8
    MacroData = <
      item
        Value = Null
        Name = 'WHERE'
      end>
    object fdqryProdutoscod_produto: TIntegerField
      FieldName = 'cod_produto'
      Origin = 'cod_produto'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqryProdutosdescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 255
    end
    object fdqryProdutospreco_venda: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'preco_venda'
      Origin = 'preco_venda'
      Precision = 20
      Size = 0
    end
  end
  object fdqryPedidos: TFDQuery
    BeforePost = fdqryPedidosBeforePost
    CachedUpdates = True
    Connection = dtmdlConexaoLocal.conSistemaVendas
    SQL.Strings = (
      'select '
      '  cod_nu_pedido, '
      '  data_emissao, '
      '  cod_cliente, '
      '  vl_total '
      'from pedidos')
    Left = 64
    Top = 207
    object fdqryPedidoscod_nu_pedido: TIntegerField
      FieldName = 'cod_nu_pedido'
      Origin = 'cod_nu_pedido'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqryPedidosdata_emissao: TDateTimeField
      AutoGenerateValue = arDefault
      FieldName = 'data_emissao'
      Origin = 'data_emissao'
    end
    object fdqryPedidoscod_cliente: TIntegerField
      FieldName = 'cod_cliente'
      Origin = 'cod_cliente'
      Required = True
    end
    object fdqryPedidosvl_total: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'vl_total'
      Origin = 'vl_total'
      Precision = 20
      Size = 2
    end
  end
  object dspCliente: TDataSetProvider
    DataSet = fdqryCliente
    Left = 24
    Top = 64
  end
  object dspProdutos: TDataSetProvider
    DataSet = fdqryProdutos
    Left = 112
    Top = 64
  end
  object fdqryItensPedido: TFDQuery
    CachedUpdates = True
    Connection = dtmdlConexaoLocal.conSistemaVendas
    FetchOptions.AssignedValues = [evCache]
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'SELECT '
      '*'
      'FROM PRODUTOS_PEDIDOS')
    Left = 160
    Top = 208
    object fdqryItensPedidocod_pedido_produto: TFDAutoIncField
      FieldName = 'cod_pedido_produto'
      Origin = 'cod_pedido_produto'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqryItensPedidocod_nu_pedido: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'cod_nu_pedido'
      Origin = 'cod_nu_pedido'
    end
    object fdqryItensPedidocod_produto: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'cod_produto'
      Origin = 'cod_produto'
    end
    object fdqryItensPedidoquantidade: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 20
      Size = 4
    end
    object fdqryItensPedidovalor_unit: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_unit'
      Origin = 'valor_unit'
      Precision = 20
      Size = 2
    end
    object fdqryItensPedidovalor_total: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total'
      Origin = 'valor_total'
      Precision = 20
      Size = 2
    end
  end
  object fdmtCache: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 464
    Top = 208
  end
  object dsCache: TDataSource
    DataSet = fdmtCache
    Left = 464
    Top = 264
  end
  object fdsAdapter: TFDSchemaAdapter
    Left = 584
    Top = 208
  end
  object fdqryProdutosGrid: TFDQuery
    OnCalcFields = fdqryProdutosGridCalcFields
    CachedUpdates = True
    Connection = dtmdlConexaoLocal.conSistemaVendas
    SQL.Strings = (
      'SELECT '
      '  * '
      'FROM produtos_pedidos pp'
      'LEFT JOIN produtos p on p.cod_produto = pp.cod_produto'
      'WHERE PP.cod_nu_pedido = :ID'
      ' !AND')
    Left = 264
    Top = 208
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
    MacroData = <
      item
        Value = Null
        Name = 'AND'
      end>
    object fdqryProdutosGridcod_pedido_produto: TFDAutoIncField
      FieldName = 'cod_pedido_produto'
      Origin = 'cod_pedido_produto'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqryProdutosGridcod_nu_pedido: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'cod_nu_pedido'
      Origin = 'cod_nu_pedido'
    end
    object fdqryProdutosGridcod_produto: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'cod_produto'
      Origin = 'cod_produto'
    end
    object fdqryProdutosGridquantidade: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 20
      Size = 4
    end
    object fdqryProdutosGridvalor_unit: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_unit'
      Origin = 'valor_unit'
      currency = True
      Precision = 20
      Size = 2
    end
    object fdqryProdutosGridvalor_total: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'valor_total'
      Origin = 'valor_total'
      currency = True
      Precision = 20
      Size = 2
    end
    object fdqryProdutosGriddescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      ProviderFlags = []
      ReadOnly = True
      Size = 255
    end
    object fdqryProdutosGridpreco_venda: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'preco_venda'
      Origin = 'preco_venda'
      ProviderFlags = []
      ReadOnly = True
      Precision = 20
      Size = 2
    end
  end
  object fdqryAux: TFDQuery
    Connection = dtmdlConexaoLocal.conSistemaVendas
    Left = 408
    Top = 72
  end
end
