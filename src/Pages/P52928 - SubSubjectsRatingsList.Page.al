#pragma implicitwith disable
page 52928 "Sub-Subjects Ratings List"
{
    Caption = 'Sub-Subjects Ratings List';
    PageType = ListPart;
    SourceTable = "Setting Ratings Sub-Subjects";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                Editable = false;
                ShowCaption = false;
                field("Moment Code"; Rec."Moment Code")
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
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Description"; Rec."Sub-Subject Description")
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

