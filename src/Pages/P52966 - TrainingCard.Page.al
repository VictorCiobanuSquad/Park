#pragma implicitwith disable
page 52966 "Training Card"
{
    Caption = 'Training Card';
    PageType = Card;
    SourceTable = Training;

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. Hours"; Rec."No. Hours")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Provider"; Rec."Service Provider")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Audience; Rec.Audience)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Goals; Rec.Goals)
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

