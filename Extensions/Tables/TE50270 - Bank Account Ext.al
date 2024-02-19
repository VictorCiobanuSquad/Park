tableextension 50270 "Bank Account Ext." extends "Bank Account"
{
    fields
    {
        field(50000; Payments; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payments';
        }
        field(50001; "Nome Diário Recebimentos"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Transferencias';
            TableRelation = "Gen. Journal Template";
        }
        field(50002; "Nome Secção Diário Rec."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Transferencias';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Nome Diário Recebimentos"));
        }
        field(50003; "Conta Clientes Diário Rec."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Transferencias';
            TableRelation = "G/L Account"."No.";
        }
        field(50004; "Cod. Fluxo-Caixa"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Transferencias';
            TableRelation = "Cash Flow Account";
        }
        field(50005; "Nome Ficheiro Rec"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Transferencias';
        }
        field(50006; "Caminho Ficheiro PS2"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
        }
        field(50007; "Código Tipo Operação"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
            //TableRelation = "Tipos Operação"."Tipo Operação";
        }
        field(50008; "Referencia Ficheiro PS2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
        }
        field(50009; "Nome Diário PS2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
            TableRelation = "Gen. Journal Template";
        }
        field(50010; "Nome Secção PS2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Nome Diário PS2"));
        }
        field(50011; "Cod. Fluxo-Caixa DB"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Conf. Deb Directos';
            TableRelation = "Cash Flow Account";
        }
        field(50012; "Caminho Ficheiro EAN"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "ID CRED"; Code[6])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Bank Entity"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Débitos Directos"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",BPI,"Caixa Agrícola",Deutsch,BCP,Totta;
            OptionCaption = ' ,BPI,Caixa Agrícola,Deutsch,BCP,Totta';
        }
        field(50016; Sign1Name; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assinatura 1';
        }
        field(50017; Sign2Name; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assinatura 2';
        }
        field(50018; "Internal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grupo';

            trigger OnValidate()
            begin
                IF NOT Internal THEN
                    TESTFIELD("Business Unit Code 2", '');
            end;
        }
        field(50019; "Business Unit Code 2"; Code[10])
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
    }
}