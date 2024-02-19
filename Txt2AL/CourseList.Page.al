#pragma implicitwith disable
page 31009868 "Course List"
{
    Caption = 'Course List';
    CardPageID = Course;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Course Header";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year Begin"; Rec."School Year Begin")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
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

        Rec.SetRange(Blocked, false);
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

