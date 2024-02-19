pageextension 50256 "Payment Journal Ext." extends "Payment Journal"
{
    layout
    {
        addafter("Document Date")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
}