codeunit 52773 Permissions
{

    trigger OnRun()
    begin
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";


    procedure StudyPlanFilter(var rRegistrationClassTEMP: Record "Registration Class" temporary)
    var
        rStudyPlanHeader: Record "Study Plan Header";
        rCourseHeader: Record "Course Header";
        rRegistration: Record Registration;
        rTeacherClass: Record "Teacher Class";
        VarInt: Integer;
        cUserEducation: Codeunit "User Education";
    begin
        //Used in Justify incidences screen

        rRegistrationClassTEMP.DeleteAll;
        VarInt := 0;

        rStudyPlanHeader.Reset;
        rStudyPlanHeader.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
        rStudyPlanHeader.SetFilter("Schooling Year", '<>%1', '');
        if cUserEducation.GetEducationFilter(UserId) <> '' then
            rStudyPlanHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
        if rStudyPlanHeader.Find('-') then begin
            repeat
                rTeacherClass.Reset;
                rTeacherClass.SetFilter(rTeacherClass."School Year", rStudyPlanHeader."School Year");
                rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                rTeacherClass.SetFilter(rTeacherClass."Schooling Year", '%1|%2', rStudyPlanHeader."Schooling Year", '');
                if rTeacherClass.FindSet then begin
                    VarInt += 10000;
                    rRegistrationClassTEMP.Init;
                    rRegistrationClassTEMP."School Year" := rStudyPlanHeader."School Year";
                    rRegistrationClassTEMP."Schooling Year" := rStudyPlanHeader."Schooling Year";
                    rRegistrationClassTEMP."Study Plan Code" := rStudyPlanHeader.Code;
                    rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Simple;
                    rRegistrationClassTEMP."Last Name" := rStudyPlanHeader.Description;
                    rRegistrationClassTEMP."Responsibility Center" := rStudyPlanHeader."Responsibility Center";
                    rRegistrationClassTEMP."Line No." := VarInt;
                    rRegistrationClassTEMP.Insert;
                end;
            until rStudyPlanHeader.Next = 0;
        end;


        rCourseHeader.Reset;
        if cUserEducation.GetEducationFilter(UserId) <> '' then
            rCourseHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
        if rCourseHeader.Find('-') then begin
            repeat
                rRegistration.Reset;
                rRegistration.SetCurrentKey("School Year", "Schooling Year", Course);
                rRegistration.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                rRegistration.SetRange("Responsibility Center", rCourseHeader."Responsibility Center");
                rRegistration.SetRange(Course, rCourseHeader.Code);
                if rRegistration.Find('-') then begin
                    repeat

                        rTeacherClass.Reset;
                        rTeacherClass.SetFilter(rTeacherClass."School Year", rCourseHeader."School Year Begin");
                        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                        rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                        rTeacherClass.SetFilter(rTeacherClass."Schooling Year", '%1|%2', rCourseHeader."Schooling Year Begin", '');
                        if rTeacherClass.FindSet then begin

                            rRegistrationClassTEMP.Reset;
                            rRegistrationClassTEMP.SetRange("Study Plan Code", rRegistration.Course);
                            rRegistrationClassTEMP.SetRange("School Year", rRegistration."School Year");
                            rRegistrationClassTEMP.SetRange("Schooling Year", rRegistration."Schooling Year");
                            rRegistrationClassTEMP.SetRange(Type, rRegistrationClassTEMP.Type::Multi);
                            rRegistrationClassTEMP.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                            if not rRegistrationClassTEMP.Find('-') then begin
                                rRegistrationClassTEMP.Init;
                                VarInt += 10000;
                                rRegistrationClassTEMP."School Year" := rRegistration."School Year";
                                rRegistrationClassTEMP."Schooling Year" := rRegistration."Schooling Year";
                                rRegistrationClassTEMP."Study Plan Code" := rCourseHeader.Code;
                                rRegistrationClassTEMP."Last Name" := rCourseHeader.Description;
                                rRegistrationClassTEMP."Responsibility Center" := rCourseHeader."Responsibility Center";
                                rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Multi;
                                rRegistrationClassTEMP."Line No." := VarInt;
                                rRegistrationClassTEMP.Insert;
                            end;

                        end;
                    until rRegistration.Next = 0;
                end;
            until rCourseHeader.Next = 0;
        end;
    end;


    procedure ClassFilter(var tempClass: Record Class temporary; pEvalIncid: Integer)
    var
        rTeacherClass: Record "Teacher Class";
        rClass: Record Class;
    begin
        //Used in evaluations screen, calendar screen and Justify incidences screen
        //1 - Permissão para avalaições
        //2 - Permissão para lançar faltas ou sumários
        //3 - Permissão para justificar faltas
        tempClass.DeleteAll;
        rTeacherClass.Reset;
        rTeacherClass.SetFilter(rTeacherClass."School Year", cStudentsRegistration.GetShoolYearActiveClosing);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        if pEvalIncid = 1 then
            rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
        if pEvalIncid = 3 then
            rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
        if rTeacherClass.FindSet then begin
            repeat
                if ((pEvalIncid = 1)) or ((pEvalIncid = 3)) or
                   ((pEvalIncid = 2) and ((rTeacherClass."Allow Assign Incidence") or (rTeacherClass."Allow Summary" = true))) then begin

                    if rTeacherClass."Schooling Year" <> '' then begin
                        if rTeacherClass.Class <> '' then begin
                            //Determinada turma de determinado ano escolariedade
                            rClass.Reset;
                            rClass.SetFilter(rClass."School Year", rTeacherClass."School Year");
                            rClass.SetRange(rClass."Schooling Year", rTeacherClass."Schooling Year");
                            rClass.SetRange(rClass.Class, rTeacherClass.Class);
                            if rClass.FindFirst then begin
                                tempClass.Init;
                                tempClass.TransferFields(rClass);
                                if not tempClass.Insert then tempClass.Modify;
                            end;

                        end else begin
                            //Todas as turmas desse Ano Escolaridade
                            rClass.Reset;
                            rClass.SetFilter(rClass."School Year", rTeacherClass."School Year");
                            rClass.SetRange(rClass."Schooling Year", rTeacherClass."Schooling Year");
                            if rClass.FindSet then begin
                                repeat
                                    tempClass.Init;
                                    tempClass.TransferFields(rClass);
                                    if not tempClass.Insert then tempClass.Modify;
                                until rClass.Next = 0;
                            end;
                        end;

                    end else begin
                        //Todas as turmas da escola
                        rClass.Reset;
                        rClass.SetFilter(rClass."School Year", rTeacherClass."School Year");
                        if rClass.FindSet then begin
                            repeat
                                tempClass.Init;
                                tempClass.TransferFields(rClass);
                                if not tempClass.Insert then tempClass.Modify;

                            until rClass.Next = 0;
                        end;
                    end;
                end;
            until rTeacherClass.Next = 0;
        end;
    end;


    procedure SubjectFilter(pType: Option Simple,Multi; pSchoolYear: Code[9]; pClass: Code[20]; pStudyPlanCode: Code[20]; pSchoolingYear: Code[10]; var TempStudyPlanLines: Record "Study Plan Lines" temporary; var TempCourseLines: Record "Course Lines" temporary; pEvalIncid: Integer)
    var
        rTeacherClass: Record "Teacher Class";
        rStudyPlanLines: Record "Study Plan Lines";
        cUserEducation: Codeunit "User Education";
        rCourseLines: Record "Course Lines";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rStruEduCountry: Record "Structure Education Country";
        l_rStruEduCountry: Record "Structure Education Country";
    begin
        //Used in evaluations screen
        //1 - Permissão para avalaições

        //3 - Permissão para justificar faltas

        if pType = pType::Simple then begin
            TempStudyPlanLines.DeleteAll;
            rTeacherClass.Reset;
            rTeacherClass.SetFilter(rTeacherClass."School Year", pSchoolYear);
            rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
            if pEvalIncid = 1 then begin
                rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
                //rTeacherClass.SETRANGE(rTeacherClass."Type Subject",rTeacherClass."Type Subject"::Subject);
            end;
            if pEvalIncid = 3 then begin
                rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                //rTeacherClass.SETRANGE(rTeacherClass."Type Subject",rTeacherClass."Type Subject"::Subject);
            end;
            if rTeacherClass.FindSet then begin
                repeat
                    if ((pEvalIncid = 1)) or ((pEvalIncid = 3)) or
                       ((pEvalIncid = 2) and ((rTeacherClass."Allow Assign Incidence") or (rTeacherClass."Allow Summary" = true))) then begin

                        if (rTeacherClass."Schooling Year" = '') or
                           ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                           ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                           (rTeacherClass.Class = pClass)) then begin

                            //Todas as disciplinas
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetFilter(Code, pStudyPlanCode);
                            rStudyPlanLines.SetFilter("School Year", pSchoolYear);
                            rStudyPlanLines.SetFilter("Schooling Year", pSchoolingYear);
                            rStudyPlanLines.SetFilter("Evaluation Type", '<>%1', rStudyPlanLines."Evaluation Type"::"None Qualification");
                            if cUserEducation.GetEducationFilter(UserId) <> '' then
                                rStudyPlanLines.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                            if rStudyPlanLines.FindSet then begin
                                repeat
                                    TempStudyPlanLines.Init;
                                    TempStudyPlanLines.TransferFields(rStudyPlanLines);
                                    if not TempStudyPlanLines.Insert then TempStudyPlanLines.Modify;
                                until rStudyPlanLines.Next = 0;
                            end;

                        end else begin
                            if (rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass) then begin
                                //Só algumas disciplinas
                                rStudyPlanLines.Reset;
                                rStudyPlanLines.SetFilter(Code, pStudyPlanCode);
                                rStudyPlanLines.SetFilter("School Year", pSchoolYear);
                                rStudyPlanLines.SetFilter("Schooling Year", pSchoolingYear);
                                rStudyPlanLines.SetFilter("Evaluation Type", '<>%1', rStudyPlanLines."Evaluation Type"::"None Qualification");
                                if cUserEducation.GetEducationFilter(UserId) <> '' then
                                    rStudyPlanLines.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                rStudyPlanLines.SetRange(rStudyPlanLines."Subject Code", rTeacherClass."Subject Code");
                                if rStudyPlanLines.FindFirst then begin
                                    TempStudyPlanLines.Init;
                                    TempStudyPlanLines.TransferFields(rStudyPlanLines);
                                    if not TempStudyPlanLines.Insert then TempStudyPlanLines.Modify;
                                end;
                            end;
                        end;
                    end;
                until rTeacherClass.Next = 0;
            end;

        end else begin
            //************MULTI*************
            rCourseLinesTEMP.Reset;
            rCourseLinesTEMP.DeleteAll;

            //Quadriennal
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pStudyPlanCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP."Temp Class" := pClass;
                    rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                    rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Anual
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, pStudyPlanCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
            rCourseLines.SetRange("Schooling Year Begin", pSchoolingYear);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP."Temp Class" := pClass;
                    rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                    rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;

            //Bienal E Triennal
            rStruEduCountry.Reset;
            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            rStruEduCountry.SetRange("Schooling Year", pSchoolingYear);
            if rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, pStudyPlanCode);
                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", pSchoolingYear);
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP."Temp Class" := pClass;
                        rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                        rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;

                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pClass, pSchoolYear) - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp Class" := pClass;
                            rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                            rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pClass, pSchoolYear) - 2);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp Class" := pClass;
                            rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                            rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(pClass, pSchoolYear) - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, pStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            rCourseLinesTEMP.Init;
                            rCourseLinesTEMP.TransferFields(rCourseLines);
                            rCourseLinesTEMP."Temp Class" := pClass;
                            rCourseLinesTEMP."Temp School Year" := pSchoolYear;
                            rCourseLinesTEMP."Schooling Year Begin" := pSchoolingYear;
                            rCourseLinesTEMP.Insert;
                        until rCourseLines.Next = 0;
                    end;
                end;
            end;


            TempCourseLines.DeleteAll;
            rTeacherClass.Reset;
            rTeacherClass.SetFilter(rTeacherClass."School Year", pSchoolYear);
            rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
            if pEvalIncid = 1 then begin
                rTeacherClass.SetRange(rTeacherClass."Allow Assign Evaluations", true);
                //rTeacherClass.SETRANGE(rTeacherClass."Type Subject",rTeacherClass."Type Subject"::Subject);
            end;
            if pEvalIncid = 3 then begin
                rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                //rTeacherClass.SETRANGE(rTeacherClass."Type Subject",rTeacherClass."Type Subject"::Subject);
            end;

            if rTeacherClass.FindSet then begin
                repeat
                    if ((pEvalIncid = 1)) or ((pEvalIncid = 3)) or
                       ((pEvalIncid = 2) and ((rTeacherClass."Allow Assign Incidence") or (rTeacherClass."Allow Summary" = true))) then begin

                        if (rTeacherClass."Schooling Year" = '') or
                           ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                           ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                           (rTeacherClass.Class = pClass)) then begin

                            //Todas as disciplinas
                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.SetFilter(Code, pStudyPlanCode);
                            rCourseLinesTEMP.SetFilter("Temp School Year", pSchoolYear);
                            rCourseLinesTEMP.SetFilter("Schooling Year Begin", pSchoolingYear);
                            rCourseLinesTEMP.SetFilter("Evaluation Type", '<>%1', rCourseLinesTEMP."Evaluation Type"::"None Qualification");
                            if cUserEducation.GetEducationFilter(UserId) <> '' then
                                rCourseLinesTEMP.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                            if rCourseLinesTEMP.FindSet then begin
                                repeat
                                    TempCourseLines.Init;
                                    TempCourseLines.TransferFields(rCourseLinesTEMP);
                                    if not TempCourseLines.Insert then TempCourseLines.Modify;
                                until rCourseLinesTEMP.Next = 0;
                            end;

                        end else begin
                            if (rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass) then begin
                                //Só algumas disciplinas
                                rCourseLinesTEMP.Reset;
                                rCourseLinesTEMP.SetFilter(Code, pStudyPlanCode);
                                rCourseLinesTEMP.SetFilter("Temp School Year", pSchoolYear);
                                rCourseLinesTEMP.SetFilter("Schooling Year Begin", pSchoolingYear);
                                rCourseLinesTEMP.SetFilter("Evaluation Type", '<>%1', rCourseLinesTEMP."Evaluation Type"::"None Qualification");
                                if cUserEducation.GetEducationFilter(UserId) <> '' then
                                    rCourseLinesTEMP.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                rCourseLinesTEMP.SetRange(rCourseLinesTEMP."Subject Code", rTeacherClass."Subject Code");
                                if rCourseLinesTEMP.FindFirst then begin
                                    TempCourseLines.Init;
                                    TempCourseLines.TransferFields(rCourseLinesTEMP);
                                    if not TempCourseLines.Insert then TempCourseLines.Modify;
                                end;
                            end;
                        end;
                    end;
                until rTeacherClass.Next = 0;
            end;


        end;
    end;


    procedure AllowGlobalObs(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10]): Boolean
    var
        rTeacherClass: Record "Teacher Class";
    begin
        //Used in evaluations screen
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        rTeacherClass.SetRange(rTeacherClass."Allow Stu. Global Observations", true);
        if rTeacherClass.FindSet then begin
            repeat
                if (rTeacherClass."Schooling Year" = '') or
                   ((rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = '')) or
                   ((rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass)) then
                    exit(true);
            until rTeacherClass.Next = 0;
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
        if rStruEduCountry.Find('-') then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;


    procedure AllowSummary(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pSubjectCode: Code[10]; pTurn: Code[20]) Summary: Boolean
    var
        rTeacherClass: Record "Teacher Class";
    begin
        //Used in calendar screen

        Summary := false;
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        rTeacherClass.SetRange(rTeacherClass."Allow Summary", true);
        if rTeacherClass.FindSet then begin
            repeat
                if (rTeacherClass."Schooling Year" = '') or
                   ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                   ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                   (rTeacherClass.Class = pClass)) then
                    Summary := true
                else begin
                    if (rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass) and
                       (rTeacherClass."Subject Code" = pSubjectCode) then
                        Summary := true;
                    //Turnos
                    if (pSchoolingYear = '') and (pClass = '') and (rTeacherClass.Turn = pTurn) then
                        Summary := true;

                end;
            until rTeacherClass.Next = 0;
        end;
    end;


    procedure AllowIncidences(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pSubjectCode: Code[10]; pTurn: Code[20]) Incidence: Boolean
    var
        rTeacherClass: Record "Teacher Class";
    begin
        //Used in calendar screen

        Incidence := false;
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        rTeacherClass.SetRange(rTeacherClass."Allow Assign Incidence", true);
        if rTeacherClass.FindSet then begin
            repeat
                if (rTeacherClass."Schooling Year" = '') or
                   ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                   ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                   (rTeacherClass.Class = pClass)) then
                    Incidence := true
                else begin
                    if (rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass) and
                       (rTeacherClass."Subject Code" = pSubjectCode) then
                        Incidence := true;
                    //Turnos
                    if (pSchoolingYear = '') and (pClass = '') and (rTeacherClass.Turn = pTurn) then
                        Incidence := true;
                end;
            until rTeacherClass.Next = 0;
        end;
    end;


    procedure AllowIncidencesAllDay(pClass: Code[20]; pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pSubjectCode: Code[10]; pTurn: Code[20]) Incidence: Boolean
    var
        rTeacherClass: Record "Teacher Class";
    begin
        //Used in calendar screen

        Incidence := false;
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        rTeacherClass.SetRange(rTeacherClass."Allow Assign Incidence", true);
        if rTeacherClass.FindSet then begin
            repeat
                if (rTeacherClass."Schooling Year" = '') or
                   ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                   ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                   (rTeacherClass.Class = pClass)) then
                    Incidence := true;

            until rTeacherClass.Next = 0;
        end;
    end;


    procedure SubjectFilterIncidence(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]; var TempCalendar: Record Calendar temporary; pDataIni: Date; pDataFim: Date; pTurn: Code[20])
    var
        rTeacherClass: Record "Teacher Class";
        rTimetableLines: Record "Timetable Lines";
        cUserEducation: Codeunit "User Education";
        rStruEduCountry: Record "Structure Education Country";
        l_rStruEduCountry: Record "Structure Education Country";
        rCalendar: Record Calendar;
    begin
        //Used calendar screen to filter subject and other

        TempCalendar.DeleteAll;
        rTeacherClass.Reset;
        rTeacherClass.SetFilter(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        if rTeacherClass.FindSet then begin
            repeat
                if (rTeacherClass."Allow Assign Incidence") or (rTeacherClass."Allow Summary" = true) then begin

                    if (rTeacherClass."Schooling Year" = '') or
                       ((rTeacherClass.Class = '') and (rTeacherClass."Schooling Year" = pSchoolingYear)) or
                       ((rTeacherClass."Subject Code" = '') and (rTeacherClass."Schooling Year" = pSchoolingYear) and
                       (rTeacherClass.Class = pClass)) then begin

                        //Todas as disciplinas
                        rCalendar.Reset;
                        if (pDataIni <> 0D) and (pDataFim <> 0D) then
                            rCalendar.SetRange(rCalendar."Filter Period", pDataIni, pDataFim);
                        if (pDataIni <> 0D) and (pDataFim = 0D) then
                            rCalendar.SetFilter(rCalendar."Filter Period", '>%1', pDataIni);
                        if (pDataIni = 0D) and (pDataFim <> 0D) then
                            rCalendar.SetFilter(rCalendar."Filter Period", '<%1', pDataFim);
                        rCalendar.SetRange(rCalendar."School Year", pSchoolYear);
                        rCalendar.SetRange(rCalendar.Class, pClass);
                        if rCalendar.FindSet then begin
                            repeat
                                TempCalendar.Init;
                                TempCalendar.TransferFields(rCalendar);
                                if not TempCalendar.Insert then TempCalendar.Modify;
                            until rCalendar.Next = 0;
                        end;


                    end else begin
                        if (rTeacherClass."Schooling Year" = pSchoolingYear) and (rTeacherClass.Class = pClass) then begin

                            //Só algumas disciplinas
                            rCalendar.Reset;
                            if (pDataIni <> 0D) and (pDataFim <> 0D) then
                                rCalendar.SetRange(rCalendar."Filter Period", pDataIni, pDataFim);
                            if (pDataIni <> 0D) and (pDataFim = 0D) then
                                rCalendar.SetFilter(rCalendar."Filter Period", '>%1', pDataIni);
                            if (pDataIni = 0D) and (pDataFim <> 0D) then
                                rCalendar.SetFilter(rCalendar."Filter Period", '<%1', pDataFim);
                            rCalendar.SetRange(rCalendar."School Year", pSchoolYear);
                            rCalendar.SetRange(rCalendar.Class, pClass);
                            rCalendar.SetRange(rCalendar.Subject, rTeacherClass."Subject Code");
                            if rCalendar.FindSet then begin
                                repeat
                                    TempCalendar.Init;
                                    TempCalendar.TransferFields(rCalendar);
                                    if not TempCalendar.Insert then TempCalendar.Modify;
                                until rCalendar.Next = 0;
                            end;
                        end;
                        //Turnos
                        if (pSchoolingYear = '') and (pClass = '') and (pTurn = rTeacherClass.Turn) then begin
                            rCalendar.Reset;
                            if (pDataIni <> 0D) and (pDataFim <> 0D) then
                                rCalendar.SetRange(rCalendar."Filter Period", pDataIni, pDataFim);
                            if (pDataIni <> 0D) and (pDataFim = 0D) then
                                rCalendar.SetFilter(rCalendar."Filter Period", '>%1', pDataIni);
                            if (pDataIni = 0D) and (pDataFim <> 0D) then
                                rCalendar.SetFilter(rCalendar."Filter Period", '<%1', pDataFim);
                            rCalendar.SetRange(rCalendar."School Year", pSchoolYear);
                            rCalendar.SetRange(rCalendar.Turn, pTurn);
                            rCalendar.SetRange(rCalendar.Subject, rTeacherClass."Subject Code");
                            if rCalendar.FindSet then begin
                                repeat
                                    TempCalendar.Init;
                                    TempCalendar.TransferFields(rCalendar);
                                    if not TempCalendar.Insert then TempCalendar.Modify;
                                until rCalendar.Next = 0;
                            end;

                        end;
                    end;
                end;
            until rTeacherClass.Next = 0;
        end;
    end;


    procedure AllowJustifyIncidence(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]): Boolean
    var
        rTeacherClass: Record "Teacher Class";
    begin
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
        rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
        rTeacherClass.SetRange(rTeacherClass."Schooling Year", '');
        if rTeacherClass.FindFirst then begin
            exit(true);
        end else begin
            rTeacherClass.Reset;
            rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
            rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
            rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
            rTeacherClass.SetRange(rTeacherClass."Schooling Year", pSchoolingYear);
            rTeacherClass.SetRange(rTeacherClass.Class, '');
            if rTeacherClass.FindFirst then begin
                exit(true);
            end else begin
                rTeacherClass.Reset;
                rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                rTeacherClass.SetRange(rTeacherClass."School Year", pSchoolYear);
                rTeacherClass.SetRange(rTeacherClass."Schooling Year", pSchoolingYear);
                rTeacherClass.SetRange(rTeacherClass.Class, pClass);
                rTeacherClass.SetRange(rTeacherClass."Subject Code", '');
                if rTeacherClass.FindFirst then
                    exit(true)
                else
                    exit(false);

            end;
        end;
    end;
}

