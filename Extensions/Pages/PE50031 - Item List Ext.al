pageextension 50031 "Item List Ext." extends "Item List"
{
    /*
    //IT001 - Parque - 2016.10.12 - Não mostrar os produtos bloqueados
    */
    layout
    {
        addafter(Description)
        {
            field("Unit List Price"; Rec."Unit List Price")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Item No.")
        {
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
        }
    }
}