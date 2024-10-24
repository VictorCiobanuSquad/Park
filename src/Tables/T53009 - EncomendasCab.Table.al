table 53009 "Encomendas Cab"
{
    // IT001 - Parque - Portal Fardas - 2017.07.21 - Novo campo Fact a Nome cliente
    // 
    // IT010 - Park - Novo campo Portal Created by - 2018.01.30 - pedido 1093

    DrillDownPageID = "Encomendas Lista";
    LookupPageID = "Encomendas Lista";

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No. Enc.';
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Venda a Cliente No.';
            TableRelation = Customer."No.";
        }
        field(7; "Sell-to Customer Name"; Text[128])
        {
            Caption = 'Nome Cliente';
        }
        field(8; "Order Date"; Date)
        {
            Caption = 'Data Encomenda';
        }
        field(10; "Users Family Customer No."; Code[20])//Bill to customer No.
        {
            Caption = 'Fact. a Cliente No.';
            Description = 'Este campo serve para guardar o Cliente a quem é faturado';
            TableRelation = Customer."No.";
        }

        field(11; "Bill-to Customer Name"; Text[50])
        {
            Caption = 'Fatura a Nome Cliente';

        }
        field(12; "Portal User Id"; Integer)
        {
            TableRelation = "Portal User".UserID;
        }

        field(20; Created; DateTime)
        {
            Caption = 'Criação';
        }
        field(21; "Created by"; Text[250])
        {
            Caption = 'User Criação';
            FieldClass = FlowField;
            CalcFormula = Lookup("Portal User".Name WHERE(UserID = FIELD("Portal User Id")));
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
            //
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
        EncomendasLinhas.RESET;
        EncomendasLinhas.SETRANGE(EncomendasLinhas."No.", "No.");
        EncomendasLinhas.DELETEALL;
    end;

    var
        EncomendasLinhas: Record "Encomendas Linhas";
        Text001: Label 'Foi criada a encomenda %1.';
        Text002: Label 'Encomenda nº %1 \Não existe disponibilidade para o produto %2, tamanho %3. Deseja continuar?';
        Text003: Label 'Operação interrompida.';
        EncHeader: Record "Encomendas Cab";
        EncHeader2: Record "Encomendas Cab";
        Text004: Label 'Orders created: %1.';
        Item: Record Item;
        Text005: Label 'The Item %1 not have location dimension.';
        Customer: Record Customer;
        Flag: Boolean;
        Text006: Label 'O campo %1 está em falta na encomenda %2. Deseja continuar?';


    procedure SelectAll()
    begin
        MODIFYALL(Pick, TRUE);
    end;


    procedure UnSelectAll()
    begin
        MODIFYALL(Pick, FALSE);
    end;


    procedure PickOrderCreate(pPostingDate: Date)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        SalesReceivSetup: Record "Sales & Receivables Setup";
        NoSeriesMgm: Codeunit "No. Series";
        EncomendasLinha: Record "Encomendas Linhas";
        NoSeries: Record "No. Series";
        ItemVariant: Record "Item Variant";
        CountOrders: Integer;
        CopyText: Text[250];
        DimLocal: Record "Dimensoes por Localizacao";
    begin
        CountOrders := 0;
        EncHeader.RESET;
        EncHeader.SETRANGE(Pick, TRUE);
        IF EncHeader.FINDSET THEN
            REPEAT
                Customer.RESET;
                IF Customer.GET("Sell-to Customer No.") THEN BEGIN
                    IF Customer.Name = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Customer.Name), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer.Address = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Address), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Post Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Post Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer.City = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(City), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Country/Region Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Country/Region Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."VAT Registration No." = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Registration No."), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Gen. Bus. Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Gen. Bus. Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."VAT Bus. Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Bus. Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Customer Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Customer Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Payment Terms Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Terms Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Payment Method Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Method Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Location Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Location Code"), EncHeader."No.")) THEN
                            ERROR(Text003);

                END;
                Customer.RESET;
                IF Customer.GET("Users Family Customer No.") THEN BEGIN //equivale ao Bill to
                    IF Customer.Name = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Name), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer.Address = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Address), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Post Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Post Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer.City = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(City), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Country/Region Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Country/Region Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."VAT Registration No." = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Registration No."), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Gen. Bus. Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Gen. Bus. Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."VAT Bus. Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Bus. Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Customer Posting Group" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Customer Posting Group"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Payment Terms Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Terms Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                    IF Customer."Payment Method Code" = '' THEN
                        IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Method Code"), EncHeader."No.")) THEN
                            ERROR(Text003);
                END;


                SalesReceivSetup.RESET;
                IF SalesReceivSetup.GET THEN;

                SalesHeader.INIT;
                SalesHeader."Origem Portal Fardas" := TRUE;
                SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                SalesHeader."No." := NoSeriesMgm.GetNextNo(SalesReceivSetup."Order Nos.", WORKDATE, TRUE);
                SalesHeader."Order Date" := EncHeader."Order Date";
                SalesHeader.VALIDATE(SalesHeader."Posting Date", pPostingDate);
                SalesHeader."Shipment Date" := pPostingDate;
                SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", EncHeader."Sell-to Customer No.");
                SalesHeader."No. Series" := SalesReceivSetup."Order Nos.";
                IF NoSeries.GET(SalesReceivSetup."Order Nos.") THEN
                    SalesHeader."Posting No. Series" := NoSeries."Registed Nos.";
                SalesHeader."Portal Created by" := "Created by";  //IT010 - Park - Novo campo Portal Created by - 2018.01.30 - pedido 1093
                SalesHeader.INSERT(TRUE);

                //A encomenda pode ser faturada por qualquer uma das entidades pagadoras ou pelo cliente que estiver no campo cliente fardas
                //na ficha do aluno. Assin sendo a fatura é sempre feita ao que vier no campo Users family Customer No
                SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", EncHeader."Users Family Customer No.");
                SalesHeader.VALIDATE(SalesHeader."Document Date", pPostingDate);
                SalesHeader.VALIDATE(SalesHeader."Order Date", EncHeader."Order Date");
                SalesHeader.MODIFY;

                EncomendasLinha.RESET;
                EncomendasLinha.SETRANGE(EncomendasLinha."No.", EncHeader."No.");
                IF EncomendasLinha.FINDSET THEN BEGIN
                    REPEAT
                        Flag := FALSE;
                        //Testa se há disponibilidade do produto
                        ItemVariant.RESET;
                        ItemVariant.SETRANGE(ItemVariant."Item No.", EncomendasLinha."Item No.");
                        ItemVariant.SETRANGE(ItemVariant.Code, EncomendasLinha."Variant Code");
                        IF ItemVariant.FINDFIRST THEN BEGIN
                            ItemVariant.CALCFIELDS(ItemVariant.Inventory);
                            IF ItemVariant.Inventory < EncomendasLinha.Quantity THEN
                                IF NOT CONFIRM(STRSUBSTNO(Text002, EncomendasLinha."No.", EncomendasLinha."Item No.", EncomendasLinha."Variant Code")) THEN
                                    ERROR(Text003)
                                ELSE
                                    Flag := TRUE;
                        END;
                        //Fim

                        //Valida campos da ficha do produto
                        Item.RESET;
                        IF Item.GET(EncomendasLinha."Item No.") THEN BEGIN
                            Item.TESTFIELD("Gen. Prod. Posting Group");
                            Item.TESTFIELD("VAT Prod. Posting Group");
                            Item.TESTFIELD("Inventory Posting Group");
                        END;

                        //Verifica se tem dimensões por localização.
                        DimLocal.RESET;
                        DimLocal.SETRANGE(DimLocal."No.", EncomendasLinha."Item No.");
                        IF DimLocal.ISEMPTY THEN
                            ERROR(STRSUBSTNO(Text005, EncomendasLinha."Item No."));


                        SalesLine.INIT;
                        SalesLine.VALIDATE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                        SalesLine.VALIDATE(SalesLine."Document No.", SalesHeader."No.");
                        SalesLine.VALIDATE(SalesLine."Line No.", EncomendasLinha."Line No.");
                        SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", EncomendasLinha."Sell-to Customer No.");
                        SalesLine.VALIDATE(SalesLine.Type, SalesLine.Type::Item);
                        SalesLine.VALIDATE(SalesLine."No.", EncomendasLinha."Item No.");
                        SalesLine.VALIDATE(SalesLine."Variant Code", EncomendasLinha."Variant Code");
                        SalesLine.VALIDATE(SalesLine.Quantity, EncomendasLinha.Quantity);
                        IF Flag = TRUE THEN SalesLine.VALIDATE(SalesLine."Qty. to Ship", 0);
                        SalesLine.INSERT(TRUE);

                    UNTIL EncomendasLinha.NEXT = 0;
                END;

                IF CopyText = '' THEN
                    CopyText := FORMAT(SalesHeader."No.");

                CountOrders := CountOrders + 1;
                //Apagar a encomenda Temporaria
                EncHeader.DELETE(TRUE);
            UNTIL (EncHeader.NEXT = 0);

        IF CountOrders > 1 THEN
            MESSAGE(STRSUBSTNO(Text004, FORMAT(CountOrders), CopyText))
        ELSE
            MESSAGE(STRSUBSTNO(Text001, CopyText));
    end;


    procedure CountMarkOrders(): Integer
    begin
        EncHeader2.RESET;
        EncHeader2.SETRANGE(Pick, TRUE);
        EXIT(EncHeader2.COUNT);
    end;
    //gcui
    procedure CheckIfHeaderExist(number: Integer) ifExist: Boolean
    begin
        if EncHeader.Get(number) then
            ifExist := true;
        ifExist := false;
    end;
    //gcui

}

