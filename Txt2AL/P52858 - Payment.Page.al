#pragma implicitwith disable
page 52858 Payment
{
    //  //Para Portugal o campo correct invoices deve estar invisivel

    Caption = 'Payment';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Student Ledger Entry";
    SourceTableView = SORTING("Student No.", Class, "School Year", "Schooling Year", "Line No.");

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
                    if varInvoiceDocNo <> '' then
                        Error(Text004);

                    //varNo := '';
                end;
            }
            field(varNo; varNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Rec.Reset;
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
                    Clear(remaningAmount);
                    GetSubForm;
                end;

                trigger OnValidate()
                begin
                    if varInvoiceDocNo <> '' then
                        Error(Text004);
                    varNoOnAfterValidate;
                end;
            }
            field(varInvoiceDocNo; varInvoiceDocNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Document No.';

                trigger OnValidate()
                begin
                    varInvoiceDocNoOnAfterValidate;
                end;
            }
            field(vCorrectInvoices; vCorrectInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Correct Invoices';
                Visible = false;

                trigger OnValidate()
                begin
                    vCorrectInvoicesOnPush;
                end;
            }
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
                    Visible = "Remaining AmountVisible";
                }
                field("Amount In Cre. Memo"; Rec."Amount In Cre. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = "Amount In Cre. MemoVisible";
                }
                field(Payment; Rec.Payment)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = PaymentEditable;

                    trigger OnValidate()
                    begin
                        PaymentOnPush;
                        Rec."Credit Note" := false;
                        Field := Rec.FieldNo(Payment);
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
            field(TotalRemaningAmount; Rec."Total Remaning Amount")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remaining Amount';
                Editable = false;
                Visible = TotalRemaningAmountVisible;
            }
            field(TotalCompanyRemaningAmount; Rec."Total Company Remaning Amount")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total Company Remaining Amount';
                Editable = false;
                Visible = TotalCompanyRemaningAmountVisi;
            }
            field(TotalAmountforCreditMemo; Rec."Total Amount for Credit Memo")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = TotalAmountforCreditMemoVisibl;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Apply All Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Apply All Entries';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lDocNo: Code[20];
                    lPostingDate: Date;
                begin
                    Rec.ApplyAllEntries(Field);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
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
                    Navigate.SetDoc(Rec."Posting Date", Rec."Registed Invoice No.");
                    Navigate.Run;
                end;
            }
            group("&Posting")
            {
                Caption = '&Posting';
                Image = Register;
                action("&Post")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Clear(cPostServicesET);
                        if not vCorrectInvoices then begin
                            if Confirm(Text002, true) then
                                // Last Parameter is false - > post + Print = false // LFM 23.10.2009
                                cPostServicesET.PaymentServices(varNo, UserId, false);
                        end else begin
                            if Confirm(Text005, true) then
                                // Last Parameter is false - > post + Print = false // LFM 23.10.2009
                                cPostServicesET.PaymentServices(varNo, UserId, false);
                        end;
                        CurrPage.Update(true);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Clear(cPostServicesET);
                        if not vCorrectInvoices then begin
                            if Confirm(Text002, true) then
                                // Last Parameter is false - > post + Print = false // LFM 23.10.2009
                                cPostServicesET.PaymentServices(varNo, UserId, true);
                        end else begin
                            if Confirm(Text005, true) then
                                // Last Parameter is false - > post + Print = false // LFM 23.10.2009
                                cPostServicesET.PaymentServices(varNo, UserId, true);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditablePayment;
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
        PaymentEditable := true;
        "Amount In Cre. MemoVisible" := true;
        "Remaining AmountVisible" := true;
        TotalAmountforCreditMemoVisibl := true;
        TotalCompanyRemaningAmountVisi := true;
        TotalRemaningAmountVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        if rUserSetup.Get(UserId) then;

        if vKinship = vKinship::" " then
            Rec.SetRange("Entry No.", 0);

        TotalRemaningAmountVisible := true;
        TotalCompanyRemaningAmountVisi := false;
        TotalAmountforCreditMemoVisibl := false;
        "Remaining AmountVisible" := true;
        "Amount In Cre. MemoVisible" := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        /* C+ 2011.09.06 - não precisa de limpar do ecran qd se sai, basta limpara da tabela
       SETRANGE("User Session",USERID);
       IF FINDSET THEN BEGIN
          "User Session" := '';
          Payment := FALSE;
          "Debit Card Payment" := 0;
          "Check Payment" := 0;
          "Credit Card Payment":= 0;
          "Cash Payment":= 0;
          "Transfer Payment"  := 0;
          "Credit Note" := FALSE;
          "Amout Credit Note" := 0;
          MODIFY;
         UNTIL NEXT = 0;
       END;
        */
        recStudLedgEntry.Reset;
        recStudLedgEntry.SetRange("User Session", UserId);//C+ 2011.09.06 Só pode limpar os do utilizador corrente
        if recStudLedgEntry.Find('-') then begin
            repeat
                if (recStudLedgEntry.Payment) or (recStudLedgEntry."Credit Note") then begin
                    recStudLedgEntry."User Session" := '';
                    recStudLedgEntry.Payment := false;
                    recStudLedgEntry."Debit Card Payment" := 0;
                    recStudLedgEntry."Check Payment" := 0;
                    recStudLedgEntry."Credit Card Payment" := 0;
                    recStudLedgEntry."Cash Payment" := 0;
                    recStudLedgEntry."Transfer Payment" := 0;
                    recStudLedgEntry."Credit Note" := false;
                    recStudLedgEntry."Amout Credit Note" := 0;
                    recStudLedgEntry.Modify;
                end;
            until recStudLedgEntry.Next = 0;
        end;

    end;

    var
        vKinship: Option " ",Student,"User Family";
        varNo: Code[20];
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        rUsersFamilyStudents: Record "Users Family / Students";
        rPaymentMethod: Record "Payment Method";
        Text001: Label 'Amount';
        cPostServicesET: Codeunit "Post Services ET";
        Text002: Label 'Do you wish to proceed posting payments?';
        Text003: Label 'Line is blocked by user %1.';
        rStudentLedgerEntry: Record "Student Ledger Entry";
        rStudentLedgerEntry2: Record "Student Ledger Entry";
        Text004: Label 'You cannot change this filter.';
        rStudentLedgerEntry3: Record "Student Ledger Entry";
        rUserSetup: Record "User Setup";
        Text005: Label 'Do you wish to proceed posting corrective Invoices?';
        Text006: Label 'You can not make payments through the Educational Module, you must do from the Module of Cartera.';
        rDetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
        remaningAmount: Decimal;
        vCorrectInvoices: Boolean;
        varInvoiceDocNo: Code[20];
        "Field": Integer;
        recStudLedgEntry: Record "Student Ledger Entry";
        [InDataSet]
        TotalRemaningAmountVisible: Boolean;
        [InDataSet]
        TotalCompanyRemaningAmountVisi: Boolean;
        [InDataSet]
        TotalAmountforCreditMemoVisibl: Boolean;
        [InDataSet]
        "Remaining AmountVisible": Boolean;
        [InDataSet]
        "Amount In Cre. MemoVisible": Boolean;
        [InDataSet]
        PaymentEditable: Boolean;
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
    procedure GetSubForm()
    var
        lStudentLedgerEntry: Record "Student Ledger Entry";
        StudentFilter: Text[1024];
    begin
        if varNo = '' then begin
            Rec.SetFilter("Entry No.", '-10');
        end;
        Rec.SetRange(Registed, true);

        if vKinship = vKinship::Student then begin
            rStudents.Get(varNo);
            Rec.SetRange("Student Customer No.", rStudents."Customer No.");

            rUsersFamilyStudents.Reset;
            rUsersFamilyStudents.SetFilter(Kinship, '<>%1', rUsersFamilyStudents.Kinship::Himself);
            rUsersFamilyStudents.SetRange("Paying Entity", true);
            rUsersFamilyStudents.SetRange("No.", varNo);
            if rUsersFamilyStudents.Find('-') then begin
                StudentFilter := rStudents."Customer No." + '|';
                repeat
                    rStudents.Get(rUsersFamilyStudents."Student Code No.");
                    StudentFilter := StudentFilter + rStudents."Customer No." + '|';
                until rUsersFamilyStudents.Next = 0;
                StudentFilter := DelStr(StudentFilter, StrLen(StudentFilter), 1);
                Rec.SetFilter("Student Customer No.", StudentFilter);
                Rec.SetFilter("Entity Customer No.", StudentFilter);

            end;
        end;

        if vKinship = vKinship::"User Family" then begin
            rUsersFamily.Get(varNo);
            Rec.SetRange("Entity Customer No.", rUsersFamily."Customer No.");
        end;
        GetCorrectInvoice;
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetCorrectInvoice()
    begin
        if vCorrectInvoices then begin
            if varInvoiceDocNo <> '' then
                Rec.SetRange("Registed Invoice No.", varInvoiceDocNo);
            Rec.SetFilter("Remaining Amount", '<=%1', 0);
        end else begin
            if varInvoiceDocNo <> '' then
                Rec.SetRange("Registed Invoice No.", varInvoiceDocNo);
            Rec.SetFilter("Remaining Amount", '>%1', 0);
        end;
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetPaymentMethod(): Boolean
    var
        l_rSalesInvoiceHeader: Record "Sales Invoice Header";
        l_rPaymentMethod: Record "Payment Method";
    begin
        /*if Company = '' then begin
            l_rSalesInvoiceHeader.Reset;
            l_rSalesInvoiceHeader.SetRange("No.", "Registed Invoice No.");
            if l_rSalesInvoiceHeader.FindFirst then begin
                if (l_rPaymentMethod.Get(l_rSalesInvoiceHeader."Payment Method Code") and
                   (l_rPaymentMethod."Invoices to Cartera") or (l_rPaymentMethod."Create Bills")) then
                    exit(true)
                else*/
        exit(false);
        /*end;
    end else begin
        Clear(l_rSalesInvoiceHeader);
        Clear(l_rPaymentMethod);

        l_rSalesInvoiceHeader.ChangeCompany(Company);
        l_rPaymentMethod.ChangeCompany(Company);

        l_rSalesInvoiceHeader.Reset;
        l_rSalesInvoiceHeader.SetRange("No.", "Registed Invoice No.");
        if l_rSalesInvoiceHeader.FindFirst then begin
            if (l_rPaymentMethod.Get(l_rSalesInvoiceHeader."Payment Method Code") and
               (l_rPaymentMethod."Invoices to Cartera") or (l_rPaymentMethod."Create Bills")) then
                exit(true)
            else
                exit(false);
        end;
    end;*/
    end;

    //[Scope('OnPrem')]
    procedure EditablePayment()
    begin
        if GetPaymentMethod or vCorrectInvoices then begin
            "Debit Card PaymentEditable" := false;
            "Check PaymentEditable" := false;
            "Credit Card PaymentEditable" := false;
            "Cash PaymentEditable" := false;
            "Transfer PaymentEditable" := false;
            PaymentEditable := false;
            TotalRemaningAmountVisible := false;
            TotalCompanyRemaningAmountVisi := false;
            if vCorrectInvoices then begin
                "Remaining AmountVisible" := false;
                "Amount In Cre. MemoVisible" := true;
                TotalAmountforCreditMemoVisibl := true;
            end else begin
                "Remaining AmountVisible" := true;
                "Amount In Cre. MemoVisible" := false;
                TotalAmountforCreditMemoVisibl := false;
            end;
            VisibleRemaningAmount;
        end else begin
            PaymentEditable := true;
            "Remaining AmountVisible" := true;
            "Amount In Cre. MemoVisible" := false;
            TotalAmountforCreditMemoVisibl := false;
        end;
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

        //DebitCardPaymentVisible:=rUserSetup."Debit Card Payment" <> '';
        //CheckPaymentVisible:=rUserSetup."Check Payment" <> '';
        //CreditCardPaymentVisible:=rUserSetup."Credit Card Payment" <> '';
        //CashPaymentVisible:=rUserSetup."Cash Payment" <> '';
        //TransferPaymentVisible:=rUserSetup."Transfer Payment" <> '';
        /*
        CurrPage."Debit Card Payment".VISIBLE(rUserSetup."Debit Card Payment" <> '');
        CurrPage."Check Payment".VISIBLE(rUserSetup."Check Payment" <> '');
        CurrPage."Credit Card Payment".VISIBLE(rUserSetup."Credit Card Payment" <> '');
        CurrPage."Cash Payment".VISIBLE(rUserSetup."Cash Payment" <> '');
        CurrPage."Transfer Payment".VISIBLE(rUserSetup."Transfer Payment" <> '');
        */
        //"Credit NoteVisible" := rUserSetup."Allow Credit Memo";
        //"Amout Credit NoteVisible" := rUserSetup."Allow Credit Memo";

    end;

    //[Scope('OnPrem')]
    procedure VisibleRemaningAmount()
    begin
        if (Rec.Company = '') and (not vCorrectInvoices) then begin
            TotalRemaningAmountVisible := true;
            TotalCompanyRemaningAmountVisi := false;
        end else begin
            if not vCorrectInvoices then begin
                TotalRemaningAmountVisible := false;
                TotalCompanyRemaningAmountVisi := true;
            end;
        end;
    end;

    local procedure varNoOnAfterValidate()
    begin
        Rec.Reset;
        GetSubForm;
    end;

    local procedure varInvoiceDocNoOnAfterValidate()
    begin
        if varInvoiceDocNo <> '' then begin
            vKinship := 0;
            varNo := '';

            Rec.Reset;
            Rec.SetRange("Registed Invoice No.", varInvoiceDocNo);
            GetCorrectInvoice;
            CurrPage.Update(false);
        end;
    end;

    local procedure CreditNoteOnAfterValidate()
    begin
        EditablePayment;
        Field := Rec.FieldNo("Credit Note");
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        VisibleRemaningAmount;
    end;

    local procedure PaymentOnDeactivate()
    begin
        EditablePayment;
    end;

    local procedure vCorrectInvoicesOnPush()
    begin
        if vCorrectInvoices then
            PaymentEditable := false;
        CurrPage.Update(false);
        GetCorrectInvoice;
    end;

    local procedure PaymentOnPush()
    begin
        if GetPaymentMethod then
            Message(Text006);
    end;
}

#pragma implicitwith restore

