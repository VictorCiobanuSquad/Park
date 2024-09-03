#pragma implicitwith disable
page 52873 "List Course Lines"
{
    Caption = 'List Course Lines';
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

