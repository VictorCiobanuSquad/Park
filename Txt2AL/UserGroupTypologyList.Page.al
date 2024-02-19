#pragma implicitwith disable
page 31009932 "User Group/Typology List"
{
    Caption = 'User Group/Typology List';
    PageType = List;
    SourceTable = "User Group GIC";

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

