report 31009752 "Invoicing Services"
{
    // //Portugal o campo getCreditMemos deve estar invisivel
    // 
    // //IT001 - CPA - 2016.09.22 - querem o nome porque na versão anterior já tinha o nome

    Caption = 'Invoicing Services';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Student Ledger Entry"; "Student Ledger Entry")
        {
            DataItemTableView = SORTING("Student No.", Class, "Entity ID", Company) WHERE(Registed = FILTER(false), "Invoice No." = FILTER(''));
            RequestFilterFields = "Student No.", Class, "Service Code", "Entity Customer No.";

            trigger OnAfterGetRecord()
            var
                tempSLEntry: Record "Student Ledger Entry";
                boolHeader: Boolean;
            begin
                //Student Ledger Entry GroupHeader - OnPreSection, starttest
                tempSLEntry.Reset;
                boolHeader := false;
                tempSLEntry := "Student Ledger Entry";
                tempSLEntry.CopyFilters("Student Ledger Entry");
                if tempSLEntry.Next = 0 then
                    boolHeader := true
                else
                    if tempSLEntry."Entity ID" <> "Student Ledger Entry"."Entity ID" then
                        boolHeader := true;
                //ELSE
                //   IF tempSLEntry.Company<>"Student Ledger Entry".Company THEN
                //      boolHeader:=TRUE;

                if boolHeader then begin
                    CreateSalesHeader;
                    //Student Ledger Entry GroupHeader - OnPreSection, starttest

                    //Student Ledger Entry Body - OnPreSection, starttest
                    CreateSalesLine;
                    StudLedgerEntry.Reset;
                    StudLedgerEntry := "Student Ledger Entry";
                    StudLedgerEntry.CopyFilters("Student Ledger Entry");
                    StudLedgerEntry.SetRange("Student No.", StudLedgerEntry."Student No.");
                    StudLedgerEntry.SetRange("Entity ID", "Student Ledger Entry"."Entity ID");
                    if StudLedgerEntry.FindSet then
                        repeat
                            StudLedgerEntry."Invoice No." := SalesLine."Document No.";
                            StudLedgerEntry.Modify;
                        until (StudLedgerEntry.Next = 0);
                    //Student Ledger Entry Body - OnPreSection, endtest
                end;
            end;

            trigger OnPostDataItem()
            begin
                //IF (LastCompanyName <> '') THEN BEGIN
                //  SalesHeader.RESET;
                //  IF SalesHeader.GET(SalesHeaderTEMP."Document Type",SalesHeaderTEMP."No.") THEN
                //    SalesHeader.DELETE;
                //END;

                // após as Faturas estarem criadas faço o registo das mesmas

                //MF-TEMP,sn
                TempSalesHeader.Reset;
                if TempSalesHeader.FindSet then
                    repeat
                        SalesHeader.Reset;
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.SetRange("No.", TempSalesHeader."No.");
                        if SalesHeader.Find('-') then
                            SalesPost.Run(SalesHeader);
                    until TempSalesHeader.Next = 0;

                //Send Email's
                //if SalesHeader.Company = '' then
                //cuPostServicesET.MailFilter('');
                //

                //Normatica 2013.03.27 - a aplicação estava muito lenta porque ia percorrer todos os registos da
                //Student Ledger Entry, então coloquei um ciclo para percorrer só as faturas que se estão a registar
                TempSalesHeader.Reset;
                if TempSalesHeader.FindSet then begin
                    repeat
                        //Normatica 2013.03.27 - fim
                        StudLedgerEntry.Reset;
                        StudLedgerEntry.SetRange(StudLedgerEntry."Invoice No.", TempSalesHeader."No.");//Normatica 2013.03.27
                        if StudLedgerEntry.FindSet then begin
                            repeat
                                StudLedgerEntry.UpdateFields(StudLedgerEntry);
                            until StudLedgerEntry.Next = 0;
                        end;
                    //Normatica 2013.03.27 - inicio
                    until TempSalesHeader.Next = 0;
                end;
                //Normatica 2013.03.27 - fim
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", DMY2Date(1, optionMes + 1, Year),
                      (CalcDate('<+1M>', DMY2Date(1, optionMes + 1, Year)) - 1));

                //Test if all the Students/Entities have the necessary information to invoice before the process starts
                //This is done because in the multicompany invoicing the rollback can not be done.
                StudLedgerEntry.Reset;
                StudLedgerEntry.Copy("Student Ledger Entry");
                if StudLedgerEntry.FindSet then
                    repeat
                        rStudents.Get(StudLedgerEntry."Student No.");
                        rStudents.TestField("Payment Method Code");
                        rStudents.TestField("Payment Terms Code");
                        rStudents.TestField("Customer Posting Group");
                        rStudents.TestField("Gen. Bus. Posting Group");
                        rStudents.TestField("VAT Bus. Posting Group");

                        if StudLedgerEntry."Entity Customer No." <> '' then begin
                            rCustomer.Get(StudLedgerEntry."Entity Customer No.");
                            rCustomer.TestField("Payment Method Code");
                            rCustomer.TestField("Payment Terms Code");
                            rCustomer.TestField("Customer Posting Group");
                            rCustomer.TestField("Gen. Bus. Posting Group");
                            rCustomer.TestField("VAT Bus. Posting Group");
                        end;
                    until StudLedgerEntry.Next = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(optionMes; optionMes)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Month';
                    }
                    field(Year; Year)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Year';
                    }
                    field(getCreditMemos; getCreditMemos)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Associate credit memos';
                    }
                    field(getSalesShipLine; getSalesShipLine)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Incluir Guias de Remessa';
                    }
                    field(DataGuiaRemessa; DataGuiaRemessa)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Até à Data inclusivé';
                    }
                    field(getMontlhyPayment; getMontlhyPayment)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Só pagamentos mensais';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Year := Date2DMY(WorkDate, 3);
        Clear(TempSalesHeader);
    end;

    trigger OnPostReport()
    begin
        Message(Text0005);
    end;

    trigger OnPreReport()
    begin
        if Year = 0 then
            Error(Text0002);

        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Month);
        rDate.SetRange("Period No.", optionMes + 1);
        if rDate.Find('-') then;

        if Confirm(StrSubstNo(Text0003, rDate."Period Name", Year)) = false then begin
            Message(Text0004);
            CurrReport.Quit;
        end;

        //IF getCreditMemos THEN
        //  IF CONFIRM(Text0006) = FALSE THEN BEGIN
        //    MESSAGE(Text0004);
        //    CurrReport.QUIT;
        //  END;
    end;

    var
        Text0002: Label 'A year must be defined';
        Text0003: Label 'Billing services for the month of %1 %2. \Do you wish to proceed?';
        Text0004: Label 'Operation interrupted by the user.';
        Text0005: Label 'Process Finished';
        Text0006: Label 'You have select the option that will process corrective invoices. Do wish to proceed?';
        Text0007: Label 'Must go to this company %1 and register the invoices!';
        optionMes: Option Janeiro,Fevereiro,"Março",Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro;
        Year: Integer;
        StudLedgerEntry: Record "Student Ledger Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        SalesHeaderTEMP: Record "Sales Header" temporary;
        SalesLineTEMP: Record "Sales Line" temporary;
        TempSalesHeader: Record "Sales Header" temporary;
        SalesRecSetup: Record "Sales & Receivables Setup";
        NoSeriesCustom: Codeunit "NoSeries Custom";
        SalesPost: Codeunit "Sales-Post";
        cuPostServicesET: Codeunit "Post Services ET";
        LastCompanyName: Text[30];
        rStudents: Record Students;
        rCustomer: Record Customer;
        getCreditMemos: Boolean;
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        vCorrectedInvoiceNo: Code[20];
        LineFlag: Boolean;
        i: Integer;
        LineNo: Integer;
        rDate: Record Date;
        getSalesShipLine: Boolean;
        DataGuiaRemessa: Date;
        getMontlhyPayment: Boolean;
        StudLedgEntry: Record "Student Ledger Entry";
        rStudents2: Record Students;

    //[Scope('OnPrem')]
    procedure CreateSalesHeader()
    var
        TabCliente: Record Customer;
    begin
        // --- Nota:
        // Os serviços iram ser Vendidos ao Aluno e facturdos a(s) entidade(s) Pagadora(s)
        Clear(SalesRecSetup);
        Clear(SalesHeader);
        SalesRecSetup.Reset;
        SalesHeader.Reset;

        //IF (LastCompanyName <> "Student Ledger Entry".Company) THEN BEGIN
        //  SalesHeader.RESET;
        //  IF SalesHeader.GET(SalesHeaderTEMP."Document Type",SalesHeaderTEMP."No.") THEN
        //    SalesHeader.DELETE;
        //END;

        //IF "Student Ledger Entry".Company <> '' THEN BEGIN
        //  SalesRecSetup.CHANGECOMPANY("Student Ledger Entry".Company);
        //  MESSAGE(Text0007,"Student Ledger Entry".Company);
        ////
        //END;

        Clear(NoSeriesCustom);

        SalesRecSetup.Get;

        SalesHeader.Init;

        SalesHeader.SetHideValidationDialog(true);

        SalesHeader."No." := NoSeriesCustom.GetNextNoMultiCompany(
          SalesRecSetup."Invoice Nos.", "Student Ledger Entry"."Posting Date", true, "Student Ledger Entry".Company);
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Order Date" := WorkDate;
        SalesHeader."Posting Date" := "Student Ledger Entry"."Posting Date";
        SalesHeader."Document Date" := "Student Ledger Entry"."Posting Date";
        SalesHeader."No. Series" := SalesRecSetup."Invoice Nos.";
        SalesHeader."Posting No. Series" := SalesRecSetup."Posted Invoice Nos.";
        SalesHeader."Shipping No. Series" := SalesRecSetup."Posted Shipment Nos.";
        if "Student Ledger Entry"."Responsibility Center" <> '' then
            SalesHeader.Validate("Responsibility Center", "Student Ledger Entry"."Responsibility Center");
        SalesHeader.Validate("Sell-to Customer No.", "Student Ledger Entry"."Student Customer No.");
        SalesHeader.Validate("Bill-to Customer No.", "Student Ledger Entry"."Entity Customer No.");
        //2013.01.11 - Normatica para preencher na 21 e na 17 para depois ir para o saft
        //SalesHeader."Posting Description" := 'Fatura ' + SalesHeader."No." ;
        //IT001 - CPA - 2016.09.22 - querem o nome porque na versão anterior já tinha o nome
        if rStudents2.Get("Student Ledger Entry"."Student No.") then
            SalesHeader."Posting Description" := rStudents2."Short Name";
        //IT001 - CPA - 2016.09.22 - en

        SalesHeader."Process by Education" := true;
        //C+  Get Open Credit Memos. ESP LFM 11.01.10
        //GetOpenCreditMemos;
        //C+
        //SalesHeader.INSERT(TRUE);
        SalesHeader.Insert;

        //IF "Student Ledger Entry".Company <> '' THEN BEGIN
        //  SalesHeaderTEMP.RESET;
        //  SalesHeaderTEMP.DELETEALL;
        //  SalesHeaderTEMP.TRANSFERFIELDS(SalesHeader);
        //  SalesHeaderTEMP.INSERT;

        //  CLEAR(SalesHeader2);
        //  SalesHeader2.RESET;
        //  SalesHeader2.CHANGECOMPANY("Student Ledger Entry".Company);
        //  SalesHeader2.INIT;
        //  SalesHeader2.TRANSFERFIELDS(SalesHeader);
        //  SalesHeader2.Company := COMPANYNAME;
        //  SalesHeader2.INSERT;
        //END;

        //LastCompanyName := "Student Ledger Entry".Company;

        //IF "Student Ledger Entry".Company = '' THEN BEGIN
        TempSalesHeader.Init;
        TempSalesHeader.TransferFields(SalesHeader);
        TempSalesHeader.Insert;
        //END;
    end;

    //[Scope('OnPrem')]
    procedure CreateSalesLine()
    begin
        Clear(i);
        Clear(SalesLine);
        SalesLine.Reset;

        //IF "Student Ledger Entry".Company <> '' THEN
        //  SalesLine.CHANGECOMPANY("Student Ledger Entry".Company);

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast then
            LineNo := SalesLine."Line No."
        else
            LineNo := 0;

        //IF NOT LineFlag THEN BEGIN
        Clear(StudLedgEntry);
        StudLedgEntry.CopyFilters("Student Ledger Entry");
        StudLedgEntry.SetRange("Student No.", "Student Ledger Entry"."Student No.");
        StudLedgEntry.SetRange("Entity ID", "Student Ledger Entry"."Entity ID");
        if StudLedgEntry.FindSet then
            repeat
                SalesLine.Init;
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                if LineNo = 0 then
                    LineNo := 10000
                else
                    LineNo += 10000;

                SalesLine."Line No." := LineNo;
                SalesLine.Type := SalesLine.Type::Service;
                //    SalesLine.VALIDATE("No.", "Student Ledger Entry"."Service Code");
                //    SalesLine.Description := "Student Ledger Entry".Description;
                //    SalesLine."Description 2" := "Student Ledger Entry"."Description 2";
                //    SalesLine.VALIDATE("Sell-to Customer No.", "Student Ledger Entry"."Student Customer No.");
                //    SalesLine.VALIDATE("Bill-to Customer No.", "Student Ledger Entry"."Entity Customer No.");
                //    SalesLine.VALIDATE(Quantity, "Student Ledger Entry".Quantity);
                //    SalesLine.VALIDATE("Unit Price", ROUND("Student Ledger Entry"."Unit Price" * "Student Ledger Entry"."Percent %" / 100,0.01));
                //    SalesLine.VALIDATE("Line Amount", ROUND("Student Ledger Entry".Amount * "Student Ledger Entry"."Percent %" / 100,0.01));
                //    SalesLine.VALIDATE(Amount, ROUND("Student Ledger Entry".Amount * "Student Ledger Entry"."Percent %" / 100,0.01));
                //    SalesLine.VALIDATE("VAT Base Amount", ROUND("Student Ledger Entry"."VAT Base Amount"
                //                * "Student Ledger Entry"."Percent %" / 100,0.01));
                //    SalesLine.VALIDATE("VAT %", "Student Ledger Entry"."VAT %");
                //    SalesLine."Responsibility Center" := "Student Ledger Entry"."Responsibility Center";
                //    SalesLine."Line Discount %" := "Student Ledger Entry"."Line Discount %";
                //    SalesLine."Line Discount Amount" :=  "Student Ledger Entry"."Line Discount Amount";
                SalesLine.Validate("No.", StudLedgEntry."Service Code");
                SalesLine.Description := StudLedgEntry.Description;
                SalesLine."Description 2" := StudLedgEntry."Description 2";
                SalesLine.Validate("Sell-to Customer No.", StudLedgEntry."Student Customer No.");
                SalesLine.Validate("Bill-to Customer No.", StudLedgEntry."Entity Customer No.");
                SalesLine.Validate(Quantity, StudLedgEntry.Quantity);
                SalesLine.Validate("Unit Price", Round(StudLedgEntry."Unit Price" * StudLedgEntry."Percent %" / 100, 0.01));
                SalesLine.Validate("Line Amount", Round(StudLedgEntry.Amount * StudLedgEntry."Percent %" / 100, 0.01));
                SalesLine.Validate(Amount, Round(StudLedgEntry.Amount * StudLedgEntry."Percent %" / 100, 0.01));
                SalesLine.Validate("VAT Base Amount", Round(StudLedgEntry."VAT Base Amount"
                            * StudLedgEntry."Percent %" / 100, 0.01));
                SalesLine.Validate("VAT %", StudLedgEntry."VAT %");
                SalesLine."Responsibility Center" := StudLedgEntry."Responsibility Center";
                SalesLine."Line Discount %" := StudLedgEntry."Line Discount %";
                SalesLine."Line Discount Amount" := StudLedgEntry."Line Discount Amount";

                SalesLine.Insert;
            until (StudLedgEntry.Next = 0);

        //END ELSE BEGIN
        //  FOR i := 1 TO 2 DO BEGIN
        //    IF LineNo = 0 THEN
        //      LineNo := 10000
        //    ELSE
        //      LineNo += 10000;

        //    SalesLine.INIT;
        //    SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
        //    SalesLine."Document No." := SalesHeader."No.";
        //    SalesLine."Line No." := LineNo;
        //    SalesLine.Type := SalesLine.Type::" ";
        //    SalesLine.VALIDATE("No.",' ');
        //    IF i = 1 THEN
        //      SalesLine.Description := "Student Ledger Entry".FIELDCAPTION("Invoice No.") +' '+vCorrectedInvoiceNo
        //    ELSE
        //      SalesLine.Description := "Student Ledger Entry".FIELDCAPTION("Credit Note")+' '+SalesHeader."Applies-to Doc. No.";
        //    SalesLine.VALIDATE("Sell-to Customer No.", "Student Ledger Entry"."Student Customer No.");
        //    SalesLine.VALIDATE("Bill-to Customer No.", "Student Ledger Entry"."Entity Customer No.");
        //    SalesLine."Responsibility Center" := "Student Ledger Entry"."Responsibility Center";
        //    SalesLine.INSERT;
        //  END;
        //  LineFlag := FALSE;
        //  CreateSalesLine;
        //END;
    end;

    //[Scope('OnPrem')]
    procedure GetOpenCreditMemos()
    var
        l_rSalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        //{ Portugal não existe
        //IF getCreditMemos THEN BEGIN
        //  IF "Student Ledger Entry".Company <> '' THEN BEGIN
        //    CLEAR(rCustLedgerEntry);
        //    CLEAR(l_rSalesCrMemoHeader);
        //    rCustLedgerEntry.CHANGECOMPANY("Student Ledger Entry".Company);
        //    l_rSalesCrMemoHeader.CHANGECOMPANY("Student Ledger Entry".Company);
        //    rCustLedgerEntry.RESET;
        //    rCustLedgerEntry.SETRANGE("Customer No.","Student Ledger Entry"."Entity Customer No.");
        //    rCustLedgerEntry.SETRANGE(Open,TRUE);
        //    rCustLedgerEntry.SETRANGE("Document Type",rCustLedgerEntry."Document Type"::"Credit Memo");
        //    IF rCustLedgerEntry.FINDFIRST THEN BEGIN
        //      LineFlag := TRUE;
        //      SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::"Credit Memo";
        //      SalesHeader."Applies-to Doc. No." := rCustLedgerEntry."Document No.";
        //      l_rSalesCrMemoHeader.RESET;
        //      l_rSalesCrMemoHeader.SETRANGE("No.",rCustLedgerEntry."Document No.");
        //      IF l_rSalesCrMemoHeader.FINDFIRST THEN
        //        vCorrectedInvoiceNo := l_rSalesCrMemoHeader."Corrected Invoice No.";
        //    END ELSE
        //      LineFlag := FALSE;

        //  END ELSE BEGIN
        //    CLEAR(rCustLedgerEntry);
        //    rCustLedgerEntry.RESET;
        //    rCustLedgerEntry.SETRANGE("Customer No.","Student Ledger Entry"."Entity Customer No.");
        //    rCustLedgerEntry.SETRANGE(Open,TRUE);
        //    rCustLedgerEntry.SETRANGE("Document Type",rCustLedgerEntry."Document Type"::"Credit Memo");
        //    IF rCustLedgerEntry.FINDFIRST THEN BEGIN
        //      LineFlag := TRUE;
        //      SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::"Credit Memo";
        //      SalesHeader."Applies-to Doc. No." := rCustLedgerEntry."Document No.";
        //      l_rSalesCrMemoHeader.RESET;
        //      l_rSalesCrMemoHeader.SETRANGE("No.",rCustLedgerEntry."Document No.");
        //      IF l_rSalesCrMemoHeader.FINDFIRST THEN
        //        vCorrectedInvoiceNo := l_rSalesCrMemoHeader."Corrected Invoice No.";
        //    END ELSE
        //      LineFlag := FALSE;
        //  END;
        //END;
        //}
    end;
}

