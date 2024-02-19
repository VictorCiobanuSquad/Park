pageextension 50027 "Vendor List Ext." extends "Vendor List"
{
    /*
    //IT002 - Parque - 2018.03.05 - novo campo IBAN e swift
    */
    layout
    {
        addafter(Name)
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field(IBAN; Rec.IBAN)
            {
                ApplicationArea = All;
            }
            field("SWIFT Code"; Rec."SWIFT Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Phone No.")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
            field(NIB; Rec.NIB)
            {
                ApplicationArea = All;
            }
        }
    }
}