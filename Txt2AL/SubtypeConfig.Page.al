#pragma implicitwith disable
page 31009905 "Subtype Config"
{
    Caption = 'Subtype Config';
    PageType = List;
    SourceTable = "Sub Type";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                Editable = false;
                ShowCaption = false;
                field("Subcategory Code"; Rec."Subcategory Code")
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

