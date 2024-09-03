#pragma implicitwith disable
page 52902 "Recover Test List"
{
    Caption = 'Recover Test List';
    PageType = List;
    SourceTable = Test;
    SourceTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
                      WHERE("Line Type" = FILTER(Header),
                            "Test Type" = FILTER("Recover Test"));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
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
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Recover Test")
            {
                Caption = '&Recover Test';
                action("&Card")
                {
                    ApplicationArea = All;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Recover Header";
                    RunPageLink = "Line Type" = FIELD("Line Type"),
                                  "Test No." = FIELD("Test No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

