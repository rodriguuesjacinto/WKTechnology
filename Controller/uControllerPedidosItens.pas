unit uControllerPedidosItens;

interface

uses uModelPedidosItens, FireDAC.Comp.Client, System.SysUtils ;

type
 TControllerPedidosItens = class
 private
    FModelPedidosItens: TModelPedidosItens;

 public
   property ModelPedidosItens : TModelPedidosItens read  FModelPedidosItens write FModelPedidosItens;

   function persistir  : Boolean ;
   function selecionar : TFDQuery ;

   constructor Create;
   destructor destroy; override;

 end;

implementation

{ TControllerPedidosItens }

constructor TControllerPedidosItens.Create;
begin
    FModelPedidosItens := TModelPedidosItens.Create;
    inherited ;
end;

destructor TControllerPedidosItens.destroy;
begin
  FreeAndNil(FModelPedidosItens);
  inherited;
end;

function TControllerPedidosItens.persistir: Boolean;
begin
  result := FModelPedidosItens.persistir ;
end;

function TControllerPedidosItens.selecionar: TFDQuery;
begin
  result := FModelPedidosItens.selecionar ;
end;


end.
