#pragma implicitwith disable
page 31009843 Incidences
{
    Caption = 'Incidences';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Incidence Type";
    SourceTableView = SORTING("School Year", "Schooling Year", Category, "Subcategory Code", "Incidence Code", "Justification Code", "Responsibility Center")
                      ORDER(Ascending)
                      WHERE("Absence Status" = FILTER(<> Justification));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VarSchoolYear; VarSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));

                    trigger OnValidate()
                    begin
                        VarSchoolYearOnAfterValidate;
                    end;
                }
                field(varCategory; varCategory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category';
                    OptionCaption = 'Class,Cantina,BUS,Schoolyard,Extra-scholar,Teacher,All';

                    trigger OnValidate()
                    begin
                        Filter;
                        varCategoryOnAfterValidate;
                    end;
                }
                field(controlvarSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = controlvarSchoolingYearEditabl;
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin
                        varSchoolingYearOnAfterValidat;
                    end;
                }
            }
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subcategory Code"; Rec."Subcategory Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subcategory Description"; Rec."Subcategory Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Incidence Type"; Rec."Incidence Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Delay; Rec.Delay)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = DelayVisible;
                }
                field("Legal/Attendance"; Rec."Legal/Attendance")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Legal/AttendanceVisible";
                }
                field("Absence Status"; Rec."Absence Status")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Justified,Unjustified';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Corresponding Code"; Rec."Corresponding Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Corresponding CodeVisible";
                }
                field("Correspondig Code Description"; Rec."Correspondig Code Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = CorrespondigCodeDescriptionVis;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SubFormIncidence; "Absence Config.")
            {
                Caption = 'Justificações';
                Editable = SubFormIncidenceEditable;
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year"),
                              Category = FIELD(Category),
                              "Subcategory Code" = FIELD("Subcategory Code"),
                              "Incidence Code" = FIELD("Incidence Code"),
                              "Absence Status" = FILTER(Justification);
            }
        }
    }

    actions
    {
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

                    trigger OnAction()
                    var
                        RepCopyIncidences: Report "Copy Incidences";
                    begin
                        RepCopyIncidences.GetIncidences(Rec."Schooling Year", Rec."School Year", Rec."Responsibility Center");
                        RepCopyIncidences.RunModal;
                        Clear(RepCopyIncidences);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Absence Status" = Rec."Absence Status"::Justified then
            SubFormIncidenceEditable := false
        else
            SubFormIncidenceEditable := true;
    end;

    trigger OnInit()
    begin
        CorrespondigCodeDescriptionVis := true;
        "Corresponding CodeVisible" := true;
        "Legal/AttendanceVisible" := true;
        DelayVisible := true;
        SubFormIncidenceEditable := true;
        controlvarSchoolingYearEditabl := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if VarSchoolYear = '' then
            Error(text001);

        if (varSchoolingYear = '') and (varCategory <> varCategory::Teacher) then
            Error(text002);

        if ((varSchoolingYear = '') and (varCategory = varCategory::All)) then
            Error(text003);

        if (Rec.Category = Rec.Category::Teacher) and (varSchoolingYear <> '') and (varCategory = varCategory::All) then
            Error(text003);
    end;

    trigger OnOpenPage()
    begin
        VarSchoolYear := Rec.GetSchoolYear;
        varCategory := varCategory::All;
        Rec.SetRange("School Year", VarSchoolYear);
        Rec.SetRange("Schooling Year", varSchoolingYear);
        Rec.SetRange(Category);
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        VarSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        text001: Label 'Please insert the school year.';
        text002: Label 'Please insert the schooling year in the tab general.';
        varCategory: Option Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher,All;
        text003: Label 'Please choose a incidence category on the header.';
        text004: Label 'Please set the Category different from teacher or all.';
        cUserEducation: Codeunit "User Education";
        [InDataSet]
        controlvarSchoolingYearEditabl: Boolean;
        [InDataSet]
        SubFormIncidenceEditable: Boolean;
        [InDataSet]
        DelayVisible: Boolean;
        [InDataSet]
        "Legal/AttendanceVisible": Boolean;
        [InDataSet]
        "Corresponding CodeVisible": Boolean;
        [InDataSet]
        CorrespondigCodeDescriptionVis: Boolean;

    //[Scope('OnPrem')]
    procedure "Filter"()
    begin

        DelayVisible := true;
        "Legal/AttendanceVisible" := true;
        "Corresponding CodeVisible" := true;
        CorrespondigCodeDescriptionVis := true;


        if (varCategory = varCategory::BUS) or (varCategory = varCategory::Schoolyard) or (varCategory = varCategory::Cantine) or
          (varCategory = varCategory::"Extra-scholar") then begin
            DelayVisible := false;
            "Legal/AttendanceVisible" := false;
            "Corresponding CodeVisible" := false;
            CorrespondigCodeDescriptionVis := false;
        end;
    end;

    local procedure VarSchoolYearOnAfterValidate()
    begin
        Rec.SetRange("School Year", VarSchoolYear);
        CurrPage.Update(false);
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin

        Rec.SetRange("Schooling Year", varSchoolingYear);

        CurrPage.Update(false);
    end;

    local procedure varCategoryOnAfterValidate()
    begin
        if varCategory = varCategory::All then
            Rec.SetRange(Category)
        else
            Rec.SetRange(Category, varCategory);

        controlvarSchoolingYearEditabl := true;
        if varCategory = varCategory::Teacher then begin
            varSchoolingYear := '';
            controlvarSchoolingYearEditabl := false;
        end;

        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

