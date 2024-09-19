page 50025 "Devolucoes Ficha Cab"
{
    /*
    //IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093
    //IT011 - Park - Preço do produto à data da fatua - 2018.01.30 - pedido 1098
    //IT012 - Park - 2018.06.14 - Mudar texto registo
    */
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Devolucoes Cab";
    Caption = 'Ficha Devolução';
    DataCaptionFields = "No.", "Sell-to Customer No.", "Sell-to Customer Name";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Caption = 'No';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell to Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Sell to Customer Name';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    Caption = 'Invoice No.';
                    ApplicationArea = All;
                }

            }
            part("Devolucoes Ficha Linhas"; "Devolucoes Ficha Linhas")
            {
                Editable = false;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    Customer: Record Customer;
                    SalesReceivSetup: Record "Sales & Receivables Setup";
                    //NoSeriesMgm: Codeunit NoSeriesManagement;
                    Cu_NoSeries: Codeunit "No. Series";
                    DevolucoesLinha: Record "Devolucoes Linhas";
                    NoSeries: Record "No. Series";
                    CustLedEntry: Record "Cust. Ledger Entry";
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvLine: Record "Sales Invoice Line";
                    ArchiveManagement: Codeunit ArchiveManagement;
                    DimMgt: Codeunit DimensionManagement;
                    ValueEntry: Record "Value Entry";
                    NLinha: Integer;
                    Text001: Label 'Foi criada a devolução %1.';
                    Text002: Label 'Nota Crédito';
                    Text003: Label 'Nº Fatura %1:';
                    Text004: Label 'Nº Fatura %1 - Nº Envio %2:';
                    Text006: Label '"NC refrente à FT "';
                    Text007: Label '"Credit Note for Invoice "';
                begin
                    //IT001 - 2017.04.06 - Passar de encomenda temporária para definitiva

                    Customer.RESET;
                    IF Customer.GET(Rec."Sell-to Customer No.") THEN
                        Customer.TESTFIELD(Customer."Location Code");

                    SalesReceivSetup.RESET;
                    IF SalesReceivSetup.GET THEN;


                    SalesHeader.INIT;
                    SalesHeader."Origem Portal Fardas" := TRUE;
                    SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                    //SalesHeader."No." := NoSeriesMgm.GetNextNo(SalesReceivSetup."Credit Memo Nos.", WORKDATE, TRUE);
                    //TODO: to test NoSeries
                    SalesHeader."No." := Cu_NoSeries.GetNextNo(SalesReceivSetup."Credit Memo Nos.", WORKDATE, TRUE);

                    SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
                    SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", Rec."Sell-to Customer No.");
                    SalesHeader."Portal Created by" := Rec."Created by";  //IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093
                    SalesHeader.INSERT;
                    IF SalesInvHeader.GET(Rec."Invoice No.") THEN BEGIN
                        SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", SalesInvHeader."Bill-to Customer No.");
                        SalesHeader.VALIDATE("Order Date", SalesInvHeader."Order Date");
                        SalesHeader.VALIDATE("Prices Including VAT", SalesInvHeader."Prices Including VAT");
                        SalesHeader.VALIDATE("Payment Method Code", SalesInvHeader."Payment Method Code");
                        SalesHeader.VALIDATE("Direct Debit Mandate ID", SalesInvHeader."Direct Debit Mandate ID");
                        SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
                        SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 2 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                        SalesHeader."External Document No." := Rec."Invoice No.";

                        CustLedEntry.RESET;
                        CustLedEntry.SETRANGE(CustLedEntry."Customer No.", SalesInvHeader."Bill-to Customer No.");
                        CustLedEntry.SETRANGE(CustLedEntry."Document Type", CustLedEntry."Document Type"::Invoice);
                        CustLedEntry.SETRANGE(CustLedEntry."Document No.", Rec."Invoice No.");
                        CustLedEntry.SETRANGE(CustLedEntry.Open, TRUE);
                        IF CustLedEntry.FINDFIRST THEN BEGIN
                            SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
                            SalesHeader.VALIDATE(SalesHeader."Applies-to Doc. No.", Rec."Invoice No.");
                        END;
                    END;

                    SalesHeader."Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header", SalesHeader."Document Type"::"Credit Memo", SalesHeader."No.");
                    SalesHeader."PTSS Shipment Start Time" := 235900T;
                    SalesHeader."Posting Description" := Text002;
                    SalesHeader."No. Series" := SalesReceivSetup."Credit Memo Nos.";
                    IF NoSeries.GET(SalesReceivSetup."Credit Memo Nos.") THEN
                        SalesHeader."Posting No. Series" := NoSeries."Registed Nos.";

                    SalesHeader.VALIDATE(SalesHeader."Document Date", Rec.Date);

                    //IT012 - Park - 2018.06.14 - Mudar texto registo, sn
                    IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND (Rec."Invoice No." <> '') THEN BEGIN
                        IF (SalesHeader."Language Code" = 'PTG') OR (SalesHeader."Language Code" = '') THEN
                            SalesHeader."Posting Description" := Text006 + Rec."Invoice No."
                        ELSE
                            SalesHeader."Posting Description" := Text007 + Rec."Invoice No.";
                    END;
                    //IT012 - Park - 2018.06.14 - Mudar texto registo, en

                    SalesHeader.MODIFY;

                    NLinha := 10000;

                    //Inserção de textos
                    SalesLine.INIT;
                    SalesLine.VALIDATE(SalesLine."Document Type", SalesLine."Document Type"::"Credit Memo");
                    SalesLine.VALIDATE(SalesLine."Document No.", SalesHeader."No.");
                    SalesLine.VALIDATE(SalesLine."Line No.", NLinha);
                    SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", DevolucoesLinha."Sell-to Customer No.");
                    SalesLine.VALIDATE(SalesLine.Type, 0);
                    SalesLine.VALIDATE(SalesLine.Description, STRSUBSTNO(Text003, Rec."Invoice No."));
                    SalesLine.INSERT;
                    NLinha := NLinha + 10000;
                    SalesLine.INIT;
                    SalesLine.VALIDATE(SalesLine."Document Type", SalesLine."Document Type"::"Credit Memo");
                    SalesLine.VALIDATE(SalesLine."Document No.", SalesHeader."No.");
                    SalesLine.VALIDATE(SalesLine."Line No.", NLinha);
                    SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", DevolucoesLinha."Sell-to Customer No.");
                    SalesLine.VALIDATE(SalesLine.Type, 0);
                    SalesLine.VALIDATE(SalesLine.Description, SalesInvHeader."Order No.");
                    SalesLine.INSERT;

                    //Inserção dos produtos
                    DevolucoesLinha.RESET;
                    DevolucoesLinha.SETRANGE(DevolucoesLinha."No.", Rec."No.");
                    IF DevolucoesLinha.FINDSET THEN BEGIN
                        REPEAT
                            NLinha := NLinha + 10000;
                            SalesLine.INIT;
                            SalesLine.VALIDATE(SalesLine."Document Type", SalesLine."Document Type"::"Credit Memo");
                            SalesLine.VALIDATE(SalesLine."Document No.", SalesHeader."No.");
                            SalesLine.VALIDATE(SalesLine."Line No.", NLinha);
                            SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", DevolucoesLinha."Sell-to Customer No.");
                            SalesLine.INSERT;
                            SalesLine.VALIDATE(SalesLine.Type, SalesLine.Type::Item);
                            SalesLine.VALIDATE(SalesLine."No.", DevolucoesLinha."Item No.");
                            SalesLine.VALIDATE(SalesLine."Variant Code", DevolucoesLinha."Variant Code");
                            SalesLine.VALIDATE(SalesLine.Quantity, DevolucoesLinha.Quantity);
                            SalesLine.VALIDATE("Return Reason Code", DevolucoesLinha."Return Reason Code"); //ReasonCode
                            SalesInvLine.RESET;
                            SalesInvLine.SETRANGE(SalesInvLine."Document No.", Rec."Invoice No.");
                            SalesInvLine.SETRANGE(SalesInvLine."Line No.", DevolucoesLinha."Sales Invoice Line");
                            IF SalesInvLine.FINDFIRST THEN BEGIN
                                SalesLine.VALIDATE(SalesLine."Shortcut Dimension 1 Code", SalesInvLine."Shortcut Dimension 1 Code");
                                SalesLine.VALIDATE(SalesLine."Shortcut Dimension 2 Code", SalesInvLine."Shortcut Dimension 2 Code");
                                //IT011 - Park - Preço do produto à data da fatua - 2018.01.30 - pedido 1098
                                SalesLine.VALIDATE(SalesLine."Unit Price", SalesInvLine."Unit Price");
                                //IT011 - Park -en
                            END;
                            ValueEntry.RESET;
                            ValueEntry.SETRANGE(ValueEntry."Document Type", ValueEntry."Document Type"::"Sales Invoice");
                            ValueEntry.SETRANGE(ValueEntry."Document No.", Rec."Invoice No.");
                            ValueEntry.SETRANGE(ValueEntry."Document Line No.", DevolucoesLinha."Sales Invoice Line");
                            IF ValueEntry.FINDFIRST THEN
                                SalesLine."Appl.-from Item Entry" := ValueEntry."Item Ledger Entry No.";
                            SalesLine.MODIFY;
                        UNTIL DevolucoesLinha.NEXT = 0;
                    END;

                    MESSAGE(STRSUBSTNO(Text001, SalesHeader."No."));

                    //Apagar a encomenda Temporaria
                    Rec.DELETE(TRUE);
                end;
            }
        }
    }
}