#pragma implicitwith disable
page 52790 "Student Subjects Entry"
{
    Caption = 'Student Subjects Entry';
    Editable = false;
    PageType = List;
    SourceTable = "Student Subjects Entry";

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subjects Code"; Rec."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Enroled; Rec.Enroled)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Option Group"; Rec."Option Group")
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

