page 50034 "Warehouse Role Center"
{
    Caption = 'Warehouse Role Center';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {

            group(Encomendas)
            {
                Caption = 'Orders';

                action("Produtos")
                {
                    ApplicationArea = All;
                    RunObject = page "Item List";
                }
                action("Fornecedores")
                {
                    ApplicationArea = All;
                    RunObject = page "Vendor List";
                }
                action("Encomendas Compra")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase Order List";
                }
                action("Devoluções Compra")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase Return Order List";
                }
                action("Nota Crédito Compra")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase Credit Memo";
                }
                action("Clientes")
                {
                    ApplicationArea = All;
                    RunObject = page "Customer List";
                }
                action("Lista Vendas")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales List";
                }
                action("Encomendas Venda")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Order";
                    ;
                }
                action("Encomendas Venda Pendenetes")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Orders";
                }
                action("Devoluções Vendas")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Return Order";
                }
                action("Fatura Venda")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Invoice";
                }
                action("Nota Crédito Venda")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Credit Memo";
                }
                action("Detalhe Encomendas")
                {
                    ApplicationArea = All;
                    RunObject = page "Detalhe Encomendas";
                }
                action("Disponibilidade Produtos")
                {
                    ApplicationArea = All;
                    RunObject = page "Disponibilidades Produtos";
                }
                action("Produtos por Localização")
                {
                    ApplicationArea = All;
                    RunObject = page "Items by Location";
                }
                action("G. Remessa Venda")
                {
                    ApplicationArea = All;
                    RunObject = report "Sales - Shipment";
                }
                action("Fatura Venda Report")
                {
                    ApplicationArea = All;
                    RunObject = report "PTSS Sales - Invoice (PT)";
                }
                action("Nota Crédito Venda Report")
                {
                    ApplicationArea = All;
                    RunObject = report "PTSS Sales - Credit Memo (PT)";
                }
                action("Recepção Devolução Vendas")
                {
                    ApplicationArea = All;
                    RunObject = report "Sales - Return Receipt";
                }
                action("Guia Remessa Compra")
                {
                    ApplicationArea = All;
                    //RunObject=report missing
                }
                action("Fatura Compra")
                {
                    ApplicationArea = All;
                    RunObject = report "PTSS Purchase - Invoice (PT)";
                }
                action("Nota Crédito Compra Report")
                {
                    ApplicationArea = All;
                    RunObject = report "Purchase - Credit Memo";
                }
                action("Envio Devolução Compra")
                {
                    ApplicationArea = All;
                    RunObject = report "Purchase - Return Shipment";
                }
                action("Devolução")
                {
                    ApplicationArea = All;
                    RunObject = report "Return Order";
                }
                action("Confirmação Devolução")
                {
                    ApplicationArea = All;
                    RunObject = report "Return Order Confirmation";
                }
            }
            group(Inventário)
            {
                Caption = 'Inventory';
                action("Diários Produto")
                {
                    ApplicationArea = All;
                    RunObject = page "Item Journal";
                }
                action("Ordem Transferência")
                {
                    ApplicationArea = All;
                    RunObject = page "Transfer Order";
                }
                action("Diário Inventário Físico")
                {
                    ApplicationArea = All;
                    RunObject = page "Phys. Inventory Journal";
                }
                action("Ajustar Custo - Movs Produto")
                {
                    ApplicationArea = All;
                    RunObject = report "Adjust Cost - Item Entries";
                }

            }
            group(Histórico)
            {
                Caption = 'History';
                group("Docs. Registados")
                {
                    Caption = 'Posted Docments';
                    action("Recepções Registadas")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Whse. Receipt";
                    }
                    action("Guias de Remessa Compra Registadas")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Purchase Receipts";
                    }
                    action("Recepção Devolução Registada")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Return Receipt";
                    }
                    action("Facts. Compra Registadas")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Purchase Invoices";
                    }
                    action("Arquivo Enc. Venda")
                    {
                        ApplicationArea = All;
                        RunObject = page "Sales Order Archive";
                    }
                    action("Envios Registados")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Whse. Shipment";
                    }
                    action("Guias Remessa Vendas Registadas")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Sales Shipments";
                    }
                    action("Envios Devolução Compra Regs.")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Return Shipment";
                    }
                    action("Fatura Venda Registada")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Sales Invoice";
                    }
                    action("Nota Crédito Venda Registada")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Sales Credit Memo";
                    }
                    action("Transf. Armazém - Notas Crédito")
                    {
                        ApplicationArea = All;
                        //RunObject=report 
                        //missing report 50059
                    }
                    action("Fatura Venda Report 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales - Invoice ';
                        RunObject = report "PTSS Sales - Invoice (PT)";
                    }
                    action("Nota Crédito Venda Report 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales - Credit Memo ';
                        RunObject = report "PTSS Sales - Credit Memo (PT)";
                    }
                }
                group("Regs. Movs.")
                {
                    Caption = 'Registers';
                    action("Regs. Movs. ")
                    {
                        ApplicationArea = All;
                        RunObject = page "Warehouse Registers";
                    }
                    action("Regs. Movs. Produto")
                    {
                        ApplicationArea = All;
                        RunObject = page "Item Registers";
                    }
                }
            }
            group(Configuração)
            {
                Caption = 'Setup';
                action("Configuração Inventário")
                {
                    ApplicationArea = All;
                    RunObject = page "Inventory Setup";
                }
                action("Localizações")
                {
                    ApplicationArea = All;
                    RunObject = page "Location Card";
                }
                action("Conf. Utilizador")
                {
                    ApplicationArea = All;
                    RunObject = page "User Setup";
                }
                action("Config Email")
                {
                    ApplicationArea = All;
                    //RunObject=page missing 50005 SMTP Fields
                }
            }
            group(Mapas)
            {
                Caption = 'Reports';
                action("Valoriz. Inventário")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory Valuation";
                }
                action("Inventário - Lista")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory - List";
                }
                action("Registo Movs. Produto - Valor")
                {
                    ApplicationArea = All;
                    RunObject = report "Item Register - Value";
                }
                action("Estado")
                {
                    ApplicationArea = All;
                    RunObject = report Status;
                }
                action("Cliente - Total Encomendas")
                {
                    ApplicationArea = All;
                    RunObject = report "Customer - Order Summary";
                }
                action("Cliente - Detalhe Encomenda - Park")
                {
                    ApplicationArea = All;
                    RunObject = report "Customer - Order Detail";
                }
                action("Vendas Cliente/Produto")
                {
                    ApplicationArea = All;
                    RunObject = report "Customer/Item Sales";
                }
                action("Disponibilidade Inventário")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory Availability";
                }
                action("Prods. - Encomenda por Servir")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory - Sales Back Orders";
                }
                action("Produtos - Encomendas por Faturar")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory - Sales Back Orders";
                }
                action("Vendas Cliente Inventário")
                {
                    ApplicationArea = All;
                    RunObject = report "Inventory - Customer Sales";
                }
                action("Exortar Ficheiro Inventário à AT")
                {
                    ApplicationArea = All;
                    //RunObject=page 50019 Tax Authority Inventory File;
                }

            }
            group("E-mails")
            {
                Caption = 'E-mails';
                action("Enviar Fatura Fardas Email")
                {
                    ApplicationArea = All;
                    RunObject = report EnviaEmailFaturaFardas;
                }
                action("Enviar Nota Crédito Fardas EMail")
                {
                    ApplicationArea = All;
                    //RunObject=report missing 50026 Enviar Nota Crédito Email
                }
            }
            group("Encomendas Online")
            {
                Caption = 'Encomendas Online';
                action("Lista de Encomendas")
                {
                    ApplicationArea = All;
                    RunObject = page "Encomendas Lista";
                }
                action("Lista Devoluções")
                {
                    ApplicationArea = All;
                    RunObject = page "Devolucoes Lista";
                }
                action("Trnsf. Armazém por Lotes")
                {
                    ApplicationArea = All;
                    //RunObject=report 50058 Transf. Armazém por Lotes
                }
                action("Reg. Lotes Encomendas Venda")
                {
                    ApplicationArea = All;
                    RunObject = report "Batch Post Sales Orders";
                }
            }
        }
    }
}
//Import-NAVServerLicense -ServerInstance BC200 -LicenseFile "G:\Squad\License\5305563 SQUAD BC20 30032023\5305563.bclicense"