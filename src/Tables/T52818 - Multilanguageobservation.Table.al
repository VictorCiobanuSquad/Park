table 52818 "Multi language observation"
{
    Caption = 'Multi language observation';
    DrillDownPageID = "Multi Language Obs Drill";
    Permissions = TableData "WEB Remarks" = rimd;

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Observation Code"; Code[20])
        {
            Caption = 'Observation Code';
        }
        field(4; Language; Option)
        {
            Caption = 'Language';
            InitValue = Castilian;
            OptionCaption = ' ,Castilian,English,Euskara,Galego,Deutsch,Français,Italian,Portuguese,Catalan';
            OptionMembers = " ",Castilian,English,Euskara,Galego,Deutsch,"Français",Italian,Portuguese,Catalan;
        }
        field(5; "Male Text"; Text[250])
        {
            Caption = 'Male Text';
        }
        field(6; "Female Text"; Text[250])
        {
            Caption = 'Female Text';
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
    }

    keys
    {
        key(Key1; "School Year", "Observation Code", Language, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

