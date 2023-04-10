unit Base.Data;

interface

uses
  System.SysUtils, System.Classes;

type
  TdtmdlBase = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmdlBase: TdtmdlBase;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
