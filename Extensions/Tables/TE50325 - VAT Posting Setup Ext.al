tableextension 50325 "VAT Posting Setup Ext." extends "VAT Posting Setup"
{
    /*
    JDE_INT SQD RTV 20210728
        New fields 50000 - "JDE Tax Area Invoice" and 50001 - "JDE Tax Area CrMemo"
    */
    fields
    {
        field(50000; "JDE Tax Area Invoice"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Tax Area Invoice';
            Description = 'JDE_INT SQD RTV 20210728';
        }
        field(50001; "JDE Tax Area Cr.Memo"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Tax Area Cr.Memo';
            Description = 'JDE_INT SQD RTV 20210728';
        }
    }
}