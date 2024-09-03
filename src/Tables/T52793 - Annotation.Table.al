table 52793 Annotation
{
    Caption = 'Annotation';
    LookupPageID = "Annotation List";

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF ("Line Type" = CONST(Line)) Annotation.Code;
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Annotation Code"; Code[10])
        {
            Caption = 'Annotation Cod.';
        }
        field(5; "Annotation Description"; Text[250])
        {
            Caption = 'Annotation Description ';
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Cab,Line';
            OptionMembers = Cab,Line;
        }
    }

    keys
    {
        key(Key1; "School Year", "Code", "Line Type", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rObservation: Record Observation;
        rMultiLanguageObservation: Record "Multi language observation";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
    begin
        rAssessmentConfiguration.Reset;
        rAssessmentConfiguration.SetRange("Annotation Code", Code);
        rAssessmentConfiguration.SetRange("School Year", "School Year");
        if rAssessmentConfiguration.FindFirst then
            Error(Text0001);


        if ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.DeleteAnnotations(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        if ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.InsertAnnotations(Rec, xRec);
    end;

    trigger OnModify()
    begin
        if ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.ModifyAnnotations(Rec, xRec);
    end;

    var
        Text0001: Label 'Cannot delete the Annotation, there are Study Plans/Courses using this code.';
        rAssessmentConfiguration: Record "Assessment Configuration";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
}

