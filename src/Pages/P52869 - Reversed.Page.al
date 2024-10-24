#pragma implicitwith disable
page 52869 Reversed
{
    Caption = 'Reversed';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(content)
        {
            field(vKinship; vKinship)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Type';
                OptionCaption = ' ,Student,User Family';

                trigger OnValidate()
                begin
                    varNo := '';
                    vKinshipOnAfterValidate;
                end;
            }
            field(varNo; varNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    if vKinship = vKinship::Student then begin
                        rStudents.Reset;
                        if rStudents.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Students List", rStudents) = ACTION::LookupOK then
                                varNo := rStudents."No.";
                        end;
                    end;

                    if vKinship = vKinship::"User Family" then begin
                        rUsersFamily.Reset;
                        if rUsersFamily.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Users Family List", rUsersFamily) = ACTION::LookupOK then
                                varNo := rUsersFamily."No.";
                        end;
                    end;

                    GetSubForm;
                end;

                trigger OnValidate()
                begin
                    varNoOnAfterValidate;
                end;
            }
            field(varPaymentDocNo; varPaymentDocNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Document No.';

                trigger OnValidate()
                begin
                    varPaymentDocNoOnAfterValidate;
                end;
            }
            repeater(Control1102065007)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("'""Bill No.""'"; '"Bill No."')
                {
                    ApplicationArea = Basic, Suite;
                }
                field("'""Document Situation""'"; '"Document Situation"')
                {
                    ApplicationArea = Basic, Suite;
                }
                field("'""Document Status""'"; '"Document Status"')
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Original Amt. (LCY)"; Rec."Original Amt. (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pmt. Disc. Tolerance Date"; Rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Original Pmt. Disc. Possible"; Rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Remaining Pmt. Disc. Possible"; Rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Max. Payment Tolerance"; Rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Pmt. Disc. Given (LCY)"; Rec."Pmt. Disc. Given (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lDocNo: Code[20];
                    lPostingDate: Date;
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            group("Funct&ions")
            {
                Caption = 'Funct&ions';
                action("&Reverse Register")
                {
                    ApplicationArea = All;
                    Caption = '&Reverse Register';
                    Image = ReverseRegister;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        if Confirm(Text002, true) then
                            ShowReverse;
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        CODEUNIT.Run(CODEUNIT::"Cust. Entry-Edit", Rec);
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        FilterSubform;
    end;

    var
        vKinship: Option " ",Student,"User Family";
        varNo: Code[20];
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        rStudentLedgerEntry2: Record "Student Ledger Entry";
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        rPaymentMethod: Record "Payment Method";
        Text001: Label 'Amount';
        rUserSetup: Record "User Setup";
        cPostServicesET: Codeunit "Post Services ET";
        Text002: Label 'Do tou wish to proceed reversing the transaction?';
        Text003: Label 'Line is blocked by user %1.';
        rStudentLedgerEntry: Record "Student Ledger Entry";
        varPaymentDocNo: Code[20];


    procedure FilterSubform()
    begin
        Rec.SetRange("Entry No.", 0);
    end;


    procedure GetSubForm()
    var
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        rUsersFamilyStudents: Record "Users Family / Students";
        StudentFilter: Text[1024];
    begin
        if varPaymentDocNo <> '' then begin
            Rec.Reset;
            exit;
        end;

        if varNo = '' then begin
            Rec.SetFilter("Entry No.", '-10');
            exit;
        end;

        rStudentLedgerEntry.Reset;
        if vKinship = vKinship::Student then begin
            rStudents.Get(varNo);
            Rec.SetRange("Customer No.", rStudents."Customer No.");
            Rec.SetRange("Entry No.");
            rUsersFamilyStudents.Reset;
            rUsersFamilyStudents.SetFilter(Kinship, '<>%1', rUsersFamilyStudents.Kinship::Himself);
            rUsersFamilyStudents.SetRange("Education Head", true);
            rUsersFamilyStudents.SetRange("No.", varNo);
            if rUsersFamilyStudents.Find('-') then begin
                StudentFilter := rStudents."Customer No." + '|';
                repeat
                    rStudents.Get(rUsersFamilyStudents."Student Code No.");
                    StudentFilter := StudentFilter + rStudents."Customer No." + '|';
                until rUsersFamilyStudents.Next = 0;
                StudentFilter := DelStr(StudentFilter, StrLen(StudentFilter), 1);
                Rec.SetFilter("Sell-to Customer No.", StudentFilter);
            end;
        end;

        if vKinship = vKinship::"User Family" then begin
            rUsersFamily.Get(varNo);
            Rec.SetRange("Entry No.");
            Rec.SetRange("Customer No.", rUsersFamily."Customer No.");
        end;

        CurrPage.Update(false);
    end;


    procedure ShowReverse()
    var
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
    begin

        Clear(ReversalEntry);
        if Rec.Reversed then
            ReversalEntry.AlreadyReversedEntry(Rec.TableCaption, Rec."Entry No.");
        if Rec."Journal Batch Name" = '' then
            ReversalEntry.TestFieldError;
        Rec.TestField("Transaction No.");
        //ReversalEntry.ReverseTransactionNEW("Transaction No.");
    end;

    local procedure vKinshipOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure varNoOnAfterValidate()
    begin
        Rec.Reset;
        GetSubForm;
    end;

    local procedure varPaymentDocNoOnAfterValidate()
    begin
        if varPaymentDocNo <> '' then begin

            vKinship := 0;
            varNo := '';
            Rec.Reset;
            Rec.SetRange("Document Type", Rec."Document Type"::Payment);
            Rec.SetRange("Document No.", varPaymentDocNo);
            CurrPage.Update(false);
        end;
    end;
}

#pragma implicitwith restore

