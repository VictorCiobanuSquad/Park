pageextension 50022 "Customer List Ext." extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
            field("Student No."; Rec."Student No.")
            {
                ApplicationArea = All;
            }
            field("JDE Payer No."; Rec."JDE Payer No.")
            {
                ApplicationArea = All;
            }
            field("JDE Pupil No."; Rec."JDE Pupil No.")
            {
                ApplicationArea = All;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Customer Price Group")
        {
            field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Currency Code")
        {
            field(NIB; Rec.NIB)
            {
                ApplicationArea = All;
            }
            field("Referencia ADC"; Rec."Referencia ADC")
            {
                ApplicationArea = All;
            }
            field("EAN Enviado"; Rec."EAN Enviado")
            {
                ApplicationArea = All;
            }
            field("Débitos Directos"; Rec."Débitos Directos")
            {
                ApplicationArea = All;
            }
        }
    }
}