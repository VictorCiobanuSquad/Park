table 50016 "JDE Integration Log"
{
    Caption = 'JDE Integration Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Temp. Invoice,Temp. Credit Memo,Posted Invoice,Posted Credit Memo,G/L Entry';
            OptionMembers = "Temp. Invoice","Temp. Credit Memo","Posted Invoice","Posted Credit Memo","G/L Entry";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF (Type = FILTER ("Temp. Invoice" | "Temp. Credit Memo")) "Sales Header"."No."
            ELSE
            IF (Type = CONST ("Posted Invoice")) "Sales Invoice Header"."No."
            ELSE
            IF (Type = CONST ("Posted Credit Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(4; Filename; Text[30])
        {
            Caption = 'Filename';
        }
        field(5; "Integration Time"; DateTime)
        {
            Caption = 'Integration Time';
        }
        field(6; "G/L Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            TableRelation = "G/L Entry"."Entry No.";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Filename)
        {
        }
    }

    fieldgroups
    {
    }
}

