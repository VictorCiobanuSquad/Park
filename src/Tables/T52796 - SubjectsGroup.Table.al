table 52796 "Subjects Group"
{
    Caption = 'Department Group';
    DrillDownPageID = "Subjects Group";
    LookupPageID = "Subjects Group";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Teacher,Subject';
            OptionMembers = Teacher,Subject;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = IF (Type = FILTER(Teacher)) "Subjects Group".Code WHERE(Type = FILTER(Subject));

            trigger OnValidate()
            begin
                if Type = Type::Teacher then
                    if Code <> '' then begin
                        rSubjectsGroup.Get(Type::Subject, Code);
                        "Subject Description" := rSubjectsGroup."Subject Description";
                    end else
                        "Subject Description" := '';
            end;
        }
        field(3; "Teacher No."; Code[20])
        {
            Caption = 'Teacher No.';
            TableRelation = Teacher."No.";
        }
        field(4; "Subject Description"; Text[64])
        {
            Caption = 'Department Description';
        }
        field(5; "Teacher Name"; Text[250])
        {
            CalcFormula = Lookup(Teacher.Name WHERE("No." = FIELD("Teacher No.")));
            Caption = 'Teacher Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Head of Department"; Code[20])
        {
            Caption = 'Cap de Departament';
            TableRelation = Teacher."No.";

            trigger OnValidate()
            begin
                if rTeacher.Get("Head of Department") then
                    "Name of the Head of Department" := FullName(rTeacher."No.");
            end;
        }
        field(7; "Name of the Head of Department"; Text[191])
        {
            Caption = 'Nom del Cap de Departament';
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Teacher No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rSubjectsGroup: Record "Subjects Group";
        rTeacher: Record Teacher;


    procedure FullName(pTeacher: Code[20]) rName: Text[191]
    var
        rEduConfiguration: Record "Edu. Configuration";
        l_Teacher: Record Teacher;
    begin
        if l_Teacher.Get(pTeacher) then begin

            if rEduConfiguration.Get then begin
                if rEduConfiguration."Full Name syntax" = 0 then begin
                    if l_Teacher."Last Name 2" <> '' then
                        rName := l_Teacher."Last Name" + ' ' + l_Teacher."Last Name 2" + ', ' + l_Teacher.Name
                    else
                        rName := l_Teacher."Last Name" + ', ' + l_Teacher.Name;
                end else begin
                    if l_Teacher."Last Name 2" <> '' then
                        rName := l_Teacher.Name + ' ' + l_Teacher."Last Name 2" + ' ' + l_Teacher."Last Name"
                    else
                        rName := l_Teacher.Name + ' ' + l_Teacher."Last Name";
                end;
            end;
        end;
    end;
}

