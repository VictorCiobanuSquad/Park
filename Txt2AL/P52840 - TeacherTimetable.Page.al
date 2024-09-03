#pragma implicitwith disable
page 52840 "Teacher Timetable"
{
    AutoSplitKey = true;
    Caption = 'Teacher Timetable';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Teacher Timetable Lines";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        if rTimetable.Get(Rec."Timetable Code") then begin
                            rTimetable.CalcFields(Blocked, "Blocked Teacher");
                            if rTimetable.Blocked then
                                Error(Text0009);
                        end;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if rTimetable.Get(Rec."Timetable Code") then begin
            rTimetable.CalcFields(Blocked, "Blocked Teacher");
            if rTimetable.Blocked then
                Error(Text0009);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (rTimetableLines."Start Hour" = 0T) and (rTimetableLines.Subject = '') then
            Error(Text0001);

        if rTimetable.Get(Rec."Timetable Code") then begin
            rTimetable.CalcFields(Blocked, "Blocked Teacher");
            if rTimetable.Blocked then
                Error(Text0009);
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if rTimetable.Get(Rec."Timetable Code") then begin
            rTimetable.CalcFields(Blocked, "Blocked Teacher");
            if rTimetable.Blocked then
                Error(Text0009);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin


        Rec.Subject := rTimetableLines.Subject;
        Rec."Sub-Subject Code" := rTimetableLines."Sub-Subject Code";
        Rec.Day := rTimetableLines.Day;
    end;

    var
        SelectedLineChanged: Boolean;
        rTimetableLines: Record "Timetable Lines";
        Text0001: Label 'Is Mandatory insert Start Hour and Subject.';
        Text0009: Label 'O horário encontra-se bloqueado. Não pode fazer alterações.';
        rTimetable: Record Timetable;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
        CurrPage.Update(false); // Update this form. Its not necessary to update the complete form, updating the second subform is enough.
    end;

    //[Scope('OnPrem')]
    procedure IsSelectedLineChanged() UpdateNeeded: Boolean
    begin
        UpdateNeeded := SelectedLineChanged; // Return if a active line changed has occur...
        Clear(SelectedLineChanged); // := FALSE; // ...and clear the variable.
    end;

    //[Scope('OnPrem')]
    procedure GetLinesCalendar(pTimetableLines: Record "Timetable Lines")
    begin
        rTimetableLines := pTimetableLines;
    end;
}

#pragma implicitwith restore

