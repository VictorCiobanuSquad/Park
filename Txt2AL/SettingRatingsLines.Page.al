#pragma implicitwith disable
page 31009797 "Setting Ratings Lines"
{
    AutoSplitKey = true;
    Caption = 'Setting Ratings Lines';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Setting Ratings";
    SourceTableView = WHERE(Type = FILTER(Lines));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Criterion 1"; Rec."Criterion 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Criterion 2"; Rec."Criterion 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Criterion 3"; Rec."Criterion 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Lines;
    end;
}

#pragma implicitwith restore

