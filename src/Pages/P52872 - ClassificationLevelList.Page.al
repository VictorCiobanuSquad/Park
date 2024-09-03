
page 52872 "Classification Level List"
{
    Caption = 'Classification Level List';
    PageType = Card;
    SourceTable = "Classification Level";

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
                field("Short Level Description"; Rec."Short Level Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Id Ordination"; Rec."Id Ordination")
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
                field(Value; Rec.Value)
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


