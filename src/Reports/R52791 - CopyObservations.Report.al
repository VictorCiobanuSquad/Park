report 52791 "Copy Observations"
{
    Caption = 'Copy Observations';
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
                    field(vOldSchoolYear; vOldSchoolYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'School Year';
                        TableRelation = "School Year";
                    }
                    field(vOldObsCode; vOldObsCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Observation Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rObservationHead: Record Observation;
                        begin
                            if vOldSchoolYear = '' then
                                exit;

                            l_rObservationHead.Reset;
                            l_rObservationHead.SetRange("Line Type", l_rObservationHead."Line Type"::Cab);
                            l_rObservationHead.SetRange("School Year", vOldSchoolYear);
                            if PAGE.RunModal(0, l_rObservationHead) = ACTION::LookupOK then
                                vOldObsCode := l_rObservationHead.Code;
                        end;
                    }
                    field(vNewSchoolYear; vNewSchoolYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New School Year';
                        TableRelation = "School Year";
                    }
                    field(vNewObsCode; vNewObsCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Observation Code';
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
        //IF (vOldObsCode = '') THEN
        //   ERROR(Text0002);

        if (vOldSchoolYear = '') then
            Error(Text0003);

        if (vNewSchoolYear = '') then
            Error(Text0005);

        //IF (vNewObsCode = '') THEN
        //   ERROR(Text0004);

        CopyObservation;

        Message(Text0001);
    end;

    var
        vOldObsCode: Code[20];
        vNewObsCode: Code[20];
        Text0001: Label 'Copies conducted successfully.';
        Text0002: Label 'Mandatory Copy Observation Code.';
        Text0003: Label 'There is no School Year selected.';
        Text0004: Label 'Mandatory Observations Code.';
        vOldSchoolYear: Code[9];
        vNewSchoolYear: Code[9];
        Text0005: Label 'There is no New School Year selected.';


    procedure CopyObservation()
    var
        l_rObservationHead: Record Observation;
        l_rObservationHeadNEW: Record Observation;
        l_rObservationLine: Record Observation;
        l_rObservationLineNEW: Record Observation;
        l_MultiLanguage: Record "Multi language observation";
        l_MultiLanguageNEW: Record "Multi language observation";
    begin
        //Cabeçalho
        l_rObservationHead.Reset;
        l_rObservationHead.SetRange("Line Type", l_rObservationHead."Line Type"::Cab);
        if vOldObsCode <> '' then
            l_rObservationHead.SetRange(Code, vOldObsCode);
        l_rObservationHead.SetRange("School Year", vOldSchoolYear);
        if l_rObservationHead.Find('-') then begin
            repeat
                l_rObservationHeadNEW.Init;
                l_rObservationHeadNEW.TransferFields(l_rObservationHead);
                if vNewObsCode <> '' then
                    l_rObservationHeadNEW.Code := vNewObsCode;
                l_rObservationHeadNEW."School Year" := vNewSchoolYear;
                l_rObservationHeadNEW.Insert(true);
            until l_rObservationHead.Next = 0;
        end;
        //

        //Linhas
        l_rObservationLine.Reset;
        l_rObservationLine.SetRange("Line Type", l_rObservationLine."Line Type"::Line);
        l_rObservationLine.SetRange("School Year", vOldSchoolYear);
        if vOldObsCode <> '' then
            l_rObservationLine.SetRange(Code, vOldObsCode);
        if l_rObservationLine.FindSet then begin
            repeat
                l_rObservationLineNEW.Init;
                l_rObservationLineNEW.TransferFields(l_rObservationLine);
                l_rObservationLineNEW."School Year" := vNewSchoolYear;
                if vNewObsCode <> '' then
                    l_rObservationLineNEW.Code := vNewObsCode;
                l_rObservationLineNEW.Insert(true);
            until l_rObservationLine.Next = 0;
        end;
        //
        l_MultiLanguage.Reset;
        l_MultiLanguage.SetRange("School Year", vOldSchoolYear);
        if vOldObsCode <> '' then
            l_MultiLanguage.SetRange("Observation Code", vOldObsCode);
        if l_MultiLanguage.FindSet then begin
            repeat
                l_MultiLanguageNEW.Init;
                l_MultiLanguageNEW.TransferFields(l_MultiLanguage);
                l_MultiLanguageNEW."School Year" := vNewSchoolYear;
                if vNewObsCode <> '' then
                    l_MultiLanguageNEW."Observation Code" := vNewObsCode;
                l_MultiLanguageNEW.Insert;
            until l_MultiLanguage.Next = 0;
        end;
    end;


    procedure GETObservation(pObservationCode: Code[20]; pSchoolYear: Code[9])
    begin
        vOldObsCode := pObservationCode;
        vOldSchoolYear := pSchoolYear;
    end;
}

