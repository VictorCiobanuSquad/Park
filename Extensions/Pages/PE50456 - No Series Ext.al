pageextension 50456 "No. Series Ext." extends "No. Series"
{
    layout
    {
        addafter("Date Order")
        {
            field("Registed Nos."; Rec."Registed Nos.")
            {
                ApplicationArea = All;
            }
            field("Document Name"; Rec."Document Name")
            {
                ApplicationArea = All;
            }
            field("Fatura Stocks"; Rec."Fatura Stocks")
            {
                ApplicationArea = All;
            }
        }
    }
}