table 31009847 "Assessing Students"
{
    Caption = 'Assessing Students';
    Permissions = TableData "Assessing Students" = rimd;

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
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(4; Subject; Code[20])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(5; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                                 "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
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
            OptionCaption = ' ,Interim,Final Moment,Test,Others,Final Year,CIF,EXN1,EXN2,CFD,,,,,CFDa';
            OptionMembers = " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD,,,,,CFDa;
        }
        field(9; "Moment Code"; Code[20])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code" WHERE("School Year" = FIELD("School Year"),
                                                                      "Schooling Year" = FIELD("Schooling Year"));
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
        field(25; "Recuperation Grade"; Decimal)
        {
            Caption = 'Recuperation Grade';
        }
        field(26; "Recuperation Qualitative Grade"; Text[50])
        {
            Caption = 'Recuperation Qualitative Grade';
            CharAllowed = 'AZ';
        }
        field(27; "Grade Calc"; Decimal)
        {
            Caption = 'Calc. Grade';
        }
        field(28; "Qualitative Grade Calc"; Text[50])
        {
            Caption = 'Qualitative Grade Calc.';
            CharAllowed = 'AZ';
        }
        field(29; "Has Individual Plan"; Boolean)
        {
            Caption = 'Has Individual Plan';
        }
        field(30; "Scholarship Reinforcement"; Boolean)
        {
            Caption = 'Scholarship Reinforcement';
        }
        field(31; "Scholarship Support"; Boolean)
        {
            Caption = 'Scholarship Support';
        }
        field(32; "Continuous Assessment"; Boolean)
        {
            Caption = 'Continuous Assessment';
        }
        field(75500; "Term Book"; Text[10])
        {
            Caption = 'Term Book';
            Description = 'ENES';
        }
        field(75501; "Term Sheet"; Text[10])
        {
            Caption = 'Term Sheet';
            Description = 'ENES';
        }
    }

    keys
    {
        key(Key1; Class, "School Year", "Schooling Year", Subject, "Sub-Subject Code", "Study Plan Code", "Student Code No.", "Moment Code")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year", "Evaluation Moment")
        {
        }
        key(Key3; "Student Code No.", "School Year", "Moment Code")
        {
        }
        key(Key4; Class, "Student Code No.", "School Year", "Moment Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cInsertNAVGeneralTable.DeleteAssessment(Rec);
    end;

    trigger OnInsert()
    begin
        "Country/Region Code" := cStudentsRegistration.GetCountry;

        ValidateContAss;

        if ("Evaluation Moment" = "Evaluation Moment"::"Final Year") and ("Type Education" = "Type Education"::Multi) then
            cCalcEvaluations.Calc(Rec);

        cInsertNAVGeneralTable.UpdateAssessment(Rec);
    end;

    trigger OnModify()
    begin
        ValidateContAss;

        if ("Evaluation Moment" = "Evaluation Moment"::"Final Year") and ("Type Education" = "Type Education"::Multi) then
            cCalcEvaluations.Calc(Rec);


        cInsertNAVGeneralTable.UpdateAssessment(Rec);
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        cCalcEvaluations: Codeunit "Calc. Evaluations";
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;

    //[Scope('OnPrem')]
    procedure ValidateContAss()
    var
        l_RegistrationSubjects: Record "Registration Subjects";
        l_AssessingStudents: Record "Assessing Students";
        l_ClassificationLevel: Record "Classification Level";
        l_ClassificationLevel2: Record "Classification Level";
        l_MomentsAssessment: Record "Moments Assessment";
        l_MomentsAssessment2: Record "Moments Assessment";
    begin



        l_MomentsAssessment.Reset;
        l_MomentsAssessment.SetRange("Moment Code", "Moment Code");
        l_MomentsAssessment.SetRange("School Year", "School Year");
        l_MomentsAssessment.SetRange("Schooling Year", "Schooling Year");
        if l_MomentsAssessment.FindFirst then;


        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetRange("Student Code No.", "Student Code No.");
        l_RegistrationSubjects.SetRange("School Year", "School Year");
        l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
        l_RegistrationSubjects.SetRange("Subjects Code", Subject);
        l_RegistrationSubjects.SetRange("Continuous Assessment", true);
        l_RegistrationSubjects.SetRange(Status, l_RegistrationSubjects.Status::Subscribed);
        if l_RegistrationSubjects.FindFirst then begin
            l_MomentsAssessment2.Reset;
            l_MomentsAssessment2.SetCurrentKey("School Year", "Schooling Year", "Sorting ID");
            l_MomentsAssessment2.SetRange("School Year", "School Year");
            l_MomentsAssessment2.SetRange("Schooling Year", "Schooling Year");
            l_MomentsAssessment2.SetRange("Evaluation Moment", l_MomentsAssessment2."Evaluation Moment"::"Final Moment");
            if l_MomentsAssessment2.FindSet then begin
                repeat
                    if l_MomentsAssessment2."Moment Code" <> "Moment Code" then begin
                        l_AssessingStudents.Reset;
                        l_AssessingStudents.SetRange("School Year", "School Year");
                        l_AssessingStudents.SetRange("Schooling Year", "Schooling Year");
                        l_AssessingStudents.SetRange(Subject, l_RegistrationSubjects."Subjects Code");
                        l_AssessingStudents.SetRange("Sub-Subject Code", '');
                        l_AssessingStudents.SetRange("Evaluation Moment", l_AssessingStudents."Evaluation Moment"::"Final Moment");
                        l_AssessingStudents.SetFilter("Moment Code", l_MomentsAssessment2."Moment Code");
                        l_AssessingStudents.SetRange("Student Code No.", "Student Code No.");
                        if l_AssessingStudents.FindFirst then begin
                            if l_ClassificationLevel.Get(l_RegistrationSubjects."Assessment Code",
                                          l_RegistrationSubjects."Minimum Classification Level") then begin

                                if (l_RegistrationSubjects."Evaluation Type" = l_RegistrationSubjects."Evaluation Type"::"Mixed-Qualification") or
                                 (l_RegistrationSubjects."Evaluation Type" = l_RegistrationSubjects."Evaluation Type"::Qualitative) then
                                    if l_MomentsAssessment.Recuperation then begin
                                        if l_ClassificationLevel2.Get(l_RegistrationSubjects."Assessment Code", "Recuperation Qualitative Grade") then;
                                        if ("Recuperation Grade" <> 0) and
                                            (l_ClassificationLevel2."Id Ordination" >= l_ClassificationLevel."Id Ordination") then begin
                                            if l_AssessingStudents."Recuperation Grade" = 0 then begin
                                                l_AssessingStudents."Recuperation Grade" := l_ClassificationLevel.Value;
                                                l_AssessingStudents."Recuperation Qualitative Grade" := l_ClassificationLevel."Classification Level Code";
                                                l_AssessingStudents."Continuous Assessment" := true;
                                            end;
                                        end else begin
                                            if l_AssessingStudents."Continuous Assessment" then begin
                                                l_AssessingStudents."Recuperation Grade" := 0;
                                                l_AssessingStudents."Recuperation Qualitative Grade" := '';
                                                l_AssessingStudents."Continuous Assessment" := false;
                                            end;
                                        end;
                                    end;
                                if l_MomentsAssessment.Active then begin
                                    if l_ClassificationLevel2.Get(l_RegistrationSubjects."Assessment Code", "Qualitative Grade") then;
                                    if (Grade <> 0) and
                                        (l_ClassificationLevel2."Id Ordination" >= l_ClassificationLevel."Id Ordination") then begin
                                        if l_AssessingStudents."Recuperation Grade" = 0 then begin
                                            l_AssessingStudents."Recuperation Grade" := l_ClassificationLevel.Value;
                                            l_AssessingStudents."Recuperation Qualitative Grade" := l_ClassificationLevel."Classification Level Code";
                                            l_AssessingStudents."Continuous Assessment" := true;
                                        end;
                                    end else begin
                                        if l_AssessingStudents."Continuous Assessment" then begin
                                            l_AssessingStudents."Recuperation Grade" := 0;
                                            l_AssessingStudents."Recuperation Qualitative Grade" := '';
                                            l_AssessingStudents."Continuous Assessment" := false;
                                        end;
                                    end;

                                end;
                                l_AssessingStudents.Modify;
                                //WEB
                                cInsertNAVGeneralTable.UpdateAssessment(l_AssessingStudents)
                            end;
                        end;
                    end;
                until l_MomentsAssessment2.Next = 0;
            end;
        end;
    end;
}

