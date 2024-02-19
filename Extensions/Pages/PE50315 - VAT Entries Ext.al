pageextension 50315 "VAT Entries Ext." extends "VAT Entries"
{
    /*
    NAVPTL005.001 :: VAT Annex
        - Show Field: "Reason Code", "External Document No."
    */
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Registration No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }
    }
}