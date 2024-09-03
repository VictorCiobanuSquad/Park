#pragma implicitwith disable
page 52793 "Setting Evaluations List"
{
    Caption = 'Setting Evaluations List';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Rank Group";

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
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
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
            group("&Setting Evaluations")
            {
                Caption = '&Setting Evaluations';
                action("&Setting Evaluations Card")
                {
                    ApplicationArea = All;
                    Caption = '&Setting Evaluations Card';
                    Image = OrderPromisingSetup;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        rRankGroup: Record "Rank Group";
                    begin
                        PAGE.Run(PAGE::"Setting Ratings Text", Rec)
                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

