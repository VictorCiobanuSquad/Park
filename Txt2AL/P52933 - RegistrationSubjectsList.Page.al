#pragma implicitwith disable
page 52933 "Registration Subjects List"
{
    Caption = 'Registration Subjects List';
    Editable = false;
    PageType = List;
    SourceTable = "Registration Subjects";

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
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
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
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

