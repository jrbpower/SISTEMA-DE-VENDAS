unit Controlador;

interface

uses
  Classes, FMX.Forms, Base.Data, FMX.Types;

type
  TControlador<T: class; TData: TdtmdlBase; TVisao: TFmxObject> = class(TComponent)
  strict private
    class var FInstance: T;
    constructor Create(AOwner: TComponent); override;
  private
    FOnDestroy: TNotifyEvent;
    FDataModule: TData;
    FVisao: TVisao;
    function GetDataModule: TData;
    procedure SetOnDestroy(const Value: TNotifyEvent);
    function GetVisao: TVisao;
    function BuscarVisao: TVisao;
    procedure SetVisao(const Value: TVisao);
  protected
    procedure CriarVisao; virtual;
  public
    class function GetInstance: T;
    destructor Destroy; override;
    property OnDestroy: TNotifyEvent read FOnDestroy write SetOnDestroy;
    property DataModule: TData read GetDataModule;
    property Visao: TVisao read GetVisao write SetVisao;
  end;

implementation

{ TControlador<T> }

function TControlador<T, TData, TVisao>.BuscarVisao: TVisao;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Application.ComponentCount - 1 do
  begin
    if Application.Components[I] is  TClass(TVisao) then
    begin
      Result := TVisao(Application.Components[I]);
      Break;
    end;
  end;
end;

constructor TControlador<T, TData, TVisao>.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TControlador<T, TData, TVisao>.CriarVisao;
begin
  FVisao :=  TVisao(TComponentClass(TVisao).Create(Application));
end;

destructor TControlador<T, TData, TVisao>.Destroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
  FInstance := nil;
  inherited;
end;

function TControlador<T, TData, TVisao>.GetDataModule: TData;
begin
  if not Assigned(FDataModule) then
    FDataModule :=  TData(TComponentClass(TData).Create(Application));
  Result := FDataModule;
end;

class function TControlador<T, TData, TVisao>.GetInstance: T;
begin
  if not Assigned(FInstance) then
    FInstance := T(Self.Create(Application));
  Result := FInstance;
end;

function TControlador<T, TData, TVisao>.GetVisao: TVisao;
begin
  Self.DataModule;
  FVisao := BuscarVisao;
  if (FVisao = nil) then
  begin
    CriarVisao;
  end;
  Result := FVisao;
end;

procedure TControlador<T, TData, TVisao>.SetOnDestroy(const Value: TNotifyEvent);
begin
  FOnDestroy := Value;
end;

procedure TControlador<T, TData, TVisao>.SetVisao(const Value: TVisao);
begin
  FVisao := Value;
end;

end.
