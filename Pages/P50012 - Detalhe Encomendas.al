page 50012 "Detalhe Encomendas"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Line";
    SourceTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(CodAluno; CodAluno)
                {
                    ApplicationArea = All;
                    Caption = 'Student No';
                }
                field(NomeAluno; NomeAluno)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(Turma; Turma)
                {
                    ApplicationArea = All;
                    Caption = 'Turma';
                }
                field(AnoEsco; AnoEsco)
                {
                    ApplicationArea = All;
                    Caption = 'Ano Escolaridade';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rCustomer.RESET;
        IF rCustomer.GET(Rec."Sell-to Customer No.") THEN
            CodAluno := rCustomer."Student No.";


        rSalesHeader.RESET;
        rSalesHeader.SETRANGE(rSalesHeader."Document Type", rSalesHeader."Document Type"::Order);
        rSalesHeader.SETRANGE(rSalesHeader."No.", Rec."Document No.");
        IF rSalesHeader.FINDFIRST THEN BEGIN
            NomeAluno := rSalesHeader."Sell-to Customer Name";
            Turma := rSalesHeader.Turma;
            AnoEsco := rSalesHeader."Ano Escolaridade";
        END;
    end;

    var
        rSalesHeader: Record "Sales Header";
        rCustomer: Record Customer;
        CodAluno: Code[20];
        NomeAluno: Text[200];
        Turma: Code[20];
        AnoEsco: Code[10];
}