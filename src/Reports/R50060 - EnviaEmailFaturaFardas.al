report 50060 EnviaEmailFaturaFardas
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Enviar Fatura Fardas Email';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            trigger OnPreDataItem()
            begin
                //Saber o caminho dos PDF's
                rCommentLine.RESET;
                rCommentLine.SETRANGE("Table Name", rCommentLine."Table Name"::"E-Mail");
                rCommentLine.SETRANGE("No.", Text0005);
                rCommentLine.SETRANGE("Document Type", rCommentLine."Document Type"::InvoiceItem);
                IF rCommentLine.FINDFIRST THEN
                    CaminhoPDF := rCommentLine."Caminho PDFs";
            end;

            trigger OnAfterGetRecord()
            var
                rCustomer: Record Customer;
                SalesCrMemoHeader: Record "Sales Cr.Memo Header";
            begin
                CLEAR(rTempNotaC);

                IF recCustomer.GET("Sales Invoice Header"."Bill-to Customer No.") THEN BEGIN
                    rCustomer.RESET;
                    IF rCustomer.GET("Sales Invoice Header"."Bill-to Customer No.") THEN BEGIN
                        fCreateAttachPDFFact("Sales Invoice Header"."No.", rCustomer."E-Mail");
                        //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
                        IF rCustomer."E-Mail2" <> '' THEN
                            fCreateAttachPDFFact("Sales Invoice Header"."No.", rCustomer."E-Mail2");
                        //IT004 - Park - 2018.01.10 - en

                        //Reportar tb as notas de crédito associadas a esta fatura
                        SalesCrMemoHeader.RESET;
                        SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                        SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."Applies-to Doc. No.", "Sales Invoice Header"."No.");
                        IF SalesCrMemoHeader.FINDSET THEN BEGIN
                            REPEAT
                                fCreateAttachPDFNC(SalesCrMemoHeader."No.", rCustomer."E-Mail", "Sales Invoice Header"."No.");
                                //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
                                IF rCustomer."E-Mail2" <> '' THEN
                                    fCreateAttachPDFNC(SalesCrMemoHeader."No.", rCustomer."E-Mail2", "Sales Invoice Header"."No.");
                            //IT004 - Park - 2018.01.10 - en

                            UNTIL SalesCrMemoHeader.NEXT = 0;
                        END;

                    END;
                END;

                IF recCustomer.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                    recUsersFamilyStudents.RESET;
                    recUsersFamilyStudents.SETRANGE("Student Code No.", recCustomer."Student No.");
                    recUsersFamilyStudents.SETRANGE("Send By Email", TRUE);
                    recUsersFamilyStudents.SETRANGE(recUsersFamilyStudents."School Year", cStudentRegistration.GetShoolYearActive);
                    IF recUsersFamilyStudents.FIND('-') THEN BEGIN
                        REPEAT
                            IF recUsersFamily.GET(recUsersFamilyStudents."No.") THEN BEGIN
                                fCreateAttachPDFFact("Sales Invoice Header"."No.", recUsersFamily."E-mail");
                                //Reportar tb as notas de crédito associadas a esta fatura
                                SalesCrMemoHeader.RESET;
                                SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                SalesCrMemoHeader.SETRANGE(SalesCrMemoHeader."Applies-to Doc. No.", "Sales Invoice Header"."No.");
                                IF SalesCrMemoHeader.FINDSET THEN BEGIN
                                    REPEAT
                                        fCreateAttachPDFNC(SalesCrMemoHeader."No.", rCustomer."E-Mail", "Sales Invoice Header"."No.");
                                    UNTIL SalesCrMemoHeader.NEXT = 0;
                                END;
                            END;

                        UNTIL recUsersFamilyStudents.NEXT = 0;
                    END;
                END;
            end;
        }
    }

    var
        rEduConfiguration: Record "Edu. Configuration";
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rTempFact: Record "Cust. Ledger Entry" temporary;
        rTempNotaC: Record "Cust. Ledger Entry" temporary;
        recCustomer: Record Customer;
        recCustomerMail: Record Customer;
        recUsersFamilyStudents: Record "Users Family / Students";
        recUsersFamily: Record "Users Family";
        //Object: Record Object;
        rCompInfo: Record "Company Information";
        rSMTPFields: Record "SMTP Fields";
        rFaturas: Report "PTSS Sales - Invoice (PT)";
        cuPostServET: Codeunit "Post Services ET";
        Mail: Codeunit Mail;
        cStudentRegistration: Codeunit "Students Registration";
        ErrorNo: Integer;
        rCommentLine: Record "Comment Line";
        int: Integer;
        ArrayBod: array[40] of Text[260];
        txtCRLF: Char;
        //SMTPMailSetup: Record "SMTP Mail Setup";
        // varMail: DotNet SmtpMessage;
        vCount: Integer;
        rCredMemo: Report "PTSS Sales - Credit Memo (PT)";
        CaminhoPDF: Text[250];
        Text001: Label 'The email address "%1" is invalid.';
        Text002: Label 'Attachment %1 does not exist or can not be accessed from the program.';
        Text003: Label 'The SMTP mail system returned the following error: %1';
        Text0005: Label 'E-mail Subject';
        Text0006: Label 'E-mail Body';
        Text0007: Label 'MailBody.txt';
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';

    trigger OnPreReport()
    begin
        rTempFact.DELETEALL;
    end;

    trigger OnPostReport()
    begin
        rTempFact.RESET;
        IF rTempFact.FindSet THEN
            REPEAT
                CheckValidEmailAddresses(rTempFact.Description);
                fEnviaEmail(rTempFact."Document No.", rTempFact.Description,
                            rTempFact.Path, CaminhoPDF);
            UNTIL rTempFact.NEXT = 0;

        //MESSAGE('Processo Concluído.');
    end;

    procedure fEnviaEmail(FactNo: Code[50]; EmailCliente: Text[50]; FactPath: Text[260]; FileD: Text[260])
    begin
        //ENVIO DO EMAIL
        //********************************
        IF EmailCliente <> '' THEN BEGIN
            CreateMessage(rCompInfo.Name, '', EmailCliente, '', '', FALSE, FactPath, FileD, FactNo);
        END;
    end;

    procedure CreateMessage(SenderName: Text[100]; SenderAddress: Text[50]; Recipients: Text[1024]; Subject: Text[200]; Body: Text[1024]; HtmlFormatted: Boolean; FileN: Text[260]; FileDir: Text[260]; FactNo: Code[50])
    var
        char10: Char;
        char13: Char;
    begin
        CLEAR(varMail);

        rSMTPFields.GET;
        rSMTPFields.TESTFIELD("SMTP Server Name");

        //IF Recipients <> '' THEN
        //  CheckValidEmailAddresses(Recipients);
        CheckValidEmailAddresses(rSMTPFields."E-Mail From");

        //BC_UPG START SQD RTV 20220907
        //IF ISCLEAR(varMail) THEN
        //CREATE(varMail);
        if not IsNull(varMail) then begin
            varMail.Dispose;
            Clear(varMail);
        end;
        //BC_UPG STOP SQD RTV 20220907

        varMail.FromName := SenderName;
        varMail.FromAddress := rSMTPFields."E-Mail From";
        varMail."To" := Recipients;
        varMail.Bcc := rSMTPFields."E-Mail From Bcc";
        rCommentLine.RESET;
        rCommentLine.SETRANGE("Table Name", rCommentLine."Table Name"::"E-Mail");
        rCommentLine.SETRANGE("No.", Text0005);
        rCommentLine.SETRANGE("Document Type", rCommentLine."Document Type"::InvoiceItem);
        IF rCommentLine.FINDSET THEN BEGIN
            int := rCommentLine.COUNT;

            REPEAT
                IF int = 1 THEN
                    varMail.Subject := rCommentLine.Comment
                ELSE BEGIN
                    varMail.Subject := INSSTR(varMail.Subject, ' ', STRLEN(varMail.Subject) + 1);
                    varMail.Subject := INSSTR(varMail.Subject, rCommentLine.Comment, STRLEN(varMail.Subject) + 1);
                END;

            UNTIL rCommentLine.NEXT = 0;
        END;

        rCommentLine.RESET;
        rCommentLine.SETRANGE("Table Name", rCommentLine."Table Name"::"E-Mail");
        rCommentLine.SETRANGE("No.", Text0006);
        rCommentLine.SETRANGE("Document Type", rCommentLine."Document Type"::InvoiceItem);
        IF rCommentLine.FINDSET THEN BEGIN
            int := rCommentLine.COUNT;
            char10 := 10;
            char13 := 13;
            REPEAT
                IF int = 1 THEN
                    varMail.Body := rCommentLine.Comment
                ELSE BEGIN
                    AppendBody(FORMAT(char13) + FORMAT(char10) + rCommentLine.Comment);
                END;
            UNTIL rCommentLine.NEXT = 0;

        END;

        varMail.HtmlFormatted := HtmlFormatted;

        //BC_UPG START SQD RTV 20220907
        //varMail.AddAttachments(FileDir + FileN);
        varMail.AddAttachmentWithName(FileN, FileDir);
        //BC_UPG STOP SQD RTV 20220907

        //Para anexar também as notas de credito respectivas
        rTempNotaC.RESET;
        rTempNotaC.SETRANGE("Document No.", FactNo);
        IF rTempNotaC.FINDSET THEN BEGIN
            REPEAT
                //BC_UPG START SQD RTV 20220907
                //varMail.AddAttachments(FileDir + rTempNotaC.Path);
                varMail.AddAttachmentWithName(rTempNotaC.Path, FileDir);
            //BC_UPG STOP SQD RTV 20220907
            UNTIL rTempNotaC.NEXT = 0;
        END;


        Send;
    end;

    procedure Send()
    var
        Result: Text[1024];
    begin
        //BC_UPG START SQD RTV 20220907
        /*Result :=
          varMail.Send(
            "SMTP Server Name", FALSE, '', '');*/
        Result := varMail.Send(rSMTPFields."SMTP Server Name", rSMTPFields."SMTP Server Port", false, '', '', true);
        //BC_UPG STOP SQD RTV 20220907

        CLEAR(Mail);

        IF Result <> '' THEN
            ERROR(Text003, Result);

    end;

    procedure AddRecipients(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddRecipients(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    procedure AddCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddCC(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    procedure AddBCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddBCC(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    procedure AppendBody(BodyPart: Text[1024])
    var
        Result: Text[1024];
    begin
        Result := varMail.AppendBody(BodyPart);
        if Result <> '' then
            Error(Text003, Result);
    end;

    procedure AddAttachment(Attachment: Text[260])
    var
        Result: Text[1024];
    begin
        if Attachment = '' then
            exit;
        if not Exists(Attachment) then
            Error(Text002, Attachment);
        Result := varMail.AddAttachments(Attachment);
        if Result <> '' then
            Error(Text003, Result);
    end;

    local procedure CheckValidEmailAddresses(Recipients: Text[1024])
    var
        s: Text[1024];
    begin
        if Recipients = '' then
            Error(Text001, Recipients);

        s := Recipients;
        while StrPos(s, ';') > 1 do begin
            CheckValidEmailAddress(CopyStr(s, 1, StrPos(s, ';') - 1));
            s := CopyStr(s, StrPos(s, ';') + 1);
        end;
        CheckValidEmailAddress(s);
    end;

    local procedure CheckValidEmailAddress(EmailAddress: Text[250])
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        if EmailAddress = '' then
            Error(Text001, EmailAddress);

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
            Error(Text001, EmailAddress);

        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then
                NoOfAtSigns := NoOfAtSigns + 1;
            if not (
              ((EmailAddress[i] >= 'a') and (EmailAddress[i] <= 'z')) or
              ((EmailAddress[i] >= 'A') and (EmailAddress[i] <= 'Z')) or
              ((EmailAddress[i] >= '0') and (EmailAddress[i] <= '9')) or
              (EmailAddress[i] in ['@', '.', '-', '_']))
            then
                Error(Text001, EmailAddress);
        end;

        if NoOfAtSigns <> 1 then
            Error(Text001, EmailAddress);
    end;

    procedure fCreateAttachPDFFact(FactNo: Code[50]; EmailCliente: Text[50])
    var
        lSalesInvHead: Record "Sales Invoice Header";
        //FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text;
        FileDirectory: Text[250];
        FileName: Text[250];
        FileName2: Text[250];
    begin
        FileDirectory := CaminhoPDF;
        FileName := 'Fatura ' + FORMAT(FactNo) + '.pdf';
        FileName := CONVERTSTR(FileName, '/', '.');
        FileName2 := 'Fatura ' + FORMAT(FactNo);
        FileName2 := CONVERTSTR(FileName2, '/', '.');

        IF NOT EXISTS(FileDirectory + FileName) THEN BEGIN
            lSalesInvHead.Reset;
            lSalesInvHead.SetRange("No.", FactNo);
            if lSalesInvHead.FindFirst then begin
                //ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');
                ServerAttachmentFilePath := FileDirectory + FileName2;
                Clear(rFaturas);
                rFaturas.UseRequestPage(false);
                //rFaturas.RecebeDados(true, true);
                rFaturas.SetTableView(lSalesInvHead);
                rFaturas.SaveAsPdf(ServerAttachmentFilePath);

                //SQD004 - 2021.11.22 - #NAV202100711
                //SLEEP(1000);
                Sleep(2000);

                if not Exists(ServerAttachmentFilePath) then
                    Error(ServerSaveAsPdfFailedErr);
            end;
        END;

        //Guarda nesta tabela temporaria: o Nº da Fatura +  Nome ficheiro Fact
        rTempFact.RESET;
        IF rTempFact.FINDLAST THEN
            vCount := rTempFact."Entry No." + 1
        ELSE
            vCount := 1;

        rTempFact.RESET;
        rTempFact.SETRANGE("Document No.", FactNo);
        rTempFact.SETRANGE(rTempFact.Description, EmailCliente);
        IF NOT rTempFact.FIND('-') THEN BEGIN
            rTempFact.INIT;
            rTempFact."Entry No." := vCount;
            rTempFact."Document No." := FactNo;
            rTempFact.Description := EmailCliente;
            rTempFact.Path := FileName;
            rTempFact.INSERT;
        END;
    end;

    procedure fCreateAttachPDFNC(NCNo: Code[50]; EmailCliente: Code[50]; FactNo: Code[50])
    var
        lSalesCrMemoHead: Record "Sales Cr.Memo Header";
        //FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text;
        FileDirectory: Text[250];
        FileName: Text[250];
        FileName2: Text[250];
    begin
        FileDirectory := CaminhoPDF;
        FileName := 'Nota Crédito ' + FORMAT(NCNo) + '.pdf';
        FileName := CONVERTSTR(FileName, '/', '.');
        FileName2 := 'Nota Crédito ' + FORMAT(NCNo);
        FileName2 := CONVERTSTR(FileName2, '/', '.');

        IF NOT EXISTS(FileDirectory + FileName) THEN BEGIN
            lSalesCrMemoHead.Reset;
            lSalesCrMemoHead.SetRange("No.", FactNo);
            if lSalesCrMemoHead.FindFirst then begin
                //ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');
                ServerAttachmentFilePath := FileDirectory + FileName2;
                Clear(rCredMemo);
                rCredMemo.UseRequestPage(false);
                //rFaturas.RecebeDados(true, true);
                rCredMemo.SetTableView(lSalesCrMemoHead);
                rCredMemo.SaveAsPdf(FileDirectory + FileName2);

                //SQD004 - 2021.11.22 - #NAV202100711
                //SLEEP(1000);
                Sleep(2000);

                if not Exists(ServerAttachmentFilePath) then
                    Error(ServerSaveAsPdfFailedErr);
            end;
        END;

        //Guarda nesta tabela temporaria: Nº fatura que deu origem à NC + Nome ficheiro NC + Nº NC
        rTempNotaC.RESET;
        IF rTempNotaC.FINDLAST THEN
            vCount := rTempNotaC."Entry No." + 1
        ELSE
            vCount := 1;

        rTempNotaC.RESET;
        rTempNotaC.SETRANGE("Document No.", FactNo);
        rTempNotaC.SETRANGE(rTempNotaC.Description, EmailCliente);
        rTempNotaC.SETRANGE(rTempNotaC."Applies-to Doc. No.", NCNo);
        IF NOT rTempNotaC.FIND('-') THEN BEGIN
            rTempNotaC.INIT;
            rTempNotaC."Entry No." := vCount;
            rTempNotaC."Document No." := FactNo; //Nº fatura que deu origem à NC
            rTempNotaC.Description := EmailCliente;
            rTempNotaC."Applies-to Doc. No." := NCNo; //Numero da NC
            rTempNotaC.Path := FileName;//Nome ficheiro NC
            rTempNotaC.INSERT;
        END;
    end;
}