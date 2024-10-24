#pragma implicitwith disable
page 52867 "Course Lines"
{
    AutoSplitKey = true;
    Caption = 'Course Lines';
    PageType = ListPart;
    SourceTable = "Course Lines";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Formation Component"; Rec."Formation Component")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Characterise Subjects"; Rec."Characterise Subjects")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year Begin"; Rec."Schooling Year Begin")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Schooling Year BeginEditable";
                }
                field("Option Group"; Rec."Option Group")
                {
                    ApplicationArea = Basic, Suite;
                    TableRelation = "Course Lines";
                }
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Curriculum Type"; Rec."Curriculum Type")
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
                field("Subject Excluded From Assess."; Rec."Subject Excluded From Assess.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject Excluded From Assessment';
                }
                field("Exam Last Year"; Rec."Exam Last Year")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Minimum Classification Level"; Rec."Minimum Classification Level")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject"; Rec."Sub-Subject")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Legal Code"; Rec."Legal Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Legal Code';
                }
                field(Credits; Rec.Credits)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Maximum Unjustified Absences"; Rec."Maximum Unjustified Absences")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = MaximumUnjustifiedAbsencesVisi;
                }
                field("Maximum Total Absences"; Rec."Maximum Total Absences")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Maximum Total AbsencesVisible";
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Weighting; Rec.Weighting)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Disciplinary Area Code"; Rec."Disciplinary Area Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Disciplinary Area Description"; Rec."Disciplinary Area Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Subjects)
            {
                Caption = 'Subjects';
                Image = UserInterface;
                action("S&ub-Subjects Configuration")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'S&ub-Subjects Configuration';
                    Image = JournalSetup;

                    trigger OnAction()
                    var
                        rCourseLines: Record "Course Lines";
                        rSPSubSubLines: Record "Study Plan Sub-Subjects Lines";
                        fStudyPlanSubSubjectsLines: Page "Study Plan Sub-Subjects Lines";
                    begin
                        rCourseLines.Reset;
                        CurrPage.GetRecord(rCourseLines);


                        rSPSubSubLines.Reset;
                        rSPSubSubLines.SetRange(Type, rSPSubSubLines.Type::Course);
                        rSPSubSubLines.SetRange(Code, Rec.Code);
                        rSPSubSubLines.SetRange("Subject Code", rCourseLines."Subject Code");
                        rSPSubSubLines.SetRange("Line No.", rCourseLines."Line No.");


                        fStudyPlanSubSubjectsLines.GetLineNo(rCourseLines."Line No.");

                        rSPSubSubLines.FilterGroup(2);
                        fStudyPlanSubSubjectsLines.SetTableView(rSPSubSubLines);
                        fStudyPlanSubSubjectsLines.RunModal;
                    end;
                }
                action("&All Setting Ratings/Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&All Setting Ratings/Aspects';
                    Image = JobListSetup;

                    trigger OnAction()
                    begin
                        OpenConfigurationAll;
                    end;
                }
                action("&Setting Ratings/Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Setting Ratings/Aspects';
                    Image = GeneralPostingSetup;

                    trigger OnAction()
                    begin
                        OpenConfiguration;
                    end;
                }
                action("&Insert new subjects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Insert new subjects';
                    Image = InsertFromCheckJournal;

                    trigger OnAction()
                    begin
                        UpdateSubject2;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        VisibleFields;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        "Schooling Year BeginEditable" := true;
        "Maximum Total AbsencesVisible" := true;
        MaximumUnjustifiedAbsencesVisi := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Sorting ID");
    end;

    var
        rCourseHeader: Record "Course Header";
        Text001: Label 'This option is not avaliable. Subject evaluation type: No Qualification. ';
        [InDataSet]
        MaximumUnjustifiedAbsencesVisi: Boolean;
        [InDataSet]
        "Maximum Total AbsencesVisible": Boolean;
        [InDataSet]
        "Schooling Year BeginEditable": Boolean;


    procedure SchoolingYearEditable()
    var
        rEduConfiguration: Record "Edu. Configuration";
    begin
        if Rec."Characterise Subjects" = Rec."Characterise Subjects"::Quadriennal then
            "Schooling Year BeginEditable" := false
        else
            "Schooling Year BeginEditable" := true;

        /*//Para Portugal isto não faz sentido
        rEduConfiguration.GET;
        IF rEduConfiguration."Use Formation Component" THEN BEGIN
          CurrForm."Mandatory/Optional Type".VISIBLE(FALSE);
          CurrForm."Formation Component".VISIBLE(TRUE);
        END ELSE BEGIN
          CurrForm."Mandatory/Optional Type".VISIBLE(TRUE);
          CurrForm."Formation Component".VISIBLE(FALSE);
        END;
        */

    end;


    procedure OpenConfiguration()
    begin
        if Rec."Evaluation Type" = Rec."Evaluation Type"::"None Qualification" then
            Error(Text001)
        else
            Rec.OpenCreateAssessmentConf;
    end;


    procedure OpenConfigurationAll()
    begin
        if Rec."Evaluation Type" = Rec."Evaluation Type"::"None Qualification" then
            Error(Text001)
        else
            Rec.CreateAssessmentConfAll;
    end;


    procedure UpdateSubject2()
    begin
        Rec.UpdateSubject
    end;


    procedure VisibleFields()
    var
        rStructureEducCountry: Record "Structure Education Country";
        vShow: Boolean;
    begin
        if rCourseHeader.Get(Rec.Code) then;
        rStructureEducCountry.Reset;
        rStructureEducCountry.SetRange(Country, Rec."Country/Region Code");
        rStructureEducCountry.SetRange("Schooling Year", rCourseHeader."Schooling Year Begin");
        if rStructureEducCountry.FindFirst then begin
            if rStructureEducCountry."Absence Type" = rStructureEducCountry."Absence Type"::Lecture then begin
                MaximumUnjustifiedAbsencesVisi := true;
                "Maximum Total AbsencesVisible" := true;
            end else begin
                MaximumUnjustifiedAbsencesVisi := false;
                "Maximum Total AbsencesVisible" := false;
            end;
        end;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        SchoolingYearEditable;
    end;
}

#pragma implicitwith restore

