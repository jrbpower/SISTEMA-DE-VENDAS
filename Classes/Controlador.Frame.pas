unit Controlador.Frame;

interface

uses
  Classes, FMX.Forms, Base.Frame, Base.Data, Controlador, FMX.Types;

type
  TControlador<T: class; TData: TdtmdlBase; TVisao: TframBase> =
                               class(Controlador.TControlador<T, TData, TVisao>)
  private
  protected
    procedure CriarVisao; override;
  public
    procedure Exibir(Parent: TFmxObject); virtual;
  end;

implementation


procedure TControlador<T, TData, TVisao>.CriarVisao;
begin
  inherited;
  Visao.DataModule := DataModule;
end;


procedure TControlador<T, TData, TVisao>.Exibir(Parent: TFmxObject);
begin
  Visao.Align := TAlignLayout.Client;
  Visao.Parent := Parent;
  Visao.BringToFront;
  Visao.Visible := True;
end;

end.
