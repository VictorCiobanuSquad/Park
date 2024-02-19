#pragma implicitwith disable
page 31009831 "Insert Teacher Subform"
{
    AutoSplitKey = true;
    Caption = 'Insert Teacher Subform';
    PageType = ListPart;
    SourceTable = "Timetable-Teacher-Insert";

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InsertRespCenter;
    end;

    trigger OnOpenPage()
    begin
        InsertRespCenter;
    end;

    //[Scope('OnPrem')]
    procedure InsertRespCenter()
    var
        rClass: Record Class;
    begin
        if rClass.Get(Rec.Class, Rec."School Year") then begin
            Rec."Responsibility Center" := rClass."Responsibility Center";

        end;
    end;
}

#pragma implicitwith restore

