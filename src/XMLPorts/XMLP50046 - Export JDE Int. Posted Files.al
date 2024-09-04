xmlport 50046 "Export JDE Int. Posted Files"
{
    /*
    init 29/06/21
    */
    Caption = 'Export JDE Int. Posted Files';
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
            tableelement(SalesInvLine; "Sales Invoice Line")
            {
                SourceTableView = SORTING("Document No.", "Line No.", "PTSS Not in VAT Report") WHERE("JDE Integrated" = CONST("Not Integrated"), Type = FILTER(<> ' '), Quantity = FILTER(<> 0));

                fieldelement(DocNo; SalesInvLine."Document No.") { }
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

                trigger OnAfterGetRecord()
                begin

                    CLEAR(VATSetup);
                    //BC_UPG START SQD RTV 20220826
                    //CLEAR(DocDim);
                    Clear(DimSet);
                    //BC_UPG STOP SQD RTV 20220826
                    CLEAR(DimValue);
                    Header.GET(SalesInvLine."Document No.");
                    doctype := 'MI';
                    grossamount := FORMAT(SalesInvLine."Amount Including VAT", 0, '<Sign><Integer><Decimals,3><Comma,.>');
                    lamount := FORMAT(-SalesInvLine.Amount, 0, '<Sign><Integer><Decimals,3><Comma,.>');

                    IF LastDocNo <> SalesInvLine."Document No." THEN
                        lineNo := '1'
                    ELSE
                        //BC_UPG START SQD RTV 20220826
                        //lineNo += 1;
                        lineNo := IncStr(lineNo);
                    //BC_UPG STOP SQD RTV 20220826

                    Cust.GET(Header."Bill-to Customer No.");
                    Cust.TESTFIELD("JDE Payer No.");
                    payerno := Cust."JDE Payer No.";

                    invoicedate := Header."Posting Date";
                    gldate := CALCDATE('<CM>', Header."Posting Date");
                    /*
                    IF DATE2DMY(Header."Posting Date", 2) = 12 THEN
                                            gldate := CALCDATE('-1D', DMY2DATE(1, 1, DATE2DMY(Header."Posting Date", 3)))
                                        ELSE
                                            gldate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(Header."Posting Date", 2), DATE2DMY(Header."Posting Date", 3)));
                    */
                    tInvoicedate := FORMAT(invoicedate, 0, '<Day,2>/<Month,2>/<Year4>');
                    tGldate := FORMAT(gldate, 0, '<Day,2>/<Month,2>/<Year4>');
                    reference := Header."No. Series";
                    IF SalesInvLine."Description 2" = '' THEN
                        remark := SalesInvLine.Description
                    ELSE
                        remark := SalesInvLine.Description + ' ' + SalesInvLine."Description 2";
                    remark := Convert.Ascii2Ansi(remark);
                    IF VATSetup.GET(SalesInvLine."VAT Bus. Posting Group", SalesInvLine."VAT Prod. Posting Group") THEN;
                    taxrate := VATSetup."JDE Tax Area Invoice";
                    taxcode := 'V';

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Park);
                    Dim.FINDFIRST;
                    //BC_UPG START SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Invoice Line", "Document No.", "Line No.", Dim.Code);
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(SalesInvLine."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno := company + DimValue."JDE Code";

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Segment);
                    Dim.FINDFIRST;
                    //BC_UPG START SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Invoice Line", "Document No.", "Line No.", Dim.Code);
                    //DocDim.GET(DATABASE::"Sales Invoice Header", "Document No.", 0, Dim.Code);
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(Header."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno += DimValue."JDE Code" + '.';

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::"Cost Center");
                    Dim.FINDFIRST;
                    //BC_UPG START SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Invoice Line", "Document No.", "Line No.", Dim.Code);
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(SalesInvLine."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno += DimValue."JDE Code";

                    Cust.GET(Header."Sell-to Customer No.");

                    Cust.TESTFIELD("JDE Pupil No.");
                    pupilno := Cust."JDE Pupil No.";

                    LastDocNo := SalesInvLine."Document No.";


                    CLEAR(Log);
                    Log.INIT;
                    Log.Type := Log.Type::"Posted Invoice";
                    Log."Document No." := SalesInvLine."Document No.";
                    Log.Filename := FileNameTxt;
                    Log."Integration Time" := CREATEDATETIME(TODAY, TIME);
                    Log.INSERT;
                    SalesInvLine.VALIDATE("JDE Integrated", SalesInvLine."JDE Integrated"::Integrated);
                    SalesInvLine.MODIFY(FALSE);
                    Header.VALIDATE("JDE Integrated", Header."JDE Integrated"::Integrated);
                    Header.MODIFY(FALSE);
                end;
            }
            tableelement(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                SourceTableView = SORTING("Document No.", "Line No.", "PTSS Not in VAT Report") WHERE("JDE Integrated" = CONST("Not Integrated"), Type = FILTER(<> ' '), Quantity = FILTER(<> 0));

                fieldelement(DocNo; SalesCrMemoLine."Document No.") { }
                textelement(doctype2) { }
                textelement(payerno2) { }
                textelement(company2) { }
                textelement(tInvoicedate2) { }
                textelement(tGldate2) { }
                textelement(lineNo2) { }
                textelement(grossamount2) { }
                textelement(reference2) { }
                textelement(remark2) { }
                textelement(taxrate2) { }
                textelement(taxcode2) { }
                textelement(paymentindicator2) { }
                textelement(accno2) { }
                textelement(lamount2) { }
                textelement(A2) { }
                textelement(pupilno2) { }

                trigger OnAfterGetRecord()
                begin

                    CLEAR(VATSetup);
                    //BC_UPG START SQD RTV 20220826
                    //CLEAR(DocDim);
                    Clear(DimSet);
                    //BC_UPG STOP SQD RTV 20220826
                    CLEAR(DimValue);
                    CreditHeader.GET(SalesCrMemoLine."Document No.");
                    doctype2 := 'MC';
                    grossamount := FORMAT(-SalesCrMemoLine."Amount Including VAT", 0, '<Sign><Integer><Decimals,3><Comma,.>');
                    lamount2 := FORMAT(SalesCrMemoLine.Amount, 0, '<Sign><Integer><Decimals,3><Comma,.>');

                    IF LastDocNo <> SalesCrMemoLine."Document No." THEN
                        lineNo2 := '1'
                    ELSE
                        //BC_UPG START SQD RTV 20220826
                        //lineNo += 1;
                        lineNo2 := IncStr(lineNo2);
                    //BC_UPG STOP SQD RTV 20220826

                    Cust.GET(CreditHeader."Bill-to Customer No.");
                    Cust.TESTFIELD("JDE Payer No.");
                    payerno2 := Cust."JDE Payer No.";

                    invoicedate := CreditHeader."Posting Date";
                    gldate := CALCDATE('<CM>', CreditHeader."Posting Date");
                    /*
                    IF DATE2DMY(CreditHeader."Posting Date", 2) = 12 THEN
                                            gldate := CALCDATE('-1D', DMY2DATE(1, 1, DATE2DMY(CreditHeader."Posting Date", 3)))
                                        ELSE
                                            gldate := CALCDATE('-1D', DMY2DATE(1, DATE2DMY(CreditHeader."Posting Date", 2), DATE2DMY(CreditHeader."Posting Date", 3)));
                    */
                    tInvoicedate2 := FORMAT(invoicedate, 0, '<Day,2>/<Month,2>/<Year4>');
                    tGldate2 := FORMAT(gldate, 0, '<Day,2>/<Month,2>/<Year4>');
                    reference2 := CreditHeader."No. Series";
                    IF SalesCrMemoLine."Description 2" = '' THEN
                        remark2 := SalesCrMemoLine.Description
                    ELSE
                        remark2 := SalesCrMemoLine.Description + ' ' + SalesCrMemoLine."Description 2";
                    remark2 := Convert.Ascii2Ansi(remark2);
                    IF VATSetup.GET(SalesCrMemoLine."VAT Bus. Posting Group", SalesCrMemoLine."VAT Prod. Posting Group") THEN;
                    taxrate2 := VATSetup."JDE Tax Area Cr.Memo";
                    taxcode2 := 'V';

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Park);
                    Dim.FINDFIRST;
                    //BC_UPG START SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Cr.Memo Line", "Document No.", "Line No.", Dim.Code);
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(SalesCrMemoLine."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno2 := company2 + DimValue."JDE Code";

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::Segment);
                    Dim.FINDFIRST;
                    //DocDim.GET(DATABASE::"Sales Cr.Memo Header", "Document No.", 0, Dim.Code);        //BC_UPG SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Cr.Memo Line", "Document No.", "Line No.", Dim.Code);
                    //BC_UPG START SQD RTV 20220826
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(CreditHeader."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno2 += DimValue."JDE Code" + '.';

                    CLEAR(DimValue);
                    Dim.SETRANGE("Dimension Type", Dim."Dimension Type"::"Cost Center");
                    Dim.FINDFIRST;
                    //BC_UPG START SQD RTV 20220826
                    //DocDim.GET(DATABASE::"Sales Cr.Memo Line", "Document No.", "Line No.", Dim.Code);
                    //DimValue.GET(Dim.Code, DocDim."Dimension Value Code");
                    DimSet.Get(SalesCrMemoLine."Dimension Set ID", Dim.Code);
                    DimValue.Get(Dim.Code, DimSet."Dimension Value Code");
                    //BC_UPG STOP SQD RTV 20220826
                    DimValue.TESTFIELD("JDE Code");
                    accno2 += DimValue."JDE Code";

                    Cust.GET(CreditHeader."Sell-to Customer No.");
                    Cust.TESTFIELD("JDE Pupil No.");
                    pupilno2 := Cust."JDE Pupil No.";

                    LastDocNo := SalesCrMemoLine."Document No.";


                    CLEAR(Log);
                    Log.INIT;
                    Log.Type := Log.Type::"Posted Credit Memo";
                    Log."Document No." := SalesCrMemoLine."Document No.";
                    Log.Filename := FileNameTxt;
                    Log."Integration Time" := CREATEDATETIME(TODAY, TIME);
                    Log.INSERT;
                    SalesCrMemoLine.VALIDATE("JDE Integrated", SalesCrMemoLine."JDE Integrated"::Integrated);
                    SalesCrMemoLine.MODIFY(FALSE);
                    CreditHeader.VALIDATE("JDE Integrated", CreditHeader."JDE Integrated"::Integrated);
                    CreditHeader.MODIFY(FALSE);
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
        Header: Record "Sales Invoice Header";
        CreditHeader: Record "Sales Cr.Memo Header";
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

    trigger OnPreXmlPort()
    begin
        CompanyInfo.GET;
        company := CompanyInfo."JDE Entity Number";
        company2 := CompanyInfo."JDE Entity Number";            //BC_UPG SQD RTV 20220826
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

        paymentindicator := ' ';
    end;

    trigger OnPostXmlPort()
    begin
        MESSAGE('Exportação terminada');
    end;
}