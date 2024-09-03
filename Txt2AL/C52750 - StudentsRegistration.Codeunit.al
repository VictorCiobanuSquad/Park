codeunit 52750 "Students Registration"
{
    Permissions = TableData "Registration Class Entry" = rimd,
                  TableData Absence = rimd,
                  TableData "Student Subjects Entry" = rimd;

    trigger OnRun()
    begin
        EncyptPassword('e84020b187b2b85c4638d3c16988eb3a');
    end;

    var
        rRegistrationClassEntry: Record "Registration Class Entry";
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Window: Dialog;
        Nreg: Integer;
        countReg: Integer;

    //[Scope('OnPrem')]
    procedure InsertStudents(pRegistrationClass: Record "Registration Class")
    begin
        rRegistrationClassEntry.Reset;
        rRegistrationClassEntry.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegistrationClassEntry.SetRange("School Year", pRegistrationClass."School Year");
        if rRegistrationClassEntry.Find('+') then begin
            rRegistrationClassEntry.Active := false;
            rRegistrationClassEntry.Modify;
        end;

        Clear(rRegistrationClassEntry);
        rRegistrationClassEntry.Init;
        //rRegistrationClassEntry."Entry No." := GetLastMovNumber;
        rRegistrationClassEntry.Class := pRegistrationClass.Class;
        rRegistrationClassEntry."School Year" := pRegistrationClass."School Year";
        rRegistrationClassEntry."Schooling Year" := pRegistrationClass."Schooling Year";
        rRegistrationClassEntry."Student Code No." := pRegistrationClass."Student Code No.";
        rRegistrationClassEntry.Name := pRegistrationClass.Name;
        rRegistrationClassEntry."Class No." := pRegistrationClass."Class No.";
        rRegistrationClassEntry.Status := pRegistrationClass.Status;
        rRegistrationClassEntry."Status Date" := pRegistrationClass."Status Date";
        rRegistrationClassEntry."School Name" := pRegistrationClass."School Name Transfer";
        rRegistrationClassEntry."Transfer Class" := pRegistrationClass."Transfer Class";
        rRegistrationClassEntry.Destination := pRegistrationClass.Destination;
        rRegistrationClassEntry."Study Plan Code" := pRegistrationClass."Study Plan Code";
        //rRegistrationClassEntry.Turn := pRegistrationClass.Turn;
        rRegistrationClassEntry.Active := true;
        rRegistrationClassEntry."User Id" := pRegistrationClass."User Id";
        rRegistrationClassEntry.Date := pRegistrationClass.Date;
        rRegistrationClassEntry.Type := pRegistrationClass.Type;

        rRegistrationClassEntry."Responsibility Center" := pRegistrationClass."Responsibility Center";

        rRegistrationClassEntry.Insert;
    end;

    //[Scope('OnPrem')]
    procedure GetLastMovNumber() LastMov: Integer
    begin
        rRegistrationClassEntry.Reset;
        if rRegistrationClassEntry.FindLast then
            exit(LastMov)
        else
            exit(1);
    end;

    //[Scope('OnPrem')]
    procedure StudentSubjectsRegister(pRegistrationClass: Record "Registration Class")
    var
        rRegSubsServ: Record "Registration Subjects";
    begin

        rRegSubsServ.Reset;
        rRegSubsServ.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegSubsServ.SetRange("School Year", pRegistrationClass."School Year");
        rRegSubsServ.SetRange("Study Plan Code", pRegistrationClass."Study Plan Code");
        //rRegSubsServ.SETRANGE(Status,0);
        rRegSubsServ.SetRange(Enroled, true);
        if rRegSubsServ.Find('-') then begin
            repeat
                rRegSubsServ.Status := rRegSubsServ.Status::Subscribed;
                rRegSubsServ.Class := pRegistrationClass.Class;
                rRegSubsServ."Class No." := pRegistrationClass."Class No.";
                rRegSubsServ."Status Date" := WorkDate;
                rRegSubsServ.Modify(true);
                //WEB
                cInsertNAVGeneralTable.InsertGTStudent(rRegSubsServ);
                //Entry
                StudentsSubjectsEntry(rRegSubsServ);
            until rRegSubsServ.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure StudentSubjectsCorrect(pRegistrationClass: Record "Registration Class")
    var
        rAspects: Record Aspects;
        rRegistrationSubjects: Record "Registration Subjects";
    begin


        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("School Year", pRegistrationClass."School Year");
        rRegistrationSubjects.SetRange("Schooling Year", pRegistrationClass."Schooling Year");
        rRegistrationSubjects.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegistrationSubjects.SetRange(Class, pRegistrationClass.Class);
        if rRegistrationSubjects.Find('-') then begin
            repeat
                //WEB
                cInsertNAVGeneralTable.DelGTStudent(rRegistrationSubjects);

                rRegistrationSubjects.Status := rRegistrationSubjects.Status::" ";
                rRegistrationSubjects.Class := pRegistrationClass.Class;
                rRegistrationSubjects."Class No." := 0;
                rRegistrationSubjects."Status Date" := WorkDate;
                rRegistrationSubjects.Modify(true);
                //Entry
                StudentsSubjectsEntry(rRegistrationSubjects);

            until rRegistrationSubjects.Next = 0;
        end;



        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Student);
        rAspects.SetRange("School Year", pRegistrationClass."School Year");
        rAspects.SetRange("Schooling Year", pRegistrationClass."Schooling Year");
        rAspects.SetRange("Type No.", pRegistrationClass."Student Code No.");
        if rAspects.Find('-') then
            rAspects.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure StudentSubjectsCancel(pRegistrationClass: Record "Registration Class")
    var
        rAspects: Record Aspects;
        rRegistrationSubjects: Record "Registration Subjects";
    begin

        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("School Year", pRegistrationClass."School Year");
        rRegistrationSubjects.SetRange("Schooling Year", pRegistrationClass."Schooling Year");
        rRegistrationSubjects.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegistrationSubjects.SetRange(Class, pRegistrationClass.Class);
        if rRegistrationSubjects.Find('-') then begin
            repeat
                //WEB
                cInsertNAVGeneralTable.AnunulGTStudent(rRegistrationSubjects);
                //
                rRegistrationSubjects.Status := rRegistrationSubjects.Status::Cancelled;
                rRegistrationSubjects."Status Date" := pRegistrationClass."Status Date";
                rRegistrationSubjects.Modify(true);
                //Entry
                StudentsSubjectsEntry(rRegistrationSubjects);

            until rRegistrationSubjects.Next = 0;
        end;

        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Student);
        rAspects.SetRange("School Year", pRegistrationClass."School Year");
        rAspects.SetRange("Schooling Year", pRegistrationClass."Schooling Year");
        rAspects.SetRange("Type No.", pRegistrationClass."Student Code No.");
        if rAspects.Find('-') then
            rAspects.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure GetShoolYear(): Code[1000]
    var
        rSchoolYear: Record "School Year";
        SchoolYearAll: Code[1000];
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1|%2', rSchoolYear.Status::Planning, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            Clear(SchoolYearAll);
            repeat
                if SchoolYearAll = '' then
                    SchoolYearAll := rSchoolYear."School Year"
                else
                    SchoolYearAll := SchoolYearAll + '|' + rSchoolYear."School Year"
            until rSchoolYear.Next = 0;
        end;

        exit(SchoolYearAll);
    end;

    //[Scope('OnPrem')]
    procedure GetShoolYearActive(): Code[1000]
    var
        rSchoolYear: Record "School Year";
        SchoolYearAll: Code[1000];
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            Clear(SchoolYearAll);
            repeat
                if SchoolYearAll = '' then
                    SchoolYearAll := rSchoolYear."School Year"
            until rSchoolYear.Next = 0;
        end;

        exit(SchoolYearAll);
    end;

    //[Scope('OnPrem')]
    procedure GetShoolYearPreActiveClosing(): Code[1000]
    var
        rSchoolYear: Record "School Year";
        SchoolYearAll: Code[1000];
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1|%2|%3', rSchoolYear.Status::Planning,
                                     rSchoolYear.Status::Active, rSchoolYear.Status::Closing);
        if rSchoolYear.Find('-') then begin
            Clear(SchoolYearAll);
            repeat
                if SchoolYearAll = '' then
                    SchoolYearAll := rSchoolYear."School Year"
                else
                    SchoolYearAll := SchoolYearAll + '|' + rSchoolYear."School Year"
            until rSchoolYear.Next = 0;
            exit(SchoolYearAll);
        end;


        exit(' ');
    end;

    //[Scope('OnPrem')]
    procedure GetShoolYearActiveClosing(): Code[1000]
    var
        rSchoolYear: Record "School Year";
        SchoolYearAll: Code[1000];
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1|%2', rSchoolYear.Status::Closing, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            Clear(SchoolYearAll);
            repeat
                if SchoolYearAll = '' then
                    SchoolYearAll := rSchoolYear."School Year"
                else
                    SchoolYearAll := SchoolYearAll + '|' + rSchoolYear."School Year"
            until rSchoolYear.Next = 0;
        end;

        exit(SchoolYearAll);
    end;

    //[Scope('OnPrem')]
    procedure GetCountry(): Code[10]
    var
        rCompanyInformation: Record "Company Information";
    begin
        if rCompanyInformation.Get then begin
            rCompanyInformation.TestField("Country/Region Code");
            exit(rCompanyInformation."Country/Region Code");
        end;
    end;

    //[Scope('OnPrem')]
    procedure CancelStudentSubject(pRegSubjects: Record "Registration Subjects"; pDate: Date; pVarStatus: Option " ",Subscribed,Transfer,Annuled,Completed; pVarNewClass: Code[20])
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
        rRegistrationClass: Record "Registration Class";
        varLineNo: Integer;
        varClassNo: Integer;
        rClass: Record Class;
        rStudents: Record Students;
        l_varcount: Integer;
        l_Class: Code[20];
        l_RegistrationSubjects: Record "Registration Subjects";
    begin
        //Status '' is correct
        varLineNo := 0;
        varClassNo := 0;
        l_varcount := 0;

        l_RegistrationSubjects.Copy(pRegSubjects);

        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("School Year", pRegSubjects."School Year");
        rRegistrationSubjects.SetRange("Schooling Year", pRegSubjects."Schooling Year");
        rRegistrationSubjects.SetRange("Student Code No.", pRegSubjects."Student Code No.");
        if pVarStatus = pVarStatus::Transfer then
            rRegistrationSubjects.SetRange(Class, pVarNewClass)
        else
            rRegistrationSubjects.SetRange(Class, pRegSubjects.Class);
        rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
        if rRegistrationSubjects.Find('-') then
            l_varcount := rRegistrationSubjects.Count;


        if pVarStatus = pVarStatus::Transfer then begin
            rRegistrationClass.Reset;
            rRegistrationClass.SetRange(Class, pRegSubjects.Class);
            rRegistrationClass.SetRange("School Year", pRegSubjects."School Year");
            rRegistrationClass.SetRange("Schooling Year", pRegSubjects."Schooling Year");
            rRegistrationClass.SetRange("Study Plan Code", pRegSubjects."Study Plan Code");
            rRegistrationClass.SetRange("Student Code No.", pRegSubjects."Student Code No.");
            rRegistrationClass.SetRange("Responsibility Center", pRegSubjects."Responsibility Center");
            if rRegistrationClass.Find('-') then begin
                if (l_varcount = 1) or (l_varcount = 0) then begin
                    rRegistrationClass.Status := rRegistrationClass.Status::Transfer;
                    rRegistrationClass."Status Date" := pDate;
                    rRegistrationClass.Modify(true)
                end;
            end;
        end;

        if (pVarStatus = pVarStatus::Annuled) or (pVarStatus = pVarStatus::" ") then
            l_Class := pRegSubjects.Class;


        if pVarStatus = pVarStatus::Annuled then
            pRegSubjects."Attendance Situation" := pRegSubjects."Attendance Situation"::AM;

        if pVarStatus = pVarStatus::Transfer then begin
            pRegSubjects."Status Date" := pDate;
            pRegSubjects.Status := pRegSubjects.Status::Transfer;
            pRegSubjects.Validate(Enroled, true);
            //entry
            StudentsSubjectsEntry(pRegSubjects);

            if rClass.Get(pVarNewClass, pRegSubjects."School Year") then;
            pRegSubjects."Study Plan Code" := rClass."Study Plan Code";

            pRegSubjects.Class := pVarNewClass;
            pRegSubjects.Status := pRegSubjects.Status::Subscribed;

        end else begin
            pRegSubjects.Status := pRegSubjects.Status::" ";
            pRegSubjects."Status Date" := pDate;
            pRegSubjects.Validate(Enroled, false);
            pRegSubjects.Status := pVarStatus;
            /*C+ 2011.11.22 - É necessário preencher sempre a Data Estado e a Turma por causa da key do ecrã das avaliações
            IF pVarStatus = pVarStatus::" " THEN BEGIN
              pRegSubjects.Class := '';
              pRegSubjects."Status Date" := 0D;
            END;
            */
        end;


        rRegistrationClass.Reset;
        if (pVarStatus = pVarStatus::Annuled) or (pVarStatus = pVarStatus::" ") then
            rRegistrationClass.SetRange(Class, l_Class);
        if pVarStatus = pVarStatus::Transfer then
            rRegistrationClass.SetRange(Class, pVarNewClass);
        rRegistrationClass.SetRange("School Year", pRegSubjects."School Year");
        rRegistrationClass.SetRange("Schooling Year", pRegSubjects."Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", pRegSubjects."Study Plan Code");
        rRegistrationClass.SetRange("Student Code No.", pRegSubjects."Student Code No.");
        rRegistrationClass.SetRange("Responsibility Center", pRegSubjects."Responsibility Center");
        if rRegistrationClass.Find('-') then begin
            if (l_varcount = 1) or (l_varcount = 0) then begin
                rRegistrationClass.Status := pRegSubjects.Status;
                rRegistrationClass.Modify(true);
            end;
        end else begin
            if pVarStatus = pVarStatus::Transfer then begin
                GetLastClassLineNo(pRegSubjects, varLineNo, varClassNo);
                if rClass.Get(pVarNewClass, pRegSubjects."School Year") then;
                rRegistrationClass.Init;
                rRegistrationClass.Class := pVarNewClass;
                rRegistrationClass."School Year" := pRegSubjects."School Year";
                rRegistrationClass."Schooling Year" := pRegSubjects."Schooling Year";
                rRegistrationClass."Study Plan Code" := pRegSubjects."Study Plan Code";
                rRegistrationClass.Validate("Student Code No.", pRegSubjects."Student Code No.");
                if rStudents.Get(pRegSubjects."Student Code No.") then begin
                    rRegistrationClass.Name := rStudents.Name;
                    rRegistrationClass."Last Name" := rStudents."Last Name";
                    rRegistrationClass."Last Name 2" := rStudents."Last Name 2";
                    rRegistrationClass."Full Name" := rStudents."Full Name";
                end;
                rRegistrationClass.Status := rRegistrationClass.Status::Subscribed;
                rRegistrationClass."Line No." := varLineNo;
                rRegistrationClass."Class No." := varClassNo;
                rRegistrationClass."Status Date" := pDate;
                rRegistrationClass.Type := rClass.Type;
                rRegistrationClass."Responsibility Center" := rStudents."Responsibility Center";
                rRegistrationClass.Insert(true);
                //Entry Class
                InsertStudents(rRegistrationClass);
            end;
        end;

        pRegSubjects."Class No." := rRegistrationClass."Class No.";
        //C+ 2011.11.22 - É necessário actualizar o UserID.
        pRegSubjects."User Id" := UserId;
        pRegSubjects.Date := Today;
        //
        pRegSubjects.Modify;

        //WEB
        if pVarStatus = pVarStatus::" " then
            cInsertNAVGeneralTable.DelGTStudent(l_RegistrationSubjects);

        if pVarStatus = pVarStatus::Annuled then
            cInsertNAVGeneralTable.AnunulGTStudent(l_RegistrationSubjects);

        if pVarStatus = pVarStatus::Transfer then begin
            //mODIFY THE old class and subcried in the new class
            cInsertNAVGeneralTable.AnunulGTStudent(l_RegistrationSubjects);
            cInsertNAVGeneralTable.InsertGTStudent(pRegSubjects);
        end;
        //WEB



        if (pVarStatus = pVarStatus::Annuled) or (pVarStatus = pVarStatus::" ") then begin
            rAspects.Reset;
            rAspects.SetRange(Type, rAspects.Type::Student);
            rAspects.SetRange("School Year", pRegSubjects."School Year");
            rAspects.SetRange("Schooling Year", pRegSubjects."Schooling Year");
            rAspects.SetRange("Type No.", pRegSubjects."Student Code No.");
            rAspects.SetRange(Subjects, pRegSubjects."Subjects Code");
            if rAspects.Find('-') then
                rAspects.DeleteAll(true);
        end;

        //Entry
        StudentsSubjectsEntry(pRegSubjects);

    end;

    //[Scope('OnPrem')]
    procedure StudentSingleSubReg(pSubjects: Code[10]; pRegistration: Record Registration; pNewClass: Code[20]; pDate: Date; pSchoolingYear: Code[10])
    var
        rRegistrationClass: Record "Registration Class";
        rRegistrationClass2: Record "Registration Class";
        LastNo: Integer;
        LastLineNo: Integer;
        StudyPlanCode: Code[20];
        rRegistrationSubjects: Record "Registration Subjects";
        LastLineNo2: Integer;
        rStudents: Record Students;
        rSubjects: Record Subjects;
        rClass: Record Class;
        rCourseLines: Record "Course Lines";
        Text001: Label 'The student is already register in the subject selected.';
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Student Code No.", pRegistration."Student Code No.");
        rRegistrationSubjects.SetRange("School Year", pRegistration."School Year");
        rRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
        rRegistrationSubjects.SetRange("Subjects Code", pSubjects);
        rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
        if rRegistrationSubjects.FindFirst then
            Error(Text001);



        rRegistrationClass2.Reset;
        rRegistrationClass2.SetCurrentKey("Class No.");
        rRegistrationClass2.SetRange(Class, pNewClass);
        rRegistrationClass2.SetRange("School Year", pRegistration."School Year");
        rRegistrationClass2.SetRange("Schooling Year", pSchoolingYear);
        rRegistrationClass2.SetRange("Student Code No.", pRegistration."Student Code No.");
        if not rRegistrationClass2.Find('-') then begin
            if pRegistration.Class <> pNewClass then begin

                if rClass.Get(pNewClass, pRegistration."School Year") then
                    StudyPlanCode := rClass."Study Plan Code";

                rRegistrationClass.Reset;
                rRegistrationClass.SetCurrentKey(rRegistrationClass."Class No.");
                rRegistrationClass.SetRange(Class, pNewClass);
                rRegistrationClass.SetRange("School Year", pRegistration."School Year");
                if rRegistrationClass.Find('+') then begin
                    LastNo := rRegistrationClass."Class No.";
                    LastLineNo := rRegistrationClass."Line No.";
                end;


                rRegistrationClass.Reset;
                rRegistrationClass.SetRange(Class, pNewClass);
                ;
                rRegistrationClass.SetRange("School Year", pRegistration."School Year");
                rRegistrationClass.SetRange("Schooling Year", pSchoolingYear);
                rRegistrationClass.SetRange("Student Code No.", pRegistration."Student Code No.");
                if not rRegistrationClass.Find('-') then begin
                    rRegistrationClass.Init;
                    rRegistrationClass.Class := pNewClass;
                    rRegistrationClass."School Year" := pRegistration."School Year";
                    rRegistrationClass."Schooling Year" := pSchoolingYear;
                    rRegistrationClass."Study Plan Code" := StudyPlanCode;
                    rRegistrationClass."Student Code No." := pRegistration."Student Code No.";
                    if rStudents.Get(pRegistration."Student Code No.") then begin
                        rRegistrationClass.Name := rStudents.Name;
                        rRegistrationClass."Last Name" := rStudents."Last Name";
                        rRegistrationClass."Last Name 2" := rStudents."Last Name 2";
                    end;
                    rRegistrationClass.Type := rRegistrationClass.Type::Multi;
                    rRegistrationClass."Class No." := LastNo + 1;
                    rRegistrationClass."Line No." := LastLineNo + 10000;
                    rRegistrationClass."Status Date" := pDate;
                    rRegistrationClass.Status := rRegistrationClass.Status::Subscribed;
                    rRegistrationClass."Country/Region Code" := GetCountry;
                    rRegistrationClass.Insert(true);

                    InsertStudents(rRegistrationClass);
                end;

                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Student Code No.", pRegistration."Student Code No.");
                rRegistrationSubjects.SetRange("School Year", pRegistration."School Year");
                if rRegistrationSubjects.FindLast then
                    LastLineNo2 := rRegistrationSubjects."Line No." + 10000
                else
                    LastLineNo2 := 10000;

                rCourseLines.Reset;
                rCourseLines.SetRange(Code, StudyPlanCode);
                rCourseLines.SetRange("Subject Code", pSubjects);
                if rCourseLines.FindFirst then;

                rCourseLines.TestField("Assessment Code");

                rCourseLines.CalcFields("Sub-Subject");
                rRegistrationSubjects.Reset;
                rRegistrationSubjects.Init;
                rRegistrationSubjects."Student Code No." := pRegistration."Student Code No.";
                rRegistrationSubjects."School Year" := pRegistration."School Year";
                rRegistrationSubjects."Study Plan Code" := StudyPlanCode;
                rRegistrationSubjects."Line No." := LastLineNo2;
                rRegistrationSubjects.Type := rRegistrationSubjects.Type::Multi;
                rRegistrationSubjects.Validate("Subjects Code", pSubjects);

                if rSubjects.Get(1, pSubjects) then
                    rRegistrationSubjects.Description := rSubjects.Description;

                rRegistrationSubjects."Schooling Year" := pSchoolingYear;
                rRegistrationSubjects.Class := pNewClass;
                rRegistrationSubjects."Status Date" := pDate;
                rRegistrationSubjects.Validate(Enroled, true);
                rRegistrationSubjects."Class No." := LastNo + 1;

                rRegistrationSubjects."Mandatory/Optional Type" := rCourseLines."Mandatory/Optional Type";
                rRegistrationSubjects."Curriculum Type" := rCourseLines."Curriculum Type";
                rRegistrationSubjects."Evaluation Type" := rCourseLines."Evaluation Type";
                rRegistrationSubjects."Responsibility Center" := rCourseLines."Responsibility Center";
                rRegistrationSubjects."Maximum Injustified Absence" := rCourseLines."Maximum Unjustified Absences";
                rRegistrationSubjects."Assessment Code" := rCourseLines."Assessment Code";
                rRegistrationSubjects.Status := rRegistrationSubjects.Status::Subscribed;
                rRegistrationSubjects."Country/Region Code" := GetCountry;
                rRegistrationSubjects."Formation Component" := rCourseLines."Formation Component";
                rRegistrationSubjects."Option Group" := rCourseLines."Option Group";
                rRegistrationSubjects.Description := rCourseLines."Subject Description";
                rRegistrationSubjects."User Id" := UserId;
                rRegistrationSubjects.Date := WorkDate;
                rRegistrationSubjects."Sorting ID" := rCourseLines."Sorting ID";
                rRegistrationSubjects."Sub-subjects for assess. only" := rCourseLines."Sub-subjects for assess. only";
                rRegistrationSubjects."Legal Code" := rCourseLines."Legal Code";
                rRegistrationSubjects."Original Line No." := rCourseLines."Line No.";
                rRegistrationSubjects."Minimum Classification Level" := rCourseLines."Minimum Classification Level";
                rRegistrationSubjects."Continuous Assessment" := rCourseLines."Continuous Assessment";
                rRegistrationSubjects.Insert;


                if rCourseLines."Sub-Subject" then begin
                    rStudyPlanSubSubjectsLines.Reset;
                    rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::Course);
                    rStudyPlanSubSubjectsLines.SetRange(Code, rCourseLines.Code);
                    rStudyPlanSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                    rStudyPlanSubSubjectsLines.SetRange("Subject Code", rCourseLines."Subject Code");
                    if rStudyPlanSubSubjectsLines.Find('-') then begin
                        repeat
                            rStudentSubSubjectsPlan.Init;
                            rStudentSubSubjectsPlan."Student Code No." := pRegistration."Student Code No.";
                            rStudentSubSubjectsPlan."School Year" := pRegistration."School Year";
                            rStudentSubSubjectsPlan."Subject Code" := rStudyPlanSubSubjectsLines."Subject Code";
                            rStudentSubSubjectsPlan."Sub-Subject Code" := rStudyPlanSubSubjectsLines."Sub-Subject Code";
                            rStudentSubSubjectsPlan."Line No." := LastLineNo2;
                            rStudentSubSubjectsPlan.Code := rClass."Study Plan Code";
                            rStudentSubSubjectsPlan."Schooling Year" := rClass."Schooling Year";
                            rStudentSubSubjectsPlan.Description := rStudyPlanSubSubjectsLines.Description;
                            rStudentSubSubjectsPlan."Subject Description" := rStudyPlanSubSubjectsLines."Subject Description";
                            rStudentSubSubjectsPlan."Mandatory/Optional Type" := rStudyPlanSubSubjectsLines."Mandatory/Optional Type";
                            rStudentSubSubjectsPlan."Curriculum Type" := rStudyPlanSubSubjectsLines."Curriculum Type";
                            rStudentSubSubjectsPlan."Evaluation Type" := rStudyPlanSubSubjectsLines."Evaluation Type";
                            rStudentSubSubjectsPlan."Sub-Subject Description" := rStudyPlanSubSubjectsLines."Sub-Subject Description";
                            rStudentSubSubjectsPlan."Country/Region Code" := rStudyPlanSubSubjectsLines."Country/Region Code";
                            rStudentSubSubjectsPlan."Responsibility Center" := pRegistration."Responsibility Center";
                            rStudentSubSubjectsPlan."Maximum Injustified Absence" := rStudyPlanSubSubjectsLines."Maximum Injustified Absence";
                            rStudentSubSubjectsPlan."Assessment Code" := rStudyPlanSubSubjectsLines."Assessment Code";
                            rStudentSubSubjectsPlan."Minimum Classification Level" := rStudyPlanSubSubjectsLines."Minimum Classification Level";
                            rStudentSubSubjectsPlan."Characterise Subjects" := rStudyPlanSubSubjectsLines."Characterise Subjects";
                            rStudentSubSubjectsPlan."Maximum Total Absence" := rStudyPlanSubSubjectsLines."Maximum Total Absence";
                            rStudentSubSubjectsPlan.Type := rStudentSubSubjectsPlan.Type::Multi;
                            rStudentSubSubjectsPlan."User Id" := UserId;
                            rStudentSubSubjectsPlan.Date := WorkDate;
                            rStudentSubSubjectsPlan."Sorting ID" := rStudyPlanSubSubjectsLines."Sorting ID";
                            rStudentSubSubjectsPlan.Insert(true);
                        until rStudyPlanSubSubjectsLines.Next = 0;
                    end;
                end;
            end;
            //WEB
            cInsertNAVGeneralTable.InsertGTStudent(rRegistrationSubjects);
            //Entry
            StudentsSubjectsEntry(rRegistrationSubjects);

        end else begin
            if rClass.Get(pNewClass, pRegistration."School Year") then
                StudyPlanCode := rClass."Study Plan Code";

            rCourseLines.Reset;
            rCourseLines.SetRange(Code, StudyPlanCode);
            rCourseLines.SetRange("Subject Code", pSubjects);
            if rCourseLines.Find('-') then;

            rCourseLines.TestField("Assessment Code");
            rCourseLines.CalcFields("Sub-Subject");
            if rClass.Get(pNewClass, pRegistration."School Year") then
                StudyPlanCode := rClass."Study Plan Code";

            rRegistrationClass.Reset;
            rRegistrationClass.SetCurrentKey(rRegistrationClass."Class No.");
            rRegistrationClass.SetRange(Class, pNewClass);
            rRegistrationClass.SetRange("School Year", pRegistration."School Year");
            if rRegistrationClass.FindLast then begin
                LastNo := rRegistrationClass."Class No.";
                LastLineNo := rRegistrationClass."Line No.";
            end;

            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange("Student Code No.", pRegistration."Student Code No.");
            rRegistrationSubjects.SetRange("School Year", pRegistration."School Year");
            if rRegistrationSubjects.FindLast then
                LastLineNo2 := rRegistrationSubjects."Line No." + 10000
            else
                LastLineNo2 := 10000;

            rRegistrationSubjects.Init;
            rRegistrationSubjects."Student Code No." := pRegistration."Student Code No.";
            rRegistrationSubjects."School Year" := pRegistration."School Year";
            rRegistrationSubjects.Validate("Subjects Code", pSubjects);
            rRegistrationSubjects."Schooling Year" := pSchoolingYear;
            rRegistrationSubjects.Type := rRegistrationSubjects.Type::Multi;
            rRegistrationSubjects."Study Plan Code" := StudyPlanCode;
            rRegistrationSubjects.Class := pNewClass;
            rRegistrationSubjects.Validate(Enroled, true);
            rRegistrationSubjects."Class No." := LastNo + 1;
            rRegistrationSubjects.Status := rRegistrationSubjects.Status::Subscribed;
            rRegistrationSubjects."Country/Region Code" := GetCountry;
            rRegistrationSubjects."Line No." := LastLineNo2;
            rRegistrationSubjects."Mandatory/Optional Type" := rCourseLines."Mandatory/Optional Type";
            rRegistrationSubjects."Curriculum Type" := rCourseLines."Curriculum Type";
            rRegistrationSubjects."Evaluation Type" := rCourseLines."Evaluation Type";
            rRegistrationSubjects."Responsibility Center" := rCourseLines."Responsibility Center";
            rRegistrationSubjects."Maximum Injustified Absence" := rCourseLines."Maximum Unjustified Absences";
            rRegistrationSubjects."Assessment Code" := rCourseLines."Assessment Code";
            rRegistrationSubjects."Option Group" := rCourseLines."Option Group";
            rRegistrationSubjects.Description := rCourseLines."Subject Description";
            rRegistrationSubjects."User Id" := UserId;
            rRegistrationSubjects.Date := WorkDate;
            rRegistrationSubjects."Sorting ID" := rCourseLines."Sorting ID";
            rRegistrationSubjects."Sub-subjects for assess. only" := rCourseLines."Sub-subjects for assess. only";
            rRegistrationSubjects."Legal Code" := rCourseLines."Legal Code";
            rRegistrationSubjects."Original Line No." := rCourseLines."Line No.";
            rRegistrationSubjects."Minimum Classification Level" := rCourseLines."Minimum Classification Level";
            rRegistrationSubjects."Continuous Assessment" := rCourseLines."Continuous Assessment";

            rRegistrationSubjects.Insert;
            if rCourseLines."Sub-Subject" then begin
                rStudyPlanSubSubjectsLines.Reset;
                rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::Course);
                rStudyPlanSubSubjectsLines.SetRange(Code, rCourseLines.Code);
                rStudyPlanSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                rStudyPlanSubSubjectsLines.SetRange("Subject Code", rCourseLines."Subject Code");
                if rStudyPlanSubSubjectsLines.Find('-') then begin
                    repeat
                        rStudentSubSubjectsPlan.Init;
                        rStudentSubSubjectsPlan."Student Code No." := pRegistration."Student Code No.";
                        rStudentSubSubjectsPlan."School Year" := pRegistration."School Year";
                        rStudentSubSubjectsPlan."Subject Code" := rStudyPlanSubSubjectsLines."Subject Code";
                        rStudentSubSubjectsPlan."Sub-Subject Code" := rStudyPlanSubSubjectsLines."Sub-Subject Code";
                        rStudentSubSubjectsPlan.Code := rClass."Study Plan Code";
                        rStudentSubSubjectsPlan."Line No." := LastLineNo2;
                        rStudentSubSubjectsPlan."Schooling Year" := rClass."Schooling Year";
                        rStudentSubSubjectsPlan.Description := rStudyPlanSubSubjectsLines.Description;
                        rStudentSubSubjectsPlan."Subject Description" := rStudyPlanSubSubjectsLines."Subject Description";
                        rStudentSubSubjectsPlan."Mandatory/Optional Type" := rStudyPlanSubSubjectsLines."Mandatory/Optional Type";
                        rStudentSubSubjectsPlan."Curriculum Type" := rStudyPlanSubSubjectsLines."Curriculum Type";
                        rStudentSubSubjectsPlan."Evaluation Type" := rStudyPlanSubSubjectsLines."Evaluation Type";
                        rStudentSubSubjectsPlan."Sub-Subject Description" := rStudyPlanSubSubjectsLines."Sub-Subject Description";
                        rStudentSubSubjectsPlan."Country/Region Code" := rStudyPlanSubSubjectsLines."Country/Region Code";
                        rStudentSubSubjectsPlan."Responsibility Center" := pRegistration."Responsibility Center";
                        rStudentSubSubjectsPlan."Maximum Injustified Absence" := rStudyPlanSubSubjectsLines."Maximum Injustified Absence";
                        rStudentSubSubjectsPlan."Assessment Code" := rStudyPlanSubSubjectsLines."Assessment Code";
                        rStudentSubSubjectsPlan."Minimum Classification Level" := rStudyPlanSubSubjectsLines."Minimum Classification Level";
                        rStudentSubSubjectsPlan."Characterise Subjects" := rStudyPlanSubSubjectsLines."Characterise Subjects";
                        rStudentSubSubjectsPlan."Maximum Total Absence" := rStudyPlanSubSubjectsLines."Maximum Total Absence";
                        rStudentSubSubjectsPlan.Type := rStudentSubSubjectsPlan.Type::Multi;
                        rStudentSubSubjectsPlan."User Id" := UserId;
                        rStudentSubSubjectsPlan.Date := WorkDate;
                        rStudentSubSubjectsPlan."Sorting ID" := rStudyPlanSubSubjectsLines."Sorting ID";
                        rStudentSubSubjectsPlan.Insert(true);
                    until rStudyPlanSubSubjectsLines.Next = 0;
                end;
            end;

            //WEB
            cInsertNAVGeneralTable.InsertGTStudent(rRegistrationSubjects);
            //Entry
            StudentsSubjectsEntry(rRegistrationSubjects);
        end;
    end;

    //[Scope('OnPrem')]
    procedure CreateRecoverTest(pType: Integer)
    var
        rTest: Record Test;
        rRegisClass: Record "Registration Class";
        rRegisSubjects: Record "Registration Subjects";
        rEduConfiguration: Record "Edu. Configuration";
        cNoSeriesManage: Codeunit NoSeriesManagement;
        vNewDoc: Code[20];
        vShowForm: Boolean;
        fRecoverHeader: Page "Recover Header";
    begin
        rEduConfiguration.Get;
        vShowForm := false;

        if pType = 1 then begin
            rRegisClass.Reset;
            rRegisClass.SetRange("Recover Test", true);
            if rRegisClass.Find('-') then begin
                Clear(vNewDoc);
                rTest.Reset;
                rTest.Init;
                rTest."Test No." := cNoSeriesManage.GetNextNo(rEduConfiguration."Test Nos.", WorkDate, true);
                vNewDoc := rTest."Test No.";
                rTest."Line Type" := rTest."Line Type"::Header;
                rTest."School Year" := rRegisClass."School Year";
                rTest."Schooling Year" := rRegisClass."Schooling Year";
                rTest.Insert;

                repeat
                    rTest.Reset;
                    rTest.Init;
                    rTest."Test No." := vNewDoc;
                    rTest."Line Type" := rTest."Line Type"::Line;
                    rTest.Validate("Student No.", rRegisClass."Student Code No.");
                    rTest."School Year" := rRegisClass."School Year";
                    rTest."Schooling Year" := rRegisClass."Schooling Year";
                    rTest.Insert;

                    rRegisClass."Recover Test" := false;
                    rRegisClass.Modify;
                until rRegisClass.Next = 0;
                vShowForm := true;
            end;
        end;

        if pType = 2 then begin
            rRegisSubjects.Reset;
            rRegisSubjects.SetRange("Recover Test", true);
            if rRegisSubjects.Find('-') then begin
                Clear(vNewDoc);
                rTest.Reset;
                rTest.Init;
                rTest."Test No." := cNoSeriesManage.GetNextNo(rEduConfiguration."Test Nos.", WorkDate, true);
                vNewDoc := rTest."Test No.";
                rTest."Line Type" := rTest."Line Type"::Header;
                rTest."Type of Test" := rTest."Type of Test"::"Recover Test";
                //rTest."School Year"    := rRegisSubjects."School Year";
                //rTest."Schooling Year" := rRegisSubjects."Schooling Year";
                rTest.Insert;

                repeat
                    rTest.Reset;
                    rTest.Init;
                    rTest."Test No." := vNewDoc;
                    rTest."Line Type" := rTest."Line Type"::Line;
                    rTest.Validate("Student No.", rRegisSubjects."Student Code No.");
                    rTest."Type of Test" := rTest."Type of Test"::"Recover Test";
                    rTest.Insert;

                    rRegisSubjects."Recover Test" := false;
                    rRegisSubjects.Modify;
                until rRegisSubjects.Next = 0;
                vShowForm := true;
            end;
        end;

        rTest.Reset;
        rTest.SetRange("Test No.", vNewDoc);
        rTest.SetRange("Line Type", rTest."Line Type"::Header);
        if rTest.Find('-') then begin
            fRecoverHeader.SetTableView(rTest);
            fRecoverHeader.Run;
        end;
    end;

    //[Scope('OnPrem')]
    procedure StudentRegSubject(pRegistrationSubjects: Record "Registration Subjects"; pRegistration: Record Registration; pNewClass: Code[20]; pDate: Date)
    var
        rRegistrationClass: Record "Registration Class";
        rRegistrationClass2: Record "Registration Class";
        LastNo: Integer;
        LastLineNo: Integer;
        StudyPlanCode: Code[20];
        rStudents: Record Students;
        rClass: Record Class;
    begin
        if rClass.Get(pNewClass, pRegistrationSubjects."School Year") then
            StudyPlanCode := rClass."Study Plan Code";


        rRegistrationClass2.Reset;
        rRegistrationClass2.SetCurrentKey("Class No.");
        rRegistrationClass2.SetRange(Class, pNewClass);
        rRegistrationClass2.SetRange("School Year", pRegistrationSubjects."School Year");
        rRegistrationClass2.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
        rRegistrationClass2.SetRange("Student Code No.", pRegistration."Student Code No.");
        if not rRegistrationClass2.Find('-') then begin
            if pRegistration.Class <> pNewClass then begin

                rRegistrationClass.Reset;
                rRegistrationClass.SetCurrentKey(rRegistrationClass."Class No.");
                rRegistrationClass.SetRange(Class, pNewClass);
                rRegistrationClass.SetRange("School Year", pRegistrationSubjects."School Year");
                rRegistrationClass.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                if rRegistrationClass.Find('+') then begin
                    LastNo := rRegistrationClass."Class No.";
                    LastLineNo := rRegistrationClass."Line No.";
                end;


                rRegistrationClass.Reset;
                rRegistrationClass.SetRange(Class, pNewClass);
                rRegistrationClass.SetRange("School Year", pRegistrationSubjects."School Year");
                rRegistrationClass.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
                rRegistrationClass.SetRange("Student Code No.", pRegistration."Student Code No.");
                if not rRegistrationClass.Find('-') then begin
                    rRegistrationClass.Init;
                    rRegistrationClass.Class := pNewClass;
                    rRegistrationClass."School Year" := pRegistrationSubjects."School Year";
                    rRegistrationClass."Schooling Year" := pRegistrationSubjects."Schooling Year";
                    rRegistrationClass."Study Plan Code" := StudyPlanCode;
                    rRegistrationClass.Validate("Student Code No.", pRegistrationSubjects."Student Code No.");
                    if pRegistration."Study Plan Code" <> '' then
                        rRegistrationClass.Type := rRegistrationClass.Type::Simple
                    else
                        rRegistrationClass.Type := rRegistrationClass.Type::Multi;
                    if rStudents.Get(rRegistrationClass."Student Code No.") then begin
                        rRegistrationClass.Name := rStudents.Name;
                        rRegistrationClass."Last Name" := rStudents."Last Name";
                        rRegistrationClass."Last Name 2" := rStudents."Last Name 2";
                    end;
                    rRegistrationClass."Class No." := LastNo + 1;
                    rRegistrationClass."Line No." := LastLineNo + 10000;
                    rRegistrationClass."Status Date" := pDate;
                    rRegistrationClass.Status := rRegistrationClass.Status::Subscribed;

                    if rStudents.Get(pRegistration."Student Code No.") then
                        rRegistrationClass."Responsibility Center" := rStudents."Responsibility Center";

                    rRegistrationClass.Insert(true);
                    InsertStudents(rRegistrationClass);
                end;

                pRegistrationSubjects.Class := pNewClass;
                pRegistrationSubjects.Validate(Enroled, true);
                pRegistrationSubjects."Class No." := LastNo + 1;
                pRegistrationSubjects.Status := pRegistrationSubjects.Status::Subscribed;
                pRegistrationSubjects."Status Date" := pDate;
                pRegistrationSubjects."Study Plan Code" := StudyPlanCode;
                pRegistrationSubjects.Modify;
                //WEB
                cInsertNAVGeneralTable.InsertGTStudent(pRegistrationSubjects);
                //Entry
                StudentsSubjectsEntry(pRegistrationSubjects);

            end;

        end else begin
            rRegistrationClass.Reset;
            rRegistrationClass.SetCurrentKey(rRegistrationClass."Class No.");
            rRegistrationClass.SetRange(Class, pNewClass);
            rRegistrationClass.SetRange("School Year", pRegistrationSubjects."School Year");
            rRegistrationClass.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
            rRegistrationClass.SetRange("Student Code No.", pRegistrationSubjects."Student Code No.");
            if rRegistrationClass.Find('+') then begin
                LastNo := rRegistrationClass."Class No.";
                if pRegistrationSubjects.Status = pRegistrationSubjects.Status::" " then begin
                    rRegistrationClass.Status := rRegistrationClass.Status::Subscribed;
                    rRegistrationClass.Modify(true);
                end;


            end;
            pRegistrationSubjects.Class := pNewClass;
            pRegistrationSubjects.Validate(Enroled, true);
            pRegistrationSubjects."Class No." := LastNo;
            pRegistrationSubjects.Status := pRegistrationSubjects.Status::Subscribed;
            pRegistrationSubjects."Status Date" := pDate;
            pRegistrationSubjects."Study Plan Code" := StudyPlanCode;
            pRegistrationSubjects.Modify;
            //WEB
            cInsertNAVGeneralTable.InsertGTStudent(pRegistrationSubjects);
            //Entry
            StudentsSubjectsEntry(pRegistrationSubjects);

        end;
    end;

    //[Scope('OnPrem')]
    procedure ReNumberClassNo(pClass: Record Class; pRegistrationClass: Record "Registration Class")
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAbsence: Record Absence;
        rRegistration: Record Registration;
        rStudentSubjectsEntry: Record "Student Subjects Entry";
    begin
        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegistrationSubjects.SetRange("School Year", pClass."School Year");
        rRegistrationSubjects.SetRange("Schooling Year", pClass."Schooling Year");
        rRegistrationSubjects.SetRange(Class, pClass.Class);
        if rRegistrationSubjects.Find('-') then begin
            repeat
                rRegistrationSubjects."Class No." := pRegistrationClass."Class No.";
                rRegistrationSubjects.Modify;
            until rRegistrationSubjects.Next = 0;
        end;

        rAbsence.Reset;
        rAbsence.SetRange("School Year", pClass."School Year");
        rAbsence.SetRange("Student/Teacher Code No.", pRegistrationClass."Student Code No.");
        rAbsence.SetRange(Class, pClass.Class);
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
        if rAbsence.Find('-') then begin
            repeat
                rAbsence."Class No." := pRegistrationClass."Class No.";
                rAbsence.Modify;
            until rAbsence.Next = 0;
        end;


        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rRegistration.SetRange("School Year", pClass."School Year");
        rRegistration.SetRange("Schooling Year", pClass."Schooling Year");
        rRegistration.SetRange(Class, pClass.Class);
        if rRegistration.Find('-') then begin
            repeat
                rRegistration."Class No." := pRegistrationClass."Class No.";
                rRegistration.Modify;
            until rRegistration.Next = 0;
        end;


        rStudentSubjectsEntry.Reset;
        rStudentSubjectsEntry.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        rStudentSubjectsEntry.SetRange("School Year", pClass."School Year");
        rStudentSubjectsEntry.SetRange("Schooling Year", pClass."Schooling Year");
        rStudentSubjectsEntry.SetRange(Class, pClass.Class);
        if rStudentSubjectsEntry.Find('-') then begin
            repeat
                rStudentSubjectsEntry."Class No." := pRegistrationClass."Class No.";
                rStudentSubjectsEntry.Modify;
            until rStudentSubjectsEntry.Next = 0;
        end;


        rRegistrationClassEntry.Reset;
        rRegistrationClassEntry.SetRange(Class, pClass."Schooling Year");
        rRegistrationClassEntry.SetRange("School Year", pClass."School Year");
        rRegistrationClassEntry.SetRange("Schooling Year", pClass."Schooling Year");
        rRegistrationClassEntry.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
        if rRegistrationClassEntry.Find('-') then begin
            repeat
                rRegistrationClassEntry."Class No." := pRegistrationClass."Class No.";
                rRegistrationClassEntry.Modify;
            until rRegistrationClassEntry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetRespCenter(pRegistration: Record Registration): Text[100]
    var
        rStudent: Record Students;
    begin
        rStudent.Get(pRegistration."Student Code No.");
        exit(rStudent."Responsibility Center");
    end;

    //[Scope('OnPrem')]
    procedure GetLastClassLineNo(pRegistrationSubjects: Record "Registration Subjects"; var pLineNo: Integer; var pClassNo: Integer)
    var
        rRegistrationClass: Record "Registration Class";
    begin
        rRegistrationClass.Reset;
        rRegistrationClass.SetCurrentKey("Class No.");
        rRegistrationClass.SetRange(Class, pRegistrationSubjects.Class);
        rRegistrationClass.SetRange("School Year", pRegistrationSubjects."School Year");
        rRegistrationClass.SetRange("Schooling Year", pRegistrationSubjects."Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", pRegistrationSubjects."Study Plan Code");
        rRegistrationClass.SetRange(Type, pRegistrationSubjects.Type);
        if rRegistrationClass.Find('+') then begin
            pLineNo := rRegistrationClass."Line No." + 10000;
            pClassNo := rRegistrationClass."Class No." + 1;
        end else begin
            pLineNo := 10000;
            pClassNo := 1;
        end;
    end;

    //[Scope('OnPrem')]
    procedure StudentsSubjectsEntry(pRegistrationSubjects: Record "Registration Subjects")
    var
        l_StudentSubjectsEntry: Record "Student Subjects Entry";
    begin

        l_StudentSubjectsEntry.Init;
        l_StudentSubjectsEntry.TransferFields(pRegistrationSubjects);
        l_StudentSubjectsEntry."Entry No." := GetLastNoEntry + 1;
        l_StudentSubjectsEntry.Insert;
    end;

    //[Scope('OnPrem')]
    procedure GetLastNoEntry(): Integer
    var
        l_StudentSubjectsEntry: Record "Student Subjects Entry";
    begin
        l_StudentSubjectsEntry.Reset;
        if l_StudentSubjectsEntry.Find('+') then
            exit(l_StudentSubjectsEntry."Entry No.")
        else
            exit(0);
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubjectStudyPlan(pStudyPlanLines: Record "Study Plan Lines")
    var
        rStudentStudyPlan: Record "Registration Subjects";
        rRegistration: Record Registration;
        l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
        VarLineNo: Integer;
        text0001: Label 'Update Subject  \@1@@@@@@@@@@@@@@@@@@@@@';
    begin

        rRegistration.Reset;
        rRegistration.SetRange("School Year", pStudyPlanLines."School Year");
        //rRegistration.SETRANGE("Responsibility Center",pStudyPlanLines."Responsibility Center");
        rRegistration.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
        rRegistration.SetRange("Study Plan Code", pStudyPlanLines.Code);
        if rRegistration.Find('-') then begin
            Window.Open(text0001);
            Nreg := rRegistration.Count;
            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));

                VarLineNo := GetLastStudentLine(rRegistration."Student Code No.",
                                        pStudyPlanLines.Code, pStudyPlanLines."School Year", pStudyPlanLines."Schooling Year",
                                        pStudyPlanLines."Subject Code", pStudyPlanLines."Responsibility Center");
                if VarLineNo <> 0 then begin
                    rStudentStudyPlan.Init;
                    rStudentStudyPlan."Student Code No." := rRegistration."Student Code No.";
                    rStudentStudyPlan."School Year" := pStudyPlanLines."School Year";
                    rStudentStudyPlan."Line No." := VarLineNo + 10000;
                    rStudentStudyPlan."Schooling Year" := pStudyPlanLines."Schooling Year";
                    rStudentStudyPlan."Study Plan Code" := pStudyPlanLines.Code;
                    rStudentStudyPlan.Validate("Subjects Code", pStudyPlanLines."Subject Code");
                    rStudentStudyPlan.Description := pStudyPlanLines."Subject Description";
                    if pStudyPlanLines."Mandatory/Optional Type" = pStudyPlanLines."Mandatory/Optional Type"::Required then
                        rStudentStudyPlan.Validate(Enroled, true);
                    rStudentStudyPlan."Mandatory/Optional Type" := pStudyPlanLines."Mandatory/Optional Type";
                    rStudentStudyPlan."Curriculum Type" := pStudyPlanLines."Curriculum Type";
                    rStudentStudyPlan."Option Group" := pStudyPlanLines."Option Group";
                    rStudentStudyPlan."Evaluation Type" := pStudyPlanLines."Evaluation Type";
                    //rStudentStudyPlan."Responsibility Center" := pStudyPlanLines."Responsibility Center";
                    rStudentStudyPlan."Responsibility Center" := rRegistration."Responsibility Center";
                    rStudentStudyPlan."Evaluation Type" := pStudyPlanLines."Evaluation Type";
                    rStudentStudyPlan."Assessment Code" := pStudyPlanLines."Assessment Code";
                    rStudentStudyPlan."Minimum Classification Level" := pStudyPlanLines."Minimum Classification Level";
                    rStudentStudyPlan.Type := rStudentStudyPlan.Type::Simple;
                    rStudentStudyPlan."User Id" := UserId;
                    rStudentStudyPlan.Date := WorkDate;
                    rStudentStudyPlan."Sub-subjects for assess. only" := pStudyPlanLines."Sub-subjects for assess. only";
                    rStudentStudyPlan."Continuous Assessment" := pStudyPlanLines."Continuous Assessment";
                    rStudentStudyPlan."Country/Region Code" := pStudyPlanLines."Country/Region Code";
                    rStudentStudyPlan.Observations := pStudyPlanLines.Observations;
                    rStudentStudyPlan."Report Description" := pStudyPlanLines."Report Descripton";
                    rStudentStudyPlan."Sorting ID" := pStudyPlanLines."Sorting ID";
                    rStudentStudyPlan."Legal Reports Sorting ID" := pStudyPlanLines."Legal Reports Sorting ID";
                    rStudentStudyPlan.Insert;
                    if pStudyPlanLines.CalcFields("Sub-Subject") then begin
                        l_SPSubSubsLines.Reset;
                        l_SPSubSubsLines.SetRange(Type, l_SPSubSubsLines.Type::"Study Plan");
                        l_SPSubSubsLines.SetRange(Code, pStudyPlanLines.Code);
                        l_SPSubSubsLines.SetRange("School Year", pStudyPlanLines."School Year");
                        l_SPSubSubsLines.SetRange("Subject Code", pStudyPlanLines."Subject Code");
                        l_SPSubSubsLines.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
                        if l_SPSubSubsLines.Find('-') then begin
                            repeat
                                l_StudentSubSubPlan.Init;
                                l_StudentSubSubPlan."Student Code No." := rRegistration."Student Code No.";
                                l_StudentSubSubPlan."School Year" := pStudyPlanLines."School Year";
                                l_StudentSubSubPlan."Schooling Year" := pStudyPlanLines."Schooling Year";
                                l_StudentSubSubPlan."Subject Code" := pStudyPlanLines."Subject Code";
                                l_StudentSubSubPlan."Subject Description" := pStudyPlanLines."Subject Description";
                                l_StudentSubSubPlan."Sub-Subject Code" := l_SPSubSubsLines."Sub-Subject Code";
                                l_StudentSubSubPlan."Sub-Subject Description" := l_SPSubSubsLines."Sub-Subject Description";
                                l_StudentSubSubPlan.Code := l_SPSubSubsLines.Code;
                                l_StudentSubSubPlan."Mandatory/Optional Type" := l_SPSubSubsLines."Mandatory/Optional Type";
                                l_StudentSubSubPlan."Curriculum Type" := l_SPSubSubsLines."Curriculum Type";
                                l_StudentSubSubPlan."Evaluation Type" := l_SPSubSubsLines."Evaluation Type";
                                l_StudentSubSubPlan."Country/Region Code" := l_SPSubSubsLines."Country/Region Code";
                                //l_StudentSubSubPlan."Responsibility Center" := l_SPSubSubsLines."Responsibility Center";
                                l_StudentSubSubPlan."Responsibility Center" := rRegistration."Responsibility Center";
                                l_StudentSubSubPlan."Maximum Injustified Absence" := l_SPSubSubsLines."Maximum Injustified Absence";
                                l_StudentSubSubPlan."Assessment Code" := l_SPSubSubsLines."Assessment Code";
                                l_StudentSubSubPlan."Minimum Classification Level" := l_SPSubSubsLines."Minimum Classification Level";
                                l_StudentSubSubPlan."Characterise Subjects" := l_SPSubSubsLines."Characterise Subjects";
                                l_StudentSubSubPlan."Maximum Total Absence" := l_SPSubSubsLines."Maximum Total Absence";
                                l_StudentSubSubPlan."Sorting ID" := l_SPSubSubsLines."Sorting ID";
                                l_StudentSubSubPlan.Type := l_StudentSubSubPlan.Type::Simple;
                                l_StudentSubSubPlan."Line No." := VarLineNo + 10000;
                                l_StudentSubSubPlan."User Id" := UserId;
                                l_StudentSubSubPlan.Date := WorkDate;
                                l_StudentSubSubPlan.Insert(true);
                            until l_SPSubSubsLines.Next = 0;
                        end;
                    end;
                end;

                if (pStudyPlanLines."Mandatory/Optional Type" = pStudyPlanLines."Mandatory/Optional Type"::Required) and
                       (rRegistration.Status = rRegistration.Status::Subscribed) then
                    StudentRegSubject(rStudentStudyPlan, rRegistration, rRegistration.Class, WorkDate);

            until rRegistration.Next = 0;
            Window.Close;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetLastStudentLine(pStudentCode: Code[20]; pCode: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pSubject: Code[10]; pRespCenter: Code[10]): Integer
    var
        rRegistrationSubjects: Record "Registration Subjects";
        l_RegSubjects: Record "Registration Subjects";
    begin

        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("Student Code No.", pStudentCode);
        rRegistrationSubjects.SetRange("School Year", pSchoolYear);
        rRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
        rRegistrationSubjects.SetRange("Subjects Code", pSubject);
        rRegistrationSubjects.SetRange("Responsibility Center", pRespCenter);
        if not rRegistrationSubjects.FindSet then begin
            l_RegSubjects.Reset;
            l_RegSubjects.SetRange("Student Code No.", pStudentCode);
            l_RegSubjects.SetRange("School Year", pSchoolYear);
            if l_RegSubjects.FindLast then
                exit(l_RegSubjects."Line No.")
            else
                exit(0);
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubjectsCourse(pCourseLines: Record "Course Lines"; pSchoolYear: Code[9]; pSchoolingYear: Code[10])
    var
        l_recRegSubServ: Record "Registration Subjects";
        l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
        rRegistration: Record Registration;
        text0001: Label 'Update Subject  \@1@@@@@@@@@@@@@@@@@@@@@';
        VarLineNo: Integer;
        rEduConfiguration: Record "Edu. Configuration";
    begin


        rRegistration.Reset;
        rRegistration.SetRange("School Year", pSchoolYear);
        rRegistration.SetRange("Responsibility Center", pCourseLines."Responsibility Center");
        rRegistration.SetRange("Schooling Year", pSchoolingYear);
        rRegistration.SetRange(Course, pCourseLines.Code);
        if rRegistration.Find('-') then begin
            rEduConfiguration.Get;
            Window.Open(text0001);
            Nreg := rRegistration.Count;
            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));

                VarLineNo := GetLastStudentLine(rRegistration."Student Code No.", pCourseLines.Code,
                                pSchoolYear, pSchoolingYear, pCourseLines."Subject Code", pCourseLines."Responsibility Center");
                if VarLineNo <> 0 then begin




                    l_recRegSubServ.Init;
                    l_recRegSubServ."Student Code No." := rRegistration."Student Code No.";
                    l_recRegSubServ."School Year" := pSchoolYear;
                    l_recRegSubServ."Line No." := VarLineNo + 10000;
                    l_recRegSubServ."Schooling Year" := pSchoolingYear;
                    l_recRegSubServ."Study Plan Code" := pCourseLines.Code;
                    l_recRegSubServ."Subjects Code" := pCourseLines."Subject Code";
                    l_recRegSubServ.Description := pCourseLines."Subject Description";
                    if rEduConfiguration."Use Formation Component" then begin
                        if pCourseLines."Formation Component" = pCourseLines."Formation Component"::General then
                            l_recRegSubServ.Validate(Enroled, true);
                    end else begin
                        if pCourseLines."Mandatory/Optional Type" = pCourseLines."Mandatory/Optional Type"::Required then
                            l_recRegSubServ.Validate(Enroled, true);
                    end;
                    l_recRegSubServ."Mandatory/Optional Type" := pCourseLines."Mandatory/Optional Type";
                    l_recRegSubServ."Curriculum Type" := pCourseLines."Curriculum Type";
                    l_recRegSubServ."Evaluation Type" := pCourseLines."Evaluation Type";
                    l_recRegSubServ."Country/Region Code" := GetCountry;
                    l_recRegSubServ."Responsibility Center" := pCourseLines."Responsibility Center";
                    l_recRegSubServ."Maximum Injustified Absence" := pCourseLines."Maximum Unjustified Absences";
                    l_recRegSubServ."Assessment Code" := pCourseLines."Assessment Code";
                    l_recRegSubServ."Option Group" := pCourseLines."Option Group";
                    l_recRegSubServ."Formation Component" := pCourseLines."Formation Component";
                    l_recRegSubServ."Characterise Subjects" := pCourseLines."Characterise Subjects";
                    l_recRegSubServ."Country/Region Code" := pCourseLines."Country/Region Code";
                    l_recRegSubServ."Responsibility Center" := pCourseLines."Responsibility Center";
                    l_recRegSubServ."Maximum Justified Absence" := pCourseLines."Maximum Justified Absence";
                    l_recRegSubServ."User Id" := UserId;
                    l_recRegSubServ.Date := WorkDate;
                    l_recRegSubServ.Type := l_recRegSubServ.Type::Multi;
                    l_recRegSubServ."Sub-subjects for assess. only" := pCourseLines."Sub-subjects for assess. only";
                    l_recRegSubServ."Original Line No." := pCourseLines."Line No.";
                    l_recRegSubServ."Continuous Assessment" := pCourseLines."Continuous Assessment";
                    l_recRegSubServ."Minimum Classification Level" := pCourseLines."Minimum Classification Level";
                    l_recRegSubServ.Insert;


                    if pCourseLines.CalcFields("Sub-Subject") then begin
                        l_SPSubSubsLines.Reset;
                        l_SPSubSubsLines.SetRange(Type, l_SPSubSubsLines.Type::Course);
                        l_SPSubSubsLines.SetRange(Code, pCourseLines.Code);
                        l_SPSubSubsLines.SetRange("Subject Code", pCourseLines."Subject Code");
                        l_SPSubSubsLines.SetRange("Schooling Year", pSchoolingYear);
                        l_SPSubSubsLines.SetRange("Line No.", pCourseLines."Line No.");
                        if l_SPSubSubsLines.Find('-') then begin
                            repeat
                                l_StudentSubSubPlan.Init;
                                l_StudentSubSubPlan."Student Code No." := rRegistration."Student Code No.";
                                l_StudentSubSubPlan."School Year" := pSchoolYear;
                                l_StudentSubSubPlan."Schooling Year" := pSchoolingYear;
                                l_StudentSubSubPlan."Subject Code" := pCourseLines."Subject Code";
                                l_StudentSubSubPlan."Subject Description" := pCourseLines."Subject Description";
                                l_StudentSubSubPlan."Sub-Subject Code" := l_SPSubSubsLines."Sub-Subject Code";
                                l_StudentSubSubPlan."Sub-Subject Description" := l_SPSubSubsLines."Sub-Subject Description";
                                l_StudentSubSubPlan.Code := l_SPSubSubsLines.Code;
                                l_StudentSubSubPlan."Mandatory/Optional Type" := l_SPSubSubsLines."Mandatory/Optional Type";
                                l_StudentSubSubPlan."Curriculum Type" := l_SPSubSubsLines."Curriculum Type";
                                l_StudentSubSubPlan."Evaluation Type" := l_SPSubSubsLines."Evaluation Type";
                                l_StudentSubSubPlan."Country/Region Code" := pCourseLines."Country/Region Code";
                                l_StudentSubSubPlan."Responsibility Center" := l_SPSubSubsLines."Responsibility Center";
                                l_StudentSubSubPlan."Maximum Injustified Absence" := l_SPSubSubsLines."Maximum Injustified Absence";
                                l_StudentSubSubPlan."Assessment Code" := l_SPSubSubsLines."Assessment Code";
                                l_StudentSubSubPlan."Minimum Classification Level" := l_SPSubSubsLines."Minimum Classification Level";
                                l_StudentSubSubPlan."Characterise Subjects" := l_SPSubSubsLines."Characterise Subjects";
                                l_StudentSubSubPlan."Maximum Total Absence" := l_SPSubSubsLines."Maximum Total Absence";
                                l_StudentSubSubPlan.Type := l_StudentSubSubPlan.Type::Multi;
                                l_StudentSubSubPlan."Line No." := VarLineNo + 10000;
                                l_StudentSubSubPlan."User Id" := UserId;
                                l_StudentSubSubPlan.Date := WorkDate;
                                l_StudentSubSubPlan.Insert;
                            until l_SPSubSubsLines.Next = 0;
                        end;
                    end;
                end;
                if rEduConfiguration."Use Formation Component" then begin
                    if (pCourseLines."Formation Component" = pCourseLines."Formation Component"::General) and
                       (rRegistration.Status = rRegistration.Status::Subscribed) then
                        StudentRegSubject(l_recRegSubServ, rRegistration, rRegistration.Class, WorkDate);

                end else begin
                    if (pCourseLines."Mandatory/Optional Type" = pCourseLines."Mandatory/Optional Type"::Required) and
                           (rRegistration.Status = rRegistration.Status::Subscribed) then
                        StudentRegSubject(l_recRegSubServ, rRegistration, rRegistration.Class, WorkDate);
                end;

            until rRegistration.Next = 0;

            Window.Close;

        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateSubSubjectsCourse(pStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines"; pSchoolYear: Code[9]; pSchoolingYear: Code[10])
    var
        l_recRegSubServ: Record "Registration Subjects";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
        rRegistration: Record Registration;
        text0001: Label 'Update Subject  \@1@@@@@@@@@@@@@@@@@@@@@';
        rRegistrationSubjects: Record "Registration Subjects";
        rEduConfiguration: Record "Edu. Configuration";
        text0002: Label 'The student %1 does not have the Subject %2 in ther Study Plan, you must aplly first he subject has new.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
    begin
        rRegistration.Reset;
        rRegistration.SetRange("School Year", pSchoolYear);
        rRegistration.SetRange("Responsibility Center", pStudyPlanSubSubjectsLines."Responsibility Center");
        rRegistration.SetRange("Schooling Year", pSchoolingYear);
        if pStudyPlanSubSubjectsLines.Type = pStudyPlanSubSubjectsLines.Type::Course then
            rRegistration.SetRange(Course, pStudyPlanSubSubjectsLines.Code)
        else
            rRegistration.SetRange("Study Plan Code", pStudyPlanSubSubjectsLines.Code);
        rRegistration.SetRange(Type, pStudyPlanSubSubjectsLines.Type);
        if rRegistration.Find('-') then begin
            rEduConfiguration.Get;
            Window.Open(text0001);
            Nreg := rRegistration.Count;
            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));

                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                rRegistrationSubjects.SetRange("School Year", pSchoolYear);
                rRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
                rRegistrationSubjects.SetRange("Subjects Code", pStudyPlanSubSubjectsLines."Subject Code");
                rRegistrationSubjects.SetRange("Responsibility Center", pStudyPlanSubSubjectsLines."Responsibility Center");
                rRegistrationSubjects.SetRange("Original Line No.", pStudyPlanSubSubjectsLines."Line No.");
                if rRegistrationSubjects.FindSet then begin


                    l_StudentSubSubPlan.Init;
                    l_StudentSubSubPlan."Student Code No." := rRegistration."Student Code No.";
                    l_StudentSubSubPlan."School Year" := pSchoolYear;
                    l_StudentSubSubPlan."Schooling Year" := pSchoolingYear;
                    l_StudentSubSubPlan."Subject Code" := pStudyPlanSubSubjectsLines."Subject Code";
                    l_StudentSubSubPlan."Subject Description" := pStudyPlanSubSubjectsLines."Subject Description";
                    l_StudentSubSubPlan."Sub-Subject Code" := pStudyPlanSubSubjectsLines."Sub-Subject Code";
                    l_StudentSubSubPlan."Sub-Subject Description" := pStudyPlanSubSubjectsLines."Sub-Subject Description";
                    l_StudentSubSubPlan.Code := pStudyPlanSubSubjectsLines.Code;
                    l_StudentSubSubPlan."Mandatory/Optional Type" := pStudyPlanSubSubjectsLines."Mandatory/Optional Type";
                    l_StudentSubSubPlan."Curriculum Type" := pStudyPlanSubSubjectsLines."Curriculum Type";
                    l_StudentSubSubPlan."Evaluation Type" := pStudyPlanSubSubjectsLines."Evaluation Type";
                    l_StudentSubSubPlan."Country/Region Code" := pStudyPlanSubSubjectsLines."Country/Region Code";
                    l_StudentSubSubPlan."Responsibility Center" := pStudyPlanSubSubjectsLines."Responsibility Center";
                    l_StudentSubSubPlan."Maximum Injustified Absence" := pStudyPlanSubSubjectsLines."Maximum Injustified Absence";
                    l_StudentSubSubPlan."Assessment Code" := pStudyPlanSubSubjectsLines."Assessment Code";
                    l_StudentSubSubPlan."Minimum Classification Level" := pStudyPlanSubSubjectsLines."Minimum Classification Level";
                    l_StudentSubSubPlan."Characterise Subjects" := pStudyPlanSubSubjectsLines."Characterise Subjects";
                    l_StudentSubSubPlan."Maximum Total Absence" := pStudyPlanSubSubjectsLines."Maximum Total Absence";
                    l_StudentSubSubPlan.Type := pStudyPlanSubSubjectsLines.Type;
                    l_StudentSubSubPlan."Line No." := rRegistrationSubjects."Line No.";
                    l_StudentSubSubPlan."User Id" := UserId;
                    l_StudentSubSubPlan.Date := WorkDate;
                    if l_StudentSubSubPlan.Insert then begin
                        if rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed then
                            cInsertNAVGeneralTable.InsGenTableSubSubjetcAddiciona(rRegistrationSubjects, l_StudentSubSubPlan);
                    end else
                        l_StudentSubSubPlan.Modify(true);


                end else
                    Error(text0002, rRegistration."Student Code No.", pStudyPlanSubSubjectsLines."Subject Code");


            until rRegistration.Next = 0;

            Window.Close;

        end;
    end;

    //[Scope('OnPrem')]
    procedure EncyptPassword(InText: Text[250])
    var
        EncryptMgt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        /*CREATE(das);
        MESSAGE(das.CalculateMD5(InText));*/
        //message(das.CalcMD5(intext));
        EncryptMgt.GenerateHash(InText, HashAlgorithmType::MD5);

    end;
}

