pageextension 50425 "Vendor Bank Account Card Ext." extends "Vendor Bank Account Card"
{
    /*
    //IT001 - Parque - 2018.03.05 - Atribuir automaticamente o codigo conta bancária
    */
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        VendorBankAcc: Record "Vendor Bank Account";
        Num: Integer;
    begin
        //IT001 - Parque - 2018.03.05 - Atribuir automaticamente o codigo conta bancária
        VendorBankAcc.RESET;
        VendorBankAcc.SETRANGE("Vendor No.", Rec."Vendor No.");
        IF VendorBankAcc.FINDLAST THEN BEGIN
            IF STRPOS(VendorBankAcc.Code, '_') <> 0 THEN
                Rec.Code := 'CB' + Rec."Vendor No." + '_' + INCSTR(COPYSTR(VendorBankAcc.Code, STRPOS(VendorBankAcc.Code, '_') + 1))
            ELSE
                Rec.Code := 'CB' + Rec."Vendor No." + '_1';
        END ELSE BEGIN
            Rec.Code := 'CB' + Rec."Vendor No." + '_1';
        END;
    end;
}