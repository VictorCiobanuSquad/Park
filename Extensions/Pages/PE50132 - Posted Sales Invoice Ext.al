pageextension 50132 "Posted Sales Invoice Ext." extends "Posted Sales Invoice"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Quote No.")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }

        }
    }
}