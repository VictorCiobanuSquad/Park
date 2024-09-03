#pragma implicitwith disable
page 52882 "Rules of Evaluation"
{
    Caption = 'Rules of Evaluation';
    PageType = List;
    SourceTable = "Rules of Evaluations";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Characterise Subjects"; Rec."Characterise Subjects")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Classifications Calculations"; Rec."Classifications Calculations")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 1"; Rec."Code Value 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 2"; Rec."Code Value 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 3"; Rec."Code Value 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 4"; Rec."Code Value 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 5"; Rec."Code Value 5")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Value 6"; Rec."Code Value 6")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Round Method"; Rec."Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec.Type := varType;
        Rec."Study Plan Code" := varStudyPlan;
    end;

    trigger OnOpenPage()
    begin
        VisibleFieds;
    end;

    var
        varType: Option Simple,Multi;
        varStudyPlan: Code[20];

    //[Scope('OnPrem')]
    procedure GetInfo(pType: Option Simple,Multi; pStudyPlan: Code[20])
    begin
        varType := pType;
        varStudyPlan := pStudyPlan;
    end;

    //[Scope('OnPrem')]
    procedure VisibleFieds()
    begin
        /*
        IF varStudyPlan <> '' THEN BEGIN
          CurrForm."Characterise Subjects".VISIBLE(FALSE);
          //CurrForm."Assessment Amount".VISIBLE(FALSE);
          CurrForm."Rule 1".VISIBLE(FALSE);
          CurrForm."And Value 1".VISIBLE(FALSE);
          CurrForm."And Value 2".VISIBLE(FALSE);
          CurrForm."Rule 2".VISIBLE(FALSE);
          CurrForm."Operation 1".VISIBLE(FALSE);
          CurrForm."Operation 2".VISIBLE(FALSE);
        END ELSE BEGIN
          CurrForm."Characterise Subjects".VISIBLE(TRUE);
          //CurrForm."Assessment Amount".VISIBLE(TRUE);
          CurrForm."Rule 1".VISIBLE(TRUE);
          CurrForm."And Value 1".VISIBLE(TRUE);
          CurrForm."And Value 2".VISIBLE(TRUE);
          CurrForm."Rule 2".VISIBLE(TRUE);
          CurrForm."Operation 1".VISIBLE(TRUE);
          CurrForm."Operation 2".VISIBLE(TRUE);
        
        END;
        */

    end;
}

#pragma implicitwith restore

