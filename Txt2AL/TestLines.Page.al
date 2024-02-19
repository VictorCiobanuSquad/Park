#pragma implicitwith disable
page 31009814 "Test Lines"
{
    Caption = 'Test Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Test;
    SourceTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
                      WHERE("Line Type" = FILTER(Line),
                            "Test Type" = FILTER(Candidate));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Candidate no."; Rec."Candidate no.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Test Classification"; Rec."Test Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Points; Rec.Points)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Absent; Rec.Absent)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Test Type" := Rec."Test Type"::Candidate;
    end;

    var
        rCandidateEntry: Record "Candidate Entry";
        rTest: Record Test;
}

#pragma implicitwith restore

