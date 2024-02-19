pageextension 50046 "Sales Order Subform Ext." extends "Sales Order Subform"
{
    layout
    {
        addafter("Inv. Discount Amount")
        {
            field("Qtd. Transferida"; Rec."Qtd. Transferida")
            {
                ApplicationArea = All;
            }
        }
    }
}