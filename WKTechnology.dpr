program WKTechnology;

uses
  Vcl.Forms,
  uViewPedidosdevendas in 'View\uViewPedidosdevendas.pas' {FormPedidosdevendas},
  uControllerConexao in 'Controller\uControllerConexao.pas',
  uDAOConexao in 'DAO\uDAOConexao.pas',
  uModelClientes in 'Model\uModelClientes.pas',
  uControllerClientes in 'Controller\uControllerClientes.pas',
  uDAOClientes in 'DAO\uDAOClientes.pas',
  uEnumerador in 'Model\uEnumerador.pas',
  uModelProdutos in 'Model\uModelProdutos.pas',
  uDAOProdutos in 'DAO\uDAOProdutos.pas',
  uControllerProdutos in 'Controller\uControllerProdutos.pas',
  uModelPedidosItens in 'Model\uModelPedidosItens.pas',
  uDAOPedidosItens in 'DAO\uDAOPedidosItens.pas',
  uModelPedidos in 'Model\uModelPedidos.pas',
  uDAOPedidos in 'DAO\uDAOPedidos.pas',
  uControllerPedidos in 'Controller\uControllerPedidos.pas',
  uControllerPedidosItens in 'Controller\uControllerPedidosItens.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPedidosdevendas, FormPedidosdevendas);
  Application.Run;
end.
