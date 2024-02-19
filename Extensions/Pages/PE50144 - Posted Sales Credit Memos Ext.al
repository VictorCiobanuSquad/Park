pageextension 50144 "Posted Sales Credit Memos Ext." extends "Posted Sales Credit Memos"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Document Date")
        {
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Applies-to Doc. Type")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
        }
    }
}