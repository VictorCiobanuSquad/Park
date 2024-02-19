table 31009828 "LOG MISI"
{
    Caption = 'LOG MISI';
    //DrillDownPageID = 31003134;
    //LookupPageID = 31003134;

    fields
    {
        field(1; Num; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Uploaded File"; Text[250])
        {
            Caption = 'Uploaded File';
        }
        field(5; "File Received"; Text[250])
        {
            Caption = 'File Received';
            NotBlank = true;
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Time; Time)
        {
            Caption = 'Time';
        }
        field(10; Status; Text[250])
        {
            Caption = 'Status';
        }
        field(11; Moment; Text[1])
        {
            Caption = 'Moments';
        }
        field(12; Year; Text[30])
        {
            Caption = 'Year';
        }
    }

    keys
    {
        key(Key1; Num)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

