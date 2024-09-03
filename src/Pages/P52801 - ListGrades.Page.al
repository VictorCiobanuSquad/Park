#pragma implicitwith disable
page 52801 "List Grades"
{
    Caption = 'List Grades';
    Editable = false;
    PageType = List;
    SourceTable = "Classification Level";
    SourceTableView = SORTING("Id Ordination")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Classification Level Code"; Rec."Classification Level Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description Level"; Rec."Description Level")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Min Value"; Rec."Min Value")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Max Value"; Rec."Max Value")
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

