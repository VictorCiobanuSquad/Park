#pragma implicitwith disable
page 31009856 "Absence Config."
{
    Caption = 'Absence Config.';
    DelayedInsert = false;
    PageType = ListPart;
    SourceTable = "Incidence Type";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Justification Code"; Rec."Justification Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
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
        Rec."Absence Status" := Rec."Absence Status"::Justification;
        Rec."Incidence Type" := Rec."Incidence Type"::Absence;
    end;

    var
        repCopyIncidence: Report "Copy Incidence";
}

#pragma implicitwith restore

