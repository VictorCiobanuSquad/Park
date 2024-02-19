table 50015 "Devolucoes Linhas"
{

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No. Dev.';
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
        field(15; "Sales Invoice Line"; Integer)
        {
            Caption = 'No. Linha Fatura';
        }
        field(16; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason".Code;
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

