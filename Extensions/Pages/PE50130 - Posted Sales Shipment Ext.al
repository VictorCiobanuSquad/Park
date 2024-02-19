pageextension 50130 "Posted Sales Shipment Ext." extends "Posted Sales Shipment"
{
    /*
    //IT001 - Parque - 2016.10.10 - Criar a ordem de transf. quando se anula Guias de remessa
    */
    layout
    {

    }

    actions
    {
        addlast("F&unctions")
        {
            action(CancelOrder)
            {

                Caption = 'Cancel Order';

                trigger OnAction()
                begin
                    //IT001 - Parque - 2016.10.10 - Criar a ordem de transf. quando se anula Guias de remessa
                    CurrPage.SalesShipmLines.Page.AnularOrdemTransf;
                end;
            }
        }
    }

    var
        myInt: Integer;
}