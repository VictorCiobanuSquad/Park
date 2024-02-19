pageextension 50461 "Inventory Setup Ext.al" extends "Inventory Setup"
{
    layout
    {
        addafter("Average Cost Period")
        {
            field("Item Category Code by Default"; Rec."Item Category Code by Default")
            {
                ApplicationArea = All;
            }
            field("Product Group Code by Default"; Rec."Product Group Code by Default")
            {
                ApplicationArea = All;
            }
        }
    }
}