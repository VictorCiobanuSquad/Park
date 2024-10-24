table 52790 "Insert Timetable Lecture"
{
    Caption = 'Insert Timetable Lecture';

    fields
    {
        field(1; "Initial Day"; Date)
        {
            Caption = 'Initial Day';
        }
        field(2; "Final Day"; Date)
        {
            Caption = 'Final Day';
        }
        field(3; "Start Hour"; Time)
        {
            Caption = 'Start Hour';

            trigger OnLookup()
            var
                rDate: Record Date;
            begin
                rDate.Reset;
                rDate.SetRange("Period Type", rDate."Period Type"::Date);
                rDate.SetRange("Period Start", "Initial Day");
                if rDate.Find('-') then;


                rTemplateTimetable.Reset;
                rTemplateTimetable.SetRange(Type, rTemplateTimetable.Type::Lines);
                rTemplateTimetable.SetRange(Day, rDate."Period No.");
                if rTimetable.Get("Timetable Code") then begin
                    rTemplateTimetable.SetRange("School Year", rTimetable."School Year");
                    rTemplateTimetable.SetRange("Template Code", rTimetable."Template Timetable");
                end;
                if rTemplateTimetable.Find('-') then
                    rTemplateTimetable.SetRange(rTemplateTimetable.Time);

                if PAGE.RunModal(PAGE::"Timetable Template Line", rTemplateTimetable) = ACTION::LookupOK then begin
                    Validate("Start Hour", rTemplateTimetable."Initial Time");
                    Times := rTemplateTimetable.Time;
                end;
            end;

            trigger OnValidate()
            var
                rDate: Record Date;
            begin
                if ("Start Hour" <> 0T) then begin

                    rDate.Reset;
                    rDate.SetRange("Period Type", rDate."Period Type"::Date);
                    rDate.SetRange("Period Start", "Initial Day");
                    if rDate.Find('-') then;


                    if rTimetable.Get("Timetable Code") then;
                    rTemplateTimetable.Reset;
                    rTemplateTimetable.SetRange(Type, rTemplateTimetable.Type::Lines);
                    rTemplateTimetable.SetRange("Template Code", rTimetable."Template Timetable");
                    rTemplateTimetable.SetRange(Day, rDate."Period No.");
                    rTemplateTimetable.SetRange("Initial Time", "Start Hour");
                    if rTemplateTimetable.Find('-') then begin
                        Validate("End Hour", rTemplateTimetable."Finish Time");
                        Times := rTemplateTimetable.Time;
                    end;
                end;
            end;
        }
        field(4; "End Hour"; Time)
        {
            Caption = 'End Hour';
        }
        field(5; Monday; Boolean)
        {
            Caption = 'Monday';
        }
        field(6; Tuesday; Boolean)
        {
            Caption = 'Tuesday';
        }
        field(7; Wednesday; Boolean)
        {
            Caption = 'Wednesday';
        }
        field(8; Thursday; Boolean)
        {
            Caption = 'Thursday';
        }
        field(9; Friday; Boolean)
        {
            Caption = 'Friday';
        }
        field(10; Saturday; Boolean)
        {
            Caption = 'Saturday';
        }
        field(11; Subject; Code[20])
        {
            Caption = 'Subject';
            TableRelation = IF ("Type Subject" = FILTER(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE
            IF ("Type Subject" = FILTER("Non lective Component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF ("Type Subject" = FILTER(Other)) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

            trigger OnLookup()
            var
                rHorario: Record Timetable;
                rStudyPlanLines: Record "Study Plan Lines";
                rCourseLines: Record "Course Lines";
                rCourseLinesTEMP: Record "Course Lines" temporary;
                rClass: Record Class;
                rStruEduCountry: Record "Structure Education Country";
                l_rStruEduCountry: Record "Structure Education Country";
                cStudentsRegistration: Codeunit "Students Registration";
            begin
                if rHorario.Get("Timetable Code") then begin
                    if ("Type Subject" = "Type Subject"::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) then begin
                        rStudyPlanLines.Reset;
                        rStudyPlanLines.SetRange(Code, rHorario."Study Plan");
                        rStudyPlanLines.SetRange("School Year", rHorario."School Year");
                        if rStudyPlanLines.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Study Plan Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                Validate(Subject, rStudyPlanLines."Subject Code");
                                "Sub-Subject Code" := '';
                            end;
                        end else begin
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
                                if PAGE.RunModal(PAGE::"Study Course Subjects", rCourseLinesTEMP) = ACTION::LookupOK then begin
                                    Validate(Subject, rCourseLinesTEMP."Subject Code");
                                    "Sub-Subject Code" := '';
                                end;
                        end;
                    end;
                    if "Type Subject" = "Type Subject"::"Non lective Component" then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, "Type Subject");
                        if recSubject.Find('-') then
                            if PAGE.RunModal(PAGE::"Non lective component List", recSubject) = ACTION::LookupOK then begin
                                Validate(Subject, recSubject.Code);
                                "Sub-Subject Code" := '';
                            end;
                    end;
                    if "Type Subject" = "Type Subject"::Other then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, "Type Subject");
                        if recSubject.Find('-') then;

                        if PAGE.RunModal(PAGE::"Non Scholar hours", recSubject) = ACTION::LookupOK then begin
                            Validate(Subject, recSubject.Code);
                            "Sub-Subject Code" := '';
                        end;
                    end;

                end;
            end;

            trigger OnValidate()
            begin
                InsertTeacher;
            end;
        }
        field(13; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code" WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(14; "Key"; Integer)
        {
            Caption = 'Key';
        }
        field(15; "Session ID"; Code[20])
        {
            Caption = 'Session ID';
        }
        field(16; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
        }
        field(17; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(18; "Sub Class"; Code[20])
        {
            Caption = 'Sub Class';
        }
        field(19; "Subject Group"; Code[20])
        {
            Caption = 'Subject Group';
            TableRelation = "Subjects Group".Code WHERE(Type = CONST(Subject));
        }
        field(20; Saved; Boolean)
        {
            Caption = 'Saved';
        }
        field(21; Recurrence; Boolean)
        {
            Caption = 'Recurrence';
        }
        field(22; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(23; "Study Plan"; Code[20])
        {
            Caption = 'Study Plan';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(24; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(25; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(26; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(27; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(28; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnLookup()
            begin
                if rTimetable.Get("Timetable Code") then begin
                    if rClass.Get(rTimetable.Class, rTimetable."School Year") then;

                    rSPSubSubjectsLines.Reset;
                    rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::"Study Plan");
                    rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                    rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                    rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                    if rSPSubSubjectsLines.Find('-') then begin
                        if PAGE.RunModal(PAGE::"Study Plan Sub-Subjects List", rSPSubSubjectsLines) = ACTION::LookupOK then
                            Validate("Sub-Subject Code", rSPSubSubjectsLines."Sub-Subject Code");

                    end else begin
                        rSPSubSubjectsLines.Reset;
                        rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::Course);
                        rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                        rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                        rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                        if rSPSubSubjectsLines.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Study Plan Sub-Subjects List", rSPSubSubjectsLines) = ACTION::LookupOK then
                                Validate("Sub-Subject Code", rSPSubSubjectsLines."Sub-Subject Code");
                        end;
                    end;
                end;
            end;
        }
        field(29; Times; Option)
        {
            Caption = 'Time';
            OptionCaption = '1º Time,2º Time,3º Time,4º Time,5º Time,6º Time,7º Time,8º Time,9º Time';
            OptionMembers = "First Time","Second Time","Third Time","Fourth Time","Fifth Time","Sixth Time","Seventh Time","Eighth Time","Nineth Time";
        }
        field(30; "Responsibility Center"; Code[10])
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
            OptionMembers = " ",Subject,"Non lective Component",Other;

            trigger OnValidate()
            begin
                Subject := '';
                "Sub-Subject Code" := '';
                Room := '';
                "Initial Day" := 0D;
                "Final Day" := 0D;
                "Start Hour" := 0T;
                "End Hour" := 0T;

                recProfessorHorarioInserir.Reset;
                recProfessorHorarioInserir.SetRange("Cab Line", "Line No.");
                recProfessorHorarioInserir.SetRange("School Year", "School Year");
                recProfessorHorarioInserir.SetRange("Study Plan", "Study Plan");
                recProfessorHorarioInserir.SetRange(Class, Class);
                recProfessorHorarioInserir.SetRange("Timetable Code", "Timetable Code");
                recProfessorHorarioInserir.SetRange(Type, Type);
                if recProfessorHorarioInserir.Find('-') then
                    recProfessorHorarioInserir.DeleteAll;
            end;
        }
    }

    keys
    {
        key(Key1; "School Year", "Study Plan", Class, "Timetable Code", Type, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recProfessorHorarioInserir.Reset;
        recProfessorHorarioInserir.SetRange("School Year", "School Year");
        recProfessorHorarioInserir.SetRange("Study Plan", "Study Plan");
        recProfessorHorarioInserir.SetRange(Class, Class);
        recProfessorHorarioInserir.SetRange("Timetable Code", "Timetable Code");
        recProfessorHorarioInserir.SetRange("User ID", "User ID");
        recProfessorHorarioInserir.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if rClass.Get(Class, "School Year") then;

        Type := rClass.Type;

        "User ID" := UserId;
    end;

    var
        recHorarioInserirAulas: Record "Insert Timetable Lecture";
        recProfessorHorarioInserir: Record "Timetable-Teacher-Insert";
        rClass: Record Class;
        rTemplateTimetable: Record "Template Timetable";
        rTimetable: Record Timetable;
        rSPSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        recSubject: Record Subjects;


    procedure InsertTeacher()
    var
        recSubjects: Record Subjects;
        recSubjectsGroup: Record "Subjects Group";
        recHorarioProfessorLinhas: Record "Teacher Timetable Lines";
        recHorarioProfessorLinhas2: Record "Teacher Timetable Lines";
        recDate: Record Date;
        varNLinha: Integer;
    begin
        recSubjects.Reset;
        recSubjects.SetRange(Code, Subject);
        if recSubjects.Find('-') then begin
            recSubjectsGroup.Reset;
            recSubjectsGroup.SetRange(Type, recSubjectsGroup.Type::Teacher);
            recSubjectsGroup.SetRange(Code, recSubjects.Department);
            if recSubjectsGroup.Find('-') then begin
                recHorarioProfessorLinhas.Reset;
                if recHorarioProfessorLinhas.Find('+') then
                    varNLinha := recHorarioProfessorLinhas."Line No." + 10000
                else
                    varNLinha := 10000;

                recHorarioProfessorLinhas2.Reset;
                recHorarioProfessorLinhas2.SetRange("Timetable Code", "Timetable Code");
                recHorarioProfessorLinhas2.SetRange(Class, Class);
                recHorarioProfessorLinhas2.SetRange(Subject, recSubjects.Code);
                if (not recHorarioProfessorLinhas2.Find('-')) then begin
                    recHorarioProfessorLinhas.Reset;
                    recHorarioProfessorLinhas.Init;
                    recHorarioProfessorLinhas."Timetable Code" := "Timetable Code";
                    recHorarioProfessorLinhas."Line No." := varNLinha;
                    recHorarioProfessorLinhas."Teacher No." := recSubjectsGroup."Teacher No.";
                    recHorarioProfessorLinhas.Class := Class;
                    recDate.Reset;
                    recDate.SetRange("Period Start", "Initial Day");
                    if recDate.Find('-') then
                        recHorarioProfessorLinhas.Day := recDate."Period No." - 1;
                    recSubjectsGroup.CalcFields("Teacher Name");
                    recHorarioProfessorLinhas.Name := recSubjectsGroup."Teacher Name";
                    recHorarioProfessorLinhas.Subject := recSubjects.Code;
                    recHorarioProfessorLinhas.Insert(true);
                end;
            end;
        end;
    end;


    procedure GetNoStructureCountry(pClass: Code[10]; pSchoolYear: Code[9]): Integer
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
}

