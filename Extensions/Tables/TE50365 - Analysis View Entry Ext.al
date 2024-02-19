tableextension 50365 "Analysis View Entry Ext." extends "Analysis View Entry"
{
    fields
    {
        field(50000; Seccao; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry"."Journal Batch Name" WHERE("Entry No." = FIELD("Entry No.")));
            Description = 'OParque';
        }
        field(50001; NDocumento; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Entry"."Document No." WHERE("Entry No." = FIELD("Entry No.")));
            Description = 'OParque';
        }
    }
}