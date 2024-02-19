#pragma implicitwith disable
page 31009803 "Remarks Text"
{
    Caption = 'Remarks Text';
    PageType = Card;
    SourceTable = Remarks;

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Textline; Rec.Textline)
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

