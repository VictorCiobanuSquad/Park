#pragma implicitwith disable
page 52837 "Teacher Subjects Group"
{
    Caption = 'Teacher Department';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Subjects Group";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Teacher Name"; Rec."Teacher Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Department description';
                    Editable = false;
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        Rec.CalcFields("Teacher Name");
    end;
}

#pragma implicitwith restore

