pageextension 50047 "Sales Invoice Subform Ext." extends "Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
            }
            field("Cash-flow code"; Rec."Cash-flow code")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}