unit uControllerProdutos;

interface

uses uModelProdutos, FireDAC.Comp.Client, System.SysUtils ;

type
 TControllerProdutos = class
 private
    FModelProdutos: TModelProdutos;

 public
   property ModelProdutos : TModelProdutos read  FModelProdutos write FModelProdutos;

   function persistir  : Boolean ;
   function selecionar : TFDQuery ;

   constructor Create;
   destructor destroy; override;

 end;

implementation

{ TControllerProdutos }

constructor TControllerProdutos.Create;
begin
    FModelProdutos := TModelProdutos.Create;
    inherited ;
end;

destructor TControllerProdutos.destroy;
begin
  FreeAndNil(FModelProdutos);
  inherited;
end;

function TControllerProdutos.persistir: Boolean;
begin
  result := FModelProdutos.persistir ;
end;

function TControllerProdutos.selecionar: TFDQuery;
begin
  result := FModelProdutos.selecionar ;
end;

end.
