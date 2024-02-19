pageextension 56635 "Return Reasons Ext." extends "Return Reasons"
{
    /*
    //IT001 - Parque - Portal Fardas - 2017.10.19 - novo campo Description ENU para preencher em inglês
    */
    layout
    {
        addafter(Description)
        {
            field("Description ENU"; Rec."Description ENU")
            {
                ApplicationArea = All;
            }
        }
    }
}