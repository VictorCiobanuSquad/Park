page 50011 "Dimensoes por Localizacao"
{
    /*
    //IT001 - Parque 2016.09.30  :
            - novo form para configurar as dimensões por localizaçao para serem usadas nas enc. venda
    */

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dimensoes por Localizacao";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}