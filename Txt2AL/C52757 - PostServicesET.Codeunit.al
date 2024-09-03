codeunit 52757 "Post Services ET"
{
    // Criado o parametro de entrada pPostPrint para permitir o registo + impressão. - LFM 23.10.2009


    trigger OnRun()
    begin
    end;

    var
        rUserSetup: Record "User Setup";
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesCustom: Codeunit "NoSeries Custom";
        rStudentLedgerEntry: Record "Detailed Stud. Ledg. Entry";
        rStudentLedgerEntry1: Record "Student Ledger Entry";
        rGenJournalLine: Record "Gen. Journal Line";
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        LineNo: Integer;
        rStudentLedgerEntryTEMP: Record "Student Ledger Entry" temporary;
        DocNumber: Code[20];
        IncrDocNumber: Boolean;
        LastEntityID: Code[20];
        Window: Dialog;
        Nreg: Integer;
        countReg: Integer;
        Comentario: Dialog;
        rGenJournalLineTEMP: Record "Gen. Journal Line" temporary;
        Text0001: Label 'The amount for payment can''t be null. Please select the amout for payment. For the Select Line(s).';
        Text0002: Label 'You must go to this company %1 and register the payment on the diary.';
        Text0003: Label 'You must go to this company %1 and register the Credit Memo.';
        Text0004: Label 'The payment amount can''t be more then remaining amount.';
        cStudentServices: Codeunit "Student Services";
        text001: Text[30];
        Text0005: Label 'E-mail Subject';
        Text0006: Label 'E-mail Body';
        repCreateReminders: Report "Create Reminders";
        rCustomer: Record Customer;
        rCustLedgerEntry1: Record "Cust. Ledger Entry";
        rReminderHeader: Record "Reminder Header";
        rIssuedReminderHeader: Record "Issued Reminder Header";
        rIssuedReminderLine: Record "Issued Reminder Line";
        rCommentLine: Record "Comment Line";
        DocumentType: Option ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill;
        Mapi: Text[30];
        /*OutlookApp: Automation;
        NameSpace: Automation;
        Mailintem: Automation;
        Attachments: Automation;*/
        int: Integer;
        Text0007: Label 'Nº Fatura';

    //[Scope('OnPrem')]
    procedure PaymentServices(pNo: Code[20]; pUserID: Code[20]; pPostPrint: Boolean)
    var
        rStudentLedgerEntry: Record "Student Ledger Entry";
        VarAmountMB: Decimal;
        VarAmountCheck: Decimal;
        VarAmountVisa: Decimal;
        VarAmountcaixa: Decimal;
        VarAmountTransfer: Decimal;
        PaymentAccountNoMB: Code[20];
        PaymentAccountNoCheck: Code[20];
        PaymentAccountNoVisa: Code[20];
        PaymentAccountNoCaixa: Code[20];
        PaymentAccountNoTransfer: Code[20];
        rPaymentMethod: Record "Payment Method";
        AccountTypeMB: enum "Payment Balance Account Type";
        AccountTypeTransfer: enum "Payment Balance Account Type";
        AccountTypeVisa: enum "Payment Balance Account Type";
        AccountTypeCheck: enum "Payment Balance Account Type";
        AccountTypeCaixa: enum "Payment Balance Account Type";
        text: Text[30];
    begin
        Clear(VarAmountMB);
        Clear(VarAmountCheck);
        Clear(VarAmountVisa);
        Clear(VarAmountcaixa);
        Clear(VarAmountTransfer);
        Clear(LineNo);

        if rUserSetup.Get(UserId) then;

        IncrDocNumber := true;

        // Chamar a função de Registo de Notas de Crédito - 09.07.2008
        CreateMemoCredit(pNo, pUserID, pPostPrint);

        //Payments
        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetCurrentKey("Entity ID");
        rStudentLedgerEntry.SetRange(Payment, true);
        rStudentLedgerEntry.SetRange("User Session", pUserID);
        if rStudentLedgerEntry.Find('-') then begin
            repeat
                rStudentLedgerEntry.CalcFields("Total Remaning Amount");
                rStudentLedgerEntry.CalcFields("Total Company Remaning Amount");

                if rStudentLedgerEntry.Company = '' then begin
                    if (rStudentLedgerEntry."Total Remaning Amount" < rStudentLedgerEntry."Debit Card Payment") or
                       (rStudentLedgerEntry."Total Remaning Amount" < rStudentLedgerEntry."Check Payment") or
                       (rStudentLedgerEntry."Total Remaning Amount" < rStudentLedgerEntry."Credit Card Payment") or
                       (rStudentLedgerEntry."Total Remaning Amount" < rStudentLedgerEntry."Cash Payment") or
                       (rStudentLedgerEntry."Total Remaning Amount" < rStudentLedgerEntry."Transfer Payment") then
                        Error(Text0004);
                end else begin
                    if (rStudentLedgerEntry."Total Company Remaning Amount" < rStudentLedgerEntry."Debit Card Payment") or
                       (rStudentLedgerEntry."Total Company Remaning Amount" < rStudentLedgerEntry."Check Payment") or
                       (rStudentLedgerEntry."Total Company Remaning Amount" < rStudentLedgerEntry."Credit Card Payment") or
                       (rStudentLedgerEntry."Total Company Remaning Amount" < rStudentLedgerEntry."Cash Payment") or
                       (rStudentLedgerEntry."Total Company Remaning Amount" < rStudentLedgerEntry."Transfer Payment") then
                        Error(Text0004);
                end;
                if rStudentLedgerEntry.Company = '' then begin
                    if (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Debit Card Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Check Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Credit Card Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Cash Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Transfer Payment") then
                        Error(Text0004);
                end else begin
                    if (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Debit Card Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Check Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Credit Card Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Cash Payment") or
                       (rStudentLedgerEntry."Remaining Amount" < rStudentLedgerEntry."Transfer Payment") then
                        Error(Text0004);
                end;


                Clear(rEduConfiguration);
                rEduConfiguration.Reset;
                if rStudentLedgerEntry.Company <> '' then begin
                    rEduConfiguration.ChangeCompany(rStudentLedgerEntry.Company);
                    Message(Text0002, rStudentLedgerEntry.Company);
                end;

                rEduConfiguration.Get;
                rEduConfiguration.TestField("Journal Template Name");
                rEduConfiguration.TestField("Journal Batch Name");
                rEduConfiguration.TestField("No. Series Journals");

                //Todas as linhas de documento têm de estar na mesma ordem, ou seja têm de estar seguidas!!!
                rStudentLedgerEntryTEMP.Reset;
                rStudentLedgerEntryTEMP.SetRange("Entity ID", rStudentLedgerEntry."Entity ID");
                rStudentLedgerEntryTEMP.SetRange("Registed Invoice No.", rStudentLedgerEntry."Registed Invoice No.");
                if rStudentLedgerEntryTEMP.Find('-') then begin
                    if rStudentLedgerEntry."Debit Card Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Debit Card Payment");
                        VarAmountMB += rStudentLedgerEntry."Debit Card Payment";
                        rStudentLedgerEntry."Debit Card Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Debit Card Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoMB := rPaymentMethod."Bal. Account No.";
                            AccountTypeMB := rPaymentMethod."Bal. Account Type";

                        end;
                    end;

                    if rStudentLedgerEntry."Check Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Check Payment");
                        VarAmountCheck += rStudentLedgerEntry."Check Payment";
                        rStudentLedgerEntry."Check Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Check Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoCheck := rPaymentMethod."Bal. Account No.";
                            AccountTypeCheck := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Credit Card Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Credit Card Payment");
                        VarAmountVisa += rStudentLedgerEntry."Credit Card Payment";
                        rStudentLedgerEntry."Credit Card Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Credit Card Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoVisa := rPaymentMethod."Bal. Account No.";
                            AccountTypeVisa := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Cash Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Cash Payment");
                        VarAmountcaixa += rStudentLedgerEntry."Cash Payment";
                        if rPaymentMethod.Get(rUserSetup."Cash Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoCaixa := rPaymentMethod."Bal. Account No.";
                            AccountTypeCaixa := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Transfer Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Transfer Payment");
                        VarAmountTransfer += rStudentLedgerEntry."Transfer Payment";
                        if rPaymentMethod.Get(rUserSetup."Transfer Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoTransfer := rPaymentMethod."Bal. Account No.";
                            AccountTypeTransfer := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    LastEntityID := rStudentLedgerEntry."Entity ID";
                end else begin

                    rStudentLedgerEntryTEMP.Reset;
                    if rStudentLedgerEntryTEMP.Count > 0 then begin
                        if VarAmountMB > 0 then
                            PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountMB, PaymentAccountNoMB, AccountTypeMB, rUserSetup."Debit Card Payment");
                        if VarAmountCheck > 0 then
                            PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountCheck, PaymentAccountNoCheck, AccountTypeCheck,
                               rUserSetup."Check Payment");
                        if VarAmountVisa > 0 then
                            PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountVisa, PaymentAccountNoVisa, AccountTypeVisa,
                               rUserSetup."Credit Card Payment");
                        if VarAmountcaixa > 0 then
                            PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountcaixa, PaymentAccountNoCaixa, AccountTypeCaixa, rUserSetup."Cash Payment");
                        if VarAmountTransfer > 0 then
                            PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountTransfer, PaymentAccountNoTransfer, AccountTypeTransfer,
                                rUserSetup."Transfer Payment");
                        rStudentLedgerEntryTEMP.Delete;

                        if LastEntityID <> rStudentLedgerEntry."Entity ID" then
                            IncrDocNumber := true;
                        LastEntityID := rStudentLedgerEntry."Entity ID";
                    end;

                    Clear(VarAmountMB);
                    Clear(VarAmountCheck);
                    Clear(VarAmountVisa);
                    Clear(VarAmountcaixa);
                    Clear(VarAmountTransfer);

                    if rStudentLedgerEntry."Debit Card Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Debit Card Payment");
                        VarAmountMB += rStudentLedgerEntry."Debit Card Payment";
                        rStudentLedgerEntry."Debit Card Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Debit Card Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoMB := rPaymentMethod."Bal. Account No.";
                            AccountTypeMB := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Check Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Check Payment");
                        VarAmountCheck += rStudentLedgerEntry."Check Payment";
                        rStudentLedgerEntry."Check Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Check Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoCheck := rPaymentMethod."Bal. Account No.";
                            AccountTypeCheck := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Credit Card Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Credit Card Payment");
                        VarAmountVisa += rStudentLedgerEntry."Credit Card Payment";
                        rStudentLedgerEntry."Credit Card Payment" := 0;
                        if rPaymentMethod.Get(rUserSetup."Credit Card Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoVisa := rPaymentMethod."Bal. Account No.";
                            AccountTypeVisa := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Cash Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Cash Payment");
                        VarAmountcaixa += rStudentLedgerEntry."Cash Payment";
                        if rPaymentMethod.Get(rUserSetup."Cash Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoCaixa := rPaymentMethod."Bal. Account No.";
                            AccountTypeCaixa := rPaymentMethod."Bal. Account Type";
                        end;
                    end;

                    if rStudentLedgerEntry."Transfer Payment" > 0 then begin
                        if IncrDocNumber then begin
                            if DocNumber = '' then
                                if rStudentLedgerEntry.Company <> '' then
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, true, rStudentLedgerEntry.Company)
                                else
                                    DocNumber := NoSeriesCustom.GetNextNoMultiCompany
                                      (rEduConfiguration."No. Series Journals", WorkDate, false, rStudentLedgerEntry.Company);
                            IncrDocNumber := false;
                        end;
                        if rStudentLedgerEntry.Company = '' then
                            InsertDtlStudent(rStudentLedgerEntry, rStudentLedgerEntry."Transfer Payment");
                        VarAmountTransfer += rStudentLedgerEntry."Transfer Payment";
                        if rPaymentMethod.Get(rUserSetup."Transfer Payment") then begin
                            rPaymentMethod.TestField("Bal. Account No.");
                            PaymentAccountNoTransfer := rPaymentMethod."Bal. Account No.";
                            AccountTypeTransfer := rPaymentMethod."Bal. Account Type";
                        end;
                    end;
                    if (VarAmountMB = 0) and
                       (VarAmountCheck = 0) and
                       (VarAmountVisa = 0) and
                       (VarAmountcaixa = 0) and
                       (VarAmountTransfer = 0) then
                        Error(Text0001);

                    rStudentLedgerEntryTEMP.TransferFields(rStudentLedgerEntry);
                    rStudentLedgerEntryTEMP.Insert;
                end;

                rStudentLedgerEntry.Payment := false;

                rStudentLedgerEntry."Debit Card Payment" := 0;
                rStudentLedgerEntry."User Session" := '';
                rStudentLedgerEntry."Check Payment" := 0;
                rStudentLedgerEntry."Credit Card Payment" := 0;
                rStudentLedgerEntry."Cash Payment" := 0;
                rStudentLedgerEntry."Transfer Payment" := 0;
                rStudentLedgerEntry.Modify;
                rStudentLedgerEntry.UpdateFields(rStudentLedgerEntry);
            until rStudentLedgerEntry.Next = 0;

            rStudentLedgerEntryTEMP.Reset;
            if rStudentLedgerEntryTEMP.Count <> 0 then begin
                if VarAmountMB > 0 then
                    PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountMB, PaymentAccountNoMB, AccountTypeMB, rUserSetup."Debit Card Payment");
                if VarAmountCheck > 0 then
                    PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountCheck, PaymentAccountNoCheck, AccountTypeCheck, rUserSetup."Check Payment");
                if VarAmountVisa > 0 then
                    PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountVisa, PaymentAccountNoVisa, AccountTypeVisa, rUserSetup."Credit Card Payment");
                if VarAmountcaixa > 0 then
                    PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountcaixa, PaymentAccountNoCaixa, AccountTypeCaixa, rUserSetup."Cash Payment");
                if VarAmountTransfer > 0 then
                    PaymetRegisto(rStudentLedgerEntryTEMP, VarAmountTransfer, PaymentAccountNoTransfer, AccountTypeTransfer,
                        rUserSetup."Transfer Payment");
            end;

            rGenJournalLine.Reset;
            if rGenJournalLine.Count <> 0 then begin
                if rStudentLedgerEntry.Company = '' then begin
                    rGenJournalLine.Copy(rGenJournalLineTEMP);
                    if not pPostPrint then
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", rGenJournalLine)
                    else
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post+Print EDUSOL", rGenJournalLine);
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertDtlStudent(pStudentLedgerEntry: Record "Student Ledger Entry"; pAmount: Decimal)
    var
        DetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
        i: Integer;
        varEntryNo: Integer;
        DetailedStudLedgEntry2: Record "Detailed Stud. Ledg. Entry";
    begin
        i := 1;

        DetailedStudLedgEntry2.Reset;
        if DetailedStudLedgEntry2.Find('+') then
            varEntryNo := DetailedStudLedgEntry2."Entry No.";

        DetailedStudLedgEntry2.Reset;
        DetailedStudLedgEntry2.SetRange("Student Ledger Entry No.", pStudentLedgerEntry."Entry No.");
        if DetailedStudLedgEntry2.FindFirst then;

        for i := 1 to 3 do begin
            varEntryNo += 1;
            DetailedStudLedgEntry.Init;
            DetailedStudLedgEntry."Entry No." := varEntryNo;
            DetailedStudLedgEntry."Posting Date" := WorkDate;
            DetailedStudLedgEntry."Document Date" := WorkDate;
            if i = 1 then begin
                DetailedStudLedgEntry."Entry Type" := DetailedStudLedgEntry."Entry Type"::"Initial Entry";
                DetailedStudLedgEntry.Amount := -pAmount;
                DetailedStudLedgEntry."Credit Amount" := pAmount;
                DetailedStudLedgEntry."Initial Document Type" := DetailedStudLedgEntry."Initial Document Type"::Payment;
            end;
            if i = 2 then begin
                DetailedStudLedgEntry."Entry Type" := DetailedStudLedgEntry."Entry Type"::Application;
                DetailedStudLedgEntry.Amount := pAmount;
                DetailedStudLedgEntry."Debit Amount" := pAmount;
                DetailedStudLedgEntry."Initial Document Type" := DetailedStudLedgEntry."Initial Document Type"::Payment;
            end;
            if i = 3 then begin
                DetailedStudLedgEntry."Entry Type" := DetailedStudLedgEntry."Entry Type"::Application;
                DetailedStudLedgEntry.Amount := -pAmount;
                DetailedStudLedgEntry."Credit Amount" := pAmount;
                DetailedStudLedgEntry."Initial Document Type" := DetailedStudLedgEntry."Initial Document Type"::Invoice;
            end;
            DetailedStudLedgEntry."User ID" := UserId;
            DetailedStudLedgEntry."Document Type" := DetailedStudLedgEntry."Document Type"::Payment;
            DetailedStudLedgEntry."Cust. Ledger Entry No." := DetailedStudLedgEntry2."Cust. Ledger Entry No.";
            DetailedStudLedgEntry."Student Ledger Entry No." := pStudentLedgerEntry."Entry No.";
            DetailedStudLedgEntry."Document No." := DocNumber;
            DetailedStudLedgEntry."Customer No." := pStudentLedgerEntry."Entity Customer No.";
            DetailedStudLedgEntry."Source Code" := DetailedStudLedgEntry2."Source Code";
            DetailedStudLedgEntry."Transaction No." := DetailedStudLedgEntry2."Transaction No.";
            DetailedStudLedgEntry."Initial Entry Due Date" := DetailedStudLedgEntry2."Initial Entry Due Date";
            DetailedStudLedgEntry.Insert(false);

        end;
    end;

    //[Scope('OnPrem')]
    procedure PaymetRegisto(pStudentLedgerEntry: Record "Student Ledger Entry"; pAmount: Decimal; pBallAccountNo: Code[20]; pAccountType: enum "Payment Balance Account Type"; pPaymentMethod: Code[50])
    var
        rGenJournalTemplate: Record "Gen. Journal Template";
    begin
        Clear(rGenJournalTemplate);
        Clear(rGenJournalLine);
        rGenJournalTemplate.Reset;
        if pStudentLedgerEntry.Company <> '' then begin
            rGenJournalTemplate.ChangeCompany(pStudentLedgerEntry.Company);
            rGenJournalLine.ChangeCompany(pStudentLedgerEntry.Company);
        end;

        rGenJournalTemplate.Get(rEduConfiguration."Journal Template Name");

        rGenJournalLine.Reset;
        rGenJournalLine.SetRange("Journal Template Name", rEduConfiguration."Journal Template Name");
        rGenJournalLine.SetRange("Journal Batch Name", rEduConfiguration."Journal Batch Name");
        if rGenJournalLine.FindLast then
            LineNo := rGenJournalLine."Line No."
        else
            LineNo := 0;

        if LineNo <> 0 then
            LineNo += 10000;

        rGenJournalLine.Init;
        rGenJournalLine."Journal Template Name" := rEduConfiguration."Journal Template Name";
        rGenJournalLine."Journal Batch Name" := rEduConfiguration."Journal Batch Name";
        rGenJournalLine."Line No." := LineNo;
        rGenJournalLine."Document No." := DocNumber;
        rGenJournalLine."Posting Date" := WorkDate;
        rGenJournalLine.Validate("Document Type", rGenJournalLine."Document Type"::Payment);
        rGenJournalLine."Account Type" := rGenJournalLine."Account Type"::Customer;
        rGenJournalLine.Validate("Account No.", pStudentLedgerEntry."Entity Customer No.");
        rGenJournalLine.Validate(Amount, -pAmount);
        rGenJournalLine."Payment Method Code" := rUserSetup."Debit Card Payment";
        case pAccountType of
            pAccountType::"G/L Account":
                rGenJournalLine."Bal. Account Type" := rGenJournalLine."Bal. Account Type"::"G/L Account";
            pAccountType::"Bank Account":
                rGenJournalLine."Bal. Account Type" := rGenJournalLine."Bal. Account Type"::"Bank Account";
        end;
        rGenJournalLine."Bal. Account No." := pBallAccountNo;
        rGenJournalLine."Applies-to Doc. Type" := rGenJournalLine."Applies-to Doc. Type"::Invoice;
        rGenJournalLine."Applies-to Doc. No." := pStudentLedgerEntry."Registed Invoice No.";
        rGenJournalLine."Source Code" := rGenJournalTemplate."Source Code";
        rGenJournalLine."Process by Education" := true;
        rGenJournalLine.Insert;

        if pStudentLedgerEntry.Company = '' then begin
            rGenJournalLineTEMP.Copy(rGenJournalLine);
        end;
    end;

    //[Scope('OnPrem')]
    procedure CreateMemoCredit(pVarNo: Code[20]; pUserID: Code[20]; pPostPrint: Boolean)
    var
        rStudentLedgerEntry: Record "Student Ledger Entry";
        rSalesHeader: Record "Sales Header";
        rSalesHeader2: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        cuNoSeriesCustom: Codeunit "NoSeries Custom";
        varNewDocNo: Code[20];
        varOldDocNo: Code[20];
        varOldInvoice: Code[20];
        varLineNo: Integer;
        varOldCompany: Text[30];
        l_Comment: Text[250];
        x: Integer;
        varUnitPriceDiscount: Decimal;
        l_Text0001: Label 'Do you want insert ext. texts in Credit Memo?';
        l_Text0002: Label 'Ext. text:';
        l_Text0003: Label 'The amount for credit memo can''t be null. Please select the amout for credit memo. For the Select Line(s).';
        InputPage: Page "Text Input";
    begin
        //----------------------------------------------------------------------------------------------------------------------------------
        // Linhas de Pagamento Notas de Crédito - 09.07.2008
        //----------------------------------------------------------------------------------------------------------------------------------
        Clear(varOldInvoice);
        Clear(varOldDocNo);

        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetCurrentKey("Registed Invoice No.");
        rStudentLedgerEntry.Ascending(true);
        rStudentLedgerEntry.SetRange("User Session", pUserID);
        rStudentLedgerEntry.SetRange("Credit Note", true);
        if rStudentLedgerEntry.Find('-') then begin
            repeat
                if rStudentLedgerEntry."Amout Credit Note" = 0 then
                    Error(l_Text0003);
            until rStudentLedgerEntry.Next = 0;
        end;

        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetCurrentKey("Registed Invoice No.");
        rStudentLedgerEntry.Ascending(true);
        rStudentLedgerEntry.SetRange("User Session", pUserID);
        rStudentLedgerEntry.SetRange("Credit Note", true);
        if rStudentLedgerEntry.Find('-') then
            repeat
                // Criação do Cabeçalho das Notas de Crédito - 09.07.2008
                if (rStudentLedgerEntry."Registed Invoice No." <> varOldInvoice) then begin

                    // Envio da Nota de Crédito para Registo - 09.07.2008
                    // Criado o pPostPrint Para chamar a codeunit post + Print // validar a multicompany  - 23.10.2009
                    if (varOldDocNo <> '') and (varOldCompany = '') then
                        RegistCreditMemo(varOldDocNo, pPostPrint);

                    if varOldCompany <> '' then
                        rSalesHeader.Delete;

                    Clear(varNewDocNo);
                    Clear(varLineNo);
                    varLineNo := 10000;

                    Clear(rSalesReceivablesSetup);
                    Clear(rSalesHeader);
                    rSalesReceivablesSetup.Reset;
                    rSalesHeader.Reset;

                    if rStudentLedgerEntry.Company <> '' then begin
                        rSalesReceivablesSetup.ChangeCompany(rStudentLedgerEntry.Company);
                    end;

                    rSalesReceivablesSetup.Get;

                    rSalesHeader.SetHideValidationDialog(true);

                    rSalesHeader.Init;
                    rSalesHeader."Document Type" := rSalesHeader."Document Type"::"Credit Memo";
                    rSalesHeader."No." := cuNoSeriesCustom.GetNextNoMultiCompany
                      (rSalesReceivablesSetup."Credit Memo Nos.", WorkDate, true, rStudentLedgerEntry.Company);
                    varNewDocNo := rSalesHeader."No.";
                    rSalesHeader."Process by Education" := true;
                    rSalesHeader."No. Series" := rSalesReceivablesSetup."Credit Memo Nos.";
                    rSalesHeader."Posting No. Series" := rSalesReceivablesSetup."Posted Credit Memo Nos.";
                    rSalesHeader."Return Receipt No." := rSalesReceivablesSetup."Posted Return Receipt Nos.";

                    rSalesHeader."Posting Description" := rStudentLedgerEntry."Student No.";
                    rSalesHeader.Insert;

                    rSalesHeader."Order Date" := WorkDate;
                    rSalesHeader."Posting Date" := WorkDate;
                    rSalesHeader."Document Date" := WorkDate;


                    rSalesHeader.Validate("Sell-to Customer No.", rStudentLedgerEntry."Student Customer No.");
                    rSalesHeader.Validate("Bill-to Customer No.", rStudentLedgerEntry."Entity Customer No.");

                    //Para a versão portuguesa este código tem de ser comentado pois a opção corrigir
                    //Só esta disponivel na versão espanhola

                    if rStudentLedgerEntry."Remaining Amount" <> 0 then begin
                        rSalesHeader."Applies-to Doc. Type" := rSalesHeader."Applies-to Doc. Type"::Invoice;
                        rSalesHeader.Validate("Applies-to Doc. No.", rStudentLedgerEntry."Registed Invoice No.");
                    end;
                    //END ELSE
                    //  rSalesHeader."Corrected Invoice No." := rStudentLedgerEntry."Registed Invoice No.";

                    rSalesHeader.Modify(true);

                    //
                    if rStudentLedgerEntry.Company <> '' then begin
                        Clear(rSalesHeader2);
                        rSalesHeader2.Reset;
                        rSalesHeader2.ChangeCompany(rStudentLedgerEntry.Company);
                        rSalesHeader2.Copy(rSalesHeader);
                        rSalesHeader2.Company := CompanyName;
                        rSalesHeader2.Insert;
                    end;

                    //Normatica 2013.01.28 - Para colocar nas linhas da nota credito o nº da fatura
                    rSalesLine.Init;
                    rSalesLine."Line No." := varLineNo;
                    rSalesLine."Document Type" := rSalesLine."Document Type"::"Credit Memo";
                    rSalesLine."Document No." := varNewDocNo;
                    rSalesLine.Description := Text0007 + ' ' + rStudentLedgerEntry."Registed Invoice No." + ':';
                    rSalesLine.Insert;
                    varLineNo := varLineNo + 10000;
                    //Normatica 2013.01.28 - fim

                end;

                // Criação das Linhas das Notas de Crédito - 09.07.2008
                Clear(rSalesLine);
                rSalesLine.Reset;
                if rStudentLedgerEntry.Company <> '' then
                    rSalesLine.ChangeCompany(rStudentLedgerEntry.Company);

                rSalesLine.Init;
                rSalesLine."Document Type" := rSalesLine."Document Type"::"Credit Memo";
                rSalesLine."Document No." := varNewDocNo;
                rSalesLine."Line No." := varLineNo;
                rSalesLine.Insert(true);

                //2011.10.14 - para poder fazer notas de credito de produtos e não só de serviços
                //rSalesLine.VALIDATE(Type,rSalesLine.Type::Service);
                if rStudentLedgerEntry.Type = rStudentLedgerEntry.Type::Service then
                    rSalesLine.Validate(Type, rSalesLine.Type::Service);
                if rStudentLedgerEntry.Type = rStudentLedgerEntry.Type::Item then
                    rSalesLine.Validate(Type, rSalesLine.Type::Item);


                rSalesLine.Validate("No.", rStudentLedgerEntry."Service Code");
                rSalesLine.Validate(Quantity, 1);
                //Normatica 2014.11.07 - para passar o Centro resp
                rSalesLine."Responsibility Center" := rStudentLedgerEntry."Responsibility Center";
                //Normrtica fim
                // If Have Line Discount
                text001 := Format(rStudentLedgerEntry."Line Discount %");
                if rStudentLedgerEntry."Line Discount %" <> 0 then begin
                    varUnitPriceDiscount := (rStudentLedgerEntry."Amout Credit Note" / (1 - (rStudentLedgerEntry."Line Discount %" / 100)));
                    rSalesLine.Validate("Unit Price", varUnitPriceDiscount);
                end else
                    rSalesLine.Validate("Unit Price", rStudentLedgerEntry."Amout Credit Note");
                if rStudentLedgerEntry.Type = rStudentLedgerEntry.Type::Item then begin
                    rSalesLine.Validate("Shortcut Dimension 1 Code", GetDimen(rStudentLedgerEntry."Responsibility Center"));
                    rSalesLine.Modify;
                end;
                rSalesLine.Modify(true);

                varLineNo := varLineNo + 10000;

                varOldInvoice := rStudentLedgerEntry."Registed Invoice No.";
                varOldDocNo := varNewDocNo;
                varOldCompany := rStudentLedgerEntry.Company;

                if Confirm(l_Text0001) then begin
                    //Comentario.Open(l_Text0002 + '#1###################################\', l_Comment);
                    //Comentario.Input(1, l_Comment);
                    InputPage.SetDisplayText(l_Text0002 + '#1###################################\');
                    InputPage.RunModal();
                    l_Comment := InputPage.GetInputText();
                    Comentario.Close;
                    if l_Comment <> '' then begin
                        rSalesLine.Init;
                        rSalesLine."Document Type" := rSalesLine."Document Type"::"Credit Memo";
                        rSalesLine."Document No." := varNewDocNo;
                        rSalesLine."Line No." := varLineNo;
                        rSalesLine.Description := l_Comment;
                        rSalesLine.Insert(true);
                        varLineNo := varLineNo + 10000;
                    end;
                end;
                rStudentLedgerEntry.Modify;
            until rStudentLedgerEntry.Next = 0;

        // Envio da última Nota de Crédito para Registo - 09.07.2008
        // Criado o pPostPrint Para chamar a codeunit post + Print // validar a multicompany  - 23.10.2009

        if rStudentLedgerEntry.Company = '' then
            RegistCreditMemo(varOldDocNo, pPostPrint)
        else begin
            rSalesHeader.Delete;
            Message(Text0003, rStudentLedgerEntry.Company);
        end;
        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetCurrentKey("Student No.", Class, "School Year", "Schooling Year", "Line No.");
        rStudentLedgerEntry.Ascending(true);
        //rStudentLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
        rStudentLedgerEntry.SetRange("User Session", pUserID);
        rStudentLedgerEntry.SetRange("Credit Note", true);
        if rStudentLedgerEntry.Find('-') then
            repeat
                rStudentLedgerEntry."Amout Credit Note" := 0;
                rStudentLedgerEntry."Credit Note" := false;
                rStudentLedgerEntry."User Session" := '';
                rStudentLedgerEntry.Modify;
                rStudentLedgerEntry.UpdateFields(rStudentLedgerEntry);
            until rStudentLedgerEntry.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure RegistCreditMemo(pOldDocNo: Code[20]; pPostPrint: Boolean)
    var
        rSalesHeaderRegis: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        Clear(ApprovalMgt);
        rSalesHeaderRegis.Reset;
        rSalesHeaderRegis.SetRange("Document Type", rSalesHeaderRegis."Document Type"::"Credit Memo");
        rSalesHeaderRegis.SetRange("No.", pOldDocNo);
        if rSalesHeaderRegis.Find('-') then
            //IF ApprovalMgt.PrePostApprovalCheck(rSalesHeaderRegis,PurchaseHeader) THEN
            if ApprovalMgt.PrePostApprovalCheckSales(rSalesHeaderRegis) then
                if not pPostPrint then
                    CODEUNIT.Run(CODEUNIT::"Sales-Post", rSalesHeaderRegis)
                else
                    CODEUNIT.Run(CODEUNIT::"Sales-Post + Print EDUSOL", rSalesHeaderRegis);
    end;

    //[Scope('OnPrem')]
    procedure InsertServices(pServicesPlanLine: Record "Services Plan Line")
    var
        l_StudentServicePlan: Record "Student Service Plan";
        l_Registration: Record Registration;
        varLineNo: Integer;
        cStudentsRegistration: Codeunit "Students Registration";
        text0001: Label 'Update Subject  \@1@@@@@@@@@@@@@@@@@@@@@';
    begin

        l_Registration.Reset;
        l_Registration.SetRange("School Year", pServicesPlanLine."School Year");
        l_Registration.SetRange("Services Plan Code", pServicesPlanLine.Code);
        l_Registration.SetRange("Schooling Year", pServicesPlanLine."Schooling Year");
        if l_Registration.FindSet then begin
            Window.Open(text0001);
            Nreg := l_Registration.Count;

            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));

                varLineNo := 0;
                l_StudentServicePlan.Reset;
                l_StudentServicePlan.SetRange("Student No.", l_Registration."Student Code No.");
                l_StudentServicePlan.SetRange("School Year", l_Registration."School Year");
                l_StudentServicePlan.SetRange("Services Plan Code", l_Registration."Services Plan Code");
                if l_StudentServicePlan.FindLast then
                    varLineNo := l_StudentServicePlan."Line No." + 10000
                else
                    varLineNo := 10000;


                l_StudentServicePlan.Reset;
                l_StudentServicePlan.SetRange("Student No.", l_Registration."Student Code No.");
                l_StudentServicePlan.SetRange("School Year", l_Registration."School Year");
                l_StudentServicePlan.SetRange("Service Code", pServicesPlanLine."Service Code");
                l_StudentServicePlan.SetRange("Services Plan Code", l_Registration."Services Plan Code");
                if not l_StudentServicePlan.FindSet then begin
                    l_StudentServicePlan.Init;
                    l_StudentServicePlan."Student No." := l_Registration."Student Code No.";
                    l_StudentServicePlan."School Year" := l_Registration."School Year";
                    l_StudentServicePlan."Schooling Year" := l_Registration."Schooling Year";
                    l_StudentServicePlan."Service Code" := pServicesPlanLine."Service Code";
                    if pServicesPlanLine."Service Type" = pServicesPlanLine."Service Type"::Required then
                        l_StudentServicePlan.Selected := true;
                    l_StudentServicePlan."Service Type" := pServicesPlanLine."Service Type";
                    l_StudentServicePlan.Description := pServicesPlanLine.Description;
                    l_StudentServicePlan."Description 2" := pServicesPlanLine."Description 2";
                    l_StudentServicePlan.Quantity := 1;
                    l_StudentServicePlan.January := pServicesPlanLine.January;
                    l_StudentServicePlan.February := pServicesPlanLine.February;
                    l_StudentServicePlan.March := pServicesPlanLine.March;
                    l_StudentServicePlan.April := pServicesPlanLine.April;
                    l_StudentServicePlan.May := pServicesPlanLine.May;
                    l_StudentServicePlan.June := pServicesPlanLine.June;
                    l_StudentServicePlan.July := pServicesPlanLine.July;
                    l_StudentServicePlan.August := pServicesPlanLine.August;
                    l_StudentServicePlan.Setember := pServicesPlanLine.Setember;
                    l_StudentServicePlan.October := pServicesPlanLine.October;
                    l_StudentServicePlan.November := pServicesPlanLine.November;
                    l_StudentServicePlan.Dezember := pServicesPlanLine.Dezember;
                    l_StudentServicePlan."Line No." := varLineNo;
                    l_StudentServicePlan."Services Plan Code" := pServicesPlanLine.Code;
                    l_StudentServicePlan."Country/Region Code" := cStudentsRegistration.GetCountry;
                    l_StudentServicePlan."Responsibility Center" := pServicesPlanLine."Responsibility Center";
                    l_StudentServicePlan."User ID" := UserId;
                    l_StudentServicePlan."Last Date Modified" := WorkDate;
                    l_StudentServicePlan.Insert(true);
                    cStudentServices.DistributionByEntityRegis(l_StudentServicePlan);
                    l_StudentServicePlan.UpdateDist;

                end;
            until l_Registration.Next = 0;
            Window.Close;
        end;
    end;

    /*//[Scope('OnPrem')]
    procedure MailFilter(pSalesInvoiceCode: Code[20])
    var
        l_Customer: Record Customer;
        l_recUsersFamilyStudents: Record "Users Family / Students";
        l_recUsersFamily: Record "Users Family";
    begin
        if rEduConfiguration.Get then begin
            if rEduConfiguration."Send E-Mail Reminder" and (pSalesInvoiceCode = '') then begin
                rStudentLedgerEntry1.Reset;
                if rStudentLedgerEntry1.FindSet then begin
                    repeat
                        if rCustomer.Get(rStudentLedgerEntry1."Entity Customer No.") then
                            if (rCustomer."E-Mail" <> '') and (rCustomer."Reminder Terms Code" <> '') then begin
                                rCustLedgerEntry1.Reset;
                                rCustLedgerEntry1.SetRange("Entry No.", rStudentLedgerEntry1."Cust. Ledger Entry No.");
                                rCustLedgerEntry1.SetRange(Open, true);
                                if rCustLedgerEntry1.FindFirst then begin
                                    Clear(repCreateReminders);
                                    repCreateReminders.UseRequestPage(false);
                                    repCreateReminders.GetData(rCustLedgerEntry1."Customer No.", DocumentType::Invoice);
                                    repCreateReminders.Run;

                                    rReminderHeader.Reset;
                                    if rReminderHeader.FindLast then begin
                                        REPORT.RunModal(REPORT::"Issue Reminders", false, true, rReminderHeader);
                                        rIssuedReminderHeader.Reset;
                                        if rIssuedReminderHeader.FindLast then begin
                                            REPORT.SaveAsHtml(REPORT::Reminder, TemporaryPath + '\Document.html', rIssuedReminderHeader);
                                            SendMail(TemporaryPath + '\Document.html', rCustLedgerEntry1."Customer No.");

                                            rIssuedReminderLine.Reset;
                                            rIssuedReminderLine.SetRange("Reminder No.", rIssuedReminderHeader."No.");
                                            rIssuedReminderLine.SetRange("Document Type", rIssuedReminderLine."Document Type"::Invoice);
                                            if rIssuedReminderLine.FindSet then begin
                                                repeat
                                                    rSalesInvoiceHeader.Reset;
                                                    rSalesInvoiceHeader.SetRange("No.", rIssuedReminderLine."Document No.");
                                                    if rSalesInvoiceHeader.FindFirst then begin
                                                        REPORT.SaveAsHtml(REPORT::Report59999, TemporaryPath + '\Document.html', rSalesInvoiceHeader);
                                                        MutipleAttachments(TemporaryPath + '\Document.html');
                                                    end;
                                                until rIssuedReminderLine.Next = 0;
                                            end;
                                            OutlookSend;
                                        end;
                                    end;
                                end;
                            end;
                    until rStudentLedgerEntry1.Next = 0;
                end;
            end else begin
                if rEduConfiguration."Send E-Mail Invoice" then begin
                    rSalesInvoiceHeader.Reset;
                    rSalesInvoiceHeader.SetRange("No.", pSalesInvoiceCode);
                    if rSalesInvoiceHeader.FindFirst then begin
                        //C+ RSC
                        if l_Customer.Get(rSalesInvoiceHeader."Sell-to Customer No.") then begin
                            l_recUsersFamilyStudents.Reset;
                            l_recUsersFamilyStudents.SetRange("No.", l_Customer."Student No.");
                            l_recUsersFamilyStudents.SetRange("Paying Entity", true);
                            if l_recUsersFamilyStudents.Find('-') then begin
                                //IF l_recUsersFamily.GET(l_recUsersFamilyStudents."No.") THEN BEGIN
                                REPORT.SaveAsHtml(REPORT::Report59999, TemporaryPath + '\Document.html', rSalesInvoiceHeader);
                                SendMail(TemporaryPath + '\Document.html', rSalesInvoiceHeader."Sell-to Customer No.");
                                OutlookSend;
                                //END;
                            end;
                        end;
                        //C+ RSC
                    end;
                end;
            end;
        end;
    end;*/

    /*//[Scope('OnPrem')]
    procedure SendMail(pFilePath: Text[250]; pCustomer: Code[20])
    begin
        if rCustomer.Get(pCustomer) then begin
            /*while not Exists(pFilePath) do begin
                Yield;
            end;*//*

            CreateMail(rCustomer."E-Mail");
            MutipleAttachments(pFilePath);
        end;
    end;

    //[Scope('OnPrem')]
    procedure OutlookSend()
    var
        File: File;
        InStream: InStream;
        TextPosition: Integer;
        Text: Text[260];
    begin
        Mailintem.Send;
        NameSpace.Logoff;
    end;

    //[Scope('OnPrem')]
    procedure MutipleAttachments(pFilePath: Text[250])
    begin
        Mailintem.Attachments.Add(pFilePath, 6, 1);
    end;

    //[Scope('OnPrem')]
    procedure CreateMail(pEmail: Text[250])
    begin
        if IsClear(OutlookApp) then
            Create(OutlookApp, false, true);

        Mapi := 'MAPI';
        NameSpace := OutlookApp.GetNamespace(Mapi);
        NameSpace.Logon;

        Mailintem := OutlookApp.CreateItem(0);
        //Mailintem.BCC(pEmail);
        Mailintem."To"(pEmail);
        Mailintem.BodyFormat := 2;
        GetSubject;
        GetBodyText;
    end;

    //[Scope('OnPrem')]
    procedure GetSubject()
    begin
        rCommentLine.Reset;
        rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::"E-Mail");
        rCommentLine.SetRange("No.", Text0005);
        if rCommentLine.FindSet then begin
            int := rCommentLine.Count;
            repeat
                if int = 1 then
                    Mailintem.Subject := rCommentLine.Comment
                else begin
                    Mailintem.Subject := InsStr(Mailintem.Subject, ' ', StrLen(Mailintem.Subject) + 1);
                    Mailintem.Subject := InsStr(Mailintem.Subject, rCommentLine.Comment, StrLen(Mailintem.Subject) + 1);
                end;
            until rCommentLine.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetBodyText()
    begin
        rCommentLine.Reset;
        rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::"E-Mail");
        rCommentLine.SetRange("No.", Text0006);
        if rCommentLine.FindSet then begin
            int := rCommentLine.Count;
            repeat
                if int = 1 then
                    Mailintem.Body := rCommentLine.Comment
                else begin
                    Mailintem.Body := InsStr(Mailintem.Body, ' ', StrLen(Mailintem.Body) + 1);
                    Mailintem.Body := InsStr(Mailintem.Body, rCommentLine.Comment, StrLen(Mailintem.Body) + 1);
                end;
            until rCommentLine.Next = 0;
        end;
    end;*/

    //[Scope('OnPrem')]
    procedure GetDimen(inCR: Code[50]): Code[30]
    begin
        case inCR of
            'TAGUS PARK':
                exit('201912112');
            'BELEM':
                exit('204912112');
            'RESTELO':
                exit('206912112');
            'CASCAIS':
                exit('207912112');
        end;
    end;
}

