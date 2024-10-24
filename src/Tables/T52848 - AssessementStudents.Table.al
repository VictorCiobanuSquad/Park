table 52848 "Assessement Students"
{
    Caption = 'Assessement Students';
    LookupPageID = "Setting Ratings Subjects List";
    Permissions = TableData "Assessing Students" = rimd,
                  TableData "Assessement Students" = rimd;

    fields
    {
        field(1; "Moment Code"; Code[10])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code" WHERE("School Year" = FIELD("School Year"),
                                                                      "Schooling Year" = FIELD("Schooling Year"),
                                                                      "Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(4; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code;
        }
        field(5; Description; Text[64])
        {
            Caption = 'Description';
        }
        field(6; "Criterion 1"; Text[200])
        {
            Caption = 'Criterion 1';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(7; "Criterion 2"; Text[200])
        {
            Caption = 'Criterion 2';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(8; "Criterion 3"; Text[200])
        {
            Caption = 'Criterion 3';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(9; "Assessment Code"; Code[20])
        {
            Caption = 'AssessmentCode';
            TableRelation = "Rank Group".Code;
        }
        field(10; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(11; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(12; Grade; Decimal)
        {
            Caption = 'Grade';

            trigger OnValidate()
            begin
                if Grade <> 0 then begin
                    if rRankGroup.Get("Assessment Code") then begin
                        if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then begin
                            rClassificationLevel.Reset;
                            rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                            if rClassificationLevel.FindFirst then begin
                                if not ((rClassificationLevel."Min Value" <= Grade) and
                                   (rClassificationLevel."Max Value" >= Grade)) then
                                    Error(text003, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(13; "Qualitative Grade"; Code[20])
        {
            Caption = 'Qualitative Grade';

            trigger OnLookup()
            begin
                "Qualitative Grade" := LookupFunction(true);
            end;

            trigger OnValidate()
            begin
                //"Qualitative Grade" := LookupFunction(FALSE);
            end;
        }
        field(14; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(16; "Responsibility Center"; Code[10])
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
        field(17; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(18; "Study Plan Code"; Code[50])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                                 "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
        }
        field(19; "Evaluation Moment"; Option)
        {
            Caption = 'Evaluation Moment';
            OptionCaption = ' ,Interim,Final,Test,Others';
            OptionMembers = " ",Interim,Final,Test,Others;
        }
        field(20; "Type Education"; Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
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
    }

    keys
    {
        key(Key1; "Moment Code", Class, "School Year", "Schooling Year", "Subject Code", "Student Code No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rMomentsAssessment: Record "Moments Assessment";
        Text001: Label 'There is no valide code selected.';
        Text002: Label 'Type of evaluation criterion is not Qualitative.';
        rClassificationLevel: Record "Classification Level";
        text003: Label 'Note should be between %1 and %2.';
        rRankGroup: Record "Rank Group";
        Text004: Label 'Type of evaluation criterion is not Quantitative.';
        varQualitativeGrade: Code[20];
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';


    procedure LookupFunction(pLookUp: Boolean) Out: Code[20]
    begin
        if rRankGroup.Get("Assessment Code") then begin
            if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then begin
                if pLookUp then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                    if rClassificationLevel.Find('-') then begin
                        if PAGE.RunModal(PAGE::"List Grades", rClassificationLevel) = ACTION::LookupOK then
                            exit(rClassificationLevel."Classification Level Code")
                        else
                            exit("Qualitative Grade");
                    end
                end;

                if pLookUp = false then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                    rClassificationLevel.SetRange("Classification Level Code", "Qualitative Grade");
                    if not rClassificationLevel.FindFirst then
                        Error(Text001)
                    else
                        exit("Qualitative Grade");
                end;
            end;
        end;
    end;


    procedure InsertAssessment()
    var
        rAssessingStudents: Record "Assessing Students";
        rAssessementStudents: Record "Assessement Students";
        vartotalGrade: Decimal;
    begin
        rAssessementStudents.Reset;
        rAssessementStudents.SetRange("Moment Code", "Moment Code");
        rAssessementStudents.SetRange(Class, Class);
        rAssessementStudents.SetRange("School Year", "School Year");
        rAssessementStudents.SetRange("Schooling Year", "Schooling Year");
        rAssessementStudents.SetRange("Subject Code", "Subject Code");
        rAssessementStudents.SetRange("Student Code No.", "Student Code No.");
        if rAssessementStudents.Find('-') then begin
            repeat

                vartotalGrade += rAssessementStudents.Grade;

            until rAssessementStudents.Next = 0;
            GetCodeAssessment(vartotalGrade);
        end;


        if rAssessingStudents.Get(Class, "School Year", "Schooling Year", "Subject Code",
                                 "Study Plan Code", "Student Code No.", "Moment Code") then begin

            if rAssessingStudents."Evaluation Moment" = rAssessingStudents."Evaluation Moment"::Test then begin
                rAssessingStudents."Qualitative Grade" := varQualitativeGrade;
                rAssessingStudents.Grade := vartotalGrade;
                rAssessingStudents.Modify;
            end;


        end else begin
            rAssessingStudents.Init;
            if rMomentsAssessment.Get("Moment Code", "School Year", "Schooling Year") then;
            rAssessingStudents.Class := Class;
            rAssessingStudents."School Year" := "School Year";
            rAssessingStudents."Schooling Year" := "Schooling Year";
            rAssessingStudents.Subject := "Subject Code";
            rAssessingStudents."Study Plan Code" := "Study Plan Code";
            rAssessingStudents."Evaluation Moment" := rMomentsAssessment."Evaluation Moment";
            rAssessingStudents."Student Code No." := "Student Code No.";
            rAssessingStudents."Moment Code" := "Moment Code";
            rAssessingStudents."Qualitative Grade" := "Qualitative Grade";
            rAssessingStudents.Grade := vartotalGrade;

            rAssessingStudents.Insert;

        end;
    end;


    procedure GetCodeAssessment(InGrade: Decimal)
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
        rSettingRatings: Record "Setting Ratings";
    begin
        Clear(varQualitativeGrade);

        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", "Moment Code");
        rSettingRatings.SetRange("School Year", "School Year");
        rSettingRatings.SetRange("Schooling Year", "Schooling Year");
        rSettingRatings.SetRange("Subject Code", "Subject Code");
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        if rSettingRatings.FindFirst then begin
            if rRankGroup.Get(rSettingRatings."Assessment Code") then begin
                rClassificationLevelMin.Reset;
                rClassificationLevelMin.SetCurrentKey("Id Ordination");
                rClassificationLevelMin.Ascending(true);
                rClassificationLevelMin.SetRange("Classification Group Code", rSettingRatings."Assessment Code");
                if rClassificationLevelMin.FindFirst then
                    VarMinValue := rClassificationLevelMin."Min Value";

                rClassificationLevelMax.Reset;
                rClassificationLevelMax.SetCurrentKey("Id Ordination");
                rClassificationLevelMax.Ascending(false);
                rClassificationLevelMax.SetRange("Classification Group Code", rSettingRatings."Assessment Code");
                if rClassificationLevelMax.FindFirst then
                    VarMaxValue := rClassificationLevelMax."Max Value";

                if (VarMinValue <= InGrade) and
                   (VarMaxValue >= InGrade) then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", rSettingRatings."Assessment Code");
                    rClassificationLevel.SetRange(Value, InGrade);
                    if rClassificationLevel.FindFirst then
                        varQualitativeGrade := rClassificationLevel."Classification Level Code";
                end;
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", rSettingRatings."Assessment Code");
                if rClassificationLevel.Find('-') then begin
                    repeat
                        if (rClassificationLevel."Min Value" <= InGrade) and
                           (rClassificationLevel."Max Value" >= InGrade) then
                            varQualitativeGrade := rClassificationLevel."Classification Level Code";
                    until rClassificationLevel.Next = 0

                end;
            end;
        end;
    end;
}

