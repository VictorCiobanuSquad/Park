page 31009861 "Filter List"
{
    Caption = 'Filter List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Save Filters";
    SourceTableView = SORTING(Type, "Filter Code", "Field No.")
                      WHERE(Type = CONST(Header));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Filter Code"; "Filter Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Created On"; "Created On")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&ilter")
            {
                Caption = 'F&ilter';
                Image = "Filter";
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Filters Card";
                    RunPageLink = "Filter Code" = FIELD("Filter Code");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            FilterGroup(2);
            SetFilter("User ID", '%1|%2', UserId, '');
            SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            FilterGroup(0);
        end else begin
            FilterGroup(2);
            SetFilter("User ID", '%1|%2', UserId, '');
            FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}
