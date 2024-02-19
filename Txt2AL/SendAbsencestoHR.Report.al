report 31009849 "Send Absences to HR"
{
    Caption = 'Send Absences to HR';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Teacher; Teacher)
        {
            RequestFilterFields = "No.";
            dataitem(AbsenceDaily; Absence)
            {
                DataItemLink = "Student/Teacher Code No." = FIELD("No.");
                DataItemTableView = SORTING("School Year", "Student/Teacher Code No.", "Absence Type", "Absence Status") WHERE(Blocked = CONST(false), "Incidence Type" = CONST(Absence), "Absence Type" = CONST(Daily));

                trigger OnAfterGetRecord()
                begin
                    NLinha := NLinha + 10000;
                    rAbsenceETRH.Reset;
                    rAbsenceETRH.Init;
                    rAbsenceETRH."School Year" := AbsenceDaily."School Year";
                    rAbsenceETRH."Line No." := NLinha;
                    rAbsenceETRH."Teacher Code No." := AbsenceDaily."Student/Teacher Code No.";
                    rAbsenceETRH.Name := AbsenceDaily."Student Name";
                    rAbsenceETRH.Day := AbsenceDaily.Day;
                    rAbsenceETRH."Incidence Code" := AbsenceDaily."Incidence Code";
                    rAbsenceETRH."Incidence Description" := AbsenceDaily."Incidence Description";
                    rAbsenceETRH."Absence Type" := AbsenceDaily."Absence Type";
                    if (AbsenceDaily."Absence Status" = AbsenceDaily."Absence Status"::Justified) or
                       (AbsenceDaily."Absence Status" = AbsenceDaily."Absence Status"::Justification) then
                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Justified
                    else
                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Unjustified;
                    rAbsenceETRH."Justified Code" := AbsenceDaily."Justified Code";
                    rAbsenceETRH."Justified Description" := AbsenceDaily."Justified Description";
                    rAbsenceETRH."Absence Qtd" := 1;
                    rAbsenceETRH."Results in loss of pay" := AbsenceDaily."Results in loss of pay";
                    rAbsenceETRH.Insert;

                    AbsenceDaily.Blocked := true;
                    AbsenceDaily.Modify;
                end;

                trigger OnPreDataItem()
                begin
                    if SendAbsWithoutLossPay = false then
                        AbsenceDaily.SetRange(AbsenceDaily."Results in loss of pay", true);

                    rSchoolYear.Reset;
                    if rSchoolYear.Get(cStudentRegistration.GetShoolYearActive) then
                        DataIni := rSchoolYear."Starting Date";
                    AbsenceDaily.SetRange(AbsenceDaily.Day, DataIni, SendAbsencesDate);

                    rAbsenceETRH.Reset;
                    rAbsenceETRH.SetRange(rAbsenceETRH."School Year", rSchoolYear."School Year");
                    if rAbsenceETRH.FindLast then
                        NLinha := rAbsenceETRH."Line No.";
                end;
            }
            dataitem(FourAbsenceOneDay; Absence)
            {
                DataItemLink = "Student/Teacher Code No." = FIELD("No.");
                DataItemTableView = SORTING("School Year", "Student/Teacher Code No.", "Absence Type", Day) WHERE(Blocked = CONST(false), "Incidence Type" = CONST(Absence), "Absence Type" = CONST(Lecture), "Results in loss of pay" = CONST(true));

                trigger OnAfterGetRecord()
                begin
                    Total := Total + FourAbsenceOneDay.Qtd;


                    //sections
                    if Total >= 4 then begin
                        l_rAbsence.Reset;
                        l_rAbsence.SetRange(l_rAbsence."School Year", FourAbsenceOneDay."School Year");
                        l_rAbsence.SetRange(l_rAbsence."Student/Teacher", l_rAbsence."Student/Teacher"::Teacher);
                        l_rAbsence.SetRange(l_rAbsence."Student/Teacher Code No.", FourAbsenceOneDay."Student/Teacher Code No.");
                        l_rAbsence.SetRange(l_rAbsence.Day, FourAbsenceOneDay.Day);
                        l_rAbsence.SetRange(l_rAbsence."Incidence Type", l_rAbsence."Incidence Type"::Absence);
                        l_rAbsence.SetRange(l_rAbsence."Absence Type", l_rAbsence."Absence Type"::Lecture);
                        l_rAbsence.SetRange(l_rAbsence."Results in loss of pay", true);
                        l_rAbsence.SetRange(l_rAbsence.Blocked, false);
                        l_rAbsence.ModifyAll(l_rAbsence.Blocked, true);

                        rAbsenceETRH.Reset;
                        rAbsenceETRH.SetRange(rAbsenceETRH."School Year", rSchoolYear."School Year");
                        if rAbsenceETRH.FindLast then
                            NLinha := rAbsenceETRH."Line No.";

                        NLinha := NLinha + 10000;
                        rAbsenceETRH.Reset;
                        rAbsenceETRH.Init;
                        rAbsenceETRH."School Year" := FourAbsenceOneDay."School Year";
                        rAbsenceETRH."Line No." := NLinha;
                        rAbsenceETRH."Teacher Code No." := FourAbsenceOneDay."Student/Teacher Code No.";
                        rAbsenceETRH.Name := FourAbsenceOneDay."Student Name";
                        rAbsenceETRH.Day := FourAbsenceOneDay.Day;
                        rAbsenceETRH."Incidence Code" := FourAbsenceOneDay."Incidence Code";
                        rAbsenceETRH."Incidence Description" := FourAbsenceOneDay."Incidence Description";
                        rAbsenceETRH."Absence Type" := rAbsenceETRH."Absence Type"::Daily;
                        if (FourAbsenceOneDay."Absence Status" = FourAbsenceOneDay."Absence Status"::Justified) or
                           (FourAbsenceOneDay."Absence Status" = FourAbsenceOneDay."Absence Status"::Justification) then
                            rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Justified
                        else
                            rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Unjustified;
                        rAbsenceETRH."Justified Code" := FourAbsenceOneDay."Justified Code";
                        rAbsenceETRH."Justified Description" := FourAbsenceOneDay."Justified Description";
                        rAbsenceETRH."Absence Qtd" := 1;
                        rAbsenceETRH."Results in loss of pay" := FourAbsenceOneDay."Results in loss of pay";
                        rAbsenceETRH.Insert;
                    end;
                end;

                // trigger OnPreDataItem()
                // begin
                //     CurrReport.CreateTotals(Total);
                // end;
            }
            dataitem(AbsenceLecture; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                begin

                    //As faltas com perca de remuneração são juntas para dar origem a 1 dia
                    //---------------------------------------------------------------------

                    rAbsence.Reset;
                    rAbsence.SetCurrentKey("School Year", "Student/Teacher Code No.", "Absence Type", "Absence Status");
                    rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Teacher);
                    rAbsence.SetRange(rAbsence."Student/Teacher Code No.", Teacher."No.");
                    rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
                    rAbsence.SetRange(rAbsence."Absence Type", rAbsence."Absence Type"::Lecture);
                    rAbsence.SetRange(rAbsence.Blocked, false);
                    rAbsence.SetRange(rAbsence."Results in loss of pay", true);
                    rSchoolYear.Reset;
                    if rSchoolYear.Get(cStudentRegistration.GetShoolYearActive) then
                        DataIni := rSchoolYear."Starting Date";
                    rAbsence.SetRange(rAbsence.Day, DataIni, SendAbsencesDate);

                    if rAbsence.Find('-') then begin
                        Contador := 0;
                        NLin := 0;
                        repeat
                            Contador := Contador + rAbsence.Qtd;
                            rAbsence.Mark(true);

                            Clear(i);
                            for i := 1 to rAbsence.Qtd do begin
                                NLin := NLin + 10000;
                                if (rAbsence."Absence Status" = rAbsence."Absence Status"::Justified) or
                                   (rAbsence."Absence Status" = rAbsence."Absence Status"::Justification) then begin
                                    TempAbsenceJust.Init;
                                    TempAbsenceJust.TransferFields(rAbsence);
                                    TempAbsenceJust."Line No." := NLin;
                                    TempAbsenceJust.Insert;
                                end;

                                if rAbsence."Absence Status" = rAbsence."Absence Status"::Unjustified then begin
                                    TempAbsenceUnj.Init;
                                    TempAbsenceUnj.TransferFields(rAbsence);
                                    TempAbsenceUnj."Line No." := NLin;
                                    TempAbsenceUnj.Insert;
                                end;
                            end;

                            if Contador = DailyEquityAbs then begin

                                rAbsenceETRH.Reset;
                                rAbsenceETRH.SetRange(rAbsenceETRH."School Year", rSchoolYear."School Year");
                                if rAbsenceETRH.FindLast then
                                    NLinha := rAbsenceETRH."Line No.";

                                if TempAbsenceJust.Count <> 0 then begin
                                    NLinha := NLinha + 10000;
                                    rAbsenceETRH.Init;
                                    rAbsenceETRH."School Year" := TempAbsenceJust."School Year";
                                    rAbsenceETRH."Line No." := NLinha;
                                    rAbsenceETRH."Teacher Code No." := TempAbsenceJust."Student/Teacher Code No.";
                                    rAbsenceETRH.Name := TempAbsenceJust."Student Name";
                                    rAbsenceETRH.Day := TempAbsenceJust.Day;
                                    rAbsenceETRH."Incidence Code" := TempAbsenceJust."Incidence Code";
                                    rAbsenceETRH."Incidence Description" := TempAbsenceJust."Incidence Description";
                                    rAbsenceETRH."Absence Type" := rAbsenceETRH."Absence Type"::Daily;
                                    if (TempAbsenceJust."Absence Status" = TempAbsenceJust."Absence Status"::Justified) or
                                       (TempAbsenceJust."Absence Status" = TempAbsenceJust."Absence Status"::Justification) then
                                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Justified
                                    else
                                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Unjustified;
                                    rAbsenceETRH."Justified Code" := TempAbsenceJust."Justified Code";
                                    rAbsenceETRH."Justified Description" := TempAbsenceJust."Justified Description";
                                    rAbsenceETRH."Absence Qtd" := (1 * TempAbsenceJust.Count) / DailyEquityAbs;
                                    rAbsenceETRH."Results in loss of pay" := TempAbsenceJust."Results in loss of pay";
                                    rAbsenceETRH.Insert;
                                end;

                                if TempAbsenceUnj.Count <> 0 then begin
                                    NLinha := NLinha + 10000;
                                    rAbsenceETRH.Init;
                                    rAbsenceETRH."School Year" := TempAbsenceUnj."School Year";
                                    rAbsenceETRH."Line No." := NLinha;
                                    rAbsenceETRH."Teacher Code No." := TempAbsenceUnj."Student/Teacher Code No.";
                                    rAbsenceETRH.Name := TempAbsenceUnj."Student Name";
                                    rAbsenceETRH.Day := TempAbsenceUnj.Day;
                                    rAbsenceETRH."Incidence Code" := TempAbsenceUnj."Incidence Code";
                                    rAbsenceETRH."Incidence Description" := TempAbsenceUnj."Incidence Description";
                                    rAbsenceETRH."Absence Type" := rAbsenceETRH."Absence Type"::Daily;
                                    if (TempAbsenceUnj."Absence Status" = TempAbsenceUnj."Absence Status"::Justified) or
                                       (TempAbsenceUnj."Absence Status" = TempAbsenceUnj."Absence Status"::Justification) then
                                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Justified
                                    else
                                        rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Unjustified;
                                    rAbsenceETRH."Justified Code" := TempAbsenceUnj."Justified Code";
                                    rAbsenceETRH."Justified Description" := TempAbsenceUnj."Justified Description";
                                    rAbsenceETRH."Absence Qtd" := (1 * TempAbsenceUnj.Count) / DailyEquityAbs;
                                    rAbsenceETRH."Results in loss of pay" := TempAbsenceUnj."Results in loss of pay";
                                    rAbsenceETRH.Insert;
                                end;

                                TempAbsenceUnj.DeleteAll;
                                TempAbsenceJust.DeleteAll;
                                Clear(TempAbsenceUnj);
                                Clear(TempAbsenceJust);

                                Contador := 0;
                                rAbsenceAux.Copy(rAbsence);
                                rAbsenceAux.MarkedOnly(true);
                                rAbsenceAux.ModifyAll(rAbsenceAux.Blocked, true);
                            end;
                        until rAbsence.Next = 0;
                    end;



                    //Se escolheu a opção de enviar as faltas sem perda de remuneração, então estas são enviadas tal como estão
                    //--------------------------------------------------------------------------------------------------------
                    if SendAbsWithoutLossPay = true then begin
                        rAbsence.Reset;
                        rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Teacher);
                        rAbsence.SetRange(rAbsence."Student/Teacher Code No.", Teacher."No.");
                        rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
                        rAbsence.SetRange(rAbsence."Absence Type", rAbsence."Absence Type"::Lecture);
                        rAbsence.SetRange(rAbsence.Blocked, false);
                        rAbsence.SetRange(rAbsence."Results in loss of pay", false);
                        rSchoolYear.Reset;
                        if rSchoolYear.Get(cStudentRegistration.GetShoolYearActive) then
                            DataIni := rSchoolYear."Starting Date";
                        rAbsence.SetRange(rAbsence.Day, DataIni, SendAbsencesDate);

                        if rAbsence.Find('-') then begin
                            repeat
                                rAbsenceETRH.Reset;
                                rAbsenceETRH.SetRange(rAbsenceETRH."School Year", rSchoolYear."School Year");
                                if rAbsenceETRH.FindLast then
                                    NLinha := rAbsenceETRH."Line No.";
                                NLinha := NLinha + 10000;
                                rAbsenceETRH.Init;
                                rAbsenceETRH."School Year" := rAbsence."School Year";
                                rAbsenceETRH."Line No." := NLinha;
                                rAbsenceETRH."Teacher Code No." := rAbsence."Student/Teacher Code No.";
                                rAbsenceETRH.Name := rAbsence."Student Name";
                                rAbsenceETRH.Day := rAbsence.Day;
                                rAbsenceETRH."Incidence Code" := rAbsence."Incidence Code";
                                rAbsenceETRH."Incidence Description" := rAbsence."Incidence Description";
                                rAbsenceETRH."Absence Type" := rAbsence."Absence Type";
                                if (rAbsence."Absence Status" = rAbsence."Absence Status"::Justified) or
                                   (rAbsence."Absence Status" = rAbsence."Absence Status"::Justification) then
                                    rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Justified
                                else
                                    rAbsenceETRH."Absence Status" := rAbsenceETRH."Absence Status"::Unjustified;
                                rAbsenceETRH."Justified Code" := rAbsence."Justified Code";
                                rAbsenceETRH."Justified Description" := rAbsence."Justified Description";
                                rAbsenceETRH."Absence Qtd" := 1;
                                rAbsenceETRH."Results in loss of pay" := rAbsence."Results in loss of pay";
                                rAbsenceETRH.Insert;

                                rAbsence.Blocked := true;
                                rAbsence.Modify;

                            until rAbsence.Next = 0;
                        end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DailyEquityAbs := Teacher."Daily Equity Absences";

                TempAbsenceUnj.DeleteAll;
                TempAbsenceJust.DeleteAll;
                Clear(TempAbsenceUnj);
                Clear(TempAbsenceJust);
            end;
        }
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
                    field(SendAbsencesDate; SendAbsencesDate)
                    {
                        Caption = 'Send absences until date';
                    }
                    field(SendAbsWithoutLossPay; SendAbsWithoutLossPay)
                    {
                        Caption = 'Send absence without loss of pay';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            SendAbsencesDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if SendAbsencesDate = 0D then Error(Text0001);
    end;

    var
        rAbsenceETRH: Record "Absence ET-RH";
        rSchoolYear: Record "School Year";
        rAbsence: Record Absence;
        rAbsenceAux: Record Absence;
        rDate: Record Date;
        TempAbsenceUnj: Record Absence temporary;
        TempAbsenceJust: Record Absence temporary;
        cStudentRegistration: Codeunit "Students Registration";
        SendAbsencesDate: Date;
        SendAbsWithoutLossPay: Boolean;
        NLinha: Integer;
        Text0001: Label 'You must fill the date.';
        DataIni: Date;
        DailyEquityAbs: Integer;
        Contador: Integer;
        Total: Decimal;
        i: Integer;
        NLin: Integer;
        l_rAbsence: Record Absence;
}

