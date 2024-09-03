report 52759 "Copy Moments"
{
    Caption = 'Copy Moments';
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
                group("Copiar Momentos")
                {
                    Caption = 'Copiar Momentos';
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
                        TableRelation = "Structure Education Country"."Schooling Year";
                    }
                    field(OldRCenter; OldRCenter)
                    {
                        Caption = 'Responsibility Center';
                        TableRelation = "Responsibility Center";
                        ApplicationArea = Basic, Suite;
                    }
                    field(NewSchoolYear; NewSchoolYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
                    }
                    field(NewSchoolingYear; NewSchoolingYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Schooling Year ';
                        TableRelation = "Structure Education Country"."Schooling Year";
                    }
                    field(NewRCenter; NewRCenter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Responsibility Center';
                        TableRelation = "Responsibility Center";
                    }
                }
            }
        }

        actions
        {
        }
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



        if ValidateNewMoments then
            if Confirm(Text0001, true) then
                DeleteMoments
            else
                Error(Text0002);


        CopyMoments;

        Message(Text0003);
    end;

    trigger OnPreReport()
    begin
        if rCompanyInformation.Get then;
    end;

    var
        Text0001: Label 'There already are configured moments for the New Academic Year. Replace?';
        Text0002: Label 'Operation stopped.';
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'The insertion of a Schooling Year is mandatory.';
        Text0005: Label 'A new Schooling Year is mandatory.';
        Text0006: Label 'A new School Year is mandatory.';
        rMomentsAssessment: Record "Moments Assessment";
        OldSchoolingYear: Code[10];
        OldRCenter: Code[20];
        OldSchoolYear: Code[9];
        rCompanyInformation: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";
        cUserEducation: Codeunit "User Education";
        NewSchoolYear: Code[9];
        NewRCenter: Code[20];
        NewSchoolingYear: Code[10];

    //[Scope('OnPrem')]
    procedure CopyMoments()
    var
        rMomentsAssessmentNew: Record "Moments Assessment";
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("Country/Region Code", rCompanyInformation."Country/Region Code");
        rMomentsAssessment.SetRange("School Year", OldSchoolYear);
        rMomentsAssessment.SetRange("Responsibility Center", OldRCenter);
        if OldSchoolingYear <> '' then
            rMomentsAssessment.SetRange("Schooling Year", OldSchoolingYear);
        if rMomentsAssessment.Find('-') then begin
            repeat
                rMomentsAssessmentNew.TransferFields(rMomentsAssessment);
                rMomentsAssessmentNew.Validate("School Year", NewSchoolYear);
                if NewSchoolingYear <> '' then
                    rMomentsAssessmentNew.Validate("Schooling Year", NewSchoolingYear);
                rMomentsAssessmentNew."Starting Date" := 0D;
                rMomentsAssessmentNew."End Date" := 0D;
                rMomentsAssessmentNew.Active := false;
                rMomentsAssessmentNew."Responsibility Center" := NewRCenter;
                rMomentsAssessmentNew.Insert(true);
            until rMomentsAssessment.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateNewMoments(): Boolean
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("Country/Region Code", rCompanyInformation."Country/Region Code");
        rMomentsAssessment.SetRange("School Year", NewSchoolYear);
        rMomentsAssessment.SetRange("Responsibility Center", NewRCenter);
        if NewSchoolingYear <> '' then
            rMomentsAssessment.SetRange("Schooling Year", NewSchoolingYear);
        if rMomentsAssessment.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure DeleteMoments()
    begin
        rMomentsAssessment.Reset;
        rMomentsAssessment.SetRange("Country/Region Code", rCompanyInformation."Country/Region Code");
        rMomentsAssessment.SetRange("School Year", NewSchoolYear);
        rMomentsAssessment.SetRange("Responsibility Center", NewRCenter);
        if NewSchoolingYear <> '' then
            rMomentsAssessment.SetRange("Schooling Year", NewSchoolingYear);
        rMomentsAssessment.DeleteAll(true);
    end;

    //[Scope('OnPrem')]
    procedure GetMoments(pSchoolingYear: Code[10]; pSchoolYear: Code[9]; pRespCenter: Code[10])
    begin

        OldSchoolingYear := pSchoolingYear;
        OldSchoolYear := pSchoolYear;
        OldRCenter := pRespCenter;
        NewRCenter := pRespCenter;
    end;
}

