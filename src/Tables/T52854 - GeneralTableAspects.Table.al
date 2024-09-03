table 52854 GeneralTableAspects
{
    Caption = 'GeneralTableAspects';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Update Type"; Option)
        {
            Caption = 'Update Type';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(3; Company; Code[30])
        {
            Caption = 'Company';
        }
        field(4; ID; Integer)
        {
            Caption = 'ID';
        }
        field(5; "Study Plan Entry No."; Integer)
        {
            Caption = 'Study Plan Entry No.';
        }
        field(6; "School Year"; Code[9])
        {
            Caption = 'School Year';
        }
        field(7; Student; Code[20])
        {
            Caption = 'Student';
        }
        field(8; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(9; Subject; Code[20])
        {
            Caption = 'Subject';
        }
        field(10; "Sub Subject"; Code[20])
        {
            Caption = 'Sub Subject';
        }
        field(11; Moment; Code[20])
        {
            Caption = 'Moment';
        }
        field(12; Aspect; Code[20])
        {
            Caption = 'Aspect';
        }
        field(13; "Percent Aspect"; Decimal)
        {
            Caption = 'Percent Aspect';
        }
        field(14; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(15; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        }
        field(16; "Subject Class"; Text[250])
        {
            Caption = 'Subject Class';
        }
        field(17; StudyPlan; Code[20])
        {
            Caption = 'StudyPlan';
        }
        field(18; "Update Type 2"; Option)
        {
            Caption = 'Update Type 2';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(19; AspectDescription; Text[50])
        {
            Caption = 'AspectDescription';
        }
        field(30; GradeAuto; Text[50])
        {
            Caption = 'GradeAuto';
        }
        field(31; GradeManual; Text[50])
        {
            Caption = 'GradeManual';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Student, "School Year", Moment, Subject, "Sub Subject")
        {
        }
        key(Key3; "School Year", Class, Moment)
        {
        }
        key(Key4; "Study Plan Entry No.", Aspect)
        {
        }
    }

    fieldgroups
    {
    }

    var
        StudyPlanAspects: Record GeneralTableAspects;
}

