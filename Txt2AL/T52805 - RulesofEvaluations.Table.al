table 52805 "Rules of Evaluations"
{
    Caption = 'Rules of Evaluations';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial,Quadriennal';
            OptionMembers = " ",Annual,Biennial,Triennial,Quadriennal;
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                if "Schooling Year" <> '' then begin
                    rStruEduCountry.Reset;
                    rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                    if rStruEduCountry.FindFirst then
                        "Edu. Level" := rStruEduCountry."Edu. Level"
                    else
                        "Edu. Level" := 0;
                end else
                    "Edu. Level" := 0;
            end;
        }
        field(4; Formula; Text[100])
        {
            Caption = 'Formula';
        }
        field(5; "Value 1"; Option)
        {
            Caption = 'Value 1';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 1" <> xRec."Value 1" then
                    "Code Value 1" := '';
            end;
        }
        field(6; "Value 2"; Option)
        {
            Caption = 'Value 2';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 2" <> xRec."Value 2" then
                    "Code Value 2" := '';
            end;
        }
        field(7; "Value 3"; Option)
        {
            Caption = 'Value 3';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 3" <> xRec."Value 3" then
                    "Code Value 3" := '';
            end;
        }
        field(8; "Value 4"; Option)
        {
            Caption = 'Value 4';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 4" <> xRec."Value 4" then
                    "Code Value 4" := '';
            end;
        }
        field(9; "Value 5"; Option)
        {
            Caption = 'Value 5';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 5" <> xRec."Value 5" then
                    "Code Value 5" := '';
            end;
        }
        field(10; "Value 6"; Option)
        {
            Caption = 'Value 6';
            OptionCaption = ' ,Moment code,Schooling Year,Subject Group,Legal Code,All Subjects-Grade,Final Year,All Subjects - Qtd';
            OptionMembers = " ","Moment code","Schooling Year","Subject Group","Legal Code","All Subjects - Grade","Final Year","All Subjects - Qtd";

            trigger OnValidate()
            begin
                if "Value 6" <> xRec."Value 6" then
                    "Code Value 6" := '';
            end;
        }
        field(11; "Classifications Calculations"; Option)
        {
            Caption = 'Classifications Calculations';
            OptionCaption = ' ,CIF,CFD,Final Cycle,Final Stage,Final Year';
            OptionMembers = " ",CIF,CFD,"Final Cycle","Final Stage","Final Year";
        }
        field(12; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Without Exam,Witht Exam (Before exam),Witht Exam (After exam)';
            OptionMembers = " ","Sem Exame","Com Exame(antes exame)","Com Exame(Após Exame)";
        }
        field(13; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(14; "Assessment Amount"; Code[20])
        {
            Caption = 'Assessment Amount';
        }
        field(15; "Rule 1"; Decimal)
        {
            Caption = 'Rule 1';
        }
        field(16; "And Value 1"; Option)
        {
            Caption = 'And Value 1';
            OptionCaption = ' ,CIF,CFD,C10,C11,C12,CE';
            OptionMembers = " ",CIF,CFD,C10,C11,C12,CE;
        }
        field(17; "And Value 2"; Option)
        {
            Caption = 'And Value 2';
            OptionCaption = ' ,CIF,CFD,C10,C11,C12,CE';
            OptionMembers = " ",CIF,CFD,C10,C11,C12,CE;
        }
        field(18; "Rule 2"; Decimal)
        {
            Caption = 'Rule 2';
        }
        field(19; "Operation 1"; Option)
        {
            Caption = 'Operation 1';
            OptionCaption = ' ,<,>,>=';
            OptionMembers = " ","<",">",">=";
        }
        field(20; "Operation 2"; Option)
        {
            Caption = 'Operation 2';
            OptionCaption = ' ,<,>,>=';
            OptionMembers = " ","<",">",">=";
        }
        field(21; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
        }
        field(23; "Edu. Level"; Option)
        {
            Caption = 'Education Level';
            OptionCaption = ' ,Pre-Primary Edu.,Primary Edu.,Lower Secondary Edu.,Upper Secondary Edu.,Formative Cycles';
            OptionMembers = " ","Pre-Primary Edu.","Primary Edu.","Lower Secondary Edu.","Upper Secondary Edu.","Formative Cycles";
        }
        field(24; "Code Value 1"; Code[10])
        {
            Caption = 'Code Value 1';
            TableRelation = IF ("Value 1" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 1" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 1" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE("Legal Code Type" = FILTER(Simple | Multi),
                                                                                                                         Type = FILTER(Subject))
            ELSE IF ("Value 1" = FILTER("Moment code")) "Moments Assessment"."Moment Code";
        }
        field(25; "Code Value 2"; Code[10])
        {
            Caption = 'Code Value 2';
            TableRelation = IF ("Value 2" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 2" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 2" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                                                         "Legal Code Type" = FILTER(Simple | Multi))
            ELSE IF ("Value 2" = FILTER("Moment code")) "Moments Assessment"."Moment Code";
        }
        field(26; "Code Value 3"; Code[10])
        {
            Caption = 'Code Value 3';
            TableRelation = IF ("Value 3" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 3" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 3" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                                                         "Legal Code Type" = FILTER(Simple | Multi));
        }
        field(27; "Code Value 4"; Code[10])
        {
            Caption = 'Code Value 4';
            TableRelation = IF ("Value 4" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 4" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 4" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                                                         "Legal Code Type" = FILTER(Simple | Multi))
            ELSE IF ("Value 4" = FILTER("Moment code")) "Moments Assessment"."Moment Code";
        }
        field(28; "Code Value 5"; Code[10])
        {
            Caption = 'Code Value 5';
            TableRelation = IF ("Value 5" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 5" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 5" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                                                         "Legal Code Type" = FILTER(Simple | Multi))
            ELSE IF ("Value 5" = FILTER("Moment code")) "Moments Assessment"."Moment Code";
        }
        field(29; "Code Value 6"; Code[10])
        {
            Caption = 'Code Value 6';
            TableRelation = IF ("Value 6" = FILTER("Subject Group")) "Group Subjects".Code
            ELSE IF ("Value 6" = FILTER("Schooling Year")) "Structure Education Country"."Schooling Year"
            ELSE IF ("Value 6" = FILTER("Legal Code")) "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                                                         "Legal Code Type" = FILTER(Simple | Multi))
            ELSE IF ("Value 6" = FILTER("Moment code")) "Moments Assessment"."Moment Code";
        }
        field(30; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan/Course Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code
            ELSE IF (Type = FILTER(Multi)) "Course Header".Code;

            trigger OnLookup()
            var
                rStudyPlanHeader: Record "Study Plan Header";
                cStudentsRegistration: Codeunit "Students Registration";
                rRegistrationClassTEMP: Record "Registration Class" temporary;
                VarInt: Integer;
            begin
            end;
        }
        field(31; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(32; "Round Method"; Decimal)
        {
            Caption = 'Round Method';
            DecimalPlaces = 1 : 3;
            InitValue = 0.01;
            MaxValue = 1;
        }
        field(33; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
        }
        field(34; "Level Group"; Code[10])
        {
            Caption = 'Level Group';
        }
        field(35; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(36; "Rule Type"; Option)
        {
            OptionCaption = ' ,Subjects,Student';
            OptionMembers = ,Subject,Student;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rStruEduCountry: Record "Structure Education Country";
}

