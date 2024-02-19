pageextension 50043 "Sales Invoice Ext." extends "Sales Invoice"
{
    /*    
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Portal Created by"; Rec."Portal Created by")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Contact")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
        }
    }
}