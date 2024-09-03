#pragma implicitwith disable
page 52862 "Filters Card"
{
    Caption = 'Filters Card';
    PageType = Card;
    SourceTable = "Save Filters";
    SourceTableView = SORTING(Type, "Filter Code", "Field No.")
                      WHERE(Type = CONST(Header));

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filter';
                field("Filter Code"; Rec."Filter Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Created By/On';
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            part(Control1110008; "Filters SubForm")
            {
                ApplicationArea = All;
                SubPageLink = "Filter Code" = FIELD("Filter Code");
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

