#pragma implicitwith disable
page 52950 "Assessment Configuration"
{
    Caption = 'Assessment Configuration';
    PageType = Card;
    SourceTable = "Assessment Configuration";

    layout
    {
        area(content)
        {
            group(Periodic)
            {
                Caption = 'Periodic';
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School YearEditable";
                }
                field("PA Subject Round Method"; Rec."PA Subject Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Group Sub. Classification"; Rec."PA Group Sub. Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Group Sub. Round Method"; Rec."PA Group Sub. Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Final Classification"; Rec."PA Final Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Final Round Method"; Rec."PA Final Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Evaluation Type"; Rec."PA Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PA Assessment Code"; Rec."PA Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Final Year")
            {
                Caption = 'Final Year';
                field("FY Sub Subjects Classification"; Rec."FY Sub Subjects Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("FY Sub Subject Round Method"; Rec."FY Sub Subject Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("FY Subjects Classification"; Rec."FY Subjects Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("FY Subject Round Method"; Rec."FY Subject Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("FY Group Sub. Classification"; Rec."FY Group Sub. Classification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("FY Group Sub. Round Method"; Rec."FY Group Sub. Round Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Level Group"; Rec."Level Group")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rRulesofEvaluations2: Record "Rules of Evaluations";
                        l_rRulesofEvaluations: Record "Rules of Evaluations";
                        l_StructureEduCountry: Record "Structure Education Country";
                        l_StructureEduCountry2: Record "Structure Education Country";
                        l_fRulesofEvaluation: Page "Rules of Evaluation Subform";
                    begin

                        l_fRulesofEvaluation.LookupMode(true);

                        if Rec.Type = Rec.Type::Simple then begin
                            if l_StudyPlanHeader.Get(Rec."Study Plan Code") then
                                l_rRulesofEvaluations.Reset;
                            l_rRulesofEvaluations.SetRange("Schooling Year", l_StudyPlanHeader."Schooling Year");
                            l_rRulesofEvaluations.SetRange("Study Plan Code", '');
                            l_fRulesofEvaluation.SetTableView(l_rRulesofEvaluations);
                            l_fRulesofEvaluation.RunModal;
                            l_fRulesofEvaluation.GetRecord(l_rRulesofEvaluations);
                            Rec."Level Group" := l_rRulesofEvaluations."Level Group";
                            if Rec.Modify(true) and Rec."Use Evaluation Rules" then begin
                                Rec.DeleteRules;
                                Rec.InsertRules;
                            end;
                        end else begin
                            if l_CourseHeader.Get(Rec."Study Plan Code") then
                                l_StructureEduCountry.Reset;
                            l_StructureEduCountry.SetRange("Schooling Year", l_CourseHeader."Schooling Year Begin");
                            if l_StructureEduCountry.FindFirst then begin
                                l_rRulesofEvaluations.Reset;
                                l_rRulesofEvaluations.SetRange("Edu. Level", l_StructureEduCountry."Edu. Level");
                                l_rRulesofEvaluations.SetRange("Study Plan Code", '');
                                if l_rRulesofEvaluations.FindSet then begin
                                    l_fRulesofEvaluation.SetTableView(l_rRulesofEvaluations);
                                    l_fRulesofEvaluation.RunModal;
                                    l_fRulesofEvaluation.GetRecord(l_rRulesofEvaluations);
                                    Rec."Level Group" := l_rRulesofEvaluations."Level Group";
                                    if Rec.Modify(true) and Rec."Use Evaluation Rules" then begin
                                        Rec.DeleteRules;
                                        Rec.InsertRules;
                                    end;
                                end;
                            end;
                        end;
                        CurrPage.Update;
                        CurrPage.RulesSubform.PAGE.UpdateForm;
                    end;
                }
                field("Use Evaluation Rules"; Rec."Use Evaluation Rules")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        UseEvaluationRulesOnPush;
                    end;
                }
            }
            group("Regras de Avaliação")
            {
                Caption = 'Regras de Avaliação';
                part(RulesSubform; "Rules of Evaluation Subform")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "School Year" = FIELD("School Year"),
                                  "Study Plan Code" = FIELD("Study Plan Code"),
                                  Type = FIELD(Type),
                                  "Level Group" = FIELD("Level Group");
                    Visible = RulesSubformVisible;
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field("FY Final Classification"; Rec."FY Final Classification")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        "FY Final Round MethodVisible" := true;
                        "FY Evaluation TypeVisible" := true;
                        "FY Assessment CodeVisible" := true;
                    end;
                }
                field("FY Final Round Method"; Rec."FY Final Round Method")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "FY Final Round MethodVisible";
                }
                field("FY Evaluation Type"; Rec."FY Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "FY Evaluation TypeVisible";
                }
                field("FY Assessment Code"; Rec."FY Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "FY Assessment CodeVisible";
                }
            }
            group(Annotation)
            {
                Caption = 'Annotation';
                field("Annotation Code"; Rec."Annotation Code")
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
            action("&Legal")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Legal';
                Image = VoucherDescription;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    rRulesEvaluations: Record "Rules of Evaluations";
                    fRulesEvaluation: Page "Rules of Evaluation";
                begin
                    rRulesEvaluations.Reset;
                    rRulesEvaluations.FilterGroup(2);
                    rRulesEvaluations.SetRange(Type, Rec.Type);
                    rRulesEvaluations.SetRange("Study Plan Code", Rec."Study Plan Code");
                    rRulesEvaluations.FilterGroup(0);

                    fRulesEvaluation.GetInfo(Rec.Type, Rec."Study Plan Code");
                    fRulesEvaluation.SetTableView(rRulesEvaluations);
                    fRulesEvaluation.RunModal;

                    Error(Text0001, Rec.FieldCaption("FY Final Classification"));
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Use Evaluation Rules" then begin
            RulesSubformVisible := true;
        end else begin
            RulesSubformVisible := false;
        end;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        TransitionRulesSubformVisible := true;
        "FY Assessment CodeVisible" := true;
        "FY Evaluation TypeVisible" := true;
        "FY Final Round MethodVisible" := true;
        "School YearEditable" := true;
        RulesSubformVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    var
        Text0001: Label 'To use this option the field %1 must be Legal.';
        l_StudyPlanHeader: Record "Study Plan Header";
        l_CourseHeader: Record "Course Header";
        [InDataSet]
        RulesSubformVisible: Boolean;
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        "FY Final Round MethodVisible": Boolean;
        [InDataSet]
        "FY Evaluation TypeVisible": Boolean;
        [InDataSet]
        "FY Assessment CodeVisible": Boolean;
        [InDataSet]
        TransitionRulesSubformVisible: Boolean;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        if Rec.Type = Rec.Type::Simple then
            "School YearEditable" := false
        else
            "School YearEditable" := true;
    end;

    local procedure UseEvaluationRulesOnPush()
    begin
        if Rec."Use Evaluation Rules" then begin
            CurrPage.LookupMode(false);
            RulesSubformVisible := true;
        end else begin
            CurrPage.LookupMode(false);
            RulesSubformVisible := false;
        end;
    end;
}

#pragma implicitwith restore

