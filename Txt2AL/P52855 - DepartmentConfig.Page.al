#pragma implicitwith disable
page 52855 "Department Config."
{
    Caption = 'Department Config.';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Subjects Group";
    SourceTableView = WHERE(Type = CONST(Subject));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Department description';
                }
                field("Head of Department"; Rec."Head of Department")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Name of the Head of Department"; Rec."Name of the Head of Department")
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

