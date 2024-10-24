table 52788 "Timetable Lines"
{
    Caption = 'Timetable Lines';

    fields
    {
        field(1; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            NotBlank = true;
            TableRelation = Timetable."Timetable Code";
        }
        field(5; Day; Integer)
        {
            Caption = 'Day';
            InitValue = 1;
            ValuesAllowed = 1, 2, 3, 4, 5, 6, 7;

            trigger OnValidate()
            begin
                "Day Description" := Day - 1;

                Time := 0;
            end;
        }
        field(6; "Day Description"; Option)
        {
            Caption = 'Day Description';
            InitValue = Segunda;
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Segunda,"Terça",Quarta,Quinta,Sexta,Sabado,Domingo;

            trigger OnValidate()
            var
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
            begin
                Day := "Day Description" + 1;



                if Day <> xRec.Day then begin
                    Time := 0;
                    "Start Hour" := 0T;
                    "End Hour" := 0T;
                    Subject := '';
                    "Sub-Subject Code" := '';
                    Turn := '';
                    Meeting := 0;
                    Target := '';
                    Level := 0;

                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines2.DeleteAll;

                end;
            end;
        }
        field(7; Subject; Code[20])
        {
            Caption = 'Subject';
            TableRelation = IF (Type = FILTER(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE
            IF (Type = FILTER("Non scholar component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF (Type = FILTER("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

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
                    rHorario.CalcFields(Blocked);
                    rHorario.CalcFields("Blocked Teacher");
                    if (Type = Type::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
                     (rHorario.Type = rHorario.Type::Simple) then begin
                        rStudyPlanLines.Reset;
                        rStudyPlanLines.SetRange(Code, rHorario."Study Plan");
                        rStudyPlanLines.SetRange("School Year", rHorario."School Year");
                        if rStudyPlanLines.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Study Plan Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                if not (rHorario.Blocked) or not (rHorario."Blocked Teacher") then begin
                                    Validate(Subject, rStudyPlanLines."Subject Code");
                                    "Sub-Subject Code" := '';
                                end;
                            end;
                        end;
                    end;
                    if (Type = Type::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
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
                            if not (rHorario.Blocked) or not (rHorario."Blocked Teacher") then begin
                                if PAGE.RunModal(PAGE::"Study Course Subjects", rCourseLinesTEMP) = ACTION::LookupOK then begin
                                    Validate(Subject, rCourseLinesTEMP."Subject Code");
                                    "Sub-Subject Code" := '';
                                end;
                            end;
                    end;
                    if Type = Type::"Non scholar component" then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, Type);
                        if recSubject.Find('-') then
                            if not (rHorario.Blocked) or not (rHorario."Blocked Teacher") then begin
                                if PAGE.RunModal(PAGE::"Non lective component List", recSubject) = ACTION::LookupOK then begin
                                    Validate(Subject, recSubject.Code);
                                    "Sub-Subject Code" := '';
                                end;
                            end;
                    end;
                    if Type = Type::"Non scholar hours" then begin
                        recSubject.Reset;
                        recSubject.SetRange(Type, Type::"Non scholar hours");
                        if recSubject.Find('-') then;
                        if not (rTimetable.Blocked) or not (rTimetable."Blocked Teacher") then begin
                            if PAGE.RunModal(PAGE::"Non Scholar hours", recSubject) = ACTION::LookupOK then begin
                                Validate(Subject, recSubject.Code);
                                "Sub-Subject Code" := '';
                            end;
                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            var
                recHorarioProfessorLinhas: Record "Teacher Timetable Lines";
                rStudyPlanLines: Record "Study Plan Lines";
                rHorario: Record Timetable;
                rCourseLines: Record "Course Lines";
            begin
                if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines.DeleteAll;
                    Meeting := 0;
                    Target := '';
                    Level := 0;
                    fJoinSubjects(Rec)
                end else
                    Error(text005);


                if Subject <> '' then begin
                    if rHorario.Get("Timetable Code") then begin
                        if (Type = Type::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
                          (rHorario.Type = rHorario.Type::Simple) then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, rHorario."Study Plan");
                            rStudyPlanLines.SetRange("School Year", rHorario."School Year");
                            rStudyPlanLines.SetRange("Subject Code", Subject);
                            if not rStudyPlanLines.FindFirst then
                                Error(Text0002);
                        end;
                        if (Type = Type::Subject) and (rHorario."Timetable Type" = rHorario."Timetable Type"::Class) and
                          (rHorario.Type = rHorario.Type::Multi) then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, rHorario."Study Plan");
                            rCourseLines.SetRange("Subject Code", Subject);
                            if not rCourseLines.FindFirst then
                                Error(Text0002);
                        end;
                    end;
                end;
            end;
        }
        field(8; "Start Hour"; Time)
        {
            Caption = 'Start Hour';

            trigger OnLookup()
            begin
                if ("Template Code" <> '') then begin
                    rTemplateTimetable.Reset;
                    rTemplateTimetable.SetRange(Type, rTemplateTimetable.Type::Lines);
                    rTemplateTimetable.SetRange(Day, Day);
                    rTemplateTimetable.SetRange("Template Code", "Template Code");
                    rTemplateTimetable.SetRange(rTemplateTimetable.Time, Time);
                    if rTimetable.Get("Timetable Code") then begin
                        rTimetable.CalcFields(Blocked);
                        rTimetable.CalcFields("Blocked Teacher");
                        rTemplateTimetable.SetRange("School Year", rTimetable."School Year");
                        if rTimetable."Timetable Type" = rTimetable."Timetable Type"::Teacher then
                            rTemplateTimetable.SetRange("Timetable Type", rTemplateTimetable."Timetable Type"::Lesson);
                    end;
                    if rTemplateTimetable.Find('-') then
                        rTemplateTimetable.SetRange(rTemplateTimetable.Time);
                    if not (rTimetable.Blocked) or not (rTimetable."Blocked Teacher") then begin
                        if PAGE.RunModal(PAGE::"Timetable Template Line", rTemplateTimetable) = ACTION::LookupOK then begin
                            varLine := rTemplateTimetable."Line No.";
                            Validate("Start Hour", rTemplateTimetable."Initial Time");
                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            var
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
            begin
                if "Start Hour" <> xRec."Start Hour" then begin
                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines2.DeleteAll;
                end;

                if ("Start Hour" <> 0T) and ("Template Code" <> '') then begin
                    if rTimetable.Get("Timetable Code") then;
                    rTimetable.CalcFields(Blocked);
                    rTimetable.CalcFields("Blocked Teacher");
                    if not rTimetable.Blocked then begin
                        rTemplateTimetable.Reset;
                        rTemplateTimetable.SetRange("School Year", rTimetable."School Year");
                        rTemplateTimetable.SetRange(Type, rTemplateTimetable.Type::Lines);
                        rTemplateTimetable.SetRange("Template Code", "Template Code");
                        rTemplateTimetable.SetRange("Initial Time", "Start Hour");
                        rTemplateTimetable.SetRange(Day, Day);
                        if varLine <> 0 then
                            rTemplateTimetable.SetRange("Line No.", varLine);
                        if rTemplateTimetable.Find('-') then begin
                            Validate("End Hour", rTemplateTimetable."Finish Time");
                            Time := rTemplateTimetable.Time;
                            "Part of Day" := rTemplateTimetable."Part of Day";
                            if rTimetable."Timetable Type" = rTimetable."Timetable Type"::Class then begin
                                if rTemplateTimetable."Timetable Type" = rTemplateTimetable."Timetable Type"::Other then
                                    Type := Type::"Non scholar hours"
                                else
                                    Type := Type::Subject
                            end;
                            if rTimetable."Timetable Type" = rTimetable."Timetable Type"::Teacher then begin
                                if rTemplateTimetable."Timetable Type" = rTemplateTimetable."Timetable Type"::Other then
                                    //Type := Type::Other
                                    Error(Text0005)
                                else
                                    Type := Type::"Non scholar component"
                            end;
                        end;
                    end else
                        "Start Hour" := xRec."Start Hour";
                end;

                if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                    "Break (Hours)" := ("End Hour" - "Start Hour") / 3600000;
                end;

                if "Break (Hours)" > 4 then
                    Error(text003);

                if "Start Hour" <> xRec."Start Hour" then begin
                    Subject := '';
                    "Sub-Subject Code" := '';
                    Turn := '';
                    Meeting := 0;
                    Target := '';
                    Level := 0;

                end;
            end;
        }
        field(9; "End Hour"; Time)
        {
            Caption = 'End Hour';

            trigger OnValidate()
            begin
                if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then
                    "Break (Hours)" := ("End Hour" - "Start Hour") / 3600000;

                if "Break (Hours)" > 4 then
                    Error(text003);
            end;
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code" WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(12; Teachers; Integer)
        {
            CalcFormula = Count("Teacher Timetable Lines" WHERE("Timetable Code" = FIELD("Timetable Code"),
                                                                 "Line No." = FIELD("Line No.")));
            Caption = 'Teachers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Break (Hours)"; Decimal)
        {
            Caption = 'Break (Hours)';
        }
        field(16; "Join Subjects"; Integer)
        {
            Caption = 'Join Subjects';
        }
        field(18; "Responsibility Center"; Code[10])
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
        field(21; Equipment; Decimal)
        {
            Caption = 'Equipment';
        }
        field(23; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(51; Time; Option)
        {
            Caption = 'Time';
            Editable = false;
            OptionCaption = '1º Time,2º Time,3º Time,4º Time,5º Time,6º Time,7º Time,8º Time,9º Time,Not Assigned';
            OptionMembers = "1º Time","2º Time","3º Time","4º Time","5º Time","6º Time","7º Time","8º Time","9º Time","Not Assigned";
        }
        field(52; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Template Timetable"."Template Code";
        }
        field(54; "Part of Day"; Option)
        {
            Caption = 'Part of Day';
            OptionCaption = ' ,Morning,Afternoon,Night';
            OptionMembers = " ","Manhã",Tarde,Noite;
        }
        field(55; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non scholar component","Non scholar hours";
        }
        field(56; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnLookup()
            var
                l_rTurnTEMP: Record Turn temporary;
                l_rTimetable: Record Timetable;
                l_rTurn: Record Turn;
            begin
                l_rTurnTEMP.Reset;
                l_rTurnTEMP.DeleteAll;

                if l_rTimetable.Get("Timetable Code") then;

                l_rTimetable.CalcFields(Blocked);
                l_rTimetable.CalcFields("Blocked Teacher");

                rTeacherClass.Reset;
                rTeacherClass.SetRange("School Year", l_rTimetable."School Year");
                rTeacherClass.SetRange(Class, l_rTimetable.Class);
                rTeacherClass.SetRange("Type Subject", rTeacherClass."Type Subject"::Subject);
                rTeacherClass.SetFilter("Subject Code", Subject);
                rTeacherClass.SetFilter("Sub-Subject Code", "Sub-Subject Code");
                rTeacherClass.SetRange("Responsibility Center", "Responsibility Center");
                rTeacherClass.SetFilter(Turn, '<>%1', '');
                if rTeacherClass.Find('-') then begin
                    repeat
                        l_rTurnTEMP.Reset;
                        l_rTurnTEMP.SetRange(Code, rTeacherClass.Turn);
                        l_rTurnTEMP.SetRange("Responsibility Center", "Responsibility Center");
                        if not l_rTurnTEMP.Find('-') then begin
                            l_rTurnTEMP.Init;
                            l_rTurnTEMP.Code := rTeacherClass.Turn;
                            l_rTurnTEMP."Responsibility Center" := "Responsibility Center";
                            if l_rTurn.Get(l_rTurnTEMP.Code, "Responsibility Center") then
                                l_rTurnTEMP.Description := l_rTurn.Description;
                            l_rTurnTEMP.Insert;
                        end;

                    until rTeacherClass.Next = 0;
                end;

                l_rTurnTEMP.Reset;
                if PAGE.RunModal(PAGE::"Turn List", l_rTurnTEMP) = ACTION::LookupOK then begin
                    if not l_rTimetable.Blocked or not l_rTimetable."Blocked Teacher" then
                        Validate(Turn, l_rTurnTEMP.Code);

                end;
            end;

            trigger OnValidate()
            begin
                if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines.DeleteAll;

                    fJoinSubjects(Rec)
                end else
                    Error(text005);
            end;
        }
        field(57; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnLookup()
            var
                rTimetable: Record Timetable;
                rClass: Record Class;
            begin
                if rTimetable.Get("Timetable Code") then begin
                    rTimetable.CalcFields(Blocked);
                    rTimetable.CalcFields("Blocked Teacher");
                    if rClass.Get(rTimetable.Class, rTimetable."School Year") then;

                    if rClass.Type = rClass.Type::Simple then begin
                        rSPSubSubjectsLines.Reset;
                        rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::"Study Plan");
                        rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                        rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                        rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                        if rSPSubSubjectsLines.Find('-') then begin
                            if not (rTimetable.Blocked) or not (rTimetable."Blocked Teacher") then begin
                                if PAGE.RunModal(PAGE::"Study Plan Sub-Subjects List", rSPSubSubjectsLines) = ACTION::LookupOK then begin
                                    Validate("Sub-Subject Code", rSPSubSubjectsLines."Sub-Subject Code");
                                    Modify;
                                end;
                            end;
                        end;
                    end;
                    if rClass.Type = rClass.Type::Multi then begin
                        rSPSubSubjectsLines.Reset;
                        rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::Course);
                        rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                        rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                        rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                        if rSPSubSubjectsLines.Find('-') then begin
                            if not (rTimetable.Blocked) or not (rTimetable."Blocked Teacher") then begin
                                if PAGE.RunModal(PAGE::"Study Plan Sub-Subjects List", rSPSubSubjectsLines) = ACTION::LookupOK then begin
                                    Validate("Sub-Subject Code", rSPSubSubjectsLines."Sub-Subject Code");
                                    Modify;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            var
                rTimetable: Record Timetable;
                rClass: Record Class;
                recHorarioProfessorLinhas: Record "Teacher Timetable Lines";
            begin
                if rTimetable.Get("Timetable Code") then begin
                    if rClass.Get(rTimetable.Class, rTimetable."School Year") then;

                    if rClass.Type = rClass.Type::Simple then begin
                        rSPSubSubjectsLines.Reset;
                        rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::"Study Plan");
                        rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                        rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                        rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                        rSPSubSubjectsLines.SetRange("Sub-Subject Code", "Sub-Subject Code");
                        if not rSPSubSubjectsLines.FindFirst and ("Sub-Subject Code" <> '') then
                            Error(Text0003);
                    end;
                    if rClass.Type = rClass.Type::Multi then begin
                        rSPSubSubjectsLines.Reset;
                        rSPSubSubjectsLines.SetRange(Type, rSPSubSubjectsLines.Type::Course);
                        rSPSubSubjectsLines.SetRange(Code, rTimetable."Study Plan");
                        rSPSubSubjectsLines.SetRange("Subject Code", Subject);
                        rSPSubSubjectsLines.SetRange("Schooling Year", rClass."Schooling Year");
                        rSPSubSubjectsLines.SetRange("Sub-Subject Code", "Sub-Subject Code");
                        if not rSPSubSubjectsLines.FindFirst and ("Sub-Subject Code" <> '') then
                            Error(Text0003);
                    end;
                end;



                if ("Start Hour" <> 0T) and ("End Hour" <> 0T) then begin
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines.DeleteAll;

                    fJoinSubjects(Rec);
                end else
                    Error(text005);
            end;
        }
        field(60; Meeting; Option)
        {
            Caption = 'Meeting';
            OptionCaption = ' ,Class,Department,Head Department,Level';
            OptionMembers = " ",Class,Department,"Head Department",Level;

            trigger OnValidate()
            var
                rSubjectsGroup: Record "Subjects Group";
                rTeacherTimetableLines: Record "Teacher Timetable Lines";
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
                l_Teacher: Record Teacher;
                varNLinha: Integer;
            begin
                if Meeting <> xRec.Meeting then begin
                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines2.DeleteAll;
                end;

                if Meeting = Meeting::"Head Department" then begin
                    if (Subject = '') or ("Start Hour" = 0T) then Error(Text0008);
                    rSubjectsGroup.Reset;
                    rSubjectsGroup.SetRange(rSubjectsGroup.Type, rSubjectsGroup.Type::Subject);
                    rSubjectsGroup.SetFilter(rSubjectsGroup."Head of Department", '<>%1', '');
                    if rSubjectsGroup.Find('-') then begin
                        repeat
                            rTeacherTimetableLines.Reset;
                            rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
                            rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Timetable Line No.", "Line No.");
                            rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Teacher No.", rSubjectsGroup."Head of Department");
                            if rTeacherTimetableLines.FindLast then
                                varNLinha := rTeacherTimetableLines."Line No." + 10000
                            else
                                varNLinha := 10000;

                            rTeacherTimetableLines2.Reset;
                            rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                            rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                            rTeacherTimetableLines2.SetRange(Subject, Subject);
                            rTeacherTimetableLines2.SetRange(rTeacherTimetableLines2."Teacher No.", rSubjectsGroup."Head of Department");
                            if not rTeacherTimetableLines2.Find('-') then begin
                                rTeacherTimetableLines.Reset;
                                rTeacherTimetableLines.Init;
                                rTeacherTimetableLines."Timetable Code" := "Timetable Code";
                                rTeacherTimetableLines."Timetable Line No." := "Line No.";
                                rTeacherTimetableLines."Line No." := varNLinha;
                                rTeacherTimetableLines."Teacher No." := rSubjectsGroup."Head of Department";
                                rTeacherTimetableLines.Name := rSubjectsGroup."Name of the Head of Department";
                                rTeacherTimetableLines.Class := rSubjectsGroup.Code;
                                rTeacherTimetableLines.Day := Day;
                                rTeacherTimetableLines.Subject := Subject;
                                rTeacherTimetableLines.Insert(true);
                            end;
                        until rSubjectsGroup.Next = 0;
                    end;
                end;
            end;
        }
        field(61; Target; Code[20])
        {
            Caption = 'Target';
            TableRelation = IF (Meeting = CONST(Class)) Class.Class
            ELSE
            IF (Meeting = CONST(Department)) "Subjects Group".Code WHERE(Type = CONST(Subject));

            trigger OnValidate()
            var
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
            begin
                if Target <> xRec.Target then begin
                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines2.DeleteAll;
                end;

                if (Subject <> '') and ("Start Hour" <> 0T) then
                    LoadTeachers(Rec)
                else
                    Error(Text0008);
            end;
        }
        field(62; Level; Option)
        {
            Caption = 'Levels';
            OptionCaption = ' ,Pre-school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = " ","Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;

            trigger OnValidate()
            var
                recTeacherClass: Record "Teacher Class";
                rTeacherTimetableLines: Record "Teacher Timetable Lines";
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
                rStuctureEduCountry: Record "Structure Education Country";
                varNLinha: Integer;
                l_Teacher: Record Teacher;
            begin
                TestField(Meeting, Meeting::Level);

                if Level <> xRec.Level then begin
                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                    rTeacherTimetableLines2.DeleteAll;
                end;

                if rTimetable.Get("Timetable Code") then;

                if Meeting = Meeting::Level then begin
                    if (Subject = '') or ("Start Hour" = 0T) then Error(Text0008);
                    recTeacherClass.Reset;
                    recTeacherClass.SetRange(recTeacherClass."User Type", recTeacherClass."User Type"::Teacher);
                    recTeacherClass.SetRange("School Year", rTimetable."School Year");
                    recTeacherClass.SetRange(recTeacherClass."Type Subject", recTeacherClass."Type Subject"::Subject);
                    if recTeacherClass.Find('-') then begin
                        repeat
                            rStuctureEduCountry.Reset;
                            rStuctureEduCountry.SetRange(rStuctureEduCountry."Schooling Year", recTeacherClass."Schooling Year");
                            rStuctureEduCountry.SetRange(rStuctureEduCountry.Level, Level - 1);
                            if rStuctureEduCountry.FindFirst then begin

                                rTeacherTimetableLines.Reset;
                                rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
                                rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Timetable Line No.", "Line No.");
                                rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Teacher No.", recTeacherClass.User);
                                if rTeacherTimetableLines.FindLast then
                                    varNLinha := rTeacherTimetableLines."Line No." + 10000
                                else
                                    varNLinha := 10000;

                                rTeacherTimetableLines2.Reset;
                                rTeacherTimetableLines2.SetRange("Timetable Code", "Timetable Code");
                                rTeacherTimetableLines2.SetRange("Timetable Line No.", "Line No.");
                                rTeacherTimetableLines2.SetRange(Subject, Subject);
                                rTeacherTimetableLines2.SetRange("Teacher No.", recTeacherClass.User);
                                if not rTeacherTimetableLines2.Find('-') then begin
                                    rTeacherTimetableLines.Reset;
                                    rTeacherTimetableLines.Init;
                                    rTeacherTimetableLines."Timetable Code" := "Timetable Code";
                                    rTeacherTimetableLines."Timetable Line No." := "Line No.";
                                    rTeacherTimetableLines."Line No." := varNLinha;
                                    rTeacherTimetableLines."Teacher No." := recTeacherClass.User;
                                    if l_Teacher.Get(recTeacherClass.User) then
                                        rTeacherTimetableLines.Name := FullName(l_Teacher."No.");
                                    rTeacherTimetableLines.Day := Day;
                                    rTeacherTimetableLines.Subject := Subject;
                                    rTeacherTimetableLines.Insert(true);
                                end;
                            end;
                        until recTeacherClass.Next = 0;
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Timetable Code", Class, "Template Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Timetable Code", Day, "Start Hour")
        {
        }
        key(Key3; "End Hour")
        {
        }
        key(Key4; "Start Hour")
        {
        }
        key(Key5; Subject, "Join Subjects")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if rTimetable.Get("Timetable Code") then begin
            rTimetable.CalcFields(Blocked, "Blocked Teacher");
            if rTimetable.Blocked then
                Error(text006);
        end;


        rTeacherTimetableLines.Reset;
        rTeacherTimetableLines.SetRange("Timetable Code", "Timetable Code");
        rTeacherTimetableLines.SetRange("Timetable Line No.", "Line No.");
        rTeacherTimetableLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if rTimetable.Get("Timetable Code") then
            "Responsibility Center" := rTimetable."Responsibility Center";
    end;

    var
        rTimetable: Record Timetable;
        rTeacherTimetableLines: Record "Teacher Timetable Lines";
        text003: Label 'Maximum allowed length is 4 hours.';
        rTemplateTimetable: Record "Template Timetable";
        recSubject: Record Subjects;
        RespCenter: Record "Responsibility Center";
        cUserEducation: Codeunit "User Education";
        text005: Label 'Please insert hours.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        text006: Label 'Could not delete Lines.';
        rSPSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        Text0003: Label 'The selected Sub Subject code does not exist.';
        Text0001: Label 'Please insert teacher.';
        Text0002: Label 'Please select another subject, the selected subject doesn''t exist in the study plan.';
        Text0005: Label 'Option not valid.';
        rTeacherClass: Record "Teacher Class";
        Text0007: Label 'The Field Sub-Subjects cannot be empty.';
        Text0008: Label 'Please insert subject.';
        varLine: Integer;


    procedure fJoinSubjects(var parTimetableLines: Record "Timetable Lines")
    var
        rTimetableLines: Record "Timetable Lines";
        recTeacherClass: Record "Teacher Class";
        rTeacherTimetableLines2: Record "Teacher Timetable Lines";
        rCourseLines: Record "Course Lines";
        varNLinha: Integer;
        varFiltra: Boolean;
        l_Teacher: Record Teacher;
        rCourseHeader: Record "Course Header";
        rStudyPlanHeader: Record "Study Plan Header";
        rClass: Record Class;
    begin
        rTimetableLines.Reset;
        rTimetableLines.SetRange("Timetable Code", parTimetableLines."Timetable Code");
        rTimetableLines.SetRange(Class, parTimetableLines.Class);
        rTimetableLines.SetRange("Template Code", parTimetableLines."Template Code");
        rTimetableLines.SetRange(Subject, parTimetableLines.Subject);
        if (rTimetableLines.Find('-')) and ((parTimetableLines."Line No." - rTimetableLines."Line No.") = 10000) then begin
            rTimetableLines."Join Subjects" := parTimetableLines."Line No.";
            rTimetableLines.Modify(true);

            if parTimetableLines."Join Subjects" <> parTimetableLines."Line No." then begin
                parTimetableLines."Join Subjects" := parTimetableLines."Line No.";
                parTimetableLines.Modify(true);
            end;
        end;

        if rTimetable.Get(parTimetableLines."Timetable Code") then;

        if rTimetable.Type = rTimetable.Type::Multi then
            if rCourseHeader.Get(rTimetable."Study Plan") then;
        if rTimetable.Type = rTimetable.Type::Simple then
            if rStudyPlanHeader.Get(rTimetable."Study Plan") then;



        if rTimetable."Timetable Type" = rTimetable."Timetable Type"::Class then begin
            varFiltra := false;
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, rTimetable."Study Plan");
            if not rCourseLines.FindFirst then
                varFiltra := true;


            recTeacherClass.Reset;
            recTeacherClass.SetRange(recTeacherClass."User Type", recTeacherClass."User Type"::Teacher);
            if varFiltra then
                recTeacherClass.SetRange("School Year", rTimetable."School Year");
            recTeacherClass.SetRange(Class, parTimetableLines.Class);
            recTeacherClass.SetRange(recTeacherClass."Type Subject", recTeacherClass."Type Subject"::Subject);
            recTeacherClass.SetRange("Subject Code", parTimetableLines.Subject);
            if not (rCourseHeader."Sub-subjects for assess. only") or not (rStudyPlanHeader."Sub-subjects for assess. only") then
                recTeacherClass.SetRange("Sub-Subject Code", parTimetableLines."Sub-Subject Code");
            recTeacherClass.SetRange(recTeacherClass.Turn, parTimetableLines.Turn);
            if recTeacherClass.Find('-') then begin
                repeat
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines.SetRange(Subject, parTimetableLines.Subject);
                    if rTeacherTimetableLines.FindLast then
                        varNLinha := rTeacherTimetableLines."Line No." + 10000
                    else
                        varNLinha := 10000;

                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
                    rTeacherTimetableLines2.SetRange(Class, parTimetableLines.Class);
                    rTeacherTimetableLines2.SetRange(Subject, parTimetableLines.Subject);
                    rTeacherTimetableLines2.SetRange("Teacher No.", recTeacherClass.User);
                    if not (rCourseHeader."Sub-subjects for assess. only") or not (rStudyPlanHeader."Sub-subjects for assess. only") then
                        rTeacherTimetableLines2.SetRange("Sub-Subject Code", parTimetableLines."Sub-Subject Code");
                    rTeacherTimetableLines2.SetRange(Turn, parTimetableLines.Turn);
                    if (not rTeacherTimetableLines2.Find('-')) or (parTimetableLines."Join Subjects" <> 0) then begin
                        rTeacherTimetableLines.Reset;
                        rTeacherTimetableLines.Init;
                        rTeacherTimetableLines."Timetable Code" := parTimetableLines."Timetable Code";
                        rTeacherTimetableLines."Line No." := varNLinha;
                        //rTeacherTimetableLines.VALIDATE("Teacher No.",recTeacherClass.user);
                        rTeacherTimetableLines."Teacher No." := recTeacherClass.User;
                        if l_Teacher.Get(recTeacherClass.User) then
                            rTeacherTimetableLines.Name := FullName(l_Teacher."No.");
                        rTeacherTimetableLines.Class := parTimetableLines.Class;
                        rTeacherTimetableLines.Day := parTimetableLines.Day;
                        rTeacherTimetableLines.Subject := parTimetableLines.Subject;
                        rTeacherTimetableLines."Sub-Subject Code" := parTimetableLines."Sub-Subject Code";
                        rTeacherTimetableLines."Timetable Line No." := parTimetableLines."Line No.";
                        rTeacherTimetableLines.Turn := recTeacherClass.Turn;
                        rTeacherTimetableLines.Insert(true);
                    end;
                until recTeacherClass.Next = 0;
            end;
        end else begin
            rTeacherTimetableLines2.Reset;
            rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
            rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
            if rTeacherTimetableLines2.FindSet then begin
                repeat
                    rTeacherTimetableLines2.Subject := parTimetableLines.Subject;
                    rTeacherTimetableLines2."Sub-Subject Code" := parTimetableLines."Sub-Subject Code";
                    rTeacherTimetableLines2.Modify;
                until rTeacherTimetableLines2.Next = 0;
            end;
        end;

        if (xRec.Subject <> '') and (Subject = '') or
            (xRec."Sub-Subject Code" <> '') and ("Sub-Subject Code" = '') and (xRec.Subject <> Subject) then begin
            rTeacherTimetableLines2.Reset;
            rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
            rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
            rTeacherTimetableLines2.SetRange(Class, parTimetableLines.Class);
            rTeacherTimetableLines2.SetRange(Subject, xRec.Subject);
            if not (rCourseHeader."Sub-subjects for assess. only") or not (rStudyPlanHeader."Sub-subjects for assess. only") then
                rTeacherTimetableLines2.SetRange("Sub-Subject Code", xRec."Sub-Subject Code");
            rTeacherTimetableLines2.DeleteAll;
        end;

        if ((xRec.Subject <> '') and (Subject <> '') and (xRec.Subject <> Subject)) or
           ((xRec."Sub-Subject Code" <> '') and ("Sub-Subject Code" <> '') and (xRec."Sub-Subject Code" <> "Sub-Subject Code")) then begin
            rTeacherTimetableLines2.Reset;
            rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
            rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
            rTeacherTimetableLines2.SetRange(Class, parTimetableLines.Class);
            rTeacherTimetableLines2.SetRange(Subject, xRec.Subject);
            rTeacherTimetableLines2.DeleteAll;
        end;
    end;


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
        if rStruEduCountry.FindFirst then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;


    procedure LoadTeachers(var parTimetableLines: Record "Timetable Lines")
    var
        rTimetableLines: Record "Timetable Lines";
        recTeacherClass: Record "Teacher Class";
        rTeacherTimetableLines2: Record "Teacher Timetable Lines";
        rSubjectsGroup: Record "Subjects Group";
        varNLinha: Integer;
        l_Teacher: Record Teacher;
        rClass: Record Class;
    begin

        if rTimetable.Get(parTimetableLines."Timetable Code") then;


        if parTimetableLines.Meeting = parTimetableLines.Meeting::Class then begin
            recTeacherClass.Reset;
            recTeacherClass.SetRange(recTeacherClass."User Type", recTeacherClass."User Type"::Teacher);
            recTeacherClass.SetRange("School Year", rTimetable."School Year");
            recTeacherClass.SetRange(Class, parTimetableLines.Target);
            recTeacherClass.SetRange(recTeacherClass."Type Subject", recTeacherClass."Type Subject"::Subject);
            if recTeacherClass.Find('-') then begin
                repeat
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Timetable Line No.", parTimetableLines."Line No.");
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Teacher No.", recTeacherClass.User);
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines.Class, parTimetableLines.Target);
                    if rTeacherTimetableLines.FindLast then
                        varNLinha := rTeacherTimetableLines."Line No." + 10000
                    else
                        varNLinha := 10000;

                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
                    rTeacherTimetableLines2.SetRange(Class, parTimetableLines.Target);
                    rTeacherTimetableLines2.SetRange(Subject, parTimetableLines.Subject);
                    rTeacherTimetableLines2.SetRange("Teacher No.", recTeacherClass.User);
                    if not rTeacherTimetableLines2.Find('-') then begin
                        rTeacherTimetableLines.Reset;
                        rTeacherTimetableLines.Init;
                        rTeacherTimetableLines."Timetable Code" := parTimetableLines."Timetable Code";
                        rTeacherTimetableLines."Timetable Line No." := parTimetableLines."Line No.";
                        rTeacherTimetableLines."Line No." := varNLinha;
                        rTeacherTimetableLines."Teacher No." := recTeacherClass.User;
                        if l_Teacher.Get(recTeacherClass.User) then
                            rTeacherTimetableLines.Name := FullName(l_Teacher."No.");
                        rTeacherTimetableLines.Class := parTimetableLines.Target;
                        rTeacherTimetableLines.Day := parTimetableLines.Day;
                        rTeacherTimetableLines.Subject := parTimetableLines.Subject;
                        rTeacherTimetableLines.Insert(true);
                    end;
                until recTeacherClass.Next = 0;
            end;
        end;


        if parTimetableLines.Meeting = parTimetableLines.Meeting::Department then begin
            rSubjectsGroup.Reset;
            rSubjectsGroup.SetRange(rSubjectsGroup.Type, rSubjectsGroup.Type::Teacher);
            rSubjectsGroup.SetRange(rSubjectsGroup.Code, parTimetableLines.Target);
            if rSubjectsGroup.Find('-') then begin
                repeat
                    rTeacherTimetableLines.Reset;
                    rTeacherTimetableLines.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Timetable Line No.", parTimetableLines."Line No.");
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines."Teacher No.", rSubjectsGroup."Teacher No.");
                    rTeacherTimetableLines.SetRange(rTeacherTimetableLines.Class, parTimetableLines.Target);
                    if rTeacherTimetableLines.FindLast then
                        varNLinha := rTeacherTimetableLines."Line No." + 10000
                    else
                        varNLinha := 10000;

                    rTeacherTimetableLines2.Reset;
                    rTeacherTimetableLines2.SetRange("Timetable Code", parTimetableLines."Timetable Code");
                    rTeacherTimetableLines2.SetRange("Timetable Line No.", parTimetableLines."Line No.");
                    rTeacherTimetableLines2.SetRange(Class, parTimetableLines.Target);
                    rTeacherTimetableLines2.SetRange(Subject, parTimetableLines.Subject);
                    rTeacherTimetableLines2.SetRange("Teacher No.", recTeacherClass.User);
                    if not rTeacherTimetableLines2.Find('-') then begin
                        rTeacherTimetableLines.Reset;
                        rTeacherTimetableLines.Init;
                        rTeacherTimetableLines."Timetable Code" := parTimetableLines."Timetable Code";
                        rTeacherTimetableLines."Timetable Line No." := parTimetableLines."Line No.";
                        rTeacherTimetableLines."Line No." := varNLinha;
                        rTeacherTimetableLines."Teacher No." := rSubjectsGroup."Teacher No.";
                        if l_Teacher.Get(rSubjectsGroup."Teacher No.") then
                            rTeacherTimetableLines.Name := FullName(l_Teacher."No.");
                        rTeacherTimetableLines.Class := parTimetableLines.Target;
                        rTeacherTimetableLines.Day := parTimetableLines.Day;
                        rTeacherTimetableLines.Subject := parTimetableLines.Subject;
                        rTeacherTimetableLines.Insert(true);
                    end;
                until rSubjectsGroup.Next = 0;
            end;
        end;
    end;


    procedure FullName(pTeacher: Code[20]) rName: Text[191]
    var
        rEduConfiguration: Record "Edu. Configuration";
        l_Teacher: Record Teacher;
    begin
        if l_Teacher.Get(pTeacher) then begin

            if rEduConfiguration.Get then begin
                if rEduConfiguration."Full Name syntax" = 0 then begin
                    if l_Teacher."Last Name 2" <> '' then
                        rName := l_Teacher."Last Name" + ' ' + l_Teacher."Last Name 2" + ', ' + l_Teacher.Name
                    else
                        rName := l_Teacher."Last Name" + ', ' + l_Teacher.Name;
                end else begin
                    if l_Teacher."Last Name 2" <> '' then
                        rName := l_Teacher.Name + ' ' + l_Teacher."Last Name 2" + ' ' + l_Teacher."Last Name"
                    else
                        rName := l_Teacher.Name + ' ' + l_Teacher."Last Name";
                end;
            end;
        end;
    end;
}

