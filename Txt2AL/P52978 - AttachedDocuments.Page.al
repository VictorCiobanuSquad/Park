#pragma implicitwith disable
page 52978 "Attached Documents"
{
    Caption = 'Attached Documents';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Attached Documents";

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field("Table"; Rec.Table)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Attach; Rec.Attach)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Extension; Rec.Extension)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Show)
            {
                ApplicationArea = All;
                Caption = 'Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    if Attachment.ExportAttachment(Rec) then
                        Message(Text0001);
                end;
            }
        }
    }

    var
        Attachment: Record "Attached Documents";
        Text0001: Label 'File exported successfully.';
}

#pragma implicitwith restore

