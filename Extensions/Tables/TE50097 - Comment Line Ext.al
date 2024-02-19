tableextension 50097 "Comment Line Ext." extends "Comment Line"
{
    /*
    //IT001 - Parque - 2016.10.19 - Nova option no campo Tipo Documento:InvoiceItem.
    // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
    //Foi criado também novo campo "Caminho PDFs", para configurar a pasta onde os PDF's das Faturas vão ser guardados

    IT002 - Parque - Nota Juros - 2017.10.11
        - Nova option no campo Tipo Documento:"Nota Juros"
    */
    fields
    {
        modify("No.")
        {
            TableRelation = IF ("Table Name" = CONST("G/L Account")) "G/L Account" ELSE
            IF ("Table Name" = CONST(Customer)) Customer ELSE
            IF ("Table Name" = CONST(Vendor)) Vendor ELSE
            IF ("Table Name" = CONST(Item)) Item ELSE
            IF ("Table Name" = CONST(Resource)) Resource ELSE
            IF ("Table Name" = CONST(Job)) Job ELSE
            IF ("Table Name" = CONST("Resource Group")) "Resource Group" ELSE
            IF ("Table Name" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Table Name" = CONST(Campaign)) Campaign ELSE
            IF ("Table Name" = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF ("Table Name" = CONST(Insurance)) Insurance ELSE
            IF ("Table Name" = CONST("IC Partner")) "IC Partner" ELSE
            IF ("Table Name" = CONST(Student)) Students ELSE
            IF ("Table Name" = CONST("Users Family")) "Users Family";
        }
        field(50000; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Type';
            OptionMembers = " ",Invoice,"Issue Reminder","Credit Memo",Receipt,InvoiceItem,"Finance Charge Memo";
            OptionCaption = ' ,Invoice,Issue Reminder,Credit Memo,Receipt,Uniform Invoice,Finance Charge Memo';
        }
        field(50005; "Caminho PDFs"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(31009750; Seperator; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Seperator';
            OptionMembers = " ",Space,"Carriage Return";
            OptionCaption = ' ,Space,Carriage Return';
        }
        field(31009751; Description; Text[128])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(31009752; Goals; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Goals';
        }
        field(31009753; "Actual Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Actual Status';
            OptionMembers = " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Tranfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences","School Certificate";
            OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Tranfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences,School Certificate';
            Editable = false;
        }
        field(31009754; "School Year"; Code[9])
        {
            DataClassification = ToBeClassified;
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
    }
}