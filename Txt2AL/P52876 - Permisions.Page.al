#pragma implicitwith disable
page 52876 Permisions
{
    AutoSplitKey = true;
    Caption = 'Permissions';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Teacher Class";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning | Closing));

                    trigger OnValidate()
                    begin
                        varSchoolYearOnAfterValidate;
                    end;
                }
                field(varUserType; varUserType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Type';
                    OptionCaption = ' ,Teacher,Employee';

                    trigger OnValidate()
                    begin
                        varUserTypeOnAfterValidate;
                    end;
                }
                field(txtSubjectType1; varSubjectType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject Type';
                    OptionCaption = ' ,Subject,,Non scholar hours';

                    trigger OnValidate()
                    begin
                        varSubjectTypeOnAfterValidate;
                    end;
                }
                field(varSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin
                        varSchoolingYearOnAfterValidat;
                    end;
                }
                field(txtClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    Enabled = txtClassEnable;
                    TableRelation = Class.Class;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rClass: Record Class;
                    begin
                        rClass.Reset;
                        if varSchoolYear <> '' then
                            rClass.SetRange(rClass."School Year", varSchoolYear);
                        if varSchoolingYear <> '' then
                            rClass.SetRange(rClass."Schooling Year", varSchoolingYear);
                        if rClass.FindSet then
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                varClass := rClass.Class;
                                if varSchoolingYear = '' then begin
                                    varSchoolingYear := rClass."Schooling Year";
                                    Rec.FilterGroup(2);
                                    Rec.SetRange("Schooling Year", varSchoolingYear);
                                    Rec.FilterGroup(0);
                                    "Schooling YearEnable" := false;
                                end;

                                if varClass <> '' then begin
                                    Rec.FilterGroup(2);
                                    Rec.SetRange(Class, varClass);
                                    Rec.FilterGroup(0);
                                    ClassEnable := false;
                                end else begin
                                    Rec.FilterGroup(2);
                                    Rec.SetRange(Class);
                                    Rec.FilterGroup(0);
                                    ClassEnable := true;
                                end;

                                CurrPage.Update(false);
                            end;
                    end;

                    trigger OnValidate()
                    begin
                        varClassOnAfterValidate;
                    end;
                }
                field(varUser; varUser)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTeacher: Record Teacher;
                    begin
                        if varUserType <> 0 then begin
                            if varUserType = varUserType::Teacher then begin
                                rTeacher.Reset;
                                if PAGE.RunModal(PAGE::"Teacher List", rTeacher) = ACTION::LookupOK then begin
                                    varUser := rTeacher."No.";
                                    if varUser <> '' then begin
                                        Rec.FilterGroup(2);
                                        Rec.SetRange(User, varUser);
                                        Rec.FilterGroup(0);
                                        UserEnable := false;
                                    end else begin
                                        Rec.FilterGroup(2);
                                        Rec.SetRange(User);
                                        Rec.FilterGroup(0);
                                        UserEnable := true;
                                    end;
                                    CurrPage.Update(false);
                                end;
                            end;
                            /*IF varUserType= varUserType::Employee THEN BEGIN
                              rEmployee.RESET;
                              IF PAGE.RUNMODAL(PAGE::Page31003036,rEmployee) = ACTION::LookupOK THEN BEGIN
                                varUser := rEmployee."No.";
                                IF varUser <> '' THEN BEGIN
                                  FILTERGROUP(2);
                                  SETRANGE(User,varUser);
                                  FILTERGROUP(0);
                                END ELSE BEGIN
                                  FILTERGROUP(2);
                                  SETRANGE(User);
                                  FILTERGROUP(0);
                                END;
                                CurrPage.UPDATE(FALSE);
                              END;
                            END;*/

                        end else
                            Error(Text0001);

                    end;

                    trigger OnValidate()
                    begin
                        varUserOnAfterValidate;
                    end;
                }
            }
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("User Type"; Rec."User Type")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = "User TypeEnable";
                }
                field(User; Rec.User)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = UserEnable;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = "School YearEnable";
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = "Schooling YearEnable";
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = ClassEnable;
                }
                field("Type Subject"; Rec."Type Subject")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = "Type SubjectEnable";
                    OptionCaption = ' ,Subject,,Non scholar hours';
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = "Sub-Subject CodeEnable";
                }
                field("Sub-Subject Description"; Rec."Sub-Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Assign Evaluations"; Rec."Allow Assign Evaluations")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AllowAssignEvaluationsEditable;
                }
                field("Allow Calc. Final Assess."; Rec."Allow Calc. Final Assess.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AllowCalcFinalAssessEditable;
                }
                field("Allow Stu. Global Observations"; Rec."Allow Stu. Global Observations")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AllowStuGlobalObservationsEdit;
                }
                field("Allow Assign Incidence"; Rec."Allow Assign Incidence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Justify Incidence"; Rec."Allow Justify Incidence")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Summary"; Rec."Allow Summary")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Allow SummaryEditable";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Type SubjectEnable" := true;
        "Sub-Subject CodeEnable" := true;
        txtClassEnable := true;
        "Allow SummaryEditable" := true;
        AllowStuGlobalObservationsEdit := true;
        AllowCalcFinalAssessEditable := true;
        AllowAssignEvaluationsEditable := true;
        "Schooling YearEnable" := true;
        ClassEnable := true;
        "User TypeEnable" := true;
        UserEnable := true;
        "School YearEnable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        rTeacher: Record Teacher;
    begin

        Rec."School Year" := varSchoolYear;
        if varUserType <> 0 then Rec."User Type" := varUserType - 1;
        Rec."Type Subject" := varSubjectType;
        Rec."Schooling Year" := varSchoolingYear;
        Rec.Class := varClass;
        if varUser <> '' then begin
            if varUserType = varUserType::Teacher then begin
                if rTeacher.Get(varUser) then begin
                    Rec.User := rTeacher."No.";
                    Rec."Full Name" := rTeacher.Name;
                    Rec."NAV User Id" := rTeacher."NAV User Id";
                    Rec."Responsibility Center" := rTeacher."Responsibility Center";
                    Rec."Last Name" := rTeacher."Last Name";
                    Rec."Last Name 2" := rTeacher."Last Name 2";
                    Rec."User Name" := rTeacher."User Name";
                    Rec.Password := rTeacher.Password;
                    Rec."Use GIC" := rTeacher."Use GIC";
                    Rec."Use WEB" := rTeacher."Use WEB";
                    Rec.Name := rTeacher.Name;
                end;
            end;
            /*IF varUserType = varUserType::Employee THEN BEGIN
              IF rEmployee.GET(varUser) THEN BEGIN
                User := rEmployee."No.";
                "Full Name" := rEmployee.Name;
                "NAV User Id" := rEmployee."NAV User Id";
                "Responsibility Center" := rEmployee."Responsibility Center";
                "Last Name" := rEmployee."Last Name";
                "User Name" := rEmployee."User Name";
                Password := rEmployee.Password;
                "Use GIC" := rEmployee."Use GIC";
                "Use WEB" := rEmployee."Use WEB";
                Name :=  rEmployee."First Name";
              END;
            END;*/

        end;

    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        varSchoolYear := Rec.GetSchoolYear;
        if varSchoolYear <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("School Year", varSchoolYear);
            Rec.FilterGroup(0);
            "School YearEnable" := false;
        end;
    end;

    var
        varSchoolYear: Code[9];
        varUserType: Option " ",Teacher,Employee;
        varSubjectType: Option " ",Subject,"Non lective Component","Non scholar hours";
        varSchoolingYear: Code[10];
        varClass: Code[20];
        varUser: Code[20];
        Text0001: Label 'Please, choose the User Type.';
        Text0002: Label 'The %1 field cannot be altered by the User.';
        [InDataSet]
        "School YearEnable": Boolean;
        [InDataSet]
        UserEnable: Boolean;
        [InDataSet]
        "User TypeEnable": Boolean;
        [InDataSet]
        ClassEnable: Boolean;
        [InDataSet]
        "Schooling YearEnable": Boolean;
        [InDataSet]
        AllowAssignEvaluationsEditable: Boolean;
        [InDataSet]
        AllowCalcFinalAssessEditable: Boolean;
        [InDataSet]
        AllowStuGlobalObservationsEdit: Boolean;
        [InDataSet]
        "Allow SummaryEditable": Boolean;
        [InDataSet]
        txtClassEnable: Boolean;
        [InDataSet]
        "Sub-Subject CodeEnable": Boolean;
        [InDataSet]
        "Type SubjectEnable": Boolean;

    local procedure varSchoolYearOnAfterValidate()
    begin
        if varSchoolYear <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("School Year", varSchoolYear);
            Rec.FilterGroup(0);
            "School YearEnable" := false;
        end else begin
            Rec.FilterGroup(2);
            Rec.SetRange("School Year");
            Rec.FilterGroup(0);
            "School YearEnable" := true;
        end;
        CurrPage.Update(false);
    end;

    local procedure varUserTypeOnAfterValidate()
    begin
        if varUserType <> 0 then begin
            if varUser <> '' then begin
                varUser := '';
                Rec.FilterGroup(2);
                Rec.SetRange(User);
                Rec.FilterGroup(0);
                UserEnable := true;

            end;
            if varUserType = varUserType::Teacher then begin
                Rec.FilterGroup(2);
                Rec.SetRange("User Type", Rec."User Type"::Teacher);
                Rec.FilterGroup(0);
            end else begin
                Rec.FilterGroup(2);
                Rec.SetRange("User Type", Rec."User Type"::Employee);
                Rec.FilterGroup(0);
            end;
            "User TypeEnable" := false;
        end else begin
            Rec.FilterGroup(2);
            Rec.SetRange("User Type");
            Rec.FilterGroup(0);
            "User TypeEnable" := true;
        end;

        CurrPage.Update(false);
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin
        if varSchoolingYear <> '' then begin
            if varClass <> '' then begin

                varClass := '';
                Rec.FilterGroup(2);
                Rec.SetRange(Class);
                Rec.FilterGroup(0);
                ClassEnable := true;
            end;

            Rec.FilterGroup(2);
            Rec.SetRange("Schooling Year", varSchoolingYear);
            Rec.FilterGroup(0);
            "Schooling YearEnable" := false;

        end else begin
            Rec.FilterGroup(2);
            Rec.SetRange("Schooling Year");
            Rec.FilterGroup(0);
            "Schooling YearEnable" := true;
        end;

        CurrPage.Update(false);
    end;

    local procedure varSubjectTypeOnAfterValidate()
    begin
        if varSubjectType <> 0 then begin
            if varSubjectType = varSubjectType::Subject then begin
                Rec.FilterGroup(2);
                Rec.SetRange("Type Subject", Rec."Type Subject"::Subject);
                Rec.FilterGroup(0);
                txtClassEnable := true;
                AllowAssignEvaluationsEditable := true;
                AllowCalcFinalAssessEditable := true;
                AllowStuGlobalObservationsEdit := true;
                "Allow SummaryEditable" := true;
                "Sub-Subject CodeEnable" := true;
            end;
            if varSubjectType = varSubjectType::"Non lective Component" then begin
                Rec.FilterGroup(2);
                Rec.SetRange("Type Subject", Rec."Type Subject"::"Non lective Component");
                Rec.FilterGroup(0);
                txtClassEnable := true;
                AllowAssignEvaluationsEditable := true;
                AllowCalcFinalAssessEditable := true;
                AllowStuGlobalObservationsEdit := true;
                "Allow SummaryEditable" := true;
                "Sub-Subject CodeEnable" := false;
            end;
            if varSubjectType = varSubjectType::"Non scholar hours" then begin
                Rec.FilterGroup(2);
                Rec.SetRange("Type Subject", Rec."Type Subject"::"Non scholar hours");
                Rec.FilterGroup(0);
                txtClassEnable := false;
                AllowAssignEvaluationsEditable := false;
                AllowCalcFinalAssessEditable := false;
                AllowStuGlobalObservationsEdit := false;
                "Allow SummaryEditable" := false;
                "Sub-Subject CodeEnable" := false;
            end;
            "Type SubjectEnable" := false;
        end else begin
            Rec.FilterGroup(2);
            Rec.SetRange("Type Subject");
            Rec.FilterGroup(0);
            txtClassEnable := true;
            "Type SubjectEnable" := true;
            "Sub-Subject CodeEnable" := true;

        end;

        CurrPage.Update(false);
    end;

    local procedure varClassOnAfterValidate()
    var
        rClass: Record Class;
    begin


        if varClass <> '' then begin

            if varSchoolingYear = '' then begin
                rClass.Reset;
                if varSchoolYear <> '' then
                    rClass.SetRange(rClass."School Year", varSchoolYear);
                rClass.SetRange(rClass.Class, varClass);
                if rClass.FindSet then begin
                    varSchoolingYear := rClass."Schooling Year";
                    Rec.FilterGroup(2);
                    Rec.SetRange("Schooling Year", varSchoolingYear);
                    Rec.FilterGroup(0);
                    "Schooling YearEnable" := false;
                end;
            end;


            Rec.FilterGroup(2);
            Rec.SetRange(Class, varClass);
            Rec.FilterGroup(0);
            ClassEnable := false;
        end else begin
            Rec.FilterGroup(2);
            Rec.SetRange(Class);
            Rec.FilterGroup(0);
            ClassEnable := true;
        end;

        CurrPage.Update(false);
    end;

    local procedure varUserOnAfterValidate()
    begin
        if varUserType <> 0 then begin
            if varUser <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetRange(User, varUser);
                Rec.FilterGroup(0);
                UserEnable := false;
            end else begin
                Rec.FilterGroup(2);
                Rec.SetRange(User);
                Rec.FilterGroup(0);
                UserEnable := true;
            end;
            CurrPage.Update(false);
        end else
            Error(Text0001);
    end;
}

#pragma implicitwith restore

