unit Aplicacao.Data;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, System.ImageList,
  FMX.ImgList;

type
  TdtmdlAplicacao = class(TDataModule)
    StyleBook: TStyleBook;
    imglst32: TImageList;
    sbEstilo: TStyleBook;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmdlAplicacao: TdtmdlAplicacao;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
