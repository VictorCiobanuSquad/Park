#pragma implicitwith disable
page 31009794 "Criteria evaluation"
{
    Caption = 'Criteria evaluation';
    PageType = List;
    SourceTable = "Criteria Evaluation";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
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

