tableextension 50079 "Company Information Ext." extends "Company Information"
{
    /*
    JDE_INT SQD RTV 20210625
        New field: 50004 - "JDE Entity Number"
    */
    fields
    {
        field(50000; Matrícula; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Capital social"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Certified Picture"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; Picture2; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Picture';
            Subtype = Bitmap;
        }
        field(50004; "JDE Entity Number"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'JDE Entity Number';
            Description = 'JDE_INT SQD RTV 20210625';
        }
    }
}