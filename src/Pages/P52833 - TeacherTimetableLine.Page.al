#pragma implicitwith disable
page 52833 "Teacher Timetable Line"
{
    Caption = 'Teacher Timetable Line';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Teacher Timetable Lines";

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
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

    var
        recHorarioLinhas: Record "Timetable Lines";
        recProfessor: Record Teacher;
        varFiltro: Text[30];


    procedure UpdateForm()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

