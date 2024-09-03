table 52829 "Absence ET-RH"
{
    Caption = 'Absences ET-RH';

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Teacher Code No."; Code[20])
        {
            Caption = 'Teacher Code No.';
            TableRelation = Teacher."No.";

            trigger OnLookup()
            var
                rRegistrationClass: Record "Registration Class";
                rStudents: Record Students;
                rStudentsTEMP: Record Students temporary;
                rRegistrationSubjects: Record "Registration Subjects";
                rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                rStudentsNLHours: Record "Students Non Lective Hours";
                rDate: Record Date;
                rRegistration: Record Registration;
            begin
            end;
        }
        field(6; Name; Text[128])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(7; Day; Date)
        {
            Caption = 'Day';
        }
        field(10; "Incidence Code"; Code[20])
        {
            Caption = 'Incidence Code';
            TableRelation = "Incidence Type"."Incidence Code" WHERE(Category = CONST(Teacher),
                                                                     "Absence Status" = FILTER(<> Justification));
        }
        field(11; "Incidence Description"; Text[50])
        {
            Caption = 'Incidence Description';
        }
        field(12; "Absence Type"; Option)
        {
            Caption = 'Absence Type';
            OptionCaption = 'Lecture,Daily';
            OptionMembers = Lecture,Daily;
        }
        field(13; "Absence Status"; Option)
        {
            Caption = 'Absence Status';
            OptionCaption = 'Justified,Unjustified';
            OptionMembers = Justified,Unjustified;
        }
        field(15; "Justified Code"; Code[20])
        {
            Caption = 'Justified Code';
        }
        field(16; "Justified Description"; Text[50])
        {
            Caption = 'Justified Description';
            Editable = false;
        }
        field(20; "Absence Qtd"; Decimal)
        {
            Caption = 'Absence Qtd';
        }
        field(21; "Results in loss of pay"; Boolean)
        {
            Caption = 'Results in loss of pay';
            Description = 'Ligação com o RH';
        }
        field(30; "Cause of Absence Code"; Code[10])
        {
            Caption = 'Cause of Absence Code';
            //TableRelation = Table31003041;
        }
        field(40; Select; Boolean)
        {
            Caption = 'Select';
        }
    }

    keys
    {
        key(Key1; "School Year", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        l_text00001: Label 'Active';
        l_text00002: Label 'Closing';
    begin
    end;

    var
        rAbsenceETRH: Record "Absence ET-RH";
        nMov: Integer;

    //[Scope('OnPrem')]
    procedure SendAbsencesToHR()
    begin
        /*
         IF rAusenciaEmp.FIND('+') THEN
           nMov := rAusenciaEmp."Entry No." + 1
         ELSE
           nMov := 1;
        
        
        rAbsenceETRH.RESET;
        rAbsenceETRH.SETRANGE(rAbsenceETRH.Select,TRUE);
        IF rAbsenceETRH.FINDSET THEN BEGIN
          REPEAT
            rAusenciaEmp.INIT;
            rAusenciaEmp."Entry No." := nMov;
        
            rEmpregado.RESET;
            rEmpregado.SETRANGE(rEmpregado."Nº Professor",rAbsenceETRH."Teacher Code No.");
            IF rEmpregado.FINDFIRST THEN
              rAusenciaEmp.VALIDATE(rAusenciaEmp."Employee No.", rEmpregado."No.");
            rAusenciaEmp.VALIDATE(rAusenciaEmp."Cause of Absence Code" , rAbsenceETRH."Cause of Absence Code");
            rAusenciaEmp.VALIDATE(rAusenciaEmp."From Date", rAbsenceETRH.Day);
            rAusenciaEmp.VALIDATE(rAusenciaEmp."To Date" , rAbsenceETRH.Day);
            rAusenciaEmp.VALIDATE(rAusenciaEmp.Quantity , rAbsenceETRH."Absence Qtd");
            IF rAbsenceETRH."Absence Type" = rAbsenceETRH."Absence Type"::Daily THEN BEGIN
              rUnidMedidaRH.RESET;
              rUnidMedidaRH.SETRANGE(rUnidMedidaRH."Designação Interna",rUnidMedidaRH."Designação Interna"::"0");
            END;
            IF rAbsenceETRH."Absence Type" = rAbsenceETRH."Absence Type"::Lecture THEN BEGIN
              rUnidMedidaRH.RESET;
              rUnidMedidaRH.SETRANGE(rUnidMedidaRH."Designação Interna",rUnidMedidaRH."Designação Interna"::"1");
            END;
            IF rUnidMedidaRH.FINDFIRST THEN
              rAusenciaEmp.VALIDATE(rAusenciaEmp."Unit of Measure Code" , rUnidMedidaRH.Code);
        
            rAusenciaEmp.INSERT;
            nMov := nMov + 1;
        
        
          UNTIL rAbsenceETRH.NEXT = 0;
        END;
        */

    end;
}

