#pragma implicitwith disable
page 52772 "Services Plan Line"
{
    Caption = 'Services Plan Line';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Services Plan Line";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(January; Rec.January)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(February; Rec.February)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(March; Rec.March)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(April; Rec.April)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(May; Rec.May)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(June; Rec.June)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(July; Rec.July)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(August; Rec.August)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Setember; Rec.Setember)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(October; Rec.October)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(November; Rec.November)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Dezember; Rec.Dezember)
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
        Rec."Country/Region Code" := CStudentsRegistration.GetCountry;
        if rServicesPlanHead.Get(Rec.Code) then
            Rec."Responsibility Center" := rServicesPlanHead."Responsibility Center";
    end;

    var
        CStudentsRegistration: Codeunit "Students Registration";
        rServicesPlanHead: Record "Services Plan Head";
}

#pragma implicitwith restore

