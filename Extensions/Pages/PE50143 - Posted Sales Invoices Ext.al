pageextension 50143 "Posted Sales Invoices Ext." extends "Posted Sales Invoices"
{
    /*
    JDE_INT SQD RTV 20210629
        Added field "JDE Integrated"
    */
    layout
    {
        addafter("Shipment Date")
        {
            field("JDE Integrated"; Rec."JDE Integrated")
            {
                ApplicationArea = All;
            }
        }
    }
}