#pragma implicitwith disable
page 31009930 "User Group GIC"
{
    Caption = 'User Group GIC';
    PageType = List;
    SourceTable = "User Group GIC";
    SourceTableView = SORTING(Type, Code)
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Group));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Typology; Rec.Typology)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Teacher; Rec.Teacher)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Activate; Rec.Activate)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Child; Rec.Child)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Group Defect"; Rec."Group Defect")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Academic; Rec.Academic)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
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
        Rec.Type := Rec.Type::Group;
    end;
}

#pragma implicitwith restore

