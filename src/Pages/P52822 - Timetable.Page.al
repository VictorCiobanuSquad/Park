#pragma implicitwith disable
page 52822 Timetable
{
    Caption = 'Timetable';
    PageType = Card;
    SourceTable = Timetable;

    layout
    {
        area(content)
        {
            group(framTime)
            {
                Caption = 'Timetables';
                field("Timetable Code"; Rec."Timetable Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DescriptionEditable;
                }
                field("Timetable Type"; Rec."Timetable Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Timetable TypeEditable";

                    trigger OnValidate()
                    begin
                        SetEditableControl;
                    end;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School YearEditable";
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    Editable = ClassEditable;

                    trigger OnValidate()
                    begin
                        ClassOnAfterValidate;
                    end;
                }
                field("Class Description"; Rec."Class Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Study Plan"; Rec."Study Plan")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course';
                    Editable = false;
                }
                field("Plan Study Description"; Rec."Plan Study Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Responsibility CenterEditable";
                }
                field("Start Period"; Rec."Start Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Start PeriodEditable";
                }
                field("End Period"; Rec."End Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "End PeriodEditable";
                }
                field("School Calendar"; Rec."School Calendar")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School CalendarEditable";
                }
                field("Template Timetable"; Rec."Template Timetable")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Template TimetableEditable";

                    trigger OnValidate()
                    begin
                        TemplateTimetableOnAfterValida;
                    end;
                }
                field("Blocked Teacher"; Rec."Blocked Teacher")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Blocked TeacherVisible";
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = BlockedVisible;
                }
            }
            part(subformCalendar; "Timetable Subform")
            {
                ApplicationArea = All;
                Caption = 'Schedule Lines';
                Editable = subformCalendarEditable;
                SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                              Class = FIELD(Class),
                              "Template Code" = FIELD("Template Timetable");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Ti&metable")
            {
                Caption = 'Ti&metable';
                Image = Calendar;
                action("&Copy Timetable")
                {
                    ApplicationArea = All;
                    Caption = '&Copy Timetable';
                    Image = CopyWorksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        l_TeacherTimetableLines: Record "Teacher Timetable Lines";
                    begin
                        if Rec.Blocked = true then
                            Error(Text012);

                        if Rec."Timetable Code" = '' then
                            Error(Text015);

                        rTimetableLines.Reset;
                        rTimetableLines.SetFilter("Timetable Code", Rec."Timetable Code");
                        rTimetableLines.SetFilter("Start Hour", '<>%1', 0T);
                        if rTimetableLines.Find('-') then
                            Error(Text013);


                        if Rec."Timetable Type" = Rec."Timetable Type"::Class then
                            if Rec.Class = '' then
                                Error(Text025);

                        if Rec."Timetable Type" = Rec."Timetable Type"::Teacher then begin
                            l_TeacherTimetableLines.Reset;
                            l_TeacherTimetableLines.SetRange("Timetable Code", Rec."Timetable Code");
                            l_TeacherTimetableLines.SetRange("Timetable Line No.", 10000);
                            l_TeacherTimetableLines.SetRange("Teacher No.", '');
                            if l_TeacherTimetableLines.Find('-') then
                                Error(Text028);
                        end;

                        //IF STRMENU(opCopyTimetable) = 1 THEN
                        //  CopyTimeTable(Rec)
                        //ELSE
                        //  CopyTimeTableTotal(Rec);

                        OptionPartialTotal := StrMenu(opCopyTimetable);
                        case OptionPartialTotal of
                            1:
                                Rec.CopyTimeTable(Rec);
                            2:
                                Rec.CopyTimeTableTotal(Rec);
                        end;
                    end;
                }
                action("C&reate Calendar")
                {
                    ApplicationArea = All;
                    Caption = 'C&reate Calendar';
                    Image = WorkCenterCalendar;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
                        l_TeacherTimetableLines: Record "Teacher Timetable Lines";
                        l_Absence: Record Absence;
                        ErrorMessage: Text[250];
                    begin
                        if cTimetableCalendarMgt.CreateCalendarAndValidation(Rec,
                                                                             rTimetableLines,
                                                                             rTeacherTimetableLines,
                                                                             ErrorMessage) then
                            Error(ErrorMessage)
                        else begin
                            cTimetableCalendarMgt.Start(Rec."Timetable Code",
                                                        Rec."School Calendar",
                                                        Rec."Start Period",
                                                        Rec."End Period");
                            ValidateFields;

                        end;
                    end;
                }
                action("&Delete Calendar")
                {
                    ApplicationArea = All;
                    Caption = '&Delete Calendar';
                    Image = CalendarMachine;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        TabHorarioProfessor: Record "Timetable-Teacher";
                        rClass: Record Class;
                        l_Absence: Record Absence;
                        l_Remarks: Record Remarks;
                    begin

                        if not Confirm(Text009, true) then
                            exit;

                        CountCalendario := 0;
                        iCalendario := 0;

                        l_Remarks.Reset;
                        l_Remarks.SetRange(Class, Rec.Class);
                        l_Remarks.SetRange("School Year", Rec."School Year");
                        l_Remarks.SetRange("Timetable Code", Rec."Timetable Code");
                        l_Remarks.SetRange("Study Plan Code", Rec."Study Plan");
                        l_Remarks.SetRange("Type Remark", l_Remarks."Type Remark"::Summary);
                        if l_Remarks.Find('-') then
                            Error(Text029);



                        // Aulas com faltas marcadas a professores
                        l_Absence.Reset;
                        l_Absence.SetRange("Timetable Code", Rec."Timetable Code");
                        l_Absence.SetRange("School Year", Rec."School Year");
                        l_Absence.SetRange("Student/Teacher", l_Absence."Student/Teacher"::Teacher);
                        if l_Absence.Find('-') then
                            Error(Text014);


                        if Rec."Timetable Type" = Rec."Timetable Type"::Class then begin
                            rCalendar.Reset;
                            rCalendar.SetFilter("Timetable Code", Rec."Timetable Code");
                            rCalendar.SetRange("Lecture Status", rCalendar."Lecture Status"::Summary);
                            if rCalendar.Find('-') then
                                Error(Text010);

                            // Aulas com faltas marcadas a alunos
                            l_Absence.Reset;
                            l_Absence.SetRange("Timetable Code", Rec."Timetable Code");
                            l_Absence.SetRange("School Year", Rec."School Year");
                            l_Absence.SetRange("Student/Teacher", l_Absence."Student/Teacher"::Student);
                            if l_Absence.Find('-') then
                                Error(Text014);


                            Window.Open(Text022, intProgress);

                            rCalendar.Reset;
                            rCalendar.SetRange("Timetable Code", Rec."Timetable Code");
                            rCalendar.SetRange("School Year", Rec."School Year");
                            if rCalendar.Find('-') then begin
                                CountCalendario := rCalendar.Count;
                                iCalendario := 1;
                                repeat
                                    iCalendario := iCalendario + 1;
                                    intProgress := Round(iCalendario / CountCalendario * 10000, 1);
                                    Window.Update;

                                    rCalendar.Delete(true);
                                until rCalendar.Next = 0;
                            end;
                        end else begin

                            Window.Open(Text021, intProgress);
                            rTimetableTeacher.Reset;
                            rTimetableTeacher.SetRange("Timetable Code", Rec."Timetable Code");
                            rTimetableTeacher.SetRange("School Year", Rec."School Year");
                            if rTimetableTeacher.Find('-') then begin
                                CountCalendario := rTimetableTeacher.Count;
                                iCalendario := 1;

                                repeat
                                    iCalendario := iCalendario + 1;
                                    intProgress := Round(iCalendario / CountCalendario * 10000, 1);
                                    Window.Update;

                                    rTimetableTeacher.Delete(true);
                                until rTimetableTeacher.Next = 0;
                            end;
                        end;

                        Message(Text016, Rec."Timetable Code");


                        Window.Close;

                        //Bloquar campos.
                        ClassEditable := true;
                        "Timetable TypeEditable" := true;
                        "School YearEditable" := true;
                        "Responsibility CenterEditable" := true;
                        "Start PeriodEditable" := true;
                        "End PeriodEditable" := true;
                        "School CalendarEditable" := true;
                        "Template TimetableEditable" := true;
                        subformCalendarEditable := true;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.subformCalendar.PAGE.SetTypeVisible(Rec."Timetable Type", Rec."Study Plan", Rec.Type);

        SetEditableControl;
        ValidateFields;
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditableControl;

        ValidateFields;

        if Rec."Timetable Type" = Rec."Timetable Type"::Class then
            CurrPage.subformCalendar.PAGE.ShowFields(false)
        else
            CurrPage.subformCalendar.PAGE.ShowFields(true);
    end;

    trigger OnInit()
    begin
        DescriptionEditable := true;
        subformTeacherEditable := true;
        BlockedVisible := true;
        "Blocked TeacherVisible" := true;
        "Template TimetableEditable" := true;
        "School CalendarEditable" := true;
        "End PeriodEditable" := true;
        "Start PeriodEditable" := true;
        "Responsibility CenterEditable" := true;
        "School YearEditable" := true;
        "Timetable TypeEditable" := true;
        ClassEditable := true;
        subformCalendarEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := cUserEducation.GetEducationFilter(UserId);
    end;

    trigger OnOpenPage()
    begin
        SetEditableControl;

        ValidateFields;
    end;

    var
        rTimetableLines: Record "Timetable Lines";
        rCalendar: Record Calendar;
        rTeacherTimetableLines: Record "Teacher Timetable Lines";
        rTimetableTeacher: Record "Timetable-Teacher";
        rTemplates: Record Templates;
        cUserEducation: Codeunit "User Education";
        Text001: Label 'You are going to copy schedule %1, do you wish to continue?';
        Text003: Label 'Fill Schedule Code.';
        Text004: Label 'Insert School year.';
        Text005: Label 'Insert first and final period.';
        Text006: Label 'Insert class.';
        Text007: Label 'This field must not be blank.';
        Window: Dialog;
        iCalendario: Integer;
        intProgress: Integer;
        Text009: Label 'Do you wish to delete the calendar entries.';
        Text010: Label 'Summaried lectures already exist. Calendar entries can not be deleted.';
        Text011: Label 'Duplicating names is not allowed.';
        PreencheHeader: Boolean;
        Text012: Label 'Timetable is blocked.';
        Text013: Label 'This timetable has entry lines, copying is not allowed.';
        Text014: Label 'There are absences for this timetable period. ';
        Text015: Label 'Timetable code cannot be blank.';
        Text016: Label 'Timetable lines deleted successfully.';
        Text017: Label 'There are summaried lectures with an entry date later then the begining of this timetable.';
        vOk: Boolean;
        Text018: Label 'There are absences with a later date in this timetable.';
        Text019: Label 'Calendary created sucessfully for timetable %1.';
        Text020: Label 'The class is already filled.';
        Text021: Label 'Erasing teachers calendar @1@@@@@@@@@@@@@@@@@@@@@@@@\';
        Text022: Label 'Erasing calendar @1@@@@@@@@@@@@@@@@@@@@@@@@\';
        Text023: Label 'There are already entries for one or more teachers';
        Text025: Label 'Class Code must not be blank before copy';
        Text026: Label 'The timetable %1 of the type %2, already have a created calendar.';
        Text027: Label 'Please fill the field %1 in timetable lines %2.';
        Text028: Label 'Please Insert teacher to create the calendar.';
        Text029: Label 'Lecture is already summarized for the. Unable to eliminate registration.';
        CountCalendario: Integer;
        Text030: Label 'Please fill the field %1.';
        opCopyTimetable: Label 'Partial,Total';
        [InDataSet]
        subformCalendarEditable: Boolean;
        [InDataSet]
        ClassEditable: Boolean;
        [InDataSet]
        "Timetable TypeEditable": Boolean;
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Start PeriodEditable": Boolean;
        [InDataSet]
        "End PeriodEditable": Boolean;
        [InDataSet]
        "School CalendarEditable": Boolean;
        [InDataSet]
        "Template TimetableEditable": Boolean;
        [InDataSet]
        "Blocked TeacherVisible": Boolean;
        [InDataSet]
        BlockedVisible: Boolean;
        [InDataSet]
        subformTeacherEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        OptionPartialTotal: Integer;


    procedure SetEditableControl()
    begin
        if Rec."Timetable Type" = Rec."Timetable Type"::Teacher then begin
            if Rec.Class <> '' then
                Error(Text020);
            ClassEditable := false;
            "School YearEditable" := true;
            "Template TimetableEditable" := true;
            "Blocked TeacherVisible" := true;
            BlockedVisible := false;
        end;

        if Rec."Timetable Type" = Rec."Timetable Type"::Class then begin
            ClassEditable := true;
            "Blocked TeacherVisible" := false;
            BlockedVisible := true;
        end;
    end;


    procedure ValidateFields()
    begin
        Rec.CalcFields("Blocked Teacher", Blocked);
        subformCalendarEditable := true;
        subformTeacherEditable := true;

        if Rec."Blocked Teacher" then begin
            CurrPage.subformCalendar.PAGE.SetTypeVisible(Rec."Timetable Type", Rec."Study Plan", Rec.Type);
            "Timetable TypeEditable" := false;
            "School YearEditable" := false;
            "Responsibility CenterEditable" := false;
            "Start PeriodEditable" := false;
            "End PeriodEditable" := false;
            "School CalendarEditable" := false;
            "Template TimetableEditable" := false;
            DescriptionEditable := false;
            "School YearEditable" := false;
            "Template TimetableEditable" := false;
            subformTeacherEditable := false;
        end;

        if Rec.Blocked then begin
            CurrPage.subformCalendar.PAGE.SetTypeVisible(Rec."Timetable Type", Rec."Study Plan", Rec.Type);
            "Timetable TypeEditable" := false;
            ClassEditable := false;
            DescriptionEditable := false;
            "School YearEditable" := false;
            "Responsibility CenterEditable" := false;
            "Start PeriodEditable" := false;
            "End PeriodEditable" := false;
            "School CalendarEditable" := false;
            "Template TimetableEditable" := false;
            subformTeacherEditable := false;
        end;

        if (Rec."Timetable Type" = Rec."Timetable Type"::Class) and (Rec.Blocked = false) then begin
            "Timetable TypeEditable" := true;
            ClassEditable := true;
            DescriptionEditable := true;
            "School YearEditable" := true;
            "Responsibility CenterEditable" := true;
            "Start PeriodEditable" := true;
            "End PeriodEditable" := true;
            "School CalendarEditable" := true;
            "Template TimetableEditable" := true;
            subformTeacherEditable := false;
        end;
    end;

    local procedure ClassOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure TemplateTimetableOnAfterValida()
    begin
        CurrPage.Update;
    end;

    local procedure subformCalendarOnActivate()
    begin
        if Rec."Template Timetable" = '' then begin
            subformCalendarEditable := false;
            Message(Text030, Rec.FieldCaption("Template Timetable"));
        end;
    end;
}

#pragma implicitwith restore

