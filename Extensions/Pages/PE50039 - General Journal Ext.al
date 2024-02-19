pageextension 50039 "General Journal Ext." extends "General Journal"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
        addafter(Amount)
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}