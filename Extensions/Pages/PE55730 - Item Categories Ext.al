pageextension 55730 "Item Categories Ext." extends "Item Categories"
{
    /*
    //IT001 - Park - 2017.12.13 - Portal Fardas - Novo campo Description ENG
    */
    layout
    {
        addafter(Description)
        {
            field("Description ENG"; Rec."Description ENG")
            {
                ApplicationArea = All;
            }
        }
    }
}