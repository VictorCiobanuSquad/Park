#pragma implicitwith disable
page 31009929 "Overall Aspects"
{
    AutoSplitKey = true;
    Caption = 'Overall Aspects';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Aspects;
    SourceTableView = SORTING(Type, "School Year", "Type No.", "Schooling Year", "Moment Code", Subjects, "Sub Subjects", "Responsibility Center", "Line No.")
                      WHERE(Type = CONST(Overall));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Responsibility Center';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("% Evaluation"; Rec."% Evaluation")
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
                field("Not to WEB"; Rec."Not to WEB")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Not to WEBEditable";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        "Not to WEBEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
        [InDataSet]
        "Not to WEBEditable": Boolean;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        if Rec.Type = Rec.Type::Overall then
            "Not to WEBEditable" := false
        else
            "Not to WEBEditable" := true
    end;
}

#pragma implicitwith restore

