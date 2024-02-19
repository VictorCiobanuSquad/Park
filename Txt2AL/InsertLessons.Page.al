#pragma implicitwith disable
page 31009819 "Insert Lessons"
{
    // This form got two contorl's in the field type subject

    Caption = 'Insert Lessons';
    PageType = Card;
    SourceTable = "Insert Timetable Lecture";
    SourceTableView = WHERE(Saved = FILTER(false));

    layout
    {
        area(content)
        {
            field(Class; Rec.Class)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Class';
                Editable = false;
            }
            field("Study Plan"; Rec."Study Plan")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("School Year"; Rec."School Year")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(cNotStudent; Rec."Type Subject")
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = ',,Non lective Component, ';
                Visible = cNotStudentVisible;
            }
            field(cStudent; Rec."Type Subject")
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = ',Subject,,Other';
                Visible = cStudentVisible;
            }
            field(Subject; Rec.Subject)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sub-Subject Code"; Rec."Sub-Subject Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Recurrence; Rec.Recurrence)
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                var
                    rDate: Record Date;
                begin
                    if Rec.Recurrence then begin
                        "Final DayEnable" := true;
                        rDate.Reset;
                        recDate.SetRange("Period Type", recDate."Period Type"::Date);
                        recDate.SetRange("Period Start", Rec."Initial Day");
                        if recDate.Find('-') then begin
                            if recDate."Period No." = 1 then
                                Rec.Monday := true;
                            if recDate."Period No." = 2 then
                                Rec.Tuesday := true;
                            if recDate."Period No." = 3 then
                                Rec.Wednesday := true;
                            if recDate."Period No." = 4 then
                                Rec.Thursday := true;
                            if recDate."Period No." = 5 then
                                Rec.Friday := true;
                            if recDate."Period No." = 6 then
                                Rec.Saturday := true;
                        end;
                    end else begin
                        "Final DayEnable" := false;
                        Rec."Final Day" := 0D;
                    end;
                    RecurrenceOnAfterValidate;
                end;
            }
            field("Final Day"; Rec."Final Day")
            {
                ApplicationArea = Basic, Suite;
                Enabled = "Final DayEnable";
            }
            group(Teacher)
            {
                Caption = 'Teacher';
                part(Control1102056045; "Insert Teacher Subform")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Cab Line" = FIELD("Line No."),
                                  "School Year" = FIELD("School Year"),
                                  "Study Plan" = FIELD("Study Plan"),
                                  Class = FIELD(Class),
                                  "Timetable Code" = FIELD("Timetable Code"),
                                  Type = FIELD(Type);
                }
            }
            field("Initial Day"; Rec."Initial Day")
            {
                ApplicationArea = Basic, Suite;

                trigger OnLookup(var Text: Text): Boolean
                begin

                    if Rec."Initial Day" = 0D then
                        Rec."Final Day" := Today
                    else
                        Rec.Validate("Initial Day");

                    InsertRespCenter;

                    Rec."Final Day" := 0D;
                    Rec.Recurrence := false;
                end;

                trigger OnValidate()
                begin
                    InsertRespCenter;

                    Rec."Final Day" := 0D;
                    Rec.Recurrence := false;
                end;
            }
            field("Start Hour"; Rec."Start Hour")
            {
                ApplicationArea = Basic, Suite;
            }
            field("End Hour"; Rec."End Hour")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Room; Rec.Room)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Turn; Rec.Turn)
            {
                ApplicationArea = Basic, Suite;
            }
            field(RespCenter; Rec."Responsibility Center")
            {
                ApplicationArea = Basic, Suite;
                Visible = RespCenterVisible;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Save Lecture")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Save Lecture';
                Image = Save;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    InsertTimeOnCalendar;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ValidateFields;
    end;

    trigger OnInit()
    begin
        RespCenterVisible := true;
        cNotStudentVisible := true;
        cStudentVisible := true;
        "Final DayEnable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if varStudent then
            Rec."Type Subject" := Rec."Type Subject"::Subject
        else
            Rec."Type Subject" := Rec."Type Subject"::"Non lective Component";
    end;

    trigger OnOpenPage()
    begin
        "Final DayEnable" := false;
        ValidateFields;
    end;

    var
        recDate: Record Date;
        recHorarioInserirAulas: Record "Insert Timetable Lecture";
        recProfessorHorarioInserir: Record "Timetable-Teacher-Insert";
        TabHorario: Record Timetable;
        TabHorarioLinhas: Record "Timetable Lines";
        TabHorarioProfessorLinhas: Record "Teacher Timetable Lines";
        TabCalendarTEMP: Record Calendar temporary;
        TabCalendarVerifyTEMP: Record Calendar temporary;
        Text003: Label 'Initial date is mandatory.';
        Text004: Label 'Starting hour and end hour is mandatory.';
        Text006: Label 'Unable to enter Subjects in the days selected by the filter. Change the filter date and continue.';
        Text007: Label 'This lecture has already been saved. Unable to continue.';
        Text008: Label 'Ending date is mandatory.';
        Text009: Label 'Mark subjects as recursive forces to fill the days of the week.';
        Text010: Label 'Starting date must be earlier than the final date.';
        varProfessores: Text[50];
        varNomeProfessores: Text[100];
        Text011: Label 'Lecture saved.';
        rRegistrationSubjects: Record "Registration Subjects";
        varClass: Code[20];
        VarSchoolYear: Code[9];
        VarStudyPlan: Code[20];
        VarTimetableCode: Code[20];
        varType: Option Simple,Multi;
        varSchoolingYear: Code[10];
        varNLine: Integer;
        rClass: Record Class;
        Text012: Label 'The field subject is mandatory.';
        varStudent: Boolean;
        rSubjects: Record Subjects;
        Calendar: Record Calendar;
        Text013: Label 'This room already is scheduled for this hour.';
        [InDataSet]
        MondayEnable: Boolean;
        [InDataSet]
        TuesdayEnable: Boolean;
        [InDataSet]
        WednesdayEnable: Boolean;
        [InDataSet]
        ThursdayEnable: Boolean;
        [InDataSet]
        FridayEnable: Boolean;
        [InDataSet]
        SaturdayEnable: Boolean;
        [InDataSet]
        "Final DayEnable": Boolean;
        [InDataSet]
        cStudentVisible: Boolean;
        [InDataSet]
        cNotStudentVisible: Boolean;
        [InDataSet]
        RespCenterVisible: Boolean;

    //[Scope('OnPrem')]
    procedure FilterType(pStudent: Boolean)
    begin
        varStudent := pStudent;
    end;

    //[Scope('OnPrem')]
    procedure InsertTimeOnCalendar()
    var
        recDate: Record Date;
        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        varCodHorario: Code[30];
    begin

        if Rec."Initial Day" = 0D then
            Error(Text003);

        if Rec.Recurrence then begin
            if Rec."Final Day" = 0D then
                Error(Text008);

            if Rec."Initial Day" > Rec."Final Day" then
                Error(Text010);
        end;

        if Rec."Start Hour" = 0T then
            Error(Text004);

        if Rec."End Hour" = 0T then
            Error(Text004);

        Calendar.Reset;
        Calendar.SetRange("Filter Period", Rec."Initial Day");
        Calendar.SetRange("Start Hour", Rec."Start Hour");
        Calendar.SetRange(Room, Rec.Room);
        if Calendar.Find('-') then
            Error(Text013);

        Clear(varNLine);

        TabCalendarVerifyTEMP.Reset;
        TabCalendarVerifyTEMP.SetRange("Timetable Code", Rec."Timetable Code");
        TabCalendarVerifyTEMP.SetRange("School Year", Rec."School Year");
        TabCalendarVerifyTEMP.SetRange("Study Plan", Rec."Study Plan");
        TabCalendarVerifyTEMP.SetRange(Class, Rec.Class);
        if TabCalendarVerifyTEMP.Find('+') then
            varNLine := TabCalendarVerifyTEMP."Line No." + 10000
        else
            varNLine := 10000;

        TabCalendarTEMP.Reset;
        TabCalendarTEMP.DeleteAll;


        if Rec.Recurrence = false then
            InsertTime;

        recDate.Reset;
        recDate.SetRange("Period Type", 0);
        if Rec.Recurrence then
            recDate.SetFilter("Period Start", '%1..%2', Rec."Initial Day", Rec."Final Day")
        else
            recDate.SetFilter("Period Start", '%1..%2', Rec."Initial Day", Rec."Initial Day");
        if recDate.Find('-') then begin
            repeat
                if Rec.Recurrence then begin
                    if (Rec.Monday) and (recDate."Period No." = 1) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                    if (Rec.Tuesday) and (recDate."Period No." = 2) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                    if (Rec.Wednesday) and (recDate."Period No." = 3) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                    if (Rec.Thursday) and (recDate."Period No." = 4) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                    if (Rec.Friday) and (recDate."Period No." = 5) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                    if (Rec.Saturday) and (recDate."Period No." = 6) then begin
                        if (recDate."Period Start" <> TabCalendarTEMP."Filter Period") then begin
                            varNLine := TabCalendarTEMP."Line No." + 10000;
                            InsertTime;
                        end;

                        cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, recDate."Period Start", Rec."Start Hour", Rec."End Hour", Rec."Line No.");
                    end;
                end else
                    cTimetableCalendarMgt.InserirCalendarioProf(TabCalendarTEMP, 0D, 0T, 0T, Rec."Line No.");
            until recDate.Next = 0;
        end else
            Error(Text006);

        Rec.Saved := true;
        Rec.Modify;

        Message(Text011);
    end;

    /*//[Scope('OnPrem')]
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
    end;*/

    //[Scope('OnPrem')]
    procedure InsertTime()
    begin
        TabCalendarTEMP.Init;
        TabCalendarTEMP.Validate("Timetable Code", Rec."Timetable Code");
        TabCalendarTEMP.Validate("School Year", Rec."School Year");
        TabCalendarTEMP."Study Plan" := Rec."Study Plan";
        TabCalendarTEMP.Validate(Class, Rec.Class);
        TabCalendarTEMP."Line No." := varNLine;
        TabCalendarTEMP.Validate("Filter Period", Rec."Initial Day");
        TabCalendarTEMP.Validate(Subject, Rec.Subject);
        if rSubjects.Get(Rec."Type Subject", Rec.Subject) then
            TabCalendarTEMP."Subject Description" := rSubjects.Description;
        TabCalendarTEMP.Validate("Start Hour", Rec."Start Hour");
        TabCalendarTEMP."End Hour" := Rec."End Hour";
        TabCalendarTEMP.Room := Rec.Room;
        TabCalendarTEMP.Turn := Rec.Turn;
        TabCalendarTEMP."Sub-Subject Code" := Rec."Sub-Subject Code";
        TabCalendarTEMP.Type := Rec.Type;
        TabCalendarTEMP.Times := Rec.Times;
        TabCalendarTEMP."Type Subject" := Rec."Type Subject";
        TabCalendarTEMP."Responsibility Center" := Rec."Responsibility Center";
        TabCalendarTEMP.Insert;
    end;

    //[Scope('OnPrem')]
    procedure InsertRespCenter()
    begin
        if rClass.Get(Rec.Class, Rec."School Year") then
            Rec."Responsibility Center" := rClass."Responsibility Center";
    end;

    //[Scope('OnPrem')]
    procedure ValidateFields()
    begin
        if varStudent then begin
            cStudentVisible := true;
            cNotStudentVisible := false;
            RespCenterVisible := false;
        end else begin
            cStudentVisible := false;
            cNotStudentVisible := true;
            RespCenterVisible := true;
        end;
    end;

    local procedure RecurrenceOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

