pageextension 50044 "Sales Credit Memo Ext." extends "Sales Credit Memo"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Sell-to City")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
            field("Service Invoice"; Rec."Service Invoice")
            {
                ApplicationArea = All;
            }
        }
    }
}