unit uViewPedidosdevendas;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Imaging.pngimage,
  Vcl.Mask, Vcl.Buttons ;

type
  TFormPedidosdevendas = class(TForm)
    PanelTopo: TPanel;
    PanelPedido: TPanel;
    PanelItensPedido: TPanel;
    PanelRodape: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    EditCodCliente: TEdit;
    EditNomeCliente: TEdit;
    Label3: TLabel;
    EditCodigoProduto: TEdit;
    EditNomeProduto: TEdit;
    Label4: TLabel;
    EditQuantidade: TEdit;
    Label5: TLabel;
    EditValorUnitario: TEdit;
    Label6: TLabel;
    EditValorTotal: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    ListViewItensPedido: TListView;
    Panel1: TPanel;
    ButtonIncluirProduto: TButton;
    ButtonGravarPedido: TButton;
    Label9: TLabel;
    EditNumeroPedido: TEdit;
    Label10: TLabel;
    PanelValorTotalPedido: TPanel;
    ButtonAbrirPedido: TButton;
    ButtonCancelarPedido: TButton;
    Image1: TImage;
    Label11: TLabel;
    Bevel1: TBevel;
    Label12: TLabel;
    DatePedido: TMaskEdit;
    ListItensPedidosDeletados: TListView;
    SpeedButton1: TSpeedButton;
    procedure EditCodClienteExit(Sender: TObject);
    procedure EditCodigoProdutoExit(Sender: TObject);
    procedure ButtonIncluirProdutoClick(Sender: TObject);
    procedure EditQuantidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditQuantidadeChange(Sender: TObject);
    procedure EditValorUnitarioChange(Sender: TObject);
    procedure EditValorUnitarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodClienteChange(Sender: TObject);
    procedure EditCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure EditCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure EditQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure EditValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure EditQuantidadeExit(Sender: TObject);
    procedure EditValorUnitarioExit(Sender: TObject);
    procedure ListViewItensPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditCodigoProdutoEnter(Sender: TObject);
    procedure ButtonGravarPedidoClick(Sender: TObject);
    procedure ButtonCancelarPedidoClick(Sender: TObject);
    procedure ButtonAbrirPedidoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    function buscaCliente(xcodigoCliente : integer) : boolean ;
    function buscaProduto(xcodigoProduto : integer) : boolean ;
    function valorTotalPedido(): Double ;
    procedure limpaEditVenda()  ;
    procedure limpaEditPedido() ;
    procedure calculaValorTotalProduto() ;
  public
    { Public declarations }
  end;

var
  FormPedidosdevendas: TFormPedidosdevendas;

implementation

{$R *.dfm}

uses uControllerConexao, uControllerClientes, uControllerProdutos, uControllerPedidos, uModelPedidosItens, uControllerPedidosItens, uEnumerador;

{ TFormPedidosdevendas }

function TFormPedidosdevendas.buscaCliente(xcodigoCliente: integer): boolean;
var
  controllerClientes : TControllerClientes ;
begin
  try
    controllerClientes := TControllerClientes.Create;
    controllerClientes.ModelClientes.intidclientes := xcodigoCliente ;

    with controllerClientes.selecionar  do
    begin
       if RecNo = 0 then
         result := False
       else
       begin
          EditNomeCliente.Text := FieldByName('cli_nome').AsString ;
          result := True ;
       end;
    end ;
  finally
    FreeAndNil(controllerClientes)  ;
  end;
end;

function TFormPedidosdevendas.buscaProduto(xcodigoProduto: integer): boolean;
var
  controllerProdutos : TControllerProdutos ;
begin
  try
    controllerProdutos := TControllerProdutos.Create;
    controllerProdutos.ModelProdutos.intidprodutos := xcodigoProduto ;
    with controllerProdutos.selecionar do
    begin
       if RecNo = 0 then
         result := False
       else
       begin
         EditNomeProduto.Text   := FieldByName('prod_nome').AsString ;
         EditValorUnitario.Text := FloatToStrF(FieldByName('prod_valorparavenda').AsFloat,ffNumber,15,2) ;
         result := True ;
       end;
    end ;

  finally
    FreeAndNil(controllerProdutos)  ;
  end;
end;

procedure TFormPedidosdevendas.ButtonAbrirPedidoClick(Sender: TObject);
var
 numeroPedido : String ;
 Item     : TListItem  ;
 controllerPedidos      : TControllerPedidos ;
 controllerPedidosItens : TControllerPedidosItens ;
begin
   if not(InputQuery('Excluir Pedido',' Informe o numero do Pedido.', numeroPedido)) then
      exit
   else
   begin
      try
          StrToInt(numeroPedido);
      except
          showmessage('Numero Invalido tente novamete.');
          exit ;
      end;
   end;

   try
      controllerPedidos := TControllerPedidos.Create;
      with controllerPedidos.ModelPedidos do
      begin
         intidpedidos  := StrToInt(numeroPedido)  ;
         enuTipo       := uEnumerador.tipoExcluir ;
      end;

      with controllerPedidos.selecionar do
      begin
         if RecNo <> 0 then
         begin
            EditNumeroPedido.Text   :=  FieldByName('idpedidos').AsString ;
            EditNomeCliente.Text    :=  FieldByName('cli_nome').AsString ;
            DatePedido.Text         :=  FieldByName('ped_dataemissao').AsString ;
            EditCodCliente.Text     :=  FieldByName('idclientes').AsString ;
         end
         else
         begin
            showmessage('Numero de Pedido n�o encontrado tente novamete.');
            exit ;
         end
      end;

      controllerPedidosItens := TControllerPedidosItens.Create;
      controllerPedidosItens.ModelPedidosItens.intidpedidos := StrToInt(numeroPedido)  ;
      with controllerPedidosItens.selecionar do
      begin
         ListViewItensPedido.Items.Clear ;
         while not Eof do
         begin
             // Incluindo os produtos noo List
             Item := ListViewItensPedido.Items.Add                   ;
             Item.Caption := FieldByName('idpedidos_itens').AsString ;
             Item.SubItems.Add(FieldByName('idprodutos').AsString)   ;
             Item.SubItems.Add(FieldByName('prod_nome').AsString)    ;
             Item.SubItems.Add(FloatToStrF(FieldByName('ite_quantidade').AsFloat,ffNumber,15,2))      ;
             Item.SubItems.Add(FloatToStrF(FieldByName('ite_valorunitario').AsFloat,ffNumber,15,2))   ;
             Item.SubItems.Add(FloatToStrF(FieldByName('ite_valortotal').AsFloat,ffNumber,15,2))      ;
            Next;
         end ;
      end;

      limpaEditVenda ;

   finally
      FreeAndNil(controllerPedidos) ;
   end;


end;

procedure TFormPedidosdevendas.ButtonCancelarPedidoClick(Sender: TObject);
var
 numeroPedido : String ;
 controllerPedidos : TControllerPedidos ;
begin
   if not(InputQuery('Excluir Pedido','   Aten��o essa a��o ira excluir os dados do Pedido.'+#13+#13+'  Informe o numero do Pedido.'+#13, numeroPedido)) then
      exit
   else
   begin
      try
          StrToInt(numeroPedido);
      except
          showmessage('Numero Invalido tente novamete.');
          exit ;
      end;
   end;

   try
      controllerPedidos := TControllerPedidos.Create;
      with controllerPedidos.ModelPedidos do
      begin
         intidpedidos  := StrToInt(numeroPedido)  ;       ;
         enuTipo       := uEnumerador.tipoExcluir ;
      end;

      if controllerPedidos.persistir then
      begin
         ShowMessage('Registro Excluido....') ;
         ListViewItensPedido.Items.Clear ;
         limpaEditVenda  ;
         limpaEditPedido ;
         EditCodCliente.SetFocus;
      end
      else
      begin
         ShowMessage('Erro n�o especificado....') ;
      end;
   finally
      FreeAndNil(controllerPedidos) ;
   end;

end;

procedure TFormPedidosdevendas.ButtonGravarPedidoClick(Sender: TObject);
var
 I : Integer ;
 controllerPedidos : TControllerPedidos ;
 modelPedidosItens : TModelPedidosItens ;
begin
      try
      controllerPedidos := TControllerPedidos.Create;
      with controllerPedidos.ModelPedidos do
      begin
         intidpedidos           := StrToIntDef(EditNumeroPedido.Text,0)  ;
         intidclientes          := StrToIntDef(EditCodCliente.Text,0)    ;
         datped_dataemissao     := FormatDateTime('yyyy-mm-dd',date())   ;
         curped_valortotal      := StrToFloatDef(PanelValorTotalPedido.Caption,0) ;
         if StrToIntDef(EditNumeroPedido.Text,0) = 0 then
            enuTipo := uEnumerador.tipoIncluir
         else
            enuTipo := uEnumerador.tipoAlterar ;
      end;

      //Gravo os Itens do Pedido
      for I := 0  to pred(ListViewItensPedido.Items.Count) do
      begin
          modelPedidosItens := TModelPedidosItens.Create ;
          with modelPedidosItens do
          begin
               intidpedidos_itens       := StrToIntDef(ListViewItensPedido.Items[I].Caption,0)        ;
               intidpedidos             := StrToIntDef(EditNumeroPedido.Text,0)  ;
               intidprodutos            := StrToIntDef(ListViewItensPedido.Items[I].SubItems[0],0)    ;
               curite_quantidade        := StrToFloatDef(ListViewItensPedido.Items[I].SubItems[2] ,0) ;
               curite_valorunitario     := StrToFloatDef(ListViewItensPedido.Items[I].SubItems[3] ,0) ;
               curite_valortotal        := StrToFloatDef(ListViewItensPedido.Items[I].SubItems[4] ,0) ;
               if StrToIntDef(ListViewItensPedido.Items[I].Caption,0) = 0 then
                 enuTipo  := uEnumerador.tipoIncluir
               else
                 enuTipo := uEnumerador.tipoAlterar ;
          end;
          //adiciono a lista
          controllerPedidos.ModelPedidos.listaitenspedido.Add(modelPedidosItens)  ;
      end;
      //Gravo os Itens do Pedido Deletados
      for I := 0  to pred(ListItensPedidosDeletados.Items.Count) do
      begin
          modelPedidosItens := TModelPedidosItens.Create ;
          with modelPedidosItens do
          begin
               intidpedidos_itens       := StrToIntDef(ListItensPedidosDeletados.Items[I].Caption,0)        ;
               enuTipo                  := uEnumerador.tipoExcluir ;
          end;
          //adiciono a lista
          controllerPedidos.ModelPedidos.listaitenspedido.Add(modelPedidosItens)  ;
      end;

      if controllerPedidos.persistir then
      begin
         ShowMessage('Registro Incluido....') ;
         ListViewItensPedido.Items.Clear ;
         EditNumeroPedido.Text := '0'      ;
         limpaEditVenda  ;
         limpaEditPedido ;
         EditCodCliente.SetFocus;
      end
      else
      begin
         ShowMessage('Erro n�o especificado....') ;
      end;
   finally
      FreeAndNil(controllerPedidos) ;
   end;

end;

procedure TFormPedidosdevendas.ButtonIncluirProdutoClick(Sender: TObject);
var
  Item     : TListItem  ;
  idList   : Integer    ;
begin
   idList := EditCodigoProduto.Tag ;
   //Vou garantir a formata��o dos Edits
   EditQuantidade.Text    := FloatToStrF( StrToFloatDef(EditQuantidade.Text,0)    , ffNumber,15,2)  ;
   EditValorUnitario.Text := FloatToStrF( StrToFloatDef(EditValorUnitario.Text,0) , ffNumber,15,2)  ;
   calculaValorTotalProduto ;

   if EditCodigoProduto.Text = EmptyStr then
   begin
     EditCodigoProduto.SetFocus ;
     exit ;
   end;

   if StrToCurr(EditValorTotal.Text) <= 0 then
   begin
     EditQuantidade.SetFocus ;
     exit ;
   end;

   if idList = 0 then
   begin
       // Incluindo os produtos noo List
       Item := ListViewItensPedido.Items.Add    ;
       Item.Caption := '0' ;
       Item.SubItems.Add(EditCodigoProduto.Text);
       Item.SubItems.Add(EditNomeProduto.Text)  ;
       Item.SubItems.Add(EditQuantidade.Text)   ;
       Item.SubItems.Add(EditValorUnitario.Text);
       Item.SubItems.Add(EditValorTotal.Text)   ;
   end
   else
   begin
       // Altera��o os produtos noo List
      ListViewItensPedido.Items[idList-1].SubItems[0] :=  EditCodigoProduto.Text ;
      ListViewItensPedido.Items[idList-1].SubItems[1] :=  EditNomeProduto.Text   ;
      ListViewItensPedido.Items[idList-1].SubItems[2] :=  EditQuantidade.Text    ;
      ListViewItensPedido.Items[idList-1].SubItems[3] :=  EditValorUnitario.Text ;
      ListViewItensPedido.Items[idList-1].SubItems[4] :=  EditValorTotal.Text    ;
   end;

   //Soma Valor total do Pedido


   limpaEditVenda ;
   EditCodigoProduto.SetFocus ;
end;

procedure TFormPedidosdevendas.calculaValorTotalProduto;
begin
   EditValorTotal.Text    := FloatToStrF( StrToFloatDef(EditQuantidade.Text,0) * StrToFloatDef(EditValorUnitario.Text,0) , ffNumber,15,2)  ;
end;

procedure TFormPedidosdevendas.EditCodClienteChange(Sender: TObject);
begin
  if (EditCodCliente.Text = EmptyStr) then
  begin
    EditNomeCliente.Clear ;
    ButtonAbrirPedido.Enabled    := True ;
    ButtonCancelarPedido.Enabled := True ;
    limpaEditVenda ;
  end
  else
  begin
    ButtonAbrirPedido.Enabled    := False ;
    ButtonCancelarPedido.Enabled := False ;
  end;
end;

procedure TFormPedidosdevendas.EditCodClienteExit(Sender: TObject);
begin
   if (EditCodCliente.Text = EmptyStr) then
   begin
      limpaEditPedido;
      exit ;
   end;
   if not(buscaCliente(StrToIntDef(EditCodCliente.Text,0))) then
   begin
      ShowMessage('Aten��o !!!'+#13+#13+'    Cliente n�o Localizado.') ;
      limpaEditPedido ;
      limpaEditVenda  ;
      EditCodCliente.SetFocus ;
   end
   else
   begin
      ButtonAbrirPedido.Enabled    := False ;
      ButtonCancelarPedido.Enabled := False ;
      EditCodigoProduto.SetFocus ;
   end;
end;

procedure TFormPedidosdevendas.EditCodClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
     EditCodigoProduto.SetFocus ;
  if not (key in ['1','2','3','4','5','6','7','8','9','0',#8]) then
     key := #0;
end;

procedure TFormPedidosdevendas.EditCodigoProdutoEnter(Sender: TObject);
begin
   EditCodigoProduto.ReadOnly := EditCodigoProduto.Tag <> 0 ;
end;

procedure TFormPedidosdevendas.EditCodigoProdutoExit(Sender: TObject);
begin
   if (EditCodigoProduto.Text = EmptyStr) then
   begin
      limpaEditVenda ;
      exit ;
   end;
   if not(buscaProduto(StrToIntDef(EditCodigoProduto.Text,0))) then
   begin
      ShowMessage('Aten��o !!!'+#13+#13+'    Produto n�o Localizado.') ;
      limpaEditVenda ;
      EditCodigoProduto.SetFocus ;
   end
   else
   begin
      calculaValorTotalProduto ;
      EditQuantidade.SetFocus  ;
   end;
end;

procedure TFormPedidosdevendas.EditCodigoProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
     EditQuantidade.SetFocus ;

  if EditCodigoProduto.Tag <> 0 then
     key :=#0;

  if not (key in ['1','2','3','4','5','6','7','8','9','0',#8]) then
     key :=#0;
end;

procedure TFormPedidosdevendas.EditQuantidadeChange(Sender: TObject);
begin
  calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditQuantidadeExit(Sender: TObject);
begin
   EditQuantidade.Text    := FloatToStrF( StrToFloatDef(EditQuantidade.Text,0)    , ffNumber,15,2)  ;
   calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditQuantidadeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditQuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
     EditValorUnitario.SetFocus ;
  if not (key in ['1','2','3','4','5','6','7','8','9','0',',',#8]) then
     key :=#0;
end;

procedure TFormPedidosdevendas.EditValorUnitarioChange(Sender: TObject);
begin
  calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditValorUnitarioExit(Sender: TObject);
begin
   EditValorUnitario.Text := FloatToStrF( StrToFloatDef(EditValorUnitario.Text,0) , ffNumber,15,2)  ;
   calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditValorUnitarioKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  calculaValorTotalProduto ;
end;

procedure TFormPedidosdevendas.EditValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
     ButtonIncluirProdutoClick(nil) ;
  if not (key in ['1','2','3','4','5','6','7','8','9','0',',',#8]) then
     key :=#0;
end;

procedure TFormPedidosdevendas.FormActivate(Sender: TObject);
begin
  ListItensPedidosDeletados.Items.Clear ;
  ListViewItensPedido.Items.Clear ;
end;

procedure TFormPedidosdevendas.limpaEditPedido;
begin
  EditCodCliente.Clear  ;
  EditNomeCliente.Clear ;
  ButtonAbrirPedido.Enabled    := True ;
  ButtonCancelarPedido.Enabled := True ;
  DatePedido.Text              := FormatDateTime('dd/MM/yy',date())
end;

procedure TFormPedidosdevendas.limpaEditVenda;
begin
   EditCodigoProduto.Clear  ;
   EditNomeProduto.Clear    ;
   EditCodigoProduto.Tag   := 0 ;
   EditQuantidade.Text    := '1'       ;
   EditValorUnitario.Text := '0,00'    ;
   EditValorTotal.Text    := 'R$ 0,00' ;
   PanelValorTotalPedido.Caption := FloatToStrF(valorTotalPedido,ffNumber,15,2) ;
end;

procedure TFormPedidosdevendas.ListViewItensPedidoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
   Item     : TListItem  ;
begin
  if Key = VK_DELETE then
  begin
      if not( ((ListViewItensPedido.Selected = nil)or(ListViewItensPedido.Items.Count = 0)) ) then
      begin
          if MessageBox(Handle,'   Confirmar a exclus�o do produto selecionado ?','Aten��o !!!',mb_YesNo+mb_IconInformation) = IDYES   then
          begin
             if ListViewItensPedido.Selected.Caption <> '0' then
             begin
                 Item := ListItensPedidosDeletados.Items.Add    ;
                 Item.Caption := ListViewItensPedido.Selected.Caption ;
             end;
             ListViewItensPedido.Selected.Delete ;
             PanelValorTotalPedido.Caption := FloatToStrF(valorTotalPedido,ffNumber,15,2) ;
          end;
      end;
      if ListViewItensPedido.Items.Count > 0 then
         ListViewItensPedido.SetFocus
      else
         EditCodigoProduto.SetFocus ;
  end;

  if key = 13 then
  begin
      //vou carregar os dados para altera��o
      EditCodigoProduto.Tag  :=  ListViewItensPedido.Selected.Index + 1   ;
      EditCodigoProduto.Text :=  ListViewItensPedido.Selected.SubItems[0] ;
      EditNomeProduto.Text   :=  ListViewItensPedido.Selected.SubItems[1] ;
      EditQuantidade.Text    :=  ListViewItensPedido.Selected.SubItems[2] ;
      EditValorUnitario.Text :=  ListViewItensPedido.Selected.SubItems[3] ;
      EditValorTotal.Text    :=  ListViewItensPedido.Selected.SubItems[4] ;
      EditQuantidade.SetFocus ;
  end;
end;

function TFormPedidosdevendas.valorTotalPedido: Double;
var
  I      : integer ;
  xvalor : Double ;
begin
  xvalor := 0 ;
  for I := 0  to pred(ListViewItensPedido.Items.Count) do
  begin
     xvalor := xvalor  +  StrToFloatDef(ListViewItensPedido.Items[I].SubItems[4] ,0) ;
  end;
  result := xvalor ;
end;

end.
