#pragma implicitwith disable
page 52943 "Study Plan List Temp"
{
    Caption = 'Study Plan List Temp';
    PageType = List;
    SourceTable = "Registration Class";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                Editable = false;
                ShowCaption = false;
                field("Study Plan Code"; Rec."Study Plan Code")
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
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

