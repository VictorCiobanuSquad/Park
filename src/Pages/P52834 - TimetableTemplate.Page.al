#pragma implicitwith disable
page 52834 "Timetable Template"
{
    Caption = 'Timetable Template';
    Editable = false;
    PageType = List;
    SourceTable = "Template Timetable";
    SourceTableView = SORTING("School Year", Type, "Template Code", Day, Time)
                      WHERE(Type = CONST(Header));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Template Description"; Rec."Template Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

