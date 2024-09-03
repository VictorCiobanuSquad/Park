page 50008 "Validação Pré-Faturação"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Student Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = All;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                }
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = All;
                }
                field(txtNomeAluno; txtNomeAluno)
                {
                    ApplicationArea = All;
                    Caption = 'Student Name';
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Entity Customer No."; Rec."Entity Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Percent %"; Rec."Percent %")
                {
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Registed Invoice No."; Rec."Registed Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Registered; Rec.Registed)
                {
                    Caption = 'Registed';
                    ApplicationArea = All;
                }
                field(Processed; Rec.Processed)
                {
                    Caption = 'Processed';
                    ApplicationArea = All;
                }
                field("JDE Payer No."; rCustomer."JDE Payer No.")
                {
                    Caption = 'JDE Payer No.';
                    ApplicationArea = All;
                }
                field("JDE Pupil No."; rCustomer."JDE Pupil No.")
                {
                    Caption = 'JDE Pupil No.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETCURRENTKEY("Service Code", "Student No.");
        Rec.SETFILTER("Posting Date", '%1..', DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)));
    end;

    trigger OnAfterGetRecord()
    begin
        rStudents.RESET;
        IF rStudents.GET(Rec."Student No.") THEN
            txtNomeAluno := rStudents."Full Name";
        if rCustomer.get(Rec."Student Customer No.") then;
    end;

    var
        rStudents: Record Students;
        txtNomeAluno: Text[250];
        rCustomer: Record Customer;
}