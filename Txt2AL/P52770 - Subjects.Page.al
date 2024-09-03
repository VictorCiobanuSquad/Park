#pragma implicitwith disable
page 52770 Subjects
{
    Caption = 'Subjects';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Subjects;
    SourceTableView = WHERE(Type = FILTER(Subject));

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
                field(Department; Rec.Department)
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
        Rec.Type := Rec.Type::Subject;
    end;
}

#pragma implicitwith restore

