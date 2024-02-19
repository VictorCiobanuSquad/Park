pageextension 55740 "Transfer Order Ext." extends "Transfer Order"
{
    /*
    It0T01 - Parque - 2016.10.10 - campo Nº encomenda
    */
    layout
    {
        addafter("Assigned User ID")
        {
            field("No. Encomenda Venda"; Rec."No. Encomenda Venda")
            {
                ApplicationArea = All;
            }
        }
    }
}