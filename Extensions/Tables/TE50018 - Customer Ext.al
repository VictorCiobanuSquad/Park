tableextension 50018 "Customer Ext." extends Customer
{
    /*    
    IT002 - Parque - Idiomas - 2017.10.10
        - Atualização do campo "Language Code" da ficha aluno e associado
        - Atualização do campo "Código Nota Juros" conforme configuração e "Language Code"
        - Preenchimento do campo "Código Nota Juros" na criação Cliente.

    IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email

    
    JDE_INT SQD RTV 20210625
        New fields: 50017 - "JDE Payer No." and 50018 - "JDE Pupil No."
    */
    fields
    {
        modify("Language Code")
        {
            trigger OnAfterValidate()
            begin
                //IT002,sn
                CLEAR(rStudents);
                rStudents.SETRANGE("Customer No.", "No.");
                IF rStudents.FINDFIRST THEN BEGIN
                    rStudents."Language Code" := "Language Code";
                    rStudents.MODIFY;
                END;

                CLEAR(rUsersFamily);
                rUsersFamily.SETRANGE("Customer No.", "No.");
                IF rUsersFamily.FINDFIRST THEN BEGIN
                    rUsersFamily."Language Code" := "Language Code";
                    rUsersFamily.MODIFY;
                END;

                SalesSetup.GET;
                IF ("Language Code" = '') OR ("Language Code" = Text50003) THEN BEGIN
                    "Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
                    "Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
                END ELSE BEGIN
                    "Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
                    "Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
                END;
                //IT002,en
            end;
        }
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                //Normatica 20140606 - SEPA
                PaymentMethod.RESET;
                PaymentMethod.SETRANGE(PaymentMethod.Code, "Payment Method Code");
                PaymentMethod.SETRANGE(PaymentMethod."Direct Debit", TRUE);
                IF PaymentMethod.FINDFIRST THEN
                    "Partner Type" := "Partner Type"::Person
                ELSE
                    "Partner Type" := "Partner Type"::" ";
                //Normatica 20140606 - SEPA
            end;
        }
        field(50000; IBAN; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'IBAN';

            trigger OnValidate()
            begin
                CheckCustomerNIBAdmin;
            end;
        }
        field(50001; NIB; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'NIB';

            trigger OnValidate()
            var
                rStudents: Record Students;
                rCustBankAccount: Record "Customer Bank Account";
            begin
                CheckCustomerNIBAdmin;

                IF STRLEN(NIB) <> 21 THEN
                    MESSAGE(Text50000);

                //Normatica 08.06.2012
                IF rStudents.GET("Student No.") THEN BEGIN
                    rStudents.NIB := NIB;
                    rStudents.MODIFY;
                END;
                //Normatica 2014.07.07 atualizar o NIB na ficha da conta bancária
                rCustBankAccount.RESET;
                rCustBankAccount.SETRANGE(rCustBankAccount."Customer No.", "No.");
                IF rCustBankAccount.FINDFIRST THEN BEGIN
                    rCustBankAccount.VALIDATE(rCustBankAccount.IBAN, 'PT50' + NIB);
                    rCustBankAccount.MODIFY;
                END;
                //Normatica 2014.07.07 fim
            end;
        }
        field(50002; "Referencia ADC"; Code[11])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckCust("Referencia ADC", "No.");

                //Normatica 2012.11.22 atualizar o aluno com a ref adc
                UpdateCustomer;
            end;
        }
        field(50003; "Débitos Directos"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",BPI,"Caixa Agricola",Deutsch,BCP,Totta;
            OptionCaption = ' ,BPI,Caixa Agrícola,Deutsch,BCP,Totta';

            trigger OnValidate()
            begin
                //JD MM
                rBankAccount.RESET;
                rBankAccount.SETRANGE("Débitos Directos", "Débitos Directos");
                IF rBankAccount.FIND('-') THEN BEGIN
                    "ID CRED" := rBankAccount."ID CRED";
                    MODIFY;
                END;
            end;
        }
        field(50004; "EAN Enviado"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "ID CRED"; Code[6])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Not Provisionable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Not Provisionable';
        }
        field(50015; "Linked Costumers"; Integer)
        {
            Caption = 'Clientes Ligados';
            FieldClass = FlowField;
            CalcFormula = Count(Customer WHERE("VAT Registration No." = FIELD("VAT Registration No.")));
        }
        field(50016; "E-Mail2"; Text[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(50017; "JDE Payer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Payer No.';
            Description = 'JDE_INT SQD RTV 20210625';
        }
        field(50018; "JDE Pupil No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Pupil No.';
        }
        field(51007; "Estado Civil"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Empresa,Solteiro,Casado,Viúvo;
            OptionCaption = ' ,Company,Single,Married,Widow';
            Description = ' ,Empresa,Solteiro,Casado,Viúvo';
        }
        field(51008; Capital; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51009; Representante; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(51010; "Matrícula Conservatória"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51011; Conservatória; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51012; "Internal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grupo';

            trigger OnValidate()
            begin
                IF NOT Internal THEN
                    TESTFIELD("Business Unit Code 2", '');
            end;
        }
        field(51013; "Business Unit Code 2"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Business Unit Code 2';
            TableRelation = "Business Unit";

            trigger OnValidate()
            begin
                IF "Business Unit Code 2" <> '' THEN
                    TESTFIELD("Internal");
            end;
        }
        /*field(51014; "Mobile Phone"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = PTG = 'Telemóvel';
        }*/
        field(73000; "Student No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Student No.';
            TableRelation = Students."No.";
        }
        field(73001; "User Family No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'User Family No.';
            TableRelation = "Users Family"."No.";
        }
    }
    keys
    {
        key(CustomKey1; "Customer Posting Group", Name) { }
        key(CustomKey2; "Referencia ADC") { }
    }

    var
        Text51000: Label 'Deseja replicar as alterações ao cliente %1 para %2 cliente(s) %3(ais)';
        Text50000: Label 'Insira o NIB com 21 caracteres.';
        Text50001: Label 'Por Favor preencha o nif do aluno %1.';
        Text50002: Label 'Excedeu o limite permitido de números no preenchimento do NIF do aluno %1.';
        Text50003: Label 'PTG';
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        SalesSetup: Record "Sales & Receivables Setup";
        rBankAccount: Record "Bank Account";

    trigger OnInsert()
    var
        l_rRemindersTerms: Record "Reminder Terms";
        l_EduConf: Record "Edu. Configuration";
        SalesSetup: Record "Sales & Receivables Setup";
        Text50003: Label 'PTG';
    begin
        //Normatica 2012.11.21 - Preencher automaticamente o Cód. Carta Aviso
        l_rRemindersTerms.RESET;
        IF l_rRemindersTerms.FINDFIRST THEN
            Rec."Reminder Terms Code" := l_rRemindersTerms.Code;

        //IT003 - Parque- Preencher o idiona - 2017.10.31
        IF l_EduConf.GET THEN
            Rec."Language Code" := l_EduConf."Language Code";
        //IT003 - ,en

        //IT002,sn
        SalesSetup.GET;
        IF (Rec."Language Code" = '') OR (Rec."Language Code" = Text50003) THEN BEGIN
            Rec."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
            Rec."Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
        END ELSE BEGIN
            Rec."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
            Rec."Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
        END;
        //IT002,en
    end;

    procedure UpdateCustomer()
    var
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        rCandidate: Record Candidate;
    begin
        IF "No." <> '' THEN BEGIN
            rStudents.RESET;
            rStudents.SETRANGE("Customer No.", "No.");
            rStudents.MODIFYALL("Payment Method Code", "Payment Method Code");
            rStudents.MODIFYALL("Payment Terms Code", "Payment Terms Code");
            rStudents.MODIFYALL("Customer Disc. Group", "Customer Disc. Group");
            rStudents.MODIFYALL("Allow Line Disc.", "Allow Line Disc.");
            rStudents.MODIFYALL("Customer Posting Group", "Customer Posting Group");
            rStudents.MODIFYALL("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rStudents.MODIFYALL("VAT Bus. Posting Group", "VAT Bus. Posting Group");

            rStudents.RESET;
            rStudents.SETRANGE("Customer No.", "No.");
            IF rStudents.FIND('-') THEN BEGIN
                rStudents.IBAN := IBAN;
                rStudents.NIB := NIB;
                rStudents."Referencia ADC" := "Referencia ADC";
                rStudents."Débitos Directos" := "Débitos Directos";
                rStudents."EAN Enviado" := "EAN Enviado";
                rStudents."ID CRED" := "ID CRED";
                rStudents."E-mail" := "E-Mail";//Normatica 2012.10.24
                                               //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
                rStudents."E-mail2" := "E-Mail2";
                rStudents.MODIFY;
            END;

        END;

        IF "No." <> '' THEN BEGIN
            rUsersFamily.RESET;
            rUsersFamily.SETRANGE("Customer No.", "No.");
            rUsersFamily.MODIFYALL("Payment Method Code", "Payment Method Code");
            rUsersFamily.MODIFYALL("Payment Terms Code", "Payment Terms Code");
            rUsersFamily.MODIFYALL("Customer Disc. Group", "Customer Disc. Group");
            rUsersFamily.MODIFYALL("Allow Line Disc.", "Allow Line Disc.");
            rUsersFamily.MODIFYALL("Customer Posting Group", "Customer Posting Group");
            rUsersFamily.MODIFYALL("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rUsersFamily.MODIFYALL("VAT Bus. Posting Group", "VAT Bus. Posting Group");
            //IT003 - Parque - 2017.11.21 -  sinconização dados entre associado e cliente
            rUsersFamily.MODIFYALL(rUsersFamily.Name, Name);
            rUsersFamily.MODIFYALL(rUsersFamily.Address, Address);
            rUsersFamily.MODIFYALL(rUsersFamily."Address 2", "Address 2");
            rUsersFamily.MODIFYALL(rUsersFamily."Post Code", "Post Code");
            rUsersFamily.MODIFYALL(rUsersFamily.Location, City);
            rUsersFamily.MODIFYALL(rUsersFamily."Country/Region Code", "Country/Region Code");
            rUsersFamily.MODIFYALL(rUsersFamily."VAT Registration No.", "VAT Registration No.");
            rUsersFamily.MODIFYALL(rUsersFamily."Language Code", "Language Code");
            rUsersFamily.MODIFYALL(rUsersFamily."Phone No.", "Phone No.");
            rUsersFamily.MODIFYALL(rUsersFamily."Mobile Phone", "Mobile Phone No.");
            rUsersFamily.MODIFYALL(rUsersFamily."E-mail", "E-Mail");
            //IT003 - Parque - 2017.11.21 -  en
            //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
            rUsersFamily.MODIFYALL(rUsersFamily."E-mail2", "E-Mail2");

        END;

        IF "No." <> '' THEN BEGIN
            rCandidate.RESET;
            rCandidate.SETRANGE("Customer No.", "No.");
            rCandidate.MODIFYALL("Payment Method Code", "Payment Method Code");
            rCandidate.MODIFYALL("Payment Terms Code", "Payment Terms Code");
            rCandidate.MODIFYALL("Customer Disc. Group", "Customer Disc. Group");
            rCandidate.MODIFYALL("Allow Line Disc.", "Allow Line Disc.");
            rCandidate.MODIFYALL("Customer Posting Group", "Customer Posting Group");
            rCandidate.MODIFYALL("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rCandidate.MODIFYALL("VAT Bus. Posting Group", "VAT Bus. Posting Group");
        END;
    end;

    procedure CheckCustomerNIBAdmin()
    var
        "rUser Setup": Record "User Setup";

    begin
        "rUser Setup".GET(USERID);
        "rUser Setup".TESTFIELD("Customer NIB Admin");
    end;

    procedure ValidateNIF()
    begin
        IF ("VAT Registration No." = '') THEN
            ERROR(Text50001, "No.");

        IF (STRLEN(FORMAT("VAT Registration No.")) > 9) THEN
            ERROR(Text50002, "No.");
    end;

    procedure CheckCust(VATRegNo: Text[20]; Number: Code[20])
    var
        Cust: Record Customer;
        Check: Boolean;
        Finish: Boolean;
        t: Text[250];
        Text020: Label 'This VAT registration number has already been entered for the following customers:\ %1';

    begin
        Check := TRUE;
        t := '';
        Cust.SETCURRENTKEY("Referencia ADC");
        Cust.SETRANGE("Referencia ADC", VATRegNo);
        Cust.SETFILTER("No.", '<>%1', Number);
        IF Cust.FIND('-') THEN BEGIN
            Check := FALSE;
            Finish := FALSE;
            REPEAT
                IF Cust."No." <> Number THEN BEGIN
                    IF t = '' THEN
                        t := Cust."No."
                    ELSE
                        IF STRLEN(t) + STRLEN(Cust."No.") + 5 <= MAXSTRLEN(t) THEN
                            t := t + ', ' + Cust."No."
                        ELSE BEGIN
                            t := t + '...';
                            Finish := TRUE;
                        END;
                END;
            UNTIL (Cust.NEXT = 0) OR Finish;
        END;
        IF Check = FALSE THEN
            MESSAGE(Text020, t);
    end;
}