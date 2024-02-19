pageextension 50560 "Dimension Value List Ext." extends "Dimension Value List"
{
    /*
    JDE_INT SQD RTV 20210805
        New field: 50000 - "JDE Code"
    */
    layout
    {
        addafter(Name)
        {
            field("JDE Code"; Rec."JDE Code")
            {
                ApplicationArea = All;
            }
        }
    }
}