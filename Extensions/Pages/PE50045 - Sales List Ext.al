pageextension 50045 "Sales List Ext." extends "Sales List"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Currency Code")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
        }
    }
}