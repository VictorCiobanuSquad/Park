tableextension 56635 "Return Reason Ext." extends "Return Reason"
{
    /*
    //IT001 - Parque - Portal Fardas - 2017.10.19 - novo campo Description ENU para preencher em inglês
    */
    fields
    {
        field(50000; "Description ENU"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Descrição ENU';
            Description = 'Fardas';
        }
    }
}