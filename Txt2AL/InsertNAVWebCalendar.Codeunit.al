codeunit 31009766 InsertNAVWebCalendar
{
    Permissions = TableData Absence = rimd,
                  TableData "WEB Absence" = rimd,
                  TableData GeneralTable = rimd,
                  TableData GeneralTableAspects = rimd,
                  TableData MasterTableWEB = rimd,
                  TableData "Web Calendar" = rimd,
                  TableData "Web Calendar Students" = rimd;

    trigger OnRun()
    begin
    end;

    var
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;

    //[Scope('OnPrem')]
    procedure InsertCalendar(pCalendar: Record Calendar; var pID: Integer)
    var
        rCalendar: Record Calendar;
        rWebCalendar: Record "Web Calendar";
        rClass: Record Class;
        rCompanyInformation: Record "Company Information";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if rCompanyInformation.Get then;

        Clear(rWebCalendar);
        rWebCalendar.Init;
        rWebCalendar."School Year" := pCalendar."School Year";
        rWebCalendar."Study Plan" := pCalendar."Study Plan";
        rWebCalendar.Class := pCalendar.Class;
        if rClass.Get(pCalendar.Class, pCalendar."School Year") then;
        rWebCalendar."Schooling Year" := rClass."Schooling Year";
        rWebCalendar."Country/Region Code" := rClass."Country/Region Code";
        rWebCalendar."Timetable Code" := pCalendar."Timetable Code";
        rWebCalendar."Filter Period" := pCalendar."Filter Period";
        rWebCalendar."Week Day" := pCalendar."Week Day";
        rWebCalendar.Subject := pCalendar.Subject;
        rWebCalendar."Subject Description" := pCalendar."Subject Description";
        rWebCalendar."Start Hour" := pCalendar."Start Hour";
        rWebCalendar."End Hour" := pCalendar."End Hour";
        rWebCalendar."Period No." := GetWeek(pCalendar."Filter Period");
        rWebCalendar."Absence Type" := pCalendar."Absence Type";
        rWebCalendar.Type := pCalendar.Type;
        rWebCalendar.Turn := pCalendar.Turn;
        rWebCalendar."Sub-Subject Code" := pCalendar."Sub-Subject Code";
        if pCalendar."Sub-Subject Code" = rWebCalendar.Subject then
            rWebCalendar."Sub-Subject Description" := rWebCalendar."Subject Description"
        else
            rWebCalendar."Sub-Subject Description" := GetSubSubjectDescription(pCalendar, rClass."Schooling Year");
        rWebCalendar."Class Description" := pCalendar."Class Description";
        rWebCalendar."Type Subject" := pCalendar."Type Subject";
        rWebCalendar."Line No." := pCalendar."Line No.";

        /*if (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"1 Connection") or
        (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"2 Connection") then
            rWebCalendar."Action Type" := rWebCalendar."Action Type"::Insert;

        if (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"2 Connection") then
            rWebCalendar."Action Type 2" := rWebCalendar."Action Type 2"::Insert;*/

        rWebCalendar.Insert;

        pID := rWebCalendar.ID;
    end;

    //[Scope('OnPrem')]
    procedure DeleteCalendar(pCalendar: Record Calendar)
    var
        rWebCalendar: Record "Web Calendar";
        rCompanyInformation: Record "Company Information";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        if rCompanyInformation.Get then;

        //Valida se a as linhas ainda nao foram inseridas no portal, e nesse caso apaga
        if rWebCalendar.Get(pCalendar."Web ID") then begin
            /*if (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"1 Connection") or
            (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"2 Connection") then
                if rWebCalendar."Action Type" = rWebCalendar."Action Type"::Insert then
                    rWebCalendar.Delete(true);*/
        end;

        if rWebCalendar.Get(pCalendar."Web ID") then begin
            /*if (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"1 Connection") or
            (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"2 Connection") then
                rWebCalendar."Action Type" := rWebCalendar."Action Type"::Delete;

            if (rCompanyInformation."Connection Type" = rCompanyInformation."Connection Type"::"2 Connection") then
                rWebCalendar."Action Type 2" := rWebCalendar."Action Type 2"::Delete;*/

            rWebCalendar.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertStudentCalendar(pWebCalendar: Record "Web Calendar")
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rWCalendarStudents: Record "Web Calendar Students";
        rStudSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        rRegistrationSubjects.Reset;
        rRegistrationSubjects.SetRange("School Year", pWebCalendar."School Year");
        rRegistrationSubjects.SetRange("Subjects Code", pWebCalendar.Subject);
        rRegistrationSubjects.SetRange("Schooling Year", pWebCalendar."Schooling Year");
        rRegistrationSubjects.SetRange(Class, pWebCalendar.Class);
        rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
        if pWebCalendar."Sub-Subject Code" = '' then begin
            rRegistrationSubjects.SetRange(Turn, pWebCalendar.Turn);
        end;
        if rRegistrationSubjects.Find('-') then begin
            repeat
                rRegistrationSubjects.CalcFields("Sub-subject");
                if rRegistrationSubjects."Sub-subject" then begin
                    rStudSubSubjectsPlan.Reset;
                    rStudSubSubjectsPlan.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                    rStudSubSubjectsPlan.SetRange("Schooling Year", pWebCalendar."Schooling Year");
                    rStudSubSubjectsPlan.SetRange("School Year", pWebCalendar."School Year");
                    rStudSubSubjectsPlan.SetRange("Subject Code", pWebCalendar.Subject);
                    rStudSubSubjectsPlan.SetRange("Sub-Subject Code", pWebCalendar."Sub-Subject Code");
                    rStudSubSubjectsPlan.SetRange(Turn, pWebCalendar.Turn);
                    if rStudSubSubjectsPlan.Find('-') then begin
                        repeat
                            InsertSC(pWebCalendar.ID, rStudSubSubjectsPlan."Student Code No.");
                        until rStudSubSubjectsPlan.Next = 0;
                    end;
                end else
                    InsertSC(pWebCalendar.ID, rRegistrationSubjects."Student Code No.");
            until rRegistrationSubjects.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteStudentCalendar(pWebCalendar: Record "Web Calendar")
    var
        WebCalendarStudents: Record "Web Calendar Students";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        WebCalendarStudents.Reset;
        WebCalendarStudents.SetRange("ID Web Calendar", pWebCalendar.ID);
        if WebCalendarStudents.Find('-') then
            WebCalendarStudents.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure InsertSC(pIDCalendar: Integer; pStudentCode: Code[20])
    var
        rWCalendarStudents: Record "Web Calendar Students";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        Clear(rWCalendarStudents);
        rWCalendarStudents.Init;
        rWCalendarStudents."ID Web Calendar" := pIDCalendar;
        rWCalendarStudents."Student Code No." := pStudentCode;
        rWCalendarStudents.Insert;
    end;

    //[Scope('OnPrem')]
    procedure GetLastID(): Integer
    var
        rWebCalendar: Record "Web Calendar";
    begin
        rWebCalendar.Reset;
        if rWebCalendar.Find('+') then
            exit(rWebCalendar.ID + 1)
        else
            exit(1);
    end;

    //[Scope('OnPrem')]
    procedure GetWeek(pDate: Date): Integer
    var
        rDate: Record Date;
        DateEnd: Date;
    begin
        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Week);
        rDate.SetFilter("Period Start", '<=%1', pDate);
        if rDate.Find('+') then
            exit(rDate."Period No.");
    end;

    //[Scope('OnPrem')]
    procedure GetLastIDStudent(): Integer
    var
        rWCalendarStudents: Record "Web Calendar Students";
    begin
        rWCalendarStudents.Reset;
        if rWCalendarStudents.Find('+') then
            exit(rWCalendarStudents.ID + 1)
        else
            exit(1);
    end;

    //[Scope('OnPrem')]
    procedure GetSubSubjectDescription(pCalendar: Record Calendar; pScholingYear: Code[10]): Text[100]
    var
        StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
    begin
        StudyPlanSubSubjectsLines.Reset;
        StudyPlanSubSubjectsLines.SetRange(Type, pCalendar.Type);
        StudyPlanSubSubjectsLines.SetRange(Code, pCalendar."Study Plan");
        StudyPlanSubSubjectsLines.SetRange("Schooling Year", pScholingYear);
        StudyPlanSubSubjectsLines.SetRange("Subject Code", pCalendar.Subject);
        StudyPlanSubSubjectsLines.SetRange("Sub-Subject Code", pCalendar."Sub-Subject Code");
        if pCalendar.Type = pCalendar.Type::Simple then
            StudyPlanSubSubjectsLines.SetRange("School Year", pCalendar."School Year");
        if StudyPlanSubSubjectsLines.Find('-') then
            exit(StudyPlanSubSubjectsLines."Sub-Subject Description");
    end;

    //[Scope('OnPrem')]
    procedure InsertModAbsence(pNewAbsence: Record Absence; poldAbsence: Record Absence)
    var
        WEBAbsence: Record "WEB Absence";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        WEBAbsence.Reset;
        WEBAbsence.SetRange("Timetable Code", pNewAbsence."Timetable Code");
        WEBAbsence.SetRange("School Year", pNewAbsence."School Year");
        WEBAbsence.SetRange("Study Plan", pNewAbsence."Study Plan");
        WEBAbsence.SetRange(Class, pNewAbsence.Class);
        WEBAbsence.SetRange(Day, pNewAbsence.Day);
        WEBAbsence.SetRange(Type, pNewAbsence.Type);
        WEBAbsence.SetRange("Line No. Timetable", pNewAbsence."Line No. Timetable");
        WEBAbsence.SetRange("Incidence Type", pNewAbsence."Incidence Type");
        WEBAbsence.SetRange("Incidence Code", pNewAbsence."Incidence Code");
        WEBAbsence.SetRange(Category, pNewAbsence.Category);
        WEBAbsence.SetRange("Subcategory Code", pNewAbsence."Subcategory Code");
        WEBAbsence.SetRange("Student/Teacher", pNewAbsence."Student/Teacher");
        WEBAbsence.SetRange("Student/Teacher Code No.", pNewAbsence."Student/Teacher Code No.");
        WEBAbsence.SetRange("Responsibility Center", pNewAbsence."Responsibility Center");
        WEBAbsence.SetRange("Line No.", pNewAbsence."Line No.");
        if not WEBAbsence.FindSet(true, true) then begin
            WEBAbsence.Init;
            WEBAbsence.TransferFields(pNewAbsence);
            WEBAbsence."Action Type" := WEBAbsence."Action Type"::Insert;
            WEBAbsence."Action Type 2" := WEBAbsence."Action Type 2"::Insert;
            WEBAbsence.Insert;
        end else begin
            WEBAbsence.TransferFields(pNewAbsence);

            if (WEBAbsence."Action Type" = WEBAbsence."Action Type"::" ") or
              (WEBAbsence."Action Type" = WEBAbsence."Action Type"::Delete) then
                WEBAbsence."Action Type" := WEBAbsence."Action Type"::Update;

            if (WEBAbsence."Action Type 2" = WEBAbsence."Action Type 2"::" ") or
              (WEBAbsence."Action Type 2" = WEBAbsence."Action Type 2"::Delete) then
                WEBAbsence."Action Type 2" := WEBAbsence."Action Type 2"::Update;

            WEBAbsence.Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteAbsence(pNewAbsence: Record Absence; poldAbsence: Record Absence)
    var
        WEBAbsence: Record "WEB Absence";
    begin
        if cInsertNAVGeneralTable.ValidateWeb = 0 then
            exit;

        WEBAbsence.Reset;
        WEBAbsence.SetRange("Timetable Code", pNewAbsence."Timetable Code");
        WEBAbsence.SetRange("School Year", pNewAbsence."School Year");
        WEBAbsence.SetRange("Study Plan", pNewAbsence."Study Plan");
        WEBAbsence.SetRange(Class, pNewAbsence.Class);
        WEBAbsence.SetRange(Day, pNewAbsence.Day);
        WEBAbsence.SetRange(Type, pNewAbsence.Type);
        WEBAbsence.SetRange("Line No. Timetable", pNewAbsence."Line No. Timetable");
        WEBAbsence.SetRange("Incidence Type", pNewAbsence."Incidence Type");
        WEBAbsence.SetRange("Incidence Code", pNewAbsence."Incidence Code");
        WEBAbsence.SetRange(Category, pNewAbsence.Category);
        WEBAbsence.SetRange("Subcategory Code", pNewAbsence."Subcategory Code");
        WEBAbsence.SetRange("Student/Teacher", pNewAbsence."Student/Teacher");
        WEBAbsence.SetRange("Student/Teacher Code No.", pNewAbsence."Student/Teacher Code No.");
        WEBAbsence.SetRange("Responsibility Center", pNewAbsence."Responsibility Center");
        WEBAbsence.SetRange("Line No.", pNewAbsence."Line No.");
        if WEBAbsence.FindSet(true, true) then begin

            if WEBAbsence."Action Type" = WEBAbsence."Action Type"::Insert then begin
                WEBAbsence.Delete;
                exit;
            end;

            if WEBAbsence."Action Type" <> WEBAbsence."Action Type"::Insert then
                WEBAbsence."Action Type" := WEBAbsence."Action Type"::Delete;

            if WEBAbsence."Action Type 2" <> WEBAbsence."Action Type 2"::Insert then
                WEBAbsence."Action Type 2" := WEBAbsence."Action Type 2"::Delete;

            WEBAbsence.Modify;
        end;
    end;
}

