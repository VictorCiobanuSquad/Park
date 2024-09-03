#pragma implicitwith disable
page 52942 "Class Sub-Subjects Lines"
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
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Description"; Rec."Sub-Subject Description")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field("Minimum Classification Level"; Rec."Minimum Classification Level")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Maximum Total Absence"; Rec."Maximum Total Absence")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Moment Ponder"; Rec."Moment Ponder")
                {
                    Editable = false;
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
                action("Subject &Assement Configuration")
                {
                    Caption = 'Subject &Assement Configuration';
                    Visible = false;
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    begin
                        Rec.OpenCreateAssessmentConf;
                    end;
                }
                action("&Aspects")
                {
                    Caption = '&Aspects';
                    ApplicationArea = Basic, Suite;

                    trigger OnAction()
                    begin
                        Rec.SubjectsAspects2(vSchoolYear, vSchoolingYear, vClass);
                    end;
                }
            }
        }
    }

    var
        vClass: Code[20];
        vSchoolingYear: Code[10];
        vSchoolYear: Code[9];

    //[Scope('OnPrem')]
    procedure GetClass(pClass: Code[20]; pSchoolingYear: Code[10]; pSchoolYear: Code[9])
    begin
        vClass := pClass;
        vSchoolingYear := pSchoolingYear;
        vSchoolYear := pSchoolYear;
    end;
}

#pragma implicitwith restore

