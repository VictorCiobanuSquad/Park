#pragma implicitwith disable
page 52825 Calendar
{
    Caption = 'Calendar';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Calendar;
    SourceTableTemporary = true;
    SourceTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class);

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(varDataInicio; varDataInicio)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        /*CLEAR(formDatePicker);
                        
                        IF varDataInicio = 0D THEN
                          formDatePicker.SetCurrDate(TODAY)
                        ELSE
                          formDatePicker.SetCurrDate(varDataInicio);
                        formDatePicker.LOOKUPMODE(TRUE);
                        IF formDatePicker.RUNMODAL = ACTION::LookupOK THEN
                          varDataInicio := formDatePicker.GetCurrDate;
                        
                        varDataFim:=varDataInicio;
                        
                        InsertFormLines;
                        CurrPage.UPDATE(FALSE)
                        */

                    end;

                    trigger OnValidate()
                    begin

                        varDataFim := varDataInicio;

                        InsertFormLines;
                        varDataInicioOnAfterValidate;
                    end;
                }
                field(varDataFim; varDataFim)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        /*CLEAR(formDatePicker);
                        
                        IF varDataFim = 0D THEN
                          formDatePicker.SetCurrDate(TODAY)
                        ELSE
                          formDatePicker.SetCurrDate(varDataFim);
                        formDatePicker.LOOKUPMODE(TRUE);
                        IF formDatePicker.RUNMODAL = ACTION::LookupOK THEN
                          varDataFim := formDatePicker.GetCurrDate;
                        
                        InsertFormLines;
                        CurrPage.UPDATE(FALSE);
                        */

                    end;

                    trigger OnValidate()
                    begin

                        InsertFormLines;
                        varDataFimOnAfterValidate;
                    end;
                }
                field(varStudyPlan; varStudyPlan)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan';
                    Editable = false;
                }
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    TableRelation = Class;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        tempClass: Record Class temporary;
                    begin


                        Clear(tempClass);
                        cPermissions.ClassFilter(tempClass, 2);

                        if tempClass.FindSet then begin
                            if PAGE.RunModal(PAGE::"Class List", tempClass) = ACTION::LookupOK then begin
                                varClass := tempClass.Class;
                                varSchoolYear := tempClass."School Year";
                                varStudyPlan := tempClass."Study Plan Code";
                                varSchoolingYear := tempClass."Schooling Year";
                                varType := tempClass.Type;
                                if varClass = '' then begin
                                    Clear(Rec);
                                    varSchoolYear := '';
                                    varStudyPlan := '';
                                    VarTurn := '';
                                end;
                            end;
                        end else
                            Error(Text003);



                        InsertFormLines;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        varClassOnAfterValidate;
                    end;
                }
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    Editable = false;
                    TableRelation = "School Year" WHERE(Status = FILTER(Active | Closing));
                }
                field(VarTurn; VarTurn)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Turn';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTurn: Record Turn;
                        rTurnTemp: Record Turn temporary;
                        rRegistrationSubjects: Record "Registration Subjects";
                        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                        rShoolYear: Record "School Year";
                    begin
                        if varClass <> '' then begin
                            rRegistrationSubjects.Reset;
                            rRegistrationSubjects.SetRange(Class, varClass);
                            rRegistrationSubjects.SetRange("School Year", varSchoolYear);
                            if rRegistrationSubjects.Find('-') then
                                repeat
                                    rRegistrationSubjects.CalcFields("Sub-subject");
                                    if rRegistrationSubjects."Sub-subject" then begin
                                        rStudentSubSubjectsPlan.Reset;
                                        rStudentSubSubjectsPlan.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                                        rStudentSubSubjectsPlan.SetRange("School Year", rRegistrationSubjects."School Year");
                                        rStudentSubSubjectsPlan.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                                        rStudentSubSubjectsPlan.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                                        if rStudentSubSubjectsPlan.Find('-') then
                                            repeat
                                                if rStudentSubSubjectsPlan.Turn <> '' then begin
                                                    rTurnTemp.Reset;
                                                    rTurnTemp.SetRange(Code, rStudentSubSubjectsPlan.Turn);
                                                    if not rTurnTemp.Find('-') then begin
                                                        if rTurn.Get(rStudentSubSubjectsPlan.Turn, rRegistrationSubjects."Responsibility Center") then begin
                                                            rTurnTemp.Init;
                                                            rTurnTemp.TransferFields(rTurn);
                                                            rTurnTemp.Insert;
                                                        end;
                                                    end;
                                                end;
                                            until rStudentSubSubjectsPlan.Next = 0;
                                    end;
                                    if rRegistrationSubjects.Turn <> '' then begin
                                        rTurnTemp.Reset;
                                        rTurnTemp.SetRange(Code, rRegistrationSubjects.Turn);
                                        if not rTurnTemp.Find('-') then begin
                                            if rTurn.Get(rRegistrationSubjects.Turn, rRegistrationSubjects."Responsibility Center") then begin
                                                rTurnTemp.Init;
                                                rTurnTemp.TransferFields(rTurn);
                                                rTurnTemp.Insert;
                                            end;
                                        end;
                                    end;
                                until rRegistrationSubjects.Next = 0;

                            rTurnTemp.Reset;
                            if PAGE.RunModal(0, rTurnTemp) = ACTION::LookupOK then
                                VarTurn := rTurnTemp.Code;

                        end else begin
                            if PAGE.RunModal(0, rTurn) = ACTION::LookupOK then
                                VarTurn := rTurn.Code;
                        end;

                        if (varClass = '') and (VarTurn <> '') then begin
                            rShoolYear.Reset;
                            rShoolYear.SetRange(Status, rShoolYear.Status::Active);
                            if rShoolYear.FindSet(false, false) then
                                varSchoolYear := rShoolYear."School Year";
                        end;


                        InsertFormLines;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    var
                        rShoolYear: Record "School Year";
                    begin
                        if varClass = '' then begin
                            rShoolYear.Reset;
                            rShoolYear.SetRange(Status, rShoolYear.Status::Active);
                            if rShoolYear.FindSet(false, false) then
                                varSchoolYear := rShoolYear."School Year";
                        end;
                        if (VarTurn = '') and (varClass = '') then
                            varSchoolYear := '';

                        InsertFormLines;
                        VarTurnOnAfterValidate;
                    end;
                }
            }
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Filter Period"; Rec."Filter Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Times; Rec.Times)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = TimesEditable;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Start HourEditable";
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "End HourEditable";
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = RoomEditable;
                }
                field("Lecture Status"; Rec."Lecture Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Absence Type"; Rec."Absence Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = TurnEditable;
                }
            }
            group(Summary)
            {
                Caption = 'Summary';
                part(SubSummary; Summary)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SubSummaryEditable;
                    Enabled = SubSummaryEnable;
                    SubPageLink = Class = FIELD(Class),
                                  "School Year" = FIELD("School Year"),
                                  "Study Plan Code" = FIELD("Study Plan"),
                                  "Timetable Code" = FIELD("Timetable Code"),
                                  Subject = FIELD(Subject),
                                  "Sub-subject" = FIELD("Sub-Subject Code"),
                                  Day = FIELD("Filter Period"),
                                  "Calendar Line" = FIELD("Line No.");
                }
            }
            group(Absence)
            {
                Caption = 'Absence';
                part(SubAbsenceLecture; "Absence Calendar")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SubAbsenceLectureEditable;
                    Enabled = SubAbsenceLectureEnable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "School Year" = FIELD("School Year"),
                                  "Study Plan" = FIELD("Study Plan"),
                                  Class = FIELD(Class),
                                  Type = FIELD(Type),
                                  "Line No. Timetable" = FIELD("Line No."),
                                  "Absence Type" = FIELD("Absence Type"),
                                  Subject = FIELD(Subject),
                                  "Sub-Subject Code" = FIELD("Sub-Subject Code"),
                                  Day = FIELD("Filter Period"),
                                  "Line No." = FILTER(<> 0);
                }
            }
            group("Daily Absence")
            {
                Caption = 'Daily Absence';
                part(subAbsenceDaily; "Absence Calendar 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = subAbsenceDailyEditable;
                    Enabled = subAbsenceDailyEnable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "School Year" = FIELD("School Year"),
                                  "Study Plan" = FIELD("Study Plan"),
                                  Class = FIELD(Class),
                                  Type = FIELD(Type),
                                  "Absence Type" = FIELD("Absence Type"),
                                  Day = FIELD("Filter Period"),
                                  "Type Subject" = FIELD("Type Subject");
                }
            }
            group(Default)
            {
                Caption = 'Default';
                part(SubGeneralAbsence; "General Calendar")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SubGeneralAbsenceEditable;
                    Enabled = SubGeneralAbsenceEnable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "School Year" = FIELD("School Year"),
                                  "Study Plan" = FIELD("Study Plan"),
                                  Class = FIELD(Class),
                                  Type = FIELD(Type),
                                  "Line No. Timetable" = FIELD("Line No."),
                                  "Absence Type" = FIELD("Absence Type"),
                                  Subject = FIELD(Subject),
                                  "Sub-Subject Code" = FIELD("Sub-Subject Code"),
                                  Day = FIELD("Filter Period"),
                                  "Line No." = FILTER(<> 0);
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Absences")
            {
                Caption = '&Absences';
                Image = Absence;
                Visible = true;
                action("Insert Absences &Students - All Day(s)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert Absences &Students - All Day(s)';
                    Image = AbsenceCalendar;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if (varClass <> '') then begin
                            if cPermissions.AllowIncidencesAllDay(varClass, varSchoolYear, varSchoolingYear, '', VarTurn) = false then
                                Error(Text003);
                            Rec.CreateAbsences(Rec, 0, varDataInicio, varDataFim);  //0 - Aluno  1-Professor   2-Turma
                        end else
                            Message(Text005);
                    end;
                }
                action("Insert Absences &Class - All Day(s)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert Absences &Class - All Day(s)';
                    Image = AbsenceCategories;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if (varClass <> '') then begin
                            if cPermissions.AllowIncidencesAllDay(varClass, varSchoolYear, varSchoolingYear, '', VarTurn) = false then
                                Error(Text003);
                            Rec.CreateAbsences(Rec, 2, varDataInicio, varDataFim);  //0 - Aluno  1-Professor   2-Turma
                        end else
                            Message(Text005);
                    end;
                }
            }
            group("&Lessons")
            {
                Caption = '&Lessons';
                Image = CustomerGroup;
                action("&Insert Lesson")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Insert Lesson';
                    Image = InsertFromCheckJournal;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        InsTimeLecture: Record "Insert Timetable Lecture";
                    begin
                        if (Rec."School Year" <> '') and (Rec."Study Plan" <> '') and (Rec.Class <> '') and (Rec."Timetable Code" <> '') then begin
                            InsTimeLecture.Reset;
                            InsTimeLecture.SetRange("School Year", Rec."School Year");
                            InsTimeLecture.SetRange("Study Plan", Rec."Study Plan");
                            InsTimeLecture.SetRange(Class, Rec.Class);
                            InsTimeLecture.SetRange("Timetable Code", Rec."Timetable Code");
                            InsTimeLecture.SetRange(Type, Rec.Type);

                            FormInserirAula.FilterType(true);
                            FormInserirAula.SetTableView(InsTimeLecture);
                            FormInserirAula.RunModal;

                        end;

                        InsertFormLines;
                        CurrPage.Update(false);
                    end;
                }
                group("&Lesson Status")
                {
                    Caption = '&Lesson Status';
                    Image = PeriodStatus;
                    action("&Summarized")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = '&Summarized';
                        Image = Text;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                            Text0001: Label 'The subject is already summary';
                        begin
                            Clear(TabCalendario);
                            CurrPage.SetSelectionFilter(TabCalendario);

                            TabCalendario.MarkedOnly(true);

                            if TabCalendario.Count > 0 then begin
                                if TabCalendario.Find('-') then
                                    repeat
                                        TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Summary);
                                        TabCalendario.Modify;
                                    until TabCalendario.Next = 0;
                            end else begin
                                TabCalendario.Reset;
                                TabCalendario.SetRange("Timetable Code", Rec."Timetable Code");
                                TabCalendario.SetRange("School Year", Rec."School Year");
                                TabCalendario.SetRange("Study Plan", Rec."Study Plan");
                                TabCalendario.SetRange(Class, Rec.Class);
                                TabCalendario.SetRange("Line No.", Rec."Line No.");
                                if TabCalendario.Find('-') then begin
                                    if TabCalendario."Lecture Status" = TabCalendario."Lecture Status"::Summary then
                                        Error(Text0001)
                                    else begin
                                        TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Summary);
                                        TabCalendario.Modify;
                                    end;
                                end;
                            end;

                            InsertFormLines;
                        end;
                    }
                    action("&Reschedule")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = '&Reschedule';
                        Image = Replan;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        Visible = false;

                        trigger OnAction()
                        var
                            TabFaltas: Record Absence;
                        begin
                            vOK := true;

                            CurrPage.SetSelectionFilter(TabCalendario);

                            TabCalendario.MarkedOnly(true);

                            if TabCalendario.Count > 0 then begin
                                if TabCalendario.Find('-') then
                                    repeat
                                        if TabCalendario."Lecture Status" = TabCalendario."Lecture Status"::Summary then
                                            vOK := false
                                        else
                                            vOK := true;

                                        TabFaltas.Reset;
                                        //TabFaltas.SETRANGE(Chave,TabCalendario.Chave);
                                        TabFaltas.SetRange("Timetable Code", TabCalendario."Timetable Code");
                                        TabFaltas.SetRange("School Year", TabCalendario."School Year");
                                        TabFaltas.SetRange("Study Plan", TabCalendario."Study Plan");
                                        TabFaltas.SetRange(Class, TabCalendario.Class);
                                        if Rec."Absence Type" = Rec."Absence Type"::Lecture then
                                            TabFaltas.SetRange(Subject, TabCalendario.Subject);
                                        TabFaltas.SetRange(Day, Rec."Filter Period");
                                        //TabFaltas.SETRANGE(Absence,TRUE);
                                        if TabFaltas.FindFirst then
                                            vOK := false
                                        else
                                            vOK := true;

                                        if vOK then begin
                                            TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Rescheduled);
                                            TabCalendario.Modify;
                                        end;

                                    until TabCalendario.Next = 0;
                            end else begin
                                TabCalendario.Reset;
                                TabCalendario.SetRange("Timetable Code", Rec."Timetable Code");
                                TabCalendario.SetRange("School Year", Rec."School Year");
                                TabCalendario.SetRange("Study Plan", Rec."Study Plan");
                                TabCalendario.SetRange(Class, Rec.Class);
                                if TabCalendario.Find('-') then begin
                                    if TabCalendario."Lecture Status" = TabCalendario."Lecture Status"::Summary then
                                        Error(Text001);

                                    TabFaltas.Reset;
                                    //TabFaltas.SETRANGE(Chave,TabCalendario.Chave);
                                    TabFaltas.SetRange("Timetable Code", TabCalendario."Timetable Code");
                                    TabFaltas.SetRange("School Year", TabCalendario."School Year");
                                    TabFaltas.SetRange("Study Plan", TabCalendario."Study Plan");
                                    TabFaltas.SetRange(Class, TabCalendario.Class);
                                    if Rec."Absence Type" = Rec."Absence Type"::Lecture then
                                        TabFaltas.SetRange(Subject, TabCalendario.Subject);
                                    TabFaltas.SetRange(Day, Rec."Filter Period");
                                    //TabFaltas.SETRANGE(Absence,TRUE);
                                    if TabFaltas.FindFirst then
                                        Error(Text002);

                                    TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Rescheduled);
                                    TabCalendario.Modify;
                                end;
                            end;

                            InsertFormLines;
                        end;
                    }
                    action("S&tarted")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'S&tarted';
                        Image = Start;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(TabCalendario);

                            TabCalendario.MarkedOnly(true);

                            if TabCalendario.Count > 0 then begin
                                if TabCalendario.Find('-') then
                                    repeat
                                        TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Started);
                                        TabCalendario.Modify;
                                    until TabCalendario.Next = 0;
                            end else begin
                                TabCalendario.Reset;
                                TabCalendario.SetRange("Timetable Code", Rec."Timetable Code");
                                TabCalendario.SetRange("School Year", Rec."School Year");
                                TabCalendario.SetRange("Study Plan", Rec."Study Plan");
                                TabCalendario.SetRange(Class, Rec.Class);
                                TabCalendario.SetRange("Line No.", Rec."Line No.");
                                if TabCalendario.Find('-') then begin
                                    TabCalendario.Validate("Lecture Status", TabCalendario."Lecture Status"::Started);
                                    TabCalendario.Modify;
                                end;
                            end;

                            InsertFormLines;
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        RoomEditable := true;
        TurnEditable := true;
        "End HourEditable" := true;
        "Start HourEditable" := true;
        SubSummaryEditable := true;
        SubGeneralAbsenceEditable := true;
        SubAbsenceLectureEditable := true;
        subAbsenceDailyEditable := true;
        SubGeneralAbsenceEnable := true;
        subAbsenceDailyEnable := true;
        SubAbsenceLectureEnable := true;
        SubSummaryEnable := true;
        Clear(varSchoolYear);
        Clear(varStudyPlan);
        Clear(varClass);
        Clear(VarTurn);
        Clear(varSchoolingYear);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        Clear(Rec);
        if varClass <> '' then
            UpdateFormClass;
    end;

    var
        TabCalendario: Record Calendar;
        rClass: Record Class;
        CTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        cStudentsRegistration: Codeunit "Students Registration";
        cPermissions: Codeunit Permissions;
        varAno: Integer;
        varMes: Option " ",Janeiro,Fevereiro,"Março",Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro;
        varDataInicio: Date;
        varDataFim: Date;
        Text001: Label 'Summarized lecture. It isn''t t possible to change the state to the "Reschedule" option, instead change the status to the "Started" option.';
        Text002: Label 'Posted absences already exist for this lecture. The status therefore cannot be changed for "Reschedule".';
        varSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        varStudyPlan: Code[20];
        varClass: Code[20];
        varTimetable: Code[20];
        varType: Option Simple,Multi;
        vOK: Boolean;
        VarTurn: Code[20];
        cUserEducation: Codeunit "User Education";
        Text003: Label 'You don''t have permissions to assign incidences.';
        Text004: Label 'You don''t have permissions to assign summary.';
        Text005: Label 'Inserting Class is Mandatory.';
        TempCalendarAux: Record Calendar temporary;
        [InDataSet]
        SubSummaryEnable: Boolean;
        [InDataSet]
        SubAbsenceLectureEnable: Boolean;
        [InDataSet]
        subAbsenceDailyEnable: Boolean;
        [InDataSet]
        SubGeneralAbsenceEnable: Boolean;
        [InDataSet]
        subAbsenceDailyEditable: Boolean;
        [InDataSet]
        SubAbsenceLectureEditable: Boolean;
        [InDataSet]
        SubGeneralAbsenceEditable: Boolean;
        [InDataSet]
        SubSummaryEditable: Boolean;
        [InDataSet]
        TimesEditable: Boolean;
        [InDataSet]
        "Start HourEditable": Boolean;
        [InDataSet]
        "End HourEditable": Boolean;
        [InDataSet]
        TurnEditable: Boolean;
        [InDataSet]
        RoomEditable: Boolean;
        FormInserirAula: Page "Insert Lessons";

    //[Scope('OnPrem')]
    procedure SetFormFilters(pSchoolYear: Code[9]; pStudyPlan: Code[20]; pClass: Code[20]; pTimetable: Code[20]; pType: Option Simple,Multi)
    begin
        varSchoolYear := pSchoolYear;
        varStudyPlan := pStudyPlan;
        varClass := pClass;
        varTimetable := pTimetable;
        varType := pType;
    end;

    //[Scope('OnPrem')]
    procedure SetEditableSubform()
    begin
        subAbsenceDailyEditable := true;
        SubAbsenceLectureEditable := true;
        SubGeneralAbsenceEditable := true;

        if Rec."Absence Type" = Rec."Absence Type"::Lecture then begin
            SubAbsenceLectureEditable := true;
            subAbsenceDailyEditable := false;
        end else begin
            SubAbsenceLectureEditable := false;
            subAbsenceDailyEditable := true;
        end;


        if Rec."Lecture Status" = Rec."Lecture Status"::Summary then begin
            SubSummaryEditable := false;
            subAbsenceDailyEditable := false;
            SubAbsenceLectureEditable := false;
            SubGeneralAbsenceEditable := false;
            TimesEditable := false;
            "Start HourEditable" := false;
            "End HourEditable" := false;
            TurnEditable := false;
            RoomEditable := false;
        end else begin
            SubSummaryEditable := true;
            "Start HourEditable" := true;
            "End HourEditable" := true;
            TurnEditable := true;
            RoomEditable := true;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FilterSubform()
    begin
        SubSummaryEditable := false;
        subAbsenceDailyEditable := false;
        SubAbsenceLectureEditable := false;
        SubGeneralAbsenceEditable := false;
    end;

    //[Scope('OnPrem')]
    procedure InsertFormLines()
    var
        lRegistrationSubjects: Record "Registration Subjects";
        LineNo: Integer;
        LastStudent: Code[20];
        TempCalendar: Record Calendar temporary;
        rCalendar: Record Calendar;
        rTimetable: Record Timetable;
    begin
        /*
        DELETEALL;
        IF varClass <> '' THEN BEGIN
        
          IF varType = varType::Simple THEN BEGIN
            CLEAR(TempStudyPlanLines);
            cPermissions.SubjectFilter(varType,varSchoolYear,varClass,varStudyPlan,varSchoolingYear,
                                     TempStudyPlanLines,TempCourseLines,2);
            TempStudyPlanLines.RESET;
            IF TempStudyPlanLines.FINDSET THEN
              REPEAT
                rCalendar.RESET;
                IF (varDataInicio <> 0D) AND  (varDataFim <> 0D) THEN
                  rCalendar.SETRANGE(rCalendar."Filter Period",varDataInicio,varDataFim);
                IF (varDataInicio <> 0D) AND  (varDataFim = 0D) THEN
                  rCalendar.SETFILTER(rCalendar."Filter Period",'>%1',varDataInicio);
                IF (varDataInicio = 0D) AND  (varDataFim <> 0D) THEN
                  rCalendar.SETFILTER(rCalendar."Filter Period",'<%1',varDataFim);
        
                rCalendar.SETRANGE(rCalendar."School Year",varSchoolYear);
                rCalendar.SETRANGE(rCalendar."Study Plan",varStudyPlan);
                rCalendar.SETRANGE(rCalendar.Class,varClass);
                IF VarTurn <> '' THEN
                  rCalendar.SETRANGE(rCalendar.Turn,VarTurn);
                rCalendar.SETRANGE(rCalendar.Subject,TempStudyPlanLines."Subject Code");
                IF rCalendar.FINDSET THEN
                  REPEAT
                    INIT;
                    TRANSFERFIELDS(rCalendar);
                    INSERT;
                  UNTIL rCalendar.NEXT =0;
              UNTIL TempStudyPlanLines.NEXT =0;
          END ELSE BEGIN
            Type := Type::Multi;
            CLEAR(TempCourseLines);
            cPermissions.SubjectFilter(varType,varSchoolYear,varClass,varStudyPlan,varSchoolingYear,
                                     TempStudyPlanLines,TempCourseLines,2);
            TempCourseLines.RESET;
            IF TempCourseLines.FINDSET THEN
              REPEAT
                rCalendar.RESET;
                IF (varDataInicio <> 0D) AND  (varDataFim <> 0D) THEN
                  rCalendar.SETRANGE(rCalendar."Filter Period",varDataInicio,varDataFim);
                IF (varDataInicio <> 0D) AND  (varDataFim = 0D) THEN
                  rCalendar.SETFILTER(rCalendar."Filter Period",'>%1',varDataInicio);
                IF (varDataInicio = 0D) AND  (varDataFim <> 0D) THEN
                  rCalendar.SETFILTER(rCalendar."Filter Period",'<%1',varDataFim);
        
                rCalendar.SETRANGE(rCalendar."School Year",varSchoolYear);
                rCalendar.SETRANGE(rCalendar."Study Plan",varStudyPlan);
                rCalendar.SETRANGE(rCalendar.Class,varClass);
                IF VarTurn <> '' THEN
                  rCalendar.SETRANGE(rCalendar.Turn,VarTurn);
                rCalendar.SETRANGE(rCalendar.Subject,TempCourseLines."Subject Code");
                IF rCalendar.FINDSET THEN
                  REPEAT
                    INIT;
                    TRANSFERFIELDS(rCalendar);
                    INSERT;
        
                  UNTIL rCalendar.NEXT =0;
              UNTIL TempCourseLines.NEXT =0;
        
          END;
          IF FINDSET THEN;
        END;
         */
        //2011.11.08 - guarda o filtro que o utilizador aplicou
        TempCalendarAux.Reset;
        TempCalendarAux.CopyFilters(Rec);
        Rec.Reset;
        //2011.11.08 - fim

        Rec.DeleteAll;
        if (varClass <> '') or (VarTurn <> '') then begin

            Clear(TempCalendar);
            cPermissions.SubjectFilterIncidence(varSchoolYear, varSchoolingYear, varClass, TempCalendar, varDataInicio, varDataFim, VarTurn);

            TempCalendar.Reset;
            if VarTurn <> '' then
                TempCalendar.SetRange(Turn, VarTurn);
            if TempCalendar.FindSet then
                repeat
                    Rec.Init;
                    Rec.TransferFields(TempCalendar);
                    Rec.Insert;
                until TempCalendar.Next = 0;
            if Rec.FindSet then;
        end;

        //2011.11.08 - volta a colocar  filtro que o utilizador aplicou
        Rec.CopyFilters(TempCalendarAux);
        //2011.11.08 - fim

    end;

    //[Scope('OnPrem')]
    procedure UpdateFormClass()
    var
        tempClass: Record Class temporary;
    begin
        Clear(tempClass);
        cPermissions.ClassFilter(tempClass, 2);

        tempClass.SetFilter(tempClass."School Year", cStudentsRegistration.GetShoolYearActiveClosing);
        tempClass.SetRange(tempClass.Class, varClass);
        if tempClass.FindFirst then begin
            varClass := tempClass.Class;
            varSchoolYear := tempClass."School Year";
            varStudyPlan := tempClass."Study Plan Code";
            varSchoolingYear := tempClass."Schooling Year";
            varType := tempClass.Type;
        end else
            Error(Text003);

        InsertFormLines;
        CurrPage.Update(false);
    end;

    local procedure varDataInicioOnAfterValidate()
    begin
        CurrPage.Update(false)
    end;

    local procedure varDataFimOnAfterValidate()
    begin
        CurrPage.Update(false)
    end;

    local procedure varClassOnAfterValidate()
    begin
        UpdateFormClass;
    end;

    local procedure VarTurnOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        //Normatica
        SubSummaryEnable := true;
        //Normatica - fim

        SetEditableSubform;
        if Rec."Absence Type" = Rec."Absence Type"::Daily then
            CurrPage.subAbsenceDaily.PAGE.SendHeader(Rec)
        else
            CurrPage.SubAbsenceLecture.PAGE.SendHeader(Rec);

        CurrPage.SubGeneralAbsence.PAGE.SendHeader(Rec);


        CurrPage.SubSummary.PAGE.SendHeader(Rec);
    end;

    local procedure varClassOnActivate()
    begin
        CurrPage.Update(false);
    end;

    local procedure SubSummaryOnActivate()
    var
        rUserTimeReg: Record "User Time Register";
    begin
        SubSummaryEnable := true;

        Clear(cPermissions);
        if (varSchoolYear <> '') and (cPermissions.AllowSummary(varClass, varSchoolYear, varSchoolingYear, Rec.Subject, VarTurn) = false) then begin
            Message(Text004);
            SubSummaryEnable := false;
        end else
            SubSummaryEnable := true;
    end;

    local procedure SubAbsenceLectureOnActivate()
    begin
        Clear(cPermissions);
        if (varSchoolYear <> '') and (cPermissions.AllowIncidences(varClass, varSchoolYear, varSchoolingYear, Rec.Subject, VarTurn) = false)
          then begin
            Message(Text003);
            SubAbsenceLectureEnable := false;
        end else
            SubAbsenceLectureEnable := true;
    end;

    local procedure subAbsenceDailyOnActivate()
    begin
        Clear(cPermissions);
        if (varSchoolYear <> '') and (cPermissions.AllowIncidences(varClass, varSchoolYear, varSchoolingYear, Rec.Subject, VarTurn) = false)
          then begin
            Message(Text003);
            subAbsenceDailyEnable := false;
        end else
            subAbsenceDailyEnable := true;
    end;

    local procedure SubGeneralAbsenceOnActivate()
    begin
        Clear(cPermissions);
        if (varSchoolYear <> '') and (cPermissions.AllowIncidences(varClass, varSchoolYear, varSchoolingYear, Rec.Subject, VarTurn) = false)
          then begin
            Message(Text003);
            SubGeneralAbsenceEnable := false;
        end else
            SubGeneralAbsenceEnable := true;
    end;
}

#pragma implicitwith restore

