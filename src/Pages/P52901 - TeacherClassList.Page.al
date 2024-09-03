#pragma implicitwith disable
page 52901 "Teacher Class List"
{
    Caption = 'Teacher Class List';
    Editable = false;
    PageType = List;
    SourceTable = "Teacher Class";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field(User; Rec.User)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
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

