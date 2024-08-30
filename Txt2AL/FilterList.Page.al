#pragma implicitwith disable
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
                field("Filter Code"; Rec."Filter Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
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
            Rec.FilterGroup(2);
            Rec.SetFilter("User ID", '%1|%2', UserId, '');
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end else begin
            Rec.FilterGroup(2);
            Rec.SetFilter("User ID", '%1|%2', UserId, '');
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore
