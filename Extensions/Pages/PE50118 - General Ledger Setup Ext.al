pageextension 50118 "General Ledger Setup Ext." extends "General Ledger Setup"
{
    /*
    JDE_INT SQD JTP 20210823
        New Fields for JDE Interface on new Tab (JDE)
            JDE File Path
    */
    layout
    {
        addafter("Payroll Transaction Import")
        {
            group(JDE)
            {
                field("JDE File Path"; Rec."JDE File Path")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}