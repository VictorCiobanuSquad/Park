#pragma implicitwith disable
page 52921 Aspects
{
    AutoSplitKey = true;
    Caption = 'Aspects';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Aspects;

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Type No."; Rec."Type No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subjects; Rec.Subjects)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub Subjects"; Rec."Sub Subjects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject Code';
                    Editable = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("% Evaluation"; Rec."% Evaluation")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Not to WEB"; Rec."Not to WEB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Delete Lines")
            {
                Caption = '&Delete Lines';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.DeleteAll(true);
                end;
            }
        }
    }
}

#pragma implicitwith restore

