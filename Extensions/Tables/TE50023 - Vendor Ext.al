tableextension 50023 "Vendor Ext." extends Vendor
{
    /*
    //IT002 - Parque - 2018.03.05 - novo campo IBAN e swift
    */
    fields
    {
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            begin
                CheckVendorNIBAdmin;
            end;
        }
        field(50000; IBAN; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; NIB; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Bank Account"."PTSS CCC No." WHERE("Vendor No." = FIELD("No.")));

            trigger OnValidate()
            begin
                CheckVendorNIBAdmin;
            end;
        }
        field(50002; "SWIFT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'SWIFT Code';
        }
    }
    keys
    {
        key(CustomKey1; "Vendor Posting Group", Name) { }
    }

    trigger OnInsert()
    var
        l_Localizacao: Record Location;
    begin
        //IT001 - Parque - 2016.10.12 - preencher automaticamente o Cod. Localização
        l_Localizacao.RESET;
        l_Localizacao.SETRANGE(l_Localizacao."Armazem Geral", TRUE);
        IF l_Localizacao.FINDFIRST THEN
            Rec."Location Code" := l_Localizacao.Code;
    end;

    procedure CheckVendorNIBAdmin()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Vendor NIB Admin");
    end;
}