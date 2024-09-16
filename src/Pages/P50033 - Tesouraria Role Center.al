page 50033 "Tesouraria Role Center"
{
    Caption = 'Tesouraria Role Center';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group(Tesouraria)
            {
                Caption = 'Tesouraria';

                action(Clientes)
                {
                    ApplicationArea = All;
                    Caption = 'Clientes';
                    RunObject = page "Customer List";
                }
                action("Lista Serviços")
                {
                    ApplicationArea = All;
                    RunObject = page "Service ET List";
                }
                action("Lista Plano de Serviço")
                {
                    ApplicationArea = All;
                    RunObject = page "Services Plan List";
                }
                action("Atribuir Serviços Ocasionais")
                {
                    ApplicationArea = All;
                    RunObject = page "Giving Services";
                }
                action("Processar Serviços")
                {
                    ApplicationArea = All;
                    RunObject = page "Processing Services";
                }
                action("Validação Pré-Faturação")
                {
                    ApplicationArea = All;
                    RunObject = page "Validação Pré-Faturação";
                }
                action("Fatura Venda")
                {
                    ApplicationArea = All;
                    RunObject = report "PTSS Sales - Invoice (PT)";
                }
                action("Nota Crédito Venda")
                {
                    ApplicationArea = All;
                    RunObject = report "PTSS Sales - Credit Memo (PT)";
                }
                action("Cliente - Recibo Pagamento")
                {
                    ApplicationArea = All;
                    RunObject = report "Customer - Payment Receipt";
                }
                action("Dívida pendente Cliente")
                {
                    ApplicationArea = All;
                    //RunObject=report missing
                }
                action("Mapa Faturação")
                {
                    ApplicationArea = All;
                    //RunObject=report missing 50035 Mapa Faturação
                }
                action("Serviços")
                {
                    ApplicationArea = All;
                    RunObject = page "Service List";
                }
                action("Gr. Desconto Cliente")
                {
                    ApplicationArea = All;
                    RunObject = page "Customer Disc. Groups";
                }
                action("Grupo Desconto Serviço")
                {
                    ApplicationArea = All;
                    RunObject = page "Service Discounts Group";
                }
                action("Empresas")
                {
                    ApplicationArea = All;
                    RunObject = page Companies;
                }
                action("Configuração Email")
                {
                    ApplicationArea = All;
                    //RunObject=page  SMTP Fields
                }
                action("Faturas Venda Registadas")
                {
                    ApplicationArea = All;
                    // RunObject=page missing
                }
                action("Faturas Venda")
                {
                    ApplicationArea = All;
                    RunObject = page "Sales Invoice";
                }
                action("Diários Cobranças")
                {
                    ApplicationArea = All;
                    //RunObject=page missing
                }
                action("Notas Crédito Venda")
                {
                    ApplicationArea = All;
                    //RunObject=page missing
                }
                action("Cobranças Débito Direto")
                {
                    ApplicationArea = All;
                    RunObject = page "Direct Debit Collections";
                }
                group("Actividades Periódicas")
                {
                    Caption = 'Actividades Periódicas';
                    action("Enviar Fatura Email")
                    {
                        ApplicationArea = All;
                        //RunObject = report EnviaEmailFaturaFardas;
                        //TODO: to uncomment
                    }
                    action("Enviar Nota Credito Email")
                    {
                        ApplicationArea = All;
                        //RunObject=report missing
                    }
                    action("Enviar Avisos Cobrança Email")
                    {
                        ApplicationArea = All;
                        //RunObject=report missing
                    }
                    action("Enviar Declaração IRS por Email")
                    {
                        ApplicationArea = All;
                        //RunObject=report missing
                    }

                }
                action("Alunos Serviços Fixos")
                {
                    ApplicationArea = All;
                    RunObject = report "Students Fixed Services";
                }
                action("Formas Pag Alunos - Clientes")
                {
                    ApplicationArea = All;
                    //RunObject=report missing
                }
            }
        }
    }
}