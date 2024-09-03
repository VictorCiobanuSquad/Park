table 52791 "Timetable-Teacher-Insert"
{
    Caption = 'Timetable-Teacher-Insert';
    //DrillDownPageID = 60187;
    //LookupPageID = 60187;

    fields
    {
        field(1; "Cab Line"; Integer)
        {
            Caption = 'Cab Line';
        }
        field(3; "Teacher No."; Code[20])
        {
            Caption = 'Teacher No.';
            TableRelation = Teacher."No." WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin


                if "Teacher No." <> '' then begin
                    if rTeacher.Get("Teacher No.") then
                        Name := rTeacher.Name;
                end else
                    Name := '';
            end;
        }
        field(4; Name; Text[128])
        {
            Caption = 'Name';
        }
        field(7; Lecture; Boolean)
        {
            Caption = 'Lecture';
        }
        field(8; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(9; "Start Hour"; Time)
        {
            Caption = 'Start Hour';
        }
        field(10; "End Hour"; Time)
        {
            Caption = 'End Hour';
        }
        field(11; Duration; Decimal)
        {
            Caption = 'Duration';
        }
        field(12; Summaried; Boolean)
        {
            Caption = 'Summarized';
        }
        field(13; "Lectury Type"; Option)
        {
            Caption = 'Lecture Type';
            OptionCaption = 'Theoretical,Theoretical and Practical,Simulated Praticals';
            OptionMembers = ,"Teórica","Prática";
        }
        field(14; Day; Date)
        {
            Caption = 'Day';
        }
        field(30; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(109; "Key"; Integer)
        {
            Caption = 'Key';
        }
        field(110; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
        }
        field(111; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(112; "Study Plan"; Code[20])
        {
            Caption = 'Study Plan';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(113; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(114; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(115; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
    }

    keys
    {
        key(Key1; "Cab Line", "School Year", "Study Plan", Class, "Timetable Code", Type, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Teacher No.", Class, "Lectury Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;

    var
        rTeacher: Record Teacher;
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
}

