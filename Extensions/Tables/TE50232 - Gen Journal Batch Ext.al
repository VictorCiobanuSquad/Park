tableextension 50232 "Gen. Journal Batch Ext." extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "Payment Suggest."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sugestão Pagam.';
        }
        field(50001; "Bal. cash-flow code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bal: cash-flow code';
        }
    }
}