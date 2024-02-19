tableextension 50021 "Cust. Ledger Entry Ext." extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Débitos Directos"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = " ",BPI,"Caixa Agrícola",Deutsch,BCP,Totta;
            OptionCaption = ' ,BPI,Caixa Agrícola,Deutsch,BCP,Totta';
            CalcFormula = Lookup(Customer."Débitos Directos" WHERE("No." = FIELD("Customer No.")));
        }
        field(50001; "Excluir Débitos Directos"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Path; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Receipt Path';
            Description = 'Recibos/Faturas por email';
            Editable = false;
        }
        field(51020; "Acc. Remaining Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Remaining Amount';
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("Date Filter"), "PTSS Excluded from calculation" = CONST(false)));
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            Editable = false;
        }
        field(51030; "Acc. Remaining Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Remaining Amount';
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Cust. Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("Date Filter"), "PTSS Excluded from calculation" = CONST(false)));
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            Editable = false;
        }
        field(73000; "Process by Education"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process by Education';
        }
    }
    keys
    {
        key(CustomKey1; "Bal. Account No.") { }
        key(CustomKey2; "Payment Method Code") { }
    }
}