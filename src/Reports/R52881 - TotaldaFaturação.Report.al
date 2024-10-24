report 52881 "Total da Faturação"
{
    //  Listagem de Faturas registadas
    DefaultLayout = RDLC;
    RDLCLayout = './TotaldaFaturação.rdlc';


    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("Document No.", "Line No.");
            RequestFilterFields = "Posting Date";
            column(FiltroData; FiltroData)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(nomeescola; nomeescola)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Amount_Including_VAT_; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Sales_Invoice_Line__Line_Discount_Amount_; "Line Discount Amount")
            {
            }
            column(TotalIliq; TotalIliq)
            {
            }
            column(NomeAluno; NomeAluno)
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Sell_to_Customer_No__; "Sales Invoice Line"."Sell-to Customer No.")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Document_No__; "Sales Invoice Line"."Document No.")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Posting_Date_; "Sales Invoice Line"."Posting Date")
            {
            }
            column(ValorNC; ValorNC)
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Amount_Including_VAT__Control1101490034; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Sales_Invoice_Line__Line_Discount_Amount__Control1101490035; "Line Discount Amount")
            {
            }
            column(TotalGlobalLiq; TotalGlobalLiq)
            {
            }
            column(Text0004_________FORMAT_TotalRegistos_; Text0004 + ' ' + Format(TotalRegistos))
            {
            }
            column(TotalNC; TotalNC)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(DescontosCaption; DescontosCaptionLbl)
            {
            }
            column("IlíquidoCaption"; IlíquidoCaptionLbl)
            {
            }
            column(NomeCaption; NomeCaptionLbl)
            {
            }
            column(N__AlunoCaption; N__AlunoCaptionLbl)
            {
            }
            column(N__FaturaCaption; N__FaturaCaptionLbl)
            {
            }
            column(DataCaption; DataCaptionLbl)
            {
            }
            column(N__CreditoCaption; N__CreditoCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column("Total_FaturaçãoCaption"; Total_FaturaçãoCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TOTAIS__Caption; TOTAIS__CaptionLbl)
            {
            }
            column(Sales_Invoice_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                tempSalesInvLine: Record "Sales Invoice Line";
                boolCalc: Boolean;
            begin
                if Aluno.Get("Sales Invoice Line"."Bill-to Customer No.") then
                    NomeAluno := Aluno.Name
                else
                    NomeAluno := '';

                // SalesInvoiceLine GroupFooter, starttest
                boolCalc := false;
                tempSalesInvLine.Reset;
                tempSalesInvLine := "Sales Invoice Line";
                if tempSalesInvLine.Next = 0 then begin
                    boolCalc := true;
                end
                else begin
                    if tempSalesInvLine."Document No." <> "Document No." then
                        boolCalc := true;
                end;
                if boolCalc then begin
                    TotalGlobalLiq := TotalGlobalLiq + TotalIliq;
                    TotalRegistos := TotalRegistos + 1;
                    //*********************************
                    //Calcular as Notas de credito associadas à fatura
                    Clear(ValorNC);
                    CustLegEntry.Reset;
                    CreateCustLedgEntry.Reset;
                    CreateCustLedgEntry.SetRange(CreateCustLedgEntry."Document Type", CreateCustLedgEntry."Document Type"::Invoice);
                    CreateCustLedgEntry.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    if CreateCustLedgEntry.FindSet then begin
                        //with CustLegEntry do begin
                        FindApplnEntriesDtldtLedgEntry;
                        CustLegEntry.SetCurrentKey("Entry No.");
                        CustLegEntry.SetRange("Entry No.");
                        if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
                            CustLegEntry."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
                            Mark(true);
                        end;
                        CustLegEntry.SetCurrentKey("Closed by Entry No.");
                        CustLegEntry.SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
                        if Find('-') then
                            repeat
                                Mark(true);
                            until Next = 0;
                        CustLegEntry.SetCurrentKey("Entry No.");
                        CustLegEntry.SetRange("Closed by Entry No.");
                    end;
                    CustLegEntry.MarkedOnly(true);
                    if CustLegEntry.FindSet then begin
                        repeat
                            if CustLegEntry."Document Type" = CustLegEntry."Document Type"::"Credit Memo" then begin
                                CustLegEntry.CalcFields(CustLegEntry.Amount);
                                ValorNC := ValorNC + Abs(CustLegEntry.Amount);
                                TotalNC := TotalNC + Abs(CustLegEntry.Amount);
                            end;
                        until CustLegEntry.Next = 0;
                    end;
                end;
            end;
            // SalesInvoiceLine GroupFooter,  endtest
            //end;
        }
    }

    requestpage
    {

        layout
        {
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
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);

        rSchool.Reset;
        if rSchool.Find('-') then
            nomeescola := rSchool."School Name";
    end;

    trigger OnPreReport()
    begin

        if "Sales Invoice Line".GetFilter("Posting Date") <> '' then
            FiltroData := Text0001 + "Sales Invoice Line".GetFilter("Posting Date");
    end;

    var
        CompanyInformation: Record "Company Information";
        Aluno: Record Customer;
        rSchool: Record School;
        FiltroData: Text[50];
        Text0001: Label 'Faturas registadas: ';
        Text0002: Label 'Turma: ';
        Text0004: Label 'Nº de documentos emitidos:';
        TotalIliq: Decimal;
        TotalGlobalLiq: Decimal;
        NomeAluno: Text[250];
        TotalRegistos: Integer;
        CustLegEntry: Record "Cust. Ledger Entry";
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        ValorNC: Decimal;
        TotalNC: Decimal;
        nomeescola: Text[128];
        TotalCaptionLbl: Label 'Total';
        DescontosCaptionLbl: Label 'Descontos';
        "IlíquidoCaptionLbl": Label 'Ilíquido';
        NomeCaptionLbl: Label 'Nome';
        N__AlunoCaptionLbl: Label 'Nº Aluno';
        N__FaturaCaptionLbl: Label 'Nº Fatura';
        DataCaptionLbl: Label 'Data';
        N__CreditoCaptionLbl: Label 'N. Credito';
        FiltersCaptionLbl: Label 'Filters';
        "Total_FaturaçãoCaptionLbl": Label 'Total Faturação';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TOTAIS__CaptionLbl: Label 'TOTAIS: ';


    procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then begin
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                  DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then begin
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                              DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                CustLegEntry.SetCurrentKey("Entry No.");
                                CustLegEntry.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if CustLegEntry.Find('-') then
                                    CustLegEntry.Mark(true);
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                    end;
                end else begin
                    CustLegEntry.SetCurrentKey("Entry No.");
                    CustLegEntry.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if CustLegEntry.Find('-') then
                        CustLegEntry.Mark(true);
                end;
            until DtldCustLedgEntry1.Next = 0;
        end;
    end;
}

