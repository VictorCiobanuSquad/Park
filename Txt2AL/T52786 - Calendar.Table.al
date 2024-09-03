table 52786 Calendar
{
    Caption = 'Calendar';
    Permissions = TableData Absence = rimd;

    fields
    {
        field(1; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Study Plan"; Code[20])
        {
            Caption = 'Study Plan';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(4; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Study Plan Description"; Text[30])
        {
            Caption = 'Study Plan Description';
        }
        field(7; "Class Description"; Text[30])
        {
            Caption = 'Class Description';
        }
        field(8; "Filter Period"; Date)
        {
            Caption = 'Filter Period';
        }
        field(9; "Week Day"; Option)
        {
            Caption = 'Week Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(12; Subject; Code[10])
        {
            Caption = 'Subject';
            TableRelation = IF ("Type Subject" = FILTER(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE
            IF ("Type Subject" = FILTER("Non scholar component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF ("Type Subject" = FILTER("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

            trigger OnLookup()
            var
                rClass: Record Class;
                rStruEduCountry: Record "Structure Education Country";
                l_rStruEduCountry: Record "Structure Education Country";
                l_rHorarioProfessorLinhas: Record "Teacher Timetable Lines";
                cStudentsRegistration: Codeunit "Students Registration";
            begin
                if rHorario.Get("Timetable Code") then begin
                    if ("Type Subject" = "Type Subject"::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
                    (rHorario.Type = rHorario.Type::Simple) then begin
                        rStudyPlanLines.Reset;
                        rStudyPlanLines.SetRange(Code, rHorario."Study Plan");
                        rStudyPlanLines.SetRange("School Year", rHorario."School Year");
                        if rStudyPlanLines.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Study Plan Subjects", rStudyPlanLines) = ACTION::LookupCancel then begin
                                Validate(Subject, rStudyPlanLines."Subject Code");
                                "Sub-Subject Code" := '';
                            end;
                        end;
                    end;
                    if ("Type Subject" = "Type Subject"::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
                      (rHorario.Type = rHorario.Type::Multi) then begin

                        rCourseLinesTEMP.Reset;
                        rCourseLinesTEMP.DeleteAll;

                        //Quadriennal
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, rHorario."Study Plan");
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                        if rCourseLines.Find('-') then begin
                            repeat
                                rCourseLinesTEMP.Init;
                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                rCourseLinesTEMP.Insert;
                            until rCourseLines.Next = 0;
                        end;

                        //Anual
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, rHorario."Study Plan");
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                        if rClass.Get(rHorario.Class, rHorario."School Year") then
                            rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                rCourseLinesTEMP.Init;
                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                rCourseLinesTEMP.Insert;
                            until rCourseLines.Next = 0;
                        end;

                        //Bienal E Triennal
                        rStruEduCountry.Reset;
                        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                        if rClass.Get(rHorario.Class, rHorario."School Year") then
                            rStruEduCountry.SetRange("Schooling Year", rClass."Schooling Year");
                        if rStruEduCountry.Find('-') then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, rHorario."Study Plan");
                            rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                            rCourseLines."Characterise Subjects"::Triennial);
                            rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;
                            //ELSE BEGIN
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(rHorario.Class, rHorario."School Year") - 1);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, rHorario."Study Plan");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(rHorario.Class, rHorario."School Year") - 2);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, rHorario."Study Plan");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(rHorario.Class, rHorario."School Year") - 1);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, rHorario."Study Plan");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;


                            //END;
                        end;


                        rCourseLinesTEMP.Reset;
                        rCourseLinesTEMP.SetRange(Code, rHorario."Study Plan");
                        if rCourseLinesTEMP.Find('-') then
                            if PAGE.RunModal(PAGE::"Study Course Subjects", rCourseLinesTEMP) = ACTION::LookupCancel then begin
                                Validate(Subject, rCourseLinesTEMP."Subject Code");
                                "Sub-Subject Code" := '';
                            end;
                    end;
                    if "Type Subject" = "Type Subject"::"Non scholar component" then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, "Type Subject");
                        if recSubject.Find('-') then
                            if PAGE.RunModal(PAGE::"Non lective component List", recSubject) = ACTION::LookupCancel then begin
                                Validate(Subject, recSubject.Code);
                                "Sub-Subject Code" := '';
                            end;
                    end;
                    if "Type Subject" = "Type Subject"::"Non scholar hours" then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, "Type Subject"::"Non scholar hours");
                        if recSubject.Find('-') then;
                        if PAGE.RunModal(PAGE::"Non Scholar hours", recSubject) = ACTION::LookupCancel then begin
                            Validate(Subject, recSubject.Code);
                            "Sub-Subject Code" := '';
                        end;
                    end;
                end;
            end;
        }
        field(13; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
        }
        field(14; "Start Hour"; Time)
        {
            Caption = 'Start Hour';

            trigger OnValidate()
            begin
                if ("Filter Period" < "End Day") and ("Filter Period" <> 0D) and ("End Day" <> 0D) then begin
                    if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                        "Break (Hours)" := ((230000T - "Start Hour") / 3600000) + 1 + (("End Hour" - 000000T) / 3600000) +
                                               ((("End Day" - "Filter Period") - 1) * 24);
                    end;
                end else
                    if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                        "Break (Hours)" := ("End Hour" - "Start Hour") / 3600000;
                    end;
            end;
        }
        field(15; "End Hour"; Time)
        {
            Caption = 'End Hour';

            trigger OnValidate()
            begin
                if ("Filter Period" < "End Day") and ("Filter Period" <> 0D) and ("End Day" <> 0D) then begin
                    if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                        "Break (Hours)" := ((230000T - "Start Hour") / 3600000) + 1 + (("End Hour" - 000000T) / 3600000) +
                                               ((("End Day" - "Filter Period") - 1) * 24);
                    end;
                end else
                    if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                        "Break (Hours)" := ("End Hour" - "Start Hour") / 3600000;
                    end;
            end;
        }
        field(16; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code";
        }
        field(17; "Lecture Code"; Code[10])
        {
            Caption = 'Lecture Code';
        }
        field(18; "Lecture Status"; Option)
        {
            Caption = 'Lecture Status';
            OptionCaption = 'Started,Rescheduled,Summarized';
            OptionMembers = Started,Rescheduled,Summary;
        }
        field(20; "Lecture Absence"; Boolean)
        {
            Caption = 'Lecture Absence';
        }
        field(21; "Teacher Absence"; Boolean)
        {
            Caption = 'Teacher Absence';
        }
        field(22; Closure; Boolean)
        {
            Caption = 'Closure';
        }
        field(23; "Join Subjects"; Integer)
        {
            Caption = 'Join Subjects';
        }
        field(24; Times; Option)
        {
            Caption = 'Time';
            OptionCaption = '1º Time,2º Time,3º Time,4º Time,5º Time,6º Time,7º Time,8º Time,9º Time,Not Assigned';
            OptionMembers = "1º Time","2º Time","3º Time","4º Time","5º Time","6º Time","7º Time","8º Time","9º Time","Not Assigned";
        }
        field(25; "End Day"; Date)
        {
            Caption = 'End Day';
        }
        field(26; "Break (Hours)"; Decimal)
        {
            Caption = 'Break (Hours)';
        }
        field(27; "Absence Type"; Option)
        {
            Caption = 'Absence Type';
            OptionCaption = 'Lecture,Daily';
            OptionMembers = Lecture,Daily;
        }
        field(28; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(29; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
        field(30; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
        field(31; "Responsibility Center"; Code[10])
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
        field(55; "Type Subject"; Option)
        {
            Caption = 'Type Subject';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non scholar component","Non scholar hours";
        }
        field(73100; "Web ID"; Integer)
        {
            Caption = 'Web ID';
        }
    }

    keys
    {
        key(Key1; "Timetable Code", "School Year", "Study Plan", Class, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Join Subjects")
        {
        }
        key(Key3; "Web ID")
        {
        }
        key(Key4; "Filter Period", "Start Hour", "End Hour")
        {
        }
        key(Key5; "Start Hour")
        {
        }
        key(Key6; "Week Day")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Lecture Status" = "Lecture Status"::Summary then begin
            Error(Text001);
        end;

        rProfessorHorario.Reset;
        rProfessorHorario.SetRange("Timetable Code", "Timetable Code");
        if rClass.Get(Class, "School Year") then
            rProfessorHorario.SetRange("School Year", rClass."School Year")
        else
            rProfessorHorario.SetRange("School Year", "School Year");
        rProfessorHorario.SetRange("Timetable Line No.", "Line No.");
        rProfessorHorario.SetRange(Class, Class);
        rProfessorHorario.DeleteAll;

        rRemarks.Reset;
        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Summary);
        if rClass.Get(Class, "School Year") then
            rRemarks.SetRange("School Year", rClass."School Year")
        else
            rRemarks.SetRange("School Year", "School Year");
        rRemarks.SetRange("Study Plan Code", "Study Plan");
        rRemarks.SetRange(Class, Class);
        rRemarks.SetRange("Calendar Line", "Line No.");
        rRemarks.SetRange("Timetable Code", "Timetable Code");
        if rRemarks.Find('-') then
            Error(Text001);

        rAbsence.Reset;
        if rClass.Get(Class, "School Year") then
            rAbsence.SetRange("School Year", rClass."School Year")
        else
            rAbsence.SetRange("School Year", "School Year");
        rAbsence.SetRange("Study Plan", "Study Plan");
        rAbsence.SetRange(Class, Class);
        rAbsence.SetRange("Timetable Code", "Timetable Code");
        if "Absence Type" = "Absence Type"::Lecture then begin
            rAbsence.SetRange("Line No. Timetable", "Line No.");
        end else begin
            rAbsence.SetRange(Day, "Filter Period");
        end;
        if rAbsence.Find('-') then
            Error(Text003);
        //rAbsence.DELETEALL;

        //WEB
        cInsertNAVWebCalendar.DeleteCalendar(Rec);
    end;

    trigger OnInsert()
    begin
        rCalendar.Reset;
        rCalendar.SetRange("Timetable Code", "Timetable Code");
        if rCalendar.Find('+') then
            "Line No." := rCalendar."Line No." + 10000
        else
            "Line No." := 10000;

        //WEB
        if not ValidateSubjects(Rec) then
            cInsertNAVWebCalendar.InsertCalendar(Rec, "Web ID");
    end;

    var
        rCalendar: Record Calendar;
        Text001: Label 'Lecture is already summarized. Unable to eliminate registration.';
        rProfessorHorario: Record "Timetable-Teacher";
        rAbsence: Record Absence;
        rClass: Record Class;
        cInsertNAVWebCalendar: Codeunit InsertNAVWebCalendar;
        Text002: Label 'There already are Teachers in the class.';
        Text003: Label 'There are already Students with absences.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        recSubject: Record Subjects;
        rRemarks: Record Remarks;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rStruEduCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        rHorario: Record Timetable;

    //[Scope('OnPrem')]
    procedure CreateAbsences(pCalendar: Record Calendar; pStudentTeacher: Integer; pInicialDate: Date; pEndDate: Date)
    var
        rClass: Record Class;
        fAbsencesWizard: Page "Absences Wizard";
    begin
        rClass.Reset;
        rClass.SetRange("School Year", pCalendar."School Year");
        rClass.SetRange("Study Plan Code", pCalendar."Study Plan");
        rClass.SetRange(Class, pCalendar.Class);

        fAbsencesWizard.SetTableView(rClass);
        fAbsencesWizard.SetFormFilter("Timetable Code", pStudentTeacher, pInicialDate, pEndDate, false, pCalendar."School Year");
        fAbsencesWizard.Run;
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(pClass: Code[20]; pSchoolYear: Code[9]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if rClass.Get(pClass, pSchoolYear) then;

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateSubjects(pCalendar: Record Calendar): Boolean
    var
        l_rStruEduCountry: Record "Structure Education Country";
    begin
        if pCalendar.Type = pCalendar.Type::Multi then begin
            rCourseLinesTEMP.Reset;
            rCourseLinesTEMP.DeleteAll;

            //Quadriennal
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pCalendar."Study Plan");
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Anual
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pCalendar."Study Plan");
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
            if rClass.Get(pCalendar.Class, pCalendar."School Year") then
                rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Bienal E Triennal
            rStruEduCountry.Reset;
            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            if rClass.Get(pCalendar.Class, pCalendar."School Year") then
                rStruEduCountry.SetRange("Schooling Year", rClass."Schooling Year");
            if rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pCalendar."Study Plan");
                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;
                //ELSE BEGIN
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pCalendar.Class, pCalendar."School Year") - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pCalendar."Study Plan");
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pCalendar.Class, pCalendar."School Year") - 2);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pCalendar."Study Plan");
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pCalendar.Class, pCalendar."School Year") - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pCalendar."Study Plan");
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                //END;
            end;


            rCourseLinesTEMP.Reset;
            rCourseLinesTEMP.SetRange(Code, pCalendar."Study Plan");
            rCourseLinesTEMP.SetRange("Subject Code", pCalendar.Subject);
            rCourseLinesTEMP.SetRange("Subject Excluded From Assess.", true);
            if rCourseLinesTEMP.FindFirst then
                exit(true)
            else
                exit(false);
        end else begin
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, pCalendar."Study Plan");
            rStudyPlanLines.SetRange("School Year", pCalendar."School Year");
            rStudyPlanLines.SetRange("Subject Code", pCalendar.Subject);
            rStudyPlanLines.SetRange("Subject Excluded From Assess.", true);
            if rStudyPlanLines.FindFirst then
                exit(true)
            else
                exit(false);
        end;
    end;
}

