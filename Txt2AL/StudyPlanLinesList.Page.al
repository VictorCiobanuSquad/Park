#pragma implicitwith disable
page 31009849 "Study Plan Lines List"
{
    Caption = 'Study Plan Lines List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Study Plan Lines";

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
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
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

