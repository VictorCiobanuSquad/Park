#pragma implicitwith disable
page 52841 "Timetable Lines"
{
    Caption = 'Timetable Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Template Timetable";
    SourceTableView = SORTING("School Year", Type, Day, "Initial Time")
                      WHERE(Type = CONST(Lines));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Week Description"; Rec."Week Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Initial Time"; Rec."Initial Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Finish Time"; Rec."Finish Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Part of Day"; Rec."Part of Day")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Timetable Type"; Rec."Timetable Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CategoryEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Timetable Type" = Rec."Timetable Type"::Lesson then
            CategoryEditable := false
        else
            CategoryEditable := true;
    end;

    trigger OnInit()
    begin
        CategoryEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."School Year" = '' then
            Error(Text0001);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Line Header" := varLineNo;
        Rec."Responsibility Center" := varRespCenter;
    end;

    var
        varLineNo: Integer;
        varRespCenter: Code[20];
        Text0001: Label 'The School Year must be filled.';
        [InDataSet]
        CategoryEditable: Boolean;


    procedure GetLineNo(pLineNo: Integer; pRespCenter: Code[20])
    begin
        varLineNo := pLineNo;
        varRespCenter := pRespCenter;
    end;

    local procedure CategoryOnActivate()
    begin
        if Rec."Timetable Type" = Rec."Timetable Type"::Lesson then
            CategoryEditable := false
        else
            CategoryEditable := true;
    end;
}

#pragma implicitwith restore

