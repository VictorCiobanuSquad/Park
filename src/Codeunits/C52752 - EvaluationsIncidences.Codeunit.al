codeunit 52752 "Evaluations-Incidences"
{

    trigger OnRun()
    begin
    end;


    procedure CalFaltasLegalReports(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]; pStudent: Code[20]; pSubject: Code[10]; pDataEnd: Date; pTotInj: Option Totais,Injustificadas; pDataIni: Date) TotalFaltas: Integer
    var
        rIncidenceType: Record "Incidence Type";
        rAbsence: Record Absence;
    begin
        //Devolve as faltas totais ou injustificadas, para um aluno, para uma disciplina, até uma determinada data
        //Em portugal os mapas legais só contabilizam as faltas do tipo Absence / Class e que tenham o pisco no campo Legal Report
        //As faltas do tipo Absence / Class que n tenham o pisco no campo Legal Report temos de fazer os cálculos da correspondencia
        //pTotInj 0 = totais / 1 = Injustificadas

        rIncidenceType.Reset;
        rIncidenceType.SetRange(rIncidenceType.Category, rIncidenceType.Category::Class);
        rIncidenceType.SetRange(rIncidenceType."Incidence Type", rIncidenceType."Incidence Type"::Absence);
        //Normatica 2013.05.31 - como o parque não justifica faltas, as faltas são justificadas por defeito,este filtro n faz sentido
        //rIncidenceType.SETFILTER(rIncidenceType."Absence Status",'<>%1',rIncidenceType."Absence Status"::Justification);
        rIncidenceType.SetRange(rIncidenceType."Legal/Attendance", false);
        rIncidenceType.SetRange(rIncidenceType."School Year", pSchoolYear);
        rIncidenceType.SetRange(rIncidenceType."Schooling Year", pSchoolingYear);
        rIncidenceType.SetFilter(rIncidenceType."Corresponding Code", '<>%1', '');
        if rIncidenceType.FindSet then begin
            repeat
                rAbsence.Reset;
                rAbsence.SetRange(rAbsence.Category, rAbsence.Category::Class);
                rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
                rAbsence.SetRange(rAbsence."School Year", pSchoolYear);
                if pClass <> '' then
                    rAbsence.SetRange(rAbsence.Class, pClass);
                rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Student);
                rAbsence.SetRange(rAbsence."Student/Teacher Code No.", pStudent);
                if pSubject <> '' then
                    rAbsence.SetRange(rAbsence.Subject, pSubject);
                if pTotInj = pTotInj::Injustificadas then
                    rAbsence.SetRange(rAbsence."Absence Status", rAbsence."Absence Status"::Unjustified);
                if (pDataIni <> 0D) and (pDataEnd <> 0D) then
                    rAbsence.SetRange(rAbsence.Day, pDataIni, pDataEnd);
                if (pDataIni = 0D) and (pDataEnd <> 0D) then
                    rAbsence.SetFilter(rAbsence.Day, '<=%1', pDataEnd);
                if (pDataIni <> 0D) and (pDataEnd = 0D) then
                    rAbsence.SetFilter(rAbsence.Day, '>=%1', pDataIni);

                rAbsence.SetRange(rAbsence."Incidence Code", rIncidenceType."Incidence Code");
                if rAbsence.Find('+') then begin
                    TotalFaltas := TotalFaltas + (Round(rAbsence.Count / rIncidenceType.Quantity, 1, '<'));
                end;
            until rIncidenceType.Next = 0;
        end;


        rIncidenceType.Reset;
        rIncidenceType.SetRange(rIncidenceType.Category, rIncidenceType.Category::Class);
        rIncidenceType.SetRange(rIncidenceType."Incidence Type", rIncidenceType."Incidence Type"::Absence);
        //Normatica 2013.05.31 - como o parque não justifica faltas, as faltas são justificadas por defeito,este filtro n faz sentido
        //rIncidenceType.SETFILTER(rIncidenceType."Absence Status",'<>%1',rIncidenceType."Absence Status"::Justification);
        rIncidenceType.SetRange(rIncidenceType."Legal/Attendance", true);
        rIncidenceType.SetRange(rIncidenceType."School Year", pSchoolYear);
        rIncidenceType.SetRange(rIncidenceType."Schooling Year", pSchoolingYear);
        if rIncidenceType.FindSet then begin
            repeat
                rAbsence.Reset;
                rAbsence.SetRange(rAbsence.Category, rAbsence.Category::Class);
                rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
                rAbsence.SetRange(rAbsence."School Year", pSchoolYear);
                if pClass <> '' then
                    rAbsence.SetRange(rAbsence.Class, pClass);
                rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Student);
                rAbsence.SetRange(rAbsence."Student/Teacher Code No.", pStudent);
                if pSubject <> '' then
                    rAbsence.SetRange(rAbsence.Subject, pSubject);
                if (pDataIni <> 0D) and (pDataEnd <> 0D) then
                    rAbsence.SetRange(rAbsence.Day, pDataIni, pDataEnd);
                if (pDataIni = 0D) and (pDataEnd <> 0D) then
                    rAbsence.SetFilter(rAbsence.Day, '<=%1', pDataEnd);
                if (pDataIni <> 0D) and (pDataEnd = 0D) then
                    rAbsence.SetFilter(rAbsence.Day, '>=%1', pDataIni);

                rAbsence.SetRange(rAbsence."Incidence Code", rIncidenceType."Incidence Code");
                if pTotInj = pTotInj::Injustificadas then
                    rAbsence.SetRange(rAbsence."Absence Status", rAbsence."Absence Status"::Unjustified);
                if rAbsence.Find('+') then
                    TotalFaltas := TotalFaltas + rAbsence.Count;
            until rIncidenceType.Next = 0;
        end;

        exit(TotalFaltas);
    end;


    procedure CalNotesLegalReports(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]; pStudent: Code[20]; pSubject: Code[10]; pMoment: Code[10]) Nota: Text[30]
    var
        rAsseStudent: Record "Assessing Students";
    begin
        //Devolve a nota, para um aluno, para uma disciplina, num determinado momento

        rAsseStudent.Reset;
        rAsseStudent.SetRange(rAsseStudent.Class, pClass);
        rAsseStudent.SetRange(rAsseStudent."School Year", pSchoolYear);
        rAsseStudent.SetRange(rAsseStudent."Schooling Year", pSchoolingYear);
        rAsseStudent.SetRange(rAsseStudent.Subject, pSubject);
        rAsseStudent.SetRange(rAsseStudent."Student Code No.", pStudent);
        rAsseStudent.SetRange(rAsseStudent."Moment Code", pMoment);
        if rAsseStudent.FindFirst then begin
            if rAsseStudent.Grade <> 0 then Nota := Format(rAsseStudent.Grade);
            if rAsseStudent."Qualitative Grade" <> '' then Nota := Format(rAsseStudent."Qualitative Grade");
        end;


        exit(Nota);
    end;


    procedure CalNotesSubDisc(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]; pStudent: Code[20]; pSubject: Code[10]; pSubSubject: Code[10]; pMoment: Code[10]) Nota: Text[30]
    var
        rAsseStudent: Record "Assessing Students";
    begin
        //Normatica 2013.05.31 - nova função para o Parque devolver as avaliações às sub-disciplinas
        //Devolve a nota, para um aluno, para uma subdisciplina, num determinado momento

        rAsseStudent.Reset;
        rAsseStudent.SetRange(rAsseStudent.Class, pClass);
        rAsseStudent.SetRange(rAsseStudent."School Year", pSchoolYear);
        rAsseStudent.SetRange(rAsseStudent."Schooling Year", pSchoolingYear);
        rAsseStudent.SetRange(rAsseStudent.Subject, pSubject);
        rAsseStudent.SetRange(rAsseStudent."Sub-Subject Code", pSubSubject);
        rAsseStudent.SetRange(rAsseStudent."Student Code No.", pStudent);
        rAsseStudent.SetRange(rAsseStudent."Moment Code", pMoment);
        if rAsseStudent.FindFirst then begin
            if rAsseStudent.Grade <> 0 then Nota := Format(rAsseStudent.Grade);
            if rAsseStudent."Qualitative Grade" <> '' then Nota := Format(rAsseStudent."Qualitative Grade");
        end;


        exit(Nota);
    end;
}

