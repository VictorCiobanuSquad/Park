#pragma implicitwith disable
page 52842 "Study Plan Subjects"
{
    Caption = 'Study Plan Subjects';
    PageType = List;
    SourceTable = "Study Plan Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
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

