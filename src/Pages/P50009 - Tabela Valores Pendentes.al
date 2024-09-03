#pragma implicitwith disable
page 50009 "Tabela Valores Pendentes"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = SORTING("Customer No.", "Posting Date", "Currency Code");

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(txtNomeAluno; txtNomeAluno)
                {
                    ApplicationArea = All;
                    Caption = 'Student Name';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Open, TRUE);
        Rec.SETFILTER("Document Type", '%1|%2', Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo");
    end;

    trigger OnAfterGetRecord()
    begin
        rCustomer.RESET;
        IF rCustomer.GET(Rec."Customer No.") THEN
            txtNomeAluno := rCustomer.Name;
    end;

    var
        rCustomer: Record Customer;
        txtNomeAluno: Text[250];
}
#pragma implicitwith restore
