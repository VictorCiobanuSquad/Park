#pragma implicitwith disable
page 52782 "SubForm Services DistEntity"
{
    Caption = 'Services Distributed by Entity';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Services Distributed by Entity";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field(Kinship; Rec.Kinship)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Name of Associate"; Rec."Name of Associate")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Service Code"; Rec."Service Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Percent %"; Rec."Percent %")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

