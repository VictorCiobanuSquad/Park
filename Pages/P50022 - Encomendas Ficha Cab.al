#pragma implicitwith disable
page 50022 "Encomendas Ficha Cab"
{
    /*
    IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093
    */
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Encomendas Cab";
    Caption = 'Ficha Encomenda';
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
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Users Family Customer No."; Rec."Users Family Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Portal User Name"; Rec."Created by")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Encomendas Ficha Linhas"; "Encomendas Ficha Linhas")
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
                Caption = 'Submeter';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                    Customer: Record Customer;
                    SalesReceivSetup: Record "Sales & Receivables Setup";
                    NoSeriesMgm: Codeunit NoSeriesManagement;
                    EncomendasLinha: Record "Encomendas Linhas";
                    NoSeries: Record "No. Series";
                    ItemVariant: Record "Item Variant";
                    Flag: Boolean;
                    Item: Record Item;
                    DimLocal: Record "Dimensoes por Localizacao";
                    Text001: Label 'Foi criada a encomenda %1.';
                    Text002: Label 'Encomenda nº %1 \Não existe disponibilidade para o produto %2, tamanho %3. Deseja continuar?';
                    Text003: Label 'Operação interrompida.';
                    Text005: Label 'The Item %1 not have location dimension.';
                    Text006: Label 'O campo %1 está em falta na encomenda %2. Deseja continuar?';
                begin
                    //IT001 - 2017.04.06 - Passar de encomenda temporária para definitiva

                    Customer.RESET;
                    IF Customer.GET(Rec."Sell-to Customer No.") THEN BEGIN
                        IF Customer.Name = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Customer.Name), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer.Address = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Address), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Post Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Post Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer.City = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(City), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Country/Region Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Country/Region Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."VAT Registration No." = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Registration No."), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Gen. Bus. Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Gen. Bus. Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."VAT Bus. Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Bus. Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Customer Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Customer Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Payment Terms Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Terms Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Payment Method Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Method Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Location Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Location Code"), Rec."No.")) THEN
                                ERROR(Text003);

                    END;
                    Customer.RESET;
                    IF Customer.GET(Rec."Users Family Customer No.") THEN BEGIN //equivale ao Bill to
                        IF Customer.Name = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Name), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer.Address = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(Address), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Post Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Post Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer.City = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION(City), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Country/Region Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Country/Region Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."VAT Registration No." = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Registration No."), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Gen. Bus. Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Gen. Bus. Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."VAT Bus. Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("VAT Bus. Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Customer Posting Group" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Customer Posting Group"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Payment Terms Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Terms Code"), Rec."No.")) THEN
                                ERROR(Text003);
                        IF Customer."Payment Method Code" = '' THEN
                            IF NOT CONFIRM(STRSUBSTNO(Text006, Customer.FIELDCAPTION("Payment Method Code"), Rec."No.")) THEN
                                ERROR(Text003);
                    END;

                    SalesReceivSetup.RESET;
                    IF SalesReceivSetup.GET THEN;


                    SalesHeader.INIT;
                    SalesHeader."Origem Portal Fardas" := TRUE;
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                    SalesHeader."No." := NoSeriesMgm.GetNextNo(SalesReceivSetup."Order Nos.", WORKDATE, TRUE);
                    SalesHeader."Order Date" := Rec."Order Date";
                    SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE);
                    SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", Rec."Sell-to Customer No.");
                    SalesHeader."No. Series" := SalesReceivSetup."Order Nos.";
                    IF NoSeries.GET(SalesReceivSetup."Order Nos.") THEN
                        SalesHeader."Posting No. Series" := NoSeries."Registed Nos.";
                    SalesHeader."Portal Created by" := Rec."Created by";  //IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093
                    SalesHeader.INSERT(TRUE);

                    //A encomenda pode ser faturada por qualquer uma das entidades pagadoras ou pelo cliente que estiver no campo cliente fardas
                    //na ficha do aluno. Assin sendo a fatura é sempre feita ao que vier no campo Users family Customer No
                    SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.", Rec."Users Family Customer No.");
                    SalesHeader.VALIDATE(SalesHeader."Document Date", WORKDATE);
                    SalesHeader.VALIDATE(SalesHeader."Order Date", Rec."Order Date");
                    SalesHeader.MODIFY;

                    EncomendasLinha.RESET;
                    EncomendasLinha.SETRANGE(EncomendasLinha."No.", Rec."No.");
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

                    MESSAGE(STRSUBSTNO(Text001, SalesHeader."No."));

                    //Apagar a encomenda Temporaria
                    Rec.DELETE(TRUE);
                end;
            }
        }
    }
}
#pragma implicitwith restore
