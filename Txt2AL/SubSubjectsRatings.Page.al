#pragma implicitwith disable
page 31009934 "Sub-Subjects Ratings"
{
    Caption = 'Sub-Subjects Ratings List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
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
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Sub-Subjects Setting Ratings")
            {
                Caption = '&Sub-Subjects Setting Ratings';
                action("&Sub-Subjects Card")
                {
                    Caption = '&Sub-Subjects Card';
                    Image = SubcontractingWorksheet;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(31009927, Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

