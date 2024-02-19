pageextension 50134 "Posted Sales Credit Memo Ext." extends "Posted Sales Credit Memo"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    
    //IT001 - Parque - 2016.10.12 - Nova opçao nas Funções para poder fazer uma Transf. Armazém para esta nota credito
    */
    layout
    {
        addafter("Sell-to County")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
        }
        addafter("Bill-to County")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("Create Warehouse Transfer")
            {
                Caption = 'Create Warehouse Transfer';

                trigger OnAction()
                var
                    l_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    //IT001 - Parque - 2016.10.12 - Nova opçao nas Funções para poder fazer uma Transf. Armazém para esta nota credito
                    l_SalesCrMemoHeader.RESET;
                    l_SalesCrMemoHeader.SETRANGE(l_SalesCrMemoHeader."No.", Rec."No.");
                    IF l_SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50059, TRUE, FALSE, l_SalesCrMemoHeader);
                end;
            }
        }
    }
}