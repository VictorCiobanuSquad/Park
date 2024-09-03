#pragma implicitwith disable
page 52972 "Calendar Changes"
{
    Caption = 'Calendar Changes';
    DataCaptionFields = "Base Calendar Code";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Base Calendar ChangeEDU";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Recurring System"; Rec."Recurring System")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Recurring System';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nonworking; Rec.Nonworking)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Nonworking';
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

