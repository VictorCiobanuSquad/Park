table 52813 Observation
{
    Caption = 'Observation';
    LookupPageID = "Assessement Observation List";

    fields
    {
        field(1; "Observation Type"; Option)
        {
            Caption = 'Observation Type';
            OptionCaption = ' ,Assessement,Incidence Student,Incidence Teacher';
            OptionMembers = " ",Assessement,"Incidence Student","Incidence Teacher";
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF ("Line Type" = CONST(Line)) Observation.Code;
        }
        field(4; Descripton; Text[30])
        {
            Caption = 'Description';
        }
        field(5; "Description Male"; Text[250])
        {
            Caption = 'Description Male';
        }
        field(6; "Description Female"; Text[250])
        {
            Caption = 'Description Female';
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
        key(Key1; "Code", "School Year", "Observation Type", "Line Type", "Line No.")
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
        if ("Observation Type" = "Observation Type"::Assessement) and
          ("Line Type" = "Line Type"::Cab) then begin

            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Observations, Code);
            rStudyPlanLines.SetRange("School Year", "School Year");
            if rStudyPlanLines.FindFirst then
                Error(Text0001);

            rCourseLines.Reset;
            rCourseLines.SetRange(Observations, Code);
            if rCourseLines.FindFirst then
                Error(Text0001);

        end;

        if ("Observation Type" <> "Observation Type"::"Incidence Teacher") and
          ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.DeleteObservation(Rec, xRec);

        rMultiLanguageObservation.Reset;
        rMultiLanguageObservation.SetRange("School Year", "School Year");
        rMultiLanguageObservation.SetRange("Observation Code", Code);
        if "Line Type" = "Line Type"::Line then
            rMultiLanguageObservation.SetRange("Line No.", "Line No.");
        rMultiLanguageObservation.DeleteAll(true);

        if "Line Type" = "Line Type"::Cab then begin
            rObservation.Reset;
            rObservation.SetRange(Code, Code);
            rObservation.SetRange("School Year", "School Year");
            rObservation.SetRange("Observation Type", "Observation Type");
            rObservation.SetRange("Line Type", rObservation."Line Type"::Line);
            rObservation.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        if ("Observation Type" <> "Observation Type"::"Incidence Teacher") and
          ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.InsertObservation(Rec, xRec);
    end;

    trigger OnModify()
    begin
        if ("Observation Type" <> "Observation Type"::"Incidence Teacher") and
          ("Line Type" = "Line Type"::Line) then
            cMasterTableWEB.ModifyObservation(Rec, xRec);
    end;

    trigger OnRename()
    begin
        //rCompanyInformation.Get;
        //if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
        //Error(Text0002,TableCaption);
    end;

    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        Text0001: Label 'Cannot delete the observation, there are Study Plans/Courses using this code.';
        Text0002: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";
}

