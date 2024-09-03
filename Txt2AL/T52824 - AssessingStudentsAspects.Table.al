table 52824 "Assessing Students Aspects"
{
    Caption = 'Assessing Students Aspects';

    fields
    {
        field(1; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"));
        }
        field(4; Subject; Code[20])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(5; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code
            ELSE IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
        }
        field(6; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(7; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(8; "Evaluation Moment"; Option)
        {
            Caption = 'Evaluation Moment';
            OptionCaption = ' ,Interim,Final Moment,Test,Others,Final Year,CIF,EXN1,EXN2,CFD';
            OptionMembers = " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD;
        }
        field(9; "Moment Code"; Code[20])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code";
        }
        field(11; Grade; Decimal)
        {
            Caption = 'Grade';
        }
        field(19; "Qualitative Grade"; Text[50])
        {
            Caption = 'Qualitative Grade';
            CharAllowed = 'AZ';
        }
        field(20; "Type Education"; Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(23; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(24; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnValidate()
            var
                recHorarioProfessorLinhas: Record "Teacher Timetable Lines";
            begin
            end;
        }
        field(25; "Aspects Code"; Code[20])
        {
            Caption = 'Aspects Code';
        }
        field(26; "Grade Calc"; Decimal)
        {
            Caption = 'Calc. Grade';
        }
        field(27; "Qualitative Grade Calc"; Text[50])
        {
            Caption = 'Qualitative Grade Calc.';
            CharAllowed = 'AZ';
        }
    }

    keys
    {
        key(Key1; Class, "School Year", "Schooling Year", Subject, "Sub-Subject Code", "Study Plan Code", "Student Code No.", "Moment Code", "Aspects Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

