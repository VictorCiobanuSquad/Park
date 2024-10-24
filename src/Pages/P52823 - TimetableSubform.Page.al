#pragma implicitwith disable
page 52823 "Timetable Subform"
{
    AutoSplitKey = true;
    Caption = 'Timetable Subform';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Timetable Lines";

    layout
    {
        area(content)
        {
            repeater(Control1101490000)
            {
                ShowCaption = false;
                field("Day Description"; Rec."Day Description")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Validatefields;
                        StartHourOnAfterValidate;
                    end;
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = SubjectVisible;

                    trigger OnValidate()
                    begin
                        Rec."Sub-Subject Code" := '';
                        Rec.Turn := '';
                        Rec.Validate(Subject, Rec.Subject);
                        Validatefields;
                        SubjectOnAfterValidate;
                    end;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject Code';
                    Editable = "Sub-Subject CodeEditable";
                    Visible = "Sub-Subject CodeVisible";

                    trigger OnValidate()
                    var
                        rTimetable: Record Timetable;
                        rClass: Record Class;
                    begin
                        Rec.Turn := '';
                        SubSubjectCodeOnAfterValidate;
                    end;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = TurnVisible;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Meeting; Rec.Meeting)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = MeetingVisible;

                    trigger OnValidate()
                    begin
                        MeetingOnAfterValidate;
                    end;
                }
                field(Target; Rec.Target)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = TargetVisible;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = LevelVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Professores)
            {
                ApplicationArea = All;
                Caption = 'Professores';
                Image = UserCertificate;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    rTimetableLine: Record "Timetable Lines";
                    pTeacherTimetable: Page "Teacher Timetable";
                    rTeacherTimetableLines: Record "Teacher Timetable Lines";
                    rTimeTable: Record Timetable;
                begin
                    CurrPage.GetRecord(rTimetableLine); // Get the active subform record, Sales Line in this sample.
                    rTimeTable.Reset;
                    rTimeTable.SetRange("Timetable Code");
                    if rTimeTable.FindFirst then begin

                        //Codigo do set cenas
                        rTeacherTimetableLines.Reset;
                        rTeacherTimetableLines.SetRange("Timetable Code", rTimetableLine."Timetable Code");
                        rTeacherTimetableLines.SetRange("Timetable Line No.", rTimetableLine."Line No.");
                        if rTimeTable."Timetable Type" = rTimeTable."Timetable Type"::Class then
                            rTeacherTimetableLines.SetRange(rTeacherTimetableLines.Class, rTimetableLine.Class);
                        if rTimeTable."Timetable Type" = rTimeTable."Timetable Type"::Teacher then
                            rTeacherTimetableLines.SetRange(Subject, rTimetableLine.Subject);

                        pTeacherTimetable.SetTableView(rTeacherTimetableLines);
                        pTeacherTimetable.GetLinesCalendar(rTimetableLine);
                        pTeacherTimetable.Run;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //IF PrevPosition <> GETPOSITION THEN // If the current record position is different from the previous position...
        SelectedLineChanged := true; // ...administrate there has been a change in active subform record.

        //PrevPosition := GETPOSITION;

        Validatefields;
    end;

    trigger OnAfterGetRecord()
    begin
        Validatefields;
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Sub-Subject CodeEditable" := true;
        "Sub-Subject CodeVisible" := true;
        TurnVisible := true;
        SubjectVisible := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if xRec."Start Hour" = 0T then
            exit;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if xRec."Start Hour" = 0T then
            exit;

        if Rec.Day = xRec.Day then begin
            Rec.Time := xRec.Time;
            Rec.Day := xRec.Day;
            Rec."Day Description" := xRec."Day Description";
        end else begin
            Rec.Type := xRec.Type;
            Rec.Time := 0;
            Rec.Day := xRec.Day;
            Rec."Day Description" := xRec."Day Description";
        end;

        if Rec.Day = 0 then
            Rec.Day := 1;

        if vTimetable = vTimetable::Teacher then
            Rec.Type := Rec.Type::"Non scholar component";

        if rCalendar.Get(Rec."Timetable Code") then
            Rec."Responsibility Center" := rCalendar."Responsibility Center";
        //OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        TabFornecedoresHorario: Record "Teacher Timetable Lines";
        recSubject: Record Subjects;
        recTeacherClass: Record "Teacher Class";
        PrevPosition: Text[1024];
        SelectedLineChanged: Boolean;
        vTimetable: Option Class,Teacher;
        vTeacher: Code[20];
        Text0002: Label 'For teacher %1 there are no linked subjects.';
        Text0003: Label 'Nothing to open.';
        rCalendar: Record Calendar;
        rTurnTEMP: Record Turn temporary;
        [InDataSet]
        SubjectVisible: Boolean;
        [InDataSet]
        TurnVisible: Boolean;
        [InDataSet]
        "Sub-Subject CodeVisible": Boolean;
        [InDataSet]
        MeetingVisible: Boolean;
        [InDataSet]
        TargetVisible: Boolean;
        [InDataSet]
        LevelVisible: Boolean;
        [InDataSet]
        "Sub-Subject CodeEditable": Boolean;


    procedure Activar()
    begin
        CurrPage.Activate;
        CurrPage.Update(false);
    end;


    procedure IsSelectedLineChanged() UpdateNeeded: Boolean
    begin
        UpdateNeeded := SelectedLineChanged; // Return if a active line changed has occur...
        Clear(SelectedLineChanged); // := FALSE; // ...and clear the variable.
    end;


    procedure SetVisibleControls()
    begin
        if Rec.Class = '' then
            SubjectVisible := false
        else
            SubjectVisible := true;
    end;


    procedure SetTypeVisible(pTimetableType: Option Class,Teacher; pStudyPlanCode: Code[20]; pType: Option Simple,Multi)
    var
        l_StudyPlanHeader: Record "Study Plan Header";
        l_CourseHeader: Record "Course Header";
    begin
        if pTimetableType = pTimetableType::Class then begin
            TurnVisible := true;
            if pType = pType::Simple then begin
                if l_StudyPlanHeader.Get(pStudyPlanCode) then;
                if l_StudyPlanHeader."Sub-subjects for assess. only" then
                    "Sub-Subject CodeVisible" := false
                else
                    "Sub-Subject CodeVisible" := true;
            end;
            if pType = pType::Multi then begin
                if l_CourseHeader.Get(pStudyPlanCode) then;
                if l_CourseHeader."Sub-subjects for assess. only" then
                    "Sub-Subject CodeVisible" := false
                else
                    "Sub-Subject CodeVisible" := true;
            end;

            "Sub-Subject CodeEditable" := true;
        end else begin
            TurnVisible := false;
            "Sub-Subject CodeEditable" := false;
        end;

        vTimetable := pTimetableType;
    end;


    procedure Validatefields()
    begin
        if (Rec.Type = Rec.Type::"Non scholar hours") or (Rec.Type = Rec.Type::"Non scholar component") then
            "Sub-Subject CodeEditable" := false
        else
            "Sub-Subject CodeEditable" := true;
    end;


    procedure ShowFields(p_Show: Boolean)
    begin
        MeetingVisible := p_Show;
        TargetVisible := p_Show;
        LevelVisible := p_Show;
    end;

    local procedure StartHourOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SubjectOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SubSubjectCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure MeetingOnAfterValidate()
    begin
        Rec.Target := '';
        Rec.Level := 0;
    end;

    local procedure OnActivateForm()
    begin
        Validatefields;
    end;

    local procedure OnBeforePutRecord()
    begin
        Validatefields;
    end;
}

#pragma implicitwith restore

