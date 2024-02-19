#pragma implicitwith disable
page 31009824 "Teacher Timetable Lines"
{
    Caption = 'Teacher Timetable Lines';
    PageType = List;
    SourceTable = "Teacher Timetable Lines";

    layout
    {
        area(content)
        {
            repeater(Control1101490000)
            {
                ShowCaption = false;
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec."Timetable Code" := Rec.GetFilter("Timetable Code");
        if Rec.GetFilter("Line No.") <> '' then
            Evaluate(Rec."Line No.", Rec.GetFilter("Line No."));
        if Rec.GetFilter(Day) <> '' then
            Evaluate(Rec.Day, Rec.GetFilter(Day));
    end;
}

#pragma implicitwith restore

