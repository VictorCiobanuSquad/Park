#pragma implicitwith disable
page 31009820 "Teacher Calendar List"
{
    Caption = 'Teacher Calendar List';
    DeleteAllowed = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Timetable-Teacher";

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field("Timetable Code"; Rec."Timetable Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    Visible = false;
                }
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if rHorario.Get(Rec."Timetable Code") then begin
                            rTeacherClass.Reset;
                            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
                            rTeacherClass.SetRange("School Year", rHorario."School Year");
                            rTeacherClass.SetRange(Class, Rec.Class);
                            rTeacherClass.SetRange(rTeacherClass."Type Subject", rTeacherClass."Type Subject"::Subject);
                            rTeacherClass.SetRange(rTeacherClass."Subject Code", Rec.Subject);
                            if Rec."Sub-Subject Code" <> '' then
                                rTeacherClass.SetRange(rTeacherClass."Sub-Subject Code", Rec."Sub-Subject Code");
                            //IF rTeacherClass.FIND('-') THEN
                            if PAGE.RunModal(PAGE::"Teacher Class List", rTeacherClass) = ACTION::LookupOK then
                                Rec.Validate("Teacher No.", rTeacherClass.User);
                        end;
                    end;
                }
                field("Teacher Name"; Rec."Teacher Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Type Subject"; Rec."Type Subject")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    var
        rHorario: Record Timetable;
        rTeacherClass: Record "Teacher Class";
}

#pragma implicitwith restore

