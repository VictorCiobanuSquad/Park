pageextension 50026 "Vendor Card Ext." extends "Vendor Card"
{
    /*
    //IT002 - Parque - 2018.03.05 - novo campo IBAN e swift
    */
    layout
    {
        addafter("Payment Terms Code")
        {
            field(IBAN; Rec.IBAN)
            {
                ApplicationArea = All;
            }
            field("SWIFT Code"; Rec."SWIFT Code")
            {
                ApplicationArea = All;
            }
        }
    }
}