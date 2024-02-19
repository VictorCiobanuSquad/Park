#pragma implicitwith disable
page 31009879 "Study Course Subjects"
{
    Caption = 'Study Course Subjects';
    Editable = false;
    PageType = List;
    SourceTable = "Course Lines";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
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

