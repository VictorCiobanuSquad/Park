table 53004 "SMTP Fields"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "SMTP Server Name"; Text[250])
        {
        }
        field(3; "SMTP Server Port"; Integer)
        {
        }
        field(4; "E-Mail From"; Text[250])
        {
        }
        field(5; "E-Mail From HR"; Text[250])
        {
        }
        field(6; "E-Mail From Bcc"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

