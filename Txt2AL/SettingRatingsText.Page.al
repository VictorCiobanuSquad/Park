#pragma implicitwith disable
page 31009791 "Setting Ratings Text"
{
    Caption = 'Setting Evaluations';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Rank Group";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Minimum Classification Level"; Rec."Minimum Classification Level")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control1110008; "Classification Level")
            {
                SubPageLink = "Classification Group Code" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Lista)
            {
                Caption = 'List';
                Image = List;
                RunObject = Page "Setting Evaluations List";
            }
        }
    }
}

#pragma implicitwith restore

