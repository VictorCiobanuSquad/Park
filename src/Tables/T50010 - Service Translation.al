table 50010 "Service Translation"
{
    /*
     //IT001 - Park  - 2017.11.17 - Nova funcionalidade de tradução de serviços
    */

    DataClassification = ToBeClassified;
    Caption = 'Service Translation';
    DataCaptionFields = "Service No.", "Language Code", Description;
    LookupPageId = "Item Translations";

    fields
    {
        field(1; "Service No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service No.';
            NotBlank = true;
            TableRelation = "Services ET";
        }
        field(2; "Language Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(4; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Service No.")
        {
            Clustered = true;
        }
    }
}