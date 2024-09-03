table 52803 "Course Lines"
{
    Caption = 'Course Line';
    DrillDownPageID = "List Course Lines";
    LookupPageID = "List Course Lines";
    Permissions = TableData "Assessing Students" = rimd,
                  TableData Absence = rimd,
                  TableData "Student Subjects Entry" = rimd,
                  TableData MasterTableWEB = rimd,
                  TableData "Assessing Students Final" = rimd;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Course Header".Code;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Schooling Year Begin"; Code[10])
        {
            Caption = 'Beginning Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Multi));

            trigger OnValidate()
            var
                l_StruEducCountry: Record "Structure Education Country";
                rCourseHeader: Record "Course Header";
                l_StruEducCountry2: Record "Structure Education Country";
                l_StruEducCountry3: Record "Structure Education Country";
            begin
                if "Schooling Year Begin" <> '' then begin
                    if (("Schooling Year Begin" = '') and (xRec."Schooling Year Begin" <> '')
                      or (xRec."Schooling Year Begin" <> "Schooling Year Begin") and (xRec."Schooling Year Begin" <> '')) then
                        ValidateSubject;


                    if rCourseHeader.Get(Code) then;

                    l_StruEducCountry.Reset;
                    l_StruEducCountry.SetRange("Schooling Year", rCourseHeader."Schooling Year Begin");
                    l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
                    if l_StruEducCountry.FindFirst then;

                    l_StruEducCountry2.Reset;
                    l_StruEducCountry2.SetRange("Schooling Year", "Schooling Year Begin");
                    l_StruEducCountry2.SetRange(Type, l_StruEducCountry.Type::Multi);
                    l_StruEducCountry2.SetRange("Edu. Level", l_StruEducCountry."Edu. Level");
                    if l_StruEducCountry2.FindFirst then;


                    l_StruEducCountry3.Reset;
                    l_StruEducCountry3.SetRange(Type, l_StruEducCountry3.Type::Multi);
                    l_StruEducCountry3.SetRange("Edu. Level", l_StruEducCountry."Edu. Level");
                    l_StruEducCountry3.SetRange("Sorting ID", l_StruEducCountry2."Sorting ID" + "Characterise Subjects" - 1);
                    if not l_StruEducCountry3.FindFirst then
                        Error(Text0014);


                    if l_StruEducCountry."Sorting ID" > l_StruEducCountry2."Sorting ID" then
                        Error(Text0014);

                    if l_StruEducCountry."Edu. Level" <> l_StruEducCountry2."Edu. Level" then
                        Error(Text0018);

                    if l_StruEducCountry."Absence Type" <> l_StruEducCountry2."Absence Type" then
                        Error(Text0015);
                end;
            end;
        }
        field(4; "Report Descripton"; Text[250])
        {
            Caption = 'Report Description';
        }
        field(5; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code;

            trigger OnValidate()
            var
                l_rMasterTableWEB: Record MasterTableWEB;
            begin
                if "Line No." <> 0 then begin
                    l_rMasterTableWEB.Reset;
                    l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::Subjects);
                    l_rMasterTableWEB.SetRange("Type Education", l_rMasterTableWEB."Type Education"::Multi);
                    l_rMasterTableWEB.SetRange(StudyPlanCode, Code);
                    l_rMasterTableWEB.SetRange("Subject Code", xRec."Subject Code");
                    l_rMasterTableWEB.SetRange("Sub-Subject Code", '');
                    l_rMasterTableWEB.SetRange(LineNow, "Line No.");
                    if FindFirst then
                        Error(Text0020, TableCaption);
                end;


                if xRec."Sub-Subject" then
                    Error(Text0019, "Subject Code");

                if (("Subject Code" = '') and (xRec."Subject Code" <> '')
                  or (xRec."Subject Code" <> "Subject Code") and (xRec."Subject Code" <> '')) then
                    ValidateSubject;


                if rSubjects.Get(rSubjects.Type::Subject, "Subject Code") then
                    "Subject Description" := rSubjects.Description
                else
                    "Subject Description" := '';
            end;
        }
        field(6; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
        }
        field(7; "Mandatory/Optional Type"; Option)
        {
            Caption = 'Mandatory/Optional Type';
            OptionCaption = ' ,Required,Optional,Free Choice';
            OptionMembers = " ",Required,Optional,"Free Choice";

            trigger OnValidate()
            begin
                if (("Mandatory/Optional Type" = "Mandatory/Optional Type"::" ") and
                  (xRec."Mandatory/Optional Type" <> xRec."Mandatory/Optional Type"::" ")
                  or ("Mandatory/Optional Type" <> xRec."Mandatory/Optional Type") and
                   (xRec."Mandatory/Optional Type" <> xRec."Mandatory/Optional Type"::" ")) then
                    ValidateSubject;
            end;
        }
        field(8; "Curriculum Type"; Option)
        {
            Caption = 'Curriculum Type';
            OptionCaption = ' ,Disciplinary,Non disciplinary,Curriculum Enrichment';
            OptionMembers = " ",Disciplinary,"Non disciplinary","Curriculum Enrichment";
        }
        field(9; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if xRec."Evaluation Type" <> xRec."Evaluation Type"::" " then
                    if "Evaluation Type" <> xRec."Evaluation Type" then
                        Validate("Assessment Code", '');

                if "Evaluation Type" = "Evaluation Type"::"None Qualification" then
                    "Subject Excluded From Assess." := true
                else
                    "Subject Excluded From Assess." := false;

                UpdateSubjects("School Year Begin", Code, "Subject Code", "Assessment Code", "Evaluation Type");
            end;
        }
        field(10; "Legal Code"; Text[10])
        {
            Caption = 'Legal Code';
            Description = 'ENES';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Multi));

            trigger OnValidate()
            begin
                ENESENEBCodes.Reset;
                ENESENEBCodes.SetRange(Type, ENESENEBCodes.Type::Subject);
                ENESENEBCodes.SetRange("Legal Code Type", ENESENEBCodes."Legal Code Type"::Multi);
                ENESENEBCodes.SetRange("Parish/Council/District Code", "Legal Code");
                if ENESENEBCodes.Find('-') then
                    "ENES Description" := ENESENEBCodes.Description
                else
                    "ENES Description" := '';
            end;
        }
        field(12; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(13; "Responsibility Center"; Code[10])
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
        field(15; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));

            trigger OnValidate()
            var
                rAssessingStudents: Record "Assessing Students";
                l_rRankGroup: Record "Rank Group";
            begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Study Plan Code", Code);
                rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Multi);
                rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
                rRegistrationSubjects.SetRange("Original Line No.", "Line No.");
                rRegistrationSubjects.SetFilter(Status, '<>%1', 0);
                if rRegistrationSubjects.FindFirst then
                    Error(Text0007);

                //OpenCreateAssessmentConf;

                l_rRankGroup.Reset;
                if l_rRankGroup.Get("Assessment Code") then
                    "Minimum Classification Level" := l_rRankGroup."Minimum Classification Level"
                else
                    "Minimum Classification Level" := '';

                UpdateSubjects("School Year Begin", Code, "Subject Code", "Assessment Code", "Evaluation Type");
            end;
        }
        field(16; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
                rClassificationLevel: Record "Classification Level";
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
            end;
        }
        field(17; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial,Quadriennal';
            OptionMembers = " ",Annual,Biennial,Triennial,Quadriennal;

            trigger OnValidate()
            var
                l_StruEducCountry: Record "Structure Education Country";
                l_StruEducCountry2: Record "Structure Education Country";
                l_StruEducCountry3: Record "Structure Education Country";
                VarCount: Integer;
                l_text0001: Label 'The Course length is %1 year.';
                SortingIdBegin: Integer;
                SortingIdEnd: Integer;
            begin
                //IF (("Characterise Subjects" = "Characterise Subjects"::" ") AND
                //  (xRec."Characterise Subjects" <> xRec."Characterise Subjects"::" ")
                //  OR ("Characterise Subjects" <> xRec."Characterise Subjects") AND
                //   (xRec."Characterise Subjects" <> xRec."Characterise Subjects"::" ")) THEN
                ValidateSubject;

                if rCourseHeader.Get(Code) then;

                l_StruEducCountry.Reset;
                l_StruEducCountry.SetCurrentKey("Sorting ID");
                l_StruEducCountry.SetRange("Schooling Year", rCourseHeader."Schooling Year Begin");
                if l_StruEducCountry.FindFirst then
                    SortingIdBegin := l_StruEducCountry."Sorting ID";

                l_StruEducCountry3.Reset;
                l_StruEducCountry3.SetCurrentKey("Sorting ID");
                l_StruEducCountry3.SetRange("Edu. Level", l_StruEducCountry."Edu. Level");
                if l_StruEducCountry3.FindLast then
                    SortingIdEnd := l_StruEducCountry3."Sorting ID";


                VarCount := 0;
                l_StruEducCountry2.Reset;
                l_StruEducCountry2.SetCurrentKey("Sorting ID");
                l_StruEducCountry2.SetRange("Sorting ID", SortingIdBegin, SortingIdEnd);
                if l_StruEducCountry2.FindSet then begin
                    repeat
                        VarCount += 1;
                    until l_StruEducCountry2.Next = 0;
                end;


                if (VarCount = 1) and ("Characterise Subjects" > 1) then
                    Error(l_text0001, VarCount);

                if (VarCount = 2) and ("Characterise Subjects" > 2) then
                    Error(l_text0001, VarCount);

                if (VarCount = 3) and ("Characterise Subjects" > 3) then
                    Error(l_text0001, VarCount);


                if "Characterise Subjects" = "Characterise Subjects"::Quadriennal then
                    "Schooling Year Begin" := rCourseHeader."Schooling Year Begin"
                else
                    "Schooling Year Begin" := '';
            end;
        }
        field(18; "Maximum Justified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Justified Absence';
        }
        field(19; "Exam Last Year"; Boolean)
        {
            Caption = 'Exam Last Year';
        }
        field(20; "School Year Begin"; Code[9])
        {
            Caption = 'School Year Begin';
            TableRelation = "School Year"."School Year";
        }
        field(21; "Option Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;

            trigger OnLookup()
            begin

                rOptionGroup.Reset;
                rOptionGroup.SetRange("Schooling Year", '');
                rOptionGroup.SetFilter("Country/Region Code", cStudentsRegistration.GetCountry);
                if rOptionGroup.Find('-') then begin
                    if PAGE.RunModal(PAGE::"Groups Subjects List", rOptionGroup) = ACTION::LookupOK then begin
                        Validate("Option Group", rOptionGroup.Code);

                    end;
                end else
                    Error(Text0008);
            end;

            trigger OnValidate()
            begin
                if "Option Group" <> '' then begin
                    rOptionGroup.Reset;
                    rOptionGroup.SetRange(Code, "Option Group");
                    rOptionGroup.SetRange("Schooling Year", '');
                    rOptionGroup.SetFilter("Country/Region Code", cStudentsRegistration.GetCountry);
                    if not rOptionGroup.FindFirst then
                        Error(Text0008);
                end;
            end;
        }
        field(22; "Formation Component"; Option)
        {
            Caption = 'Formation Component';
            OptionCaption = ' ,Specific,General,Technical';
            OptionMembers = " ",Specific,General,Technical;

            trigger OnValidate()
            begin
                if (("Formation Component" = "Formation Component"::" ") and
                  (xRec."Formation Component" <> xRec."Formation Component"::" ")
                  or ("Formation Component" <> xRec."Mandatory/Optional Type") and
                   (xRec."Formation Component" <> xRec."Formation Component"::" ")) then
                    ValidateSubject;
            end;
        }
        field(23; "Maximum Unjustified Absences"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absences';

            trigger OnValidate()
            begin
                if ("Maximum Total Absences" < "Maximum Unjustified Absences") and ("Maximum Total Absences" <> 0) then
                    Error(Text0013, FieldCaption("Maximum Total Absences"), FieldCaption("Maximum Unjustified Absences"));

                //PT
                VerificarFaltas(Code, "Subject Code");
            end;
        }
        field(24; "Maximum Total Absences"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Total Absences';

            trigger OnValidate()
            begin
                if ("Maximum Total Absences" <> 0) then begin
                    if "Maximum Total Absences" < "Maximum Unjustified Absences" then
                        Error(Text0013, FieldCaption("Maximum Total Absences"), FieldCaption("Maximum Unjustified Absences"));
                end;

                //PT
                VerificarFaltas(Code, "Subject Code");
            end;
        }
        field(32; "ENES Description"; Text[61])
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
        field(40; "Sub-subjects for assess. only"; Boolean)
        {
            Caption = 'Sub-subjects for assessments only';
        }
        field(41; "Legal Reports Sorting ID"; Integer)
        {
            Caption = 'Legal Reports Sorting ID';
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
            CalcFormula = Exist("Study Plan Sub-Subjects Lines" WHERE(Type = FILTER(Course),
                                                                       Code = FIELD(Code),
                                                                       "Subject Code" = FIELD("Subject Code"),
                                                                       "Line No." = FIELD("Line No.")));
            Caption = 'Sub-Subject';
            FieldClass = FlowField;
        }
        field(73101; Observations; Code[20])
        {
            Caption = 'Observations';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab),
                                                    "Observation Type" = FILTER(Assessement));

            trigger OnValidate()
            begin
                if rCourseHeader.Get(Code) then;

                rObservation.Reset;
                rObservation.SetRange("Observation Type", rObservation."Observation Type"::Assessement);
                rObservation.SetFilter("School Year", '<%1', rCourseHeader."School Year Begin");
                if rObservation.FindSet then;
            end;
        }
        field(73102; Weighting; Integer)
        {
            Caption = 'Weighting';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;

            trigger OnValidate()
            begin
                //ValidateWeighting;
            end;
        }
        field(73103; "Subject Excluded From Assess."; Boolean)
        {
            Caption = 'Subject Excluded From Assessment';
        }
        field(73104; "Temp Class"; Code[20])
        {
            Caption = 'Temp. Class';
        }
        field(73105; "Temp School Year"; Code[9])
        {
            Caption = 'Temp School Year';
        }
        field(73106; Credits; Decimal)
        {
            Caption = 'Credits';
        }
        field(73107; Hours; Decimal)
        {
            Caption = 'Hours';
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
        key(Key1; "Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Option Group", "Subject Code")
        {
        }
        key(Key3; "Option Group", "Sorting ID")
        {
        }
        key(Key4; "Subject Code", "Sorting ID")
        {
        }
        key(Key5; "Subject Code", "Legal Reports Sorting ID")
        {
        }
        key(Key6; "Option Group", "Legal Reports Sorting ID")
        {
        }
        key(Key7; "Sorting ID")
        {
        }
        key(Key8; "Legal Reports Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_StruEducCountry: Record "Structure Education Country";
        l_StruEducCountry2: Record "Structure Education Country";
        lCourseLines: Record "Course Lines";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Multi);
        rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        rRegistrationSubjects.SetRange("Original Line No.", "Line No.");
        //rRegistrationSubjects.SETRANGE(Enroled,TRUE);
        rRegistrationSubjects.SetFilter(Status, '<>%1', rRegistrationSubjects.Status::" ");
        if rRegistrationSubjects.FindFirst then
            Error(Text0005);

        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Multi);
        rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        //rRegistrationSubjects.SETRANGE(Enroled,FALSE);
        rRegistrationSubjects.SetFilter(Status, '<>%1', rRegistrationSubjects.Status::" ");
        rRegistrationSubjects.SetRange("Original Line No.", "Line No.");
        if rRegistrationSubjects.FindSet then begin
            rStudentSubSubjectsPlan.Reset;
            repeat
                rStudentSubSubjectsPlan.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                rStudentSubSubjectsPlan.SetRange("Line No.", rRegistrationSubjects."Line No.");
                rStudentSubSubjectsPlan.SetRange(Type, rStudentSubSubjectsPlan.Type::Multi);
                rStudentSubSubjectsPlan.SetRange(Code, Code);
                rStudentSubSubjectsPlan.DeleteAll;
            until rRegistrationSubjects.Next = 0;
            rRegistrationSubjects.Delete;
        end;


        if CalcFields("Sub-Subject") then begin
            recStudyPlanSubSubjectsLines.Reset;
            recStudyPlanSubSubjectsLines.SetRange(Type, recStudyPlanSubSubjectsLines.Type::Course);
            recStudyPlanSubSubjectsLines.SetRange(Code, Code);
            recStudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
            recStudyPlanSubSubjectsLines.SetRange("Line No.", "Line No.");
            recStudyPlanSubSubjectsLines.DeleteAll(true);
        end;



        l_StruEducCountry.Reset;
        l_StruEducCountry.SetRange("Schooling Year", "Schooling Year Begin");
        l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
        if l_StruEducCountry.FindFirst then;


        l_StruEducCountry2.Reset;
        l_StruEducCountry2.SetRange(l_StruEducCountry2."Sorting ID", l_StruEducCountry."Sorting ID",
              l_StruEducCountry."Sorting ID" + "Characterise Subjects");
        if l_StruEducCountry2.FindSet then begin
            repeat
                recSettingRatings.Reset;
                recSettingRatings.SetRange("Type Education", recSettingRatings."Type Education"::Multi);
                recSettingRatings.SetRange("Study Plan Code", Code);
                recSettingRatings.SetRange("Subject Code", "Subject Code");
                recSettingRatings.SetRange("Schooling Year", l_StruEducCountry2."Schooling Year");
                recSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                recSettingRatings.SetRange("Line No.", "Line No.");
                recSettingRatings.DeleteAll;
            until l_StruEducCountry2.Next = 0;
        end;

        recAspects.Reset;
        recAspects.SetRange(Type, recAspects.Type::Course);
        recAspects.SetRange("Type No.", Code);
        recAspects.SetRange(Subjects, "Subject Code");
        recAspects.DeleteAll(true);

        //Test if the subject group is the last in the study plan before delete
        if "Option Group" <> '' then begin
            lCourseLines.Reset;
            lCourseLines.SetRange(Code, Code);
            lCourseLines.SetRange("Option Group", "Option Group");
            if lCourseLines.Count = 1 then
                cInsertNAVMasterTable.DeleteSubjectGroupCClass(Rec, xRec);
        end;

        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            cInsertNAVMasterTable.DeleteSubjectCClass(Rec, xRec);
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetCL(Rec, true);
        end;
    end;

    trigger OnInsert()
    var
        lCourseLines: Record "Course Lines";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
    begin

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if rCourseHeader.Get(Code) then begin
            if rCourseHeader."Schooling Year Begin" = '' then
                Error(Text0010);
            "Responsibility Center" := rCourseHeader."Responsibility Center";
            "Sub-subjects for assess. only" := rCourseHeader."Sub-subjects for assess. only";
        end;


        "User Id" := UserId;
        Date := WorkDate;


        //Test if the subject group allredy exists for this course
        if "Option Group" <> '' then begin
            lCourseLines.Reset;
            lCourseLines.SetRange(Code, Code);
            lCourseLines.SetRange("Option Group", "Option Group");
            if not lCourseLines.FindSet then
                cInsertNAVMasterTable.InsertSubjectGroupCClass(Rec, xRec);
        end;

        //Test if the evaluation type if None Qualification
        CalcFields("Sub-Subject");
        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then
            cInsertNAVMasterTable.InsertSubjectCClass(Rec, xRec, "Sub-Subject");
    end;

    trigger OnModify()
    var
        lRegistrationSubjects: Record "Registration Subjects";
        lStudentSubjectsEntry: Record "Student Subjects Entry";
        l_AssessingStudentsFinal: Record "Assessing Students Final";
        lCourseLines: Record "Course Lines";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
    begin
        // Verify if group subjects has grades.
        if "Option Group" <> xRec."Option Group" then begin
            l_AssessingStudentsFinal.Reset;
            l_AssessingStudentsFinal.SetFilter("Evaluation Type", '%1|%2'
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Year Group"
                                               , l_AssessingStudentsFinal."Evaluation Type"::"Final Moment Group");
            l_AssessingStudentsFinal.SetRange("Study Plan Code", Code);
            l_AssessingStudentsFinal.SetRange("Option Group", xRec."Option Group");
            if l_AssessingStudentsFinal.FindFirst then
                Error(Text0020, FieldCaption("Option Group"));
        end;

        //Change all subjects Groups for the active year in the Registration Subjects to the reports
        recSchoolYear.Reset;
        recSchoolYear.SetRange(Status, recSchoolYear.Status::Active);
        if recSchoolYear.FindSet and (("Option Group" <> xRec."Option Group") or
          ("Subject Excluded From Assess." <> xRec."Subject Excluded From Assess."))
          or ("Subject Excluded From Assess." <> xRec."Subject Excluded From Assess.") or
           ("Sorting ID" <> xRec."Sorting ID") or ("Evaluation Type" <> xRec."Evaluation Type") or
           ("Assessment Code" <> xRec."Assessment Code") or
           ("Minimum Classification Level" <> xRec."Minimum Classification Level") or ("Report Descripton" <> xRec."Report Descripton") or
           ("Legal Code" <> xRec."Legal Code") or ("Legal Reports Sorting ID" <> xRec."Legal Reports Sorting ID") or
           ("Continuous Assessment" <> xRec."Continuous Assessment") or ("Mandatory/Optional Type" <> xRec."Mandatory/Optional Type")
           then begin

            lRegistrationSubjects.Reset;
            lRegistrationSubjects.SetRange("School Year", recSchoolYear."School Year");
            lRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
            lRegistrationSubjects.SetRange(Type, lRegistrationSubjects.Type::Multi);
            lRegistrationSubjects.SetRange("Original Line No.", "Line No.");
            lRegistrationSubjects.SetRange("Study Plan Code", Code);


            if "Subject Excluded From Assess." <> xRec."Subject Excluded From Assess." then
                lRegistrationSubjects.ModifyAll("Subject Excluded From Assess.", "Subject Excluded From Assess.", true);

            if "Mandatory/Optional Type" <> xRec."Mandatory/Optional Type" then
                lRegistrationSubjects.ModifyAll("Mandatory/Optional Type", "Mandatory/Optional Type", true);

            if "Continuous Assessment" <> xRec."Continuous Assessment" then
                lRegistrationSubjects.ModifyAll("Continuous Assessment", "Continuous Assessment", true);

            if "Sorting ID" <> xRec."Sorting ID" then
                lRegistrationSubjects.ModifyAll("Sorting ID", "Sorting ID", true);

            if "Legal Reports Sorting ID" <> xRec."Legal Reports Sorting ID" then
                lRegistrationSubjects.ModifyAll("Legal Reports Sorting ID", "Legal Reports Sorting ID", true);

            if "Evaluation Type" <> xRec."Evaluation Type" then
                lRegistrationSubjects.ModifyAll("Evaluation Type", "Evaluation Type", true);

            if "Assessment Code" <> xRec."Assessment Code" then
                lRegistrationSubjects.ModifyAll("Assessment Code", "Assessment Code", true);

            if "Minimum Classification Level" <> xRec."Minimum Classification Level" then
                lRegistrationSubjects.ModifyAll("Minimum Classification Level", "Minimum Classification Level", true);

            if "Maximum Justified Absence" <> xRec."Maximum Justified Absence" then
                lRegistrationSubjects.ModifyAll("Maximum Justified Absence", "Maximum Justified Absence", true);

            if "Maximum Unjustified Absences" <> xRec."Maximum Unjustified Absences" then
                lRegistrationSubjects.ModifyAll("Maximum Injustified Absence", "Maximum Unjustified Absences", true);

            if "Report Descripton" <> xRec."Report Descripton" then
                lRegistrationSubjects.ModifyAll("Report Description", "Report Descripton", true);

            if "Legal Code" <> xRec."Legal Code" then
                lRegistrationSubjects.ModifyAll("Legal Code", "Legal Code", true);

            if "Option Group" <> xRec."Option Group" then
                lRegistrationSubjects.ModifyAll("Option Group", "Option Group", true);

            if "Continuous Assessment" <> xRec."Continuous Assessment" then
                lRegistrationSubjects.ModifyAll("Continuous Assessment", "Continuous Assessment", true);

            //Change the lStudentSubjectsEntry for the active School Year
            lStudentSubjectsEntry.Reset;
            lStudentSubjectsEntry.SetRange("School Year", recSchoolYear."School Year");
            lStudentSubjectsEntry.SetRange("Subjects Code", "Subject Code");
            lStudentSubjectsEntry.SetRange(Type, lRegistrationSubjects.Type::Multi);
            lStudentSubjectsEntry.SetRange("Study Plan Code", Code);
            if "Option Group" <> xRec."Option Group" then
                lStudentSubjectsEntry.ModifyAll("Option Group", "Option Group", true);

            if "Evaluation Type" <> xRec."Evaluation Type" then
                lStudentSubjectsEntry.ModifyAll("Evaluation Type", "Evaluation Type", true);

            if "Assessment Code" <> xRec."Assessment Code" then
                lStudentSubjectsEntry.ModifyAll("Assessment Code", "Assessment Code", true);

            if "Minimum Classification Level" <> xRec."Minimum Classification Level" then
                lStudentSubjectsEntry.ModifyAll("Minimum Classification Level", "Minimum Classification Level", true);

            if "Maximum Justified Absence" <> xRec."Maximum Justified Absence" then
                lStudentSubjectsEntry.ModifyAll("Maximum Justified Absence", "Maximum Justified Absence", true);

            if "Maximum Unjustified Absences" <> xRec."Maximum Unjustified Absences" then
                lStudentSubjectsEntry.ModifyAll("Maximum Injustified Absence", "Maximum Unjustified Absences", true);

        end;

        //Change Setting Ratings
        if ("Assessment Code" <> xRec."Assessment Code") or ("Evaluation Type" <> xRec."Evaluation Type") then begin
            recSettingRatings.Reset;
            recSettingRatings.SetRange("Type Education", recSettingRatings."Type Education"::Multi);
            recSettingRatings.SetRange("Study Plan Code", Code);
            recSettingRatings.SetRange("Subject Code", "Subject Code");
            recSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
            recSettingRatings.SetRange("Line No.", "Line No.");
            recSettingRatings.ModifyAll("Assessment Code", "Assessment Code");
        end;

        //Change the sub subjects lines
        if "Sub-Subject" then begin
            recStudyPlanSubSubjectsLines.Reset;
            recStudyPlanSubSubjectsLines.SetRange(Type, recStudyPlanSubSubjectsLines.Type::Course);
            recStudyPlanSubSubjectsLines.SetRange(Code, Code);
            recStudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
            recStudyPlanSubSubjectsLines.SetRange("Line No.", "Line No.");
            recStudyPlanSubSubjectsLines.ModifyAll("Assessment Code", "Assessment Code");
            recStudyPlanSubSubjectsLines.ModifyAll("Option Group", "Option Group");
            recStudyPlanSubSubjectsLines.ModifyAll("Subject Description", "Subject Description", true);
        end;

        //Test if the subject group allredy exists for this course
        if "Option Group" <> '' then begin
            lCourseLines.Reset;
            lCourseLines.SetRange(Code, Code);
            lCourseLines.SetRange("Option Group", "Option Group");
            if not lCourseLines.FindSet then
                cInsertNAVMasterTable.InsertSubjectGroupCClass(Rec, xRec);
        end;

        if ("Option Group" <> '') and (xRec."Option Group" <> "Option Group") then begin
            lCourseLines.Reset;
            lCourseLines.SetRange(Code, Code);
            lCourseLines.SetRange("Option Group", xRec."Option Group");
            if lCourseLines.Count - 1 = 0 then
                cInsertNAVMasterTable.DeleteSubjectGroupCClass(Rec, xRec);
        end;

        if ("Option Group" = '') and (xRec."Option Group" <> '') then begin
            lCourseLines.Reset;
            lCourseLines.SetRange(Code, Code);
            lCourseLines.SetRange("Option Group", xRec."Option Group");
            if lCourseLines.Count = 1 then
                cInsertNAVMasterTable.DeleteSubjectGroupCClass(Rec, xRec);
        end;

        //Test if the evaluation type if None Qualification and delete or update web lines
        if ("Evaluation Type" = "Evaluation Type"::"None Qualification") and
          ((xRec."Evaluation Type" <> xRec."Evaluation Type"::"None Qualification") or
          (xRec."Evaluation Type" <> xRec."Evaluation Type"::" ")) then begin
            cInsertNAVMasterTable.DeleteSubjectCClass(Rec, xRec);
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetCL(Rec, true);
        end;
        CalcFields("Sub-Subject");
        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            cInsertNAVMasterTable.InsertSubjectCClass(Rec, xRec, "Sub-Subject");
            cInsertNAVGeneralTable.ModDelGTSubjectAssessemetCL(Rec, false);
        end;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0020, TableCaption);*/
    end;

    var
        rSubjects: Record Subjects;
        rCourseHeader: Record "Course Header";
        cStudentsRegistration: Codeunit "Students Registration";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0001: Label 'You must specify a valid code.';
        Text0002: Label 'The value must be between %1 and %2.';
        Text0003: Label 'There aren''t any moments for School year %1 and Schooling Year %2.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rRegistrationSubjects: Record "Registration Subjects";
        Text0005: Label 'You cannot eliminate lines.';
        varSchoolYear: Code[9];
        Text0006: Label 'Assessment Code is Mandatory for Subjects %1 - %2.';
        recAspects: Record Aspects;
        recStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        recSchoolYear: Record "School Year";
        recSettingRatings: Record "Setting Ratings";
        Text0007: Label 'The Assessement Code cannot be changed.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        rOptionGroup: Record "Group Subjects";
        Text0008: Label 'There is no Code in the Selection.';
        Text0009: Label 'There is no overall configuration of aspects.';
        Text0010: Label 'You must specify the Schooling Year begin regarding the Course.';
        Text0011: Label 'To set the Setting Ratings you need to set the Setting Moments for the School Year(s).';
        ENESENEBCodes: Record "Legal Codes";
        Text0012: Label 'To use this option please configure the Course Setting Ratings for the subject %1.';
        Text0013: Label 'The field %1 must be higher than the field %2.';
        Text0014: Label 'Wrong Schooling Year.';
        rObservation: Record Observation;
        Text0015: Label 'The absence type for the schooling year configured in the header is different of the absence type configured for the schooling year in the line';
        Text0016: Label 'Not allowed to modify the subject. There are students with the subject.';
        Text0017: Label 'Wrong Classification level inserted.';
        rRankGroup: Record "Rank Group";
        Text0018: Label 'This Schooling Year does not belong to the same Educational Level as the Course''s beginning School Year.';
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        Text0019: Label 'The subject %1 has sub-subjects. You must first delete the sub-subjects.';
        Text0020: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";

    //[Scope('OnPrem')]
    procedure OpenCreateAssessmentConf()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        l_SchoolYear: Record "School Year";
        l_StruEducCountry: Record "Structure Education Country";
        l_CourseHeader: Record "Course Header";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        tSchoolingYear: Text[1024];
        int: Integer;
        l_StruEducCountry2: Record "Structure Education Country";
        Flag: Boolean;
        varCharacteriseSubjects: Integer;
        varCount: Integer;
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Overall);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.FindFirst then
            Error(Text0009);

        if "Assessment Code" = '' then
            Error(Text0006, "Subject Code", "Subject Description");


        if rCourseHeader.Get(Code) then begin
            Clear(varSchoolYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
            if l_SchoolYear.FindSet then
                repeat
                    tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
                until l_SchoolYear.Next = 0;

            Clear(int);

            if tLectiveYear <> '' then begin
                int := StrMenu(tLectiveYear);
                l_SchoolYear.Reset;
                l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
                if l_SchoolYear.Find('-') and (int <> 0) then
                    l_SchoolYear.Next := int - 1
                else
                    exit;
            end;

            varSchoolYear := l_SchoolYear."School Year";
        end;


        Clear(int);

        l_CourseHeader.Reset;
        l_CourseHeader.SetRange(Code, Code);
        l_CourseHeader.SetRange("Responsibility Center", "Responsibility Center");
        if l_CourseHeader.FindFirst then;

        l_StruEducCountry2.Reset;
        l_StruEducCountry2.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry2.SetRange(Type, l_StruEducCountry2.Type::Multi);
        l_StruEducCountry2.SetRange("Schooling Year", "Schooling Year Begin");
        if l_StruEducCountry2.FindFirst then;

        Flag := false;

        if "Characterise Subjects" = "Characterise Subjects"::Annual then
            varCharacteriseSubjects := 1;
        if "Characterise Subjects" = "Characterise Subjects"::Biennial then
            varCharacteriseSubjects := 2;
        if "Characterise Subjects" = "Characterise Subjects"::Triennial then
            varCharacteriseSubjects := 3;
        if "Characterise Subjects" = "Characterise Subjects"::Quadriennal then
            varCharacteriseSubjects := 4;



        l_StruEducCountry.Reset;
        l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
        l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
        if l_StruEducCountry.FindSet then
            varCount := 1;
        repeat

            if l_StruEducCountry."Schooling Year" = "Schooling Year Begin" then
                Flag := true;

            if (Flag) and (varCount <= varCharacteriseSubjects) then begin
                tSchoolingYear := tSchoolingYear + l_StruEducCountry."Schooling Year" + ',';
                varCount += 1;
            end;
        until l_StruEducCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StruEducCountry.Reset;
            l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
            l_StruEducCountry.SetRange("Sorting ID", l_StruEducCountry2."Sorting ID" + (int - 1));
            l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
            l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
            if l_StruEducCountry.Find('-') and (int <> 0) then
                l_StruEducCountry.Next := int - 1
            else
                exit;
        end;
        Clear(int);

        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", l_SchoolYear."School Year");
        l_rMoments.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.FindSet then begin
            repeat
                tAssessment := tAssessment + l_rMoments."Moment Code" + ','
            until l_rMoments.Next = 0;
        end else
            Error(Text0003, l_SchoolYear."School Year", l_rMoments."Schooling Year");

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMoments.SetRange("School Year", l_SchoolYear."School Year");
            l_rMoments.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
            l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 1
            else
                exit;

            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
            l_rSettingRatings.SetRange("School Year", l_SchoolYear."School Year");
            l_rSettingRatings.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code", Code);
            l_rSettingRatings.SetRange("Subject Code", "Subject Code");
            l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
            l_rSettingRatings.SetRange("Line No.", "Line No.");
            if not l_rSettingRatings.FindSet then begin
                l_rSettingRatings.Init;
                l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                l_rSettingRatings."School Year" := l_SchoolYear."School Year";
                l_rSettingRatings."Schooling Year" := l_StruEducCountry."Schooling Year";
                l_rSettingRatings."Study Plan Code" := Code;
                l_rSettingRatings."Subject Code" := "Subject Code";
                l_rSettingRatings."Moment Ponder" := Weighting;
                l_rSettingRatings."Assessment Code" := "Assessment Code";
                l_rSettingRatings."Responsibility Center" := "Responsibility Center";
                l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                l_rSettingRatings."Type Education" := l_rSettingRatings."Type Education"::Multi;
                l_rSettingRatings."Line No." := "Line No.";
                l_rSettingRatings.Insert(true);

                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", l_SchoolYear."School Year");
                l_rSettingRatings.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Code);
                l_rSettingRatings.SetRange("Subject Code", "Subject Code");
                l_rSettingRatings.SetRange("Line No.", "Line No.");
                if l_rSettingRatings.Find('-') then;
            end;

            l_rSettingRatings."Assessment Code" := "Assessment Code";
            l_rSettingRatings.Modify(true);

            //
            SubjectsAspects(l_rMoments."Moment Code", l_StruEducCountry."Schooling Year");
            //

            PAGE.Run(PAGE::"Setting Ratings", l_rSettingRatings);
            //end;
        end else
            Error(Text0011);
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects(pMomentCode: Code[10]; pSchoolingYear: Code[10])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Course);
        rAspects.SetRange("School Year", varSchoolYear);
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Sub Subjects", '');
        rAspects.SetRange("Moment Code", pMomentCode);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        rAspects.SetRange("Schooling Year", pSchoolingYear);
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Course, varSchoolYear, Code, pMomentCode,
                               pSchoolingYear, "Subject Code", '', "Evaluation Type", "Assessment Code", "Responsibility Center");
            Commit;
        end;

        //fAspects.SETTABLEVIEW(rAspects);
        //FORM.RUNMODAL(FORM::Aspects,rAspects);
    end;

    //[Scope('OnPrem')]
    procedure ValidateWeighting()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        l_SchoolYear: Record "School Year";
        l_CourseHeader: Record "Course Header";
        l_StruEducCountry: Record "Structure Education Country";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        tSchoolingYear: Text[1024];
        int: Integer;
        l_StruEducCountry2: Record "Structure Education Country";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
        if l_SchoolYear.Find('-') then
            repeat
                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
            until l_SchoolYear.Next = 0;

        Clear(int);

        if tLectiveYear <> '' then begin
            int := StrMenu(tLectiveYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
            if l_SchoolYear.Find('-') and (int <> 0) then
                l_SchoolYear.Next := int - 1
            else
                exit;
        end;

        Clear(int);

        l_CourseHeader.Reset;
        l_CourseHeader.SetRange(Code, Code);
        l_CourseHeader.SetRange("Responsibility Center", "Responsibility Center");
        if l_CourseHeader.Find('-') then;

        l_StruEducCountry2.Reset;
        l_StruEducCountry2.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry2.SetRange(Type, l_StruEducCountry2.Type::Multi);
        l_StruEducCountry2.SetRange("Schooling Year", l_CourseHeader."Schooling Year Begin");
        if l_StruEducCountry2.Find('-') then;


        l_StruEducCountry.Reset;
        l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
        l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
        if l_StruEducCountry.Find('-') then
            repeat
                tSchoolingYear := tSchoolingYear + l_StruEducCountry."Schooling Year" + ',';
            until l_StruEducCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StruEducCountry.Reset;
            l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
            l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
            if l_StruEducCountry.Find('-') and (int <> 0) then
                l_StruEducCountry.Next := int - 1
            else
                exit;
        end;

        l_rSettingRatings.Reset;
        l_rSettingRatings.SetRange("School Year", l_SchoolYear."School Year");
        l_rSettingRatings.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
        l_rSettingRatings.SetRange("Study Plan Code", Code);
        l_rSettingRatings.SetRange("Subject Code", "Subject Code");
        l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        l_rSettingRatings.SetRange("Line No.", "Line No.");
        if l_rSettingRatings.Find('-') then begin
            repeat
                if (l_rSettingRatings."Moment Ponder" = xRec.Weighting) or (l_rSettingRatings."Moment Ponder" = 0) then begin
                    l_rSettingRatings."Moment Ponder" := Weighting;
                    l_rSettingRatings.Modify;
                end;
            until l_rSettingRatings.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects2(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        lSettingRatings: Record "Setting Ratings";
        rAspects: Record Aspects;
        l_rMoments: Record "Moments Assessment";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        int: Integer;
        tAssessment: Text[1024];
    begin
        l_rMomentsTEMP.DeleteAll;

        lSettingRatings.Reset;
        lSettingRatings.SetRange("School Year", pSchoolYear);
        lSettingRatings.SetRange("Schooling Year", pSchoolingYear);
        lSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        lSettingRatings.SetRange("Type Education", lSettingRatings."Type Education"::Multi);
        lSettingRatings.SetRange("Study Plan Code", Code);
        lSettingRatings.SetRange(Type, lSettingRatings.Type::Header);
        lSettingRatings.SetRange("Subject Code", "Subject Code");
        lSettingRatings.SetRange("Line No.", "Line No.");
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
            Error(Text0012, "Subject Code");


        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMomentsTEMP.SetRange("School Year", pSchoolYear);
        l_rMomentsTEMP.SetRange("Schooling Year", pSchoolingYear);
        l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMomentsTEMP.FindSet then
            repeat
                tAssessment := tAssessment + l_rMomentsTEMP."Moment Code" + ','
            until l_rMomentsTEMP.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMomentsTEMP.Reset;
            l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMomentsTEMP.SetRange("School Year", pSchoolYear);
            l_rMomentsTEMP.SetRange("Schooling Year", pSchoolingYear);
            l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMomentsTEMP.Find('-') and (int <> 0) then
                l_rMomentsTEMP.Next := int - 1
            else
                exit;
        end;

        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Class);
        rAspects.SetRange("School Year", pSchoolYear);
        rAspects.SetRange("Type No.", pClass);
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
        rAspects.SetRange("Sub Subjects", '');
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Class, pSchoolYear, pClass, l_rMomentsTEMP."Moment Code",
                               pSchoolingYear, "Subject Code", '', "Evaluation Type", "Assessment Code", "Responsibility Center");

            Commit;
        end;

        PAGE.RunModal(PAGE::Aspects, rAspects);
    end;

    //[Scope('OnPrem')]
    procedure CreateAssessmentConfAll()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_rMoments: Record "Moments Assessment";
        l_SchoolYear: Record "School Year";
        l_StruEducCountry: Record "Structure Education Country";
        l_CourseHeader: Record "Course Header";
        l_CourseLines: Record "Course Lines";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        tSchoolingYear: Text[1024];
        int: Integer;
        l_StruEducCountry2: Record "Structure Education Country";
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

        //Colocar dentro do ciclo.
        if "Assessment Code" = '' then
            Error(Text0006, "Subject Code", "Subject Description");

        if rCourseHeader.Get(Code) then begin
            Clear(varSchoolYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
            if l_SchoolYear.Find('-') then
                repeat
                    tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
                until l_SchoolYear.Next = 0;

            Clear(int);

            if tLectiveYear <> '' then begin
                int := StrMenu(tLectiveYear);
                l_SchoolYear.Reset;
                l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
                if l_SchoolYear.Find('-') and (int <> 0) then
                    l_SchoolYear.Next := int - 1
                else
                    exit;
            end;

            varSchoolYear := l_SchoolYear."School Year";

        end;

        Clear(int);

        l_CourseHeader.Reset;
        l_CourseHeader.SetRange(Code, Code);
        l_CourseHeader.SetRange("Responsibility Center", "Responsibility Center");
        if l_CourseHeader.FindFirst then;

        l_StruEducCountry2.Reset;
        l_StruEducCountry2.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry2.SetRange(Type, l_StruEducCountry2.Type::Multi);
        l_StruEducCountry2.SetRange("Schooling Year", "Schooling Year Begin");
        if l_StruEducCountry2.FindFirst then;

        Flag := false;

        if "Characterise Subjects" = "Characterise Subjects"::Annual then
            varCharacteriseSubjects := 1;
        if "Characterise Subjects" = "Characterise Subjects"::Biennial then
            varCharacteriseSubjects := 2;
        if "Characterise Subjects" = "Characterise Subjects"::Triennial then
            varCharacteriseSubjects := 3;
        if "Characterise Subjects" = "Characterise Subjects"::Quadriennal then
            varCharacteriseSubjects := 4;

        l_StruEducCountry.Reset;
        l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
        //l_StruEducCountry.SETRANGE("Schooling Year","Schooling Year Begin");
        l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
        if l_StruEducCountry.Find('-') then
            varCount := 1;
        repeat

            if l_StruEducCountry."Schooling Year" = "Schooling Year Begin" then
                Flag := true;

            if (Flag) and (varCount <= varCharacteriseSubjects) then begin
                tSchoolingYear := tSchoolingYear + l_StruEducCountry."Schooling Year" + ',';
                varCount += 1;
            end;
        until l_StruEducCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StruEducCountry.Reset;
            l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
            l_StruEducCountry.SetRange("Sorting ID", l_StruEducCountry2."Sorting ID" + (int - 1));
            l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
            l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
            if l_StruEducCountry.Find('-') and (int <> 0) then
                l_StruEducCountry.Next := int - 1
            else
                exit;
        end;
        Clear(int);

        l_rMoments.Reset;
        l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMoments.SetRange("School Year", l_SchoolYear."School Year");
        l_rMoments.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.Find('-') then begin
            repeat
                //
                SubjectsAspectsAll(l_rMoments."Moment Code", l_StruEducCountry."Schooling Year", "Subject Code", '');
                //

                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", l_SchoolYear."School Year");
                l_rSettingRatings.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", Code);
                l_rSettingRatings.SetRange("Subject Code", "Subject Code");
                l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                l_rSettingRatings.SetRange("Line No.", "Line No.");
                if not l_rSettingRatings.Find('-') then begin
                    l_rSettingRatings.Init;
                    l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                    l_rSettingRatings."School Year" := l_SchoolYear."School Year";
                    l_rSettingRatings."Schooling Year" := l_StruEducCountry."Schooling Year";
                    l_rSettingRatings."Study Plan Code" := Code;
                    l_rSettingRatings."Subject Code" := "Subject Code";
                    l_rSettingRatings."Moment Ponder" := Weighting;
                    l_rSettingRatings."Assessment Code" := "Assessment Code";
                    l_rSettingRatings."Responsibility Center" := "Responsibility Center";
                    l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                    l_rSettingRatings."Type Education" := l_rSettingRatings."Type Education"::Multi;
                    l_rSettingRatings."Line No." := "Line No.";
                    l_rSettingRatings.Insert(true);
                end;
                l_rSettingRatings."Assessment Code" := "Assessment Code";
                l_rSettingRatings.Modify(true);

                //InsertSubSubjects
                l_StudyPlanSubSubjectsLines.Reset;
                l_StudyPlanSubSubjectsLines.SetRange(Type, l_StudyPlanSubSubjectsLines.Type::Course);
                l_StudyPlanSubSubjectsLines.SetRange(Code, Code);
                l_StudyPlanSubSubjectsLines.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
                l_StudyPlanSubSubjectsLines.SetRange("Subject Code", "Subject Code");
                l_StudyPlanSubSubjectsLines.SetRange("Line No.", "Line No.");
                if l_StudyPlanSubSubjectsLines.FindSet then
                    repeat
                        SubjectsAspectsAll(l_rMoments."Moment Code", l_StruEducCountry."Schooling Year",
                          "Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");

                        l_SRSubSubjects.Reset;
                        l_SRSubSubjects.SetRange("Moment Code", l_rMoments."Moment Code");
                        l_SRSubSubjects.SetRange("School Year", l_SchoolYear."School Year");
                        l_SRSubSubjects.SetRange("Schooling Year", l_StruEducCountry."Schooling Year");
                        l_SRSubSubjects.SetRange("Study Plan Code", Code);
                        l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
                        l_SRSubSubjects.SetRange("Sub-Subject Code", l_StudyPlanSubSubjectsLines."Sub-Subject Code");
                        l_SRSubSubjects.SetRange("Line No.", "Line No.");
                        if not l_SRSubSubjects.Find('-') then begin

                            l_SRSubSubjects.Init;
                            l_SRSubSubjects."Moment Code" := l_rMoments."Moment Code";
                            l_SRSubSubjects."School Year" := l_SchoolYear."School Year";
                            l_SRSubSubjects."Schooling Year" := l_StruEducCountry."Schooling Year";
                            l_SRSubSubjects."Study Plan Code" := Code;
                            l_SRSubSubjects."Subject Code" := "Subject Code";
                            l_SRSubSubjects."Assessment Code" := "Assessment Code";
                            l_SRSubSubjects.Type := l_SRSubSubjects.Type::Header;
                            l_SRSubSubjects."Responsibility Center" := "Responsibility Center";
                            l_SRSubSubjects."Sub-Subject Code" := l_StudyPlanSubSubjectsLines."Sub-Subject Code";
                            l_SRSubSubjects."Sub-Subject Description" := l_StudyPlanSubSubjectsLines."Sub-Subject Description";
                            l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Multi;
                            l_SRSubSubjects."Moment Ponder" := l_StudyPlanSubSubjectsLines."Moment Ponder";
                            l_SRSubSubjects."Line No." := "Line No.";
                            l_SRSubSubjects.Insert(true);
                        end else begin
                            l_SRSubSubjects."Assessment Code" := l_StudyPlanSubSubjectsLines."Assessment Code";
                            l_SRSubSubjects.Modify(true);
                        end;
                    until l_StudyPlanSubSubjectsLines.Next = 0;
            until l_rMoments.Next = 0;
        end else
            Error(Text0011);
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspectsAll(pMomentCode: Code[10]; pSchoolingYear: Code[10]; pSubject: Code[20]; pSubSubject: Code[20])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Course);
        rAspects.SetRange("School Year", varSchoolYear);
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, pSubject);
        rAspects.SetRange("Sub Subjects", pSubSubject);
        rAspects.SetRange("Moment Code", pMomentCode);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        rAspects.SetRange("Schooling Year", pSchoolingYear);
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Course, varSchoolYear, Code, pMomentCode,
                               pSchoolingYear, pSubject, pSubSubject, "Evaluation Type", "Assessment Code", "Responsibility Center");
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubject()
    var
        l_SchoolYear: Record "School Year";
        l_StruEducCountry: Record "Structure Education Country";
        tAssessment: Text[1024];
        tLectiveYear: Text[1024];
        int: Integer;
        l_CourseHeader: Record "Course Header";
        l_StruEducCountry2: Record "Structure Education Country";
        Flag: Boolean;
        varCharacteriseSubjects: Integer;
        varCount: Integer;
        tSchoolingYear: Text[1024];
        cStudentsRegistration: Codeunit "Students Registration";
        rCourseHeader: Record "Course Header";
    begin
        if rCourseHeader.Get(Code) then;
        Clear(varSchoolYear);
        l_SchoolYear.Reset;
        l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
        if l_SchoolYear.Find('-') then
            repeat
                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
            until l_SchoolYear.Next = 0;

        Clear(int);

        if tLectiveYear <> '' then begin
            int := StrMenu(tLectiveYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
            if l_SchoolYear.Find('-') and (int <> 0) then
                l_SchoolYear.Next := int - 1
            else
                exit;
        end;

        varSchoolYear := l_SchoolYear."School Year";


        l_CourseHeader.Reset;
        l_CourseHeader.SetRange(Code, Code);
        l_CourseHeader.SetRange("Responsibility Center", "Responsibility Center");
        if l_CourseHeader.FindFirst then;

        l_StruEducCountry2.Reset;
        l_StruEducCountry2.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry2.SetRange(Type, l_StruEducCountry2.Type::Multi);
        l_StruEducCountry2.SetRange("Schooling Year", "Schooling Year Begin");
        if l_StruEducCountry2.FindFirst then;

        Flag := false;

        if "Characterise Subjects" = "Characterise Subjects"::Annual then
            varCharacteriseSubjects := 1;
        if "Characterise Subjects" = "Characterise Subjects"::Biennial then
            varCharacteriseSubjects := 2;
        if "Characterise Subjects" = "Characterise Subjects"::Triennial then
            varCharacteriseSubjects := 3;
        if "Characterise Subjects" = "Characterise Subjects"::Quadriennal then
            varCharacteriseSubjects := 4;

        l_StruEducCountry.Reset;
        l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
        l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
        //l_StruEducCountry.SETRANGE("Schooling Year","Schooling Year Begin");
        l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
        if l_StruEducCountry.Find('-') then
            varCount := 1;
        repeat

            if l_StruEducCountry."Schooling Year" = "Schooling Year Begin" then
                Flag := true;

            if (Flag) and (varCount <= varCharacteriseSubjects) then begin
                tSchoolingYear := tSchoolingYear + l_StruEducCountry."Schooling Year" + ',';
                varCount += 1;
            end;
        until l_StruEducCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StruEducCountry.Reset;
            l_StruEducCountry.SetRange(Country, l_CourseHeader."Country/Region Code");
            l_StruEducCountry.SetRange("Sorting ID", l_StruEducCountry2."Sorting ID" + (int - 1));
            l_StruEducCountry.SetRange("Edu. Level", l_StruEducCountry2."Edu. Level");
            l_StruEducCountry.SetRange(Type, l_StruEducCountry.Type::Multi);
            if l_StruEducCountry.Find('-') and (int <> 0) then
                l_StruEducCountry.Next := int - 1
            else
                exit;
        end;
        Clear(int);

        if (varSchoolYear <> '') and (l_StruEducCountry."Schooling Year" <> '') then
            cStudentsRegistration.UpdateSubjectsCourse(Rec, varSchoolYear, l_StruEducCountry."Schooling Year");
    end;

    //[Scope('OnPrem')]
    procedure ValidateSubject()
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Study Plan Code", Code);
        rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Multi);
        rRegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        rRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
        rRegistrationSubjects.SetRange("Original Line No.", "Line No.");
        if rRegistrationSubjects.FindFirst then
            Error(Text0016);
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubjects(pSchoolYear: Code[9]; pCode: Code[20]; pSubjectsCode: Code[10]; pAssessmentCode: Code[20]; pEvaluationType: Integer)
    var
        StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        SettingRatings: Record "Setting Ratings";
        SettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin

        StudyPlanSubSubjectsLines.Reset;
        //StudyPlanSubSubjectsLines.SETRANGE(Type,StudyPlanSubSubjectsLines.Type::"Study Plan");
        StudyPlanSubSubjectsLines.SetRange(Code, pCode);
        //StudyPlanSubSubjectsLines.SETRANGE("Schooling Year",pSchoolingYear);
        StudyPlanSubSubjectsLines.SetRange("Subject Code", pSubjectsCode);
        StudyPlanSubSubjectsLines.ModifyAll("Assessment Code", pAssessmentCode);
        StudyPlanSubSubjectsLines.ModifyAll(StudyPlanSubSubjectsLines."Evaluation Type", pEvaluationType);

        SettingRatingsSubSubjects.Reset;
        SettingRatingsSubSubjects.SetRange("Study Plan Code", pCode);
        SettingRatingsSubSubjects.SetRange("School Year", pSchoolYear);
        //SettingRatingsSubSubjects.SETRANGE("Schooling Year",pSchoolingYear);
        SettingRatingsSubSubjects.SetRange("Subject Code", pSubjectsCode);
        SettingRatingsSubSubjects.ModifyAll("Assessment Code", pAssessmentCode);

        SettingRatings.Reset;
        SettingRatings.SetRange("School Year", pSchoolYear);
        //SettingRatings.SETRANGE("Schooling Year",pSchoolingYear);
        SettingRatings.SetRange("Study Plan Code", pCode);
        SettingRatings.SetRange("Subject Code", pSubjectsCode);
        SettingRatings.ModifyAll("Assessment Code", pAssessmentCode);
    end;

    //[Scope('OnPrem')]
    procedure VerificarFaltas(Courses: Code[20]; SubjectCode: Code[20])
    var
        Absence: Record Absence;
        TEXT001: Label 'Incidences are already given to Students belonging to this Course, changing this value may affect student eligibility for recovery tests.';
    begin
        //PT
        Absence.Reset;
        Absence.SetRange(Subject, SubjectCode);
        Absence.SetRange("Study Plan", Code);
        if Absence.Find('-') then
            Message(TEXT001);
    end;
}

