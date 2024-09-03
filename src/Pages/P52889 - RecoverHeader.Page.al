#pragma implicitwith disable
page 52889 "Recover Header"
{
    Caption = 'Recover Header Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Test;
    SourceTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
                      WHERE("Line Type" = CONST(Header),
                            "Test Type" = CONST("Recover Test"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Test No."; Rec."Test No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
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
            part(subLines; "Recover Lines")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Test No." = FIELD("Test No."),
                              "Test Type" = FIELD("Test Type");
            }
            group(Assessment)
            {
                Caption = 'Assessment';
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Test No.");
    end;
}

#pragma implicitwith restore

