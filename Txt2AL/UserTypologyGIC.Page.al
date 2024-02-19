#pragma implicitwith disable
page 31009931 "User Typology GIC"
{
    Caption = 'User Typology GIC';
    PageType = List;
    SourceTable = "User Group GIC";
    SourceTableView = SORTING(Type, Code)
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Typology));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
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
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Typology;
    end;
}

#pragma implicitwith restore

