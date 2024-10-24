table 52789 "Teacher Timetable Lines"
{
    Caption = 'Teacher Timetable Lines';

    fields
    {
        field(5; "Teacher No."; Code[20])
        {
            Caption = 'Teacher No.';
            TableRelation = Teacher."No.";

            trigger OnValidate()
            begin

                if "Teacher No." <> '' then begin
                    if rTeacher.Get("Teacher No.") then begin
                        Name := rTeacher.Name;
                        UpdateFullName("Teacher No.");
                    end;
                end else
                    Name := '';
            end;
        }
        field(6; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; Day; Integer)
        {
            Caption = 'Day';
            InitValue = 1;
            ValuesAllowed = 1, 2, 3, 4, 5, 6, 7;
        }
        field(10; Name; Text[191])
        {
            Caption = 'Name';

            trigger OnValidate()
            var
                l_rTeacher: Record Teacher;
            begin
            end;
        }
        field(13; Class; Code[20])
        {
            Caption = 'Class';
            Editable = false;
            TableRelation = Class.Class;
        }
        field(15; Subject; Code[10])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(16; "Timetable Line No."; Integer)
        {
            Caption = 'Timetable Line No.';
        }
        field(17; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(18; "Non Lective Component"; Code[10])
        {
            Caption = 'Non Lective Component';
        }
        field(19; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
        field(20; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
    }

    keys
    {
        key(Key1; "Timetable Code", "Timetable Line No.", "Teacher No.", Class, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Teacher No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        rTeacher: Record Teacher;
        Text0001: Label 'You cannot insert a teacher after you have chosen a subject.';


    procedure UpdateFullName(pTeacher: Code[20])
    var
        rEduConfiguration: Record "Edu. Configuration";
        l_Teacher: Record Teacher;
    begin
        if l_Teacher.Get(pTeacher) then begin

            if rEduConfiguration.Get then begin
                if rEduConfiguration."Full Name syntax" = 0 then begin
                    if l_Teacher."Last Name 2" <> '' then
                        Name := l_Teacher."Last Name" + ' ' + l_Teacher."Last Name 2" + ', ' + l_Teacher.Name
                    else
                        Name := l_Teacher."Last Name" + ', ' + l_Teacher.Name;
                end else begin
                    if l_Teacher."Last Name 2" <> '' then
                        Name := l_Teacher.Name + ' ' + l_Teacher."Last Name 2" + ' ' + l_Teacher."Last Name"
                    else
                        Name := l_Teacher.Name + ' ' + l_Teacher."Last Name";
                end;
            end;
        end;
    end;
}

