report 52815 "Copy Annotations"
{
    Caption = 'Copy Annotation';
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
                        Caption = 'School Year';
                        TableRelation = "School Year";
                        ApplicationArea = Basic, Suite;
                    }
                    field(vOldAnnotCode; vOldAnnotCode)
                    {
                        Caption = 'Cód. Averbamento';
                        ApplicationArea = Basic, Suite;
                    }
                    field(vNewSchoolYear; vNewSchoolYear)
                    {
                        Caption = 'New School Year';
                        TableRelation = "School Year";
                        ApplicationArea = Basic, Suite;
                    }
                    field(vNewAnnotCode; vNewAnnotCode)
                    {
                        Caption = 'Novo Cód. Averbamento';
                        ApplicationArea = Basic, Suite;
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

        if (vOldSchoolYear = '') then
            Error(Text0003);

        if (vNewSchoolYear = '') then
            Error(Text0005);


        CopyAnnotation;

        Message(Text0001);
    end;

    var
        vOldAnnotCode: Code[20];
        vNewAnnotCode: Code[20];
        Text0001: Label 'Copies conducted successfully.';
        Text0002: Label 'Mandatory Copy Annotation Code.';
        Text0003: Label 'There is no School Year selected.';
        Text0004: Label 'Mandatory Annotation Code.';
        vOldSchoolYear: Code[9];
        vNewSchoolYear: Code[9];
        Text0005: Label 'There is no New School Year selected.';


    procedure CopyAnnotation()
    var
        l_rAnnotationHead: Record Annotation;
        l_rAnnotationHeadNEW: Record Annotation;
        l_rAnnotationLine: Record Annotation;
        l_rAnnotationLineNEW: Record Annotation;
    begin
        //Cabeçalho
        l_rAnnotationHead.Reset;
        l_rAnnotationHead.SetRange("Line Type", l_rAnnotationHead."Line Type"::Cab);
        if vOldAnnotCode <> '' then
            l_rAnnotationHead.SetRange(Code, vOldAnnotCode);
        l_rAnnotationHead.SetRange("School Year", vOldSchoolYear);
        if l_rAnnotationHead.Find('-') then begin
            repeat
                l_rAnnotationHeadNEW.Init;
                l_rAnnotationHeadNEW.TransferFields(l_rAnnotationHead);
                if vNewAnnotCode <> '' then
                    l_rAnnotationHeadNEW.Code := vNewAnnotCode;
                l_rAnnotationHeadNEW."School Year" := vNewSchoolYear;
                l_rAnnotationHeadNEW.Insert(true);
            until l_rAnnotationHead.Next = 0;
        end;
        //

        //Linhas
        l_rAnnotationLine.Reset;
        l_rAnnotationLine.SetRange("Line Type", l_rAnnotationLine."Line Type"::Line);
        l_rAnnotationLine.SetRange("School Year", vOldSchoolYear);
        if vOldAnnotCode <> '' then
            l_rAnnotationLine.SetRange(Code, vOldAnnotCode);
        if l_rAnnotationLine.Find('-') then begin
            repeat
                l_rAnnotationLineNEW.Init;
                l_rAnnotationLineNEW.TransferFields(l_rAnnotationLine);
                l_rAnnotationLineNEW."School Year" := vNewSchoolYear;
                if vNewAnnotCode <> '' then
                    l_rAnnotationLineNEW.Code := vNewAnnotCode;
                l_rAnnotationLineNEW.Insert(true);
            until l_rAnnotationLine.Next = 0;
        end;
        //
    end;


    procedure GETAnnotation(pAnnotationCode: Code[20]; pSchoolYear: Code[9])
    begin

        vOldAnnotCode := pAnnotationCode;
        vOldSchoolYear := pSchoolYear;
    end;
}

