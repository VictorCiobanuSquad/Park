#pragma implicitwith disable
page 31009941 "Group Subjects Card"
{
    Caption = 'Group Subjects Card';
    PageType = Card;
    SourceTable = "Group Subjects";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Code';
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
                field(Ponder; Rec.Ponder)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ponder';
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    local procedure SchoolingYearOnAfterValidate()
    begin
        CurrPage.SaveRecord;
    end;
}

#pragma implicitwith restore

