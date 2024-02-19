report 31009766 "Copy Incidence"
{
    Caption = 'Copy Incidence';
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
                                if PAGE.RunModal(PAGE::"Structure Education country", rStructureEducationCountry) = ACTION::LookupOK then
                                    OldSchoolingYear := rStructureEducationCountry."Schooling Year";
                            end;
                        end;
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
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if rCompanyInformation.Get then;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if OldSchoolingYear = '' then
            Error(Text0004);
        if NewSchoolingYear = '' then
            Error(Text0005);
        if NewSchoolYear = '' then
            Error(Text0006);

        if ValidateNewIncidence then
            if Confirm(Text0001, true) then
                DeleteIncidence
            else
                Error(Text0002);

        CopyIncidence;

        Message(Text0003);
    end;

    trigger OnPreReport()
    begin
        if rCompanyInformation.Get then;
    end;

    var
        rIncidenceType: Record "Incidence Type";
        OldSchoolingYear: Code[10];
        NewSchoolingYear: Code[10];
        rCompanyInformation: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";
        Text0001: Label 'There is already configured moments for the New Academic Year. Replace?';
        Text0002: Label 'Operation stopped.';
        OldSchoolYear: Code[9];
        NewSchoolYear: Code[9];
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'Mandatory Schoolling Year.';
        Text0005: Label 'Mandatory New Schoolling Year.';
        Text0006: Label 'Mandatory New Schooll Year.';

    //[Scope('OnPrem')]
    procedure CopyIncidence()
    var
        rIncidenceTypeNew: Record "Incidence Type";
    begin
        rIncidenceType.Reset;
        rIncidenceType.SetRange("School Year", OldSchoolYear);
        rIncidenceType.SetRange("Schooling Year", OldSchoolingYear);
        if rIncidenceType.Find('-') then begin
            repeat
                rIncidenceTypeNew.TransferFields(rIncidenceType);
                rIncidenceTypeNew.Validate("School Year", NewSchoolYear);
                rIncidenceTypeNew.Validate("Schooling Year", NewSchoolingYear);
                rIncidenceTypeNew.Insert;
            until rIncidenceType.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateNewIncidence(): Boolean
    begin
        rIncidenceType.Reset;
        rIncidenceType.SetRange("School Year", NewSchoolYear);
        rIncidenceType.SetRange("Schooling Year", NewSchoolingYear);
        if rIncidenceType.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure DeleteIncidence()
    begin
        rIncidenceType.Reset;
        rIncidenceType.SetRange("School Year", NewSchoolYear);
        rIncidenceType.SetRange("Schooling Year", NewSchoolingYear);
        if rIncidenceType.Find('-') then
            rIncidenceType.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure GetIncidence(pSchoolingYear: Code[10]; pSchoolYear: Code[9])
    begin

        OldSchoolingYear := pSchoolingYear;
        OldSchoolYear := pSchoolYear;
    end;
}

