codeunit 31009754 "Timetable Calendar Mgt"
{
    Permissions = TableData Absence = rimd;

    trigger OnRun()
    begin
    end;

    var
        WindowDialog: Dialog;
        BaseCalendarChangeEDU: Record "Base Calendar ChangeEDU";
        AccountingPeriod: Record "Accounting Period";

    //[Scope('OnPrem')]
    procedure Start(pTimetableCode: Code[20]; pSchoolCalendar: Code[20]; pStartingDate: Date; pEndDate: Date)
    var
        rDate: Record Date;
        rTimetableLinesTEMP: Record "Timetable Lines" temporary;
        AgregarGlobal: Integer;
        Text001: Label 'Course Code                    #1#####################\';
        Text002: Label 'Class Code                     #2#####################\';
        Text003: Label 'Timetable code                 #3#####################\';
        Text004: Label 'Starting date - Ending date    #4#####################\';
        Text005: Label 'Day                            #5#####################\';
        Text006: Label 'Subject                        #6#####################\';
        Text007: Label 'Empty Timetable Code.';
        Text008: Label 'Generating Timetable\';
        Text009: Label 'Calendary created sucessfully for timetable %1.';
        l_Timetable: Record Timetable;
    begin
        if pTimetableCode = '' then
            Error(Text007);

        WindowDialog.Open(
                Text008 +
                Text001 +
                Text002 +
                Text003 +
                Text004 +
                Text005 +
                Text006);

        AgregarGlobal := BuscarAgregarDisciplina();

        rTimetableLinesTEMP.DeleteAll;


        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Date);
        rDate.SetFilter("Period Start", '%1..%2', pStartingDate, pEndDate);
        if rDate.Find('-') then
            PercorrerDias(pTimetableCode,
                           pSchoolCalendar,
                           rDate,
                           AgregarGlobal,
                           rTimetableLinesTEMP);

        WindowDialog.Close;

        if l_Timetable.Get(pTimetableCode) then begin
            l_Timetable."User Id" := UserId;
            l_Timetable.DateTime := CurrentDateTime;
            l_Timetable.Modify;
        end;
        Message(Text009, pTimetableCode);
    end;

    //[Scope('OnPrem')]
    procedure PercorrerDias(pTimetableCode: Code[20]; pSchoolCalendar: Code[20]; var pDate: Record Date; AgregarGlobal: Integer; var pTimetableLinesTEMP: Record "Timetable Lines" temporary)
    var
        l_Timetable: Record Timetable;
        l_TimetableLines: Record "Timetable Lines";
        VarDescription: Text[50];
        varHoliday: Boolean;
        l_rCalendar: Record Calendar;
    begin
        if l_Timetable.Get(pTimetableCode) then;


        repeat
            //Delete lines for this class for the current date
            l_rCalendar.Reset;
            l_rCalendar.SetRange(Class, l_Timetable.Class);
            l_rCalendar.SetRange("Filter Period", pDate."Period Start");
            l_rCalendar.DeleteAll(true);

            varHoliday := CheckDateStatus(pSchoolCalendar, pDate."Period Start", VarDescription);
            if not varHoliday then begin
                if pTimetableLinesTEMP.Find('-') then begin
                    l_TimetableLines.Reset;
                    l_TimetableLines.Copy(pTimetableLinesTEMP);
                end else
                    l_TimetableLines.Reset;

                l_TimetableLines.SetCurrentKey("Timetable Code", Class, "Template Code", "Line No.");
                l_TimetableLines.SetRange("Timetable Code", pTimetableCode);

                case pDate."Period No." of
                    1:
                        l_TimetableLines.SetFilter(Day, '%1', 1);
                    2:
                        l_TimetableLines.SetFilter(Day, '%1', 2);
                    3:
                        l_TimetableLines.SetFilter(Day, '%1', 3);
                    4:
                        l_TimetableLines.SetFilter(Day, '%1', 4);
                    5:
                        l_TimetableLines.SetFilter(Day, '%1', 5);
                    6:
                        l_TimetableLines.SetFilter(Day, '%1', 6);
                    7:
                        l_TimetableLines.SetFilter(Day, '%1', 7);
                end;

                if l_TimetableLines.Find('-') then
                    PercorrerLinhasDiario(l_Timetable, l_TimetableLines, pDate, AgregarGlobal);
            end;
        until pDate.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure PercorrerLinhasDiario(TabelaHorario: Record Timetable; var TabelaHorarioLinhasTEMP: Record "Timetable Lines" temporary; var TabelaData: Record Date; var AgregarGlobal: Integer)
    var
        Text001: Label 'Class';
    begin
        repeat
            WindowDialog.Update(1, Text001);
            WindowDialog.Update(2, TabelaHorario.Class);
            WindowDialog.Update(3, TabelaHorario."Timetable Code");
            WindowDialog.Update(4, Format(TabelaHorario."Start Period") + ' - ' + Format(TabelaHorario."End Period"));
            WindowDialog.Update(5, Format(TabelaData."Period Start"));
            WindowDialog.Update(6, TabelaHorarioLinhasTEMP.Subject);

            if TabelaHorario."Timetable Type" = TabelaHorario."Timetable Type"::Class then
                InserirCalendario(TabelaHorario, TabelaHorarioLinhasTEMP, TabelaData, AgregarGlobal)
            else
                InsertTeacherCalendar(TabelaHorario, TabelaHorarioLinhasTEMP, TabelaData, AgregarGlobal);
        until TabelaHorarioLinhasTEMP.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure InserirCalendario(pTimetable: Record Timetable; var pTimetableLines: Record "Timetable Lines" temporary; var pDate: Record Date; var AgregarGlobal: Integer)
    var
        rCalendar: Record Calendar;
        rTimetableTeacher: Record "Timetable-Teacher";
        rTeacherTimetableLines: Record "Teacher Timetable Lines";
        rSubject: Record Subjects;
        rClass: Record Class;
        rStructureEducationCountry: Record "Structure Education Country";
        rSubjectsGroup: Record "Subjects Group";
        AntigoAgregar: Integer;
        OldDay: Date;
        varNLine: Integer;
    begin
        if (AntigoAgregar <> pTimetableLines."Join Subjects") or (OldDay <> pDate."Period Start") then
            AgregarGlobal := AgregarGlobal + 1;

        AntigoAgregar := pTimetableLines."Join Subjects";
        OldDay := pDate."Period Start";

        Clear(varNLine);
        rCalendar.Reset;
        rCalendar.SetRange("Timetable Code", pTimetableLines."Timetable Code");
        if rCalendar.Find('+') then
            varNLine := rCalendar."Line No." + 10000
        else
            varNLine := 10000;

        rCalendar.Reset;
        rCalendar.Init;
        rCalendar."Timetable Code" := pTimetable."Timetable Code";
        rCalendar."Line No." := varNLine;
        rCalendar.Class := pTimetable.Class;
        rCalendar.Subject := pTimetableLines.Subject;
        rCalendar."Sub-Subject Code" := pTimetableLines."Sub-Subject Code";
        rCalendar."Filter Period" := pDate."Period Start";
        rCalendar."Start Hour" := pTimetableLines."Start Hour";
        rCalendar."End Hour" := pTimetableLines."End Hour";//HoraFinal; //TabelaHorarioLinhas."Hora Fim";
        rCalendar."Week Day" := pDate."Period No." - 1;
        rCalendar.Room := pTimetableLines.Room;
        rCalendar."Type Subject" := pTimetableLines.Type;
        rCalendar."Join Subjects" := AgregarGlobal; //TabelaHorarioLinhas."Agregar Disciplina"
        if rClass.Get(pTimetable.Class, pTimetable."School Year") then begin
            rStructureEducationCountry.Reset;
            rStructureEducationCountry.SetRange("Schooling Year", rClass."Schooling Year");
            rStructureEducationCountry.SetRange(Country, rClass."Country/Region Code");
            if rStructureEducationCountry.Find('-') then
                rCalendar."Absence Type" := rStructureEducationCountry."Absence Type";
            rCalendar."School Year" := rClass."School Year";
        end;
        rCalendar."Study Plan" := pTimetable."Study Plan";
        rCalendar."Study Plan Description" := pTimetable."Plan Study Description";
        rCalendar."Class Description" := pTimetable."Class Description";
        if pTimetableLines.Type = pTimetableLines.Type::Subject then begin
            if rSubject.Get(rSubject.Type::Subject, pTimetableLines.Subject) then
                rCalendar."Subject Description" := rSubject.Description;
        end;
        if pTimetableLines.Type = pTimetableLines.Type::"Non scholar hours" then begin
            if rSubject.Get(rSubject.Type::"Non scholar hours", pTimetableLines.Subject) then
                rCalendar."Subject Description" := rSubject.Description;
        end;
        if pTimetableLines.Type = pTimetableLines.Type::"Non scholar component" then begin
            if rSubject.Get(rSubject.Type::"Non scholar component", pTimetableLines.Subject) then
                rCalendar."Subject Description" := rSubject.Description;
        end;

        rCalendar.Times := pTimetableLines.Time;
        rCalendar.Type := pTimetable.Type;
        rCalendar.Turn := pTimetableLines.Turn;
        rCalendar."Responsibility Center" := pTimetable."Responsibility Center";
        rCalendar.Insert(true);

        rTeacherTimetableLines.Reset;
        rTeacherTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
        rTeacherTimetableLines.SetRange(Subject, pTimetableLines.Subject);
        rTeacherTimetableLines.SetRange("Timetable Line No.", pTimetableLines."Line No.");
        if rTeacherTimetableLines.Find('-') then begin
            repeat
                rTimetableTeacher.Init;
                rTimetableTeacher."Timetable Code" := pTimetable."Timetable Code";
                rTimetableTeacher."Teacher No." := rTeacherTimetableLines."Teacher No.";
                rTimetableTeacher."Teacher Name" := rTeacherTimetableLines.Name;
                rTimetableTeacher.Class := rCalendar.Class;
                rTimetableTeacher."Start Hour" := rCalendar."Start Hour";
                rTimetableTeacher."End Hour" := rCalendar."End Hour";
                rTimetableTeacher.Duration := rCalendar."Break (Hours)";
                if rClass.Get(pTimetable.Class, pTimetable."School Year") then
                    rTimetableTeacher."School Year" := rClass."School Year";
                rTimetableTeacher.Lecture := false;
                rTimetableTeacher."Timetable Line No." := rCalendar."Line No.";
                rTimetableTeacher."Lecture Status" := rCalendar."Lecture Status";
                rTimetableTeacher."Filter Period" := rCalendar."Filter Period";
                rTimetableTeacher.Subject := rCalendar.Subject;
                rTimetableTeacher."Sub-Subject Code" := rCalendar."Sub-Subject Code";
                rTimetableTeacher."Type Subject" := rCalendar."Type Subject";
                rTimetableTeacher.Turn := rTeacherTimetableLines.Turn;
                rTimetableTeacher."Responsibility Center" := pTimetable."Responsibility Center";
                rTimetableTeacher."Week Day" := pTimetableLines."Day Description";
                rTimetableTeacher.Room := pTimetableLines.Room;
                rTimetableTeacher.Times := pTimetableLines.Time;
                rTimetableTeacher.Meeting := pTimetableLines.Meeting;
                if pTimetableLines.Meeting <> pTimetableLines.Meeting::"Head Department" then begin
                    rTimetableTeacher.Target := pTimetableLines.Target;
                end else begin
                    rSubjectsGroup.Reset;
                    rSubjectsGroup.SetRange(rSubjectsGroup.Type, rSubjectsGroup.Type::Subject);
                    rSubjectsGroup.SetRange(rSubjectsGroup."Head of Department", rTeacherTimetableLines."Teacher No.");
                    if rSubjectsGroup.FindFirst then
                        rTimetableTeacher.Target := rSubjectsGroup.Code;
                end;

                rTimetableTeacher.Level := pTimetableLines.Level;
                rTimetableTeacher.Insert;
            until rTeacherTimetableLines.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertTeacherCalendar(pTimetable: Record Timetable; var pTimetableLinesTEMP: Record "Timetable Lines" temporary; var pDate: Record Date; var AgregarGlobal: Integer)
    var
        rClass: Record Class;
        l_TimetableTeacher: Record "Timetable-Teacher";
        l_TeacherTimetableLines: Record "Teacher Timetable Lines";
        rSubjectsGroup: Record "Subjects Group";
    begin
        l_TeacherTimetableLines.Reset;
        l_TeacherTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
        l_TeacherTimetableLines.SetRange("Timetable Line No.", pTimetableLinesTEMP."Line No.");
        if l_TeacherTimetableLines.Find('-') then begin
            repeat
                l_TimetableTeacher.Init;
                l_TimetableTeacher."Timetable Code" := pTimetable."Timetable Code";
                l_TimetableTeacher."Timetable Line No." := pTimetableLinesTEMP."Line No.";
                l_TimetableTeacher."Teacher No." := l_TeacherTimetableLines."Teacher No.";
                l_TimetableTeacher."Teacher Name" := l_TeacherTimetableLines.Name;
                l_TimetableTeacher."Start Hour" := pTimetableLinesTEMP."Start Hour";
                l_TimetableTeacher."End Hour" := pTimetableLinesTEMP."End Hour";
                if rClass.Get(pTimetable.Class, pTimetable."School Year") then
                    l_TimetableTeacher."School Year" := rClass."School Year"
                else
                    l_TimetableTeacher."School Year" := pTimetable."School Year";
                l_TimetableTeacher.Subject := pTimetableLinesTEMP.Subject;
                l_TimetableTeacher.Lecture := false;
                l_TimetableTeacher."Filter Period" := pDate."Period Start";
                l_TimetableTeacher.Observations := l_TeacherTimetableLines.Observations;
                l_TimetableTeacher."Responsibility Center" := pTimetable."Responsibility Center";
                l_TimetableTeacher."Type Subject" := pTimetableLinesTEMP.Type;
                l_TimetableTeacher."Week Day" := pTimetableLinesTEMP."Day Description";
                l_TimetableTeacher.Room := pTimetableLinesTEMP.Room;
                l_TimetableTeacher.Times := pTimetableLinesTEMP.Time;
                l_TimetableTeacher.Meeting := pTimetableLinesTEMP.Meeting;

                if pTimetableLinesTEMP.Meeting <> pTimetableLinesTEMP.Meeting::"Head Department" then begin
                    l_TimetableTeacher.Target := pTimetableLinesTEMP.Target;
                end else begin
                    rSubjectsGroup.Reset;
                    rSubjectsGroup.SetRange(rSubjectsGroup.Type, rSubjectsGroup.Type::Subject);
                    rSubjectsGroup.SetRange(rSubjectsGroup."Head of Department", l_TeacherTimetableLines."Teacher No.");
                    if rSubjectsGroup.FindFirst then
                        l_TimetableTeacher.Target := rSubjectsGroup.Code;
                end;

                l_TimetableTeacher.Level := pTimetableLinesTEMP.Level;
                l_TimetableTeacher.Insert;
            until l_TeacherTimetableLines.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure BuscarAgregarDisciplina(): Integer
    var
        l_Calendar: Record Calendar;
    begin
        l_Calendar.Reset;
        l_Calendar.SetCurrentKey("Join Subjects");
        l_Calendar.Ascending(true);
        if l_Calendar.Find('+') then
            exit(l_Calendar."Join Subjects")
        else
            exit(0);
    end;

    //[Scope('OnPrem')]
    procedure ApagarAlunosFaltas(pSchoolYear: Code[9]; pStudyPlan: Code[20]; pClass: Code[20]; pStartPeriod: Date; pEndPeriod: Date; pFilterDate: Date)
    var
        l_Calendar: Record Calendar;
        l_Absence: Record Absence;
        TabRegistrationClass: Record "Registration Class";
        rClass: Record Class;
    begin
        // Lanca os alunos na tabela faltas.

        l_Calendar.Reset;
        if rClass.Get(pClass, pSchoolYear) then
            l_Calendar.SetRange("School Year", rClass."School Year")
        else
            l_Calendar.SetRange("School Year", pSchoolYear);
        l_Calendar.SetRange("Study Plan", pStudyPlan);
        l_Calendar.SetRange(Class, pClass);
        if (pStartPeriod <> 0D) and (pEndPeriod <> 0D) then
            l_Calendar.SetFilter("Filter Period", '%1..%2', pStartPeriod, pEndPeriod)
        else
            l_Calendar.SetRange("Filter Period", pFilterDate);
        if l_Calendar.Find('-') then begin
            repeat
                TabRegistrationClass.Reset;
                TabRegistrationClass.SetRange("School Year", l_Calendar."School Year");
                TabRegistrationClass.SetRange("Study Plan Code", l_Calendar."Study Plan");
                TabRegistrationClass.SetRange(Class, l_Calendar.Class);
                TabRegistrationClass.SetFilter(Status, '%1|%2|%3', TabRegistrationClass.Status::Transfer, TabRegistrationClass.Status::Annuled
                                                                , TabRegistrationClass.Status::" ");
                if TabRegistrationClass.Find('-') then begin
                    repeat
                        if (TabRegistrationClass.Status = TabRegistrationClass.Status::" ") then begin
                            l_Absence.Reset;
                            l_Absence.SetRange("School Year", l_Calendar."School Year");
                            l_Absence.SetRange("Study Plan", l_Calendar."Study Plan");
                            l_Absence.SetRange(Class, l_Calendar.Class);
                            l_Absence.SetRange(Subject, l_Calendar.Subject);
                            l_Absence.SetRange(Day, l_Calendar."Filter Period");
                            l_Absence.SetRange("Student/Teacher Code No.", TabRegistrationClass."Student Code No.");
                            if l_Absence.Find('-') then
                                l_Absence.DeleteAll;
                        end;
                        if (TabRegistrationClass.Status = TabRegistrationClass.Status::Transfer) and
                           (TabRegistrationClass."Status Date" > l_Calendar."Filter Period") then begin
                            l_Absence.Reset;
                            l_Absence.SetRange("School Year", l_Calendar."School Year");
                            l_Absence.SetRange("Study Plan", l_Calendar."Study Plan");
                            l_Absence.SetRange(Class, l_Calendar.Class);
                            l_Absence.SetRange(Subject, l_Calendar.Subject);
                            l_Absence.SetRange(Day, l_Calendar."Filter Period");
                            l_Absence.SetRange("Student/Teacher Code No.", TabRegistrationClass."Student Code No.");
                            if l_Absence.Find('-') then
                                l_Absence.DeleteAll;
                        end;

                        if (TabRegistrationClass.Status = TabRegistrationClass.Status::Annuled) and
                           (TabRegistrationClass."Status Date" > l_Calendar."Filter Period") then begin
                            l_Absence.Reset;
                            l_Absence.SetRange("School Year", l_Calendar."School Year");
                            l_Absence.SetRange("Study Plan", l_Calendar."Study Plan");
                            l_Absence.SetRange(Class, l_Calendar.Class);
                            l_Absence.SetRange(Subject, l_Calendar.Subject);
                            l_Absence.SetRange(Day, l_Calendar."Filter Period");
                            l_Absence.SetRange("Student/Teacher Code No.", TabRegistrationClass."Student Code No.");
                            if l_Absence.Find('-') then
                                l_Absence.DeleteAll;
                        end;
                    until TabRegistrationClass.Next = 0;
                end;
            until l_Calendar.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure LancarAlunosFaltas(pSchoolYear: Code[9]; pStudyPlan: Code[20]; pClass: Code[20]; pStartPeriod: Date; pEndPeriod: Date; pFilterDate: Date)
    var
        TabCalendario: Record Calendar;
        TabFaltas: Record Absence;
        TabFaltas2: Record Absence;
        TabRegistrationClass: Record "Registration Class";
        TabStudent: Record Students;
        rClass: Record Class;
        LineNo: Integer;
        Text001: Label 'Course Code                    #1#####################\';
        Text002: Label 'Class Code                     #2#####################\';
        Text003: Label 'Timetable code                 #3#####################\';
        Text004: Label 'Starting date - Ending date    #4#####################\';
        Text005: Label 'Day                            #5#####################\';
        Text006: Label 'Subject                     #6#####################\';
        Text008: Label 'Generating Timetable\';
    begin
        // Lanca os alunos na tabela faltas.

        Clear(WindowDialog);

        WindowDialog.Open(
                Text008 +
                Text001 +
                Text002 +
                Text003 +
                Text004 +
                Text005 +
                Text006);

        TabFaltas.Reset;
        if TabFaltas.Find('+') then
            LineNo := TabFaltas."Line No.";


        TabCalendario.Reset;
        TabCalendario.SetCurrentKey("Timetable Code", "School Year", "Study Plan", Class, "Line No.");
        if rClass.Get(pClass, pSchoolYear) then
            TabCalendario.SetRange("School Year", rClass."School Year")
        else
            TabCalendario.SetRange("School Year", pSchoolYear);
        TabCalendario.SetRange("Study Plan", pStudyPlan);
        TabCalendario.SetRange(Class, pClass);
        if (pStartPeriod <> 0D) and (pEndPeriod <> 0D) then
            TabCalendario.SetRange("Filter Period", pStartPeriod, pEndPeriod)
        else
            TabCalendario.SetRange("Filter Period", pFilterDate);
        if TabCalendario.Find('-') then begin
            repeat
                TabRegistrationClass.Reset;
                TabRegistrationClass.SetCurrentKey("School Year", "Study Plan Code", Class, Status);
                TabRegistrationClass.SetRange("School Year", TabCalendario."School Year");
                TabRegistrationClass.SetRange("Study Plan Code", TabCalendario."Study Plan");
                TabRegistrationClass.SetRange(Class, TabCalendario.Class);
                TabRegistrationClass.SetRange(Status, TabRegistrationClass.Status::Subscribed);
                if TabRegistrationClass.Find('-') then begin
                    repeat
                        if ((TabRegistrationClass."Status Date" <= TabCalendario."Filter Period")
                            and (TabRegistrationClass."Status Date" >= TabCalendario."Filter Period")) then begin
                            TabFaltas.Reset;
                            TabFaltas.SetCurrentKey("Timetable Code", "School Year", "Study Plan", Class, "Absence Type", "Student/Teacher Code No.");
                            TabFaltas.SetRange("Timetable Code", TabCalendario."Timetable Code");
                            TabFaltas.SetRange("School Year", TabCalendario."School Year");
                            TabFaltas.SetRange("Study Plan", TabCalendario."Study Plan");
                            TabFaltas.SetRange(Class, TabCalendario.Class);
                            if TabCalendario."Absence Type" = TabCalendario."Absence Type"::Daily then
                                TabFaltas.SetRange(Day, TabCalendario."Filter Period")
                            else
                                TabFaltas.SetRange("Line No. Timetable", TabCalendario."Line No.");
                            TabFaltas.SetRange("Student/Teacher Code No.", TabRegistrationClass."Student Code No.");
                            if not TabFaltas.Find('-') then begin
                                LineNo += 1;
                                TabFaltas2.Init;
                                TabFaltas2."Timetable Code" := TabCalendario."Timetable Code";
                                TabFaltas2."School Year" := TabCalendario."School Year";
                                TabFaltas2."Study Plan" := TabCalendario."Study Plan";
                                TabFaltas2.Class := TabCalendario.Class;
                                if TabCalendario."Absence Type" = TabCalendario."Absence Type"::Lecture then
                                    TabFaltas2.Subject := TabCalendario.Subject;
                                TabFaltas2."Student/Teacher Code No." := TabRegistrationClass."Student Code No.";
                                TabFaltas2."Class No." := TabRegistrationClass."Class No.";
                                TabFaltas2."Incidence Type" := TabFaltas2."Incidence Type"::Absence;
                                TabFaltas2.Day := TabCalendario."Filter Period";
                                if TabCalendario."Absence Type" = TabCalendario."Absence Type"::Lecture then
                                    TabFaltas2."Line No. Timetable" := TabCalendario."Line No.";
                                TabFaltas2."Line No." := LineNo;
                                TabFaltas2."Absence Type" := TabCalendario."Absence Type";
                                if TabStudent.Get(TabRegistrationClass."Student Code No.") then
                                    TabFaltas2."Student Name" := TabStudent.Name;
                                TabFaltas2.Type := TabCalendario.Type;
                                TabFaltas2.Insert;
                            end;
                        end;
                        WindowDialog.Update(1, TabCalendario."Study Plan");
                        WindowDialog.Update(2, TabCalendario.Class);
                        WindowDialog.Update(3, TabCalendario."Timetable Code");
                        WindowDialog.Update(4, Format(pStartPeriod) + ' - ' + Format(pEndPeriod));
                        WindowDialog.Update(5, Format(TabCalendario."Filter Period"));
                        WindowDialog.Update(6, TabStudent.Name);
                    until TabRegistrationClass.Next = 0;
                end;
            until TabCalendario.Next = 0;
        end;

        WindowDialog.Close;
    end;

    //[Scope('OnPrem')]
    procedure InserirCalendarioProf(pCalendarTEMP: Record Calendar temporary; pStartPeriod: Date; pStartHour: Time; pEndHour: Time; PLineNo: Integer)
    var
        l_Calendar: Record Calendar;
        l_Subject: Record Subjects;
        l_TimetableTeacher: Record "Timetable-Teacher";
        l_Date: Record Date;
        l_TimetableTeacherInsert: Record "Timetable-Teacher-Insert";
        CountProf: Integer;
    begin

        l_Calendar.Init;
        l_Calendar."Timetable Code" := pCalendarTEMP."Timetable Code";
        l_Calendar."Line No." := pCalendarTEMP."Line No.";
        l_Calendar.Class := pCalendarTEMP.Class;
        l_Calendar.Subject := pCalendarTEMP.Subject;
        l_Calendar."Sub-Subject Code" := pCalendarTEMP."Sub-Subject Code";
        if pStartPeriod <> 0D then
            l_Calendar."Filter Period" := pStartPeriod
        else
            l_Calendar."Filter Period" := pCalendarTEMP."Filter Period";

        if pStartHour <> 0T then
            l_Calendar."Start Hour" := pStartHour
        else
            l_Calendar."Start Hour" := pCalendarTEMP."Start Hour";

        if pEndHour <> 0T then
            l_Calendar."End Hour" := pEndHour
        else
            l_Calendar."End Hour" := pCalendarTEMP."End Hour";//HoraFinal; //TabelaHorarioLinhas."Hora Fim";

        l_Date.Reset;
        l_Date.SetRange("Period Start", pCalendarTEMP."Filter Period");
        if l_Date.Find('-') then
            l_Calendar."Week Day" := l_Date."Period No." - 1;

        l_Calendar.Room := pCalendarTEMP.Room;
        l_Calendar."Study Plan" := pCalendarTEMP."Study Plan";
        l_Calendar."School Year" := pCalendarTEMP."School Year";
        l_Calendar."Study Plan Description" := pCalendarTEMP."Study Plan Description";
        l_Calendar."Class Description" := pCalendarTEMP."Class Description";
        if l_Subject.Get(pCalendarTEMP."Type Subject", pCalendarTEMP.Subject) then
            l_Calendar."Subject Description" := l_Subject.Description;
        l_Calendar.Times := pCalendarTEMP.Times;
        l_Calendar.Type := pCalendarTEMP.Type;
        l_Calendar.Turn := pCalendarTEMP.Turn;
        l_Calendar."Sub-Subject Code" := pCalendarTEMP."Sub-Subject Code";
        l_Calendar.Type := pCalendarTEMP.Type;
        l_Calendar."Type Subject" := pCalendarTEMP."Type Subject";
        l_Calendar."Responsibility Center" := pCalendarTEMP."Responsibility Center";
        l_Calendar.Insert(true);

        l_TimetableTeacherInsert.Reset;
        l_TimetableTeacherInsert.SetRange("School Year", pCalendarTEMP."School Year");
        l_TimetableTeacherInsert.SetRange("Study Plan", pCalendarTEMP."Study Plan");
        l_TimetableTeacherInsert.SetRange(Class, pCalendarTEMP.Class);
        l_TimetableTeacherInsert.SetRange("Timetable Code", pCalendarTEMP."Timetable Code");
        l_TimetableTeacherInsert.SetRange("Cab Line", PLineNo);
        if l_TimetableTeacherInsert.Find('-') then begin
            repeat
                l_TimetableTeacher.Init;
                l_TimetableTeacher."Timetable Code" := l_TimetableTeacherInsert."Timetable Code";
                l_TimetableTeacher."Timetable Line No." := l_Calendar."Line No.";
                l_TimetableTeacher."Teacher No." := l_TimetableTeacherInsert."Teacher No.";
                l_TimetableTeacher."Teacher Name" := l_TimetableTeacherInsert.Name;
                l_TimetableTeacher.Class := l_TimetableTeacherInsert.Class;
                l_TimetableTeacher."Start Hour" := pCalendarTEMP."Start Hour";
                l_TimetableTeacher."End Hour" := pCalendarTEMP."End Hour";
                l_TimetableTeacher.Duration := pCalendarTEMP."Break (Hours)";
                l_TimetableTeacher."School Year" := l_TimetableTeacherInsert."School Year";
                l_TimetableTeacher.Lecture := false;
                if CountProf = 1 then
                    l_TimetableTeacher.Lecture := true;
                l_TimetableTeacher.Turn := pCalendarTEMP.Turn;
                l_TimetableTeacher."Lecture Status" := pCalendarTEMP."Lecture Status";
                l_TimetableTeacher."Filter Period" := pCalendarTEMP."Filter Period";
                l_TimetableTeacher.Subject := pCalendarTEMP.Subject;
                l_TimetableTeacher."Sub-Subject Code" := pCalendarTEMP."Sub-Subject Code";
                l_TimetableTeacher.Insert;
            until l_TimetableTeacherInsert.Next = 0;
        end
    end;

    //[Scope('OnPrem')]
    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean
    begin
        BaseCalendarChangeEDU.Reset;
        BaseCalendarChangeEDU.SetRange("Base Calendar Code", CalendarCode);
        BaseCalendarChangeEDU.SetRange(Type, BaseCalendarChangeEDU.Type::Lines);
        if BaseCalendarChangeEDU.FindSet then
            repeat
                case BaseCalendarChangeEDU."Recurring System" of
                    BaseCalendarChangeEDU."Recurring System"::" ":
                        if TargetDate = BaseCalendarChangeEDU.Date then begin
                            Description := BaseCalendarChangeEDU.Description;
                            exit(BaseCalendarChangeEDU.Nonworking);
                        end;
                    BaseCalendarChangeEDU."Recurring System"::"Weekly Recurring":
                        if Date2DWY(TargetDate, 1) = BaseCalendarChangeEDU.Day then begin
                            Description := BaseCalendarChangeEDU.Description;
                            exit(BaseCalendarChangeEDU.Nonworking);
                        end;
                    BaseCalendarChangeEDU."Recurring System"::"Annual Recurring":
                        if (Date2DMY(TargetDate, 2) = Date2DMY(BaseCalendarChangeEDU.Date, 2)) and
                           (Date2DMY(TargetDate, 1) = Date2DMY(BaseCalendarChangeEDU.Date, 1))
                        then begin
                            Description := BaseCalendarChangeEDU.Description;
                            exit(BaseCalendarChangeEDU.Nonworking);
                        end;
                end;
            until BaseCalendarChangeEDU.Next = 0;
        Description := '';
    end;

    //[Scope('OnPrem')]
    procedure FindDate(SearchString: Text[3]; var Calendar: Record Date; PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"): Boolean
    var
        Found: Boolean;
    begin
        Calendar.SetRange("Period Type", PeriodType);
        Calendar."Period Type" := PeriodType;
        if Calendar."Period Start" = 0D then
            Calendar."Period Start" := WorkDate;
        if SearchString in ['', '=><'] then
            SearchString := '=<>';
        if PeriodType = PeriodType::"Accounting Period" then begin
            SetAccountingPeriodFilter(Calendar);
            Found := AccountingPeriod.Find(SearchString);
            if Found then
                CopyAccountingPeriod(Calendar);
        end else begin
            Found := Calendar.Find(SearchString);
            if Found then
                Calendar."Period End" := NormalDate(Calendar."Period End");
        end;
        exit(Found);
    end;

    //[Scope('OnPrem')]
    procedure NextDate(NextStep: Integer; var Calendar: Record Date; PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period"): Integer
    begin
        Calendar.SetRange("Period Type", PeriodType);
        Calendar."Period Type" := PeriodType;
        if PeriodType = PeriodType::"Accounting Period" then begin
            SetAccountingPeriodFilter(Calendar);
            NextStep := AccountingPeriod.Next(NextStep);
            if NextStep <> 0 then
                CopyAccountingPeriod(Calendar);
        end else begin
            NextStep := Calendar.Next(NextStep);
            if NextStep <> 0 then
                Calendar."Period End" := NormalDate(Calendar."Period End");
        end;
        exit(NextStep);
    end;

    local procedure SetAccountingPeriodFilter(var Calendar: Record Date)
    begin
        AccountingPeriod.SetFilter("Starting Date", Calendar.GetFilter("Period Start"));
        AccountingPeriod.SetFilter(Name, Calendar.GetFilter("Period Name"));
        AccountingPeriod."Starting Date" := Calendar."Period Start";
    end;

    local procedure CopyAccountingPeriod(var Calendar: Record Date)
    begin
        Calendar.Init;
        Calendar."Period Start" := AccountingPeriod."Starting Date";
        Calendar."Period Name" := AccountingPeriod.Name;
        if AccountingPeriod.Next = 0 then
            Calendar."Period End" := 99991231D
        else
            Calendar."Period End" := AccountingPeriod."Starting Date" - 1;
    end;

    //[Scope('OnPrem')]
    procedure CreateCalendarAndValidation(pTimetable: Record Timetable; var l_rTimetableLines: Record "Timetable Lines"; var l_TeacherTimetableLines: Record "Teacher Timetable Lines"; var ErrorMessage: Text[250]): Boolean
    var
        l_Text01: Label 'There are absences for this timetable period. ';
        l_Text02: Label 'There are summaried lectures with an entry date later then the begining of this timetable.';
        l_Text04: Label 'The timetable %1 of the type %2, already have a created calendar.';
        l_Text05: Label 'Please fill the field %1 in timetable lines %2.';
        l_Text06: Label 'Please Insert teacher to create the calendar.';
        l_rCalendar: Record Calendar;
        l_Absence: Record Absence;
        l_Text07: Label 'Please fill the field %1 in the Edu. Configuration Form.';
        l_Text08: Label 'Please fill the field %1.';
        l_Text09: Label 'Please fill the field %1.';
        l_rStudyplanLines: Record "Study Plan Lines";
        l_rCourseLines: Record "Course Lines";
        l_Text10: Label 'Please fill the field %1 in Subject %2.';
        l_rTimetableLines1: Record "Timetable Lines";
    begin
        if pTimetable."Timetable Type" = pTimetable."Timetable Type"::Teacher then begin
            if pTimetable."Blocked Teacher" then begin
                ErrorMessage := StrSubstNo(l_Text04, pTimetable."Timetable Code", pTimetable."Timetable Type");
                exit(true);
            end;
        end else
            if pTimetable.Blocked then begin
                ErrorMessage := StrSubstNo(l_Text04, pTimetable."Timetable Code", pTimetable."Timetable Type");
                exit(true);
            end;

        if pTimetable."School Calendar" = '' then begin
            ErrorMessage := StrSubstNo(l_Text07, pTimetable.FieldCaption("School Calendar"));
            exit(true);
        end;
        if pTimetable."Start Period" = 0D then begin
            ErrorMessage := StrSubstNo(l_Text08, pTimetable.FieldCaption("Start Period"));
            exit(true);
        end;
        if pTimetable."End Period" = 0D then begin
            ErrorMessage := StrSubstNo(l_Text09, pTimetable.FieldCaption("End Period"));
            exit(true);
        end;

        if pTimetable."Timetable Type" <> pTimetable."Timetable Type"::Teacher then begin
            l_rTimetableLines.Reset;
            l_rTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
            l_rTimetableLines.SetRange(Subject, '');
            if l_rTimetableLines.FindFirst then begin
                ErrorMessage := StrSubstNo(l_Text05, l_rTimetableLines.FieldCaption(Subject), pTimetable."Timetable Code");
                exit(true);
            end;
            l_rTimetableLines.Reset;
            l_rTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
            l_rTimetableLines.SetFilter(Subject, '<>%1', '');
            l_rTimetableLines.SetRange("Sub-Subject Code", '');
            if l_rTimetableLines.FindSet then begin
                repeat
                    if pTimetable.Type = pTimetable.Type::Simple then begin
                        l_rStudyplanLines.Reset;
                        l_rStudyplanLines.SetRange(Code, pTimetable."Study Plan");
                        l_rStudyplanLines.SetRange("School Year", pTimetable."School Year");
                        l_rStudyplanLines.SetRange("Subject Code", l_rTimetableLines.Subject);
                        l_rStudyplanLines.SetRange("Sub-subjects for assess. only", false);
                        l_rStudyplanLines.CalcFields("Sub-Subject");
                        l_rStudyplanLines.SetRange("Sub-Subject", true);
                        if l_rStudyplanLines.FindFirst then begin
                            ErrorMessage := StrSubstNo(l_Text10,
                                                       l_rTimetableLines.FieldCaption(l_rTimetableLines."Sub-Subject Code")
                                                       , l_rTimetableLines.Subject);
                            exit(true);
                        end;
                    end;
                    if pTimetable.Type = pTimetable.Type::Multi then begin
                        l_rCourseLines.Reset;
                        l_rCourseLines.SetRange(Code, pTimetable."Study Plan");
                        l_rCourseLines.SetRange("Subject Code", l_rTimetableLines.Subject);
                        l_rCourseLines.SetRange("Sub-subjects for assess. only", false);
                        l_rCourseLines.CalcFields("Sub-Subject");
                        l_rCourseLines.SetRange("Sub-Subject", true);
                        if l_rCourseLines.FindFirst then begin
                            ErrorMessage := StrSubstNo(l_Text10,
                                                       l_rTimetableLines.FieldCaption(l_rTimetableLines."Sub-Subject Code")
                                                       , l_rTimetableLines.Subject);
                            exit(true);
                        end;
                    end;
                until l_rTimetableLines.Next = 0;
            end;
            ValidateLines(l_rTimetableLines);
        end;

        l_rTimetableLines.Reset;
        l_rTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
        l_rTimetableLines.SetRange(Room, '');
        l_rTimetableLines.SetFilter(Type, '<>%1', l_rTimetableLines.Type::"Non scholar hours");
        if l_rTimetableLines.FindFirst then begin
            ErrorMessage := StrSubstNo(l_Text05, l_rTimetableLines.FieldCaption(Room), pTimetable."Timetable Code");
            exit(true);
        end;
        l_TeacherTimetableLines.Reset;
        l_TeacherTimetableLines.SetRange("Timetable Code", pTimetable."Timetable Code");
        l_TeacherTimetableLines.SetRange("Timetable Line No.", 10000);
        l_TeacherTimetableLines.SetRange("Teacher No.", '');
        if l_TeacherTimetableLines.FindFirst then begin
            ErrorMessage := StrSubstNo(l_Text06);
            exit(true);
        end;
        if pTimetable."Timetable Type" = pTimetable."Timetable Type"::Class then begin

            // Aulas com sumário
            l_rCalendar.Reset;
            l_rCalendar.SetRange(l_rCalendar.Class, pTimetable.Class);
            l_rCalendar.SetFilter("Filter Period", '>=%1', pTimetable."Start Period");
            l_rCalendar.SetRange("Lecture Status", l_rCalendar."Lecture Status"::Summary);
            if l_rCalendar.FindFirst then begin
                ErrorMessage := StrSubstNo(l_Text02);
                exit(true);
            end;
            // Aulas com faltas marcadas
            l_Absence.Reset;
            l_Absence.SetRange("School Year", pTimetable."School Year");
            l_Absence.SetRange(l_Absence.Class, pTimetable.Class);
            l_Absence.SetRange("Student/Teacher", l_Absence."Student/Teacher"::Student);
            l_Absence.SetRange(l_Absence.Day, pTimetable."Start Period", pTimetable."End Period");
            if l_Absence.FindFirst then begin
                ErrorMessage := StrSubstNo(l_Text01);
                exit(true);
            end;

        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateLines(var pTimetableLines: Record "Timetable Lines")
    var
        l_rTimetableLines: Record "Timetable Lines";
        Text001: Label 'There is already a timetable line for the day %1, in the subject %2.';
        l_rTimetableLines2: Record "Timetable Lines";
        Text002: Label 'There is already a room %1 associated for the day %2, in the subject %3.';
    begin
        //// Line validation /////
        l_rTimetableLines.Reset;
        l_rTimetableLines.SetRange("Timetable Code", pTimetableLines."Timetable Code");
        l_rTimetableLines.SetRange(Class, pTimetableLines.Class);
        l_rTimetableLines.SetRange(Day, pTimetableLines.Day);
        l_rTimetableLines.SetRange("Start Hour", pTimetableLines."Start Hour");
        l_rTimetableLines.SetRange("End Hour", pTimetableLines."End Hour");
        if pTimetableLines."Sub-Subject Code" <> '' then
            l_rTimetableLines.SetRange("Sub-Subject Code", pTimetableLines."Sub-Subject Code")
        else
            l_rTimetableLines.SetRange("Sub-Subject Code", '');
        if pTimetableLines.Subject <> '' then
            l_rTimetableLines.SetRange(Subject, pTimetableLines.Subject);
        if pTimetableLines.Turn <> '' then
            l_rTimetableLines.SetRange(Turn, pTimetableLines.Turn)
        else
            l_rTimetableLines.SetRange(Turn, '');
        l_rTimetableLines.SetFilter("Line No.", '<>%1', pTimetableLines."Line No.");
        if l_rTimetableLines.FindFirst then begin
            Error(Text001, pTimetableLines."Day Description", pTimetableLines.Subject);
        end;

        //////// Room Validation
        l_rTimetableLines2.Reset;
        l_rTimetableLines2.SetRange("Timetable Code", pTimetableLines."Timetable Code");
        l_rTimetableLines2.SetRange(Class, pTimetableLines.Class);
        l_rTimetableLines2.SetRange(Day, pTimetableLines.Day);
        l_rTimetableLines2.SetRange("Start Hour", pTimetableLines."Start Hour");
        l_rTimetableLines2.SetRange("End Hour", pTimetableLines."End Hour");
        l_rTimetableLines2.SetRange(Room, pTimetableLines.Room);
        l_rTimetableLines2.SetFilter("Line No.", '<>%1', pTimetableLines."Line No.");
        if l_rTimetableLines2.FindFirst then begin
            Error(Text002, pTimetableLines.Room, pTimetableLines."Day Description", pTimetableLines.Subject);
        end;
    end;
}

