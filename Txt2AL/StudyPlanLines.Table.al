table 31009758 "Study Plan Lines"
{
    Caption = 'Study Plan Line';
    DrillDownPageID = "Study Plan Lines List";
    LookupPageID = "Study Plan Lines List";
    Permissions = TableData "Assessing Students" = rimd,
                  TableData "Student Subjects Entry" = rimd,
                  TableData "Assessing Students Final" = rimd;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Study Plan Header".Code;
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Simple));
        }
        field(4; "Report Descripton"; Text[250])
        {
            Caption = 'Report Descripton';
        }
        field(6; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code WHERE(Type = FILTER(Subject));

            trigger OnValidate()
            begin
                if StudyPlanHeader.Get(Code) then begin
                    StudyPlanHeader.TestField("Schooling Year");
                    StudyPlanHeader.TestField("School Year");
                end;

                if (("Subject Code" = '') and (xRec."Subject Code" <> '')
                  or ("Subject Code" <> xRec."Subject Code") and (xRec."Subject Code" <> '')) then
                    ValidateSubject;

                if rSubjects.Get(rSubjects.Type::Subject, "Subject Code") then
                    "Subject Description" := rSubjects.Description
                else
                    "Subject Description" := '';
            end;
        }
        field(7; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
        }
        field(8; "Mandatory/Optional Type"; Option)
        {
            Caption = 'Mandatory/Optional Type';
            OptionCaption = ' ,Required,Optional';
            OptionMembers = " ",Required,Optional;

            trigger OnValidate()
            begin
                if (("Mandatory/Optional Type" = "Mandatory/Optional Type"::" ") and
                  (xRec."Mandatory/Optional Type" <> xRec."Mandatory/Optional Type"::" ")
                  or ("Mandatory/Optional Type" <> xRec."Mandatory/Optional Type") and
                   (xRec."Mandatory/Optional Type" <> xRec."Mandatory/Optional Type"::" ")) then
                    ValidateSubject;
            end;
        }
        field(9; "Curriculum Type"; Option)
        {
            Caption = 'Curriculum Type';
            OptionCaption = ' ,Disciplinary,Non disciplinary,Curriculum Enrichment,General,Specific';
            OptionMembers = " ",Disciplinary,"Non disciplinary"," Curriculum Enrichment",General,Specific;
        }
        field(10; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                exit;
                if "Evaluation Type" <> xRec."Evaluation Type" then
                    Validate("Assessment Code", '');

                if "Evaluation Type" = "Evaluation Type"::"None Qualification" then
                    "Subject Excluded From Assess." := true
                else
                    "Subject Excluded From Assess." := false;

                UpdateSubjects("School Year", "Schooling Year", Code, "Subject Code", "Evaluation Type", "Assessment Code");
            end;
        }
        field(12; "Legal Code"; Text[10])
        {
            Caption = 'Legal Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Simple));

            trigger OnValidate()
            begin
                ENESENEBCodes.Reset;
                ENESENEBCodes.SetRange(Type, ENESENEBCodes.Type::Subject);
                ENESENEBCodes.SetRange("Legal Code Type", ENESENEBCodes."Legal Code Type"::Simple);
                ENESENEBCodes.SetRange("Parish/Council/District Code", "Legal Code");
                if ENESENEBCodes.Find('-') then
                    "Legal Code Description" := ENESENEBCodes.Description
                else
                    "Legal Code Description" := '';
            end;
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(14; "Responsibility Center"; Code[10])
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
        field(15; "Maximum Unjustified Absences"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absences';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" < "Maximum Unjustified Absences") then
                    Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absences"));
            end;
        }
        field(16; "Assessment Code"; Code[30])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));

            trigger OnValidate()
            var
                rAssessingStudents: Record "Assessing Students";
                l_rRankGroup: Record "Rank Group";
            begin
                exit;
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Study Plan Code", Code);
                rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Simple);
                rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
                rRegistrationSubjects.SetFilter(Status, '<>%1', 0);
                if rRegistrationSubjects.FindFirst then
                    Error(Text0007);


                //InsertSettingRatings;

                l_rRankGroup.Reset;
                if l_rRankGroup.Get("Assessment Code") then
                    "Minimum Classification Level" := l_rRankGroup."Minimum Classification Level"
                else
                    "Minimum Classification Level" := '';

                UpdateSubjects("School Year", "Schooling Year", Code, "Subject Code", "Evaluation Type", "Assessment Code");
            end;
        }
        field(17; "Minimum Classification Level"; Code[20])
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
                if "Minimum Classification Level" <> '' then begin
                    TestField("Assessment Code");
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
                            Evaluate(l_TempValue, "Minimum Classification Level");
                            rClassificationLevel.Reset;
                            rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                            rClassificationLevel.SetFilter("Min Value", '<=%1', l_TempValue);
                            rClassificationLevel.SetFilter("Max Value", '>=%1', l_TempValue);
                            if not rClassificationLevel.Find('-') then
                                Error(Text0002);
                        end;
                    end;
                end;
            end;
        }
        field(18; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial';
            OptionMembers = " ",Annual,Biennial,Triennial;
        }
        field(19; "Maximum Total Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Total Absence';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" <> 0) then begin
                    if "Maximum Total Absence" < "Maximum Unjustified Absences" then
                        Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absences"));
                end;
            end;
        }
        field(21; "Option Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;

            trigger OnLookup()
            var
                rGroupSubjects: Record "Group Subjects";
            begin
                rGroupSubjects.Reset;
                rGroupSubjects.SetFilter("Schooling Year", "Schooling Year");
                rGroupSubjects.SetFilter("Country/Region Code", cStudentsRegistration.GetCountry);
                if rGroupSubjects.Find('-') then
                    if PAGE.RunModal(0, rGroupSubjects) = ACTION::LookupOK then
                        Validate("Option Group", rGroupSubjects.Code)
                //ELSE
                // MESSAGE(Text0006);
            end;

            trigger OnValidate()
            var
                rGroupSubjects: Record "Group Subjects";
            begin
                if "Option Group" <> '' then begin
                    rGroupSubjects.Reset;
                    rGroupSubjects.SetFilter("Schooling Year", "Schooling Year");
                    rGroupSubjects.SetFilter("Country/Region Code", cStudentsRegistration.GetCountry);
                    rGroupSubjects.SetRange(Code, "Option Group");
                    if not rGroupSubjects.Find('-') then
                        Error(Text0008);
                end;
            end;
        }
        field(30; "Legal Exam Code"; Text[4])
        {
            Caption = 'Legal Exam Code';
            Description = 'ENES';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Exams),
                                                                                "Legal Code Type" = FILTER(Simple));

            trigger OnValidate()
            begin
                ENESENEBCodes.Reset;
                ENESENEBCodes.SetRange(Type, ENESENEBCodes.Type::Exams);
                ENESENEBCodes.SetRange("Legal Code Type", ENESENEBCodes."Legal Code Type"::Simple);
                ENESENEBCodes.SetRange("Parish/Council/District Code", "Legal Exam Code");
                if ENESENEBCodes.Find('-') then
                    "Legal Code Description" := ENESENEBCodes.Description
                else
                    "Legal Code Description" := '';
            end;
        }
        field(31; "Legal Exam Description"; Text[61])
        {
            Caption = 'Legal Exam Description';
        }
        field(32; "Legal Code Description"; Text[61])
        {
            Caption = 'Legal Code Description';
        }
        field(33; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(34; "Continuous Assessment"; Boolean)
        {
            Caption = 'Continuous Assessment';
        }
        field(41; "Legal Reports Sorting ID"; Integer)
        {
            Caption = 'Legal Reports Sorting ID';
        }
        field(49; "Sub-subjects for assess. only"; Boolean)
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
        field(73100; "Sub-Subject"; Boolean)
        {
            CalcFormula = Exist("Study Plan Sub-Subjects Lines" WHERE(Type = FILTER("Study Plan"),
                                                                       Code = FIELD(Code),
                                                                       "Subject Code" = FIELD("Subject Code")));
            Caption = 'Sub-Subject';
            FieldClass = FlowField;
        }
        field(73101; Observations; Code[20])
        {
            Caption = 'Observations';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab),
                                                    "School Year" = FIELD("School Year"),
                                                    "Observation Type" = CONST(Assessement));
        }
        field(73102; Weighting; Integer)
        {
            Caption = 'Weighting';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;
        }
        field(73103; "Subject Excluded From Assess."; Boolean)
        {
            Caption = 'Subject Excluded From Assessment';
        }
        field(75000; "Disciplinary Area Code"; Code[10])
        {
            Caption = 'Disciplinary Area Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = CONST(Disc));

            trigger OnValidate()
            var
                rTableMISI: Record "Table MISI";
            begin
                rTableMISI.Reset;
                rTableMISI.SetRange(rTableMISI.Type, rTableMISI.Type::Disc);
                rTableMISI.SetRange(rTableMISI.Code, "Disciplinary Area Code");
                if rTableMISI.FindFirst then
                    "Disciplinary Area Description" := rTableMISI.Description
                else
                    "Disciplinary Area Description" := '';
            end;
        }
        field(75001; "Disciplinary Area Description"; Text[160])
        {
            Caption = 'Disciplinary Area Desc.';
            Description = 'MISI';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "School Year", "Schooling Year", "Subject Code")
        {
            Clustered = true;
        }
        key(Key2; "Code", "School Year", "Schooling Year", "Curriculum Type")
        {
        }
        key(Key3; "Option Group", "Subject Code")
        {
        }
        key(Key4; "Option Group", "Sorting ID")
        {
        }
        key(Key5; "Code", "School Year", "Schooling Year", "Sorting ID")
        {
        }
        key(Key6; "Option Group", "Legal Reports Sorting ID")
        {
        }
        key(Key7; "Subject Code", "Legal Reports Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_StudyPlanLines: Record "Study Plan Lines";
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Simple);
        rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        //rRegistrationSubjects.SETRANGE(Enroled,TRUE);
        rRegistrationSubjects.SetFilter(Status, '<>%1', rRegistrationSubjects.Status::" ");
        rRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
        if rRegistrationSubjects.FindFirst then
            Error(Text0005);


        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Simple);
        rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        //rRegistrationSubjects.SETRANGE(Enroled,FALSE);
        rRegistrationSubjects.SetFilter(Status, '<>%1', rRegistrationSubjects.Status::" ");
        rRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
        rRegistrationSubjects.DeleteAll;


        recSettingRatings.Reset;
        recSettingRatings.SetRange("School Year", "School Year");
        recSettingRatings.SetRange("Study Plan Code", Code);
        recSettingRatings.SetRange("Subject Code", "Subject Code");
        recSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        recSettingRatings.DeleteAll(true);

        recAspects.Reset;
        recAspects.SetRange(Type, recAspects.Type::"Study Plan");
        recAspects.SetRange("School Year", "School Year");
        recAspects.SetRange("Type No.", Code);
        recAspects.SetRange(Subjects, "Subject Code");
        recAspects.SetRange("Responsibility Center", "Responsibility Center");
        recAspects.DeleteAll(true);

        if "Sub-Subject" then begin
            rStudyPlanSubSubjectsLines.Reset;
            rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", "Schooling Year");
            rStudyPlanSubSubjectsLines.SetRange(Code, Code);
            rStudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
            rStudyPlanSubSubjectsLines.SetRange("Responsibility Center", "Responsibility Center");
            rStudyPlanSubSubjectsLines.DeleteAll(true);
        end;

        //Test if the subject group is the last in the study plan before delete
        if "Option Group" <> '' then begin
            l_StudyPlanLines.Reset;
            l_StudyPlanLines.SetRange(Code, Code);
            l_StudyPlanLines.SetRange("School Year", "School Year");
            l_StudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            l_StudyPlanLines.SetRange("Option Group", "Option Group");
            if l_StudyPlanLines.Count = 1 then
                cInsertNAVMasterTable.DeleteSubjectGroupPLClass(Rec, xRec);
        end;

        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            cInsertNAVMasterTable.DeleteSubjectPLClass(Rec, xRec);
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetSP(Rec, true);
        end;
    end;

    trigger OnInsert()
    var
        l_StudyPlanLines: Record "Study Plan Lines";
    begin
        if StudyPlanHeader.Get(Code) then begin
            "School Year" := StudyPlanHeader."School Year";
            "Schooling Year" := StudyPlanHeader."Schooling Year";
            "Responsibility Center" := StudyPlanHeader."Responsibility Center";
            "Sub-subjects for assess. only" := StudyPlanHeader."Sub-subjects for assess. only";
        end;

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        "User Id" := UserId;
        Date := WorkDate;

        //Test if the subject group allredy exists for this study plan
        if "Option Group" <> '' then begin
            l_StudyPlanLines.Reset;
            l_StudyPlanLines.SetRange(Code, Code);
            l_StudyPlanLines.SetRange("School Year", "School Year");
            l_StudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            l_StudyPlanLines.SetRange("Option Group", "Option Group");
            if not l_StudyPlanLines.FindSet then
                cInsertNAVMasterTable.InsertSubjectGroupPLClass(Rec, xRec);
        end;

        CalcFields("Sub-Subject");
        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then
            cInsertNAVMasterTable.InsertSubjectPLClass(Rec, xRec, "Sub-Subject");
    end;

    trigger OnModify()
    var
        l_StudyPlanLines: Record "Study Plan Lines";
        lRegistrationSubjects: Record "Registration Subjects";
        lStudentSubjectsEntry: Record "Student Subjects Entry";
        l_AssessingStudentsFinal: Record "Assessing Students Final";
    begin
        // Verify if group subjects has grades.
        if "Option Group" <> xRec."Option Group" then begin
            l_AssessingStudentsFinal.Reset;
            l_AssessingStudentsFinal.SetFilter("Evaluation Type", '%1|%2'
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Year Group"
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
            l_AssessingStudentsFinal.SetRange("Study Plan Code", Code);
            l_AssessingStudentsFinal.SetRange("Option Group", xRec."Option Group");
            l_AssessingStudentsFinal.SetRange(Subject, "Subject Code");
            if l_AssessingStudentsFinal.FindFirst then
                Error(Text0017, FieldCaption("Option Group"))
        end;



        //Change all subjects Groups for the active year in the Registration Subjects to the reports
        if ("Option Group" <> xRec."Option Group") or
           ("Subject Excluded From Assess." <> xRec."Subject Excluded From Assess.")
           or ("Subject Excluded From Assess." <> xRec."Subject Excluded From Assess.") or
           ("Sorting ID" <> xRec."Sorting ID") or ("Evaluation Type" <> xRec."Evaluation Type") or
           ("Assessment Code" <> xRec."Assessment Code") or
           ("Minimum Classification Level" <> xRec."Minimum Classification Level") or
           ("Report Descripton" <> xRec."Report Descripton") or
           ("Legal Code" <> xRec."Legal Code") or ("Legal Reports Sorting ID" <> xRec."Legal Reports Sorting ID") or
           ("Continuous Assessment" <> xRec."Continuous Assessment") or ("Mandatory/Optional Type" <> xRec."Mandatory/Optional Type")
           then begin

            lRegistrationSubjects.Reset;
            lRegistrationSubjects.SetRange("School Year", "School Year");
            lRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
            lRegistrationSubjects.SetRange(Type, lRegistrationSubjects.Type::Simple);
            lRegistrationSubjects.SetRange("Study Plan Code", Code);
            if "Option Group" <> xRec."Option Group" then
                lRegistrationSubjects.ModifyAll("Option Group", "Option Group", true);

            if "Subject Excluded From Assess." <> xRec."Subject Excluded From Assess." then
                lRegistrationSubjects.ModifyAll("Subject Excluded From Assess.", "Subject Excluded From Assess.", true);

            if "Continuous Assessment" <> xRec."Continuous Assessment" then
                lRegistrationSubjects.ModifyAll("Continuous Assessment", "Continuous Assessment", true);

            if "Sorting ID" <> xRec."Sorting ID" then
                lRegistrationSubjects.ModifyAll("Sorting ID", "Sorting ID", true);

            if "Legal Reports Sorting ID" <> xRec."Legal Reports Sorting ID" then
                lRegistrationSubjects.ModifyAll("Legal Reports Sorting ID", "Legal Reports Sorting ID", true);

            if "Evaluation Type" <> xRec."Evaluation Type" then
                lRegistrationSubjects.ModifyAll("Evaluation Type", "Evaluation Type", true);

            if "Mandatory/Optional Type" <> xRec."Mandatory/Optional Type" then
                lRegistrationSubjects.ModifyAll("Mandatory/Optional Type", "Mandatory/Optional Type", true);

            if "Assessment Code" <> xRec."Assessment Code" then
                lRegistrationSubjects.ModifyAll("Assessment Code", "Assessment Code", true);

            if "Minimum Classification Level" <> xRec."Minimum Classification Level" then
                lRegistrationSubjects.ModifyAll("Minimum Classification Level", "Minimum Classification Level", true);

            if "Maximum Total Absence" <> xRec."Maximum Total Absence" then
                lRegistrationSubjects.ModifyAll("Maximum Justified Absence", "Maximum Total Absence", true);

            if "Maximum Unjustified Absences" <> xRec."Maximum Unjustified Absences" then
                lRegistrationSubjects.ModifyAll("Maximum Injustified Absence", "Maximum Unjustified Absences", true);

            if "Option Group" <> xRec."Option Group" then
                lRegistrationSubjects.ModifyAll("Option Group", "Option Group", true);

            if "Report Descripton" <> xRec."Report Descripton" then
                lRegistrationSubjects.ModifyAll("Report Description", "Report Descripton", true);

            if "Legal Code" <> xRec."Legal Code" then
                lRegistrationSubjects.ModifyAll("Legal Code", "Legal Code", true);

            if "Continuous Assessment" <> xRec."Continuous Assessment" then
                lRegistrationSubjects.ModifyAll("Continuous Assessment", "Continuous Assessment", true);


            //Change the lStudentSubjectsEntry for the active School Year
            lStudentSubjectsEntry.Reset;
            lStudentSubjectsEntry.SetRange("School Year", "School Year");
            lStudentSubjectsEntry.SetRange("Subjects Code", "Subject Code");
            lStudentSubjectsEntry.SetRange(Type, lRegistrationSubjects.Type::Simple);
            lStudentSubjectsEntry.SetRange("Study Plan Code", Code);
            if "Option Group" <> xRec."Option Group" then
                lStudentSubjectsEntry.ModifyAll("Option Group", "Option Group", true);

            if "Evaluation Type" <> xRec."Evaluation Type" then
                lStudentSubjectsEntry.ModifyAll("Evaluation Type", "Evaluation Type", true);

            if "Assessment Code" <> xRec."Assessment Code" then
                lStudentSubjectsEntry.ModifyAll("Assessment Code", "Assessment Code", true);

            if "Minimum Classification Level" <> xRec."Minimum Classification Level" then
                lStudentSubjectsEntry.ModifyAll("Minimum Classification Level", "Minimum Classification Level", true);

            if "Maximum Total Absence" <> xRec."Maximum Total Absence" then
                lStudentSubjectsEntry.ModifyAll("Maximum Justified Absence", "Maximum Total Absence", true);

            if "Maximum Unjustified Absences" <> xRec."Maximum Unjustified Absences" then
                lStudentSubjectsEntry.ModifyAll("Maximum Injustified Absence", "Maximum Unjustified Absences", true);

            if "Option Group" <> xRec."Option Group" then
                lStudentSubjectsEntry.ModifyAll("Option Group", "Option Group", true);

        end;

        //Change the sub subjects lines
        if "Sub-Subject" then begin
            rStudyPlanSubSubjectsLines.Reset;
            rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", "Schooling Year");
            rStudyPlanSubSubjectsLines.SetRange(Code, Code);
            rStudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
            rStudyPlanSubSubjectsLines.SetRange("Responsibility Center", "Responsibility Center");
            rStudyPlanSubSubjectsLines.ModifyAll("Option Group", "Option Group");
            rStudyPlanSubSubjectsLines.ModifyAll("Subject Description", "Subject Description", true);
        end;

        //Test if the subject group allredy exists for this study plan
        if "Option Group" <> '' then begin
            l_StudyPlanLines.Reset;
            l_StudyPlanLines.SetRange(Code, Code);
            l_StudyPlanLines.SetRange("School Year", "School Year");
            l_StudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            l_StudyPlanLines.SetRange("Option Group", "Option Group");
            if not l_StudyPlanLines.FindSet then
                cInsertNAVMasterTable.InsertSubjectGroupPLClass(Rec, xRec);
        end;
        if ("Option Group" = '') and (xRec."Option Group" <> '') then begin
            l_StudyPlanLines.Reset;
            l_StudyPlanLines.SetRange(Code, Code);
            l_StudyPlanLines.SetRange("School Year", "School Year");
            l_StudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            l_StudyPlanLines.SetRange("Option Group", xRec."Option Group");
            if l_StudyPlanLines.Count = 1 then
                cInsertNAVMasterTable.DeleteSubjectGroupPLClass(Rec, xRec);
        end;

        //Test if the evaluation type if None Qualification and delete or update web lines
        if ("Evaluation Type" = "Evaluation Type"::"None Qualification") and
          ((xRec."Evaluation Type" <> xRec."Evaluation Type"::"None Qualification") or
          (xRec."Evaluation Type" <> xRec."Evaluation Type"::" ")) then begin
            cInsertNAVMasterTable.DeleteSubjectPLClass(Rec, xRec);
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetSP(Rec, true);
        end;
        CalcFields("Sub-Subject");
        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            cInsertNAVMasterTable.InsertSubjectPLClass(Rec, xRec, "Sub-Subject");
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetSP(Rec, false);
        end;
    end;

    trigger OnRename()
    begin
        CalcFields("Sub-Subject");
        if xRec."Sub-Subject" then
            Error(Text0006, "Subject Code");

        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0017, TableCaption);*/
    end;

    var
        rSubjects: Record Subjects;
        StudyPlanHeader: Record "Study Plan Header";
        cStudentsRegistration: Codeunit "Students Registration";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        ENESENEBCodes: Record "Legal Codes";
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
        Text0001: Label 'You must specify a valid code.';
        Text0002: Label 'The inserted value is not defined on the Setting Evaluations list.';
        Text0003: Label 'There are no moments for the School year %1 and Schooling Year %2.';
        rRegistrationSubjects: Record "Registration Subjects";
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        recSettingRatings: Record "Setting Ratings";
        recAspects: Record Aspects;
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0005: Label 'You cannot eliminate lines.';
        Text0006: Label 'The subject %1 has sub-subjects. You must first delete the sub-subjects.';
        Text0007: Label 'The Assessement Code cannot be changed.';
        Text0008: Label 'There is no Code in the Selection.';
        Text0009: Label 'There are no configurations of aspects overall.';
        Text0010: Label 'To set the setting ratings you need to set the Setting Moments for this school year(s)';
        Text0011: Label 'To use this option please configure the Study Plan Setting Ratings for the subject %1.';
        Text0013: Label 'The field %1 must be higher than the field %2.';
        Text0016: Label 'Not allowed to modify the subject. There are students with the subject.';
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        Text0017: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";

    //[Scope('OnPrem')]
    procedure OpenCreateAssessmentConf()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Overall);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then
            Error(Text0009);


        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", "School Year");
        l_rMoments.SetRange("Schooling Year", "Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMoments."Moment Code" + ','
            until l_rMoments.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMoments.SetRange("School Year", "School Year");
            l_rMoments.SetRange("Schooling Year", "Schooling Year");
            l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 1
            else
                exit;

            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
            l_rSettingRatings.SetRange("School Year", "School Year");
            l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code", Code);
            l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
            l_rSettingRatings.SetRange("Subject Code", "Subject Code");
            l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
            if not l_rSettingRatings.Find('-') then begin
                l_rSettingRatings.Init;
                l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                l_rSettingRatings."School Year" := "School Year";
                l_rSettingRatings."Schooling Year" := "Schooling Year";
                l_rSettingRatings."Study Plan Code" := Code;
                l_rSettingRatings."Subject Code" := "Subject Code";
                l_rSettingRatings."Assessment Code" := "Assessment Code";
                l_rSettingRatings."Responsibility Center" := "Responsibility Center";
                l_rSettingRatings."Moment Ponder" := Weighting;
                l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                l_rSettingRatings."Sorting ID" := "Sorting ID";
                l_rSettingRatings.Insert(true);

                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", "School Year");
                l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Code);
                l_rSettingRatings.SetRange("Subject Code", "Subject Code");
                l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                if l_rSettingRatings.Find('-') then;
                //FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings2);
            end;
            //ELSE begin
            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code");
            l_rSettingRatings.SetRange("School Year");
            l_rSettingRatings.SetRange("Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code");
            l_rSettingRatings.SetRange("Subject Code");
            //Aspects
            SubjectsAspects(l_rMoments."Moment Code");
            //
            PAGE.Run(PAGE::"Setting Ratings", l_rSettingRatings);
            //end;
        end else
            Error(Text0010);
    end;

    //[Scope('OnPrem')]
    procedure InsertSettingRatings()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        l_RegistrationSubjects: Record "Registration Subjects";
        l_Aspects: Record Aspects;
    begin
        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", "School Year");
        l_rMoments.SetRange("Schooling Year", "Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.Find('-') then begin
            repeat
                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", "School Year");
                l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Code);
                l_rSettingRatings.SetRange("Subject Code", "Subject Code");
                l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                if not l_rSettingRatings.Find('-') then begin
                    l_rSettingRatings.Init;
                    l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                    l_rSettingRatings."School Year" := "School Year";
                    l_rSettingRatings."Schooling Year" := "Schooling Year";
                    l_rSettingRatings."Study Plan Code" := Code;
                    l_rSettingRatings."Subject Code" := "Subject Code";
                    l_rSettingRatings."Assessment Code" := "Assessment Code";
                    l_rSettingRatings."Moment Ponder" := Weighting;
                    l_rSettingRatings."Responsibility Center" := "Responsibility Center";
                    l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                    l_rSettingRatings."Sorting ID" := "Sorting ID";
                    l_rSettingRatings.Insert(true);
                end else begin
                    l_rSettingRatings."Assessment Code" := "Assessment Code";
                    l_rSettingRatings.Modify;
                end;
            until l_rMoments.Next = 0;
            l_RegistrationSubjects.Reset;
            l_RegistrationSubjects.SetRange("School Year", "School Year");
            l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
            l_RegistrationSubjects.SetRange("Study Plan Code", Code);
            l_RegistrationSubjects.SetRange("Subjects Code", "Subject Code");
            if l_RegistrationSubjects.Find('-') then begin
                repeat
                    l_RegistrationSubjects."Evaluation Type" := "Evaluation Type";
                    l_RegistrationSubjects."Assessment Code" := "Assessment Code";
                    l_RegistrationSubjects.Modify;
                until l_RegistrationSubjects.Next = 0;
            end;
            l_Aspects.Reset;
            l_Aspects.SetRange(Type, l_Aspects.Type::"Study Plan");
            l_Aspects.SetRange("School Year", "School Year");
            l_Aspects.SetRange("Type No.", Code);
            l_Aspects.SetRange("Schooling Year", "Schooling Year");
            l_Aspects.SetRange("Moment Code", l_rMoments."Moment Code");
            l_Aspects.SetRange(Subjects, "Subject Code");
            if l_Aspects.Find('-') then begin
                repeat
                    l_Aspects."Evaluation Type" := "Evaluation Type";
                    l_Aspects."Assessment Code" := "Assessment Code";
                    l_Aspects.Modify;
                until l_Aspects.Next = 0;
            end;

        end else
            Error(Text0003, "School Year", "Schooling Year");
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects(pMomentCode: Code[10])
    var
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::"Study Plan");
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Sub Subjects", '');
        rAspects.SetRange("Moment Code", pMomentCode);
        if not rAspects.Find('-') then begin
            //rAspects.InsertDefaultAspects(rAspects,rAspects.Type::"Study Plan","School Year","Subject Code");
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::"Study Plan", "School Year", Code, pMomentCode,
                               "Schooling Year", "Subject Code", '', "Evaluation Type", "Assessment Code", "Responsibility Center");

            Commit;
        end;

        //fAspects.SETTABLEVIEW(rAspects);
        //FORM.RUNMODAL(FORM::Aspects,rAspects);;
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects2(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20])
    var
        rAspects: Record Aspects;
        l_rMoments: Record "Moments Assessment";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        lSettingRatings: Record "Setting Ratings";
        int: Integer;
        tAssessment: Text[1024];
    begin
        l_rMomentsTEMP.DeleteAll;

        lSettingRatings.Reset;
        lSettingRatings.SetRange("School Year", pSchoolYear);
        lSettingRatings.SetRange("Schooling Year", pSchoolingYear);
        lSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        lSettingRatings.SetRange("Type Education", lSettingRatings."Type Education"::Simple);
        lSettingRatings.SetRange("Study Plan Code", Code);
        lSettingRatings.SetRange(Type, lSettingRatings.Type::Header);
        lSettingRatings.SetRange("Subject Code", "Subject Code");
        if lSettingRatings.FindSet then begin
            repeat
                l_rMoments.Reset;
                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                l_rMoments.SetRange("School Year", pSchoolYear);
                l_rMoments.SetRange("Schooling Year", pSchoolingYear);
                l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
                l_rMoments.SetRange("Moment Code", lSettingRatings."Moment Code");
                if l_rMoments.Find('-') then begin
                    l_rMomentsTEMP.Init;
                    l_rMomentsTEMP.TransferFields(l_rMoments);
                    l_rMomentsTEMP.Insert;
                end;
            until lSettingRatings.Next = 0;
        end else
            Error(Text0011, "Subject Code");

        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMomentsTEMP.SetRange("School Year", "School Year");
        l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
        l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMomentsTEMP.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMomentsTEMP."Moment Code" + ','
            until l_rMomentsTEMP.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMoments.SetRange("School Year", "School Year");
            l_rMoments.SetRange("Schooling Year", "Schooling Year");
            l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 1
            else
                exit;
        end;

        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Class);
        rAspects.SetRange("School Year", pSchoolYear);
        rAspects.SetRange("Type No.", pClass);
        rAspects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Sub Subjects", '');
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Class, pSchoolYear, pClass, l_rMomentsTEMP."Moment Code",
                               pSchoolingYear, "Subject Code", '', "Evaluation Type", "Assessment Code", "Responsibility Center");

            Commit;
        end;

        PAGE.RunModal(PAGE::Aspects, rAspects);
        ;
    end;

    //[Scope('OnPrem')]
    procedure CreateAssessmentConfAll()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_rMoments: Record "Moments Assessment";
        l_CourseHeader: Record "Course Header";
        l_CourseLines: Record "Course Lines";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        tSchoolingYear: Text[1024];
        int: Integer;
        Flag: Boolean;
        varCharacteriseSubjects: Integer;
        varCount: Integer;
        rAspects: Record Aspects;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Overall);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then
            Error(Text0009);

        //Normatica 2013.11.15 - apagar tudo para criar tudo novamente
        l_rSettingRatings.Reset;
        l_rSettingRatings.SetRange("School Year", "School Year");
        l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
        l_rSettingRatings.SetRange("Study Plan Code", Code);
        l_rSettingRatings.SetRange("Subject Code", "Subject Code");
        l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        if l_rSettingRatings.Find('-') then
            l_rSettingRatings.DeleteAll;

        l_SRSubSubjects.Reset;
        l_SRSubSubjects.SetRange("School Year", "School Year");
        l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
        l_SRSubSubjects.SetRange("Study Plan Code", Code);
        l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
        if l_SRSubSubjects.Find('-') then
            l_SRSubSubjects.DeleteAll;

        //Normatica fim

        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", "School Year");
        l_rMoments.SetRange("Schooling Year", "Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.Find('-') then begin
            repeat
                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", "School Year");
                l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Code);
                l_rSettingRatings.SetRange("Subject Code", "Subject Code");
                l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                if not l_rSettingRatings.Find('-') then begin
                    l_rSettingRatings.Init;
                    l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                    l_rSettingRatings."School Year" := "School Year";
                    l_rSettingRatings."Schooling Year" := "Schooling Year";
                    l_rSettingRatings."Study Plan Code" := Code;
                    l_rSettingRatings."Subject Code" := "Subject Code";
                    l_rSettingRatings."Moment Ponder" := Weighting;
                    l_rSettingRatings."Assessment Code" := "Assessment Code";
                    l_rSettingRatings."Responsibility Center" := "Responsibility Center";
                    l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                    l_rSettingRatings."Type Education" := l_rSettingRatings."Type Education"::Simple;
                    l_rSettingRatings."Sorting ID" := "Sorting ID";
                    l_rSettingRatings.Insert(true);
                end;
                l_rSettingRatings."Assessment Code" := "Assessment Code";
                l_rSettingRatings.Modify(true);

                //
                SubjectsAspectsAll(l_rMoments."Moment Code", "Schooling Year", "Subject Code", '');
                //
                //InsertSubSubjects
                l_StudyPlanSubSubjectsLines.Reset;
                l_StudyPlanSubSubjectsLines.SetRange(Type, l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                l_StudyPlanSubSubjectsLines.SetRange(Code, Code);
                l_StudyPlanSubSubjectsLines.SetRange("Schooling Year", "Schooling Year");
                l_StudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
                if l_StudyPlanSubSubjectsLines.FindSet then
                    repeat
                        l_SRSubSubjects.Reset;
                        l_SRSubSubjects.SetRange("Moment Code", l_rMoments."Moment Code");
                        l_SRSubSubjects.SetRange("School Year", "School Year");
                        l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
                        l_SRSubSubjects.SetRange("Study Plan Code", Code);
                        l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
                        l_SRSubSubjects.SetRange("Sub-Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");
                        if not l_SRSubSubjects.Find('-') then begin

                            l_SRSubSubjects.Init;
                            l_SRSubSubjects."Moment Code" := l_rMoments."Moment Code";
                            l_SRSubSubjects."School Year" := "School Year";
                            l_SRSubSubjects."Schooling Year" := "Schooling Year";
                            l_SRSubSubjects."Study Plan Code" := Code;
                            l_SRSubSubjects."Subject Code" := "Subject Code";
                            if l_StudyPlanSubSubjectsLines."Assessment Code" <> '' then
                                l_SRSubSubjects."Assessment Code" := l_StudyPlanSubSubjectsLines."Assessment Code"
                            else
                                l_SRSubSubjects."Assessment Code" := "Assessment Code";

                            //l_SRSubSubjects."Assessment Code" := "Assessment Code";
                            l_SRSubSubjects.Type := l_SRSubSubjects.Type::Header;
                            l_SRSubSubjects."Responsibility Center" := "Responsibility Center";
                            l_SRSubSubjects."Sub-Subject Code" := l_StudyPlanSubSubjectsLines."Sub-Subject Code";
                            l_SRSubSubjects."Sub-Subject Description" := l_StudyPlanSubSubjectsLines."Sub-Subject Description";
                            l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Simple;
                            l_SRSubSubjects."Moment Ponder" := l_StudyPlanSubSubjectsLines."Moment Ponder";
                            l_SRSubSubjects."Sorting ID" := l_StudyPlanSubSubjectsLines."Sorting ID";
                            l_SRSubSubjects.Insert(true);
                        end else begin
                            l_SRSubSubjects."Assessment Code" := l_StudyPlanSubSubjectsLines."Assessment Code";
                            l_SRSubSubjects.Modify(true);
                        end;
                        SubjectsAspectsAll(l_rMoments."Moment Code", "Schooling Year",
                          "Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");
                    until l_StudyPlanSubSubjectsLines.Next = 0;
            until l_rMoments.Next = 0;
        end else
            Error(Text0010);
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspectsAll(pMomentCode: Code[10]; pSchoolingYear: Code[10]; pSubject: Code[20]; pSubSubject: Code[20])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::"Study Plan");
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, pSubject);
        rAspects.SetRange("Sub Subjects", pSubSubject);
        rAspects.SetRange("Moment Code", pMomentCode);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::"Study Plan", "School Year", Code, pMomentCode,
                               pSchoolingYear, pSubject, pSubSubject, "Evaluation Type", "Assessment Code", "Responsibility Center");
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateSubject()
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Simple);
        rRegistrationSubjects.SetRange("Subjects Code", xRec."Subject Code");
        rRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
        if rRegistrationSubjects.FindFirst then
            Error(Text0016);
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubjects(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pCode: Code[20]; pSubjectsCode: Code[10]; pEvaluationType: Option; pAssessmentCode: Code[20])
    var
        StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        SettingRatings: Record "Setting Ratings";
        SettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin

        StudyPlanSubSubjectsLines.Reset;
        StudyPlanSubSubjectsLines.SetRange(Type, StudyPlanSubSubjectsLines.Type::"Study Plan");
        StudyPlanSubSubjectsLines.SetRange(Code, pCode);
        StudyPlanSubSubjectsLines.SetRange("Schooling Year", pSchoolingYear);
        StudyPlanSubSubjectsLines.SetRange("Subject Code", pSubjectsCode);
        StudyPlanSubSubjectsLines.ModifyAll("Assessment Code", pAssessmentCode);
        StudyPlanSubSubjectsLines.ModifyAll("Evaluation Type", pEvaluationType);

        SettingRatingsSubSubjects.Reset;
        SettingRatingsSubSubjects.SetRange("Study Plan Code", pCode);
        SettingRatingsSubSubjects.SetRange("School Year", pSchoolYear);
        SettingRatingsSubSubjects.SetRange("Schooling Year", pSchoolingYear);
        SettingRatingsSubSubjects.SetRange("Subject Code", pSubjectsCode);
        SettingRatingsSubSubjects.ModifyAll("Assessment Code", pAssessmentCode);


        SettingRatings.Reset;
        SettingRatings.SetRange("School Year", pSchoolYear);
        SettingRatings.SetRange("Schooling Year", pSchoolingYear);
        SettingRatings.SetRange("Study Plan Code", pCode);
        SettingRatings.SetRange("Subject Code", pSubjectsCode);
        SettingRatings.ModifyAll("Assessment Code", pAssessmentCode);
    end;

    //[Scope('OnPrem')]
    procedure CreateAssessmentConfStudyPlan()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_rMoments: Record "Moments Assessment";
        l_CourseHeader: Record "Course Header";
        l_CourseLines: Record "Course Lines";
        l_StudyPlanLines: Record "Study Plan Lines";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        tSchoolingYear: Text[1024];
        int: Integer;
        Flag: Boolean;
        varCharacteriseSubjects: Integer;
        varCount: Integer;
        rAspects: Record Aspects;
        l_StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
    begin
        l_StudyPlanLines.Reset;
        l_StudyPlanLines.SetRange(l_StudyPlanLines.Code, Code);
        l_StudyPlanLines.SetRange(l_StudyPlanLines."School Year", "School Year");
        l_StudyPlanLines.SetRange(l_StudyPlanLines."Schooling Year", "Schooling Year");
        if l_StudyPlanLines.FindSet then begin
            repeat
                if l_StudyPlanLines."Evaluation Type" <> l_StudyPlanLines."Evaluation Type"::"None Qualification" then begin

                    rAspects.Reset;
                    rAspects.SetRange(Type, rAspects.Type::Overall);
                    rAspects.SetRange("Responsibility Center", l_StudyPlanLines."Responsibility Center");
                    if not rAspects.Find('-') then
                        Error(Text0009);

                    l_rMoments.Reset;
                    l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                    l_rMoments.SetRange("School Year", l_StudyPlanLines."School Year");
                    l_rMoments.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year");
                    l_rMoments.SetRange("Responsibility Center", l_StudyPlanLines."Responsibility Center");
                    if l_rMoments.Find('-') then begin
                        repeat
                            l_rSettingRatings.Reset;
                            l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                            l_rSettingRatings.SetRange("School Year", l_StudyPlanLines."School Year");
                            l_rSettingRatings.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year");
                            l_rSettingRatings.SetRange("Study Plan Code", l_StudyPlanLines.Code);
                            l_rSettingRatings.SetRange("Subject Code", l_StudyPlanLines."Subject Code");
                            l_rSettingRatings.SetRange("Responsibility Center", l_StudyPlanLines."Responsibility Center");
                            if not l_rSettingRatings.Find('-') then begin
                                l_rSettingRatings.Init;
                                l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                                l_rSettingRatings."School Year" := l_StudyPlanLines."School Year";
                                l_rSettingRatings."Schooling Year" := l_StudyPlanLines."Schooling Year";
                                l_rSettingRatings."Study Plan Code" := l_StudyPlanLines.Code;
                                l_rSettingRatings."Subject Code" := l_StudyPlanLines."Subject Code";
                                l_rSettingRatings."Moment Ponder" := l_StudyPlanLines.Weighting;
                                l_rSettingRatings."Assessment Code" := l_StudyPlanLines."Assessment Code";
                                l_rSettingRatings."Responsibility Center" := l_StudyPlanLines."Responsibility Center";
                                l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                                l_rSettingRatings."Type Education" := l_rSettingRatings."Type Education"::Simple;
                                l_rSettingRatings."Sorting ID" := l_StudyPlanLines."Sorting ID";
                                l_rSettingRatings.Insert(true);
                            end;
                            l_rSettingRatings."Assessment Code" := l_StudyPlanLines."Assessment Code";
                            l_rSettingRatings.Modify(true);

                            //
                            SubjectsAspectsAll(l_rMoments."Moment Code", l_StudyPlanLines."Schooling Year", l_StudyPlanLines."Subject Code", '');
                            //
                            //InsertSubSubjects
                            l_StudyPlanSubSubjectsLines.Reset;
                            l_StudyPlanSubSubjectsLines.SetRange(Type, l_StudyPlanSubSubjectsLines.Type::"Study Plan");
                            l_StudyPlanSubSubjectsLines.SetRange(Code, l_StudyPlanLines.Code);
                            l_StudyPlanSubSubjectsLines.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year");
                            l_StudyPlanSubSubjectsLines.SetRange("Subject Code", l_StudyPlanLines."Subject Code");
                            if l_StudyPlanSubSubjectsLines.FindSet then
                                repeat
                                    l_SRSubSubjects.Reset;
                                    l_SRSubSubjects.SetRange("Moment Code", l_rMoments."Moment Code");
                                    l_SRSubSubjects.SetRange("School Year", l_StudyPlanLines."School Year");
                                    l_SRSubSubjects.SetRange("Schooling Year", l_StudyPlanLines."Schooling Year");
                                    l_SRSubSubjects.SetRange("Study Plan Code", l_StudyPlanLines.Code);
                                    l_SRSubSubjects.SetRange("Subject Code", l_StudyPlanLines."Subject Code");
                                    l_SRSubSubjects.SetRange("Sub-Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");
                                    if not l_SRSubSubjects.Find('-') then begin

                                        l_SRSubSubjects.Init;
                                        l_SRSubSubjects."Moment Code" := l_rMoments."Moment Code";
                                        l_SRSubSubjects."School Year" := l_StudyPlanLines."School Year";
                                        l_SRSubSubjects."Schooling Year" := l_StudyPlanLines."Schooling Year";
                                        l_SRSubSubjects."Study Plan Code" := l_StudyPlanLines.Code;
                                        l_SRSubSubjects."Subject Code" := l_StudyPlanLines."Subject Code";
                                        if l_StudyPlanSubSubjectsLines."Assessment Code" <> '' then
                                            l_SRSubSubjects."Assessment Code" := l_StudyPlanSubSubjectsLines."Assessment Code"
                                        else
                                            l_SRSubSubjects."Assessment Code" := l_StudyPlanLines."Assessment Code";

                                        //l_SRSubSubjects."Assessment Code" := l_StudyPlanLines."Assessment Code";
                                        l_SRSubSubjects.Type := l_SRSubSubjects.Type::Header;
                                        l_SRSubSubjects."Responsibility Center" := l_StudyPlanLines."Responsibility Center";
                                        l_SRSubSubjects."Sub-Subject Code" := l_StudyPlanSubSubjectsLines."Sub-Subject Code";
                                        l_SRSubSubjects."Sub-Subject Description" := l_StudyPlanSubSubjectsLines."Sub-Subject Description";
                                        l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Simple;
                                        l_SRSubSubjects."Moment Ponder" := l_StudyPlanSubSubjectsLines."Moment Ponder";
                                        l_SRSubSubjects."Sorting ID" := l_StudyPlanSubSubjectsLines."Sorting ID";
                                        l_SRSubSubjects.Insert(true);
                                    end else begin
                                        l_SRSubSubjects."Assessment Code" := l_StudyPlanSubSubjectsLines."Assessment Code";
                                        l_SRSubSubjects.Modify(true);
                                    end;
                                    SubjectsAspectsAll(l_rMoments."Moment Code", l_StudyPlanLines."Schooling Year",
                                      l_StudyPlanLines."Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");
                                until l_StudyPlanSubSubjectsLines.Next = 0;
                        until l_rMoments.Next = 0;
                    end else
                        Error(Text0010);
                end;
            until l_StudyPlanLines.Next = 0;
        end;
    end;
}

