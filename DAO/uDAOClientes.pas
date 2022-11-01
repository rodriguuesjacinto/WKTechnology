unit uDAOClientes;

interface

uses System.SysUtils, uModelClientes, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt ;

type
  TDAOClientes = class

  public
    function selecionarcliente(ModelClientes : TModelClientes): TFDQuery;
    function incluir (ModelClientes : TModelClientes): Boolean;
    function excluir (ModelClientes : TModelClientes): Boolean;
    function alterar (ModelClientes : TModelClientes): Boolean;

  end;

implementation

{ TDAOClientes }


function TDAOClientes.alterar(ModelClientes: TModelClientes): Boolean;
var
  QClientes : TFDQuery ;
begin
  try
    QClientes := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QClientes.ExecSQL('update clientes set cli_nome = :cli_nome,cli_cidade = :cli_cidade,cli_uf = :cli_uf where idclientes = :idclientes',[ModelClientes.strcli_nome, ModelClientes.strcli_cidade, ModelClientes.strcli_uf, ModelClientes.intidclientes]) ;
    finally
      FreeAndNil(QClientes) ;
    end;
    result := true ;
  except
    result := false ;
  end;
end;

function TDAOClientes.excluir(ModelClientes: TModelClientes): Boolean;
var
  QClientes : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    QClientes := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QClientes.ExecSQL('delete from clientes where idclientes = :idclientes',[ModelClientes.intidclientes]) ;
    finally
      FreeAndNil(QClientes) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOClientes.incluir(ModelClientes: TModelClientes): Boolean;
var
  QClientes : TFDQuery ;
begin
  try
     TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

    QClientes := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      QClientes.ExecSQL('insert into clientes (cli_nome,cli_cidade,cli_uf) values (:cli_nome,:cli_cidade,:cli_uf)',[ModelClientes.strcli_nome, ModelClientes.strcli_cidade, ModelClientes.strcli_uf]) ;
    finally
      FreeAndNil(QClientes) ;
    end;

    TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOClientes.selecionarcliente(ModelClientes : TModelClientes): TFDQuery;
var
  QClientes : TFDQuery ;
begin
  QClientes := TControllerConexao.getInstance.daoConexao.criarQrery;
  if ModelClientes.intidclientes > 0   then
     QClientes.Open('select * from clientes where idclientes = :idclientes',[ModelClientes.intidclientes])
  else
     QClientes.Open('select * from clientes') ;
  result := QClientes ;
end;

end.
