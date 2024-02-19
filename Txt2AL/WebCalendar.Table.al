table 31009857 "Web Calendar"
{
    Caption = 'Web Calendar';
    Permissions = TableData "Web Calendar Students"=rimd;

    fields
    {
        field(1;ID;Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2;"School Year";Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3;"Study Plan";Code[20])
        {
            Caption = 'Study Plan';
            TableRelation = IF (Type=FILTER(Simple)) "Study Plan Header".Code WHERE ("School Year"=FIELD("School Year"))
                            ELSE IF (Type=FILTER(Multi)) "Course Header".Code;
        }
        field(4;Class;Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(5;"Schooling Year";Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE (Country=FIELD("Country/Region Code"));
        }
        field(6;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(7;"Timetable Code";Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(8;"Filter Period";Date)
        {
            Caption = 'Filter Period';
        }
        field(9;"Week Day";Option)
        {
            Caption = 'Week Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(12;Subject;Code[10])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(13;"Subject Description";Text[64])
        {
            Caption = 'Subject Description';
        }
        field(14;"Start Hour";Time)
        {
            Caption = 'Start Hour';
        }
        field(15;"End Hour";Time)
        {
            Caption = 'End Hour';
        }
        field(21;"Period No.";Integer)
        {
            Caption = 'Period No.';
        }
        field(27;"Absence Type";Option)
        {
            Caption = 'Absence Type';
            OptionCaption = 'Lecture,Daily';
            OptionMembers = Lecture,Daily;
        }
        field(28;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(29;Turn;Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
        field(30;"Sub-Subject Code";Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
        field(31;"Action Type";Option)
        {
            Caption = 'Action Type';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(32;"Action Type 2";Option)
        {
            Caption = 'Action Type 2';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(33;"Sub-Subject Description";Text[64])
        {
            Caption = 'Sub-Subject Description';
        }
        field(34;"Class Description";Text[30])
        {
            Caption = 'Class Description';
        }
        field(35;"Type Subject";Option)
        {
            Caption = 'Type Subject';
            OptionCaption = ' ,Subject,Non lective Component,Other';
            OptionMembers = " ",Subject,"Non lective Component",Other;
        }
        field(36;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
    }

    keys
    {
        key(Key1;ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        WebCalendarStudents: Record "Web Calendar Students";
    begin
        WebCalendarStudents.Reset;
        WebCalendarStudents.SetRange("ID Web Calendar",ID);
           WebCalendarStudents.DeleteAll;
    end;
}

