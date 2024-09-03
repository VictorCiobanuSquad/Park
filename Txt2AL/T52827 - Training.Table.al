table 52827 Training
{
    Caption = 'Training';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            Description = 'MISI';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            Description = 'MISI';
        }
        field(6; "No. Hours"; Decimal)
        {
            Caption = 'No. Hours';
            Description = 'MISI';
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Description = 'MISI';
        }
        field(8; "End Date"; Date)
        {
            Caption = 'End Date';
            Description = 'MISI';
        }
        field(9; Location; Text[30])
        {
            Caption = 'Location';
            Description = 'MISI';
        }
        field(10; "Service Provider"; Text[30])
        {
            Caption = 'Service Provider';
            Description = 'MISI';
        }
        field(20; Goals; Text[250])
        {
            Caption = 'Goals';
            Description = 'MISI';
        }
        field(30; Audience; Option)
        {
            Caption = 'Audience';
            Description = 'MISI';
            OptionCaption = ' ,Teacher,No Teacher';
            OptionMembers = " ",Teacher,"No Teacher";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

