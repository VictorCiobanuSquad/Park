#pragma implicitwith disable
page 52936 "Multi Language Obs Drill"
{
    Caption = 'Multi Language Obs Drill';
    PageType = List;
    SourceTable = "Multi language observation";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field(Language; Rec.Language)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Male Text"; Rec."Male Text")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Female Text"; Rec."Female Text")
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
        Rec."School Year" := Rec."School Year";
        Rec."Observation Code" := Rec."Observation Code";
        Rec."Line No." := Rec."Line No.";
    end;
}

#pragma implicitwith restore

