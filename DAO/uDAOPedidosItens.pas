unit uDAOPedidosItens;

interface

uses System.SysUtils, uModelPedidosItens, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt ;

type
  TDAOPedidosItens = class

  public
    function selecionarPedidosItens(ModelPedidosItens : TModelPedidosItens): TFDQuery;
    function incluir (ModelPedidosItens : TModelPedidosItens): Boolean;
    function excluir (ModelPedidosItens : TModelPedidosItens): Boolean;
    function alterar (ModelPedidosItens : TModelPedidosItens): Boolean;

  end;

implementation

{ TDAOPedidosItens }


function TDAOPedidosItens.alterar(ModelPedidosItens: TModelPedidosItens): Boolean;
var
  QPedidosItens : TFDQuery ;
begin
  try
    QPedidosItens := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QPedidosItens.ExecSQL('update pedidos_itens set idpedidos = :idpedidos, idprodutos = :idprodutos, ite_quantidade = :ite_quantidade, ite_valorunitario = :ite_valorunitario, ite_valortotal = :ite_valortotal where idpedidos_itens = :idpedidos_itens',[ModelPedidosItens.intidpedidos, ModelPedidosItens.intidprodutos, ModelPedidosItens.curite_quantidade, ModelPedidosItens.curite_valorunitario, ModelPedidosItens.curite_valortotal, ModelPedidosItens.intidpedidos_itens ]) ;
    finally
      FreeAndNil(QPedidosItens) ;
    end;
    result := true ;
  except
    result := false ;
  end;
end;

function TDAOPedidosItens.excluir(ModelPedidosItens: TModelPedidosItens): Boolean;
var
  QPedidosItens : TFDQuery ;
begin
  try
    QPedidosItens := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QPedidosItens.ExecSQL('delete from pedidos_itens where idpedidos_itens = :idpedidos_itens',[ModelPedidosItens.intidpedidos_itens]) ;
    finally
      FreeAndNil(QPedidosItens) ;
    end;
    result := true ;
  except
    result := false ;
  end;
end;

function TDAOPedidosItens.incluir(ModelPedidosItens: TModelPedidosItens): Boolean;
var
  QPedidosItens : TFDQuery ;
begin
  try
    QPedidosItens := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QPedidosItens.ExecSQL('insert into pedidos_itens (idpedidos_itens, idpedidos, idprodutos, ite_quantidade, ite_valorunitario, ite_valortotal) values (:idpedidos_itens, :idpedidos, :idprodutos, :ite_quantidade, :ite_valorunitario, :ite_valortotal)',[ModelPedidosItens.intidpedidos_itens, ModelPedidosItens.intidpedidos, ModelPedidosItens.intidprodutos, ModelPedidosItens.curite_quantidade, ModelPedidosItens.curite_valorunitario, ModelPedidosItens.curite_valortotal ]) ;
    finally
      FreeAndNil(QPedidosItens) ;
    end;
    result := true ;
  except
    result := false ;
  end;
end;

function TDAOPedidosItens.selecionarPedidosItens(ModelPedidosItens : TModelPedidosItens): TFDQuery;
var
  QPedidosItens : TFDQuery ;
begin
  QPedidosItens := TControllerConexao.getInstance.daoConexao.criarQrery;
  QPedidosItens.Open('select pi.idpedidos_itens, pi.idpedidos, pi.idprodutos, p.prod_nome , pi.ite_quantidade, pi.ite_valorunitario, pi.ite_valortotal  from pedidos_itens pi left join produtos p on p.idprodutos = pi.idprodutos  where idpedidos = :idpedidos', [ModelPedidosItens.intidpedidos]) ;
  result := QPedidosItens ;
end;

end.
