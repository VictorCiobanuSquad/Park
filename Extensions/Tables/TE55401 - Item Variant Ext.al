tableextension 55401 "Item Variant Ext." extends "Item Variant"
{
    /*
    //IT001 - Parque - 2016.10.13 - Novos campos 50000 para serem usados no form 50013 - Disponibilidade de Produtos
    //IT002 - Parque - Portal Fardas - 2017.04.26 - novo campo Stock Mínimo
    //IT003 - Parque - 2018.01.25 - F50013 Disponibilidade de Produtos - Na calc formula foi pedido para usar o campo Qtd Pend em vez de
                                    Qtd Pendente (Base)
    */
    fields
    {
        field(50000; Inventory; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Variant Code" = FIELD(Code)));
            Caption = 'Inventory';
            Description = 'Parque';
        }
        field(50001; "Qty. on Purch. Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("Item No."), "Variant Code" = FIELD(Code)));
            Caption = 'Qty. on Purch. Order';
            Description = 'Parque';
        }
        field(50002; "Qty. on Sales Order"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order), Type = CONST(Item), "No." = FIELD("Item No."), "Variant Code" = FIELD(Code)));
            Caption = 'Qty. on Sales Order';
            Description = 'Parque';
        }
        field(50003; "Stock Mínimo"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Parque - Portal Fardas';
        }
    }
}