table 52815 "Study Plan Sub-Subjects Lines"
{
    Caption = 'Study Plan Sub-Subjects Lines';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Study Plan,Course';
            OptionMembers = "Study Plan",Course;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST("Study Plan")) "Study Plan Header".Code
            ELSE
            IF (Type = CONST(Course)) "Course Header".Code;

            trigger OnValidate()
            var
                rStudyPlanHeader: Record "Study Plan Header";
            begin
                if Type = Type::"Study Plan" then begin
                    if rStudyPlanHeader.Get(Code) then
                        "School Year" := rStudyPlanHeader."School Year";
                end;
            end;
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = IF (Type = FILTER("Study Plan")) "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Simple))
            ELSE
            IF (Type = FILTER(Course)) "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Multi));

            trigger OnValidate()
            var
                l_StrEduCountry: Record "Structure Education Country";
                l_StrEduCountry2: Record "Structure Education Country";
                flag: Boolean;
            begin
                if Type = Type::Course then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Code);
                    rCourseLines.SetRange("Subject Code", "Subject Code");
                    rCourseLines.SetRange("Line No.", "Line No.");
                    if rCourseLines.FindFirst then;

                    l_StrEduCountry.Reset;
                    l_StrEduCountry.SetRange("Schooling Year", rCourseLines."Schooling Year Begin");
                    if l_StrEduCountry.FindFirst then;

                    if rCourseLines."Characterise Subjects" = rCourseLines."Characterise Subjects"::Annual then begin
                        if rCourseLines."Schooling Year Begin" <> "Schooling Year" then
                            Error(Text0014);
                    end;

                    if rCourseLines."Characterise Subjects" = rCourseLines."Characterise Subjects"::Biennial then begin
                        flag := true;
                        l_StrEduCountry2.Reset;
                        l_StrEduCountry2.SetRange("Schooling Year", "Schooling Year");
                        if l_StrEduCountry2.FindFirst then begin
                            if (l_StrEduCountry."Sorting ID" = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 1 = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                        end;
                        if flag then
                            Error(Text0014);

                    end;

                    if rCourseLines."Characterise Subjects" = rCourseLines."Characterise Subjects"::Triennial then begin
                        flag := true;
                        l_StrEduCountry2.Reset;
                        l_StrEduCountry2.SetRange("Schooling Year", "Schooling Year");
                        if l_StrEduCountry2.FindFirst then begin
                            if (l_StrEduCountry."Sorting ID" = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 1 = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 2 = l_StrEduCountry2."Sorting ID") then
                                flag := false;

                        end;
                        if flag then
                            Error(Text0014);
                    end;
                    if rCourseLines."Characterise Subjects" = rCourseLines."Characterise Subjects"::Quadriennal then begin
                        flag := true;
                        l_StrEduCountry2.Reset;
                        l_StrEduCountry2.SetRange("Schooling Year", "Schooling Year");
                        if l_StrEduCountry2.FindFirst then begin
                            if (l_StrEduCountry."Sorting ID" = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 1 = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 2 = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                            if (l_StrEduCountry."Sorting ID" + 3 = l_StrEduCountry2."Sorting ID") then
                                flag := false;
                        end;
                        if flag then
                            Error(Text0014);
                    end;
                end;
            end;
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code WHERE(Type = FILTER(Subject));

            trigger OnValidate()
            begin
                if rSubjects.Get(1, "Subject Code") then
                    "Subject Description" := rSubjects.Description;
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
                if Type = Type::"Study Plan" then begin
                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetRange(Code, Code);
                    rStudyPlanLines.SetRange("School Year", "School Year");
                    rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
                    rStudyPlanLines.SetRange("Subject Code", "Subject Code");
                    if rStudyPlanLines.FindFirst then;

                    if rStudyPlanLines."Evaluation Type" = rStudyPlanLines."Evaluation Type"::Quantitative then
                        if "Evaluation Type" = "Evaluation Type"::Qualitative then
                            Error(Text0006);

                    if "Evaluation Type" <> xRec."Evaluation Type" then
                        Validate("Assessment Code", '');

                end;

                if Type = Type::Course then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Code);
                    rCourseLines.SetRange("Subject Code", "Subject Code");
                    rCourseLines.SetRange("Line No.", "Line No.");
                    if rCourseLines.FindFirst then;

                    if rCourseLines."Evaluation Type" = rCourseLines."Evaluation Type"::Quantitative then
                        if "Evaluation Type" = "Evaluation Type"::Qualitative then
                            Error(Text0006);

                    if "Evaluation Type" <> xRec."Evaluation Type" then
                        Validate("Assessment Code", '');

                end;
            end;
        }
        field(11; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnValidate()
            begin
                if ("Sub-Subject Code" = '') and (xRec."Sub-Subject Code" <> '') then
                    Error(Text0013);

                ValidateAssessment;
            end;
        }
        field(12; "Sub-Subject Description"; Text[64])
        {
            Caption = 'Sub-Subject Description';
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
        field(15; "Maximum Injustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';
        }
        field(16; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));

            trigger OnValidate()
            var
                l_StudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
            begin
                l_StudentSubSubjectsPlan.Reset;
                l_StudentSubSubjectsPlan.SetRange(Type, Type);
                l_StudentSubSubjectsPlan.SetRange("Subject Code", "Subject Code");
                l_StudentSubSubjectsPlan.SetRange("Sub-Subject Code", "Sub-Subject Code");
                l_StudentSubSubjectsPlan.SetRange(Code, Code);
                l_StudentSubSubjectsPlan.SetRange("Schooling Year", "Schooling Year");
                if l_StudentSubSubjectsPlan.FindFirst then
                    Error(Text0021);
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
        }
        field(20; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
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
        field(73101; Observations; Code[20])
        {
            Caption = 'Observations';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab));
        }
        field(73102; "Moment Ponder"; Integer)
        {
            Caption = 'Moment Ponder';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;
        }
        field(73103; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(73104; "Report Description"; Text[250])
        {
            Caption = 'Report Description';
        }
        field(73105; "Option Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Schooling Year", "Subject Code", "Sub-Subject Code")
        {
            Clustered = true;
        }
        key(Key2; "Code", "Schooling Year", "Subject Code", "Sub-Subject Code")
        {
        }
        key(Key3; Type, "Code", "Subject Code")
        {
        }
        key(Key4; "Code", "Schooling Year", "Subject Code", "Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
    begin
        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetRange("Study Plan Code", Code);
        l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
        l_RegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        l_RegistrationSubjects.SetFilter(Status, '<>%1', 0);
        l_RegistrationSubjects.SetRange("Original Line No.", "Line No.");
        if l_RegistrationSubjects.FindFirst then begin
            l_StudentSubSubjectsPlan.Reset;
            l_StudentSubSubjectsPlan.SetRange("Schooling Year", "Schooling Year");
            l_StudentSubSubjectsPlan.SetRange("Subject Code", "Subject Code");
            l_StudentSubSubjectsPlan.SetRange("Sub-Subject Code", "Sub-Subject Code");
            l_StudentSubSubjectsPlan.SetRange(Code, Code);
            if l_StudentSubSubjectsPlan.FindFirst then
                Error(Text0016);
        end;

        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetRange("Study Plan Code", Code);
        l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
        l_RegistrationSubjects.SetRange("Subjects Code", "Subject Code");
        l_RegistrationSubjects.SetRange(Status, 0);
        l_RegistrationSubjects.SetRange("Original Line No.", "Line No.");
        if l_RegistrationSubjects.FindSet then begin
            l_StudentSubSubjectsPlan.Reset;
            l_StudentSubSubjectsPlan.SetRange("Schooling Year", "Schooling Year");
            l_StudentSubSubjectsPlan.SetRange("Subject Code", "Subject Code");
            l_StudentSubSubjectsPlan.SetRange("Sub-Subject Code", "Sub-Subject Code");
            l_StudentSubSubjectsPlan.SetRange(Code, Code);
            l_StudentSubSubjectsPlan.DeleteAll;
        end;



        l_SRSubSubjects.Reset;
        l_SRSubSubjects.SetRange("Type Education", Type);
        if Type = Type::"Study Plan" then
            l_SRSubSubjects.SetRange("School Year", "School Year");
        l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
        l_SRSubSubjects.SetRange("Study Plan Code", Code);
        l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
        l_SRSubSubjects.SetRange("Sub-Subject Code", "Sub-Subject Code");
        if Type = Type::Course then
            l_SRSubSubjects.SetRange("Line No.", "Line No.");
        l_SRSubSubjects.DeleteAll(true);

        recAspects.Reset;
        if Type = Type::"Study Plan" then begin
            recAspects.SetRange(Type, recAspects.Type::"Study Plan");
            recAspects.SetRange("School Year", "School Year");
        end;
        if Type = Type::Course then
            recAspects.SetRange(Type, recAspects.Type::Course);

        recAspects.SetRange("Schooling Year", "Schooling Year");
        recAspects.SetRange("Type No.", Code);
        recAspects.SetRange(Subjects, "Subject Code");
        recAspects.SetRange("Sub Subjects", "Sub-Subject Code");
        recAspects.DeleteAll(true);

        cInsertNAVMasterTable.DeleteSubSubjectCClass(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        if "Sub-Subject Code" = '' then
            Error(Text0012);


        "Country/Region Code" := cStudentsRegistration.GetCountry;


        if Type = Type::"Study Plan" then begin
            if StudyPlanHeader.Get(Code) then
                "Responsibility Center" := StudyPlanHeader."Responsibility Center";
        end;
        if Type = Type::Course then begin
            if rCourseHeader.Get(Code) then
                "Responsibility Center" := rCourseHeader."Responsibility Center";
        end;



        "User Id" := UserId;
        Date := WorkDate;

        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then
            cInsertNAVMasterTable.InsertSubSubjectCClass(Rec, xRec);

        if (Type = Type::Course) and ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, Code);
            rCourseLines.SetRange("Subject Code", "Subject Code");
            rCourseLines.SetRange("Line No.", "Line No.");
            if rCourseLines.FindFirst then
                cInsertNAVMasterTable.InsertSubjectCClass(rCourseLines, rCourseLines, true)
        end;

        if (Type = Type::"Study Plan") and ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, Code);
            rStudyPlanLines.SetRange("Subject Code", "Subject Code");
            if rStudyPlanLines.FindFirst then
                cInsertNAVMasterTable.InsertSubjectPLClass(rStudyPlanLines, rStudyPlanLines, true)
        end;

        rStudyPlanLines.Reset;
        rStudyPlanLines.SetRange(Code, Code);
        rStudyPlanLines.SetRange("Subject Code", "Subject Code");
        if rStudyPlanLines.FindFirst then begin
            "Mandatory/Optional Type" := rStudyPlanLines."Mandatory/Optional Type";
            "Curriculum Type" := rStudyPlanLines."Curriculum Type";
        end;
    end;

    trigger OnModify()
    var
        lStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        lSchoolYear: Record "School Year";
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin
        lSchoolYear.Reset;
        lSchoolYear.SetRange(Status, lSchoolYear.Status::Active);
        if lSchoolYear.FindSet then begin
            //Student Sub-Subjects Plan
            lStudentSubSubjectsPlan.Reset;
            lStudentSubSubjectsPlan.SetRange("School Year", lSchoolYear."School Year");
            lStudentSubSubjectsPlan.SetRange("Subject Code", "Subject Code");
            lStudentSubSubjectsPlan.SetRange("Sub-Subject Code", "Sub-Subject Code");
            lStudentSubSubjectsPlan.SetRange(Type, Type);
            lStudentSubSubjectsPlan.SetRange(Code, Code);
            lStudentSubSubjectsPlan.ModifyAll("Sorting ID", "Sorting ID");
            lStudentSubSubjectsPlan.ModifyAll("Subject Description", "Subject Description");
            lStudentSubSubjectsPlan.ModifyAll("Sub-Subject Description", "Sub-Subject Description");
            lStudentSubSubjectsPlan.ModifyAll("Assessment Code", "Assessment Code");
            lStudentSubSubjectsPlan.ModifyAll("Evaluation Type", "Evaluation Type");
            lStudentSubSubjectsPlan.ModifyAll("Maximum Injustified Absence", "Maximum Injustified Absence");
            lStudentSubSubjectsPlan.ModifyAll("Minimum Classification Level", "Minimum Classification Level");
            lStudentSubSubjectsPlan.ModifyAll("Maximum Total Absence", "Maximum Total Absence");
            lStudentSubSubjectsPlan.ModifyAll(Observations, Observations);
            lStudentSubSubjectsPlan.ModifyAll("Report Description", "Report Description", true);
        end;

        if ("Assessment Code" <> xRec."Assessment Code") or ("Evaluation Type" <> xRec."Evaluation Type") then begin
            l_SRSubSubjects.Reset;
            l_SRSubSubjects.SetRange("Type Education", Type);
            l_SRSubSubjects.SetRange("School Year", lSchoolYear."School Year");
            l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
            l_SRSubSubjects.SetRange("Study Plan Code", Code);
            l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
            l_SRSubSubjects.SetRange("Sub-Subject Code", "Sub-Subject Code");
            l_SRSubSubjects.ModifyAll("Assessment Code", "Assessment Code", true);
        end;


        //Test if the evaluation type if None Qualification and delete or update web lines
        if ("Evaluation Type" = "Evaluation Type"::"None Qualification") and
          ((xRec."Evaluation Type" <> xRec."Evaluation Type"::"None Qualification") or
          (xRec."Evaluation Type" <> xRec."Evaluation Type"::" ")) then begin
            cInsertNAVMasterTable.DeleteSubSubjectCClass(Rec, xRec);
        end;
        if ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            cInsertNAVMasterTable.InsertSubSubjectCClass(Rec, xRec);
        end;

        if (Type = Type::Course) and ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, Code);
            rCourseLines.SetRange("Subject Code", "Subject Code");
            rCourseLines.SetRange("Line No.", "Line No.");
            if rCourseLines.FindFirst then
                cInsertNAVMasterTable.InsertSubjectCClass(rCourseLines, rCourseLines, true)
        end;

        if (Type = Type::"Study Plan") and ("Evaluation Type" <> "Evaluation Type"::"None Qualification") then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, Code);
            rStudyPlanLines.SetRange("Subject Code", "Subject Code");
            if rStudyPlanLines.FindFirst then
                cInsertNAVMasterTable.InsertSubjectPLClass(rStudyPlanLines, rStudyPlanLines, true)
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
        StudyPlanHeader: Record "Study Plan Header";
        cStudentsRegistration: Codeunit "Students Registration";
        cUserEducation: Codeunit "User Education";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
        Text0001: Label 'You must specify a valid code';
        Text0002: Label 'The value must be between %1 and %2.';
        Text0003: Label 'There are no moments for School Year %1 and Schooling Year %2.';
        Text0005: Label 'Please insert %1.';
        recAspects: Record Aspects;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        Text0006: Label 'Evaluation type must be Quantitative.';
        Text0007: Label 'To use this option, first configure the subject Setting Ratings / Aspects.';
        Text0009: Label 'There is no overall configuration of Aspects.';
        rCourseHeader: Record "Course Header";
        Text0010: Label 'To use this option please configure the Course Setting Ratings for the subject %1.';
        Text0011: Label 'To use this option please configure the Study Plan Setting Ratings for the subject %1.';
        Text0012: Label 'The field sub-subject code is mandatory.';
        Text0013: Label 'The Sub-Subject Code field must not be blank.';
        Text0014: Label 'The school year duration of the sub-subject exceeds the main subject''s';
        Text0016: Label 'Not allowed to delete the sub-subject. There are students with the sub-subject.';
        Text0020: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";
        Text0021: Label 'The Assessement Code cannot be changed.';

    //[Scope('OnPrem')]
    procedure OpenCreateAssessmentConf()
    var
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_SRSubSubjects2: Record "Setting Ratings Sub-Subjects";
        l_SchoolYear: Record "School Year";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        lSettingRatings: Record "Setting Ratings";
        tLectiveYear: Text[1024];
    begin
        if Type = Type::Course then begin
            if rCourseHeader.Get(Code) then begin
                l_SchoolYear.Reset;
                l_SchoolYear.SetRange("School Year", rCourseHeader."School Year Begin");
                if l_SchoolYear.Find('-') then begin
                    if l_SchoolYear.Status = l_SchoolYear.Status::Planning then begin
                        //                CLEAR(varSchoolYear);
                        l_SchoolYear.Reset;
                        l_SchoolYear.SetFilter(Status, '%1', l_SchoolYear.Status::Planning);
                        if l_SchoolYear.Find('-') then
                            repeat
                                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
                            until l_SchoolYear.Next = 0;

                        Clear(int);

                        if tLectiveYear <> '' then begin
                            int := StrMenu(tLectiveYear);
                            l_SchoolYear.Reset;
                            l_SchoolYear.SetFilter(Status, '%1', l_SchoolYear.Status::Planning);
                            if l_SchoolYear.Find('-') and (int <> 0) then
                                l_SchoolYear.Next := int - 1
                            else
                                exit;
                        end;

                    end;
                    if l_SchoolYear.Status = l_SchoolYear.Status::Active then begin
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

                    end;
                end;

            end;
        end;

        l_rMomentsTEMP.DeleteAll;

        lSettingRatings.Reset;
        if Type = Type::Course then
            lSettingRatings.SetRange("School Year", l_SchoolYear."School Year");
        if Type = Type::"Study Plan" then
            lSettingRatings.SetRange("School Year", "School Year");
        lSettingRatings.SetRange("Schooling Year", "Schooling Year");
        lSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        lSettingRatings.SetRange("Type Education", Type);
        lSettingRatings.SetRange("Study Plan Code", Code);
        lSettingRatings.SetRange(Type, lSettingRatings.Type::Header);
        lSettingRatings.SetRange("Subject Code", "Subject Code");
        lSettingRatings.SetRange("Line No.", "Line No.");
        if lSettingRatings.FindSet then begin
            repeat
                l_rMoments.Reset;
                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                if Type = Type::Course then
                    l_rMoments.SetRange("School Year", l_SchoolYear."School Year");
                if Type = Type::"Study Plan" then
                    l_rMoments.SetRange("School Year", "School Year");
                l_rMoments.SetRange("Schooling Year", "Schooling Year");
                l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
                l_rMoments.SetRange("Moment Code", lSettingRatings."Moment Code");
                if l_rMoments.Find('-') then begin
                    l_rMomentsTEMP.Init;
                    l_rMomentsTEMP.TransferFields(l_rMoments);
                    l_rMomentsTEMP.Insert;
                end;
            until lSettingRatings.Next = 0;
        end else
            if Type = Type::"Study Plan" then
                Error(Text0011, "Subject Code")
            else
                Error(Text0010, "Subject Code");

        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
        if Type = Type::Course then
            l_rMomentsTEMP.SetRange("School Year", l_SchoolYear."School Year");
        if Type = Type::"Study Plan" then
            l_rMomentsTEMP.SetRange("School Year", "School Year");
        l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
        l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMomentsTEMP.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMomentsTEMP."Moment Code" + ','
            until l_rMomentsTEMP.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMomentsTEMP.Reset;
            l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
            if Type = Type::Course then
                l_rMomentsTEMP.SetRange("School Year", l_SchoolYear."School Year");
            if Type = Type::"Study Plan" then
                l_rMomentsTEMP.SetRange("School Year", "School Year");
            l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
            l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMomentsTEMP.Find('-') and (int <> 0) then
                l_rMomentsTEMP.Next := int - 1
            else
                exit;

            //validate setting rattings for the subject
            if Type = Type::"Study Plan" then
                ValidateSubjectSetRatting(l_rMomentsTEMP."Moment Code", "School Year", "Schooling Year", Code, "Subject Code", Type,
                                         "Responsibility Center");
            if Type = Type::Course then
                ValidateSubjectSetRatting(l_rMomentsTEMP."Moment Code", l_SchoolYear."School Year", "Schooling Year", Code, "Subject Code", Type,
                                         "Responsibility Center");


            l_SRSubSubjects.Reset;
            l_SRSubSubjects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
            if Type = Type::Course then begin
                l_SRSubSubjects.SetRange("School Year", l_SchoolYear."School Year");
                l_SRSubSubjects.SetRange("Line No.", "Line No.");
            end;
            if Type = Type::"Study Plan" then
                l_SRSubSubjects.SetRange("School Year", "School Year");
            l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
            l_SRSubSubjects.SetRange("Study Plan Code", Code);
            l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
            l_SRSubSubjects.SetRange("Sub-Subject Code", "Sub-Subject Code");
            l_SRSubSubjects.SetRange("Responsibility Center", "Responsibility Center");

            if not l_SRSubSubjects.Find('-') then begin
                l_SRSubSubjects.Init;
                l_SRSubSubjects."Moment Code" := l_rMomentsTEMP."Moment Code";
                if Type = Type::Course then begin
                    l_SRSubSubjects."School Year" := l_SchoolYear."School Year";
                    l_SRSubSubjects."Line No." := "Line No.";
                end;
                if Type = Type::"Study Plan" then
                    l_SRSubSubjects."School Year" := "School Year";

                l_SRSubSubjects."Schooling Year" := "Schooling Year";
                l_SRSubSubjects."Study Plan Code" := Code;
                l_SRSubSubjects."Subject Code" := "Subject Code";
                l_SRSubSubjects."Assessment Code" := "Assessment Code";
                l_SRSubSubjects.Type := l_SRSubSubjects.Type::Header;
                l_SRSubSubjects."Sub-Subject Code" := "Sub-Subject Code";
                l_SRSubSubjects."Sub-Subject Description" := "Sub-Subject Description";
                l_SRSubSubjects."Responsibility Center" := "Responsibility Center";
                if Type = Type::"Study Plan" then
                    l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Simple;
                if Type = Type::Course then
                    l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Multi;
                l_SRSubSubjects."Moment Ponder" := "Moment Ponder";
                l_SRSubSubjects."Sorting ID" := "Sorting ID";
                l_SRSubSubjects.Insert(true);

                l_SRSubSubjects.Reset;
                l_SRSubSubjects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
                if Type = Type::Course then
                    l_SRSubSubjects.SetRange("School Year", l_SchoolYear."School Year");
                if Type = Type::"Study Plan" then
                    l_SRSubSubjects.SetRange("School Year", "School Year");
                l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
                l_SRSubSubjects.SetRange("Study Plan Code", Code);
                l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
                l_SRSubSubjects.SetRange("Sub-Subject Code", "Sub-Subject Code");
                l_SRSubSubjects.SetRange("Responsibility Center", "Responsibility Center");
                if l_SRSubSubjects.Find('-') then;
                //FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings2);
            end;
            //ELSE begin
            l_SRSubSubjects.Reset;
            l_SRSubSubjects.SetRange("Moment Code");
            l_SRSubSubjects.SetRange("School Year");
            l_SRSubSubjects.SetRange("Schooling Year");
            l_SRSubSubjects.SetRange("Study Plan Code");
            l_SRSubSubjects.SetRange("Subject Code");
            l_SRSubSubjects.SetRange("Sub-Subject Code");
            //aspects
            if Type = Type::Course then
                SubjectsAspects(l_rMomentsTEMP."Moment Code", l_SchoolYear."School Year");
            if Type = Type::"Study Plan" then
                SubjectsAspects(l_rMomentsTEMP."Moment Code", "School Year");

            //
            PAGE.Run(PAGE::"Sub Subjects Setting Ratings", l_SRSubSubjects);
            //end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertSettingRatings()
    var
        l_SRSubSubjects: Record "Setting Ratings Sub-Subjects";
        l_rMoments: Record "Moments Assessment";
        Text0001: Label 'Unable to automatically configure the moments of Evaluation for Discipline.';
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
        if l_rMoments.Find('-') then begin
            repeat
                l_SRSubSubjects.Reset;
                l_SRSubSubjects.SetRange("Moment Code", l_rMoments."Moment Code");
                l_SRSubSubjects.SetRange("School Year", "School Year");
                l_SRSubSubjects.SetRange("Schooling Year", "Schooling Year");
                l_SRSubSubjects.SetRange("Study Plan Code", Code);
                l_SRSubSubjects.SetRange("Subject Code", "Subject Code");
                l_SRSubSubjects.SetRange("Sub-Subject Code", "Sub-Subject Code");
                if not l_SRSubSubjects.Find('-') then begin

                    l_SRSubSubjects.Init;
                    l_SRSubSubjects."Moment Code" := l_rMoments."Moment Code";
                    l_SRSubSubjects."School Year" := "School Year";
                    l_SRSubSubjects."Schooling Year" := "Schooling Year";
                    l_SRSubSubjects."Study Plan Code" := Code;
                    l_SRSubSubjects."Subject Code" := "Subject Code";
                    l_SRSubSubjects."Assessment Code" := "Assessment Code";
                    l_SRSubSubjects.Type := l_SRSubSubjects.Type::Header;
                    l_SRSubSubjects."Responsibility Center" := "Responsibility Center";
                    l_SRSubSubjects."Sub-Subject Code" := "Sub-Subject Code";
                    l_SRSubSubjects."Sub-Subject Description" := "Sub-Subject Description";
                    if Type = Type::"Study Plan" then
                        l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Simple;
                    if Type = Type::Course then
                        l_SRSubSubjects."Type Education" := l_SRSubSubjects."Type Education"::Multi;
                    l_SRSubSubjects."Moment Ponder" := "Moment Ponder";
                    l_SRSubSubjects.Insert(true);
                end else begin
                    l_SRSubSubjects."Assessment Code" := "Assessment Code";
                    l_SRSubSubjects.Modify(true);
                end;
            until l_rMoments.Next = 0;
        end else
            Error(Text0003, Code, "School Year");
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects(pMomentCode: Code[10]; pSchoolYear: Code[9])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange("School Year", pSchoolYear);
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Moment Code", pMomentCode);
        rAspects.SetRange("Sub Subjects", '');
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            if Type = Type::"Study Plan" then
                rAspects.InsertDefaultAspects2(rAspects, 4, pSchoolYear, Code, pMomentCode,
                                "Schooling Year", "Subject Code", '', "Evaluation Type", "Assessment Code",
                                "Responsibility Center");
            if Type = Type::Course then
                rAspects.InsertDefaultAspects2(rAspects, 2, pSchoolYear, Code, pMomentCode,
                                "Schooling Year", "Subject Code", '', "Evaluation Type", "Assessment Code",
                                "Responsibility Center");

        end;

        rAspects.Reset;
        //rAspects.SETRANGE(Type,Type);
        rAspects.SetRange("School Year", pSchoolYear);
        rAspects.SetRange("Type No.", Code);
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Schooling Year", "Schooling Year");
        rAspects.SetRange("Moment Code", pMomentCode);
        rAspects.SetRange("Sub Subjects", "Sub-Subject Code");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            if Type = Type::"Study Plan" then
                rAspects.InsertDefaultAspects2(rAspects, 4, pSchoolYear, Code, pMomentCode,
                                "Schooling Year", "Subject Code", "Sub-Subject Code", "Evaluation Type", "Assessment Code",
                                "Responsibility Center");
            if Type = Type::Course then
                rAspects.InsertDefaultAspects2(rAspects, 2, pSchoolYear, Code, pMomentCode,
                                "Schooling Year", "Subject Code", "Sub-Subject Code", "Evaluation Type", "Assessment Code",
                                "Responsibility Center");

            Commit;
        end;

        //fAspects.SETTABLEVIEW(rAspects);
        //FORM.RUNMODAL(FORM::Aspects,rAspects);;
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects2(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
        l_rMoments: Record "Moments Assessment";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        lSettingRatingsSS: Record "Setting Ratings Sub-Subjects";
        int: Integer;
        tAssessment: Text[1024];
    begin
        l_rMomentsTEMP.DeleteAll;

        lSettingRatingsSS.Reset;
        lSettingRatingsSS.SetRange("School Year", pSchoolYear);
        lSettingRatingsSS.SetRange("Schooling Year", pSchoolingYear);
        lSettingRatingsSS.SetRange("Responsibility Center", "Responsibility Center");
        lSettingRatingsSS.SetRange("Type Education", Type);
        lSettingRatingsSS.SetRange("Study Plan Code", Code);
        lSettingRatingsSS.SetRange(Type, lSettingRatingsSS.Type::Header);
        lSettingRatingsSS.SetRange("Subject Code", "Subject Code");
        lSettingRatingsSS.SetRange("Sub-Subject Code", "Sub-Subject Code");
        if lSettingRatingsSS.FindSet then begin
            repeat
                l_rMoments.Reset;
                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                l_rMoments.SetRange("School Year", pSchoolYear);
                l_rMoments.SetRange("Schooling Year", pSchoolingYear);
                l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
                l_rMoments.SetRange("Moment Code", lSettingRatingsSS."Moment Code");
                if l_rMoments.Find('-') then begin
                    l_rMomentsTEMP.Init;
                    l_rMomentsTEMP.TransferFields(l_rMoments);
                    l_rMomentsTEMP.Insert;
                end;
            until lSettingRatingsSS.Next = 0;
        end else
            if Type = Type::"Study Plan" then
                Error(Text0011, "Subject Code")
            else
                Error(Text0010, "Subject Code");

        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMomentsTEMP.SetRange("School Year", pSchoolYear);
        l_rMomentsTEMP.SetRange("Schooling Year", pSchoolingYear);
        l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMomentsTEMP.Find('-') then
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
        rAspects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Sub Subjects", "Sub-Subject Code");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Class, pSchoolYear, pClass, l_rMomentsTEMP."Moment Code",
                               pSchoolingYear, "Subject Code", "Sub-Subject Code", "Evaluation Type", "Assessment Code",
                               "Responsibility Center");

            Commit;
        end;

        PAGE.RunModal(PAGE::Aspects, rAspects);
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessment()
    begin
        if Type = Type::"Study Plan" then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, Code);
            rStudyPlanLines.SetRange("School Year", "School Year");
            rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
            rStudyPlanLines.SetRange("Subject Code", "Subject Code");
            if rStudyPlanLines.FindFirst then begin
                "Evaluation Type" := rStudyPlanLines."Evaluation Type";
                Validate("Assessment Code", rStudyPlanLines."Assessment Code");
            end;
        end;
        if Type = Type::Course then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, Code);
            rCourseLines.SetRange("Subject Code", "Subject Code");
            if rCourseLines.FindFirst then begin
                "Evaluation Type" := rCourseLines."Evaluation Type";
                Validate("Assessment Code", rCourseLines."Assessment Code");
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateSubjectSetRatting(pMoment: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[20]; pStudyPlan: Code[20]; pSubject: Code[20]; pType: Integer; pRespCenter: Code[20])
    var
        rSettingRatings: Record "Setting Ratings";
    begin
        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", pMoment);
        rSettingRatings.SetRange("School Year", pSchoolYear);
        rSettingRatings.SetRange("Schooling Year", pSchoolingYear);
        rSettingRatings.SetRange("Study Plan Code", pStudyPlan);
        rSettingRatings.SetRange("Subject Code", pSubject);
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        rSettingRatings.SetRange("Type Education", pType);
        if not rSettingRatings.FindFirst then
            Error(Text0007);
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubSubject()
    var
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        cStudentsRegistration.UpdateSubSubjectsCourse(Rec, cStudentsRegistration.GetShoolYearActive, "Schooling Year");
    end;
}

