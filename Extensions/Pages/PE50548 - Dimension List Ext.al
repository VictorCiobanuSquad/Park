pageextension 50548 "Dimension List Ext." extends "Dimension List"
{
    /*
    #001 - SQD - JTP - 20210823 - JDE Interface
        New Field
            Dimension Type
    */
    layout
    {
        addafter(Name)
        {
            field("Dimension Type"; Rec."Dimension Type")
            {
                ApplicationArea = All;
            }
        }
    }
}