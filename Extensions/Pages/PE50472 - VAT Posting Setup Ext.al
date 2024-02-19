pageextension 50472 "VAT Posting Setup Ext." extends "VAT Posting Setup"
{
    /*
    JDE_INT SQD RTV 20210728
        Added fields "JDE Tax Area Invoice" and "JDE Tax Area Cr.Memo"
    */
    layout
    {
        addafter("PTSS Return VAT Acc. (Sales)")
        {
            field("JDE Tax Area Invoice"; Rec."JDE Tax Area Invoice")
            {
                ApplicationArea = All;
            }
            field("JDE Tax Area Cr.Memo"; Rec."JDE Tax Area Cr.Memo")
            {
                ApplicationArea = All;
            }
        }
    }
}