unit uControllerPedidos;

interface

uses uModelPedidos, FireDAC.Comp.Client, System.SysUtils ;

type
 TControllerPedidos = class
 private
    FModelPedidos: TModelPedidos;

 public
   property ModelPedidos : TModelPedidos read  FModelPedidos write FModelPedidos;

   function persistir  : Boolean ;
   function selecionar : TFDQuery ;

   constructor Create;
   destructor destroy; override;

 end;

implementation

{ TControllerPedidos }

constructor TControllerPedidos.Create;
begin
    FModelPedidos := TModelPedidos.Create;
    inherited ;
end;

destructor TControllerPedidos.destroy;
begin
  FreeAndNil(FModelPedidos);
  inherited;
end;

function TControllerPedidos.persistir: Boolean;
begin
  result := FModelPedidos.persistir ;
end;

function TControllerPedidos.selecionar: TFDQuery;
begin
  result := FModelPedidos.selecionar ;
end;

end.
