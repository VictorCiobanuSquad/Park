xmlport 50045 "Export JDE Int. Temp Files"
{
    /*
    init 29/06/21
    */
    Caption = 'Export JDE Int. Temp Files';
    Direction = Export;
    Format = VariableText;
    UseRequestPage = false;


    schema
    {
        textelement(NodeName1)
        {
            tableelement(Integer; Integer)
            {
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));

                textelement(LegacyInvoiceTxt) { }
                textelement(LegacyDocTypeTxt) { }
                textelement(CustomerTxt) { }
                textelement(CompanyTxt) { }
                textelement(InvoiceDateTxt) { }
                textelement(GlDateTxt) { }
                textelement(LineTxt) { }
                textelement(GrossInvoiceAmountTxt) { }
                textelement(ReferenceTxt) { }
                textelement(ExplanationRemarkTxt) { }
                textelement(TaxRateTxt) { }
                textelement(TaxCodeTxt) { }
                textelement(AdvPaymentIndicatorTxt) { }
                textelement(AccountNumberTxt) { }
                textelement(AmountTxt) { }
                textelement(SubledgerTypeTxt) { }
                textelement(PupilTxt) { }

                trigger OnAfterGetRecord()
                begin
                    LegacyInvoiceTxt := LegacyInvoiceMsg;
                    LegacyDocTypeTxt := LegacyDocTypeMsg;
                    CustomerTxt := CustomerMsg;
                    CompanyTxt := CompanyMsg;
                    InvoiceDateTxt := InvoiceDateMsg;
                    GlDateTxt := GlDateMsg;
                    LineTxt := LineMsg;
                    GrossInvoiceAmountTxt := GrossInvoiceAmountMsg;
                    ReferenceTxt := ReferenceMsg;
                    ExplanationRemarkTxt := ExplanationRemarkMsg;
                    TaxRateTxt := TaxRateMsg;
                    TaxCodeTxt := TaxCodeMsg;
                    AdvPaymentIndicatorTxt := AdvPaymentIndicatorMsg;
                    AccountNumberTxt := AccountNumberMsg;
                    AmountTxt := AmountMsg;
                    SubledgerTypeTxt := SubledgerTypeMsg;
                    PupilTxt := PupilMsg;
                end;
            }
            tableelement(SalesLine; "Sales Line")
            {
                SourceTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = FILTER(Invoice | "Credit Memo"), "JDE Integrated" = CONST("Not Integrated"), Type = FILTER(<> ' '), Quantity = FILTER(<> 0));

                fieldelement(DocNo; SalesLine."Document No.") { }
                textelement(doctype) { }
                textelement(payerno) { }
                textelement(company) { }
                textelement(tInvoicedate) { }
                textelement(tGldate) { }
                textelement(lineNo) { }
                textelement(grossamount) { }
                textelement(reference) { }
                textelement(remark) { }
                textelement(taxrate) { }
                textelement(taxcode) { }
                textelement(paymentindicator) { }
                textelement(accno) { }
                textelement(lamount) { }
                textelement(A) { }
                textelement(pupilno) { }

                trigger OnPreXmlItem()
                begin
                    paymentindicator := ' ';
                end;

                trigger OnAfterGetRecord()
                begin
                    SalesDoc.GET(SalesLine."Document Type", SalesLine."Document No.");
                    //IF (NOT SalesDoc."Service Invoice") OR (SalesDoc.Status = SalesDoc.Status::Open) THEN
                    IF (NOT SalesDoc."Service Invoice") THEN
                        currXMLport.SKIP;

                    IF LastDocNo <> SalesLine."Document No." THEN
                        //lineNo := 1
                        lineNo := '1'
                    ELSE
                        //BC_UPG START SQD RTV 20220826
                        //lineNo += 1;
                        lineNo := IncStr(lineNo);
                    //BC_UPG STOP SQD RTV 20220826

                    CLEAR(VATSetup);
                    //BC_UPG START SQD RTV 20220826
                    //CLEAR(DocDim);
                    Clear(DimSet);
                    //BC_UPG STOP SQD RTV 20220826
                    CLEAR(DimValue);
                    SalesDoc.GET(SalesLine."Document Type", SalesLine."Document No.");
                    //SalesDoc.TESTFIELD(Status, SalesDoc.Status::Released);
                    IF VATSetup.GET(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") THEN;
                    IF SalesLine."Document Type" = SalesLine."Document Type"::Invoice THEN BEGIN
                        doctype := 'MB';
                        grossamount := FORMAT(SalesLine."Amount Including VAT", 0, '<Sign><Integer><Decimals,3><Comma,.>');
                        lamount := FORMAT(-SalesLine.Amount, 0, '<Sign><Integer><Decimals,3><Comma,.>');
                        VATSetup.TESTFIELD("JDE Tax Area Invoice");
                        taxrate := VATSetup."JDE Tax Area Invoice";

                        CLEAR(DimValue);

                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Park);
                        Dim.FINDFIRST;
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::Invoice, SalesLine."Document No.", SalesLine."Line No.", Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        DimSet.Get(SalesLine."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno := company + DimValue."JDE Code";

                        CLEAR(DimValue);
                        Clear(SalesHeader);         //BC_UPG SQD RTV 20220826
                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Segment);
                        Dim.FINDFIRST;
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::Invoice, "Document No.",
                        //          "Line No.", Dim.Code);
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Header", DocDim."Document Type"::Invoice, SalesLine."Document No.", 0, Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                        DimSet.Get(SalesHeader."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno += DimValue."JDE Code" + '.';

                        CLEAR(DimValue);
                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::"Cost Center");
                        Dim.FINDFIRST;
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::Invoice, SalesLine."Document No.", SalesLine."Line No.", Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        DimSet.Get(SalesLine."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno += DimValue."JDE Code";
                    END ELSE BEGIN
                        doctype := 'MD';
                        grossamount := FORMAT(-SalesLine."Amount Including VAT", 0, '<Sign><Integer><Decimals,3><Comma,.>');
                        lamount := FORMAT(SalesLine.Amount, 0, '<Sign><Integer><Decimals,3><Comma,.>');
                        VATSetup.TESTFIELD("JDE Tax Area Cr.Memo");
                        taxrate := VATSetup."JDE Tax Area Cr.Memo";

                        CLEAR(DimValue);
                        //IF DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", "Document No.", "Line No.", 'SEGMENTOS') THEN
                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Park);
                        Dim.FINDFIRST;
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", SalesLine."Document No.", SalesLine."Line No.", Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        DimSet.Get(SalesLine."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno := company + DimValue."JDE Code";

                        CLEAR(DimValue);
                        Clear(SalesHeader);         //BC_UPG SQD RTV 20220826
                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Segment);
                        Dim.FINDFIRST;
                        //IF DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", "Document No.", "Line No.", 'PARK') THEN
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", "Document No.",
                        //          "Line No.", Dim.Code);
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Header", DocDim."Document Type"::"Credit Memo", SalesLine."Document No.", 0, Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                        DimSet.Get(SalesHeader."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno += DimValue."JDE Code" + '.';

                        CLEAR(DimValue);
                        Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::"Cost Center");
                        Dim.FINDFIRST;
                        //IF DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", "Document No.", "Line No.", 'PROFITCENTER') THEN
                        //BC_UPG START SQD RTV 20220826
                        //DocDim.GET(DATABASE::"Sales Line", DocDim."Document Type"::"Credit Memo", SalesLine."Document No.", SalesLine."Line No.", Dim.Code);
                        //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                        DimSet.Get(SalesLine."Dimension Set ID", Dim.Code);
                        DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                        //BC_UPG STOP SQD RTV 20220826
                        DimValue.TESTFIELD("JDE Code");
                        accno += DimValue."JDE Code";
                    END;
                    Cust.GET(SalesDoc."Bill-to Customer No.");
                    Cust.TESTFIELD("JDE Payer No.");
                    payerno := Cust."JDE Payer No.";
                    invoicedate := SalesDoc."Posting Date";
                    gldate := CALCDATE('<CM>', SalesDoc."Posting Date");
                    /*
                    IF DATE2DMY(SalesDoc."Posting Date", 2) = 12 THEN
                        gldate := CALCDATE('-1D', DMY2DATE(1, 1, DATE2DMY(SalesDoc."Posting Date", 3)))
                    ELSE
                        gldate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(SalesDoc."Posting Date", 2), DATE2DMY(SalesDoc."Posting Date", 3)));
                    */
                    tInvoicedate := FORMAT(invoicedate, 0, '<Day,2>/<Month,2>/<Year4>');
                    tGldate := FORMAT(gldate, 0, '<Day,2>/<Month,2>/<Year4>');

                    IF SalesLine."Description 2" = '' THEN
                        remark := SalesLine.Description
                    ELSE
                        remark := SalesLine.Description + ' ' + SalesLine."Description 2";
                    remark := Convert.Ascii2Ansi(remark);
                    taxcode := 'V';
                    Cust.GET(SalesDoc."Sell-to Customer No.");
                    pupilno := Cust."JDE Pupil No.";
                    reference := '.';

                    LastDocNo := SalesLine."Document No.";


                    CLEAR(Log);
                    Log.INIT;
                    IF SalesLine."Document Type" = SalesLine."Document Type"::Invoice THEN
                        Log.Type := Log.Type::"Temp. Invoice"
                    ELSE
                        Log.Type := Log.Type::"Temp. Credit Memo";
                    Log."Document No." := SalesLine."Document No.";
                    Log.Filename := FileNameTxt;
                    Log."Integration Time" := CREATEDATETIME(TODAY, TIME);
                    Log.INSERT;
                    SalesLine.VALIDATE("JDE Integrated", SalesLine."JDE Integrated"::Integrated);
                    SalesLine.MODIFY(FALSE);
                    SalesDoc.VALIDATE("JDE Integrated", SalesLine."JDE Integrated"::Integrated);
                    SalesDoc.MODIFY(FALSE);
                end;
            }
        }
    }

    var
        docno: Text[30];
        invoicedate: Date;
        gldate: Date;
        Cust: Record Customer;
        CompanyInfo: Record "Company Information";
        SalesDoc: Record "Sales Header";
        Group: Record "General Posting Setup";
        Log: Record "JDE Integration Log";
        Setup: Record "General Ledger Setup";
        IntNo: Text[2];
        //DocDim: Record "Document Dimension";
        DimSet: Record "Dimension Set Entry";
        VATSetup: Record "VAT Posting Setup";
        DimValue: Record "Dimension Value";
        Convert: Codeunit "Ansi Ascii";
        Dim: Record Dimension;
        LastDocNo: Text[30];
        FileNameTxt: Text[30];
        LegacyInvoiceMsg: Label 'Legacy Invoice';
        LegacyDocTypeMsg: Label 'Legacy Doc Type';
        CustomerMsg: Label 'Customer';
        CompanyMsg: Label 'Company';
        InvoiceDateMsg: Label 'Invoice Date';
        GlDateMsg: Label 'G/L Date';
        LineMsg: Label 'Line';
        GrossInvoiceAmountMsg: Label 'Gross (Invoice) Amount';
        ReferenceMsg: Label 'Reference';
        ExplanationRemarkMsg: Label 'Explanation/Remark';
        TaxRateMsg: Label 'Tax Rate';
        TaxCodeMsg: Label 'Tax Code';
        AdvPaymentIndicatorMsg: Label 'Adv Payment Indicator';
        AccountNumberMsg: Label 'Account Number';
        AmountMsg: Label 'Amount';
        SubledgerTypeMsg: Label 'Subledger Type';
        PupilMsg: Label 'Pupil';
        SalesHeader: Record "Sales Header";

    trigger OnPreXmlPort()
    begin
        CompanyInfo.GET;
        company := CompanyInfo."JDE Entity Number";
        docno := '';
        paymentindicator := '';
        A := 'A';
        Setup.GET;
        IF Setup."Last Doc Integration Date" <> TODAY THEN BEGIN
            Setup.VALIDATE("Last Doc Integration Date", TODAY);
            IntNo := '01';
        END ELSE
            IntNo := INCSTR(Setup."Last Doc Integration No.");
        Setup.VALIDATE("Last Doc Integration No.", IntNo);
        Setup.MODIFY;
        Setup.TESTFIELD("JDE File Path");

        FileNameTxt := CompanyInfo."JDE Entity Number" +
                                 FORMAT(TODAY, 0, '<Day,2><Month,2><Year,2>') + IntNo + '.csv';

        CurrXMLport.FILENAME := Setup."JDE File Path" + FileNameTxt;
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Exportação terminada');
    end;
}