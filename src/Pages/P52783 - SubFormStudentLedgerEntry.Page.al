#pragma implicitwith disable
page 52783 "SubForm Student Ledger Entry"
{
    Caption = 'SubForm Student Ledger Entry';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Student Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity ID"; Rec."Entity ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entity Customer No."; Rec."Entity Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Percent %"; Rec."Percent %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Registed Invoice No."; Rec."Registed Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Registed; Rec.Registed)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount In Cre. Memo"; Rec."Amount In Cre. Memo")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document Situation"; Rec."Document Situation")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Name"; rStudent.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Registed then begin
            Message(Text001);
            exit(false);
        end;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Student No." <> '' then
            rStudent.Get(rec."Student No.")
    end;

    var
        cUserEducation: Codeunit "User Education";
        Text001: Label 'This record can not be deleted.';
        rStudent: Record Students;


    procedure GetRecord() InvoiceNo: Code[20]
    begin
        exit(Rec."Registed Invoice No.");
    end;

}

#pragma implicitwith restore

