table 52819 "Group Subjects"
{
    Caption = 'Group Subjects';
    DrillDownPageID = "Groups Subjects List";
    LookupPageID = "Groups Subjects List";
    Permissions = TableData "Assessing Students Final" = rimd;

    fields
    {
        field(1; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Description; Text[60])
        {
            Caption = 'Description';
        }
        field(4; Ponder; Integer)
        {
            BlankZero = true;
            Caption = 'Ponder';
            InitValue = 1;
        }
        field(5; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region".Code;
        }
        field(6; "Sorting ID"; Integer)
        {
            BlankZero = true;
            Caption = 'Sorting ID';
        }
        field(7; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if "Evaluation Type" <> xRec."Evaluation Type" then
                    Validate("Assessment Code", '');
            end;
        }
        field(8; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(9; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
                if rRankGroup.Get("Assessment Code") then begin
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative) or
                       (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                        rClassificationLevel.SetRange("Classification Level Code", "Minimum Classification Level");
                        if not rClassificationLevel.Find('-') then
                            Error(Text0001);

                    end;
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            Evaluate(l_TempValue, "Minimum Classification Level");
                            if (l_TempValue < rClassificationLevel."Min Value") or
                               (l_TempValue > rClassificationLevel."Max Value") then
                                Error(Text0002, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                        end;
                    end;

                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Code", "Schooling Year")
        {
            Clustered = true;
        }
        key(Key2; "Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Schooling Year" <> '' then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange("Option Group", Code);
            rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            if rStudyPlanLines.FindFirst then
                Error(Text001, rStudyPlanLines.Code, rStudyPlanLines."Subject Code");
        end;

        if "Schooling Year" = '' then begin
            rCourseLines.Reset;
            rCourseLines.SetRange("Option Group", Code);
            if rCourseLines.FindFirst then
                Error(Text001, rCourseLines.Code, rCourseLines."Subject Code");
        end;


        cInsertNAVMasterTable.DeleteSubjectGroup(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        "Country/Region Code" := cStudentsRegistration.GetCountry;

        //This step is now made by the study plan/Curse lines
        //cInsertNAVMasterTable.InsertSubjectGroup(Rec,xRec);
    end;

    trigger OnModify()
    var
        l_AssessingStudentsFinal: Record "Assessing Students Final";
    begin
        // Verify if group subjects has grades.
        if (Rec."Assessment Code" <> xRec."Assessment Code") then begin
            l_AssessingStudentsFinal.Reset;
            l_AssessingStudentsFinal.SetFilter("Evaluation Type", '%1|%2'
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Year Group"
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
            l_AssessingStudentsFinal.SetRange("Option Group", xRec.Code);
            if l_AssessingStudentsFinal.FindFirst then
                Error(Text0003, FieldCaption("Assessment Code"));
        end;


        cInsertNAVMasterTable.ModifySubjectGroup(Rec, xRec);
    end;

    trigger OnRename()
    begin
        Error(Text0003, TableCaption);
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        Text001: Label 'There are Subjects with this option Group. %1 %2';
        Text0001: Label 'You must specify a valid code.';
        Text0002: Label 'The value must be between %1 and %2.';
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
        Text0003: Label 'You cannot rename a %1.';
}

