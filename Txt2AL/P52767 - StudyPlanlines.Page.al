#pragma implicitwith disable
page 52767 "Study Plan lines"
{
    // IT001 - ET:Novo campo "Calculo Transicao Ano" - para o portal  - HG 2016.04.08
    // 
    // IT002 - EDU - Adicionado novo campo: "Biographic Record Excluded"

    Caption = 'Study Plan lines';
    PageType = ListPart;
    SourceTable = "Study Plan Lines";
    SourceTableView = SORTING(Code, "School Year", "Schooling Year", "Curriculum Type");

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
                field("Report Descripton"; Rec."Report Descripton")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Option Group"; Rec."Option Group")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject Group';
                }
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Excluded From Assess."; Rec."Subject Excluded From Assess.")
                {
                    ApplicationArea = Basic, Suite;
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
                }
                field("Legal Code Description"; Rec."Legal Code Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Legal Exam Code"; Rec."Legal Exam Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Maximum Unjustified Absences"; Rec."Maximum Unjustified Absences")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = MaximumUnjustifiedAbsencesVisi;
                }
                field("Maximum Total Absence"; Rec."Maximum Total Absence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Weighting; Rec.Weighting)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Legal Reports Sorting ID"; Rec."Legal Reports Sorting ID")
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
            group("Funções")
            {
                Caption = 'Funções';
                action("S&ub-Subjects Configuration")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'S&ub-Subjects Configuration';
                    Image = QuestionaireSetup;

                    trigger OnAction()
                    var
                        rStudyPlanLines: Record "Study Plan Lines";
                        rSPSubSubLines: Record "Study Plan Sub-Subjects Lines";
                        fStudyPlanSubSubjectsLines: Page "Study Plan Sub-Subjects Lines";
                    begin

                        rSPSubSubLines.Reset;
                        rSPSubSubLines.SetRange(Type, rSPSubSubLines.Type::"Study Plan");
                        rSPSubSubLines.SetRange(Code, Rec.Code);
                        rSPSubSubLines.SetRange("Schooling Year", Rec."Schooling Year");
                        rSPSubSubLines.SetRange("Subject Code", Rec."Subject Code");

                        rSPSubSubLines.FilterGroup(2);
                        fStudyPlanSubSubjectsLines.SetTableView(rSPSubSubLines);
                        fStudyPlanSubSubjectsLines.RunModal;
                    end;
                }
                action("&All Setting Ratings/Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&All Setting Ratings/Aspects';
                    Image = SetupList;

                    trigger OnAction()
                    begin
                        OpenConfigurationAll;
                    end;
                }
                action("S&etting Ratings/Aspects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'S&etting Ratings/Aspects';
                    Image = ValidateEmailLoggingSetup;

                    trigger OnAction()
                    begin

                        OpenConfiguration;
                        //Normatica 2013.11.29 - desactivei esta opção porque deixou de fazer sentido a partir do momento em que na
                        //configuração das sub-disciplinas temos o campo a indicar se é Intercalar ou Final
                    end;
                }
                action("&Insert new subjects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Insert new subjects';
                    Image = NewDocument;

                    trigger OnAction()
                    var
                        cStudentsRegistration: Codeunit "Students Registration";
                        l_StudyPlanLines: Record "Study Plan Lines";
                    begin


                        cStudentsRegistration.UpdateSubjectStudyPlan(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        VisibleFields;
    end;

    trigger OnInit()
    begin
        "Maximum Total AbsenceVisible" := true;
        MaximumUnjustifiedAbsencesVisi := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(Code, "School Year", "Schooling Year", "Sorting ID");
    end;

    var
        StudyPlanHeader: Record "Study Plan Header";
        rUserSetup: Record "User Setup";
        cStudentsRegistration: Codeunit "Students Registration";
        Text001: Label 'This option is not avaliable. Subject evaluation type: None Qualification. ';
        [InDataSet]
        MaximumUnjustifiedAbsencesVisi: Boolean;
        [InDataSet]
        "Maximum Total AbsenceVisible": Boolean;

    //[Scope('OnPrem')]
    procedure OpenConfiguration()
    begin
        if Rec."Evaluation Type" = Rec."Evaluation Type"::"None Qualification" then
            Error(Text001)
        else
            Rec.OpenCreateAssessmentConf();
    end;

    //[Scope('OnPrem')]
    procedure OpenConfigurationAll()
    begin
        if Rec."Evaluation Type" = Rec."Evaluation Type"::"None Qualification" then
            Error(Text001)
        else
            rec.CreateAssessmentConfAll();
    end;

    //[Scope('OnPrem')]
    procedure VisibleFields()
    var
        rStructureEducCountry: Record "Structure Education Country";
        vShow: Boolean;
    begin
        rStructureEducCountry.Reset;
        rStructureEducCountry.SetRange(Country, Rec."Country/Region Code");
        rStructureEducCountry.SetRange("Schooling Year", Rec."Schooling Year");
        if rStructureEducCountry.Find('-') then begin
            if rStructureEducCountry."Absence Type" = rStructureEducCountry."Absence Type"::Lecture then begin
                MaximumUnjustifiedAbsencesVisi := true;
                "Maximum Total AbsenceVisible" := true;
            end else begin
                MaximumUnjustifiedAbsencesVisi := false;
                "Maximum Total AbsenceVisible" := false;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure OpenConfigurationSP()
    begin
        Rec.CreateAssessmentConfStudyPlan;
    end;
}

#pragma implicitwith restore

