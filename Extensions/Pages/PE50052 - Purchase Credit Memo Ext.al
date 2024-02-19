pageextension 50052 "Purchase Credit Memo Ext." extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Campaign No.")
        {
            field("Entry Date"; Rec."Entry Date")
            {
                ApplicationArea = All;
            }
        }
    }
}