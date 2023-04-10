unit Base.Frame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Actions, FMX.ActnList, FMX.TabControl, FMX.Effects, FMX.Objects,
  Base.Data, FMX.Filter.Effects, FMX.Controls.Presentation, FMX.ListBox,
  FMX.Layouts;

type
  TframBase = class(TFrame)
    actnlstBase: TActionList;
    actnSair: TAction;
    rctnglOpaco: TRectangle;
    rctHeadTitulo: TRectangle;
    lblTituloHead: TLabel;
    rctFormTotal: TRectangle;
    pthSair: TPath;
    procedure actnSairExecute(Sender: TObject);
  private
    FTitulo: string;
    FTabItem: TTabItem;
    FDataModule: TdtmdlBase;
    procedure SetTitulo(const Value: string);
    procedure SetTabItem(const Value: TTabItem);
    procedure SetDataModule(const Value: TdtmdlBase);
  public
    constructor Create(AOwner: TComponent); override;
    property Titulo: string read FTitulo write SetTitulo;
    property TabItem: TTabItem read FTabItem write SetTabItem;
    property DataModule: TdtmdlBase read FDataModule write SetDataModule;
  end;

implementation

{$R *.fmx}

{ TframBase }

procedure TframBase.actnSairExecute(Sender: TObject);
begin
  Visible := False;
end;

constructor TframBase.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TframBase.SetDataModule(const Value: TdtmdlBase);
begin
  FDataModule := Value;
end;

procedure TframBase.SetTabItem(const Value: TTabItem);
begin
  FTabItem := Value;
end;

procedure TframBase.SetTitulo(const Value: string);
begin
  FTitulo := Value;
  lblTituloHead.Text := Value;
end;

end.
