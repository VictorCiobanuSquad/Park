#pragma implicitwith disable
page 52881 "Subform Correct Invoices"
{
    Caption = 'Subform Payment';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Student Ledger Entry";
    SourceTableView = SORTING("Registed Invoice No.")
                      ORDER(Ascending)
                      WHERE("Remaining Amount" = FILTER(0));

    layout
    {
        area(content)
        {
            repeater(TableBoxPayment)
            {
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Entity ID"; Rec."Entity ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Entity Customer No."; Rec."Entity Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Registed Invoice No."; Rec."Registed Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Payment; Rec.Payment)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec."Credit Note" := false;
                        PaymentOnAfterValidate;
                    end;
                }
                field("Debit Card Payment"; Rec."Debit Card Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Debit Card PaymentEditable";
                    Visible = DebitCardPaymentVisible;

                    trigger OnValidate()
                    var
                        Text001: Label 'Not Allowed';
                    begin
                    end;
                }
                field("Check Payment"; Rec."Check Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Check PaymentEditable";
                    Visible = CheckPaymentVisible;
                }
                field("Credit Card Payment"; Rec."Credit Card Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Credit Card PaymentEditable";
                    Visible = CreditCardPaymentVisible;
                }
                field("Cash Payment"; Rec."Cash Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Cash PaymentEditable";
                    Visible = CashPaymentVisible;
                }
                field("Transfer Payment"; Rec."Transfer Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Transfer PaymentEditable";
                    Visible = TransferPaymentVisible;
                }
                field("Credit Note"; Rec."Credit Note")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Credit NoteVisible";

                    trigger OnValidate()
                    begin
                        Rec.Payment := false;
                        CreditNoteOnAfterValidate;
                    end;
                }
                field("Amout Credit Note"; Rec."Amout Credit Note")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Amout Credit NoteEditable";
                    Visible = "Amout Credit NoteVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        "Amout Credit NoteEditable" := true;
        "Transfer PaymentEditable" := true;
        "Cash PaymentEditable" := true;
        "Credit Card PaymentEditable" := true;
        "Check PaymentEditable" := true;
        "Debit Card PaymentEditable" := true;
        "Amout Credit NoteVisible" := true;
        "Credit NoteVisible" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        if rUserSetup.Get(UserId) then;
        Rec.SetRange("Entity ID", '');
    end;

    var
        rUserSetup: Record "User Setup";
        [InDataSet]
        "Credit NoteVisible": Boolean;
        [InDataSet]
        "Amout Credit NoteVisible": Boolean;
        [InDataSet]
        "Debit Card PaymentEditable": Boolean;
        [InDataSet]
        "Check PaymentEditable": Boolean;
        [InDataSet]
        "Credit Card PaymentEditable": Boolean;
        [InDataSet]
        "Cash PaymentEditable": Boolean;
        [InDataSet]
        "Transfer PaymentEditable": Boolean;
        [InDataSet]
        "Amout Credit NoteEditable": Boolean;
        DebitCardPaymentVisible: Boolean;
        CheckPaymentVisible: Boolean;
        CreditCardPaymentVisible: Boolean;
        CashPaymentVisible: Boolean;
        TransferPaymentVisible: Boolean;

    //[Scope('OnPrem')]
    procedure EditablePayment()
    begin
        if (Rec.Payment = false) and (Rec."Credit Note" = false) then begin
            "Debit Card PaymentEditable" := false;
            "Check PaymentEditable" := false;
            "Credit Card PaymentEditable" := false;
            "Cash PaymentEditable" := false;
            "Transfer PaymentEditable" := false;
            "Amout Credit NoteEditable" := false;
        end;


        if (Rec.Payment = true) and (Rec."Credit Note" = false) then begin
            "Debit Card PaymentEditable" := true;
            "Check PaymentEditable" := true;
            "Credit Card PaymentEditable" := true;
            "Cash PaymentEditable" := true;
            "Transfer PaymentEditable" := true;
            "Amout Credit NoteEditable" := false;
        end;

        if (Rec.Payment = false) and (Rec."Credit Note" = true) then begin
            "Debit Card PaymentEditable" := false;
            "Check PaymentEditable" := false;
            "Credit Card PaymentEditable" := false;
            "Cash PaymentEditable" := false;
            "Transfer PaymentEditable" := false;
            "Amout Credit NoteEditable" := true;
        end;

        /*DebitCardPaymentVisible:=rUserSetup."Debit Card Payment" <> '';
        CheckPaymentVisible:=rUserSetup."Check Payment" <> '';
        CreditCardPaymentVisible:=rUserSetup."Credit Card Payment" <> '';
        CashPaymentVisible:=rUserSetup."Cash Payment" <> '';
        TransferPaymentVisible:=rUserSetup."Transfer Payment" <> '';
        
        {
        CurrPage."Debit Card Payment".VISIBLE(rUserSetup."Debit Card Payment" <> '');
        CurrPage."Check Payment".VISIBLE(rUserSetup."Check Payment" <> '');
        CurrPage."Credit Card Payment".VISIBLE(rUserSetup."Credit Card Payment" <> '');
        CurrPage."Cash Payment".VISIBLE(rUserSetup."Cash Payment" <> '');
        CurrPage."Transfer Payment".VISIBLE(rUserSetup."Transfer Payment" <> '');
        }
        
        "Credit NoteVisible" := rUserSetup."Allow Credit Memo";
        "Amout Credit NoteVisible" := rUserSetup."Allow Credit Memo";*/

    end;

    //[Scope('OnPrem')]
    procedure FormUpdate()
    begin
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetDocAndDate(var PostingDate: Date; var DocNo: Code[20])
    begin
        PostingDate := Rec."Posting Date";
        DocNo := Rec."Registed Invoice No.";
    end;

    local procedure PaymentOnAfterValidate()
    begin
        EditablePayment;
    end;

    local procedure CreditNoteOnAfterValidate()
    begin
        EditablePayment;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        EditablePayment;
    end;
}

#pragma implicitwith restore

