#pragma implicitwith disable
page 31009925 "Study Plan Sub-Subjects Lines"
{
    Caption = 'Study Plan Sub-Subjects Lines';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Study Plan Sub-Subjects Lines";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
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
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Minimum Classification Level"; Rec."Minimum Classification Level")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Maximum Total Absence"; Rec."Maximum Total Absence")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Moment Ponder"; Rec."Moment Ponder")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sorting ID"; Rec."Sorting ID")
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
            group("Fu&nction")
            {
                Caption = 'Fu&nction';
                action("Sub-S&etting Ratings/Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-S&etting Ratings/Aspects';
                    Image = WIP;

                    trigger OnAction()
                    begin

                        Rec.TestField("Assessment Code");

                        if Rec."Evaluation Type" = Rec."Evaluation Type"::"None Qualification" then
                            Error(Text001)
                        else
                            Rec.OpenCreateAssessmentConf;
                    end;
                }
                separator(Action1102065005)
                {
                }
                action("&Insert sub-subject")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Insert sub-subject';
                    Image = WIPEntries;

                    trigger OnAction()
                    begin
                        Rec.UpdateSubSubject;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Line No." := varLineNo;
    end;

    var
        varLineNo: Integer;
        Text001: Label 'This option is not available. Subject evaluation type: None Qualification. ';

    //[Scope('OnPrem')]
    procedure GetLineNo(pLineNo: Integer)
    begin
        varLineNo := pLineNo;
    end;
}

#pragma implicitwith restore

