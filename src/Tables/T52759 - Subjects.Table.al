table 52759 Subjects
{
    Caption = 'Subjects';
    LookupPageID = Subjects;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';

            trigger OnValidate()
            var
                l_Subjects: Record Subjects;
            begin
                l_Subjects.Reset;
                l_Subjects.SetRange(Code, Code);
                l_Subjects.SetRange(Type, Type);
                if l_Subjects.Find('-') then
                    Error(Text0003);
            end;
        }
        field(2; Description; Text[64])
        {
            Caption = 'Description';
        }
        field(3; "Abbreviation Description"; Text[28])
        {
            Caption = 'Abbreviation Description';
        }
        field(4; Department; Code[10])
        {
            Caption = 'Department';
            TableRelation = "Subjects Group".Code WHERE(Type = FILTER(Subject));
        }
        field(12; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = ',Cantine,BUS,Schoolyard ';
            OptionMembers = " ",Cantine,BUS,"Schoolyard ";
        }
        field(55; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non scholar component","Non scholar hours";
        }
        field(56; "Absence Period"; Option)
        {
            Caption = 'Absence Period';
            OptionCaption = ' ,Daily';
            OptionMembers = " ",Daily;
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Code <> '' then
            ValidateDeleteSubject;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0012, TableCaption);*/
    end;

    var
        rStudyPlanLine: Record "Study Plan Lines";
        rCourseLine: Record "Course Lines";
        Text0001: Label 'Cannot delete this subject %1 because it is already enroled in a study plan %2.';
        Text0002: Label 'Cannot delete this subject %1 becaused it is already enroled in a course %2.';
        Text0003: Label 'The Selected Code is already in use.';
        Text0012: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";


    procedure ValidateDeleteSubject()
    begin
        if Type = Type::Subject then begin
            rStudyPlanLine.Reset;
            rStudyPlanLine.SetRange("Subject Code", Code);
            if rStudyPlanLine.Find('-') then
                Error(Text0001, Code, rStudyPlanLine.Code);

            rCourseLine.Reset;
            rCourseLine.SetRange("Subject Code", Code);
            if rCourseLine.Find('-') then
                Error(Text0002, Code, rCourseLine.Code);
        end;
    end;
}

