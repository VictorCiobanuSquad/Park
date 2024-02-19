tableextension 50288 "Vendor Bank Account Ext." extends "Vendor Bank Account"
{
    /*
    //IT002 - Parque - 2018.03.05 - passar o IBAN e o Swift para a ficha fornecedor
    */
    fields
    {
        modify(IBAN)
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                SwiftCode: Record "SWIFT Code";
            begin
                //IT002 - Parque - 2018.03.05 - passar o IBAN e o Swift para a ficha fornecedor
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    Vendor.IBAN := IBAN;
                    Vendor."SWIFT Code" := "SWIFT Code";
                    Vendor.MODIFY;
                    SwiftCode.RESET;
                    IF SwiftCode.GET(COPYSTR(IBAN, 5, 4)) THEN
                        VALIDATE("SWIFT Code", SwiftCode.Code);

                    VALIDATE("PTSS CCC No.", COPYSTR(IBAN, 5));
                END;
            end;
        }
        modify("SWIFT Code")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
            begin
                //IT002 - Parque - 2018.03.05 - passar o IBAN e o Swift para a ficha fornecedor
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    Vendor.IBAN := IBAN;
                    Vendor."SWIFT Code" := "SWIFT Code";
                    Vendor.MODIFY;
                END;
            end;
        }
    }
}