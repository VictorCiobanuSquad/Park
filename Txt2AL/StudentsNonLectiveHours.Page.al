#pragma implicitwith disable
page 31009957 "Students Non Lective Hours"
{
    Caption = 'Students Non Lective Hours';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Students Non Lective Hours";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Lunch; Rec.Lunch)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Collect Transport"; Rec."Collect Transport")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimated Colect Hour"; Rec."Estimated Colect Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Collect Stop Address"; Rec."Collect Stop Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Collect Stop Address 2"; Rec."Collect Stop Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Collect Post Code"; Rec."Collect Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Collect Location"; Rec."Collect Location")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Collect County"; Rec."Collect County")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Deliver Transport"; Rec."Deliver Transport")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estimated Deliver Hour"; Rec."Estimated Deliver Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Deliver Stop Address"; Rec."Deliver Stop Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Deliver Stop Address 2"; Rec."Deliver Stop Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Deliver Post Code"; Rec."Deliver Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Deliver Location"; Rec."Deliver Location")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Deliver County"; Rec."Deliver County")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

