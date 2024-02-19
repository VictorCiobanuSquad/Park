pageextension 50030 "Item Card Ext." extends "Item Card"
{
    /*
    //IT001 - Parque 2016.09.30  :
            - nova opção botão Produtos para configurar as dimensões por localizaçao para serem usadas nas enc. venda
    */
    layout
    {
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Unit List Price"; Rec."Unit List Price")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Dimensions)
        {
            action("Dimensions By Location")
            {
                Caption = 'Dimension By Location';
                RunObject = page "Dimensoes por Localizacao";
                RunPageLink = "No." = FIELD("No.");
            }
        }
    }
}