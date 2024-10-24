table 53011 "Devolucoes Cab"
{
    // IT010 - Park - Novo campo Portal Created by - 2018.01.30 - pedido 1093
    // 
    // IT011 - Park - Preço do produto à data da fatua - 2018.01.30 - pedido 1098
    // 
    // IT012 - Park - 2018.06.14 - Mudar texto registo


    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No. Dev.';
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Venda a Cliente No.';
            TableRelation = Customer."No.";
        }
        field(6; "Sell-to Customer Name"; Text[128])
        {
            Caption = 'Nome Cliente';
        }
        field(8; Date; Date)
        {
            Caption = 'Data';
        }
        field(10; "Invoice No."; Code[20])
        {
            Caption = 'No. Fatura';
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(20; Created; DateTime)
        {
            Caption = 'Criação';
        }
        field(21; "Created by"; Text[250])
        {
            Caption = 'User Criação';
        }
        field(22; Modified; DateTime)
        {
            Caption = 'Modificação';
        }
        field(23; "Modified by"; Text[250])
        {
            Caption = 'User Modificação';
        }
        field(24; Pick; Boolean)
        {
            Caption = 'Select';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DevolucaoLinhas.RESET;
        DevolucaoLinhas.SETRANGE(DevolucaoLinhas."No.", "No.");
        DevolucaoLinhas.DELETEALL;
    end;

    var
        ReturnHeader: Record "Devolucoes Cab";
        DevolucaoLinhas: Record "Devolucoes Linhas";
        Text001: Label 'Return created %1';
        Text002: Label 'Credit Memo';
        Text003: Label 'Invoice No. %1';
        Text004: Label 'Invoice No. %1 - Send No. %2.';
        ReturnHeader2: Record "Devolucoes Cab";
        CopyText: Text[250];
        Text005: Label 'Returns created: %1.';
        Text006: Label 'NC refrente à FT ';
        Text007: Label 'Credit Note for Invoice ';


    procedure SelectAll()
    begin
        MODIFYALL(Pick, TRUE);
    end;


    procedure UnSelectAll()
    begin
        MODIFYALL(Pick, FALSE);
    end;


    procedure CountMarkReturns(): Integer
    begin
        ReturnHeader2.RESET;
        ReturnHeader2.SETRANGE(Pick, TRUE);
        EXIT(ReturnHeader2.COUNT);
    end;


    procedure PickReturnCreate()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        SalesReceivSetup: Record "Sales & Receivables Setup";
        NoSeriesMgm: Codeunit "No. Series";
        DevolucoesLinha: Record "Devolucoes Linhas";
        NoSeries: Record "No. Series";
        CustLedEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        ArchiveManagement: Codeunit ArchiveManagement;
        DimMgt: Codeunit DimensionManagement;
        ValueEntry: Record "Value Entry";
        NLinha: Integer;
        CountReturns: Integer;
    begin
        CountReturns := 0;
        ReturnHeader.RESET;
        ReturnHeader.SETRANGE(Pick, TRUE);
        IF ReturnHeader.FINDSET THEN
            REPEAT
                Customer.RESET;
                IF Customer.GET("Sell-to Customer No.") THEN
                    Customer.TESTFIELD(Customer."Location Code");

                SalesReceivSetup.RESET;
                IF SalesReceivSetup.GET THEN;

                SalesHeader.INIT;
                SalesHeader."Origem Portal Fardas" := TRUE;
                SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
                SalesHeader."No." := NoSeriesMgm.GetNextNo(SalesReceivSetup."Credit Memo Nos.", WORKDATE, TRUE);
                SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
                SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", ReturnHeader."Sell-to Customer No.");
                SalesHeader."Portal Created by" := "Created by";  //IT010 - Park - Novo campo Portal Created by - 2018.01.30 - pedido 1093
                SalesHeader.INSERT;
                IF SalesInvHeader.GET("Invoice No.") THEN BEGIN
                    SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", SalesInvHeader."Bill-to Customer No.");
                    SalesHeader.VALIDATE("Order Date", SalesInvHeader."Order Date");
                    SalesHeader.VALIDATE("Prices Including VAT", SalesInvHeader."Prices Including VAT");
                    SalesHeader.VALIDATE("Payment Method Code", SalesInvHeader."Payment Method Code");
                    SalesHeader.VALIDATE("Direct Debit Mandate ID", SalesInvHeader."Direct Debit Mandate ID");
                    SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
                    SalesHeader.VALIDATE(SalesHeader."Shortcut Dimension 2 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                    SalesHeader."External Document No." := ReturnHeader."Invoice No.";

                    CustLedEntry.RESET;
                    CustLedEntry.SETRANGE(CustLedEntry."Customer No.", SalesInvHeader."Bill-to Customer No.");
                    CustLedEntry.SETRANGE(CustLedEntry."Document Type", CustLedEntry."Document Type"::"Invoice");
                    CustLedEntry.SETRANGE(CustLedEntry."Document No.", ReturnHeader."Invoice No.");
                    CustLedEntry.SETRANGE(CustLedEntry.Open, TRUE);
                    IF CustLedEntry.FINDFIRST THEN BEGIN
                        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::"Invoice";
                        SalesHeader.VALIDATE(SalesHeader."Applies-to Doc. No.", ReturnHeader."Invoice No.");
                    END;
                END;

                SalesHeader."Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header",
                SalesHeader."Document Type"::"Credit Memo", SalesHeader."No.");

                SalesHeader."PTSS Shipment Start Time" := 235900T;
                SalesHeader."Posting Description" := Text002;
                SalesHeader."No. Series" := SalesReceivSetup."Credit Memo Nos.";
                IF NoSeries.GET(SalesReceivSetup."Credit Memo Nos.") THEN
                    SalesHeader."Posting No. Series" := NoSeries."Registed Nos.";

                SalesHeader.VALIDATE(SalesHeader."Document Date", ReturnHeader.Date);
                //IT012 - Park - 2018.06.14 - Mudar texto registo, sn
                IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND (ReturnHeader."Invoice No." <> '') THEN BEGIN
                    IF (SalesHeader."Language Code" = 'PTG') OR (SalesHeader."Language Code" = '') THEN
                        SalesHeader."Posting Description" := Text006 + ReturnHeader."Invoice No."
                    ELSE
                        SalesHeader."Posting Description" := Text007 + ReturnHeader."Invoice No.";
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
                SalesLine.VALIDATE(SalesLine.Description, STRSUBSTNO(Text003, "Invoice No."));
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
                DevolucoesLinha.SETRANGE(DevolucoesLinha."No.", ReturnHeader."No.");
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
                        SalesLine.VALIDATE("Return Reason Code", DevolucoesLinha."Return Reason Code");
                        SalesInvLine.RESET;
                        SalesInvLine.SETRANGE(SalesInvLine."Document No.", "Invoice No.");
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
                        ValueEntry.SETRANGE(ValueEntry."Document No.", "Invoice No.");
                        ValueEntry.SETRANGE(ValueEntry."Document Line No.", DevolucoesLinha."Sales Invoice Line");
                        IF ValueEntry.FINDFIRST THEN
                            SalesLine."Appl.-from Item Entry" := ValueEntry."Item Ledger Entry No.";
                        SalesLine.MODIFY;
                    UNTIL DevolucoesLinha.NEXT = 0;
                END;

                IF CopyText = '' THEN
                    CopyText := FORMAT(SalesHeader."No.");

                CountReturns := CountReturns + 1;
                //Apagar a encomenda Temporaria
                ReturnHeader.DELETE(TRUE);

            UNTIL (ReturnHeader.NEXT = 0);

        IF CountReturns > 1 THEN
            MESSAGE(STRSUBSTNO(Text005, FORMAT(CountReturns), CopyText))
        ELSE
            MESSAGE(STRSUBSTNO(Text001, CopyText));
    end;
}

