unit uDAOProdutos;

interface

uses System.SysUtils, uModelProdutos, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt ;

type
  TDAOProdutos = class

  public
    function selecionarprodutos(ModelProdutos : TModelProdutos) : TFDQuery;
    function incluir (ModelProdutos : TModelProdutos): Boolean;
    function excluir (ModelProdutos : TModelProdutos): Boolean;
    function alterar (ModelProdutos : TModelProdutos): Boolean;

  end;

implementation

{ TDAOProdutos }


function TDAOProdutos.alterar(ModelProdutos: TModelProdutos): Boolean;
var
  QProdutos : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    QProdutos := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QProdutos.ExecSQL('update produtos set prod_nome = :prod_nome,prod_valorparavenda = :prod_valorparavenda where idprodutos = :idprodutos',[ModelProdutos.strprod_nome, ModelProdutos.curprod_valorparavenda, ModelProdutos.intidprodutos]) ;
    finally
      FreeAndNil(QProdutos) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOProdutos.excluir(ModelProdutos: TModelProdutos): Boolean;
var
  QProdutos : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    QProdutos := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QProdutos.ExecSQL('delete from produtos where idprodutos = :idprodutos',[ModelProdutos.intidprodutos]) ;
    finally
      FreeAndNil(QProdutos) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOProdutos.incluir(ModelProdutos: TModelProdutos): Boolean;
var
  QProdutos : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    QProdutos := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QProdutos.ExecSQL('insert into produtos (prod_nome,prod_valorparavenda) values (:prod_nome,:prod_valorparavenda)',[ModelProdutos.strprod_nome, ModelProdutos.curprod_valorparavenda]) ;
    finally
      FreeAndNil(QProdutos) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOProdutos.selecionarprodutos(ModelProdutos : TModelProdutos): TFDQuery;
var
  QProdutos : TFDQuery ;
begin
  QProdutos := TControllerConexao.getInstance.daoConexao.criarQrery;
  if ModelProdutos.intidprodutos > 0 then
    QProdutos.Open('select * from produtos where idprodutos = :idprodutos',[ModelProdutos.intidprodutos])
  else
    QProdutos.Open('select * from produtos') ;
  result := QProdutos ;
end;

end.
