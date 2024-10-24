codeunit 52768 InsertNAVGeneralTable
{
    Permissions = TableData "Assessing Students" = rimd,
                  TableData GeneralTable = rimd,
                  TableData GeneralTableAspects = rimd,
                  TableData MasterTableWEB = rimd,
                  TableData "WEB Remarks" = rimd;

    trigger OnRun()
    begin
    end;

    var
        rCompanyInformation: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";


    procedure InsertGTStudent(pRegistrationSubjects: Record "Registration Subjects")
    var
        rGeneralTable: Record GeneralTable;
        rSettingRatings: Record "Setting Ratings";
        rMomentsAssessment: Record "Moments Assessment";
        rTeacherClass: Record "Teacher Class";
        rUsersFamilyStudents: Record "Users Family / Students";
        rClass: Record Class;
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
        rEduConfig: Record "Edu. Configuration";
    begin
        if ValidateWeb = 0 then
            exit;

        Clear(rTeacherClass);
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
        rTeacherClass.SetRange("School Year", pRegistrationSubjects."School Year");
        rTeacherClass.SetRange(Class, pRegistrationSubjects.Class);
        rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
        rTeacherClass.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
        rTeacherClass.SetRange("Sub-Subject Code", '');
        rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
        if rTeacherClass.FindFirst then;

        Clear(rUsersFamilyStudents);
        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetRange("School Year", pRegistrationSubjects."School Year");
        rUsersFamilyStudents.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
        rUsersFamilyStudents.SetRange("Education Head", true);
        if rUsersFamilyStudents.FindFirst then;

        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rCourseLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            if rCourseLines.FindFirst then begin
                if rCourseLines."Evaluation Type" = rCourseLines."Evaluation Type"::"None Qualification" then
                    exit;
            end else
                exit;
        end;
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rStudyPlanLines.SetRange("School Year", pRegistrationSubjects."School Year");
            rStudyPlanLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            if rStudyPlanLines.FindFirst then begin
                if rStudyPlanLines."Evaluation Type" = rStudyPlanLines."Evaluation Type"::"None Qualification" then
                    exit;
            end else
                exit;
        end;

        rSettingRatings.Reset;
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        rSettingRatings.SetRange("School Year", pRegistrationSubjects."School Year");
        rSettingRatings.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
        rSettingRatings.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
        rSettingRatings.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
        rSettingRatings.SetRange("Line No.", pRegistrationSubjects."Original Line No.");
        if rSettingRatings.FindSet then begin
            repeat
                rStructureEducationCountry.Reset;
                rStructureEducationCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStructureEducationCountry.SetRange("Schooling Year", rSettingRatings."Schooling Year");
                if rStructureEducationCountry.FindFirst then;

                Clear(rGeneralTable);
                rGeneralTable.Init;
                rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::" ";
                rGeneralTable."Interface Type WEB" := rStructureEducationCountry."Interface Type WEB";
                rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
                rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
                rGeneralTable.Company := CompanyName;
                rGeneralTable."School Year" := pRegistrationSubjects."School Year";
                rGeneralTable.Student := pRegistrationSubjects."Student Code No.";
                rGeneralTable.Class := pRegistrationSubjects.Class;
                rGeneralTable.Subject := pRegistrationSubjects."Subjects Code";
                rGeneralTable.SubjectDescription := pRegistrationSubjects.Description;
                rGeneralTable."Sub Subject" := rGeneralTable.Subject;
                rGeneralTable.SubSubjectDescription := pRegistrationSubjects.Description;
                rGeneralTable.Moment := rSettingRatings."Moment Code";
                rGeneralTable."Subject Sorting ID" := pRegistrationSubjects."Sorting ID";
                rGeneralTable."Type Education" := pRegistrationSubjects.Type;
                rGeneralTable.Turn := pRegistrationSubjects.Turn;
                rGeneralTable.StudyPlanCode := pRegistrationSubjects."Study Plan Code";
                if rMomentsAssessment.Get(rSettingRatings."Moment Code", rSettingRatings."School Year", rSettingRatings."Schooling Year",
                                          rSettingRatings."Responsibility Center") then begin
                    rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                end;
                rGeneralTable.Teacher := rTeacherClass.User;
                rGeneralTable."Education Header" := rUsersFamilyStudents."No.";
                if rClass.Get(pRegistrationSubjects.Class, pRegistrationSubjects."School Year") then begin
                    rGeneralTable."Class Director" := rClass."Class Director No.";
                    rGeneralTable.ClassDescription := rClass.Description;
                end;
                if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then begin
                    rGeneralTable."Observations Group" := rCourseLines.Observations;
                    rGeneralTable."Assement Code" := rCourseLines."Assessment Code";
                    rGeneralTable."Option Group" := rCourseLines."Option Group";
                    rGeneralTable.EvaluationType := rCourseLines."Evaluation Type";
                    rCourseLines.CalcFields("Sub-Subject");
                    rGeneralTable.HasSubSubject := rCourseLines."Sub-Subject";
                    rGeneralTable."Large Description SS" := rCourseLines."Report Descripton";

                end else begin
                    rGeneralTable."Observations Group" := rStudyPlanLines.Observations;
                    rGeneralTable."Assement Code" := rStudyPlanLines."Assessment Code";
                    rGeneralTable."Option Group" := rStudyPlanLines."Option Group";
                    rGeneralTable.EvaluationType := rStudyPlanLines."Evaluation Type";
                    rStudyPlanLines.CalcFields("Sub-Subject");
                    rGeneralTable.HasSubSubject := rStudyPlanLines."Sub-Subject";
                    rGeneralTable."Large Description SS" := rStudyPlanLines."Report Descripton";
                end;
                rGeneralTable."Subject Ponder" := rSettingRatings."Moment Ponder";
                rGeneralTable."Subject Class" := pRegistrationSubjects.Description + ' ' + rClass.Description;
                rGeneralTable."Responsibility Center" := pRegistrationSubjects."Responsibility Center";
                rGeneralTable.SchoolingYear := pRegistrationSubjects."Schooling Year";
                rGeneralTable."Original Line No." := pRegistrationSubjects."Original Line No.";

                rEduConfig.Get;

                rGeneralTable.Insert;
                //Get assessemts
                GetAssessment(rGeneralTable);
                rGeneralTable.Modify;

                //Aspects
                InsertAspects(pRegistrationSubjects, rGeneralTable, '');
                //SUB SUBJECTS
                pRegistrationSubjects.CalcFields("Sub-subject");
                if pRegistrationSubjects."Sub-subject" then
                    InsertGenTableSubSubjetc(pRegistrationSubjects, rSettingRatings."Moment Code");
            until rSettingRatings.Next = 0;
        end;
    end;


    procedure InsertGenTableSubSubjetc(pRegistrationSubjects: Record "Registration Subjects"; pMomentCode: Code[20])
    var
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rGeneralTable: Record GeneralTable;
        rEduConfig: Record "Edu. Configuration";
        rMomentsAssessment: Record "Moments Assessment";
        rUsersFamilyStudents: Record "Users Family / Students";
        rClass: Record Class;
        rTeacherClass: Record "Teacher Class";
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        rSettingRatings: Record "Setting Ratings";
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
    begin
        if ValidateWeb = 0 then
            exit;

        Clear(rUsersFamilyStudents);
        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetRange("School Year", pRegistrationSubjects."School Year");
        rUsersFamilyStudents.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
        rUsersFamilyStudents.SetRange("Education Head", true);
        if rUsersFamilyStudents.FindFirst then;

        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rCourseLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            rCourseLines.SetRange("Line No.", pRegistrationSubjects."Original Line No.");
            if rCourseLines.FindFirst then;
        end;
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rStudyPlanLines.SetRange("School Year", rStudyPlanLines."School Year");
            rStudyPlanLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            if rStudyPlanLines.FindFirst then;
        end;

        rStudentSubSubjectsPlan.Reset;
        rStudentSubSubjectsPlan.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
        rStudentSubSubjectsPlan.SetRange("School Year", pRegistrationSubjects."School Year");
        rStudentSubSubjectsPlan.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then
            rStudentSubSubjectsPlan.SetRange(Type, rStudentSubSubjectsPlan.Type::Simple);
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then begin
            rStudentSubSubjectsPlan.SetRange(Type, rStudentSubSubjectsPlan.Type::Multi);
            rStudentSubSubjectsPlan.SetRange("Line No.", pRegistrationSubjects."Original Line No.");
        end;
        rStudentSubSubjectsPlan.SetRange(Code, pRegistrationSubjects."Study Plan Code");
        rStudentSubSubjectsPlan.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
        if rStudentSubSubjectsPlan.FindSet then begin
            repeat
                if rStudentSubSubjectsPlan."Evaluation Type" <> rStudentSubSubjectsPlan."Evaluation Type"::"None Qualification" then begin
                    Clear(rTeacherClass);
                    rTeacherClass.Reset;
                    rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
                    rTeacherClass.SetRange("School Year", pRegistrationSubjects."School Year");
                    rTeacherClass.SetRange(Class, pRegistrationSubjects.Class);
                    rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
                    rTeacherClass.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                    rTeacherClass.SetRange("Sub-Subject Code", rStudentSubSubjectsPlan."Sub-Subject Code");
                    rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
                    if rTeacherClass.FindFirst then;

                    rSettingRatingsSubSubjects.Reset;
                    rSettingRatingsSubSubjects.SetRange(Type, rSettingRatingsSubSubjects.Type::Header);
                    rSettingRatingsSubSubjects.SetRange("School Year", pRegistrationSubjects."School Year");
                    rSettingRatingsSubSubjects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    rSettingRatingsSubSubjects.SetRange("Moment Code", pMomentCode);
                    rSettingRatingsSubSubjects.SetRange("Study Plan Code", rStudentSubSubjectsPlan.Code);
                    rSettingRatingsSubSubjects.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                    rSettingRatingsSubSubjects.SetRange("Sub-Subject Code", rStudentSubSubjectsPlan."Sub-Subject Code");
                    rSettingRatingsSubSubjects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                    if rSettingRatingsSubSubjects."Type Education" = rSettingRatingsSubSubjects."Type Education"::Multi then
                        rSettingRatingsSubSubjects.SetRange("Line No.", rStudentSubSubjectsPlan."Line No.");
                    if rSettingRatingsSubSubjects.FindSet then begin
                        repeat
                            Clear(rGeneralTable);
                            rGeneralTable.Init;
                            rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::" ";
                            rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
                            rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
                            rGeneralTable.Company := CompanyName;
                            rGeneralTable."School Year" := pRegistrationSubjects."School Year";
                            rGeneralTable.Student := pRegistrationSubjects."Student Code No.";
                            rGeneralTable.Class := pRegistrationSubjects.Class;
                            rGeneralTable.Subject := pRegistrationSubjects."Subjects Code";
                            rGeneralTable.SubjectDescription := pRegistrationSubjects.Description;
                            rGeneralTable."Sub Subject" := rStudentSubSubjectsPlan."Sub-Subject Code";
                            rGeneralTable.SubSubjectDescription := rStudentSubSubjectsPlan."Sub-Subject Description";
                            rGeneralTable.Turn := rStudentSubSubjectsPlan.Turn;
                            rGeneralTable."Type Education" := pRegistrationSubjects.Type;
                            rGeneralTable.StudyPlanCode := pRegistrationSubjects."Study Plan Code";
                            if rGeneralTable.SubSubjectDescription = '' then
                                if StrLen(pRegistrationSubjects.Description + rGeneralTable."Sub Subject") + 1 > 64 then begin
                                    rGeneralTable.SubSubjectDescription :=
                                    CopyStr(pRegistrationSubjects.Description,
                                    1,
                                    (StrLen(pRegistrationSubjects.Description) - StrLen(rGeneralTable."Sub Subject")) - 1)
                                    + ' ' + rGeneralTable."Sub Subject"
                                end else
                                    rGeneralTable.SubSubjectDescription := pRegistrationSubjects.Description + ' ' + rGeneralTable."Sub Subject";

                            rGeneralTable.Moment := rSettingRatingsSubSubjects."Moment Code";
                            rGeneralTable."Assement Code" := rSettingRatingsSubSubjects."Assessment Code";
                            if rMomentsAssessment.Get(rSettingRatingsSubSubjects."Moment Code", rSettingRatingsSubSubjects."School Year",
                                                      rSettingRatingsSubSubjects."Schooling Year",
                                                      rSettingRatingsSubSubjects."Responsibility Center") then begin
                                rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                            end;

                            rGeneralTable."Education Header" := rUsersFamilyStudents."No.";
                            if rClass.Get(pRegistrationSubjects.Class, pRegistrationSubjects."School Year") then begin
                                rGeneralTable."Class Director" := rClass."Class Director No.";
                                rGeneralTable.ClassDescription := rClass.Description;
                            end;

                            rGeneralTable.Teacher := rTeacherClass.User;

                            rStudyPlanSubSubjectsLines.Reset;
                            if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
                                rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
                                rStudyPlanSubSubjectsLines.SetRange("School Year", pRegistrationSubjects."School Year");
                            end;
                            if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then
                                rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::Course);
                            rStudyPlanSubSubjectsLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
                            rStudyPlanSubSubjectsLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                            rStudyPlanSubSubjectsLines.SetRange("Sub-Subject Code", rSettingRatingsSubSubjects."Sub-Subject Code");
                            rStudyPlanSubSubjectsLines.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                            if rStudyPlanSubSubjectsLines.FindFirst then begin
                                rGeneralTable."Observations Group" := rStudyPlanSubSubjectsLines.Observations;
                                rGeneralTable.EvaluationType := rStudyPlanSubSubjectsLines."Evaluation Type";
                            end;

                            rSettingRatings.Reset;
                            rSettingRatings.SetRange("Moment Code", rSettingRatingsSubSubjects."Moment Code");
                            rSettingRatings.SetRange("School Year", pRegistrationSubjects."School Year");
                            rSettingRatings.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                            rSettingRatings.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
                            rSettingRatings.SetRange("Line No.", pRegistrationSubjects."Original Line No.");
                            if rSettingRatings.FindFirst then
                                rGeneralTable."Subject Ponder" := rSettingRatings."Moment Ponder"
                            else begin
                                if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then
                                    rGeneralTable."Subject Ponder" := rStudyPlanLines.Weighting;
                                if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then
                                    rGeneralTable."Subject Ponder" := rCourseLines.Weighting;
                            end;

                            rGeneralTable."Sub Subject Ponder" := rSettingRatingsSubSubjects."Moment Ponder";
                            rGeneralTable."Subject Class" := rStudentSubSubjectsPlan."Sub-Subject Description" + ' ' +
                            rClass.Description;
                            rGeneralTable."Responsibility Center" := rStudentSubSubjectsPlan."Responsibility Center";
                            rGeneralTable.SchoolingYear := rStudentSubSubjectsPlan."Schooling Year";
                            rGeneralTable."Subject Sorting ID" := rStudentSubSubjectsPlan."Sorting ID";
                            rGeneralTable."Large Description SS" := rStudentSubSubjectsPlan."Report Description";
                            rGeneralTable."Original Line No." := pRegistrationSubjects."Original Line No.";

                            rEduConfig.Get;
                            rGeneralTable."Is SubSubject" := true;
                            rGeneralTable."Interface Type WEB" := rStructureEducationCountry."Interface Type WEB";
                            rGeneralTable.Insert;

                            //Get assessemts
                            GetAssessment(rGeneralTable);
                            rGeneralTable.Modify;

                            //aspects - Bloqueado dia 09-03-2009
                            InsertAspects(pRegistrationSubjects, rGeneralTable, rStudentSubSubjectsPlan."Sub-Subject Code");

                        until rSettingRatingsSubSubjects.Next = 0;
                    end;
                end;
            until rStudentSubSubjectsPlan.Next = 0;
        end;
    end;


    procedure InsGenTableSubSubjetcAddiciona(pRegistrationSubjects: Record "Registration Subjects"; pStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ")
    var
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rGeneralTable: Record GeneralTable;
        rEduConfig: Record "Edu. Configuration";
        rMomentsAssessment: Record "Moments Assessment";
        rUsersFamilyStudents: Record "Users Family / Students";
        rClass: Record Class;
        rTeacherClass: Record "Teacher Class";
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        rSettingRatings: Record "Setting Ratings";
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
    begin
        if ValidateWeb = 0 then
            exit;

        Clear(rUsersFamilyStudents);
        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetRange("School Year", pRegistrationSubjects."School Year");
        rUsersFamilyStudents.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
        rUsersFamilyStudents.SetRange("Education Head", true);
        if rUsersFamilyStudents.FindFirst then;

        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rCourseLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            if rCourseLines.FindFirst then;
        end;
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
            rStudyPlanLines.SetRange("School Year", rStudyPlanLines."School Year");
            rStudyPlanLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            if rStudyPlanLines.FindFirst then;
        end;

        if pStudentSubSubjectsPlan."Evaluation Type" <> pStudentSubSubjectsPlan."Evaluation Type"::"None Qualification" then begin
            Clear(rTeacherClass);
            rTeacherClass.Reset;
            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
            rTeacherClass.SetRange("School Year", pRegistrationSubjects."School Year");
            rTeacherClass.SetRange(Class, pRegistrationSubjects.Class);
            rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
            rTeacherClass.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            rTeacherClass.SetRange("Sub-Subject Code", pStudentSubSubjectsPlan."Sub-Subject Code");
            rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
            if rTeacherClass.FindFirst then;

            rSettingRatingsSubSubjects.Reset;
            rSettingRatingsSubSubjects.SetRange(Type, rSettingRatingsSubSubjects.Type::Header);
            rSettingRatingsSubSubjects.SetRange("School Year", pRegistrationSubjects."School Year");
            rSettingRatingsSubSubjects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
            //rSettingRatingsSubSubjects.SETRANGE("Moment Code",pMomentCode);
            rSettingRatingsSubSubjects.SetRange("Study Plan Code", pStudentSubSubjectsPlan.Code);
            rSettingRatingsSubSubjects.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
            rSettingRatingsSubSubjects.SetRange("Sub-Subject Code", pStudentSubSubjectsPlan."Sub-Subject Code");
            rSettingRatingsSubSubjects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
            if rSettingRatingsSubSubjects.FindSet then begin
                repeat
                    Clear(rGeneralTable);
                    rGeneralTable.Init;
                    rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::" ";
                    rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
                    rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
                    rGeneralTable.Company := CompanyName;
                    rGeneralTable."School Year" := pRegistrationSubjects."School Year";
                    rGeneralTable.Student := pRegistrationSubjects."Student Code No.";
                    rGeneralTable.Class := pRegistrationSubjects.Class;
                    rGeneralTable.Subject := pRegistrationSubjects."Subjects Code";
                    rGeneralTable.SubjectDescription := pRegistrationSubjects.Description;
                    rGeneralTable."Sub Subject" := pStudentSubSubjectsPlan."Sub-Subject Code";
                    rGeneralTable.SubSubjectDescription := pStudentSubSubjectsPlan."Sub-Subject Description";
                    rGeneralTable."Type Education" := pRegistrationSubjects.Type;
                    rGeneralTable.StudyPlanCode := pRegistrationSubjects."Study Plan Code";
                    rGeneralTable.Turn := pStudentSubSubjectsPlan.Turn;
                    if rGeneralTable.SubSubjectDescription = '' then
                        if StrLen(pRegistrationSubjects.Description + rGeneralTable."Sub Subject") + 1 > 64 then begin
                            rGeneralTable.SubSubjectDescription :=
                                    CopyStr(pRegistrationSubjects.Description,
                                    1,
                                    (StrLen(pRegistrationSubjects.Description) - StrLen(rGeneralTable."Sub Subject")) - 1)
                                    + ' ' + rGeneralTable."Sub Subject"
                        end else
                            rGeneralTable.SubSubjectDescription := pRegistrationSubjects.Description + ' ' + rGeneralTable."Sub Subject";

                    rGeneralTable.Moment := rSettingRatingsSubSubjects."Moment Code";
                    rGeneralTable."Assement Code" := rSettingRatingsSubSubjects."Assessment Code";


                    if rMomentsAssessment.Get(rSettingRatingsSubSubjects."Moment Code", rSettingRatingsSubSubjects."School Year",
                                              rSettingRatingsSubSubjects."Schooling Year",
                                              rSettingRatingsSubSubjects."Responsibility Center") then begin

                        rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                    end;

                    rGeneralTable."Education Header" := rUsersFamilyStudents."No.";
                    if rClass.Get(pRegistrationSubjects.Class, pRegistrationSubjects."School Year") then begin
                        rGeneralTable."Class Director" := rClass."Class Director No.";
                        rGeneralTable.ClassDescription := rClass.Description;
                    end;

                    rGeneralTable.Teacher := rTeacherClass.User;

                    rStudyPlanSubSubjectsLines.Reset;
                    if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
                        rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
                        rStudyPlanSubSubjectsLines.SetRange("School Year", pRegistrationSubjects."School Year");
                    end;
                    if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then
                        rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::Course);
                    rStudyPlanSubSubjectsLines.SetRange(Code, pRegistrationSubjects."Study Plan Code");
                    rStudyPlanSubSubjectsLines.SetRange("Subject Code", pRegistrationSubjects."Subjects Code");
                    rStudyPlanSubSubjectsLines.SetRange("Sub-Subject Code", rSettingRatingsSubSubjects."Sub-Subject Code");
                    rStudyPlanSubSubjectsLines.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    if rStudyPlanSubSubjectsLines.FindFirst then begin
                        rGeneralTable."Observations Group" := rStudyPlanSubSubjectsLines.Observations;
                        rGeneralTable.EvaluationType := rStudyPlanSubSubjectsLines."Evaluation Type";
                    end;

                    rSettingRatings.Reset;
                    rSettingRatings.SetRange("Moment Code", rSettingRatingsSubSubjects."Moment Code");
                    rSettingRatings.SetRange("School Year", pRegistrationSubjects."School Year");
                    rSettingRatings.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    rSettingRatings.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
                    rSettingRatings.SetRange("Line No.", pRegistrationSubjects."Original Line No.");
                    if rSettingRatings.FindFirst then
                        rGeneralTable."Subject Ponder" := rSettingRatings."Moment Ponder"
                    else begin
                        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then
                            rGeneralTable."Subject Ponder" := rStudyPlanLines.Weighting;
                        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then
                            rGeneralTable."Subject Ponder" := rCourseLines.Weighting;
                    end;

                    rGeneralTable."Sub Subject Ponder" := rSettingRatingsSubSubjects."Moment Ponder";
                    rGeneralTable."Subject Class" := pStudentSubSubjectsPlan."Sub-Subject Description" + ' ' +
                    rClass.Description;
                    rGeneralTable."Responsibility Center" := pStudentSubSubjectsPlan."Responsibility Center";
                    rGeneralTable.SchoolingYear := pStudentSubSubjectsPlan."Schooling Year";
                    rGeneralTable."Subject Sorting ID" := pStudentSubSubjectsPlan."Sorting ID";
                    rGeneralTable."Large Description SS" := pStudentSubSubjectsPlan."Report Description";
                    rGeneralTable."Original Line No." := pRegistrationSubjects."Original Line No.";

                    rEduConfig.Get;

                    rGeneralTable."Is SubSubject" := true;
                    rGeneralTable."Interface Type WEB" := rStructureEducationCountry."Interface Type WEB";
                    rGeneralTable.Insert;

                    //Get assessemts
                    GetAssessment(rGeneralTable);
                    rGeneralTable.Modify;

                    //aspects - Bloqueado dia 09-03-2009
                    InsertAspects(pRegistrationSubjects, rGeneralTable, pStudentSubSubjectsPlan."Sub-Subject Code");

                until rSettingRatingsSubSubjects.Next = 0;
            end;
        end;
    end;


    procedure ModDelGTSubjectAssessemetSP(pStudyPlanLines: Record "Study Plan Lines"; "pDelete?": Boolean)
    var
        rGeneralTable: Record GeneralTable;
        rSettingRatings: Record "Setting Ratings";
        rMomentsAssessment: Record "Moments Assessment";
        rClass: Record Class;
        Deleted: Boolean;
    begin
        //STUDY PLAN
        // "pDelete?" = True -> DELETE
        // "pDelete?" = False -> UPDATE

        if ValidateWeb = 0 then
            exit;

        rClass.Reset;
        rClass.SetRange("Study Plan Code", pStudyPlanLines.Code);
        rClass.SetRange("School Year", pStudyPlanLines."School Year");
        if rClass.FindSet then begin
            repeat
                Deleted := false;
                rGeneralTable.Reset;
                //rGeneralTable.SETRANGE("Update Type",rGeneralTable."Update Type"::" ");
                rGeneralTable.SetRange("School Year", pStudyPlanLines."School Year");
                rGeneralTable.SetRange(Class, rClass.Class);
                rGeneralTable.SetRange(Company, CompanyName);
                rGeneralTable.SetRange(Subject, pStudyPlanLines."Subject Code");
                rGeneralTable.SetRange("Is SubSubject", false);
                rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
                if rGeneralTable.FindSet(true) then begin
                    repeat
                        rSettingRatings.Reset;
                        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
                        rSettingRatings.SetRange("School Year", pStudyPlanLines."School Year");
                        rSettingRatings.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
                        rSettingRatings.SetRange("Study Plan Code", pStudyPlanLines.Code);
                        rSettingRatings.SetRange("Subject Code", pStudyPlanLines."Subject Code");
                        rSettingRatings.SetRange("Moment Code", rGeneralTable.Moment);
                        rSettingRatings.SetRange("Line No.", rGeneralTable."Original Line No.");
                        if rSettingRatings.FindFirst then begin
                            if "pDelete?" and not Deleted then begin
                                rGeneralTable.ModifyAll("Update Type", rGeneralTable."Update Type"::Delete);
                                rGeneralTable.ModifyAll("Update Type 2", rGeneralTable."Update Type 2"::Delete);
                                Deleted := true;
                            end else begin
                                if rMomentsAssessment.Get(rSettingRatings."Moment Code", rSettingRatings."School Year",
                                                          rSettingRatings."Schooling Year",
                                                          rSettingRatings."Responsibility Center") then begin
                                    rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                                    rGeneralTable."Assement Code" := pStudyPlanLines."Assessment Code";
                                    rGeneralTable.EvaluationType := pStudyPlanLines."Evaluation Type";
                                    rGeneralTable."Subject Ponder" := pStudyPlanLines.Weighting;
                                    rGeneralTable."Observations Group" := pStudyPlanLines.Observations;
                                    rGeneralTable.SubjectDescription := pStudyPlanLines."Subject Description";
                                    rGeneralTable."Large Description SS" := pStudyPlanLines."Report Descripton";
                                    if rGeneralTable."Sub Subject" = rGeneralTable.Subject then
                                        rGeneralTable.SubSubjectDescription := pStudyPlanLines."Subject Description";
                                    rGeneralTable."Subject Sorting ID" := pStudyPlanLines."Sorting ID";
                                    if (rGeneralTable."Update Type" = rGeneralTable."Update Type"::" ") or
                                      (rGeneralTable."Update Type" = rGeneralTable."Update Type"::Delete) then
                                        rGeneralTable."Update Type" := rGeneralTable."Update Type"::Update;

                                    if (rGeneralTable."Update Type 2" = rGeneralTable."Update Type 2"::" ") or
                                      (rGeneralTable."Update Type 2" = rGeneralTable."Update Type 2"::Delete) then
                                        rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Update;
                                    rGeneralTable.Modify;
                                end;
                            end;
                        end;
                    until rGeneralTable.Next = 0;
                end;
            until rClass.Next = 0;
        end;
    end;


    procedure ModDelGTSubjectAssessemetCL(pCourseLines: Record "Course Lines"; "pDelete?": Boolean)
    var
        rGeneralTable: Record GeneralTable;
        rSettingRatings: Record "Setting Ratings";
        rMomentsAssessment: Record "Moments Assessment";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
        rSchoolYear: Record "School Year";
        Deleted: Boolean;
    begin
        //COURSE
        // "pDelete?" = True -> DELETE
        // "pDelete?" = False -> UPDATE

        if ValidateWeb = 0 then
            exit;

        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1', rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;


        rClass.Reset;
        rClass.SetRange("Study Plan Code", pCourseLines.Code);
        rClass.SetRange("School Year", rSchoolYear."School Year");
        if rClass.FindSet then begin
            repeat
                Deleted := false;
                rGeneralTable.Reset;
                rGeneralTable.SetRange("School Year", rClass."School Year");
                rGeneralTable.SetRange(Class, rClass.Class);
                rGeneralTable.SetRange(Company, CompanyName);
                rGeneralTable.SetRange(Subject, pCourseLines."Subject Code");
                rGeneralTable.SetRange("Is SubSubject", false);
                rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
                if rGeneralTable.FindSet(true) then begin
                    repeat
                        rSettingRatings.Reset;
                        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
                        rSettingRatings.SetRange("School Year", rClass."School Year");
                        rSettingRatings.SetRange("Schooling Year", rClass."Schooling Year");
                        rSettingRatings.SetRange("Study Plan Code", pCourseLines.Code);
                        rSettingRatings.SetRange("Subject Code", pCourseLines."Subject Code");
                        rSettingRatings.SetRange("Moment Code", rGeneralTable.Moment);
                        rSettingRatings.SetRange("Line No.", rGeneralTable."Original Line No.");
                        if rSettingRatings.FindFirst then begin
                            if "pDelete?" and not Deleted then begin
                                rGeneralTable.ModifyAll("Update Type", rGeneralTable."Update Type"::Delete);
                                rGeneralTable.ModifyAll("Update Type 2", rGeneralTable."Update Type 2"::Delete);
                                Deleted := true;
                            end else begin
                                if rMomentsAssessment.Get(rSettingRatings."Moment Code", rSettingRatings."School Year",
                                                          rSettingRatings."Schooling Year",
                                                          rSettingRatings."Responsibility Center") then begin
                                    rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                                    rGeneralTable."Assement Code" := pCourseLines."Assessment Code";
                                    rGeneralTable.EvaluationType := pCourseLines."Evaluation Type";
                                    rGeneralTable."Subject Ponder" := pCourseLines.Weighting;
                                    rGeneralTable."Observations Group" := pCourseLines.Observations;
                                    rGeneralTable.SubjectDescription := pCourseLines."Subject Description";
                                    if rGeneralTable."Sub Subject" = rGeneralTable.Subject then
                                        rGeneralTable.SubSubjectDescription := pCourseLines."Subject Description";
                                    rGeneralTable."Subject Sorting ID" := pCourseLines."Sorting ID";
                                    rGeneralTable."Large Description SS" := pCourseLines."Report Descripton";

                                    if (rGeneralTable."Update Type" = rGeneralTable."Update Type"::" ") or
                                       (rGeneralTable."Update Type" = rGeneralTable."Update Type"::Delete) then
                                        rGeneralTable."Update Type" := rGeneralTable."Update Type"::Update;
                                    if (rGeneralTable."Update Type 2" = rGeneralTable."Update Type 2"::" ") or
                                       (rGeneralTable."Update Type" = rGeneralTable."Update Type 2"::Delete) then
                                        rGeneralTable."Update Type 2" := rGeneralTable."Update Type"::Update;

                                    rGeneralTable.Modify;
                                end;
                            end;
                        end;
                    until rGeneralTable.Next = 0;
                end;
            until rClass.Next = 0;
        end;
    end;


    procedure DelGTStudent(pRegistrationSubjects: Record "Registration Subjects")
    var
        rGeneralTable: Record GeneralTable;
        rGeneralTable2: Record GeneralTable;
        rGeneralTableAspects: Record GeneralTableAspects;
        rGeneralTableAspects2: Record GeneralTableAspects;
    begin
        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetRange(Company, CompanyName);
        rGeneralTable.SetRange("School Year", pRegistrationSubjects."School Year");
        rGeneralTable.SetRange(Student, pRegistrationSubjects."Student Code No.");
        rGeneralTable.SetRange(Class, pRegistrationSubjects.Class);
        rGeneralTable.SetRange(Subject, pRegistrationSubjects."Subjects Code");
        rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
        if rGeneralTable.FindSet(true) then begin
            repeat
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                if rGeneralTableAspects.FindSet(true) then begin
                    repeat
                        if rGeneralTableAspects."Update Type" <> rGeneralTableAspects."Update Type"::Insert then begin
                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;
                            rGeneralTableAspects.Modify;
                        end else begin
                            rGeneralTableAspects2.Get(rGeneralTableAspects."Entry No.");
                            rGeneralTableAspects2.Delete;
                        end;
                    until rGeneralTableAspects.Next = 0;
                end;

                if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Insert then begin
                    rGeneralTable."Update Type" := rGeneralTable."Update Type"::Delete;
                    rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Delete;
                    rGeneralTable.Modify;
                end else begin
                    rGeneralTable2.Get(rGeneralTable."Entry No.");
                    rGeneralTable2.Delete;
                end;
            until rGeneralTable.Next = 0;
        end;
    end;


    procedure InsertAspects(pRegistrationSubjects: Record "Registration Subjects"; pGeneralTable: Record GeneralTable; pSubSubjects: Code[20])
    var
        rAspects: Record Aspects;
        rGeneralTableAspects: Record GeneralTableAspects;
    begin
        if ValidateWeb = 0 then
            exit;

        rAspects.Reset;
        rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
        rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
        rAspects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
        rAspects.SetRange("Moment Code", pGeneralTable.Moment);
        rAspects.SetRange(Type, rAspects.Type::Student);
        rAspects.SetRange("Type No.", pRegistrationSubjects."Student Code No.");
        rAspects.SetRange(Subjects, pRegistrationSubjects."Subjects Code");
        rAspects.SetRange("Sub Subjects", pSubSubjects);
        rAspects.SetRange("Not to WEB", false);
        if not rAspects.FindSet then begin
            rAspects.Reset;
            rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
            rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
            rAspects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
            rAspects.SetRange(Type, rAspects.Type::Class);
            rAspects.SetRange("Type No.", pRegistrationSubjects.Class);
            rAspects.SetRange("Moment Code", pGeneralTable.Moment);
            rAspects.SetRange(Subjects, pRegistrationSubjects."Subjects Code");
            rAspects.SetRange("Sub Subjects", pSubSubjects);
            rAspects.SetRange("Not to WEB", false);
            if not rAspects.FindSet then begin
                if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Simple then begin
                    rAspects.Reset;
                    rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                    rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
                    rAspects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                    rAspects.SetRange("Moment Code", pGeneralTable.Moment);
                    rAspects.SetRange(Subjects, pRegistrationSubjects."Subjects Code");
                    rAspects.SetRange("Sub Subjects", pSubSubjects);
                    rAspects.SetRange("Type No.", pRegistrationSubjects."Study Plan Code");
                    rAspects.SetRange("Not to WEB", false);
                    if not rAspects.FindSet then begin
                        //If the Study Plan does not have aspects to send does not send

                        rAspects.Reset;
                        rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                        rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
                        rAspects.SetRange(Type, rAspects.Type::Overall);
                        rAspects.SetRange("Not to WEB", false);
                        if not rAspects.FindSet then begin
                        end;
                    end;
                end else begin
                    rAspects.Reset;
                    rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                    rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
                    rAspects.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                    rAspects.SetRange(Type, rAspects.Type::Course);
                    rAspects.SetRange("Moment Code", pGeneralTable.Moment);
                    rAspects.SetRange("Not to WEB", false);
                    rAspects.SetRange(Subjects, pRegistrationSubjects."Subjects Code");
                    rAspects.SetRange("Sub Subjects", pSubSubjects);
                    rAspects.SetRange("Type No.", pRegistrationSubjects."Study Plan Code");
                    if not rAspects.FindSet then begin
                        //If the Course does not have aspects to send does not send

                        rAspects.Reset;
                        rAspects.SetRange("Responsibility Center", pRegistrationSubjects."Responsibility Center");
                        rAspects.SetRange("School Year", pRegistrationSubjects."School Year");
                        rAspects.SetRange(Type, rAspects.Type::Overall);
                        rAspects.SetRange("Not to WEB", false);
                        if not rAspects.FindSet then begin
                        end;
                    end;
                end;
            end;
        end;
        if rAspects.Count >= 1 then begin
            repeat
                Clear(rGeneralTableAspects);
                rGeneralTableAspects.Init;
                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Insert;
                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Insert;
                rGeneralTableAspects.Company := CompanyName;
                rGeneralTableAspects."Study Plan Entry No." := pGeneralTable."Entry No.";
                rGeneralTableAspects."School Year" := pGeneralTable."School Year";
                rGeneralTableAspects.Student := pGeneralTable.Student;
                rGeneralTableAspects.Class := pGeneralTable.Class;
                rGeneralTableAspects.Subject := pGeneralTable.Subject;
                rGeneralTableAspects."Sub Subject" := pGeneralTable."Sub Subject";
                rGeneralTableAspects.Moment := pGeneralTable.Moment;
                rGeneralTableAspects.Aspect := rAspects.Code;
                rGeneralTableAspects.AspectDescription := rAspects.Description;
                rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";
                rGeneralTableAspects."Evaluation Type" := rAspects."Evaluation Type";
                rGeneralTableAspects."Subject Class" := pGeneralTable."Subject Class";
                rGeneralTableAspects.StudyPlan := pRegistrationSubjects."Study Plan Code";
                rGeneralTableAspects.Insert;
                //GET ASPECTS ASSESSEMENT
                GetAspectsAssessment(rGeneralTableAspects);
                rGeneralTableAspects.Modify;
            until rAspects.Next = 0;
        end;
    end;


    procedure InsertAspectsStudent(pSubSubjects: Code[20]; pSubjects: Code[20]; pStudent: Code[20]; pAspects: Record Aspects)
    var
        rGeneralTable: Record GeneralTable;
        rGeneralTableAspects: Record GeneralTableAspects;
    begin
        if pAspects."Not to WEB" then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetCurrentKey(Company, Subject, "Sub Subject", Student, Moment, "Responsibility Center", "Entry Type");
        rGeneralTable.SetRange(Company, CompanyName);
        rGeneralTable.SetRange(Subject, pSubjects);
        if pSubSubjects = '' then
            rGeneralTable.SetRange("Sub Subject", pSubjects)
        else
            rGeneralTable.SetRange("Sub Subject", pSubSubjects);
        rGeneralTable.SetRange(Student, pStudent);
        rGeneralTable.SetRange(Moment, pAspects."Moment Code");
        rGeneralTable.SetRange("Responsibility Center", pAspects."Responsibility Center");
        rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
        if rGeneralTable.FindSet then begin
            repeat
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetCurrentKey("Study Plan Entry No.", Aspect);
                rGeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                if not rGeneralTableAspects.FindSet(true) then begin
                    Clear(rGeneralTableAspects);
                    rGeneralTableAspects.Init;
                    rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Insert;
                    rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Insert;
                    rGeneralTableAspects.Company := CompanyName;
                    rGeneralTableAspects."Study Plan Entry No." := rGeneralTable."Entry No.";
                    rGeneralTableAspects."School Year" := rGeneralTable."School Year";
                    rGeneralTableAspects.Student := rGeneralTable.Student;
                    rGeneralTableAspects.Class := rGeneralTable.Class;
                    rGeneralTableAspects.Subject := rGeneralTable.Subject;
                    rGeneralTableAspects."Sub Subject" := rGeneralTable."Sub Subject";
                    rGeneralTableAspects.Moment := rGeneralTable.Moment;
                    rGeneralTableAspects.Aspect := pAspects.Code;
                    rGeneralTableAspects.AspectDescription := pAspects.Description;
                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                    rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                    rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                    rGeneralTableAspects."Subject Class" := rGeneralTable."Subject Class";
                    rGeneralTableAspects.StudyPlan := rGeneralTable.StudyPlanCode;
                    //rGeneralTableAspects.StudyPlan              := '';
                    rGeneralTableAspects.Insert;
                    //GET ASPECTS ASSESSEMENT
                    GetAspectsAssessment(rGeneralTableAspects);
                    rGeneralTableAspects.Modify;

                end else begin
                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                      (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                    if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                      (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                        rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                    //GET ASPECTS ASSESSEMENT
                    GetAspectsAssessment(rGeneralTableAspects);
                    rGeneralTableAspects.Modify;
                end;
            until rGeneralTable.Next = 0;
        end;
    end;


    procedure DeleteAspectsStudent(pSubSubjects: Code[20]; pSubjects: Code[20]; pStudent: Code[20]; pAspects: Record Aspects)
    var
        rGeneralTable: Record GeneralTable;
        rGeneralTableAspects: Record GeneralTableAspects;
        rGeneralTableAspects2: Record GeneralTableAspects;
    begin
        if pAspects."Not to WEB" = false then
            exit;

        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetRange(Company, CompanyName);
        rGeneralTable.SetRange(Subject, pSubjects);
        if pSubSubjects = '' then
            rGeneralTable.SetRange("Sub Subject", pSubjects)
        else
            rGeneralTable.SetRange("Sub Subject", pSubSubjects);
        rGeneralTable.SetRange(Student, pStudent);
        rGeneralTable.SetRange(Moment, pAspects."Moment Code");
        rGeneralTable.SetRange("Responsibility Center", pAspects."Responsibility Center");
        rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
        if rGeneralTable.FindSet then begin
            repeat
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                if rGeneralTableAspects.FindSet(true) then begin
                    repeat
                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) and
                          (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then begin
                            rGeneralTableAspects2.Get(rGeneralTableAspects."Entry No.");
                            //rGeneralTableAspects2.DELETE;
                        end else begin
                            if rGeneralTableAspects."Update Type" <> rGeneralTableAspects."Update Type"::Insert then
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete
                            else
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::" ";
                            if rGeneralTableAspects."Update Type 2" <> rGeneralTableAspects."Update Type 2"::Insert then
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete
                            else
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::" ";

                            rGeneralTableAspects.Modify;
                        end;
                    until rGeneralTableAspects.Next = 0;
                end;
            until rGeneralTable.Next = 0;
        end;
    end;


    procedure ModDelAspects(pAspects: Record Aspects; pOldAspects: Record Aspects; "pDelete?": Boolean)
    var
        rGeneralTableAspects: Record GeneralTableAspects;
        rGeneralTableAspects2: Record GeneralTableAspects;
        rGeneralTable: Record GeneralTable;
        rAspects: Record Aspects;
        rAspects2: Record Aspects;
        rRegistrationSubjects: Record "Registration Subjects";
        rSettingRatings: Record "Setting Ratings";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin
        // "pDelete?" = True -> DELETE
        // "pDelete?" = False -> UPDATE

        if ValidateWeb = 0 then
            exit;

        //Falta valiadar se funcionalmente podemos alterar o not to web para alunos, ou se fica a nivel de plano de estudos.
        //IF (Not pOldAspects."Not to WEB") and pAspects."Not to WEB" then
        //  "pDelete?" := true;

        if pAspects."Not to WEB" = false then begin
            if pAspects.Type = pAspects.Type::Student then begin
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                rGeneralTableAspects.SetRange(Student, pAspects."Type No.");
                rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                if pAspects."Sub Subjects" <> '' then
                    rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects")
                else
                    rGeneralTableAspects.SetRange("Sub Subject", pAspects.Subjects);
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                if rGeneralTableAspects.FindSet(true) then begin
                    if "pDelete?" then begin
                        //Get the aspects value of the Class or Course or Global
                        repeat
                            GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year", pAspects."Schooling Year", pAspects."Moment Code",
                              pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                              rAspects, rGeneralTableAspects, "pDelete?");

                            rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";
                            rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                            rGeneralTableAspects.AspectDescription := rAspects.Description;

                            //GET ASPECTS ASSESSEMENT
                            //GetAspectsAssessment(rGeneralTableAspects);

                            rGeneralTable.Reset;
                            rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.");
                            if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                  (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                    rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                            end else
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;

                            if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                  (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                    rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;
                            end else
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;

                            rGeneralTableAspects.Modify;

                            //if have get sub-subjects
                            if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                            (rGeneralTable.HasSubSubject) then begin
                                rGeneralTableAspects2.Reset;
                                rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                rGeneralTableAspects2.SetRange(Subject, pAspects.Subjects);
                                rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                rGeneralTableAspects2.SetRange(Student, pAspects."Type No.");
                                if rGeneralTableAspects2.FindSet(true) then begin
                                    repeat

                                        GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                          pAspects."Schooling Year", pAspects."Moment Code",
                                          pAspects.Subjects, rGeneralTableAspects2."Sub Subject", pAspects.Code, pAspects."Responsibility Center", rAspects,
                                          rGeneralTableAspects2, "pDelete?");

                                        rGeneralTableAspects2."Percent Aspect" := rAspects."% Evaluation";
                                        rGeneralTableAspects2.AspectDescription := rAspects.Description;
                                        rGeneralTableAspects2."Assessment Code" := rAspects."Assessment Code";
                                        //GET ASPECTS ASSESSEMENT
                                        //GetAspectsAssessment(rGeneralTableAspects2);

                                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                            if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                              (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete
                                        end else
                                            rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;

                                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                            if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                              (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;
                                        end else
                                            rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;

                                        rGeneralTableAspects2.Modify;
                                    until rGeneralTableAspects2.Next = 0;
                                end;
                            end;
                        until rGeneralTableAspects.Next = 0;
                    end else begin
                        repeat
                            rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                            rGeneralTableAspects.AspectDescription := pAspects.Description;
                            rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                            //GET ASPECTS ASSESSEMENT
                            GetAspectsAssessment(rGeneralTableAspects);

                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                              (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                              (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                            //GET ASPECTS ASSESSEMENT
                            GetAspectsAssessment(rGeneralTableAspects);

                            rGeneralTableAspects.Modify;

                            //ChangeSubSubjAspects
                            //if have get sub-subjects
                            if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                              (rGeneralTable.HasSubSubject) then begin
                                rAspects.Reset;
                                rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                  "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                rAspects.SetRange(Type, rAspects.Type::Student);
                                rAspects.SetRange("School Year", pAspects."School Year");
                                rAspects.SetRange("Type No.", pAspects."Type No.");
                                rAspects.SetRange(Subjects, pAspects.Subjects);
                                rAspects.SetFilter("Sub Subjects", '<>%1', '');
                                rAspects.SetRange("Moment Code", pAspects."Moment Code");
                                rAspects.SetRange(Modified, true);
                                rAspects.SetRange(Code, pAspects.Code);
                                rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                if not rAspects.FindSet then begin
                                    rGeneralTableAspects2.Reset;
                                    rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                    //rGeneralTableAspects2.SETRANGE(StudyPlan,rRegistrationSubjects."Study Plan Code");
                                    rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                    rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                    rGeneralTableAspects2.SetRange(Subject, pAspects.Subjects);
                                    rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                    rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                    rGeneralTableAspects2.SetRange(Student, pAspects."Type No.");
                                    if rGeneralTableAspects2.FindSet(true) then begin
                                        repeat
                                            rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                            rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                            rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";

                                            //GET ASPECTS ASSESSEMENT
                                            GetAspectsAssessment(rGeneralTableAspects2);

                                            if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                            (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                            if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                            (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                            rGeneralTableAspects2.Modify;

                                        until rGeneralTableAspects2.Next = 0;
                                    end;
                                end else begin
                                    rAspects.Reset;
                                    rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                      "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    rAspects.SetRange(Type, rAspects.Type::Student);
                                    rAspects.SetRange("School Year", pAspects."School Year");
                                    rAspects.SetRange("Type No.", pAspects."Type No.");
                                    rAspects.SetRange(Subjects, pAspects.Subjects);
                                    rAspects.SetFilter("Sub Subjects", '<>%1', '');
                                    rAspects.SetRange("Moment Code", pAspects."Moment Code");
                                    rAspects.SetRange(Modified, true);
                                    rAspects.SetRange(Code, pAspects.Code);
                                    rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                    if rAspects.FindSet then begin
                                        repeat

                                            rGeneralTableAspects2.Reset;
                                            rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                            rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                            rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                            rGeneralTableAspects2.SetRange(Subject, pAspects.Subjects);
                                            rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                            rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                            rGeneralTableAspects2.SetRange(Student, pAspects."Type No.");
                                            if rGeneralTableAspects2.FindSet(true) then begin
                                                repeat
                                                    if rAspects."Sub Subjects" <> rGeneralTableAspects2."Sub Subject" then begin
                                                        rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                                        rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                                        rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";
                                                        //GET ASPECTS ASSESSEMENT
                                                        GetAspectsAssessment(rGeneralTableAspects2);

                                                        if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                        (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                            rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                                        if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                        (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                            rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                                        rGeneralTableAspects2.Modify;
                                                    end;
                                                until rGeneralTableAspects2.Next = 0;
                                            end;
                                        until rAspects.Next = 0;
                                    end;
                                end;
                            end;

                        until rGeneralTableAspects.Next = 0;
                    end;
                end;
            end;

            if pAspects.Type = pAspects.Type::Class then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center",
                "Study Plan Code", "Subjects Code");
                rRegistrationSubjects.SetRange(Class, pAspects."Type No.");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
                rRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                if rRegistrationSubjects.FindSet then begin
                    repeat
                        rAspects.Reset;
                        rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                          "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        rAspects.SetRange(Type, rAspects.Type::Student);
                        rAspects.SetRange("School Year", pAspects."School Year");
                        rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                        rAspects.SetRange(Subjects, pAspects.Subjects);
                        rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                        rAspects.SetRange(Code, pAspects.Code);
                        rAspects.SetRange("Moment Code", pAspects."Moment Code");
                        rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                        if not rAspects.FindSet then begin
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                            rGeneralTableAspects.SetRange(Class, pAspects."Type No.");
                            rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                            rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                            rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                            if pAspects."Sub Subjects" <> '' then
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects")
                            else
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects.Subjects);
                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                            rGeneralTableAspects.SetRange(Student, rRegistrationSubjects."Student Code No.");
                            if rGeneralTableAspects.FindSet(true) then begin
                                if "pDelete?" then begin
                                    //Get the aspects value of the Class or Course or Global
                                    repeat
                                        GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                          pAspects."Schooling Year", pAspects."Moment Code",
                                          pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                                          rAspects, rGeneralTableAspects, "pDelete?");

                                        rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := rAspects.Description;
                                        rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";

                                        //GET ASPECTS ASSESSEMENT
                                        //GetAspectsAssessment(rGeneralTableAspects);

                                        rGeneralTable.Reset;
                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then;
                                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                                        end else
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;

                                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;
                                        end else
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;

                                        rGeneralTableAspects.Modify;

                                        //if have get sub-subjects
                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                        (rGeneralTable.HasSubSubject) then begin
                                            rAspects2.Reset;
                                            rAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                              "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            rAspects2.SetRange(Type, rAspects.Type);
                                            rAspects2.SetRange("School Year", pAspects."School Year");
                                            rAspects2.SetRange("Type No.", rAspects."Type No.");
                                            rAspects2.SetRange(Subjects, pAspects.Subjects);
                                            rAspects2.SetFilter("Sub Subjects", '<>%1', '');
                                            rAspects2.SetRange("Moment Code", pAspects."Moment Code");
                                            rAspects2.SetRange(Modified, true);
                                            rAspects2.SetRange(Code, pAspects.Code);
                                            rAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                            if rAspects2.FindSet then begin
                                                repeat
                                                    rGeneralTableAspects2.Reset;
                                                    rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                    rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                    rGeneralTableAspects2.SetRange("School Year", rAspects."School Year");
                                                    rGeneralTableAspects2.SetRange(Moment, rAspects."Moment Code");
                                                    rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                    rGeneralTableAspects2.SetRange("Sub Subject", rAspects2."Sub Subjects");
                                                    rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                    rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                    if rGeneralTableAspects2.FindSet(true) then begin
                                                        repeat
                                                            rGeneralTableAspects2."Percent Aspect" := rAspects2."% Evaluation";
                                                            rGeneralTableAspects2.AspectDescription := rAspects2.Description;
                                                            rGeneralTableAspects2."Assessment Code" := rAspects2."Assessment Code";
                                                            //GET ASPECTS ASSESSEMENT
                                                            //GetAspectsAssessment(rGeneralTableAspects2);

                                                            rGeneralTable.Reset;
                                                            if rGeneralTable.Get(rGeneralTableAspects2."Study Plan Entry No.") then;
                                                            if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                                                if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                   (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                    rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;
                                                            end else
                                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;

                                                            if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                                                if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                   (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete)
                              then
                                                                    rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;
                                                            end else
                                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;

                                                            rGeneralTableAspects2.Modify;

                                                        until rGeneralTableAspects2.Next = 0;
                                                    end;
                                                until rAspects.Next = 0;
                                            end;
                                        end;

                                    until rGeneralTableAspects.Next = 0;
                                end else begin
                                    repeat
                                        rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := pAspects.Description;
                                        rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;

                                        //if have get sub-subjects
                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                        (rGeneralTable.HasSubSubject) then begin
                                            rAspects.Reset;
                                            rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                              "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then
                                                rAspects.SetRange(Type, rAspects.Type::Course)
                                            else
                                                rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                                            rAspects.SetRange("School Year", pAspects."School Year");
                                            rAspects.SetRange("Type No.", rRegistrationSubjects."Study Plan Code");
                                            rAspects.SetRange(Subjects, pAspects.Subjects);
                                            rAspects.SetFilter("Sub Subjects", '<>%1', '');
                                            rAspects.SetRange("Moment Code", pAspects."Moment Code");
                                            rAspects.SetRange(Modified, true);
                                            rAspects.SetRange(Code, pAspects.Code);
                                            rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                            if rAspects.Find('-') then begin
                                                repeat
                                                    rGeneralTableAspects2.Reset;
                                                    rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                    rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                    rGeneralTableAspects2.SetRange("School Year", rAspects."School Year");
                                                    rGeneralTableAspects2.SetRange(Moment, rAspects."Moment Code");
                                                    rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                    rGeneralTableAspects2.SetRange("Sub Subject", rAspects."Sub Subjects");
                                                    rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                    rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                    if rGeneralTableAspects2.Find('-') then begin
                                                        repeat
                                                            rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                                            rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                                            rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";
                                                            //GET ASPECTS ASSESSEMENT
                                                            GetAspectsAssessment(rGeneralTableAspects2);

                                                            if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                            (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                                            if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                            (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                                            rGeneralTableAspects2.Modify;

                                                        until rGeneralTableAspects2.Next = 0;
                                                    end;
                                                until rAspects.Next = 0;
                                            end;
                                        end;

                                    until rGeneralTableAspects.Next = 0;
                                end;
                            end;
                        end else begin
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                            rGeneralTableAspects.SetRange(Class, pAspects."Type No.");
                            rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                            rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                            rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                            if pAspects."Sub Subjects" <> '' then
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects")
                            else
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects.Subjects);
                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                            rGeneralTableAspects.SetRange(Student, rRegistrationSubjects."Student Code No.");
                            if rGeneralTableAspects.Find('-') then begin
                                if "pDelete?" then begin
                                    //Get the aspects value of the Class or Course or Global
                                    repeat
                                        GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                          pAspects."Schooling Year", pAspects."Moment Code",
                                          pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                                          rAspects, rGeneralTableAspects, "pDelete?");

                                        rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := rAspects.Description;
                                        rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";
                                        //GET ASPECTS ASSESSEMENT
                                        //GetAspectsAssessment(rGeneralTableAspects);

                                        rGeneralTable.Reset;
                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then;
                                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                                        end else
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;

                                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;
                                        end else
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;

                                        rGeneralTableAspects.Modify;

                                        //if have get sub-subjects
                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                        (rGeneralTable.HasSubSubject) then begin
                                            rAspects2.Reset;
                                            rAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                              "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            rAspects2.SetRange(Type, rAspects.Type);
                                            rAspects2.SetRange("School Year", pAspects."School Year");
                                            rAspects2.SetRange("Type No.", rAspects."Type No.");
                                            rAspects2.SetRange(Subjects, pAspects.Subjects);
                                            rAspects2.SetFilter("Sub Subjects", '<>%1', '');
                                            rAspects2.SetRange("Moment Code", pAspects."Moment Code");
                                            rAspects2.SetRange(Modified, true);
                                            rAspects2.SetRange(Code, pAspects.Code);
                                            rAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                            if rAspects2.Find('-') then begin
                                                repeat
                                                    rGeneralTableAspects2.Reset;
                                                    rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                    rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                    rGeneralTableAspects2.SetRange("School Year", rAspects."School Year");
                                                    rGeneralTableAspects2.SetRange(Moment, rAspects."Moment Code");
                                                    rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                    rGeneralTableAspects2.SetRange("Sub Subject", rAspects2."Sub Subjects");
                                                    rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                    rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                    if rGeneralTableAspects2.Find('-') then begin
                                                        repeat
                                                            rGeneralTableAspects2."Percent Aspect" := rAspects2."% Evaluation";
                                                            rGeneralTableAspects2.AspectDescription := rAspects2.Description;
                                                            rGeneralTableAspects2."Assessment Code" := rAspects2."Assessment Code";
                                                            //GET ASPECTS ASSESSEMENT
                                                            //GetAspectsAssessment(rGeneralTableAspects2);

                                                            rGeneralTable.Reset;
                                                            if rGeneralTable.Get(rGeneralTableAspects2."Study Plan Entry No.") then;
                                                            if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                                                if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                   (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                    rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;
                                                            end else
                                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;

                                                            if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                                                if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                   (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                                    rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;
                                                            end else
                                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;

                                                            rGeneralTableAspects2.Modify;

                                                        until rGeneralTableAspects2.Next = 0;
                                                    end;
                                                until rAspects.Next = 0;
                                            end;
                                        end;

                                    until rGeneralTableAspects.Next = 0;
                                end;
                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end;
            end;

            if (pAspects.Type = pAspects.Type::"Study Plan") or (pAspects.Type = pAspects.Type::Course) then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center",
                "Study Plan Code", "Subjects Code");
                rRegistrationSubjects.SetRange("Study Plan Code", pAspects."Type No.");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
                if pAspects.Type = pAspects.Type::"Study Plan" then
                    rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Simple)
                else
                    rRegistrationSubjects.SetRange(Type, rRegistrationSubjects.Type::Multi);
                rRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        //if the student does not have aspects go to the next level
                        rAspects.Reset;
                        rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                          "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        rAspects.SetRange(Type, rAspects.Type::Student);
                        rAspects.SetRange("School Year", pAspects."School Year");
                        rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                        rAspects.SetRange(Subjects, pAspects.Subjects);
                        rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                        rAspects.SetRange("Moment Code", pAspects."Moment Code");
                        rAspects.SetRange(Modified, true);
                        rAspects.SetRange(Code, pAspects.Code);
                        rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                        if not rAspects.Find('-') then begin
                            //if the class does not have aspects change or delete aspects
                            rAspects.Reset;
                            rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                              "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            rAspects.SetRange(Type, rAspects.Type::Class);
                            rAspects.SetRange("School Year", pAspects."School Year");
                            rAspects.SetRange("Type No.", rRegistrationSubjects.Class);
                            rAspects.SetRange(Subjects, pAspects.Subjects);
                            rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                            rAspects.SetRange("Moment Code", pAspects."Moment Code");
                            rAspects.SetRange(Modified, true);
                            rAspects.SetRange(Code, pAspects.Code);
                            rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                            if not rAspects.Find('-') then begin

                                rGeneralTableAspects.Reset;
                                rGeneralTableAspects.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                rGeneralTableAspects.SetRange(StudyPlan, pAspects."Type No.");
                                rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                                rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                                rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                                if pAspects."Sub Subjects" <> '' then
                                    rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects")
                                else
                                    rGeneralTableAspects.SetRange("Sub Subject", pAspects.Subjects);
                                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                                rGeneralTableAspects.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                if rGeneralTableAspects.Find('-') then begin
                                    if "pDelete?" then begin
                                        //Get the aspects value of the Class or Course or Global
                                        repeat
                                            GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                              pAspects."Schooling Year", pAspects."Moment Code",
                                              pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                                              rAspects, rGeneralTableAspects, "pDelete?");

                                            rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                                            rGeneralTableAspects.AspectDescription := rAspects.Description;
                                            rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";
                                            //GET ASPECTS ASSESSEMENT
                                            //GetAspectsAssessment(rGeneralTableAspects);

                                            rGeneralTable.Reset;
                                            if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then;
                                            if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                                if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                                   (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                    rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                                            end else
                                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;

                                            if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                                if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                                   (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                    rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;
                                            end else
                                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;

                                            rGeneralTableAspects.Modify;

                                            //if have get sub-subjects
                                            if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                            (rGeneralTable.HasSubSubject) then begin
                                                rGeneralTableAspects2.Reset;
                                                rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                                rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                                rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                                rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                if rGeneralTableAspects2.Find('-') then begin
                                                    repeat
                                                        GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                                          pAspects."Schooling Year", pAspects."Moment Code",
                                                          pAspects.Subjects, rGeneralTableAspects2."Sub Subject", pAspects.Code, pAspects."Responsibility Center",
                                                          rAspects, rGeneralTableAspects2, "pDelete?");

                                                        rGeneralTableAspects2."Percent Aspect" := rAspects."% Evaluation";
                                                        rGeneralTableAspects2.AspectDescription := rAspects.Description;
                                                        rGeneralTableAspects2."Assessment Code" := rAspects."Assessment Code";
                                                        //GET ASPECTS ASSESSEMENT
                                                        //GetAspectsAssessment(rGeneralTableAspects2);

                                                        rGeneralTable.Reset;
                                                        if rGeneralTable.Get(rGeneralTableAspects2."Study Plan Entry No.") then;
                                                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                                            if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                               (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;
                                                        end else
                                                            rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;

                                                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                                            if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                               (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                                rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;
                                                        end else
                                                            rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;

                                                        rGeneralTableAspects2.Modify;

                                                    until rGeneralTableAspects2.Next = 0;
                                                end;
                                            end;

                                        until rGeneralTableAspects.Next = 0;
                                    end else begin
                                        repeat
                                            rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                            rGeneralTableAspects.AspectDescription := pAspects.Description;
                                            rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                            //GET ASPECTS ASSESSEMENT
                                            GetAspectsAssessment(rGeneralTableAspects);

                                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                            rGeneralTableAspects.Modify;

                                            //if have get sub-subjects
                                            if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                            (rGeneralTable.HasSubSubject) then begin
                                                rAspects.Reset;
                                                rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                                  "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then
                                                    rAspects.SetRange(Type, rAspects.Type::Course)
                                                else
                                                    rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                                                rAspects.SetRange("School Year", pAspects."School Year");
                                                rAspects.SetRange("Type No.", rRegistrationSubjects."Study Plan Code");
                                                rAspects.SetRange(Subjects, pAspects.Subjects);
                                                rAspects.SetFilter("Sub Subjects", '<>%1', '');
                                                rAspects.SetRange("Moment Code", pAspects."Moment Code");
                                                rAspects.SetRange(Modified, true);
                                                rAspects.SetRange(Code, pAspects.Code);
                                                rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                                if not rAspects.Find('-') then begin
                                                    repeat
                                                        rGeneralTableAspects2.Reset;
                                                        rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                        rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                        rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                                        rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                                        rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                        rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                                        rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                        rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                        if rGeneralTableAspects2.Find('-') then begin
                                                            repeat
                                                                rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                                                rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                                                rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";
                                                                //GET ASPECTS ASSESSEMENT
                                                                GetAspectsAssessment(rGeneralTableAspects2);

                                                                if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                    rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                                                if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                                    rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                                                rGeneralTableAspects2.Modify;

                                                            until rGeneralTableAspects2.Next = 0;
                                                        end;
                                                    until rAspects.Next = 0;
                                                end else begin
                                                    repeat
                                                        rGeneralTableAspects2.Reset;
                                                        rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                        //rGeneralTableAspects2.SETRANGE(StudyPlan,rRegistrationSubjects."Study Plan Code");
                                                        rGeneralTableAspects2.SetRange("School Year", pAspects."School Year");
                                                        rGeneralTableAspects2.SetRange(Moment, pAspects."Moment Code");
                                                        rGeneralTableAspects2.SetRange(Subject, pAspects.Subjects);
                                                        rGeneralTableAspects2.SetFilter("Sub Subject", '<>%1', '');
                                                        rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                        rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                        if rGeneralTableAspects2.Find('-') then begin
                                                            repeat
                                                                if rAspects."Sub Subjects" <> rGeneralTableAspects2."Sub Subject" then begin
                                                                    rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                                                    rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                                                    rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";
                                                                    //GET ASPECTS ASSESSEMENT
                                                                    GetAspectsAssessment(rGeneralTableAspects2);

                                                                    if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                    (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                        rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                                                    if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                    (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete) then
                                                                        rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                                                    rGeneralTableAspects2.Modify;
                                                                end;
                                                            until rGeneralTableAspects2.Next = 0;
                                                        end;
                                                    until rAspects.Next = 0;
                                                end;
                                            end;
                                        until rGeneralTableAspects.Next = 0;
                                    end;
                                end else begin

                                    //asdasd
                                end;
                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end;
            end;

            if pAspects.Type = pAspects.Type::Overall then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center",
                "Study Plan Code", "Subjects Code");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        //Find the setting ratings for the subject
                        rSettingRatings.Reset;
                        rSettingRatings.SetRange("School Year", rRegistrationSubjects."School Year");
                        rSettingRatings.SetRange("Schooling Year", rRegistrationSubjects."Schooling Year");
                        rSettingRatings.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                        rSettingRatings.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                        rSettingRatings.SetRange(Type, rSettingRatingsSubSubjects.Type::Header);
                        rSettingRatings.SetRange("Type Education", rRegistrationSubjects.Type);
                        rSettingRatings.SetRange("Responsibility Center", pAspects."Responsibility Center");
                        rSettingRatings.SetRange("Line No.", rRegistrationSubjects."Original Line No.");
                        if rSettingRatings.FindSet then
                            repeat
                                //if the student does not have aspects go to the next level
                                rAspects.Reset;
                                rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                  "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                rAspects.SetRange(Type, rAspects.Type::Student);
                                rAspects.SetRange("School Year", rSettingRatings."School Year");
                                rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                                rAspects.SetRange(Subjects, rRegistrationSubjects."Subjects Code");
                                rAspects.SetRange("Sub Subjects", '');
                                rAspects.SetRange("Moment Code", rSettingRatings."Moment Code");
                                rAspects.SetRange(Modified, true);
                                rAspects.SetRange(Code, pAspects.Code);
                                rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                if not rAspects.Find('-') then begin

                                    //if the class does not have aspects go to the next level
                                    rAspects.Reset;
                                    rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                      "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    rAspects.SetRange(Type, rAspects.Type::Class);
                                    rAspects.SetRange("School Year", rSettingRatings."School Year");
                                    rAspects.SetRange("Type No.", rRegistrationSubjects.Class);
                                    rAspects.SetRange(Subjects, rRegistrationSubjects."Subjects Code");
                                    rAspects.SetRange("Sub Subjects", '');
                                    rAspects.SetRange("Moment Code", rSettingRatings."Moment Code");
                                    rAspects.SetRange(Modified, true);
                                    rAspects.SetRange(Code, pAspects.Code);
                                    rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                    if not rAspects.Find('-') then begin

                                        //if the Course/Study plan does not have aspects change or delete aspects
                                        rAspects.Reset;
                                        rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year",
                                          "Responsibility Center", Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                        if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then
                                            rAspects.SetRange(Type, rAspects.Type::Course)
                                        else
                                            rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                                        rAspects.SetRange("School Year", rSettingRatings."School Year");
                                        rAspects.SetRange("Type No.", rRegistrationSubjects."Study Plan Code");
                                        rAspects.SetRange(Subjects, rRegistrationSubjects."Subjects Code");
                                        rAspects.SetRange("Sub Subjects", '');
                                        rAspects.SetRange("Moment Code", rSettingRatings."Moment Code");
                                        rAspects.SetRange(Modified, true);
                                        rAspects.SetRange(Code, pAspects.Code);
                                        rAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                        if not rAspects.Find('-') then begin

                                            rGeneralTableAspects.Reset;
                                            rGeneralTableAspects.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                            rGeneralTableAspects.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                            rGeneralTableAspects.SetRange("School Year", rSettingRatings."School Year");
                                            rGeneralTableAspects.SetRange(Moment, rSettingRatings."Moment Code");
                                            rGeneralTableAspects.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                            rGeneralTableAspects.SetRange("Sub Subject", rRegistrationSubjects."Subjects Code");
                                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                                            rGeneralTableAspects.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                            if rGeneralTableAspects.Find('-') then begin
                                                if "pDelete?" then begin
                                                    //Get the aspects value of the Class or Course or Global
                                                    repeat
                                                        GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                                                          pAspects."Schooling Year", pAspects."Moment Code",
                                                          pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                                                          rAspects, rGeneralTableAspects, "pDelete?");

                                                        rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                                                        rGeneralTableAspects.AspectDescription := rAspects.Description;
                                                        rGeneralTableAspects."Assessment Code" := rAspects."Assessment Code";
                                                        //GET ASPECTS ASSESSEMENT
                                                        //GetAspectsAssessment(rGeneralTableAspects);

                                                        rGeneralTable.Reset;
                                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") then;
                                                        if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Delete then begin
                                                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;
                                                        end else
                                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Delete;

                                                        if rGeneralTable."Update Type 2" <> rGeneralTable."Update Type 2"::Delete then begin
                                                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;
                                                        end else
                                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Delete;

                                                        rGeneralTableAspects.Modify;

                                                    until rGeneralTableAspects.Next = 0;
                                                end else begin
                                                    repeat
                                                        rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                                        rGeneralTableAspects.AspectDescription := pAspects.Description;
                                                        rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                                        //GET ASPECTS ASSESSEMENT
                                                        GetAspectsAssessment(rGeneralTableAspects);

                                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                                           (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                                        rGeneralTableAspects.Modify;

                                                        //if have get sub-subjects
                                                        if rGeneralTable.Get(rGeneralTableAspects."Study Plan Entry No.") and
                                                        (rGeneralTable.HasSubSubject) then begin
                                                            rSettingRatingsSubSubjects.Reset;
                                                            rSettingRatingsSubSubjects.SetRange("Moment Code", rSettingRatings."Moment Code");
                                                            rSettingRatingsSubSubjects.SetRange("School Year", rRegistrationSubjects."School Year");
                                                            rSettingRatingsSubSubjects.SetRange("Schooling Year", rRegistrationSubjects."Schooling Year");
                                                            rSettingRatingsSubSubjects.SetRange("Study Plan Code", rRegistrationSubjects."Study Plan Code");
                                                            rSettingRatingsSubSubjects.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                                                            rSettingRatingsSubSubjects.SetRange(Type, rSettingRatingsSubSubjects.Type::Header);
                                                            rSettingRatingsSubSubjects.SetRange("Type Education", rRegistrationSubjects.Type);
                                                            rSettingRatingsSubSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                                            if rSettingRatingsSubSubjects.FindSet then
                                                                repeat
                                                                    rGeneralTableAspects2.Reset;
                                                                    rGeneralTableAspects2.SetCurrentKey(Student, "School Year", Moment, Subject, "Sub Subject");
                                                                    rGeneralTableAspects2.SetRange(StudyPlan, rRegistrationSubjects."Study Plan Code");
                                                                    rGeneralTableAspects2.SetRange("School Year", rSettingRatings."School Year");
                                                                    rGeneralTableAspects2.SetRange(Moment, rSettingRatings."Moment Code");
                                                                    rGeneralTableAspects2.SetRange(Subject, rRegistrationSubjects."Subjects Code");
                                                                    rGeneralTableAspects2.SetRange("Sub Subject", rSettingRatingsSubSubjects."Sub-Subject Code");
                                                                    rGeneralTableAspects2.SetRange(Aspect, pAspects.Code);
                                                                    rGeneralTableAspects2.SetRange(Student, rRegistrationSubjects."Student Code No.");
                                                                    if rGeneralTableAspects2.Find('-') then begin
                                                                        if "pDelete?" then begin
                                                                            //Get the aspects value of the Class or Course or Global
                                                                            repeat
                                                                                GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year", pAspects."Schooling Year"
                                           ,
                                                                                  pAspects."Moment Code", pAspects.Subjects, pAspects."Sub Subjects",
                                                                                  pAspects.Code, pAspects."Responsibility Center", rAspects, rGeneralTableAspects2, "pDelete?");

                                                                                rGeneralTableAspects2."Percent Aspect" := rAspects."% Evaluation";
                                                                                rGeneralTableAspects2.AspectDescription := rAspects.Description;
                                                                                rGeneralTableAspects2."Assessment Code" := rAspects."Assessment Code";
                                                                                //GET ASPECTS ASSESSEMENT
                                                                                //GetAspectsAssessment(rGeneralTableAspects2);

                                                                                if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                                (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                                    rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Delete;

                                                                                if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                                (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete)
                                           then
                                                                                    rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Delete;

                                                                                rGeneralTableAspects2.Modify;

                                                                            until rGeneralTableAspects2.Next = 0;
                                                                        end else begin
                                                                            repeat
                                                                                rGeneralTableAspects2."Percent Aspect" := pAspects."% Evaluation";
                                                                                rGeneralTableAspects2.AspectDescription := pAspects.Description;
                                                                                rGeneralTableAspects2."Assessment Code" := pAspects."Assessment Code";
                                                                                //GET ASPECTS ASSESSEMENT
                                                                                GetAspectsAssessment(rGeneralTableAspects2);

                                                                                if (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::" ") or
                                                                                (rGeneralTableAspects2."Update Type" = rGeneralTableAspects2."Update Type"::Delete) then
                                                                                    rGeneralTableAspects2."Update Type" := rGeneralTableAspects2."Update Type"::Update;

                                                                                if (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::" ") or
                                                                                (rGeneralTableAspects2."Update Type 2" = rGeneralTableAspects2."Update Type 2"::Delete)
                                           then
                                                                                    rGeneralTableAspects2."Update Type 2" := rGeneralTableAspects2."Update Type 2"::Update;

                                                                                rGeneralTableAspects2.Modify;

                                                                            until rGeneralTableAspects2.Next = 0;
                                                                        end;
                                                                    end;
                                                                until rSettingRatingsSubSubjects.Next = 0;
                                                        end;
                                                    until rGeneralTableAspects.Next = 0;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            until rSettingRatings.Next = 0;
                    until rRegistrationSubjects.Next = 0;
                end;
            end;
        end;
    end;


    procedure ValidateWeb(): Integer
    begin
        //if rCompanyInformation.Get then
        //exit(rCompanyInformation."Connection Type")
    end;


    procedure AnunulGTStudent(pRegistrationSubjects: Record "Registration Subjects")
    var
        rGeneralTable: Record GeneralTable;
        l_GeneralTable2: Record GeneralTable;
        l_GeneralTableAspects: Record GeneralTableAspects;
    begin
        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetRange("School Year", pRegistrationSubjects."School Year");
        rGeneralTable.SetRange(Student, pRegistrationSubjects."Student Code No.");
        rGeneralTable.SetRange(Class, pRegistrationSubjects.Class);
        rGeneralTable.SetRange(Subject, pRegistrationSubjects."Subjects Code");
        rGeneralTable.SetRange(Company, CompanyName);
        rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
        if rGeneralTable.Find('-') then begin
            repeat
                if rGeneralTable."Update Type" <> rGeneralTable."Update Type"::Insert then begin
                    //rGeneralTable."Active Moment" := FALSE;
                    rGeneralTable."Update Type" := rGeneralTable."Update Type"::Delete;
                    //rGeneralTable."Update Type" := rGeneralTable."Update Type"::Update;
                    rGeneralTable.Modify(true);
                    l_GeneralTableAspects.Reset;
                    l_GeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                    if l_GeneralTableAspects.FindSet then begin
                        l_GeneralTableAspects.ModifyAll("Update Type", l_GeneralTableAspects."Update Type"::Delete);
                        //l_GeneralTableAspects.MODIFYALL("Update Type",l_GeneralTableAspects."Update Type"::Update);
                    end;
                end;
                if rGeneralTable."Update Type" = rGeneralTable."Update Type"::Insert then begin
                    if l_GeneralTable2.Get(rGeneralTable."Entry No.") then begin
                        l_GeneralTableAspects.Reset;
                        l_GeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                        if l_GeneralTableAspects.Find('-') then
                            l_GeneralTableAspects.DeleteAll;
                        l_GeneralTable2.Delete;
                    end;
                end;
            until rGeneralTable.Next = 0;
        end;
    end;


    procedure GetAspects(pType: Integer; pTypeNo: Code[20]; pSchoolYear: Code[10]; pSchoolingYear: Code[10]; pMomentCode: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pAspectCode: Code[20]; pRCenter: Code[20]; var pAspects: Record Aspects; pGeneralTableAspects: Record GeneralTableAspects; pDelete: Boolean) NextLevel: Boolean
    var
        RegistrationClass: Record "Registration Class";
    begin
        //pType options
        //1 = Overall
        //2 = Course
        //3 = Class
        //4 = Study Plan
        //5 = Student

        //Filter the aspects for the level of ptype
        case pType of
            5:
                begin
                    //find the aspect of the Student
                    pAspects.Reset;
                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                    pAspects.SetRange(Type, 5);
                    pAspects.SetRange("School Year", pSchoolYear);
                    pAspects.SetRange("Schooling Year", pSchoolingYear);
                    pAspects.SetRange("Type No.", pTypeNo);
                    pAspects.SetRange(Subjects, pSubjects);
                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                    pAspects.SetRange("Moment Code", pMomentCode);
                    if pAspectCode <> '' then
                        pAspects.SetRange(Code, pAspectCode);
                    pAspects.SetRange("Responsibility Center", pRCenter);
                    if not pAspects.Find('-') or pDelete then begin

                        //If Subsubject try find aspects of the Subject
                        if pSubSubjects <> '' then begin
                            pAspects.Reset;
                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            pAspects.SetRange(Type, 5);
                            pAspects.SetRange("School Year", pSchoolYear);
                            pAspects.SetRange("Schooling Year", pSchoolingYear);
                            pAspects.SetRange("Type No.", pTypeNo);
                            pAspects.SetRange(Subjects, pSubjects);
                            pAspects.SetRange("Sub Subjects", '');
                            pAspects.SetRange("Moment Code", pMomentCode);
                            if pAspectCode <> '' then
                                pAspects.SetRange(Code, pAspectCode);
                            pAspects.SetRange("Responsibility Center", pRCenter);
                            if not pAspects.Find('-') or pDelete then begin

                                //find the subject aspect of the class
                                RegistrationClass.Reset;
                                RegistrationClass.SetRange("School Year", pSchoolYear);
                                RegistrationClass.SetRange("Student Code No.", pTypeNo);
                                RegistrationClass.SetRange(Class, pGeneralTableAspects.Class);
                                if RegistrationClass.FindSet then begin
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    pAspects.SetRange(Type, 3);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Schooling Year", pSchoolingYear);
                                    pAspects.SetRange("Type No.", RegistrationClass.Class);
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    pAspects.SetRange("Responsibility Center", pRCenter);
                                    if not pAspects.Find('-') then begin
                                        //
                                        //If Subsubject try find aspects of Subject
                                        if pSubSubjects <> '' then begin
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            pAspects.SetRange(Type, 3);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Schooling Year", pSchoolingYear);
                                            pAspects.SetRange("Type No.", RegistrationClass.Class);
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            pAspects.SetRange("Responsibility Center", pRCenter);
                                            if not pAspects.Find('-') then begin

                                                //find the aspect of the Course/Study plan
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                    pAspects.SetRange(Type, 4)
                                                else
                                                    pAspects.SetRange(Type, 2);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Schooling Year", pSchoolingYear);
                                                pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                                pAspects.SetRange(Subjects, pSubjects);
                                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                                pAspects.SetRange("Moment Code", pMomentCode);
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                pAspects.SetRange("Responsibility Center", pRCenter);
                                                if not pAspects.Find('-') then begin

                                                    //If Subsubject try find aspects of Subject
                                                    if pSubSubjects <> '' then begin
                                                        pAspects.Reset;
                                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                        if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                            pAspects.SetRange(Type, 4)
                                                        else
                                                            pAspects.SetRange(Type, 2);
                                                        pAspects.SetRange("School Year", pSchoolYear);
                                                        pAspects.SetRange("Schooling Year", pSchoolingYear);
                                                        pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                                        pAspects.SetRange(Subjects, pSubjects);
                                                        pAspects.SetRange("Sub Subjects", '');
                                                        pAspects.SetRange("Moment Code", pMomentCode);
                                                        if pAspectCode <> '' then
                                                            pAspects.SetRange(Code, pAspectCode);
                                                        pAspects.SetRange("Responsibility Center", pRCenter);
                                                        if not pAspects.Find('-') then begin

                                                            //Find Global aspect
                                                            pAspects.Reset;
                                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                            pAspects.SetRange(Type, 1);
                                                            pAspects.SetRange("School Year", pSchoolYear);
                                                            pAspects.SetRange("Type No.", '');
                                                            pAspects.SetRange(Subjects, '');
                                                            pAspects.SetRange("Sub Subjects", '');
                                                            pAspects.SetRange("Moment Code", '');
                                                            if pAspectCode <> '' then
                                                                pAspects.SetRange(Code, pAspectCode);
                                                            pAspects.SetRange("Responsibility Center", pRCenter);
                                                            if not pAspects.Find('-') then begin
                                                            end;
                                                        end;
                                                    end else begin
                                                        //Find Global aspect
                                                        pAspects.Reset;
                                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                        pAspects.SetRange(Type, 1);
                                                        pAspects.SetRange("School Year", pSchoolYear);
                                                        pAspects.SetRange("Type No.", '');
                                                        pAspects.SetRange(Subjects, '');
                                                        pAspects.SetRange("Sub Subjects", '');
                                                        pAspects.SetRange("Moment Code", '');
                                                        if pAspectCode <> '' then
                                                            pAspects.SetRange(Code, pAspectCode);
                                                        pAspects.SetRange("Responsibility Center", pRCenter);
                                                        if not pAspects.Find('-') then begin
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end else begin
                                            //find the aspect of the Course/Study plan
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                pAspects.SetRange(Type, 4)
                                            else
                                                pAspects.SetRange(Type, 2);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Schooling Year", pSchoolingYear);
                                            pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", pSubSubjects);
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            pAspects.SetRange("Responsibility Center", pRCenter);
                                            if not pAspects.Find('-') then begin
                                                //Find Global aspect
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                pAspects.SetRange(Type, 1);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Type No.", '');
                                                pAspects.SetRange(Subjects, '');
                                                pAspects.SetRange("Sub Subjects", '');
                                                pAspects.SetRange("Moment Code", '');
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                pAspects.SetRange("Responsibility Center", pRCenter);
                                                if not pAspects.Find('-') then begin
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end else begin
                            //find the subject aspect of the class
                            RegistrationClass.Reset;
                            RegistrationClass.SetRange("School Year", pSchoolYear);
                            RegistrationClass.SetRange("Student Code No.", pTypeNo);
                            RegistrationClass.SetRange(Class, pGeneralTableAspects.Class);
                            if RegistrationClass.FindSet then begin
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                pAspects.SetRange(Type, 3);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Schooling Year", pSchoolingYear);
                                pAspects.SetRange("Type No.", RegistrationClass.Class);
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                pAspects.SetRange("Moment Code", pMomentCode);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                pAspects.SetRange("Responsibility Center", pRCenter);
                                if not pAspects.Find('-') then begin
                                    //find the aspect of the Course/Study plan
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                        pAspects.SetRange(Type, 4)
                                    else
                                        pAspects.SetRange(Type, 2);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Schooling Year", pSchoolingYear);
                                    pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    pAspects.SetRange("Responsibility Center", pRCenter);
                                    if not pAspects.Find('-') then begin
                                        //Find Global aspect
                                        pAspects.Reset;
                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                        pAspects.SetRange(Type, 1);
                                        pAspects.SetRange("School Year", pSchoolYear);
                                        pAspects.SetRange("Type No.", '');
                                        pAspects.SetRange(Subjects, '');
                                        pAspects.SetRange("Sub Subjects", '');
                                        pAspects.SetRange("Moment Code", '');
                                        if pAspectCode <> '' then
                                            pAspects.SetRange(Code, pAspectCode);
                                        pAspects.SetRange("Responsibility Center", pRCenter);
                                        if not pAspects.Find('-') then begin
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            3:
                begin
                    //find the subject aspect of the class
                    RegistrationClass.Reset;
                    RegistrationClass.SetRange("School Year", pSchoolYear);
                    RegistrationClass.SetRange("Student Code No.", pGeneralTableAspects.Student);
                    RegistrationClass.SetRange(Class, pGeneralTableAspects.Class);
                    if RegistrationClass.FindSet then begin
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        pAspects.SetRange(Type, 3);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Schooling Year", pSchoolingYear);
                        pAspects.SetRange("Type No.", RegistrationClass.Class);
                        pAspects.SetRange(Subjects, pSubjects);
                        pAspects.SetRange("Sub Subjects", pSubSubjects);
                        pAspects.SetRange("Moment Code", pMomentCode);
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        pAspects.SetRange("Responsibility Center", pRCenter);
                        if not pAspects.Find('-') or pDelete then begin
                            //
                            //If Subsubject try find aspects of Subject
                            if pSubSubjects <> '' then begin
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                pAspects.SetRange(Type, 3);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Schooling Year", pSchoolingYear);
                                pAspects.SetRange("Type No.", RegistrationClass.Class);
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", '');
                                pAspects.SetRange("Moment Code", pMomentCode);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                pAspects.SetRange("Responsibility Center", pRCenter);
                                if not pAspects.Find('-') then begin

                                    //find the aspect of the Course/Study plan
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                        pAspects.SetRange(Type, 4)
                                    else
                                        pAspects.SetRange(Type, 2);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Schooling Year", pSchoolingYear);
                                    pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    pAspects.SetRange("Responsibility Center", pRCenter);
                                    if not pAspects.Find('-') then begin

                                        //If Subsubject try find aspects of Subject
                                        if pSubSubjects <> '' then begin
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                pAspects.SetRange(Type, 4)
                                            else
                                                pAspects.SetRange(Type, 2);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Schooling Year", pSchoolingYear);
                                            pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            pAspects.SetRange("Responsibility Center", pRCenter);
                                            if not pAspects.Find('-') then begin

                                                //Find Global aspect
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                pAspects.SetRange(Type, 1);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Type No.", '');
                                                pAspects.SetRange(Subjects, '');
                                                pAspects.SetRange("Sub Subjects", '');
                                                pAspects.SetRange("Moment Code", '');
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                pAspects.SetRange("Responsibility Center", pRCenter);
                                                if not pAspects.Find('-') then begin
                                                end;
                                            end;
                                        end else begin
                                            //Find Global aspect
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            pAspects.SetRange(Type, 1);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Type No.", '');
                                            pAspects.SetRange(Subjects, '');
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", '');
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            pAspects.SetRange("Responsibility Center", pRCenter);
                                            if not pAspects.Find('-') then begin
                                            end;
                                        end;
                                    end;
                                end;
                            end else begin
                                //find the aspect of the Course/Study plan
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                    pAspects.SetRange(Type, 4)
                                else
                                    pAspects.SetRange(Type, 2);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Schooling Year", pSchoolingYear);
                                pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                pAspects.SetRange("Moment Code", pMomentCode);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                pAspects.SetRange("Responsibility Center", pRCenter);
                                if not pAspects.Find('-') then begin
                                    //Find Global aspect
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    pAspects.SetRange(Type, 1);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Type No.", '');
                                    pAspects.SetRange(Subjects, '');
                                    pAspects.SetRange("Sub Subjects", '');
                                    pAspects.SetRange("Moment Code", '');
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    pAspects.SetRange("Responsibility Center", pRCenter);
                                    if not pAspects.Find('-') then begin
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            4, 2:
                begin
                    //If Subsubject try find aspects of Subject

                    if pSubSubjects <> '' then begin
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        if RegistrationClass.Type = RegistrationClass.Type::Simple then
                            pAspects.SetRange(Type, 4)
                        else
                            pAspects.SetRange(Type, 2);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Schooling Year", pSchoolingYear);
                        pAspects.SetRange("Type No.", pTypeNo);
                        pAspects.SetRange(Subjects, pSubjects);
                        pAspects.SetRange("Sub Subjects", '');
                        pAspects.SetRange("Moment Code", pMomentCode);
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        pAspects.SetRange("Responsibility Center", pRCenter);
                        if not pAspects.Find('-') or pDelete then begin

                            //Find Global aspect
                            pAspects.Reset;
                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            pAspects.SetRange(Type, 1);
                            pAspects.SetRange("School Year", pSchoolYear);
                            pAspects.SetRange("Type No.", '');
                            pAspects.SetRange(Subjects, '');
                            pAspects.SetRange("Sub Subjects", '');
                            pAspects.SetRange("Moment Code", '');
                            if pAspectCode <> '' then
                                pAspects.SetRange(Code, pAspectCode);
                            pAspects.SetRange("Responsibility Center", pRCenter);
                            if not pAspects.Find('-') then begin
                            end;
                        end;
                    end else begin
                        //Find Global aspect
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        pAspects.SetRange(Type, 1);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Type No.", '');
                        pAspects.SetRange(Subjects, '');
                        pAspects.SetRange("Sub Subjects", '');
                        pAspects.SetRange("Moment Code", '');
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        pAspects.SetRange("Responsibility Center", pRCenter);
                        if not pAspects.Find('-') then begin
                        end;
                    end;
                end;
        end;
    end;


    procedure DelAspects(pAspects: Record Aspects; pOldAspects: Record Aspects; "pDelete?": Boolean)
    var
        rGeneralTableAspects: Record GeneralTableAspects;
        rAspects: Record Aspects;
        rAspects2: Record Aspects;
        rRegistrationSubjects: Record "Registration Subjects";
        GoNextLevel: Boolean;
    begin
        // "pDelete?" = True -> DELETE
        // "pDelete?" = False -> UPDATE

        if ValidateWeb = 0 then
            exit;

        GoNextLevel := true;

        if pAspects."Not to WEB" = false then begin
            if pAspects.Type = pAspects.Type::Student then begin
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetRange(Student, pAspects."Type No.");
                rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                if pAspects."Sub Subjects" <> '' then
                    rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                if rGeneralTableAspects.Find('-') then begin
                    //IF Delete the student subjects must find the last level and update the lines whith the %
                    if "pDelete?" then begin
                        //Get the aspects value of the Class or Course or Global
                        repeat
                            GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                              pAspects."Schooling Year", pAspects."Moment Code",
                              pAspects.Subjects, pAspects."Sub Subjects", pAspects.Code, pAspects."Responsibility Center",
                              rAspects2, rGeneralTableAspects, "pDelete?");
                            rGeneralTableAspects."Percent Aspect" := rAspects2."% Evaluation";
                            rGeneralTableAspects.AspectDescription := rAspects2.Description;
                            //GET ASPECTS ASSESSEMENT
                            GetAspectsAssessment(rGeneralTableAspects);

                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                            rGeneralTableAspects.Modify;
                        until rGeneralTableAspects.Next = 0;
                    end else begin
                        repeat
                            rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                            rGeneralTableAspects.AspectDescription := pAspects.Description;
                            //GET ASPECTS ASSESSEMENT
                            GetAspectsAssessment(rGeneralTableAspects);

                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                              (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                              (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                            rGeneralTableAspects.Modify;
                        until rGeneralTableAspects.Next = 0;
                    end;
                end;
            end;

            if pAspects.Type = pAspects.Type::Class then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange(Class, pAspects."Type No.");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        rAspects.Reset;
                        rAspects.SetRange(Type, rAspects.Type::Student);
                        rAspects.SetRange("School Year", pAspects."School Year");
                        rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                        rAspects.SetRange(Subjects, pAspects.Subjects);
                        rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                        if not rAspects.Find('-') then begin
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetRange(Class, pAspects."Type No.");
                            rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                            rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                            rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                            if pAspects."Sub Subjects" <> '' then
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                            rGeneralTableAspects.SetRange("Percent Aspect", pOldAspects."% Evaluation");
                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                            if rGeneralTableAspects.Find('-') then begin
                                if "pDelete?" then begin
                                    //Get the aspects value of the Class or Course or Global
                                    repeat
                                        GetAspects(rAspects.Type, rAspects."Type No.", rAspects."School Year",
                                          pAspects."Schooling Year", rAspects."Moment Code",
                                          rAspects.Subjects, rAspects."Sub Subjects", rAspects.Code, pAspects."Responsibility Center",
                                          rAspects2, rGeneralTableAspects, "pDelete?");

                                        rGeneralTableAspects."Percent Aspect" := rAspects2."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := rAspects2.Description;
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;

                                    until rGeneralTableAspects.Next = 0;

                                end else begin
                                    repeat
                                        rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := pAspects.Description;
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;
                                    until rGeneralTableAspects.Next = 0;
                                end;
                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end;
            end;
            if pAspects.Type = pAspects.Type::"Study Plan" then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Study Plan Code", pAspects."Type No.");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        rAspects.Reset;
                        rAspects.SetRange(Type, rAspects.Type::Student);
                        rAspects.SetRange("School Year", pAspects."School Year");
                        rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                        rAspects.SetRange(Subjects, pAspects.Subjects);
                        rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                        if not rAspects.Find('-') then begin
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetRange(StudyPlan, pAspects."Type No.");
                            rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                            rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                            rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                            if pAspects."Sub Subjects" <> '' then
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                            rGeneralTableAspects.SetRange("Percent Aspect", pOldAspects."% Evaluation");
                            if rGeneralTableAspects.Find('-') then begin
                                if "pDelete?" then begin
                                    //Get the aspects value of the Class or Course or Global
                                    repeat

                                        GetAspects(rAspects.Type, rAspects."Type No.", rAspects."School Year",
                                          pAspects."Schooling Year", rAspects."Moment Code",
                                          rAspects.Subjects, rAspects."Sub Subjects", rAspects.Code, pAspects."Responsibility Center",
                                          rAspects2, rGeneralTableAspects, "pDelete?");

                                        rGeneralTableAspects."Percent Aspect" := rAspects2."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := rAspects2.Description;
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;

                                    until rGeneralTableAspects.Next = 0;


                                end else begin
                                    repeat
                                        rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := pAspects.Description;
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;
                                    until rGeneralTableAspects.Next = 0;
                                end;
                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end else begin
                    rGeneralTableAspects.Reset;
                    rGeneralTableAspects.SetRange(StudyPlan, pAspects."Type No.");
                    rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                    rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                    rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                    if pAspects."Sub Subjects" <> '' then
                        rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                    rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                    rGeneralTableAspects.SetRange("Percent Aspect", pOldAspects."% Evaluation");
                    if rGeneralTableAspects.Find('-') then begin
                        if "pDelete?" then begin
                            rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                            rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                        end else begin
                            repeat
                                rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                                rGeneralTableAspects.AspectDescription := pAspects.Description;
                                //GET ASPECTS ASSESSEMENT
                                GetAspectsAssessment(rGeneralTableAspects);

                                if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                   (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                    rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type"::" ") or
                                   (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                    rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                rGeneralTableAspects.Modify;
                            until rGeneralTableAspects.Next = 0;
                        end;
                    end;
                end;
            end;
            if pAspects.Type = pAspects.Type::Course then begin
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Study Plan Code", pAspects."Type No.");
                rRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        rAspects.Reset;
                        rAspects.SetRange(Type, rAspects.Type::Student);
                        rAspects.SetRange("School Year", pAspects."School Year");
                        rAspects.SetRange("Type No.", rRegistrationSubjects."Student Code No.");
                        rAspects.SetRange(Subjects, pAspects.Subjects);
                        if pAspects."Sub Subjects" <> '' then
                            rAspects.SetRange("Sub Subjects", pAspects."Sub Subjects");
                        if not rAspects.Find('-') then begin
                            rGeneralTableAspects.Reset;
                            rGeneralTableAspects.SetRange(StudyPlan, pAspects."Type No.");
                            rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                            rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                            rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                            if pAspects."Sub Subjects" <> '' then
                                rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                            rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                            rGeneralTableAspects.SetRange("Percent Aspect", pOldAspects."% Evaluation");
                            if rGeneralTableAspects.Find('-') then begin
                                if "pDelete?" then begin
                                    rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                                    rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete)
                                end else begin
                                    repeat
                                        rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                        rGeneralTableAspects.AspectDescription := pAspects.Description;
                                        //GET ASPECTS ASSESSEMENT
                                        GetAspectsAssessment(rGeneralTableAspects);

                                        if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                           (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                            rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                        if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                           (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                            rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                        rGeneralTableAspects.Modify;
                                    until rGeneralTableAspects.Next = 0;
                                end;
                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end else begin
                    rGeneralTableAspects.Reset;
                    rGeneralTableAspects.SetRange(StudyPlan, pAspects."Type No.");
                    rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                    rGeneralTableAspects.SetRange(Moment, pAspects."Moment Code");
                    rGeneralTableAspects.SetRange(Subject, pAspects.Subjects);
                    if pAspects."Sub Subjects" <> '' then
                        rGeneralTableAspects.SetRange("Sub Subject", pAspects."Sub Subjects");
                    rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                    if rGeneralTableAspects.Find('-') then begin
                        if "pDelete?" then begin
                            rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                            rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                        end else begin
                            repeat
                                rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                                rGeneralTableAspects.AspectDescription := pAspects.Description;
                                //GET ASPECTS ASSESSEMENT
                                GetAspectsAssessment(rGeneralTableAspects);

                                if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                   (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                    rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                   (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                    rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                rGeneralTableAspects.Modify;
                            until rGeneralTableAspects.Next = 0;
                        end;
                    end;
                end;
            end;
            if pAspects.Type = pAspects.Type::Overall then begin
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                rGeneralTableAspects.SetRange("School Year", pAspects."School Year");
                rGeneralTableAspects.SetRange("Percent Aspect", pOldAspects."% Evaluation");
                if rGeneralTableAspects.Find('-') then begin
                    if "pDelete?" then begin
                        rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                        rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                    end else begin
                        repeat
                            rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                            rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                            rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                            rGeneralTableAspects.AspectDescription := pAspects.Description;
                            //GET ASPECTS ASSESSEMENT
                            GetAspectsAssessment(rGeneralTableAspects);

                            if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                               (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                            if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                               (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                            rGeneralTableAspects.Modify;
                        until rGeneralTableAspects.Next = 0;
                    end;
                end;
                rAspects.Reset;
                rAspects.SetRange("School Year", pAspects."School Year");
                rAspects.SetRange(Code, pAspects.Code);
                rAspects.SetRange("Not to WEB", false);
                if rAspects.Find('-') then begin
                    if rAspects.Type = rAspects.Type::Course then begin
                        rGeneralTableAspects.Reset;
                        rGeneralTableAspects.SetRange(StudyPlan, rAspects."Type No.");
                        rGeneralTableAspects.SetRange("School Year", rAspects."School Year");
                        rGeneralTableAspects.SetRange(Moment, rAspects."Moment Code");
                        rGeneralTableAspects.SetRange(Subject, rAspects.Subjects);
                        rGeneralTableAspects.SetRange("Sub Subject", rAspects."Sub Subjects");
                        rGeneralTableAspects.SetRange(Aspect, rAspects.Code);
                        if rGeneralTableAspects.Find('-') then begin
                            if "pDelete?" then begin
                                rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                                rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                            end else begin
                                repeat
                                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                    rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                    rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                                    rGeneralTableAspects.AspectDescription := pAspects.Description;
                                    //GET ASPECTS ASSESSEMENT
                                    GetAspectsAssessment(rGeneralTableAspects);

                                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                       (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                    if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                       (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                        rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                    rGeneralTableAspects.Modify;
                                until rGeneralTableAspects.Next = 0;
                            end;
                        end;

                    end;
                    if rAspects.Type = rAspects.Type::"Study Plan" then begin
                        rGeneralTableAspects.Reset;
                        rGeneralTableAspects.SetRange(StudyPlan, rAspects."Type No.");
                        rGeneralTableAspects.SetRange("School Year", rAspects."School Year");
                        rGeneralTableAspects.SetRange(Moment, rAspects."Moment Code");
                        rGeneralTableAspects.SetRange(Subject, rAspects.Subjects);
                        rGeneralTableAspects.SetRange("Sub Subject", rAspects."Sub Subjects");
                        rGeneralTableAspects.SetRange(Aspect, rAspects.Code);
                        if rGeneralTableAspects.Find('-') then begin
                            if "pDelete?" then begin
                                rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                                rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete)
                            end else begin
                                repeat
                                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                    rGeneralTableAspects."Assessment Code" := pAspects."Assessment Code";
                                    rGeneralTableAspects."Evaluation Type" := pAspects."Evaluation Type";
                                    rGeneralTableAspects.AspectDescription := pAspects.Description;
                                    //GET ASPECTS ASSESSEMENT
                                    GetAspectsAssessment(rGeneralTableAspects);

                                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                       (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                    if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                       (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                        rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                    rGeneralTableAspects.Modify;
                                until rGeneralTableAspects.Next = 0;
                            end;
                        end;
                    end;
                    if rAspects.Type = rAspects.Type::Class then begin
                        rGeneralTableAspects.Reset;
                        rGeneralTableAspects.SetRange(Class, rAspects."Type No.");
                        rGeneralTableAspects.SetRange("School Year", rAspects."School Year");
                        rGeneralTableAspects.SetRange(Moment, rAspects."Moment Code");
                        rGeneralTableAspects.SetRange(Subject, rAspects.Subjects);
                        rGeneralTableAspects.SetRange("Sub Subject", rAspects."Sub Subjects");
                        rGeneralTableAspects.SetRange(Aspect, rAspects.Code);
                        if rGeneralTableAspects.Find('-') then begin
                            if "pDelete?" then begin
                                rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                                rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete);
                            end else begin
                                repeat
                                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                    rGeneralTableAspects.AspectDescription := pAspects.Description;
                                    //GET ASPECTS ASSESSEMENT
                                    GetAspectsAssessment(rGeneralTableAspects);

                                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                       (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                                    if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                                       (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                                        rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                                    rGeneralTableAspects.Modify;
                                until rGeneralTableAspects.Next = 0;
                            end;
                        end;
                    end;
                    if rAspects.Type = rAspects.Type::Student then begin
                        rGeneralTableAspects.Reset;
                        rGeneralTableAspects.SetRange(Student, rAspects."Type No.");
                        rGeneralTableAspects.SetRange("School Year", rAspects."School Year");
                        rGeneralTableAspects.SetRange(Moment, rAspects."Moment Code");
                        rGeneralTableAspects.SetRange(Subject, rAspects.Subjects);
                        rGeneralTableAspects.SetRange("Sub Subject", rAspects."Sub Subjects");
                        rGeneralTableAspects.SetRange(Aspect, rAspects.Code);
                        if rGeneralTableAspects.Find('-') then begin
                            if "pDelete?" then begin
                                rGeneralTableAspects.ModifyAll("Update Type", rGeneralTableAspects."Update Type"::Delete);
                                rGeneralTableAspects.ModifyAll("Update Type 2", rGeneralTableAspects."Update Type 2"::Delete)
                            end else begin
                                repeat
                                    rGeneralTableAspects."Percent Aspect" := pAspects."% Evaluation";
                                    rGeneralTableAspects.AspectDescription := pAspects.Description;
                                    //GET ASPECTS ASSESSEMENT
                                    GetAspectsAssessment(rGeneralTableAspects);

                                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                                       (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;
                                    rGeneralTableAspects.Modify;
                                until rGeneralTableAspects.Next = 0;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;


    procedure GetAssessment(var l_GeneralTable: Record GeneralTable)
    var
        l_AssessingStudents: Record "Assessing Students";
    begin
        l_AssessingStudents.Reset;
        l_AssessingStudents.SetRange("School Year", l_GeneralTable."School Year");
        l_AssessingStudents.SetRange(Subject, l_GeneralTable.Subject);
        if l_GeneralTable.Subject = l_GeneralTable."Sub Subject" then
            l_AssessingStudents.SetFilter("Sub-Subject Code", '')
        else
            l_AssessingStudents.SetRange("Sub-Subject Code", l_GeneralTable."Sub Subject");
        l_AssessingStudents.SetRange("Student Code No.", l_GeneralTable.Student);
        l_AssessingStudents.SetRange("Moment Code", l_GeneralTable.Moment);
        if l_AssessingStudents.FindSet then begin
            if l_GeneralTable.EvaluationType = l_GeneralTable.EvaluationType::Qualitative then begin
                l_GeneralTable.GradeManual := Format(l_AssessingStudents."Qualitative Grade");
                if l_AssessingStudents."Qualitative Grade Calc" <> '' then
                    l_GeneralTable."Qualitative Eval." := Format(l_AssessingStudents."Qualitative Grade Calc")
                else
                    l_GeneralTable."Qualitative Eval." := l_GeneralTable.GradeManual;

                //IF l_AssessingStudents."Recuperation Qualitative Grade" <> '' THEN BEGIN
                //  l_GeneralTable."Qualitative Eval." := FORMAT(l_AssessingStudents."Recuperation Qualitative Grade");
                //  l_GeneralTable."Qualitative Eval." := FORMAT(l_AssessingStudents."Recuperation Qualitative Grade")
                //END;
                if l_AssessingStudents."Recuperation Qualitative Grade" <> '' then
                    l_GeneralTable."Recuperation Qualitative Grade" := Format(l_AssessingStudents."Recuperation Qualitative Grade");

            end else begin
                l_GeneralTable.GradeManual := Format(l_AssessingStudents.Grade);
                if l_AssessingStudents."Grade Calc" <> 0 then
                    l_GeneralTable.GradeAuto := Format(l_AssessingStudents."Grade Calc")
                else
                    l_GeneralTable.GradeAuto := Format(l_AssessingStudents.Grade);

                //IF l_AssessingStudents."Recuperation Grade" <> 0 THEN BEGIN
                //  l_GeneralTable.GradeManual := FORMAT(l_AssessingStudents."Recuperation Grade");
                //  l_GeneralTable.GradeAuto := FORMAT(l_AssessingStudents."Recuperation Grade");
                //END;
                if l_AssessingStudents."Recuperation Grade" <> 0 then
                    l_GeneralTable."Recuperation Grade" := l_AssessingStudents."Recuperation Grade";


                l_GeneralTable."Has Individual Plan" := l_AssessingStudents."Has Individual Plan";
                l_GeneralTable."Scholarship Reinforcement" := l_AssessingStudents."Scholarship Reinforcement";
                l_GeneralTable."Scholarship Support" := l_AssessingStudents."Scholarship Support";
            end;
        end;
    end;


    procedure UpdateAssessment(p_AssessingStudents: Record "Assessing Students")
    var
        l_GeneralTable: Record GeneralTable;
    begin
        if ValidateWeb = 0 then
            exit;

        l_GeneralTable.Reset;
        l_GeneralTable.SetRange("School Year", p_AssessingStudents."School Year");
        l_GeneralTable.SetRange(Class, p_AssessingStudents.Class);
        l_GeneralTable.SetRange(Student, p_AssessingStudents."Student Code No.");
        l_GeneralTable.SetRange(Subject, p_AssessingStudents.Subject);
        if p_AssessingStudents."Sub-Subject Code" = '' then
            l_GeneralTable.SetRange("Sub Subject", p_AssessingStudents.Subject)
        else
            l_GeneralTable.SetRange("Sub Subject", p_AssessingStudents."Sub-Subject Code");
        l_GeneralTable.SetRange(Moment, p_AssessingStudents."Moment Code");
        if l_GeneralTable.Find('-') then begin

            l_GeneralTable."Has Individual Plan" := p_AssessingStudents."Has Individual Plan";
            l_GeneralTable."Scholarship Reinforcement" := p_AssessingStudents."Scholarship Reinforcement";
            l_GeneralTable."Scholarship Support" := p_AssessingStudents."Scholarship Support";

            if l_GeneralTable.EvaluationType = l_GeneralTable.EvaluationType::Qualitative then begin
                l_GeneralTable.GradeManual := Format(p_AssessingStudents."Qualitative Grade");
                if p_AssessingStudents."Qualitative Grade Calc" <> '' then
                    l_GeneralTable."Qualitative Eval." := Format(p_AssessingStudents."Qualitative Grade Calc")
                else
                    l_GeneralTable."Qualitative Eval." := l_GeneralTable.GradeManual;

                if p_AssessingStudents."Recuperation Qualitative Grade" <> '' then
                    l_GeneralTable."Recuperation Qualitative Grade" := Format(p_AssessingStudents."Recuperation Qualitative Grade");

            end else begin
                if p_AssessingStudents.Grade <> 0 then
                    l_GeneralTable.GradeManual := Format(p_AssessingStudents.Grade)
                else
                    l_GeneralTable.GradeManual := '';

                if p_AssessingStudents."Grade Calc" <> 0 then
                    l_GeneralTable.GradeAuto := Format(p_AssessingStudents."Grade Calc")
                else
                    l_GeneralTable.GradeAuto := Format(p_AssessingStudents.Grade);

                if p_AssessingStudents."Recuperation Grade" <> 0 then
                    l_GeneralTable."Recuperation Grade" := p_AssessingStudents."Recuperation Grade";
            end;

            if (l_GeneralTable."Update Type" = l_GeneralTable."Update Type"::" ") or
               (l_GeneralTable."Update Type" = l_GeneralTable."Update Type"::Delete) then
                l_GeneralTable."Update Type" := l_GeneralTable."Update Type"::Update;

            if (l_GeneralTable."Update Type 2" = l_GeneralTable."Update Type 2"::" ") or
               (l_GeneralTable."Update Type 2" = l_GeneralTable."Update Type 2"::Delete) then
                l_GeneralTable."Update Type 2" := l_GeneralTable."Update Type 2"::Update;

            l_GeneralTable.Modify;
        end;
    end;


    procedure DeleteAssessment(p_AssessingStudents: Record "Assessing Students")
    var
        l_GeneralTable: Record GeneralTable;
    begin
        if ValidateWeb = 0 then
            exit;

        l_GeneralTable.Reset;
        l_GeneralTable.SetRange("School Year", p_AssessingStudents."School Year");
        l_GeneralTable.SetRange(Student, p_AssessingStudents."Student Code No.");
        l_GeneralTable.SetRange(Subject, p_AssessingStudents.Subject);
        if p_AssessingStudents."Sub-Subject Code" = '' then
            l_GeneralTable.SetRange("Sub Subject", p_AssessingStudents.Subject)
        else
            l_GeneralTable.SetRange("Sub Subject", p_AssessingStudents."Sub-Subject Code");
        l_GeneralTable.SetRange(Moment, p_AssessingStudents."Moment Code");
        if l_GeneralTable.Find('-') then begin
            l_GeneralTable.GradeManual := '';
            l_GeneralTable.GradeAuto := '';

            if (l_GeneralTable."Update Type" = l_GeneralTable."Update Type"::" ") or
               (l_GeneralTable."Update Type" = l_GeneralTable."Update Type"::Delete) then
                l_GeneralTable."Update Type" := l_GeneralTable."Update Type"::Update;

            if (l_GeneralTable."Update Type 2" = l_GeneralTable."Update Type 2"::" ") or
               (l_GeneralTable."Update Type 2" = l_GeneralTable."Update Type 2"::Delete) then
                l_GeneralTable."Update Type 2" := l_GeneralTable."Update Type 2"::Update;

            l_GeneralTable.Modify;
        end;
    end;


    procedure DelSubjetsSettingRatings(p_SettingRatings: Record "Setting Ratings")
    var
        l_GeneralTable: Record GeneralTable;
        l_Class: Record Class;
    begin
        if p_SettingRatings.Type = p_SettingRatings.Type::Lines then
            exit;

        if ValidateWeb = 0 then
            exit;

        l_Class.Reset;
        l_Class.SetRange("Study Plan Code", p_SettingRatings."Study Plan Code");
        l_Class.SetRange(Type, p_SettingRatings."Type Education");
        l_Class.SetRange("School Year", p_SettingRatings."School Year");
        l_Class.SetRange("Schooling Year", p_SettingRatings."Schooling Year");
        if l_Class.FindSet then
            repeat
                l_GeneralTable.Reset;
                l_GeneralTable.SetRange(Subject, p_SettingRatings."Subject Code");
                l_GeneralTable.SetRange("Sub Subject", p_SettingRatings."Subject Code");
                l_GeneralTable.SetRange(Moment, p_SettingRatings."Moment Code");
                l_GeneralTable.SetRange(Class, l_Class.Class);
                if l_GeneralTable.Find('-') then begin
                    l_GeneralTable.ModifyAll("Update Type", l_GeneralTable."Update Type"::Delete, true);
                    l_GeneralTable.ModifyAll("Update Type 2", l_GeneralTable."Update Type 2"::Delete, true);
                end;
            until l_Class.Next = 0;
    end;


    procedure DelSubSubjetsSettingRatings(p_SettingRatingsSS: Record "Setting Ratings Sub-Subjects")
    var
        l_GeneralTable: Record GeneralTable;
        l_Class: Record Class;
    begin
        if p_SettingRatingsSS.Type = p_SettingRatingsSS.Type::Lines then
            exit;

        if ValidateWeb = 0 then
            exit;

        l_Class.Reset;
        l_Class.SetRange("Study Plan Code", p_SettingRatingsSS."Study Plan Code");
        l_Class.SetRange(Type, p_SettingRatingsSS."Type Education");
        l_Class.SetRange("School Year", p_SettingRatingsSS."School Year");
        l_Class.SetRange("Schooling Year", p_SettingRatingsSS."Schooling Year");
        if l_Class.FindSet then
            repeat
                l_GeneralTable.Reset;
                l_GeneralTable.SetRange(Subject, p_SettingRatingsSS."Subject Code");
                l_GeneralTable.SetRange("Sub Subject", p_SettingRatingsSS."Sub-Subject Code");
                l_GeneralTable.SetRange(Moment, p_SettingRatingsSS."Moment Code");
                l_GeneralTable.SetRange(Class, l_Class.Class);
                if l_GeneralTable.Find('-') then begin
                    l_GeneralTable.ModifyAll("Update Type", l_GeneralTable."Update Type"::Delete, true);
                    l_GeneralTable.ModifyAll("Update Type 2", l_GeneralTable."Update Type 2"::Delete, true);
                end;
            until l_Class.Next = 0;
    end;


    procedure InsertSettingRatings(p_SettingRatings: Record "Setting Ratings")
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rClass: Record Class;
        rMomentsAssessment: Record "Moments Assessment";
        rGeneralTable: Record GeneralTable;
        rTeacherClass: Record "Teacher Class";
        rUsersFamilyStudents: Record "Users Family / Students";
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
        InsertLine: Boolean;
        rEduConfig: Record "Edu. Configuration";
    begin
        rCompanyInformation.Get;

        if p_SettingRatings.Type = p_SettingRatings.Type::Lines then
            exit;

        if ValidateWeb = 0 then
            exit;

        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
        rStructureEducationCountry.SetRange("Schooling Year", p_SettingRatings."Schooling Year");
        if rStructureEducationCountry.FindFirst then;

        rClass.Reset;
        rClass.SetRange("School Year", p_SettingRatings."School Year");
        rClass.SetRange("Schooling Year", p_SettingRatings."Schooling Year");
        rClass.SetRange("Responsibility Center", p_SettingRatings."Responsibility Center");
        rClass.SetRange("Study Plan Code", p_SettingRatings."Study Plan Code");
        if rClass.FindSet then begin
            repeat
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("School Year", rClass."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", rClass."Schooling Year");
                rRegistrationSubjects.SetRange(Class, rClass.Class);
                rRegistrationSubjects.SetRange("Responsibility Center", rClass."Responsibility Center");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", p_SettingRatings."Subject Code");
                if p_SettingRatings."Type Education" = p_SettingRatings."Type Education"::Multi then
                    rRegistrationSubjects.SetRange("Original Line No.", p_SettingRatings."Line No.");
                if rRegistrationSubjects.FindSet then begin
                    repeat
                        Clear(rTeacherClass);
                        rTeacherClass.Reset;
                        rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
                        rTeacherClass.SetRange("School Year", rRegistrationSubjects."School Year");
                        rTeacherClass.SetRange(Class, rRegistrationSubjects.Class);
                        rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
                        rTeacherClass.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                        rTeacherClass.SetRange("Sub-Subject Code", '');
                        rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
                        if rTeacherClass.Find('-') then;

                        Clear(rUsersFamilyStudents);
                        rUsersFamilyStudents.Reset;
                        rUsersFamilyStudents.SetRange("School Year", rRegistrationSubjects."School Year");
                        rUsersFamilyStudents.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                        rUsersFamilyStudents.SetRange("Education Head", true);
                        if rUsersFamilyStudents.Find('-') then;

                        InsertLine := true;

                        if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                            rCourseLines.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                            rCourseLines.SetRange("Line No.", rRegistrationSubjects."Original Line No.");
                            if rCourseLines.Find('-') then begin
                                if rCourseLines."Evaluation Type" = rCourseLines."Evaluation Type"::"None Qualification" then
                                    InsertLine := false;
                            end else
                                InsertLine := false;
                        end;
                        if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Simple then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                            rStudyPlanLines.SetRange("School Year", rRegistrationSubjects."School Year");
                            rStudyPlanLines.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                            if rStudyPlanLines.Find('-') then begin
                                if rStudyPlanLines."Evaluation Type" = rStudyPlanLines."Evaluation Type"::"None Qualification" then
                                    InsertLine := false;
                            end else
                                InsertLine := false;
                        end;

                        if InsertLine then begin
                            Clear(rGeneralTable);
                            rGeneralTable.Init;
                            rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::" ";
                            rGeneralTable."Interface Type WEB" := rStructureEducationCountry."Interface Type WEB";
                            rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
                            rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
                            rGeneralTable.Company := CompanyName;
                            rGeneralTable."School Year" := rRegistrationSubjects."School Year";
                            rGeneralTable.Student := rRegistrationSubjects."Student Code No.";
                            rGeneralTable.Class := rRegistrationSubjects.Class;
                            rGeneralTable.Subject := rRegistrationSubjects."Subjects Code";
                            rGeneralTable.SubjectDescription := rRegistrationSubjects.Description;
                            rGeneralTable."Sub Subject" := rGeneralTable.Subject;
                            rGeneralTable.SubSubjectDescription := rRegistrationSubjects.Description;
                            rGeneralTable."Option Group" := rRegistrationSubjects."Option Group";
                            rGeneralTable.Moment := p_SettingRatings."Moment Code";
                            rGeneralTable."Type Education" := p_SettingRatings."Type Education";
                            rGeneralTable.StudyPlanCode := p_SettingRatings."Study Plan Code";
                            rGeneralTable.Turn := rRegistrationSubjects.Turn;
                            if rMomentsAssessment.Get(p_SettingRatings."Moment Code", p_SettingRatings."School Year",
                                                      p_SettingRatings."Schooling Year", p_SettingRatings."Responsibility Center") then begin
                                rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                            end;
                            rGeneralTable.Teacher := rTeacherClass.User;
                            rGeneralTable."Education Header" := rUsersFamilyStudents."No.";
                            rGeneralTable."Class Director" := rClass."Class Director No.";
                            rGeneralTable.ClassDescription := rClass.Description;
                            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then begin
                                rGeneralTable."Observations Group" := rCourseLines.Observations;
                                rGeneralTable."Assement Code" := rCourseLines."Assessment Code";
                                rGeneralTable.EvaluationType := rCourseLines."Evaluation Type";
                                rCourseLines.CalcFields("Sub-Subject");
                                rGeneralTable.HasSubSubject := rCourseLines."Sub-Subject";
                                rGeneralTable."Large Description SS" := rCourseLines."Report Descripton";
                            end else begin
                                rGeneralTable."Observations Group" := rStudyPlanLines.Observations;
                                rGeneralTable."Assement Code" := rStudyPlanLines."Assessment Code";
                                rGeneralTable.EvaluationType := rStudyPlanLines."Evaluation Type";
                                rStudyPlanLines.CalcFields("Sub-Subject");
                                rGeneralTable.HasSubSubject := rStudyPlanLines."Sub-Subject";
                                rGeneralTable."Large Description SS" := rStudyPlanLines."Report Descripton";
                            end;
                            rGeneralTable."Subject Ponder" := p_SettingRatings."Moment Ponder";
                            rGeneralTable."Subject Class" := rRegistrationSubjects.Description + ' ' + rClass.Description;
                            rGeneralTable."Responsibility Center" := rRegistrationSubjects."Responsibility Center";
                            rGeneralTable.SchoolingYear := rRegistrationSubjects."Schooling Year";
                            rGeneralTable."Original Line No." := rRegistrationSubjects."Original Line No.";

                            rEduConfig.Get;
                            rGeneralTable.Insert(true);
                            //Get assessemts
                            GetAssessment(rGeneralTable);
                            rGeneralTable.Modify;

                            //Aspects - Bloqueado dia 09-03-2009
                            InsertAspects(rRegistrationSubjects, rGeneralTable, '');
                            //SUB SUBJECTS

                            rRegistrationSubjects.CalcFields("Sub-subject");
                            if rRegistrationSubjects."Sub-subject" then
                                InsertGenTableSubSubjetc(rRegistrationSubjects, p_SettingRatings."Moment Code");
                        end;
                    until rRegistrationSubjects.Next = 0;
                end;
            until rClass.Next = 0;
        end;
    end;


    procedure InsertSettingRatingsSS(p_SettingRatingsSS: Record "Setting Ratings Sub-Subjects")
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        rClass: Record Class;
        rMomentsAssessment: Record "Moments Assessment";
        rGeneralTable: Record GeneralTable;
        rTeacherClass: Record "Teacher Class";
        rUsersFamilyStudents: Record "Users Family / Students";
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
        InsertLine: Boolean;
        rEduConfig: Record "Edu. Configuration";
    begin
        rCompanyInformation.Get;

        if p_SettingRatingsSS.Type = p_SettingRatingsSS.Type::Lines then
            exit;

        if ValidateWeb = 0 then
            exit;

        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
        rStructureEducationCountry.SetRange("Schooling Year", p_SettingRatingsSS."Schooling Year");
        if rStructureEducationCountry.Find('-') then;

        rClass.Reset;
        rClass.SetRange("School Year", p_SettingRatingsSS."School Year");
        rClass.SetRange("Schooling Year", p_SettingRatingsSS."Schooling Year");
        rClass.SetRange("Responsibility Center", p_SettingRatingsSS."Responsibility Center");
        rClass.SetRange("Study Plan Code", p_SettingRatingsSS."Study Plan Code");
        if rClass.Find('-') then begin
            repeat
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("School Year", rClass."School Year");
                rRegistrationSubjects.SetRange("Schooling Year", rClass."Schooling Year");
                rRegistrationSubjects.SetRange(Class, rClass.Class);
                rRegistrationSubjects.SetRange("Responsibility Center", rClass."Responsibility Center");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                rRegistrationSubjects.SetRange("Subjects Code", p_SettingRatingsSS."Subject Code");
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        rStudentSubSubjectsPlan.Reset;
                        rStudentSubSubjectsPlan.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                        rStudentSubSubjectsPlan.SetRange("School Year", rRegistrationSubjects."School Year");
                        rStudentSubSubjectsPlan.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                        rStudentSubSubjectsPlan.SetRange("Sub-Subject Code", p_SettingRatingsSS."Sub-Subject Code");
                        rStudentSubSubjectsPlan.SetRange(Code, p_SettingRatingsSS."Study Plan Code");
                        rStudentSubSubjectsPlan.SetRange(Type, p_SettingRatingsSS."Type Education");
                        rStudentSubSubjectsPlan.SetRange("Schooling Year", p_SettingRatingsSS."Schooling Year");
                        if rStudentSubSubjectsPlan.FindSet then begin
                            Clear(rTeacherClass);
                            rTeacherClass.Reset;
                            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
                            rTeacherClass.SetRange("School Year", rRegistrationSubjects."School Year");
                            rTeacherClass.SetRange(Class, rRegistrationSubjects.Class);
                            rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
                            rTeacherClass.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                            rTeacherClass.SetRange(rTeacherClass."Sub-Subject Code", p_SettingRatingsSS."Sub-Subject Code");
                            rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
                            if rTeacherClass.Find('-') then;

                            Clear(rUsersFamilyStudents);
                            rUsersFamilyStudents.Reset;
                            rUsersFamilyStudents.SetRange("School Year", rRegistrationSubjects."School Year");
                            rUsersFamilyStudents.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                            rUsersFamilyStudents.SetRange("Education Head", true);
                            if rUsersFamilyStudents.Find('-') then;

                            InsertLine := true;

                            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                                rCourseLines.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                                if rCourseLines.Find('-') then begin
                                    if rCourseLines."Evaluation Type" = rCourseLines."Evaluation Type"::"None Qualification" then
                                        InsertLine := false;
                                end else
                                    InsertLine := false;
                            end;
                            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Simple then begin
                                rStudyPlanLines.Reset;
                                rStudyPlanLines.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                                rStudyPlanLines.SetRange("School Year", rRegistrationSubjects."School Year");
                                rStudyPlanLines.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                                if rStudyPlanLines.Find('-') then begin
                                    if rStudyPlanLines."Evaluation Type" = rStudyPlanLines."Evaluation Type"::"None Qualification" then
                                        InsertLine := false;
                                end else
                                    InsertLine := false;
                            end;

                            if InsertLine then begin
                                Clear(rGeneralTable);
                                rGeneralTable.Init;
                                rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::" ";
                                rGeneralTable."Interface Type WEB" := rStructureEducationCountry."Interface Type WEB";
                                rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
                                rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
                                rGeneralTable.Company := CompanyName;
                                rGeneralTable."School Year" := rRegistrationSubjects."School Year";
                                rGeneralTable.Student := rRegistrationSubjects."Student Code No.";
                                rGeneralTable.Class := rRegistrationSubjects.Class;
                                rGeneralTable.Subject := rRegistrationSubjects."Subjects Code";
                                rGeneralTable.SubjectDescription := rRegistrationSubjects.Description;
                                rGeneralTable."Sub Subject" := p_SettingRatingsSS."Sub-Subject Code";
                                rGeneralTable.SubSubjectDescription := p_SettingRatingsSS."Sub-Subject Description";
                                rGeneralTable.Moment := p_SettingRatingsSS."Moment Code";
                                rGeneralTable."Type Education" := p_SettingRatingsSS."Type Education";
                                rGeneralTable.StudyPlanCode := p_SettingRatingsSS."Study Plan Code";
                                rGeneralTable.Turn := rStudentSubSubjectsPlan.Turn;
                                if rMomentsAssessment.Get(p_SettingRatingsSS."Moment Code", p_SettingRatingsSS."School Year",
                                                          p_SettingRatingsSS."Schooling Year", p_SettingRatingsSS."Responsibility Center") then begin
                                    rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                                end;
                                rGeneralTable.Teacher := rTeacherClass.User;
                                rGeneralTable."Education Header" := rUsersFamilyStudents."No.";
                                rGeneralTable."Class Director" := rClass."Class Director No.";
                                rGeneralTable.ClassDescription := rClass.Description;
                                if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then begin
                                    rGeneralTable."Observations Group" := rStudentSubSubjectsPlan.Observations;
                                    rGeneralTable."Assement Code" := rCourseLines."Assessment Code";
                                    rGeneralTable."Option Group" := rCourseLines."Option Group";
                                    rGeneralTable.EvaluationType := rCourseLines."Evaluation Type";
                                    rCourseLines.CalcFields("Sub-Subject");
                                    rGeneralTable."Large Description SS" := rCourseLines."Report Descripton";

                                end else begin
                                    rGeneralTable."Observations Group" := rStudentSubSubjectsPlan.Observations;
                                    rGeneralTable."Assement Code" := rStudyPlanLines."Assessment Code";
                                    rGeneralTable."Option Group" := rStudyPlanLines."Option Group";
                                    rGeneralTable.EvaluationType := rStudyPlanLines."Evaluation Type";
                                    rStudyPlanLines.CalcFields("Sub-Subject");
                                    rGeneralTable."Large Description SS" := rStudyPlanLines."Report Descripton";
                                end;
                                rGeneralTable."Subject Ponder" := p_SettingRatingsSS."Moment Ponder";
                                rGeneralTable."Subject Class" := rRegistrationSubjects.Description + ' ' + rClass.Description;
                                rGeneralTable."Responsibility Center" := rRegistrationSubjects."Responsibility Center";
                                rGeneralTable."Is SubSubject" := true;
                                rGeneralTable.SchoolingYear := rRegistrationSubjects."Schooling Year";
                                rGeneralTable."Original Line No." := rRegistrationSubjects."Original Line No.";

                                rEduConfig.Get;
                                rGeneralTable.Insert(true);
                                //Get assessemts
                                GetAssessment(rGeneralTable);
                                rGeneralTable.Modify;

                                //Aspects - Bloqueado dia 09-03-2009
                                InsertAspects(rRegistrationSubjects, rGeneralTable, p_SettingRatingsSS."Sub-Subject Code");

                            end;
                        end;
                    until rRegistrationSubjects.Next = 0;
                end;
            until rClass.Next = 0;
        end;
    end;


    procedure ChangeSubSubjAspects(pAspects: Record Aspects; pGeneralTable: Record GeneralTable)
    var
        rGeneralTable: Record GeneralTable;
        rGeneralTableAspects: Record GeneralTableAspects;
        rAspects: Record Aspects;
    begin
        if ValidateWeb = 0 then
            exit;

        case pAspects.Type of
            pAspects.Type::Student:
                begin
                    rGeneralTable.Reset;
                    rGeneralTable.SetRange(Student, pGeneralTable.Student);
                    rGeneralTable.SetRange(Subject, pGeneralTable.Subject);
                    rGeneralTable.SetRange("Is SubSubject", true);
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::" ");
                end;
        end;

        if rGeneralTable.Find('-') then
            repeat
                rGeneralTableAspects.Reset;
                rGeneralTableAspects.SetRange("Study Plan Entry No.", rGeneralTable."Entry No.");
                rGeneralTableAspects.SetRange(Aspect, pAspects.Code);
                if rGeneralTableAspects.FindSet then begin
                    GetAspects(pAspects.Type, pAspects."Type No.", pAspects."School Year",
                      pAspects."Schooling Year", pAspects."Moment Code",
                      pAspects.Subjects, rGeneralTable."Sub Subject", pAspects.Code, pAspects."Responsibility Center",
                      rAspects, rGeneralTableAspects, false);

                    rGeneralTableAspects."Percent Aspect" := rAspects."% Evaluation";
                    rGeneralTableAspects.AspectDescription := rAspects.Description;
                    //GET ASPECTS ASSESSEMENT
                    GetAspectsAssessment(rGeneralTableAspects);

                    if (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::" ") or
                       (rGeneralTableAspects."Update Type" = rGeneralTableAspects."Update Type"::Delete) then
                        rGeneralTableAspects."Update Type" := rGeneralTableAspects."Update Type"::Update;

                    if (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::" ") or
                       (rGeneralTableAspects."Update Type 2" = rGeneralTableAspects."Update Type 2"::Delete) then
                        rGeneralTableAspects."Update Type 2" := rGeneralTableAspects."Update Type 2"::Update;

                    rGeneralTableAspects.Modify;
                end;
            until rGeneralTable.Next = 0;
    end;


    procedure DelInsCourseSubjects(pAspects: Record Aspects)
    var
        lRegistrationSubjects: Record "Registration Subjects";
        lStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
    begin
        if ValidateWeb = 0 then
            exit;

        lRegistrationSubjects.Reset;
        if pAspects.Type = pAspects.Type::Course then
            lRegistrationSubjects.SetRange(Type, lRegistrationSubjects.Type::Multi)
        else
            lRegistrationSubjects.SetRange(Type, lRegistrationSubjects.Type::Simple);
        lRegistrationSubjects.SetRange("Study Plan Code", pAspects."Type No.");
        lRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
        lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
        lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
        if lRegistrationSubjects.FindSet then begin
            repeat
                if pAspects."Not to WEB" = false then
                    InsertAspectsStudent('', lRegistrationSubjects."Subjects Code", lRegistrationSubjects."Student Code No.", pAspects)
                else
                    DeleteAspectsStudent('', lRegistrationSubjects."Subjects Code", lRegistrationSubjects."Student Code No.", pAspects);

                lStudentSubSubjectsPlan.Reset;
                lStudentSubSubjectsPlan.SetRange("Student Code No.", lRegistrationSubjects."Student Code No.");
                lStudentSubSubjectsPlan.SetRange("School Year", lRegistrationSubjects."School Year");
                lStudentSubSubjectsPlan.SetRange("Subject Code", lRegistrationSubjects."Subjects Code");
                lStudentSubSubjectsPlan.SetRange("Schooling Year", lRegistrationSubjects."Schooling Year");
                lStudentSubSubjectsPlan.SetRange(Code, lRegistrationSubjects."Study Plan Code");
                if lStudentSubSubjectsPlan.FindSet then begin
                    repeat
                        if pAspects."Not to WEB" = false then
                            InsertAspectsStudent(lStudentSubSubjectsPlan."Sub-Subject Code", lRegistrationSubjects."Subjects Code",
                             lRegistrationSubjects."Student Code No.", pAspects)
                        else
                            DeleteAspectsStudent(lStudentSubSubjectsPlan."Sub-Subject Code", lRegistrationSubjects."Subjects Code",
                             lRegistrationSubjects."Student Code No.", pAspects)
                    until lStudentSubSubjectsPlan.Next = 0;
                end;
            until lRegistrationSubjects.Next = 0;
        end;
    end;


    procedure InsertUpdateFinalAssessment(lAssessingStudentsFinal: Record "Assessing Students Final")
    var
        rGeneralTable: Record GeneralTable;
        rMomentsAssessment: Record "Moments Assessment";
        rClass: Record Class;
        rAssessmentConfiguration: Record "Assessment Configuration";
        rGroupSubjects: Record "Group Subjects";
    begin
        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetRange(Student, lAssessingStudentsFinal."Student Code No.");
        rGeneralTable.SetRange(Moment, lAssessingStudentsFinal."Moment Code");
        case lAssessingStudentsFinal."Evaluation Type" of
            lAssessingStudentsFinal."Evaluation Type"::"Final Year":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Year");
                    rGeneralTable.SetRange("Option Group", '');
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Year Group":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Year Group");
                    rGeneralTable.SetRange("Option Group", lAssessingStudentsFinal."Option Group");
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Moment":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Moment");
                    rGeneralTable.SetRange("Option Group", '');
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Moment Group":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Moment Group");
                    rGeneralTable.SetRange("Option Group", lAssessingStudentsFinal."Option Group");
                end;
        end;
        if not rGeneralTable.FindSet(true, true) then begin
            Clear(rGeneralTable);
            rGeneralTable.Init;
            rGeneralTable."Update Type" := rGeneralTable."Update Type"::Insert;
            rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Insert;
            rGeneralTable.Company := CompanyName;

            case lAssessingStudentsFinal."Evaluation Type" of
                lAssessingStudentsFinal."Evaluation Type"::"Final Year":
                    begin
                        rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::"Final Year";
                        rAssessmentConfiguration.Reset;
                        rAssessmentConfiguration.SetRange("School Year", lAssessingStudentsFinal."School Year");
                        rAssessmentConfiguration.SetRange(Type, lAssessingStudentsFinal."Type Education");
                        rAssessmentConfiguration.SetRange("Study Plan Code", lAssessingStudentsFinal."Study Plan Code");
                        if rAssessmentConfiguration.FindFirst then begin
                            rGeneralTable.EvaluationType := rAssessmentConfiguration."FY Evaluation Type";
                            rGeneralTable."Assement Code" := rAssessmentConfiguration."FY Assessment Code";
                        end;
                    end;
                lAssessingStudentsFinal."Evaluation Type"::"Final Year Group":
                    begin
                        rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::"Final Year Group";
                        if (lAssessingStudentsFinal."Option Group" <> '') then begin
                            rGroupSubjects.Reset;
                            rGroupSubjects.SetRange(Code, lAssessingStudentsFinal."Option Group");
                            if (lAssessingStudentsFinal."Type Education" = lAssessingStudentsFinal."Type Education"::Multi) then
                                rGroupSubjects.SetRange("Schooling Year", '')
                            else
                                rGroupSubjects.SetRange("Schooling Year", lAssessingStudentsFinal."Schooling Year");
                            if rGroupSubjects.FindFirst then begin
                                rGeneralTable.EvaluationType := rGroupSubjects."Evaluation Type";
                                rGeneralTable."Assement Code" := rGroupSubjects."Assessment Code";
                            end;
                        end;
                    end;
                lAssessingStudentsFinal."Evaluation Type"::"Final Moment":
                    begin
                        rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::"Final Moment";
                        rAssessmentConfiguration.Reset;
                        rAssessmentConfiguration.SetRange("School Year", lAssessingStudentsFinal."School Year");
                        rAssessmentConfiguration.SetRange(Type, lAssessingStudentsFinal."Type Education");
                        rAssessmentConfiguration.SetRange("Study Plan Code", lAssessingStudentsFinal."Study Plan Code");
                        if rAssessmentConfiguration.FindFirst then begin
                            rGeneralTable.EvaluationType := rAssessmentConfiguration."PA Evaluation Type";
                            rGeneralTable."Assement Code" := rAssessmentConfiguration."PA Assessment Code";
                        end;

                    end;
                lAssessingStudentsFinal."Evaluation Type"::"Final Moment Group":
                    begin
                        rGeneralTable."Entry Type" := rGeneralTable."Entry Type"::"Final Moment Group";
                        if (lAssessingStudentsFinal."Option Group" <> '') then begin
                            rGroupSubjects.Reset;
                            rGroupSubjects.SetRange(Code, lAssessingStudentsFinal."Option Group");
                            if (lAssessingStudentsFinal."Type Education" = lAssessingStudentsFinal."Type Education"::Multi) then
                                rGroupSubjects.SetRange("Schooling Year", '')
                            else
                                rGroupSubjects.SetRange("Schooling Year", lAssessingStudentsFinal."Schooling Year");
                            if rGroupSubjects.FindFirst then begin
                                rGeneralTable.EvaluationType := rGroupSubjects."Evaluation Type";
                                rGeneralTable."Assement Code" := rGroupSubjects."Assessment Code";
                            end;
                        end;
                    end;
            end;

            rGeneralTable.Class := lAssessingStudentsFinal.Class;
            rGeneralTable."School Year" := lAssessingStudentsFinal."School Year";
            rGeneralTable.SchoolingYear := lAssessingStudentsFinal."Schooling Year";
            if rClass.Get(lAssessingStudentsFinal.Class, lAssessingStudentsFinal."School Year") then begin
                if rMomentsAssessment.Get(lAssessingStudentsFinal."Moment Code", lAssessingStudentsFinal."School Year",
                                          lAssessingStudentsFinal."Schooling Year", rClass."Responsibility Center") then begin
                    rGeneralTable."Moment Ponder" := rMomentsAssessment.Weighting;
                end;
            end;
            rGeneralTable.Moment := lAssessingStudentsFinal."Moment Code";
            rGeneralTable."Option Group" := lAssessingStudentsFinal."Option Group";
            rGeneralTable.Student := lAssessingStudentsFinal."Student Code No.";
            rGeneralTable.GradeAuto := Format(lAssessingStudentsFinal.Grade);
            rGeneralTable."Type Education" := lAssessingStudentsFinal."Type Education";
            rGeneralTable."Qualitative Eval." := lAssessingStudentsFinal."Qualitative Grade";
            if (lAssessingStudentsFinal."Qualitative Manual Grade" <> '') or (lAssessingStudentsFinal."Manual Grade" <> 0) then begin
                rGeneralTable."Qualitative Eval." := lAssessingStudentsFinal."Qualitative Manual Grade";
                rGeneralTable.GradeAuto := Format(lAssessingStudentsFinal."Manual Grade");
            end;

            rGeneralTable."Type Education" := lAssessingStudentsFinal."Type Education";
            rGeneralTable.StudyPlanCode := lAssessingStudentsFinal."Study Plan Code";
            rGeneralTable.Insert;

        end else begin
            if not (rGeneralTable."Update Type" = rGeneralTable."Update Type"::Insert) then
                rGeneralTable."Update Type" := rGeneralTable."Update Type"::Update;

            if not (rGeneralTable."Update Type 2" = rGeneralTable."Update Type 2"::Insert) then
                rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Update;

            rGeneralTable.GradeAuto := Format(lAssessingStudentsFinal.Grade);
            rGeneralTable."Qualitative Eval." := lAssessingStudentsFinal."Qualitative Grade";

            if (lAssessingStudentsFinal."Qualitative Manual Grade" <> '') or (lAssessingStudentsFinal."Manual Grade" <> 0) then begin
                rGeneralTable."Qualitative Eval." := lAssessingStudentsFinal."Qualitative Manual Grade";
                rGeneralTable.GradeAuto := Format(lAssessingStudentsFinal."Manual Grade");
            end;
            rGeneralTable.Modify;
        end;
    end;


    procedure DeleteFinalAssessment(lAssessingStudentsFinal: Record "Assessing Students Final")
    var
        rGeneralTable: Record GeneralTable;
    begin
        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Reset;
        rGeneralTable.SetRange(Student, lAssessingStudentsFinal."Student Code No.");
        rGeneralTable.SetRange(Moment, lAssessingStudentsFinal."Moment Code");
        case lAssessingStudentsFinal."Evaluation Type" of
            lAssessingStudentsFinal."Evaluation Type"::"Final Year":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Year");
                    rGeneralTable.SetRange("Option Group", '');
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Year Group":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Year Group");
                    rGeneralTable.SetRange("Option Group", lAssessingStudentsFinal."Option Group");
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Moment":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Moment");
                    rGeneralTable.SetRange("Option Group", '');
                end;
            lAssessingStudentsFinal."Evaluation Type"::"Final Moment Group":
                begin
                    rGeneralTable.SetRange("Entry Type", rGeneralTable."Entry Type"::"Final Moment Group");
                    rGeneralTable.SetRange("Option Group", lAssessingStudentsFinal."Option Group");
                end;
        end;
        if rGeneralTable.FindSet(true, true) then begin
            if rGeneralTable."Update Type" = rGeneralTable."Update Type"::Insert then
                rGeneralTable.Delete;
            exit;
            rGeneralTable."Update Type" := rGeneralTable."Update Type"::Delete;
            rGeneralTable."Update Type 2" := rGeneralTable."Update Type 2"::Delete;
            rGeneralTable.Modify;
        end;
    end;


    procedure ModStructureEducationCountry(pStructureEducationCountry: Record "Structure Education Country")
    var
        rMasterTableWEB: Record MasterTableWEB;
    begin
        if ValidateWeb = 0 then
            exit;

        rMasterTableWEB.Reset;
        rMasterTableWEB.SetRange("Table Type", rMasterTableWEB."Table Type"::Class);
        rMasterTableWEB.SetRange(SchoolingYear, pStructureEducationCountry."Schooling Year");
        if rMasterTableWEB.FindSet(true, true) then begin
            repeat
                if rMasterTableWEB."Action Type" <> rMasterTableWEB."Action Type"::Delete then begin

                    rMasterTableWEB."Interface Type WEB" := pStructureEducationCountry."Interface Type WEB";

                    if not (rMasterTableWEB."Action Type" = rMasterTableWEB."Action Type"::Insert) then
                        rMasterTableWEB."Action Type" := rMasterTableWEB."Action Type"::Update;
                end;

                if rMasterTableWEB."Action Type 2" <> rMasterTableWEB."Action Type 2"::Delete then begin

                    rMasterTableWEB."Interface Type WEB" := pStructureEducationCountry."Interface Type WEB";

                    if not (rMasterTableWEB."Action Type 2" = rMasterTableWEB."Action Type 2"::Insert) then
                        rMasterTableWEB."Action Type 2" := rMasterTableWEB."Action Type 2"::Update;
                end;

                rMasterTableWEB.Modify;

            until rMasterTableWEB.Next = 0;

        end;
    end;


    procedure InsertRemarks(pNewRec: Record Remarks)
    var
        lWEBRemarks: Record "WEB Remarks";
        lEntryno: Integer;
    begin
        if (pNewRec."Type Remark" <> pNewRec."Type Remark"::Assessment) and
          (pNewRec."Type Remark" <> pNewRec."Type Remark"::Absence) and
          (pNewRec."Type Remark" <> pNewRec."Type Remark"::Annotation) then
            exit;

        if ValidateWeb = 0 then
            exit;

        if lWEBRemarks.Get(pNewRec."Entry No.") then begin
            lWEBRemarks.Init;
            lWEBRemarks.TransferFields(pNewRec);
            lEntryno := pNewRec."Entry No.";
            lWEBRemarks."Entry No." := lEntryno;
            lWEBRemarks."Update Type" := lWEBRemarks."Update Type"::Insert;
            lWEBRemarks."Update Type 2" := lWEBRemarks."Update Type 2"::Insert;
            lWEBRemarks.Modify;
        end else begin
            lWEBRemarks.Init;
            lWEBRemarks.TransferFields(pNewRec);
            lEntryno := pNewRec."Entry No.";
            lWEBRemarks."Entry No." := lEntryno;
            lWEBRemarks."Update Type" := lWEBRemarks."Update Type"::Insert;
            lWEBRemarks."Update Type 2" := lWEBRemarks."Update Type 2"::Insert;
            lWEBRemarks.Insert;
        end;
    end;


    procedure DeleteRemarks(pNewRec: Record Remarks)
    var
        lWEBRemarks: Record "WEB Remarks";
    begin
        if (pNewRec."Type Remark" <> pNewRec."Type Remark"::Assessment) and
          (pNewRec."Type Remark" <> pNewRec."Type Remark"::Absence) and
          (pNewRec."Type Remark" <> pNewRec."Type Remark"::Annotation) then
            exit;

        if ValidateWeb = 0 then
            exit;

        lWEBRemarks.Reset;
        if lWEBRemarks.Get(pNewRec."Entry No.") then begin
            if (lWEBRemarks."Update Type" = lWEBRemarks."Update Type"::Insert) and
              (lWEBRemarks."Update Type 2" = lWEBRemarks."Update Type 2"::Insert) then
                lWEBRemarks.Delete
            else begin
                lWEBRemarks."Update Type" := lWEBRemarks."Update Type"::Delete;
                lWEBRemarks."Update Type 2" := lWEBRemarks."Update Type 2"::Delete;
                lWEBRemarks.Modify;
            end;
        end;
    end;


    procedure GetAspectsAssessment(var pGeneralTableAspects: Record GeneralTableAspects)
    var
        rAssessingStudentsAspects: Record "Assessing Students Aspects";
        rGeneralTable: Record GeneralTable;
    begin
        if ValidateWeb = 0 then
            exit;

        rGeneralTable.Get(pGeneralTableAspects."Study Plan Entry No.");

        rAssessingStudentsAspects.Reset;
        //rAssessingStudentsAspects.SETRANGE(Class,pGeneralTableAspects.Class);
        rAssessingStudentsAspects.SetRange("School Year", pGeneralTableAspects."School Year");
        rAssessingStudentsAspects.SetRange("Schooling Year", rGeneralTable.SchoolingYear);
        rAssessingStudentsAspects.SetRange(Subject, pGeneralTableAspects.Subject);
        if rGeneralTable."Is SubSubject" then
            rAssessingStudentsAspects.SetRange("Sub-Subject Code", rGeneralTable."Sub Subject")
        else
            rAssessingStudentsAspects.SetRange("Sub-Subject Code", '');
        rAssessingStudentsAspects.SetRange("Student Code No.", pGeneralTableAspects.Student);
        rAssessingStudentsAspects.SetRange("Moment Code", pGeneralTableAspects.Moment);
        rAssessingStudentsAspects.SetRange("Study Plan Code", rGeneralTable.StudyPlanCode);
        rAssessingStudentsAspects.SetRange("Type Education", rGeneralTable."Type Education");
        rAssessingStudentsAspects.SetRange("Aspects Code", pGeneralTableAspects.Aspect);
        if rAssessingStudentsAspects.Find('-') then begin
            //IF rAssessingStudentsAspects.Grade <> 0 THEN
            if rAssessingStudentsAspects."Grade Calc" = 0 then
                pGeneralTableAspects.GradeManual := Format(rAssessingStudentsAspects.Grade)
            //IF rAssessingStudentsAspects."Qualitative Grade" <> '' THEN
            //  pGeneralTableAspects.GradeManual := rAssessingStudentsAspects."Qualitative Grade";
            else
                //IF rAssessingStudentsAspects."Grade Calc" <> 0 THEN
                pGeneralTableAspects.GradeManual := Format(rAssessingStudentsAspects."Grade Calc");
            //IF rAssessingStudentsAspects."Qualitative Grade Calc" <> '' THEN
            // pGeneralTableAspects.GradeManual := rAssessingStudentsAspects."Qualitative Grade Calc";
            pGeneralTableAspects.Modify;
        end;
    end;


    procedure UpdateStudentsSubjectsTurn(pRegistrationSubjects: Record "Registration Subjects")
    var
        rGeneralTable: Record GeneralTable;
    begin
        rGeneralTable.Reset;
        rGeneralTable.SetRange("School Year", pRegistrationSubjects."School Year");
        rGeneralTable.SetRange(Class, pRegistrationSubjects.Class);
        rGeneralTable.SetRange(Student, pRegistrationSubjects."Student Code No.");
        rGeneralTable.SetRange(Subject, pRegistrationSubjects."Subjects Code");
        rGeneralTable.SetRange(SchoolingYear, pRegistrationSubjects."Schooling Year");
        if pRegistrationSubjects.Type = pRegistrationSubjects.Type::Multi then
            rGeneralTable.SetRange("Original Line No.", pRegistrationSubjects."Original Line No.");
        rGeneralTable.SetRange(StudyPlanCode, pRegistrationSubjects."Study Plan Code");
        rGeneralTable.SetRange("Type Education", pRegistrationSubjects.Type);
        rGeneralTable.SetRange("Is SubSubject", false);
        if rGeneralTable.FindSet(true, true) then begin
            if rGeneralTable."Update Type" = rGeneralTable."Update Type"::" " then
                rGeneralTable.ModifyAll("Update Type", rGeneralTable."Update Type"::Update);
            rGeneralTable.ModifyAll(Turn, pRegistrationSubjects.Turn);
        end;
    end;


    procedure UpdateStudentsSubSubjectsTurn(pStudentSubSubjects: Record "Student Sub-Subjects Plan ")
    var
        rGeneralTable: Record GeneralTable;
    begin

        rGeneralTable.Reset;
        rGeneralTable.SetRange("School Year", pStudentSubSubjects."School Year");
        rGeneralTable.SetRange(SchoolingYear, pStudentSubSubjects."Schooling Year");
        rGeneralTable.SetRange(Student, pStudentSubSubjects."Student Code No.");
        rGeneralTable.SetRange(Subject, pStudentSubSubjects."Subject Code");
        rGeneralTable.SetRange("Sub Subject", pStudentSubSubjects."Sub-Subject Code");
        rGeneralTable.SetRange(Company, CompanyName);
        rGeneralTable.SetRange("Is SubSubject", true);
        if rGeneralTable.FindSet(true, true) then begin
            if rGeneralTable."Update Type" = rGeneralTable."Update Type"::" " then
                rGeneralTable.ModifyAll("Update Type", rGeneralTable."Update Type"::Update);
            rGeneralTable.ModifyAll(Turn, pStudentSubSubjects.Turn);
        end;
    end;
}

