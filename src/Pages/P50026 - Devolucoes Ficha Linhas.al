page 50026 "Devolucoes Ficha Linhas"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Devolucoes Linhas";
    Caption = 'Linhas Devolução';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Item No."; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Caption = 'Item Description';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    Caption = 'Return Reason Code';
                    ApplicationArea = All;
                }
            }
        }
    }
}