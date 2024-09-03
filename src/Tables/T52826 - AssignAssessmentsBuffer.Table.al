table 52826 "Assign Assessments Buffer"
{
    Caption = 'Assign Assessments Buffer';
    Permissions = TableData "Assessing Students" = rimd;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(4; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(6; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code WHERE(Type = FILTER(Subject));
        }
        field(10; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
        field(11; Text; Text[250])
        {
            Caption = 'Text';
        }
        field(20; Level; Integer)
        {
            Caption = 'Level';
        }
        field(21; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Student,Subjects,Option Group,Sub-Subjects,Schooling Year';
            OptionMembers = Student,Subjects,"Option Group","Sub-Subjects","Schooling Year";
        }
        field(22; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
        }
        field(23; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
    }

    keys
    {
        key(Key1; "User ID", "Line No.")
        {
        }
        key(Key2; "Class No.")
        {
            Clustered = true;
        }
        key(Key3; "Schooling Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rRegistration: Record Registration;
        rRegistrationSubjectsServices: Record "Registration Subjects";
        rStudentServicePlan: Record "Student Service Plan";
        rRegistrationClass: Record "Registration Class";
    begin
    end;

    var
        Text0001: Label 'You must fill the Class and Subject fields.';

    //[Scope('OnPrem')]
    procedure DeleteAssessignStudents(varClass: Code[20]; varSubject: Code[10]; varRespCenter: Code[10]; varSchoolYear: Code[9]; varSchoolingYear: Code[10]; varStudyPlanCode: Code[20]; varStudent: Code[20]; varMoment: Code[10]; varSubSubject: Code[20])
    var
        lAssessingStudents: Record "Assessing Students";
    begin
        lAssessingStudents.Reset;
        lAssessingStudents.SetRange(lAssessingStudents.Class, varClass);
        lAssessingStudents.SetRange(lAssessingStudents."School Year", varSchoolYear);
        lAssessingStudents.SetRange(lAssessingStudents."Schooling Year", varSchoolingYear);
        lAssessingStudents.SetRange(lAssessingStudents.Subject, varSubject);
        lAssessingStudents.SetRange(lAssessingStudents."Sub-Subject Code", varSubSubject);
        lAssessingStudents.SetRange(lAssessingStudents."Study Plan Code", varStudyPlanCode);
        lAssessingStudents.SetRange(lAssessingStudents."Student Code No.", varStudent);
        lAssessingStudents.SetRange(lAssessingStudents."Moment Code", varMoment);
        if lAssessingStudents.FindFirst then begin
            lAssessingStudents.Delete;
        end;
    end;
}

