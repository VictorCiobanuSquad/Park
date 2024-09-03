report 52788 "Copy Incidences"
{
    Caption = 'Copy Incidences';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(OldSchoolYear; OldSchoolYear)
                    {
                        Caption = 'School Year';
                        TableRelation = "School Year"."School Year";
                        ApplicationArea = Basic, Suite;
                    }
                    field(OldSchoolingYear; OldSchoolingYear)
                    {
                        Caption = 'Schooling Year';
                        ApplicationArea = Basic, Suite;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            rStructureEducationCountry.Reset;
                            rStructureEducationCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                            if rStructureEducationCountry.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Structure Education country", rStructureEducationCountry) = ACTION::LookupOK then begin
                                    OldSchoolingYear := rStructureEducationCountry."Schooling Year";
                                end;
                            end;
                        end;
                    }
                    field(OldCenter; OldRCenter)
                    {
                        Caption = 'Responsibility Center';
                        Editable = OldCenterEditable;
                        TableRelation = "Responsibility Center";
                        ApplicationArea = Basic, Suite;
                    }
                    field(varCategory; varCategory)
                    {
                        Caption = 'Category';
                        OptionCaption = 'Class,Cantine,BUS,Schoolyard,Extra-scholar,Teacher,All';
                        ApplicationArea = Basic, Suite;
                    }
                    field(NewSchoolYear; NewSchoolYear)
                    {
                        Caption = 'New School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
                        ApplicationArea = Basic, Suite;
                    }
                    field(NewSchoolingYear; NewSchoolingYear)
                    {
                        Caption = 'New Schooling Year ';
                        ApplicationArea = Basic, Suite;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            rStructureEducationCountry.Reset;
                            rStructureEducationCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                            if rStructureEducationCountry.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Structure Education country", rStructureEducationCountry) = ACTION::LookupOK then
                                    NewSchoolingYear := rStructureEducationCountry."Schooling Year";
                            end;
                        end;
                    }
                    field(NewCenter; NewRCenter)
                    {
                        Caption = 'New Responsibility Center';
                        Editable = NewCenterEditable;
                        TableRelation = "Responsibility Center";
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            NewCenterEditable := true;
            OldCenterEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if rCompanyInformation.Get then;

            if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                OldCenterEditable := false;
                NewCenterEditable := false;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //Para poder copiar todos de um ano para outro
        if OldSchoolingYear = '' then
            if NewSchoolingYear = '' then
                NewSchoolingYear := '';

        if OldSchoolingYear <> '' then
            if NewSchoolingYear = '' then
                Error(Text0005);

        if NewSchoolYear = '' then
            Error(Text0006);


        if ValidateNewIncidence then
            if Confirm(Text0001, true) then
                DeleteIncidences
            else
                Error(Text0002);


        CopyIncidences;

        Message(Text0003);
    end;

    trigger OnPreReport()
    begin
        if rCompanyInformation.Get then;
    end;

    var
        OldSchoolingYear: Code[10];
        OldRCenter: Code[20];
        OldSchoolYear: Code[9];
        rCompanyInformation: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";
        Text0001: Label 'There is already configured incidences for the New Academic Year. Replace?';
        Text0002: Label 'Operation stopped.';
        cUserEducation: Codeunit "User Education";
        NewSchoolYear: Code[9];
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'Mandatory Schoolling Year.';
        Text0005: Label 'Mandatory New Schoolling Year.';
        Text0006: Label 'Mandatory New Schooll Year.';
        NewRCenter: Code[20];
        NewSchoolingYear: Code[10];
        varRespCenter: Code[10];
        varCategory: Option Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher,All;
        rIncidenceType: Record "Incidence Type";
        [InDataSet]
        OldCenterEditable: Boolean;
        [InDataSet]
        NewCenterEditable: Boolean;

    //[Scope('OnPrem')]
    procedure ValidateNewIncidence(): Boolean
    begin

        rIncidenceType.Reset;
        if NewSchoolingYear <> '' then
            rIncidenceType.SetRange("Schooling Year", NewSchoolingYear);
        rIncidenceType.SetRange("School Year", NewSchoolYear);
        if varCategory <> varCategory::All then
            rIncidenceType.SetRange(Category, varCategory);
        rIncidenceType.SetRange("Responsibility Center", NewRCenter);
        if rIncidenceType.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure DeleteIncidences()
    begin

        rIncidenceType.Reset;
        if NewSchoolingYear <> '' then
            rIncidenceType.SetRange("Schooling Year", NewSchoolingYear);
        rIncidenceType.SetRange("School Year", NewSchoolYear);
        if varCategory <> varCategory::All then
            rIncidenceType.SetRange(Category, varCategory);
        rIncidenceType.SetRange("Responsibility Center", NewRCenter);
        rIncidenceType.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure GetIncidences(pSchoolingYear: Code[10]; pSchoolYear: Code[9]; pRespCenter: Code[10])
    begin

        OldSchoolingYear := pSchoolingYear;
        OldSchoolYear := pSchoolYear;
        OldRCenter := pRespCenter;
        NewRCenter := pRespCenter;
    end;

    //[Scope('OnPrem')]
    procedure CopyIncidences()
    var
        l_IncidenceType: Record "Incidence Type";
    begin

        rIncidenceType.Reset;
        if varCategory <> varCategory::All then
            rIncidenceType.SetRange(Category, varCategory);
        rIncidenceType.SetRange("School Year", OldSchoolYear);
        rIncidenceType.SetRange("Responsibility Center", OldRCenter);
        if OldSchoolingYear <> '' then
            rIncidenceType.SetRange("Schooling Year", OldSchoolingYear);
        if rIncidenceType.FindSet then begin
            repeat
                l_IncidenceType.TransferFields(rIncidenceType);
                l_IncidenceType.Validate("School Year", NewSchoolYear);
                if NewSchoolingYear <> '' then
                    l_IncidenceType.Validate("Schooling Year", NewSchoolingYear);
                l_IncidenceType."Responsibility Center" := NewRCenter;
                l_IncidenceType.Insert(true);
            until rIncidenceType.Next = 0;
        end;
    end;
}

