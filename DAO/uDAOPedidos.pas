unit uDAOPedidos;

interface

uses System.SysUtils, uModelPedidos, FireDAC.Comp.Client, uControllerConexao, FireDAC.DApt, uEnumerador ;

type
  TDAOPedidos = class

  public
    function selecionarPedidos(ModelPedidos : TModelPedidos): TFDQuery;
    function incluir (ModelPedidos : TModelPedidos): Boolean;
    function excluir (ModelPedidos : TModelPedidos): Boolean;
    function alterar (ModelPedidos : TModelPedidos): Boolean;

  end;

implementation

{ TDAOPedidos }

uses uDAOPedidosItens, uModelPedidosItens ;


function TDAOPedidos.alterar(ModelPedidos: TModelPedidos): Boolean;
var
  I : Integer ;
  QPedidos : TFDQuery ;
  daoPedidosItens : TDAOPedidosItens ;
begin
  try
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

      QPedidos := TControllerConexao.getInstance.daoConexao.criarQrery;
      try
        QPedidos.ExecSQL('update pedidos set idclientes = :idclientes, ped_dataemissao = :ped_dataemissao, ped_valortotal = :ped_valortotal where idpedidos = :idpedidos',[ModelPedidos.intidclientes, ModelPedidos.datped_dataemissao, ModelPedidos.curped_valortotal, ModelPedidos.intidpedidos]) ;
        for I := 0 to pred(ModelPedidos.listaitenspedido.Count) do
        begin
            case (ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens).enuTipo of
              tipoIncluir:
                daoPedidosItens.incluir((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
              tipoExcluir:
                daoPedidosItens.excluir((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
              tipoAlterar:
                daoPedidosItens.alterar((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
            end;
        end;
      finally
        FreeAndNil(QPedidos) ;
      end;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
      result := true ;
  except
      TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
      result := false ;
  end;
end;

function TDAOPedidos.excluir(ModelPedidos: TModelPedidos): Boolean;
var
  QPedidos : TFDQuery ;
begin
  try
    TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

      QPedidos := TControllerConexao.getInstance.daoConexao.criarQrery;
      try
        QPedidos.ExecSQL('delete from pedidos where idpedidos = :idpedidos',[ModelPedidos.intidpedidos]) ;
      finally
        FreeAndNil(QPedidos) ;
      end;

    TControllerConexao.getInstance().daoConexao.getConexao.commit ;
    result := true ;
  except
    TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
    result := false ;
  end;
end;

function TDAOPedidos.incluir(ModelPedidos: TModelPedidos): Boolean;
var
  QPedidos        : TFDQuery ;
  QParametro      : TFDQuery ;
  I               : integer  ;
  nPedido         : integer  ;
  daoPedidosItens : TDAOPedidosItens ;
begin
  try
    QPedidos   := TControllerConexao.getInstance.daoConexao.criarQrery;
    QParametro := TControllerConexao.getInstance.daoConexao.criarQrery;
    try
      TControllerConexao.getInstance().daoConexao.getConexao.StartTransaction ;

      // Pego o Numero do Pedido
      QParametro.Open('SELECT numerodopedido FROM parametros where idparametros = 1') ;
      nPedido := QParametro.FieldByName('numerodopedido').AsInteger ;

      QPedidos.ExecSQL('insert into pedidos (idpedidos, idclientes, ped_dataemissao, ped_valortotal) values (:idpedidos, :idclientes, :ped_dataemissao, :ped_valortotal)',[ModelPedidos.intidpedidos, ModelPedidos.intidclientes, ModelPedidos.datped_dataemissao, ModelPedidos.curped_valortotal]) ;

      for I := 0 to pred(ModelPedidos.listaitenspedido.Count) do
      begin
          (ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens).intidpedidos := nPedido ;
          case (ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens).enuTipo of
            tipoIncluir:
              daoPedidosItens.incluir((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
            tipoExcluir:
              daoPedidosItens.excluir((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
            tipoAlterar:
              daoPedidosItens.alterar((ModelPedidos.listaitenspedido.Items[I] as TModelPedidosItens)) ;
          end;

      end;

      TControllerConexao.getInstance().daoConexao.getConexao.Commit ;
      result := true ;
    except
      TControllerConexao.getInstance().daoConexao.getConexao.Rollback ;
      result := false ;
    end;

  finally
    FreeAndNil(QPedidos) ;
    FreeAndNil(QParametro) ;
  end;
end;

function TDAOPedidos.selecionarPedidos(ModelPedidos : TModelPedidos): TFDQuery;
var
  QPedidos : TFDQuery ;
begin
  QPedidos := TControllerConexao.getInstance.daoConexao.criarQrery;
  QPedidos.Open('select p.idpedidos, p.idclientes, c.cli_nome, p.ped_dataemissao, p.ped_valortotal  from pedidos p left join clientes c on c.idclientes = p.idclientes  where idpedidos = :idpedidos', [ModelPedidos.intidpedidos]) ;
  result := QPedidos ;
end;

end.
