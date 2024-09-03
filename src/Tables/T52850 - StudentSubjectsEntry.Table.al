table 52850 "Student Subjects Entry"
{
    Caption = 'Student Subjects Entry';

    fields
    {
        field(1; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
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
        field(4; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                     "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(5; "Subjects Code"; Code[10])
        {
            Caption = 'Subjects Code';
            TableRelation = Subjects.Code;
        }
        field(6; Description; Text[64])
        {
            Caption = 'Description';
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; Enroled; Boolean)
        {
            Caption = 'Enroled';
        }
        field(9; "Mandatory/Optional Type"; Option)
        {
            Caption = 'Mandatory/Optional Type';
            OptionCaption = ' ,Required,Optional,Free Choice';
            OptionMembers = " ",Required,Optional,"Free Choice";
        }
        field(10; "Curriculum Type"; Option)
        {
            Caption = 'Curriculum Type';
            OptionCaption = ' ,Disciplinary,Non disciplinary,Curriculum Enrichment,General,Specific';
            OptionMembers = " ",Disciplinary,"Non disciplinary","Curriculum Enrichment",General,Specific;
        }
        field(11; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(18; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21; "Maximum Injustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Injustified Absence';
        }
        field(22; "Assessment Code"; Code[20])
        {
            Caption = 'AssessmentCode';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(23; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(24; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial,Quadriennal';
            OptionMembers = " ",Annual,Biennial,Triennial,Quadriennal;
        }
        field(25; "Maximum Justified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Justified Absence';
        }
        field(26; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(27; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(28; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Correct,Subscribed,Transfer,Cancelled,Excluded by Incidences';
            OptionMembers = Correct,Subscribed,Transfer,Cancelled,"Excluded by Incidences";
        }
        field(29; "Transition Status"; Option)
        {
            Caption = 'Transition Status';
            Editable = false;
            OptionCaption = ' ,Not Approved,Not Transited,Excluded,Exams Excluded,Resume School Process,Transit,Approved';
            OptionMembers = " ","Not Approved","Not Transited",Excluded,"Exams Excluded","Resume School Process",Transit,Approved;
        }
        field(30; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(32; "Status Date"; Date)
        {
            Caption = 'Status Date';
        }
        field(35; "Option Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;
        }
        field(36; "Formation Component"; Option)
        {
            Caption = 'Formation Component';
            OptionCaption = ' ,Specific,General,Technical';
            OptionMembers = " ",Specific,General,Technical;
        }
        field(37; "Absence Option"; Option)
        {
            Caption = 'Absence Option';
            OptionCaption = ' ,Half Absence,Unjustified Total,Total,Half Unjustified';
            OptionMembers = " ","Half Absence","Unjustified Total",Total,"Half Unjustified";
        }
        field(38; "Education Head Alert"; Boolean)
        {
            Caption = 'Education Head Alert';
        }
        field(39; "Recover Test"; Boolean)
        {
            Caption = 'Recover Test';
        }
        field(40; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(41; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(50; "Sub-subjects for assess. only"; Boolean)
        {
            Caption = 'Sub-subjects for assessments only';
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(73101; "User Session ID"; Code[20])
        {
            Caption = 'User Session ID';
        }
        field(73102; "No. Students"; Integer)
        {
            CalcFormula = Count("Registration Subjects" WHERE("School Year" = FIELD("School Year"),
                                                               "Schooling Year" = FIELD("Schooling Year"),
                                                               "Study Plan Code" = FIELD("Study Plan Code"),
                                                               "Subjects Code" = FIELD("Subjects Code"),
                                                               Enroled = FILTER(true)));
            Caption = 'No. Students';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Student Code No.", "School Year", "Schooling Year", "Study Plan Code", "Subjects Code", "Status Date")
        {
        }
        key(Key3; "School Year", "Schooling Year", Class, "Class No.", "Subjects Code", "Status Date")
        {
        }
        key(Key4; "School Year", "Schooling Year", Class, "Student Code No.", "Subjects Code", "Status Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := Today;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := Today;
    end;
}

