pageextension 50140 "Posted Purchase Cr. Memo Ext." extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Pay-to County")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
}