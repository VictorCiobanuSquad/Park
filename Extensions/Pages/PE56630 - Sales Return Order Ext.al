pageextension 56630 "Sales Return Order Ext." extends "Sales Return Order"
{
    layout
    {
        addafter("VAT Bus. Posting Group")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
}