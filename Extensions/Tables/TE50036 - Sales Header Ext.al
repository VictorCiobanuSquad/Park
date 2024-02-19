tableextension 50036 "Sales Header Ext." extends "Sales Header"
{
    /*
    Norm1 - APD - 21-11-2014
        - Texto Registo alterado para ficar apenas Fatura ao fazer nova. Anteriormente "Fatura + No."

    IT001 - 03-09-2016
        - Para encomendas:
            - Alterado o preenchimento do número de série conforme configuração do campo "Registed Nos"
            - Ao criar o documento o campo "Preços IVA Incluído" = TRUE

    IT002 - Parque - 06.10.2016 - Novos campos Turma e Ano Escolaridade

    IT003 - Parque - 2016.10.06

    IT004 - Parque - 2016.10.13 - preencher automaticamente texto registo

    IT005 - Parque - 2016.10.14 - atualizar a data de envio

    IT006 - Parque - 2016.10.28 - preencher "Bill To Customer" qd a entidade pagadora não é o Aluno

    IT007 - Parque - Portal Fardas - 2017.05.18 - novo campo Origem Portal Fardas - para sabermos que este doc vem do portal e o portal
                                                só mostrar este tipo de documentos
    IT008 - Parque - Portal Fardas - 2017.07.21 - foi pedido para tirar esta mensagem

    IT009 - Park - Novo campo Aluno - 2018.01.30 - pedido 1095

    IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093

    IT012 - Park - 2018.06.14 - Mudar texto registo

    JDE_INT SQD RTV 20210730
    New field: 50013 - "JDE Integrated";
    New field: 50014 - "Service Invoice"

    
    */
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                rSchoolingYear: Record "School Year";
                rRegistration: Record Registration;
                rStudents: Record Students;
                l_UsersFamilyStu: Record "Users Family / Students";
                l_UsersFamily: Record "Users Family";
                Text50001: Label 'Este Cliente tem como entidade pagadora %1.';
            begin
                //IT006 - Parque - 2016.10.28 - preencher "Bill To Customer" qd a entidade pagadora não é o Aluno
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    rStudents.RESET;
                    rStudents.SETRANGE(rStudents."Customer No.", "Sell-to Customer No.");
                    IF rStudents.FINDFIRST THEN BEGIN
                        rSchoolingYear.RESET;
                        rSchoolingYear.SETFILTER(rSchoolingYear."Starting Date", '<=%1', "Order Date");
                        rSchoolingYear.SETFILTER(rSchoolingYear."Ending Date", '>=%1', "Order Date");
                        IF rSchoolingYear.FINDFIRST THEN BEGIN
                            l_UsersFamilyStu.RESET;
                            l_UsersFamilyStu.SETRANGE(l_UsersFamilyStu."School Year", rSchoolingYear."School Year");
                            l_UsersFamilyStu.SETRANGE(l_UsersFamilyStu."Student Code No.", rStudents."No.");
                            l_UsersFamilyStu.SETRANGE(l_UsersFamilyStu."Paying Entity", TRUE);
                            l_UsersFamilyStu.SETFILTER(l_UsersFamilyStu.Kinship, '<>%1', l_UsersFamilyStu.Kinship::Himself);
                            IF l_UsersFamilyStu.FINDFIRST THEN BEGIN
                                l_UsersFamily.RESET;
                                l_UsersFamily.SETRANGE(l_UsersFamily."No.", l_UsersFamilyStu."No.");
                                IF l_UsersFamily.FINDFIRST THEN BEGIN
                                    COMMIT; //2019.05.07
                                    VALIDATE("Bill-to Customer No.", l_UsersFamily."Customer No.");
                                    MESSAGE(Text50001, "Bill-to Name");
                                END;
                            END;
                        END;
                    END;
                END;
                //IT006 - Parque - 2016.10.28 - fim

                //IT002 - Parque - 06.10.2016 - Novos campos Turma e Ano Escolaridade
                rStudents.RESET;
                rStudents.SETRANGE(rStudents."Customer No.", "Sell-to Customer No.");
                IF rStudents.FINDFIRST THEN BEGIN
                    //IT009 - Park - Novo campo Aluno - 2018.01.30 - pedido 1095
                    Aluno := rStudents."No.";
                    //IT009 - Park - en
                    rSchoolingYear.RESET;
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                        rSchoolingYear.SETFILTER(rSchoolingYear."Starting Date", '<=%1', "Posting Date");
                        rSchoolingYear.SETFILTER(rSchoolingYear."Ending Date", '>=%1', "Posting Date");
                    END ELSE BEGIN
                        rSchoolingYear.SETFILTER(rSchoolingYear."Starting Date", '<=%1', "Order Date");
                        rSchoolingYear.SETFILTER(rSchoolingYear."Ending Date", '>=%1', "Order Date");
                    END;
                    IF rSchoolingYear.FINDFIRST THEN BEGIN
                        rRegistration.RESET;
                        rRegistration.SETRANGE(rRegistration."Student Code No.", rStudents."No.");
                        rRegistration.SETRANGE(rRegistration."School Year", rSchoolingYear."School Year");
                        IF rRegistration.FINDLAST THEN BEGIN
                            Turma := rRegistration.Class;
                            "Ano Escolaridade" := rRegistration."Schooling Year";
                        END;
                    END;
                END;
                //IT00/2 - Parque - en

                //IT012 - Park - 2018.06.14 - Mudar texto registo, sn
                IF "Document Type" = "Document Type"::Invoice THEN
                    "Posting Description" := "Sell-to Customer Name";
                //IT012 - Park - 2018.06.14 - Mudar texto registo, en
            end;
        }
        field(50002; "Origem Portal Fardas"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Parque - Portal Fardas';
        }
        field(50009; Turma; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Turma onde o Aluno está inserido, para efeitos de ordenação';
        }
        field(50010; "Ano Escolaridade"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Parque';
        }
        field(50011; Aluno; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Park';
        }
        field(50012; "Portal Created by"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Park';
            Caption = 'User Criação Portal';
        }
        field(50013; "JDE Integrated"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Integrated';
            Description = 'JDE_INT SQD RTV 20210625';
            OptionMembers = Old,"Not Integrated",Integrated;
            OptionCaption = 'Old,Not Integrated,Integrated';
            InitValue = "Not Integrated";
        }
        field(50014; "Service Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Invoice';
            Description = 'JDE_INT SQD RTV 20210730';
        }
        field(50017; "JDE Payer No."; Code[20])
        {
            Caption = 'JDE Payer No.';
            Description = 'JDE_INT SQD RTV 20210625';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."JDE Payer No." WHERE("No." = FIELD("Bill-to Customer No.")));
        }
        field(50018; "JDE Pupil No."; Code[20])
        {
            Caption = 'JDE Pupil No.';
            Description = 'JDE_INT SQD RTV 20210625';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."JDE Pupil No." WHERE("No." = FIELD("Bill-to Customer No.")));
        }
        // field(50019; "Portal User Name"; Text[50])
        // {
        // }
        field(73000; "Process by Education"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process by Education';
        }
        field(31009751; Company; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Company';
            TableRelation = Company.Name;
        }
    }

    trigger OnInsert()
    var
        Text50000: Label 'Encomenda Fardas';
    begin
        //IT003 - Parque - 2016.10.06
        Rec."PTSS Shipment Start Time" := 235900T;

        //IT004 - Parque - 2016.10.13 - preencher automaticamente texto registo
        IF Rec."Document Type" = Rec."Document Type"::Order THEN
            Rec."Posting Description" := Text50000 + ' ' + Rec."No.";
    end;
}