tableextension 50080 "Gen. Journal Template Ext." extends "Gen. Journal Template"
{
    fields
    {
        field(50000; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 1 Code';
            Editable = true;
            TableRelation = Dimension;
        }
        field(50001; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = Dimension;
        }
        field(50002; "Dimension 1 Value Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dimension 1 Value Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50003; "Dimension 2 Value Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dimension 2 Value Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50004; "Direct Debit"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Direct Debit';
        }
    }
}