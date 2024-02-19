tableextension 50289 "Payment Method Ext." extends "Payment Method"
{
    /*
    IT001 - 2017.11.13 - Park - Novo campo Description ENG para tradução nas faturas
    IT002 - 2018.06.14 - Park - Novos campos Abbreviation e Abbreviation ENG
    */
    fields
    {
        field(50001; "Description ENG"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description ENG';
            Description = 'Park';
        }
        field(50002; Abbreviation; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Abbreviation';
            Description = 'Park';
        }
        field(50003; "Abbreviation ENG"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Abbreviation ENG';
            Description = 'Park';
        }
        field(31009750; "Payment Edu"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Edu.';
        }
    }
}