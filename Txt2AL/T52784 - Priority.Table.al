table 52784 Priority
{
    Caption = 'Priority';
    DrillDownPageID = Priority;
    LookupPageID = Priority;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Priority Points"; Integer)
        {
            Caption = 'Priority Points';
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

