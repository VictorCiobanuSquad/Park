#pragma implicitwith disable
page 52912 "Health & Safety Code List"
{
    Caption = 'Health & Safety Code List';
    PageType = List;
    SourceTable = "H&S";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
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

