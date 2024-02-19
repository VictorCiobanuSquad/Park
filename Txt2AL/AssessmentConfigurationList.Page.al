#pragma implicitwith disable
page 31009896 "Assessment Configuration List"
{
    Caption = 'Assessment Configuration List';
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Assessment Configuration";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
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
            group("Ass&essment Configuration")
            {
                Caption = 'Ass&essment Configuration';
                Image = Evaluate;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Assessment Configuration", Rec)
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty then
            CurrPage.Editable(true);
    end;
}

#pragma implicitwith restore

