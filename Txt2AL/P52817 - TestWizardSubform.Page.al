#pragma implicitwith disable
page 52817 "Test Wizard Subform"
{
    Caption = 'Test Wizard Subform';
    PageType = CardPart;
    SourceTable = Test;
    SourceTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
                      WHERE("Line Type" = FILTER(Header),
                            "Test Type" = FILTER(Candidate));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Test No."; Rec."Test No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Hour; Rec.Hour)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Room; Rec.Room)
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

