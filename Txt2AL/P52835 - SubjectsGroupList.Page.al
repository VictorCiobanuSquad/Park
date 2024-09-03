#pragma implicitwith disable
page 52835 "Subjects Group List"
{
    Caption = 'Subjects Group List';
    Editable = false;
    PageType = List;
    SourceTable = "Subjects Group";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Teacher Name"; Rec."Teacher Name")
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

