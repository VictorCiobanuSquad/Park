#pragma implicitwith disable
page 31009940 "Groups Subjects List"
{
    Caption = 'Subject Groups List';
    PageType = List;
    SourceTable = "Group Subjects";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Ponder; Rec.Ponder)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Subject Group")
            {
                Caption = '&Subject Group';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Group Subjects Card", Rec);
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

