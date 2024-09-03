report 52856 Timetable
{
    DefaultLayout = RDLC;
    RDLCLayout = './Timetable.rdlc';
    Caption = 'Timetable';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Cabecalho; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(vAlvo; vAlvo)
            {
            }
            column(HorariCaption; HorariCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cabecalho_Number; Number)
            {
            }

            trigger OnPreDataItem()
            begin
                if vSchoolYear = '' then Error(Text0001);
                if vDataIni = 0D then Error(Text0002);
                if vDataFim = 0D then Error(Text0003);
                if vType = vType::Class then
                    if vClass = '' then Error(Text0004);
                if vType = vType::Teacher then
                    if vTeacher = '' then Error(Text0005);
                if (vDataFim - vDataIni) > 6 then Error(Text0007);

                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;


                if vType = vType::Class then
                    vAlvo := vDescClass
                else
                    vAlvo := vTeacherName;


                Filtros := vSchoolYear + '; ' + Format(vDataIni) + '..' + Format(vDataFim);
            end;
        }
        dataitem(DiasSemana; Calendar)
        {
            DataItemTableView = SORTING("Week Day");

            trigger OnAfterGetRecord()
            begin
                if vDiaSemana <> DiasSemana."Week Day" then begin
                    i := i + 1;
                    vDayDescription[i] := Format(DiasSemana."Week Day");
                    vDay[i] := DiasSemana."Week Day" + 1;
                    vDiaSemana := DiasSemana."Week Day";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Class then begin
                    //DiasSemana.SETRANGE(DiasSemana.Class,vClass);
                    DiasSemana.SetRange(DiasSemana."Filter Period", vDataIni, vDataFim);
                    vDiaSemana := 20;
                    Clear(i);
                end else
                    CurrReport.Break;
            end;
        }
        dataitem(Horas; Calendar)
        {
            DataItemTableView = SORTING("Start Hour");
            column(vDayDescription_1_; vDayDescription[1])
            {
            }
            column(vDayDescription_3_; vDayDescription[3])
            {
            }
            column(vDayDescription_2_; vDayDescription[2])
            {
            }
            column(vDayDescription_4_; vDayDescription[4])
            {
            }
            column(vDayDescription_5_; vDayDescription[5])
            {
            }
            column(Text0006; Text0006)
            {
            }
            column(Text0006_Control1102065115; Text0006)
            {
            }
            column(Text0006_Control1102065117; Text0006)
            {
            }
            column(Text0006_Control1102065119; Text0006)
            {
            }
            column(Text0006_Control1102065121; Text0006)
            {
            }
            column(Horas_Timetable_Code; "Timetable Code")
            {
            }
            column(Horas_School_Year; "School Year")
            {
            }
            column(Horas_Study_Plan; "Study Plan")
            {
            }
            column(Horas_Class; Class)
            {
            }
            column(Horas_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if vHora <> Horas."Start Hour" then begin
                    TempHoras.Init;
                    TempHoras.TransferFields(Horas);
                    TempHoras.Insert;
                    vHora := Horas."Start Hour"
                end;
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Class then begin
                    Horas.SetRange(Horas.Class, vClass);
                    Horas.SetRange(Horas."Filter Period", vDataIni, vDataFim);
                    Clear(vHora);
                end else
                    CurrReport.Break;
            end;
        }
        dataitem(Horas2; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(FORMAT_TempHoras__Start_Hour__0___Hours24___Minutes_2___; Format(TempHoras."Start Hour", 0, '<Hours24>:<Minutes,2>'))
            {
            }
            column(FORMAT_TempHoras__End_Hour__0___Hours24___Minutes_2___; Format(TempHoras."End Hour", 0, '<Hours24>:<Minutes,2>'))
            {
            }
            column(vSubject_1_; vSubject[1])
            {
            }
            column(vSubject_2_; vSubject[2])
            {
            }
            column(vSubject_4_; vSubject[4])
            {
            }
            column(vSubject_3_; vSubject[3])
            {
            }
            column(vSubject_5_; vSubject[5])
            {
            }
            column(vRoom_2_; vRoom[2])
            {
            }
            column(vRoom_3_; vRoom[3])
            {
            }
            column(vRoom_4_; vRoom[4])
            {
            }
            column(vRoom_5_; vRoom[5])
            {
            }
            column(vRoom_1_; vRoom[1])
            {
            }
            column(Horas2_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Horas2.Number <> 1 then
                    TempHoras.Next;

                vSubject[1] := GetSubject(TempHoras."Start Hour", 1);
                vSubject[2] := GetSubject(TempHoras."Start Hour", 2);
                vSubject[3] := GetSubject(TempHoras."Start Hour", 3);
                vSubject[4] := GetSubject(TempHoras."Start Hour", 4);
                vSubject[5] := GetSubject(TempHoras."Start Hour", 5);
                vSubject[6] := GetSubject(TempHoras."Start Hour", 6);
                vSubject[7] := GetSubject(TempHoras."Start Hour", 7);

                vRoom[1] := GetRoom(TempHoras."Start Hour", 1);
                vRoom[2] := GetRoom(TempHoras."Start Hour", 2);
                vRoom[3] := GetRoom(TempHoras."Start Hour", 3);
                vRoom[4] := GetRoom(TempHoras."Start Hour", 4);
                vRoom[5] := GetRoom(TempHoras."Start Hour", 5);
                vRoom[6] := GetRoom(TempHoras."Start Hour", 6);
                vRoom[7] := GetRoom(TempHoras."Start Hour", 7);
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Class then begin

                    TempHoras.Reset;
                    TempHoras.SetCurrentKey(TempHoras."Start Hour");
                    Horas2.SetRange(Horas2.Number, 1, TempHoras.Count);
                    if TempHoras.FindFirst then;

                end else
                    CurrReport.Break;
            end;
        }
        dataitem("Teacher Class"; "Teacher Class")
        {
            DataItemTableView = SORTING("School Year", Class, "Subject Code", "Sub-Subject Code", "Allow Assign Evaluations") WHERE("Subject Code" = FILTER(<> ''));
            column(Teacher_Class__Teacher_Class___Subject_Description_; "Teacher Class"."Subject Description")
            {
            }
            column(Teacher_Class__Teacher_Class___Full_Name_; "Teacher Class"."Full Name")
            {
            }
            column(Teacher_Class__Teacher_Class___Full_Name_Caption; Teacher_Class__Teacher_Class___Full_Name_CaptionLbl)
            {
            }
            column(Teacher_Class__Teacher_Class___Subject_Description_Caption; Teacher_Class__Teacher_Class___Subject_Description_CaptionLbl)
            {
            }
            column(Teacher_Class_User_Type; "User Type")
            {
            }
            column(Teacher_Class_User; User)
            {
            }
            column(Teacher_Class_Line_No_; "Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Teacher Class"."School Year", vSchoolYear);
                SetRange("Teacher Class".Class, vClass);
                if vType = vType::Teacher then
                    CurrReport.Skip;
            end;
        }
        dataitem(DiasSemanaProf; "Timetable-Teacher")
        {
            DataItemTableView = SORTING("Week Day");

            trigger OnAfterGetRecord()
            begin
                if vDiaSemana <> DiasSemanaProf."Week Day" then begin
                    i := i + 1;
                    vDayDescription[i] := Format(DiasSemanaProf."Week Day");
                    vDay[i] := DiasSemanaProf."Week Day" + 1;
                    vDiaSemana := DiasSemanaProf."Week Day";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Teacher then begin
                    DiasSemanaProf.SetRange(DiasSemanaProf."Filter Period", vDataIni, vDataFim);
                    vDiaSemana := 20;
                    Clear(i);
                end else
                    CurrReport.Break;
            end;
        }
        dataitem(HorasProf; "Timetable-Teacher")
        {
            DataItemTableView = SORTING("Start Hour");
            column(vDayDescription_3__Control1102065048; vDayDescription[3])
            {
            }
            column(vDayDescription_2__Control1102065049; vDayDescription[2])
            {
            }
            column(vDayDescription_4__Control1102065050; vDayDescription[4])
            {
            }
            column(vDayDescription_5__Control1102065052; vDayDescription[5])
            {
            }
            column(vDayDescription_1__Control1102065062; vDayDescription[1])
            {
            }
            column(Text0006_Control1102065127; Text0006)
            {
            }
            column(Text0006_Control1102065129; Text0006)
            {
            }
            column(Text0006_Control1102065131; Text0006)
            {
            }
            column(Text0006_Control1102065133; Text0006)
            {
            }
            column(Text0006_Control1102065135; Text0006)
            {
            }
            column(HorasProf_Timetable_Code; "Timetable Code")
            {
            }
            column(HorasProf_Timetable_Line_No_; "Timetable Line No.")
            {
            }
            column(HorasProf_Filter_Period; "Filter Period")
            {
            }
            column(HorasProf_Teacher_No_; "Teacher No.")
            {
            }
            column(HorasProf_Class; Class)
            {
            }
            column(HorasProf_Subject; Subject)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if vHora <> HorasProf."Start Hour" then begin
                    TempHorasProf.Init;
                    TempHorasProf.TransferFields(HorasProf);
                    TempHorasProf.Insert;
                    vHora := HorasProf."Start Hour"
                end;
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Teacher then begin
                    HorasProf.SetRange(HorasProf."Teacher No.", vTeacher);
                    HorasProf.SetRange(HorasProf."Filter Period", vDataIni, vDataFim);
                    Clear(vHora);
                end else
                    CurrReport.Break;
            end;
        }
        dataitem(HorasProf2; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(vSubject_4__Control1102065068; vSubject[4])
            {
            }
            column(vSubject_3__Control1102065069; vSubject[3])
            {
            }
            column(vSubject_5__Control1102065071; vSubject[5])
            {
            }
            column(vSubject_2__Control1102065079; vSubject[2])
            {
            }
            column(FORMAT_TempHorasProf__Start_Hour__0___Hours24___Minutes_2___; Format(TempHorasProf."Start Hour", 0, '<Hours24>:<Minutes,2>'))
            {
            }
            column(FORMAT_TempHorasProf__End_Hour__0___Hours24___Minutes_2___; Format(TempHorasProf."End Hour", 0, '<Hours24>:<Minutes,2>'))
            {
            }
            column(vRoom_1__Control1102065101; vRoom[1])
            {
            }
            column(vRoom_2__Control1102065103; vRoom[2])
            {
            }
            column(vRoom_3__Control1102065105; vRoom[3])
            {
            }
            column(vRoom_4__Control1102065107; vRoom[4])
            {
            }
            column(vRoom_5__Control1102065109; vRoom[5])
            {
            }
            column(vSubject_1__Control1102065081; vSubject[1])
            {
            }
            column(HorasProf2_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if HorasProf2.Number <> 1 then
                    TempHorasProf.Next;


                vSubject[1] := GetSubjectTeacher(TempHorasProf."Start Hour", 1);
                vSubject[2] := GetSubjectTeacher(TempHorasProf."Start Hour", 2);
                vSubject[3] := GetSubjectTeacher(TempHorasProf."Start Hour", 3);
                vSubject[4] := GetSubjectTeacher(TempHorasProf."Start Hour", 4);
                vSubject[5] := GetSubjectTeacher(TempHorasProf."Start Hour", 5);
                vSubject[6] := GetSubjectTeacher(TempHorasProf."Start Hour", 6);
                vSubject[7] := GetSubjectTeacher(TempHorasProf."Start Hour", 7);

                vRoom[1] := GetRoomTeacher(TempHorasProf."Start Hour", 1);
                vRoom[2] := GetRoomTeacher(TempHorasProf."Start Hour", 2);
                vRoom[3] := GetRoomTeacher(TempHorasProf."Start Hour", 3);
                vRoom[4] := GetRoomTeacher(TempHorasProf."Start Hour", 4);
                vRoom[5] := GetRoomTeacher(TempHorasProf."Start Hour", 5);
                vRoom[6] := GetRoomTeacher(TempHorasProf."Start Hour", 6);
                vRoom[7] := GetRoomTeacher(TempHorasProf."Start Hour", 7);
            end;

            trigger OnPreDataItem()
            begin
                if vType = vType::Teacher then begin

                    TempHorasProf.Reset;
                    TempHorasProf.SetCurrentKey(TempHorasProf."Start Hour");
                    HorasProf2.SetRange(HorasProf2.Number, 1, TempHorasProf.Count);
                    if TempHorasProf.FindFirst then;

                end else
                    CurrReport.Break;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(vType; vType)
                {
                    ApplicationArea = All;
                    Caption = 'Report Type';
                    OptionCaption = 'Class,Teacher';
                }
                field(vSchoolYear; vSchoolYear)
                {
                    ApplicationArea = All;
                    Caption = 'School Year';
                    TableRelation = "School Year";
                }
                field(vClass; vClass)
                {
                    ApplicationArea = All;
                    Caption = 'Class';
                    TableRelation = Class;

                    trigger OnValidate()
                    begin

                        rClass.Reset;
                        rClass.SetRange(rClass.Class, vClass);
                        rClass.SetRange(rClass."School Year", vSchoolYear);
                        if rClass.FindFirst then
                            vDescClass := rClass."Schooling Year" + ' - ' + rClass."Class Letter";
                    end;
                }
                field(vTeacher; vTeacher)
                {
                    ApplicationArea = All;
                    Caption = 'Teacher';
                    TableRelation = Teacher;

                    trigger OnValidate()
                    begin

                        rTeacher.Reset;
                        rTeacher.SetRange(rTeacher."No.", vTeacher);
                        if rTeacher.FindFirst then
                            vTeacherName := rTeacher.Name + ' ' + rTeacher."Last Name";
                    end;
                }
                field(vDataIni; vDataIni)
                {
                    ApplicationArea = All;
                    Caption = 'Inicial Date';
                }
                field(vDataFim; vDataFim)
                {
                    ApplicationArea = All;
                    Caption = 'Final Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        TempHoras: Record Calendar temporary;
        TempHorasProf: Record "Timetable-Teacher" temporary;
        rCalendar: Record Calendar;
        rTimetableTeacher: Record "Timetable-Teacher";
        rClass: Record Class;
        rTeacher: Record Teacher;
        rRoom: Record Room;
        cUserEducation: Codeunit "User Education";
        vType: Option Class,Teacher;
        vSchoolYear: Code[9];
        vDataIni: Date;
        vDataFim: Date;
        vClass: Code[20];
        vDescClass: Text[50];
        vTeacher: Code[20];
        vTeacherName: Text[191];
        vDayDescription: array[8] of Text[50];
        vDay: array[8] of Integer;
        vSubject: array[8] of Text[64];
        vHora: Time;
        vDiaSemana: Integer;
        int: Integer;
        i: Integer;
        vAlvo: Text[100];
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        Text0001: Label 'You must fill School Year.';
        Text0002: Label 'You must fill Inicial Date.';
        Text0003: Label 'You must fill Final Date.';
        Text0004: Label 'You must fill the Class.';
        Text0005: Label 'You must fill the Teacher.';
        vRoom: array[8] of Text[50];
        Text0006: Label 'Room';
        Text0007: Label 'Beginning Date and Ending Date can only differ from one week.';
        HorariCaptionLbl: Label 'Timetable';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Teacher_Class__Teacher_Class___Full_Name_CaptionLbl: Label 'Teacher Name';
        Teacher_Class__Teacher_Class___Subject_Description_CaptionLbl: Label 'Subject';

    //[Scope('OnPrem')]
    procedure GetSubject(pStartHour: Time; pInt: Integer) pSubject: Text[64]
    begin
        rCalendar.Reset;
        rCalendar.SetRange(rCalendar.Class, vClass);
        rCalendar.SetRange(rCalendar."Filter Period", vDataIni, vDataFim);
        rCalendar.SetRange(rCalendar."Start Hour", pStartHour);
        rCalendar.SetRange(rCalendar."Week Day", vDay[pInt] - 1);
        if rCalendar.FindFirst then begin
            repeat
                if pSubject <> '' then
                    pSubject := pSubject + rCalendar."Subject Description" + '/'
                else
                    pSubject := rCalendar."Subject Description" + '/';
            until rCalendar.Next = 0;
            pSubject := CopyStr(pSubject, 1, StrLen(pSubject) - 1);
        end else
            pSubject := '';
    end;

    //[Scope('OnPrem')]
    procedure GetSubjectTeacher(pStartHour: Time; pInt: Integer) pSubject: Text[50]
    var
        vOldSub: Code[40];
    begin
        Clear(pSubject);
        rTimetableTeacher.Reset;
        rTimetableTeacher.SetRange(rTimetableTeacher."Teacher No.", vTeacher);
        rTimetableTeacher.SetRange(rTimetableTeacher."Filter Period", vDataIni, vDataFim);
        rTimetableTeacher.SetRange(rTimetableTeacher."Start Hour", pStartHour);
        rTimetableTeacher.SetRange(rTimetableTeacher."Week Day", vDay[pInt] - 1);
        if rTimetableTeacher.FindFirst then begin
            repeat
                if rTimetableTeacher.Class <> '' then begin
                    rClass.Reset;
                    rClass.SetRange(rClass.Class, rTimetableTeacher.Class);
                    rClass.SetRange(rClass."School Year", vSchoolYear);
                    if rClass.FindFirst then begin
                        if vOldSub <> rTimetableTeacher.Subject then
                            pSubject := pSubject + rTimetableTeacher.Subject + '\' + rClass."Schooling Year" + '-' + rClass."Class Letter" + ' '
                        else
                            pSubject := pSubject + '/' + rClass."Schooling Year" + '-' + rClass."Class Letter" + ' ';
                        vOldSub := rTimetableTeacher.Subject;
                    end else
                        pSubject := pSubject;
                end else begin
                    if rTimetableTeacher.Meeting = rTimetableTeacher.Meeting::Class then begin
                        rClass.Reset;
                        rClass.SetRange(rClass.Class, rTimetableTeacher.Target);
                        rClass.SetRange(rClass."School Year", vSchoolYear);
                        if rClass.FindFirst then
                            pSubject := rTimetableTeacher.Subject + '\' + rClass."Schooling Year" + '-' + rClass."Class Letter"
                        else
                            pSubject := rTimetableTeacher.Subject;
                    end;
                    if rTimetableTeacher.Meeting = rTimetableTeacher.Meeting::Department then begin
                        pSubject := rTimetableTeacher.Subject + '\' + rTimetableTeacher.Target;
                    end;
                    if rTimetableTeacher.Meeting = rTimetableTeacher.Meeting::"Head Department" then begin
                        pSubject := rTimetableTeacher.Subject;
                    end;

                    if rTimetableTeacher.Meeting = rTimetableTeacher.Meeting::Level then begin
                        pSubject := rTimetableTeacher.Subject + '\' + Format(rTimetableTeacher.Level);
                    end;
                end;
            until rTimetableTeacher.Next = 0;
            pSubject := CopyStr(pSubject, 1, StrLen(pSubject) - 1);
        end else
            pSubject := '';
    end;

    //[Scope('OnPrem')]
    procedure GetRoom(pStartHour: Time; pInt: Integer) pRoom: Text[50]
    begin
        rCalendar.Reset;
        rCalendar.SetRange(rCalendar.Class, vClass);
        rCalendar.SetRange(rCalendar."Filter Period", vDataIni, vDataFim);
        rCalendar.SetRange(rCalendar."Start Hour", pStartHour);
        rCalendar.SetRange(rCalendar."Week Day", vDay[pInt] - 1);
        if rCalendar.FindFirst then begin
            repeat
                if pRoom <> '' then
                    pRoom := pRoom + rCalendar.Room + '/'
                else
                    pRoom := rCalendar.Room + '/';
            until rCalendar.Next = 0;
            pRoom := CopyStr(pRoom, 1, StrLen(pRoom) - 1);
        end else
            pRoom := '';
    end;

    //[Scope('OnPrem')]
    procedure GetRoomTeacher(pStartHour: Time; pInt: Integer) pRoom: Text[50]
    begin
        rTimetableTeacher.Reset;
        rTimetableTeacher.SetRange(rTimetableTeacher."Teacher No.", vTeacher);
        rTimetableTeacher.SetRange(rTimetableTeacher."Filter Period", vDataIni, vDataFim);
        rTimetableTeacher.SetRange(rTimetableTeacher."Start Hour", pStartHour);
        rTimetableTeacher.SetRange(rTimetableTeacher."Week Day", vDay[pInt] - 1);
        if rTimetableTeacher.FindFirst then begin
            if pRoom <> '' then
                pRoom := pRoom + rTimetableTeacher.Room
            else
                pRoom := rTimetableTeacher.Room;
        end else
            pRoom := '';
    end;
}

