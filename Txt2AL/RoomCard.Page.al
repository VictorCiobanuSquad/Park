#pragma implicitwith disable
page 31009875 "Room Card"
{
    Caption = 'Room Card';
    PageType = Card;
    SourceTable = Room;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Room Code"; Rec."Room Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Room Type"; Rec."Room Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Room Description"; Rec."Room Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Abbreviation Description"; Rec."Abbreviation Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Capacity; Rec.Capacity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Capacity (users)';
                }
                field("Average Users per Month"; Rec."Average Users per Month")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Operational; Rec.Operational)
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

