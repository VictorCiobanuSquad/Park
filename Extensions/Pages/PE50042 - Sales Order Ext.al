pageextension 50042 "Sales Order Ext." extends "Sales Order"
{
    /*
    //IT001 - Parque - 2016.10.07 - registar automaticamente a transferencia de armazém
    //IT002 - Parque - 2016.10.10 - registar automaticamente a transferencia de armazém por lotes
    */
    layout
    {
        addafter("Sell-to County")
        {
            field(Turma; Rec.Turma)
            {
                ApplicationArea = All;
            }
            field("Ano Escolaridade"; Rec."Ano Escolaridade")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Portal Created by"; Rec."Portal Created by")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Create &Warehouse Shipment")
        {
            action("Transfer from Warehouse")
            {
                Caption = 'Transferir de Armazém';

                trigger OnAction()
                var
                    TransAramazem: Codeunit "Transferencias Armazens";
                begin
                    //IT001 - Parque - 2016.10.07 - registar automaticamente a transferencia de armazém
                    CLEAR(TransAramazem);
                    IF (Rec."Document Type" = Rec."Document Type"::Order) THEN BEGIN
                        TransAramazem.CriarOrdemTransf(Rec);
                    END;
                    //IT001 - Parque - 2016.10.07 - en
                end;
            }
            action("Transf. from Warehouse By Lot")
            {
                Caption = 'Transf. from Warehouse By Lot';

                trigger OnAction()
                begin
                    //IT002 - Parque - 2016.10.10 - registar automaticamente a transferencia de armazém

                    REPORT.RUNMODAL(50058);
                    //IT002 - Parque - 2016.10.10 - en
                end;
            }
        }
    }
}