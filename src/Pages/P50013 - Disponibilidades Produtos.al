page 50013 "Disponibilidades Produtos"
{
    /*
    //IT001 - Parque - 2016.10.13 -Novo Ecran para mostrar a Disponibilidade de Produtos por variante
    */
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Variant";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = All;
                }
                field(SaldoImediato; SaldoImediato)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Saldo; Saldo)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Item No.", '%1..', 'PRD00107');
    end;

    trigger OnAfterGetRecord()
    begin
        SaldoImediato := Rec.Inventory - Rec."Qty. on Sales Order";
        Saldo := Rec.Inventory + Rec."Qty. on Purch. Order" - Rec."Qty. on Sales Order";
    end;

    var
        SaldoImediato: Decimal;
        Saldo: Decimal;
}