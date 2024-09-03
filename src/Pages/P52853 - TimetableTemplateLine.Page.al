#pragma implicitwith disable
page 52853 "Timetable Template Line"
{
    Caption = 'Timetable Template Line';
    Editable = false;
    PageType = List;
    SourceTable = "Template Timetable";
    SourceTableView = SORTING("School Year", Type, Day, "Initial Time")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Week Description"; Rec."Week Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Initial Time"; Rec."Initial Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Finish Time"; Rec."Finish Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Part of Day"; Rec."Part of Day")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Timetable Type"; Rec."Timetable Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

