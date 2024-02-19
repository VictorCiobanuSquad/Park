pageextension 50537 "Dimension Values Ext." extends "Dimension Values"
{
    /*
    JDE_INT SQD RTV 20210805
        New field: 50000 - "JDE Code"
    */
    layout
    {
        addafter(Blocked)
        {
            field("JDE Code"; Rec."JDE Code")
            {
                ApplicationArea = All;
            }
        }
    }
}