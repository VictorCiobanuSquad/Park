page 50001 "Comment Line Edit"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Comment Line";

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field(TableName; Rec."Table Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Table Name';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'No.';
                }
                field(Type; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Type';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Line No.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        lastRec: Record "Comment Line";
    begin
        lastRec.Reset();
        lastRec.CopyFilters(Rec);
        if lastRec.FindLast() then
            Rec."Line No." := lastRec."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;
}