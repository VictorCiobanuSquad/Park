#pragma implicitwith disable
page 52890 "Recover Lines"
{
    Caption = 'Recover Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Test;
    SourceTableView = SORTING("Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
                      WHERE("Line Type" = FILTER(Line),
                            "Test Type" = FILTER("Recover Test"));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Name"; Rec."Student Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subjects Code"; Rec."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Recover Classif."; Rec."Recover Classif.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Absent; Rec.Absent)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Excl Ret by Incidences"; Rec."Excl Ret by Incidences")
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
        Rec."Test Type" := Rec."Test Type"::"Recover Test";
    end;

    var
        rTest: Record Test;
        rClassificationLevel: Record "Classification Level";
        text004: Label 'Grade should be between %1 and %2.';
}

#pragma implicitwith restore

