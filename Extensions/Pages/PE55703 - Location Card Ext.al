pageextension 55703 "Location Card Ext." extends "Location Card"
{
    /*
    //IT001 - Parque 2016.09.30 - novo campo Resp Center para ligar as location com os Centros Resp
    //IT002 - Parque 2016.10.07 - novo campo Armazém geral usado nas ordens de transferencia
    */
    layout
    {
        addafter("Country/Region Code")
        {
            field("Resp. Center"; Rec."Resp. Center")
            {
                ApplicationArea = All;
            }
            field("Armazem Geral"; Rec."Armazem Geral")
            {
                ApplicationArea = All;
            }
        }
    }
}