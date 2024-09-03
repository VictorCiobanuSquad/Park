#pragma implicitwith disable
page 52887 "Non Scholar Component"
{
    Caption = 'Non Scholar Component';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Subjects;
    SourceTableView = WHERE(Type = FILTER("Non scholar component"));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Abbreviation Description"; Rec."Abbreviation Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Period"; Rec."Absence Period")
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

