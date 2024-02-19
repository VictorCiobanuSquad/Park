tableextension 50098 "General Ledger Setup Ext." extends "General Ledger Setup"
{
    /*
    JDE_INT SQD RTV 20210728
        New fields: 50000 - "Last Doc Integration Date", 50001 - "Last G/L Integration Date", 50002 - "Last Doc Integration No."
        and 50003 - "Last G/L Integration No."

    JDE_INT SQD JTP 20210823
        New Fields
            JDE File Path
    */
    fields
    {
        field(50000; "Last Doc Integration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JDE_INT SQD RTV 20210728';
        }
        field(50001; "Last G/L Integration Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JDE_INT SQD RTV 20210728';
        }
        field(50002; "Last Doc Integration No."; Text[2])
        {
            DataClassification = ToBeClassified;
            Description = 'JDE_INT SQD RTV 20210728';
        }
        field(50003; "Last G/L Integration No."; Text[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Last G/L Integration No.';
        }
        field(50004; "JDE File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE File Path';
            Description = 'JDE_INT SQD JTP 20210823';
        }
    }
}