#pragma implicitwith disable
page 52955 "Non Scholar hours"
{
    Caption = 'Non Scholar hours';
    PageType = List;
    SourceTable = Subjects;
    SourceTableView = WHERE(Type = FILTER("Non scholar hours"));

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
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Abbreviation Description"; Rec."Abbreviation Description")
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
        Rec.Type := Rec.Type::"Non scholar hours";
        Rec.Category := Rec.Category::Cantine;
    end;
}

#pragma implicitwith restore

