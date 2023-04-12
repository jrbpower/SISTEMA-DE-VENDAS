inherited dtmdlConexaoLocal: TdtmdlConexaoLocal
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 463
  Width = 595
  object conSistemaVendas: TFDConnection
    ConnectionName = 'SistemaVendas'
    LoginPrompt = False
    Left = 56
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\SOLUC\Downloads\MySQL\libmysql\libmysql.dll'
    Left = 56
    Top = 72
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 56
    Top = 132
  end
end
