tableextension 50037 "Sales Line Ext." extends "Sales Line"
{
    /*    
    PT355578 - Prepayment Error - CMC - 2014/01/27
            The value must be greater than or equal to 0

    PT356036 - BugFix - CMC - 2014/02/05

    PT356318 - BugFix - PJC - 2001/02/11

    //IT001 - Parque 2016.09.29 - não parecer os produtos bloqueados
    //IT001 - Parque 2016.09.30 - trazer as dimensões que estiverem parametrizadas para este produto e esta localização
    //IT002 - Parque 2016.10.07 - Novo campo Qtd Transferida para indicar ao utilizador as transferencias de armazem
    //IT003 - Parque 2016.10.18 - Não atualizar as quantidades depois de enviar e faturar
    //IT004 - Park   2017.11.17 - Para traduzir os serviços

    JDE_INT SQD RTV 20210625
    New field: 50002 - "JDE Integrated"
    */
    fields
    {
        modify("No.")
        {
            //TableRelation = IF (Type=CONST(" ")) "Standard Text" ELSE IF (Type=CONST(G/L Account),System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),Account Type=CONST(Posting),Blocked=CONST(No)) ELSE IF (Type=CONST(G/L Account),System-Created Entry=CONST(Yes)) "G/L Account" ELSE IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge" ELSE IF (Type=CONST(Item),Document Type=FILTER(<>Credit Memo&<>Return Order)) Item WHERE (Blocked=CONST(No),Sales Blocked=CONST(No)) ELSE IF (Type=CONST(Item),Document Type=FILTER(Credit Memo|Return Order)) Item WHERE (Blocked=CONST(No))
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST("G/L Account"), "System-Created entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false)) ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(true)) "G/L Account" ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER('<>Credit Memo&<>Return Order')) Item WHERE(Blocked = CONST(false), "Sales Blocked" = CONST(false)) ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER('Credit Memo|Return Order')) Item WHERE(Blocked = CONST(false)) ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge" ELSE
            IF (Type = CONST(Service)) "Services ET";

            trigger OnAfterValidate()
            var
                l_ServicesET: Record "Services ET";
                ServicesET: Record "Services ET";
                SalesHeader: Record "Sales Header";
            begin
                //Normatica 2014.11.13 - como há Pais que tem mais d eum ficho o Centro de resp deve vir da ficha do serviço
                IF Type = Type::Service THEN BEGIN
                    l_ServicesET.RESET;
                    l_ServicesET.SETRANGE(l_ServicesET."No.", "No.");
                    IF l_ServicesET.FINDFIRST THEN
                        "Responsibility Center" := l_ServicesET."Responsibility Center";
                END;
                //Normatica 2014.11.13 - fim

                //C+ ET03
                if Type = Type::Service then begin
                    TESTFIELD("No.");
                    IF "No." <> ServicesET."No." THEN
                        ServicesET.GET("No.");
                    ServicesET.TESTFIELD(Blocked, FALSE);
                    //ServicesET.TESTFIELD("Inventory Posting Group");
                    ServicesET.TESTFIELD("Gen. Serv. Posting Group");


                    //"Posting Group" := ServicesET."Inventory Posting Group";
                    Description := ServicesET.Description;
                    "Description 2" := ServicesET."Description 2";
                    //GetUnitCost;
                    VALIDATE("Unit Price", ServicesET."Unit Price");
                    "Allow Invoice Disc." := ServicesET."Allow Invoice Disc.";
                    //"Units per Parcel" := ServicesET."Units per Parcel";
                    "Gen. Prod. Posting Group" := ServicesET."Gen. Serv. Posting Group";
                    "VAT Prod. Posting Group" := ServicesET."VAT Serv. Posting Group";
                    //"Tax Group Code" := ServicesET."Tax Group Code";
                    //"Item Category Code" := ServicesET."Item Category Code";
                    //"Product Group Code" := ServicesET."Product Group Code";
                    //Nonstock := ServicesET."Created From Nonstock Item";
                    //"Profit %" := ServicesET."Profit %";
                    "Allow Item Charge Assignment" := TRUE;
                    SalesHeader.get("Document Type", "Document No.");
                    IF SalesHeader."Language Code" <> '' THEN
                        GetServiceTranslation; //IT004 - Park   2017.11.17 - Para traduzir os serviços
                    "Unit of Measure Code" := '';
                END;

                //C+ 2011.11.30 - Preencher automaticamente o Centro Respon do cliente/aluno
                IF Type = Type::Item THEN
                    "Shortcut Dimension 1 Code" := GetDimCR("Sell-to Customer No.");
                //C+ 2011.11.30 - fim
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                if type = type::Service then
                    UpdateUnitPrice(FieldNo(Quantity));
            end;
        }
        field(50000; "Cash-flow code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cash-flow code';
        }
        field(50001; "Qtd. Transferida"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Parque';
        }
        field(50002; "JDE Integrated"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Integrated';
            Description = 'JDE_INT SQD RTV 20210625';
            OptionMembers = Old,"Not Integrated",Integrated;
            OptionCaption = 'Old,Not Integrated,Integrated';
            InitValue = "Not Integrated";


        }
    }

    local procedure GetDimCR(inCust: Code[50]): Code[50]
    var
        l_rStudents: Record Students;
        l_rUsersFamily: Record "Users Family";
        l_rUsersFamStud: Record "Users Family / Students";
        l_rRegistration: Record Registration;
        l_cStudentsRegist: Codeunit "Students Registration";
        l_vCR: Code[50];
    begin
        CLEAR(l_vCR);

        l_rStudents.RESET;
        l_rStudents.SETRANGE("Customer No.", inCust);
        IF l_rStudents.FIND('-') THEN BEGIN
            l_rRegistration.RESET;
            l_rRegistration.SETRANGE("Student Code No.", l_rStudents."No.");
            l_rRegistration.SETRANGE("School Year", l_cStudentsRegist.GetShoolYearActive);
            IF l_rRegistration.FIND('-') THEN
                l_vCR := l_rRegistration."Responsibility Center";
        END ELSE BEGIN
            l_rUsersFamily.RESET;
            l_rUsersFamily.SETRANGE("Customer No.", inCust);
            IF l_rUsersFamily.FIND('-') THEN BEGIN
                l_rUsersFamStud.RESET;
                l_rUsersFamStud.SETRANGE("School Year", l_cStudentsRegist.GetShoolYearActive);
                l_rUsersFamStud.SETRANGE("No.", l_rUsersFamily."No.");
                IF l_rUsersFamStud.FIND('-') THEN BEGIN
                    l_rRegistration.RESET;
                    l_rRegistration.SETRANGE("School Year", l_rUsersFamStud."School Year");
                    l_rRegistration.SETRANGE("Student Code No.", l_rUsersFamStud."Student Code No.");
                    IF l_rRegistration.FIND('-') THEN
                        l_vCR := l_rRegistration."Responsibility Center";
                END;
            END;
        END;

        CASE l_vCR OF
            'TAGUS PARK':
                EXIT('201912112');
            'BELEM':
                EXIT('204912112');
            'RESTELO':
                EXIT('206912112');
            'CASCAIS':
                EXIT('207912112');
        END;
    end;

    procedure GetServiceTranslation()
    var
        ServiceTranslation: Record "Service Translation";
        SalesHeader: Record "Sales Header";
    begin
        //IT004 - Park   2017.11.17 - Para traduzir os serviços
        SalesHeader.get("Document Type", "Document No.");
        IF ServiceTranslation.GET("No.", SalesHeader."Language Code") THEN BEGIN
            Description := ServiceTranslation.Description;
            "Description 2" := ServiceTranslation."Description 2";
        END;
    end;
}