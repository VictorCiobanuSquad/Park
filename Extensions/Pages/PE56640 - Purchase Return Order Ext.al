pageextension 56640 "Purchase Return Order Ext." extends "Purchase Return Order"
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