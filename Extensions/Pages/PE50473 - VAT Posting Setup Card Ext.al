pageextension 50473 "VAT Posting Setup Card Ext." extends "VAT Posting Setup Card"
{
    /*
    JDE_INT SQD RTV 2020728
        Added fields "JDE Tax Area Invoice" and "JDE Tax Area Cr.Memo"
    */
    layout
    {
        addafter(Purchases)
        {
            group(JDE)
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
}