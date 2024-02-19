pageextension 50536 "Dimensions Ext." extends "Dimensions"
{
    /*
    #001 - SQD - JTP - 20210823 - JDE Interface
        New Field
            Dimension Type
    */
    layout
    {
        addafter("Map-to IC Dimension Code")
        {
            field("Dimension Type"; Rec."Dimension Type")
            {
                ApplicationArea = All;
            }
        }
    }
}