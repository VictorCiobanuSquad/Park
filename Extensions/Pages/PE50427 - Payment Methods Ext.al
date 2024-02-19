pageextension 50427 "Payment Methods Ext." extends "Payment Methods"
{
    /*
    IT001 - 2017.11.13 - Park - Novo campo Description ENG para tradução nas faturas
    IT002 - 2018.06.14 - Park - Novos campos Abbreviation e Abbreviation ENG
    */
    layout
    {
        addafter(Description)
        {
            field("Description ENG"; Rec."Description ENG")
            {
                ApplicationArea = All;
            }
            field(Abbreviation; Rec.Abbreviation)
            {
                ApplicationArea = All;
            }
            field("Abbreviation ENG"; Rec."Abbreviation ENG")
            {
                ApplicationArea = All;
            }
        }
        addafter("PTSS SAF-T Pmt. Mechanism")
        {
            field("Payment Edu"; Rec."Payment Edu")
            {
                ApplicationArea = All;
            }
        }
    }
}