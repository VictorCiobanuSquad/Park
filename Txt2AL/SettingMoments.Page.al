#pragma implicitwith disable
page 31009795 "Setting Moments"
{
    Caption = 'Setting Moments';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "Moments Assessment";
    SourceTableView = SORTING("School Year", "Schooling Year", "Sorting ID")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorting ID';
                }
                field("Moment Code"; Rec."Moment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Moment Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Moment"; Rec."Evaluation Moment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Evaluation Moment';
                }
                field(Weighting; Rec.Weighting)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Recuperation; Rec.Recuperation)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Recuperation';
                    Visible = false;
                }
                field(Publish; Rec.Publish)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Responsibility Center';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = ServiceSetup;
                action("&Copy")
                {
                    Caption = '&Copy';
                    Image = Copy;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RepCopyMoments: Report "Copy Moments";
                    begin

                        RepCopyMoments.GetMoments(Rec."Schooling Year", Rec."School Year", Rec."Responsibility Center");
                        RepCopyMoments.RunModal;
                        Clear(RepCopyMoments);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Country/Region Code" := cStudentsRegistration.GetCountry;
    end;

    trigger OnOpenPage()
    begin

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

