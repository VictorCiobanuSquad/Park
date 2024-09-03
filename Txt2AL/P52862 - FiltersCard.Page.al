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
                field("Filter Code"; "Filter Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Table No."; "Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Created On"; "Created On")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Created By/On';
                    Editable = false;
                }
                field("User ID"; "User ID")
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

