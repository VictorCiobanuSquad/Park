pageextension 50459 "Sales & Receivables Setup Ext." extends "Sales & Receivables Setup"
{
    /*
    IT001 - Parque - Idiomas - 2017.10.12
        - Novos campos - Tabulador Geral:
            - Fin. Charges Memo PT Code
            - Fin. Charges Memo ENG Code
            - Reminder Terms Code PT
            - Reminder Terms Code ENG
    */
    layout
    {
        addafter("Archive Quotes")
        {
            field("Fin. Charges Memo PT Code"; Rec."Fin. Charges Memo PT Code")
            {
                ApplicationArea = All;
            }
            field("Fin. Charges Memo ENG Code"; Rec."Fin. Charges Memo ENG Code")
            {
                ApplicationArea = All;
            }
            field("Reminder Terms Code PT"; Rec."Reminder Terms Code PT")
            {
                ApplicationArea = All;
            }
            field("Reminder Terms Code ENG"; Rec."Reminder Terms Code ENG")
            {
                ApplicationArea = All;
            }
        }
    }
}