table 52858 "Web Calendar Students"
{
    Caption = 'Web Calendar Students';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; "ID Web Calendar"; Integer)
        {
            Caption = 'ID Web Calendar';
        }
        field(3; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

