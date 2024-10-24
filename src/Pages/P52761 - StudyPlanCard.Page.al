#pragma implicitwith disable
page 52761 "Study Plan Card"
{
    Caption = 'Study Plan Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Study Plan Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CodeEditable;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DescriptionEditable;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School YearEditable";

                    trigger OnValidate()
                    begin
                        SchoolYearOnAfterValidate;
                    end;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = "Schooling YearEditable";

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Responsibility CenterEditable";
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Blocked';
                }
                field("Sub-subjects for assess. only"; Rec."Sub-subjects for assess. only")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Legal)
            {
                Caption = 'Legal';
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Description"; Rec."Study Plan Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SubForm; "Study Plan lines")
            {
                ApplicationArea = All;
                Editable = SubFormEditable;
                SubPageLink = Code = FIELD(Code),
                              "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Study Plan")
            {
                Caption = '&Study Plan';
                Visible = bt2Visible;
                action("&List")
                {
                    ApplicationArea = All;
                    Caption = '&List';
                    Image = List;
                    RunObject = Page "Study Plan List";
                }
                action("Assess&ment Configuration")
                {
                    ApplicationArea = All;
                    Caption = 'Assess&ment Configuration';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Assessment Configuration";
                    RunPageLink = "School Year" = FIELD("School Year"),
                                  "Study Plan Code" = FIELD(Code),
                                  "Country/Region Code" = FIELD("Country/Region Code");
                    RunPageView = SORTING("School Year", Type, "Study Plan Code", "Country/Region Code")
                                  WHERE(Type = CONST(Simple));
                }
            }
        }
        area(processing)
        {
            group(Action1000000017)
            {
                Caption = '&Study Plan';
                Image = Planning;
                Visible = bt2Visible;
                action("Config all Study Plan")
                {
                    ApplicationArea = All;
                    Caption = 'Config all Study Plan';
                    Image = TaxSetup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.SubForm.PAGE.OpenConfigurationSP;
                    end;
                }
                action("&Copy")
                {
                    ApplicationArea = All;
                    Caption = '&Copy';
                    Image = Copy;

                    trigger OnAction()
                    var
                        RepCopyStudyPlan: Report "Copy Study Plan";
                    begin

                        RepCopyStudyPlan.GetStudyPlanNo(Rec.Code, Rec."Responsibility Center");
                        RepCopyStudyPlan.RunModal;
                        Clear(RepCopyStudyPlan);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableSchoolYear;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        SubFormEditable := true;
        "Maximum Total AbsenceEditable" := true;
        MaximumUnjustifiedAbsenceEdita := true;
        "Responsibility CenterEditable" := true;
        DescriptionEditable := true;
        CodeEditable := true;
        bt2Visible := true;
        bt1Visible := true;
        "Maximum Total AbsenceVisible" := true;
        txtM2Visible := true;
        MaximumUnjustifiedAbsenceVisib := true;
        txtM1Visible := true;
        "School YearEditable" := true;
        "Schooling YearEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Schooling YearEditable" := true;
        "School YearEditable" := true;
        OnAfterGetCurrRecord2;
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        [InDataSet]
        "Schooling YearEditable": Boolean;
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        txtM1Visible: Boolean;
        [InDataSet]
        MaximumUnjustifiedAbsenceVisib: Boolean;
        [InDataSet]
        txtM2Visible: Boolean;
        [InDataSet]
        "Maximum Total AbsenceVisible": Boolean;
        [InDataSet]
        bt1Visible: Boolean;
        [InDataSet]
        bt2Visible: Boolean;
        [InDataSet]
        CodeEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        MaximumUnjustifiedAbsenceEdita: Boolean;
        [InDataSet]
        "Maximum Total AbsenceEditable": Boolean;
        [InDataSet]
        SubFormEditable: Boolean;


    procedure VisibleFields()
    var
        rStructureEducationCountry: Record "Structure Education Country";
    begin
        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange(Country, Rec."Country/Region Code");
        rStructureEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
        if rStructureEducationCountry.Find('-') then begin
            if rStructureEducationCountry."Absence Type" = rStructureEducationCountry."Absence Type"::Daily then begin
                txtM1Visible := true;
                MaximumUnjustifiedAbsenceVisib := true;
                txtM2Visible := true;
                "Maximum Total AbsenceVisible" := true;
            end else begin
                txtM1Visible := false;
                MaximumUnjustifiedAbsenceVisib := false;
                txtM2Visible := false;
                "Maximum Total AbsenceVisible" := false;
            end;
        end;
    end;


    procedure EditableSchoolYear()
    var
        l_SchoolYear: Record "School Year";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetRange("School Year", Rec."School Year");
        if l_SchoolYear.FindFirst then begin
            if (l_SchoolYear.Status = l_SchoolYear.Status::Closing) or (l_SchoolYear.Status = l_SchoolYear.Status::Closed) then begin
                CodeEditable := false;
                DescriptionEditable := false;
                "Schooling YearEditable" := false;
                "School YearEditable" := false;
                "Responsibility CenterEditable" := false;
                MaximumUnjustifiedAbsenceEdita := false;
                "Maximum Total AbsenceEditable" := false;
                SubFormEditable := false;
                bt1Visible := false;
                bt2Visible := true;
            end else begin
                CodeEditable := true;
                DescriptionEditable := true;
                "Schooling YearEditable" := true;
                "School YearEditable" := true;
                "Responsibility CenterEditable" := true;
                MaximumUnjustifiedAbsenceEdita := true;
                "Maximum Total AbsenceEditable" := true;
                SubFormEditable := true;
                bt1Visible := true;
                bt2Visible := false;


            end;
        end;
    end;

    local procedure SchoolingYearOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SchoolYearOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        VisibleFields;
    end;
}

#pragma implicitwith restore

