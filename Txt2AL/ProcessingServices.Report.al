report 31009750 "Processing Services"
{
    // //IT001 - ET: 2016.09.19 - Foi eliminado o campo Use Student Unit Price
    // //Caso o Aluno tenha um preço diferente basta preencher o novo preço na atribuição dos serviços

    Caption = 'Processing Services';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Registration; Registration)
        {
            DataItemTableView = SORTING("Student Code No.", "School Year") ORDER(Ascending) WHERE(Status = FILTER(Subscribed | " "));
            RequestFilterFields = "Student Code No.", "School Year", "Schooling Year";
            dataitem("Student Service Plan"; "Student Service Plan")
            {
                DataItemLink = "Student No." = FIELD("Student Code No."), "School Year" = FIELD("School Year");
                DataItemTableView = SORTING("Student No.", "School Year", "Schooling Year", "Service Code", "Line No.") ORDER(Ascending) WHERE(Selected = CONST(true));
                dataitem("Services Distributed by Entity"; "Services Distributed by Entity")
                {
                    DataItemLink = "School Year" = FIELD("School Year"), "Student No." = FIELD("Student No."), "Service Code" = FIELD("Service Code");
                    DataItemTableView = SORTING("School Year", "Student No.", "Line No.") ORDER(Ascending) WHERE("Percent %" = FILTER(<> 0));

                    trigger OnAfterGetRecord()
                    var
                        l_StudLedgerEntry: Record "Student Ledger Entry";
                        l_StudLedgerEntry_2: Record "Student Ledger Entry";
                        l_StudLedgerEntryProcess: Record "Student Ledger Entry";
                        rServices: Record "Services ET";
                    begin
                        if "Services Distributed by Entity".Type = "Services Distributed by Entity".Type::Service then begin//IT001 - ET: 2016.11.03 - Coloquei o IF pois pode haver linhas com produtos
                            //CheckDependingService
                            if rServicesET.Get("Service Code") and (rServicesET."Service Depending Other") then
                                if rServicesET2.Get(rServicesET."Service Depending Code") then
                                    if not CheckMonthForDepending(rServicesET2) then
                                        CurrReport.Skip;

                            //Test if the sum of all entitys for this service is 100%
                            ServicesDistEntity.Reset;
                            ServicesDistEntity.SetCurrentKey("Service Code", "School Year", "Schooling Year", "Student No.");
                            ServicesDistEntity.SetRange("Service Code", "Service Code");
                            ServicesDistEntity.SetRange("School Year", "School Year");
                            ServicesDistEntity.SetRange("Schooling Year", "Schooling Year");
                            ServicesDistEntity.SetRange("Student No.", "Student No.");
                            if ServicesDistEntity.Find('-') then begin
                                ServicesDistEntity.CalcSums("Percent %");
                                if ServicesDistEntity."Percent %" <> 100 then
                                    Error(Text0007, ServicesDistEntity."Service Code", ServicesDistEntity.Description, "Student No.");
                            end;

                            rServices.Get("Services Distributed by Entity"."Service Code");

                            l_StudLedgerEntry_2.Reset;
                            if l_StudLedgerEntry_2.FindLast then
                                NextEntryNo := l_StudLedgerEntry_2."Entry No." + 1
                            else
                                NextEntryNo := 1;



                            l_StudLedgerEntry_2.Reset;
                            l_StudLedgerEntry_2.SetRange("Student No.", "Student No.");
                            l_StudLedgerEntry_2.SetRange("School Year", "School Year");
                            l_StudLedgerEntry_2.SetRange("Schooling Year", "Schooling Year");
                            if l_StudLedgerEntry_2.FindLast then
                                LineNo := l_StudLedgerEntry_2."Line No." + 10000
                            else
                                LineNo := 10000;

                            l_StudLedgerEntry.LockTable;

                            l_StudLedgerEntry.Init;
                            l_StudLedgerEntry.Validate("Student No.", "Services Distributed by Entity"."Student No.");
                            l_StudLedgerEntry."School Year" := "Services Distributed by Entity"."School Year";
                            l_StudLedgerEntry."Schooling Year" := "Services Distributed by Entity"."Schooling Year";

                            l_StudLedgerEntry."Entry No." := NextEntryNo;
                            l_StudLedgerEntry.Kinship := "Services Distributed by Entity".Kinship;
                            l_StudLedgerEntry.Type := l_StudLedgerEntry.Type::Service;
                            l_StudLedgerEntry.Class := Registration.Class;
                            l_StudLedgerEntry."Line No." := LineNo;
                            l_StudLedgerEntry."Posting Date" := PostingDate;
                            l_StudLedgerEntry.Validate("Entity ID", "Services Distributed by Entity"."No.");
                            l_StudLedgerEntry."Percent %" := "Services Distributed by Entity"."Percent %";
                            l_StudLedgerEntry.Validate("Service Code", "Service Code");

                            //CPA - sn
                            //IF rServicesET.GET("Service Code") AND rServicesET."Use Student Unit Price" THEN
                            //  l_StudLedgerEntry."Unit Price" := "Student Service Plan"."Student Unit Price";
                            if "Student Service Plan"."Student Unit Price" = 0 then begin
                                if rServices.Get("Service Code") then
                                    l_StudLedgerEntry."Unit Price" := rServices."Unit Price";
                            end else
                                l_StudLedgerEntry."Unit Price" := "Student Service Plan"."Student Unit Price";
                            //CPA - en

                            //IT001 - ET: 2016.09.19 - Foi eliminado o campo Use Student Unit Price
                            //    IF rServicesET.GET("Service Code") AND (rServicesET."Service Depending Other") THEN
                            //      IF rServicesET2.GET(rServicesET."Service Depending Code") THEN
                            //        IF rServicesET2."Use Student Unit Price" THEN BEGIN
                            //          rStudentServicePlan.RESET;
                            //          rStudentServicePlan.SETRANGE("Student No.",Registration."Student Code No.");
                            //          rStudentServicePlan.SETRANGE("School Year",Registration."School Year");
                            //          rStudentServicePlan.SETRANGE(Selected,TRUE);
                            //          rStudentServicePlan.SETRANGE("Service Code",rServicesET2."No.");
                            //          IF rStudentServicePlan.FINDFIRST THEN
                            //           l_StudLedgerEntry."Unit Price" := ((rStudentServicePlan."Student Unit Price") * (rServicesET."Percent %") /100)
                            //        END ELSE
                            //            l_StudLedgerEntry."Unit Price" := (rServicesET2."Unit Price" * rServicesET."Percent %") / 100;
                            //Novo código
                            if rServicesET.Get("Service Code") and (rServicesET."Service Depending Other") then
                                if rServicesET2.Get(rServicesET."Service Depending Code") then begin
                                    rStudentServicePlan.Reset;
                                    rStudentServicePlan.SetRange("Student No.", Registration."Student Code No.");
                                    rStudentServicePlan.SetRange("School Year", Registration."School Year");
                                    rStudentServicePlan.SetRange(Selected, true);
                                    rStudentServicePlan.SetRange("Service Code", rServicesET2."No.");
                                    if rStudentServicePlan.FindFirst then
                                        l_StudLedgerEntry."Unit Price" := ((rStudentServicePlan."Student Unit Price") * (rServicesET."Percent %") / 100)
                                end;
                            //IT001 - ET: 2016.09.19 - en

                            l_StudLedgerEntry.Validate(Quantity, "Student Service Plan".Quantity);
                            l_StudLedgerEntry."Service Type" := "Student Service Plan"."Service Type";
                            l_StudLedgerEntry."Responsibility Center" := "Student Service Plan"."Responsibility Center";
                            l_StudLedgerEntry.Processed := true;
                            l_StudLedgerEntry."User ID" := UserId;
                            l_StudLedgerEntry.Company := rServices.Company;
                            l_StudLedgerEntry."Last Date Modified" := Today;
                            if not l_StudLedgerEntry.Insert then
                                l_StudLedgerEntry.Modify;

                            flag := true;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not ValidateProcessService("Student Service Plan") then
                        CurrReport.Skip;
                end;

                trigger OnPostDataItem()
                begin

                    if ("Student Service Plan".Count = 0) and (Registration.GetFilter("Student Code No.") <> '')
                    and (Registration.Count = 1) then
                        Error(Text0010);
                end;

                trigger OnPreDataItem()
                begin
                    if cUserEducation.GetEducationFilter(UserId) <> '' then
                        SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));

                    FilterStudentServPlan;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ValidateService;

                //Valida se o aluno tem alguma entidade pagadora para o ano letivo.
                UsersFamilyStudents.Reset;
                UsersFamilyStudents.SetRange("School Year", Registration."School Year");
                UsersFamilyStudents.SetRange("Student Code No.", Registration."Student Code No.");
                UsersFamilyStudents.SetRange("Paying Entity", true);
                if not UsersFamilyStudents.Find('-') then
                    Error(Text012, Registration."Student Code No.");
            end;

            trigger OnPreDataItem()
            begin
                if ResCenter <> '' then
                    SetFilter("Responsibility Center", ResCenter);

                if cUserEducation.GetEducationFilter(UserId) <> '' then
                    SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));

                MessageIfEntry := false;
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
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                    }
                    field(Month; optionMes)
                    {
                        Caption = 'Mês';
                        ApplicationArea = Basic, Suite;

                    }

                    field("ResCenter"; ResCenter)
                    {
                        Caption = 'Centro de Responsabilidade';
                        ApplicationArea = Basic, Suite;
                        TableRelation = "Responsibility Center";

                        trigger OnAssistEdit()
                        var
                            l_PageResCenterList: Page "Responsibility Center List";
                            l_RecResCenter: Record "Responsibility Center";
                        begin
                            l_RecResCenter.RESET;
                            if l_RecResCenter.findset then begin
                                Clear(l_PageResCenterList);
                                l_PageResCenterList.SetTableView(l_RecResCenter);
                                l_PageResCenterList.LookupMode := true;
                                if l_PageResCenterList.RunModal() = Action::LookupOK then begin
                                    l_PageResCenterList.SetSelectionFilter(l_RecResCenter);
                                    if l_RecResCenter.findset then begin
                                        Clear(ResCenter);
                                        repeat
                                            if ResCenter = '' then
                                                ResCenter := l_RecResCenter.Code
                                            else
                                                ResCenter += '|' + l_RecResCenter.Code;

                                        until l_RecResCenter.Next() = 0;
                                    end;
                                end;
                            end;
                        end;
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

    trigger OnInitReport()
    begin
        //Year := DATE2DMY(WORKDATE,3);
        ReplaceServices := false;
    end;

    trigger OnPostReport()
    begin
        if flag then
            Message(Text0005)
        else
            Message(Text0013);
    end;

    trigger OnPreReport()
    begin
        if PostingDate = 0D then
            Error(Text0001);


        if Registration.GetFilter("School Year") = '' then
            Error(Text0008);

        if rSchoolYear.Get(Registration.GetFilter("School Year")) then begin
            rSchoolYear.TestField("Starting Date");
            rSchoolYear.TestField("Ending Date");
            if not (PostingDate >= rSchoolYear."Starting Date") and (PostingDate <= rSchoolYear."Ending Date") then
                Error(Text0009, rSchoolYear."Starting Date", rSchoolYear."Ending Date");


        end;
        flag := false;
    end;

    var
        Text0001: Label 'A date must be set';
        Text0002: Label 'A Year must be defined';
        Text0003: Label 'Processing services for the day %1 to %2 to %3. \ Wish to proceed?';
        Text0004: Label 'Operation interrupted by the user';
        LineNo: Integer;
        Text0005: Label 'Process Finished';
        Text0006: Label 'The Service is already Processed  for %1. \ Replace the  Service  exists?';
        NextEntryNo: Integer;
        ReplaceServices: Boolean;
        PostingDate: Date;
        optionMes: Integer;
        BeginDate: Date;
        EndDate: Date;
        ServicesDistEntity: Record "Services Distributed by Entity";
        Text0007: Label 'The Service %1 -  %2 must have 100% of allocation, for the student %3';
        Text0008: Label 'School year is Mandatory';
        rSchoolYear: Record "School Year";
        Text0009: Label 'Posting Date must be between %1 and %2.';
        Text0010: Label 'Nothing to process to the selected month';
        UsersFamilyStudents: Record "Users Family / Students";
        cUserEducation: Codeunit "User Education";
        cStudentServices: Codeunit "Student Services";
        MessageIfEntry: Boolean;
        Text0011: Label 'The Service(s) is/are already processed for one or more students.\ Do you wish to substitute the existing Service(s)?';
        Text012: Label 'The Student %1 does not have any Paying Entity associated';
        Text0013: Label 'Nothing to process to the selected month.';
        flag: Boolean;
        rServicesET: Record "Services ET";
        rServicesET2: Record "Services ET";
        rStudentServicePlan: Record "Student Service Plan";
        ResCenter: Text[250];

    //[Scope('OnPrem')]
    procedure FilterStudentServPlan()
    begin
        Evaluate(optionMes, Format(PostingDate, 0, '<Month>'));

        if optionMes = 1 then
            "Student Service Plan".SetRange(January, true);
        if optionMes = 2 then
            "Student Service Plan".SetRange(February, true);
        if optionMes = 3 then
            "Student Service Plan".SetRange(March, true);
        if optionMes = 4 then
            "Student Service Plan".SetRange(April, true);
        if optionMes = 5 then
            "Student Service Plan".SetRange(May, true);
        if optionMes = 6 then
            "Student Service Plan".SetRange(June, true);
        if optionMes = 7 then
            "Student Service Plan".SetRange(July, true);
        if optionMes = 8 then
            "Student Service Plan".SetRange(August, true);
        if optionMes = 9 then
            "Student Service Plan".SetRange(Setember, true);
        if optionMes = 10 then
            "Student Service Plan".SetRange(October, true);
        if optionMes = 11 then
            "Student Service Plan".SetRange(November, true);
        if optionMes = 12 then
            "Student Service Plan".SetRange(Dezember, true);
    end;

    //[Scope('OnPrem')]
    procedure ValidateService() stopProcess: Boolean
    var
        l_StudLedgerEntry: Record "Student Ledger Entry";
        l_SalesHeader: Record "Sales Header";
        l_SalesLine: Record "Sales Line";
    begin
        // no caso de já existirem serviços processados para o mesmo mês, é necessario
        // perguntar ao utilizador se realmente deseja efectuar um novo processamento

        BeginDate := 0D;
        EndDate := 0D;

        cStudentServices.FilterDate(PostingDate, BeginDate, EndDate);

        l_StudLedgerEntry.Reset;
        l_StudLedgerEntry.SetRange("Student No.", Registration."Student Code No.");
        l_StudLedgerEntry.SetRange("School Year", Registration."School Year");
        l_StudLedgerEntry.SetRange("Schooling Year", Registration."Schooling Year");
        l_StudLedgerEntry.SetRange("Posting Date", BeginDate, EndDate);
        l_StudLedgerEntry.SetRange(Registed, false);
        if l_StudLedgerEntry.Find('-') then begin

            //Valida se estamos a correr para um aluno ou varios para dar a mensagem para o aluno ou global.
            //Se global so mostra uma mensagem
            if Registration.Count = 1 then begin
                if Confirm(StrSubstNo(Text0006, PostingDate)) = false then begin
                    Message(Text0004);
                    CurrReport.Quit;
                end
                else begin
                    repeat
                        if (l_StudLedgerEntry.Company <> '') and (l_StudLedgerEntry."Invoice No." <> '') then begin
                            Clear(l_SalesHeader);
                            l_SalesHeader.ChangeCompany(l_StudLedgerEntry.Company);
                            if l_SalesHeader.Get(l_SalesHeader."Document Type"::Invoice, l_StudLedgerEntry."Invoice No.") then begin
                                l_SalesHeader.Delete;
                                Clear(l_SalesLine);
                                l_SalesLine.ChangeCompany(l_StudLedgerEntry.Company);
                                l_SalesLine.SetRange("Document Type", l_SalesLine."Document Type"::Invoice);
                                l_SalesLine.SetRange("Document No.", l_StudLedgerEntry."Invoice No.");
                                l_SalesLine.DeleteAll;
                            end;
                        end;
                    until l_StudLedgerEntry.Next = 0;
                    l_StudLedgerEntry.DeleteAll;
                end;
            end else begin
                if not MessageIfEntry then begin
                    if Confirm(StrSubstNo(Text0011)) = false then begin
                        Message(Text0004);
                        CurrReport.Quit;
                    end else begin
                        repeat
                            if (l_StudLedgerEntry.Company <> '') and (l_StudLedgerEntry."Invoice No." <> '') then begin
                                Clear(l_SalesHeader);
                                l_SalesHeader.ChangeCompany(l_StudLedgerEntry.Company);
                                if l_SalesHeader.Get(l_SalesHeader."Document Type"::Invoice, l_StudLedgerEntry."Invoice No.") then begin
                                    l_SalesHeader.Delete;
                                    Clear(l_SalesLine);
                                    l_SalesLine.ChangeCompany(l_StudLedgerEntry.Company);
                                    l_SalesLine.SetRange("Document Type", l_SalesLine."Document Type"::Invoice);
                                    l_SalesLine.SetRange("Document No.", l_StudLedgerEntry."Invoice No.");
                                    l_SalesLine.DeleteAll;
                                end;
                            end;
                        until l_StudLedgerEntry.Next = 0;
                        l_StudLedgerEntry.DeleteAll;
                        MessageIfEntry := true;
                    end;
                end else begin
                    repeat
                        if (l_StudLedgerEntry.Company <> '') and (l_StudLedgerEntry."Invoice No." <> '') then begin
                            Clear(l_SalesHeader);
                            l_SalesHeader.ChangeCompany(l_StudLedgerEntry.Company);
                            if l_SalesHeader.Get(l_SalesHeader."Document Type"::Invoice, l_StudLedgerEntry."Invoice No.") then begin
                                l_SalesHeader.Delete;
                                Clear(l_SalesLine);
                                l_SalesLine.ChangeCompany(l_StudLedgerEntry.Company);
                                l_SalesLine.SetRange("Document Type", l_SalesLine."Document Type"::Invoice);
                                l_SalesLine.SetRange("Document No.", l_StudLedgerEntry."Invoice No.");
                                l_SalesLine.DeleteAll;
                            end;
                        end;
                    until l_StudLedgerEntry.Next = 0;
                    l_StudLedgerEntry.DeleteAll;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateProcessService(pStudentServicePlan: Record "Student Service Plan"): Boolean
    var
        rStudentLedgerEntry: Record "Student Ledger Entry";
        rDetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
        Text00001: Label 'Unable to handle services for this month because the monthly bill is already payed.';
        rServices: Record "Services ET";
        varAno: Integer;
        varMes: Integer;
        varDia: Integer;
        varInitialDate: Date;
        varEndDate: Date;
        Status: Boolean;
    begin
        //----------------------------------------------------------------------------------------------------------------------------------
        //Processar Serviços para um determinado mês - 10.07.2008
        //----------------------------------------------------------------------------------------------------------------------------------

        Status := true;

        //Nao processa os serviços que ja foram processados e que não podem ser processados novamente no mesmo mês
        if rServices.Get(pStudentServicePlan."Service Code") and
           not (rServices."Multiple invoices per month") then begin

            //Vai validar se ja temos Faturas feitas para o mes sem notas de crédito para o servico
            rStudentLedgerEntry.Reset;
            rStudentLedgerEntry.SetRange("Student No.", pStudentServicePlan."Student No.");
            rStudentLedgerEntry.SetRange("School Year", pStudentServicePlan."School Year");
            rStudentLedgerEntry.SetRange("Service Code", pStudentServicePlan."Service Code");
            rStudentLedgerEntry.SetRange(Registed, true);
            rStudentLedgerEntry.SetRange("Posting Date", CalcDate('<-CM>', PostingDate), CalcDate('<+CM>', PostingDate));
            if rStudentLedgerEntry.Find('-') then begin
                repeat
                    rStudentLedgerEntry.CalcFields("Amount In Cre. Memo");
                    if rStudentLedgerEntry."Amount In Cre. Memo" <> rStudentLedgerEntry.Amount then
                        Status := false
                    else
                        Status := true;
                until (rStudentLedgerEntry.Next = 0);
            end;
        end else
            Status := true;


        exit(Status);
    end;

    //[Scope('OnPrem')]
    procedure CheckMonthForDepending(pServicesEt: Record "Services ET"): Boolean
    begin
        Evaluate(optionMes, Format(PostingDate, 0, '<Month>'));

        if optionMes = 1 then
            pServicesEt.SetRange(January, true);
        if optionMes = 2 then
            pServicesEt.SetRange(February, true);
        if optionMes = 3 then
            pServicesEt.SetRange(March, true);
        if optionMes = 4 then
            pServicesEt.SetRange(April, true);
        if optionMes = 5 then
            pServicesEt.SetRange(May, true);
        if optionMes = 6 then
            pServicesEt.SetRange(June, true);
        if optionMes = 7 then
            pServicesEt.SetRange(July, true);
        if optionMes = 8 then
            pServicesEt.SetRange(August, true);
        if optionMes = 9 then
            pServicesEt.SetRange(Setember, true);
        if optionMes = 10 then
            pServicesEt.SetRange(October, true);
        if optionMes = 11 then
            pServicesEt.SetRange(November, true);
        if optionMes = 12 then
            pServicesEt.SetRange(December, true);

        if not pServicesEt.FindFirst then
            exit(false)
        else
            exit(true);
    end;
}

