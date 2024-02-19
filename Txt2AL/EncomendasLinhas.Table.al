table 50013 "Encomendas Linhas"
{

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No. Enc.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'No. Linhas';
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Venda a No. Cliente';
            TableRelation = Customer."No.";
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'No. Produto';
            TableRelation = Item."No.";
        }
        field(7; "Item Description"; Text[250])
        {
            Caption = 'Descrição';
        }
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Tamanho';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Item No."));
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantidade';
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

