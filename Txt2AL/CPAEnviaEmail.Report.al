report 50025 CPAEnviaEmail
{
    // IT001 - CPA - Upgrade Report - MF - 2016-04-13
    //       - New Version
    // 
    // IT002 - Alteração Parâmetro Timeout
    // 
    // IT003 - 206.11.10 - Alteração para poder enviar faturas por email, para qualquer tipo de cliente (alunos, candidatos, outros)
    // 
    // Nota: Futuros Clientes ver se o email da fatura deve ser para o sellto ou bill-to
    // 
    // SQD004 - 2021.11.22 - #NAV202100711
    //   Sleep and Timeout increased

    Caption = 'Enviar Fatura Email';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date", "Sell-to Customer No.";
            RequestFilterHeading = 'Faturas Registadas';

            trigger OnAfterGetRecord()
            begin
                //IT003 - 206.11.10 - Alteração para poder enviar faturas por email, para qualquer tipo de cliente (alunos, candidatos, outros)
                //IF rEduConfiguration.GET THEN
                //  IF rEduConfiguration."Send E-Mail Invoice" THEN
                //    IF recCustomer.GET("Sales Invoice Header"."Sell-to Customer No.") THEN BEGIN
                //      recUsersFamilyStudents.RESET;
                //      recUsersFamilyStudents.SETRANGE("No.",recCustomer."Student No.");
                //      recUsersFamilyStudents.SETRANGE("Paying Entity",TRUE);
                //      IF recUsersFamilyStudents.FINDLAST THEN
                //        CreateAttachPDF("Sales Invoice Header"."No.","Sales Invoice Header"."Sell-to Customer No.");
                //    END;


                if rEduConfiguration.Get then
                    if rEduConfiguration."Send E-Mail Invoice" then
                        if recCustomer.Get("Sales Invoice Header"."Sell-to Customer No.") then
                            CreateAttachPDF("Sales Invoice Header"."No.", "Sales Invoice Header"."Sell-to Customer No.");


                //IT003 - 206.11.10 - en
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        rSalesInvoiceHeaderTEMP.Reset;
        if rSalesInvoiceHeaderTEMP.FindSet then
            repeat
                if recCustomerMail.Get(rSalesInvoiceHeaderTEMP."Sell-to Customer No.") then
                    CheckValidEmailAddresses(recCustomerMail."E-Mail");
                fEnviaEmail(rSalesInvoiceHeaderTEMP."No.", rSalesInvoiceHeaderTEMP."Sell-to Customer No.",
                            rSalesInvoiceHeaderTEMP."Invoice Path", Text0010 + ' ' +
                            rSalesInvoiceHeaderTEMP."No." + ExtensionFile);
            until rSalesInvoiceHeaderTEMP.Next = 0;

        Message(Text0009);
    end;

    trigger OnPreReport()
    begin
        rSalesInvoiceHeaderTEMP.DeleteAll;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesInvoiceHeaderTEMP: Record "Sales Invoice Header" temporary;
        recCustomer: Record Customer;
        recCustomerMail: Record Customer;
        recUsersFamilyStudents: Record "Users Family / Students";
        "Object": Record "Object";
        rCompInfo: Record "Company Information";
        rSMTPFields: Record "SMTP Fields";
        ReportInvoice: Report "PTSS Sales - Invoice (PT)";
        cuPostServET: Codeunit "Post Services ET";
        Mail: Codeunit Mail;
        ErrorNo: Integer;
        Text001: Label 'The email address "%1" is invalid.';
        Text002: Label 'Attachment %1 does not exist or can not be accessed from the program.';
        Text003: Label 'The SMTP mail system returned the following error: %1';
        Text0005: Label 'E-mail Subject';
        Text0006: Label 'E-mail Body';
        rCommentLine: Record "Comment Line";
        int: Integer;
        ArrayBod: array[40] of Text[260];
        txtCRLF: Char;
        Text0007: Label 'MailBody.txt';
        Text0008: Label 'c:\Navision\';
        //SMTPMailSetup: Record "SMTP Mail Setup";
        varMail: DotNet SmtpMessage;
        Text0009: Label 'Process Completed.';
        Text0010: Label 'Invoice';
        ExtensionFile: Label '.pdf';
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
        ContMail: Integer;

    //[Scope('OnPrem')]
    procedure fEnviaEmail(FactNo: Code[50]; FactCliente: Code[50]; FactPath: Text[260]; FileD: Text[260])
    var
        l_recSalesInvHead: Record "Sales Invoice Header";
    begin
        //ENVIO DO EMAIL
        if recCustomerMail.Get(FactCliente) then
            CreateMessage(rCompInfo.Name, '', recCustomerMail."E-Mail", '', '', false, FactPath, FileD);
    end;

    //[Scope('OnPrem')]
    procedure CreateMessage(SenderName: Text[100]; SenderAddress: Text[50]; Recipients: Text[1024]; Subject: Text[200]; Body: Text[1024]; HtmlFormatted: Boolean; FileN: Text[260]; FileDir: Text[260])
    var
        char10: Char;
        char13: Char;
    begin
        rSMTPFields.Get;
        rSMTPFields.TestField("SMTP Server Name");

        //CheckValidEmailAddresses(rSMTPFields."E-Mail From");

        if not IsNull(varMail) then begin
            varMail.Dispose;
            Clear(varMail);
        end;

        varMail := varMail.SmtpMessage;
        varMail.FromAddress := rSMTPFields."E-Mail From";
        varMail."To" := Recipients;
        varMail.CC := rSMTPFields."E-Mail From Bcc";

        rCommentLine.Reset;
        rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::"E-mail");
        rCommentLine.SetRange("No.", Text0005);
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::Invoice);
        if rCommentLine.FindSet then begin
            int := rCommentLine.Count;
            repeat
                if int = 1 then
                    varMail.Subject := rCommentLine.Comment
                else begin
                    varMail.Subject := InsStr(varMail.Subject, ' ', StrLen(varMail.Subject) + 1);
                    varMail.Subject := InsStr(varMail.Subject, rCommentLine.Comment, StrLen(varMail.Subject) + 1);
                end;

            until rCommentLine.Next = 0;
        end;

        rCommentLine.Reset;
        rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::"E-mail");
        rCommentLine.SetRange("No.", Text0006);
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::Invoice);
        if rCommentLine.FindSet then begin
            int := rCommentLine.Count;
            char10 := 10;
            char13 := 13;
            repeat
                if int = 1 then
                    varMail.Body := rCommentLine.Comment
                else begin
                    AppendBody(Format(char13) + Format(char10) + rCommentLine.Comment);
                end;
            until rCommentLine.Next = 0;

        end;

        varMail.HtmlFormatted := HtmlFormatted;
        varMail.AddAttachmentWithName(FileN, FileDir);
        //IT002,o varMail.Timeout(20000);
        //SQD004 - 2021.11.22 - #NAV202100711
        //varMail.Timeout(50000); //IT002,n
        varMail.Timeout(90000); //IT002,n

        Send;

        //IT002,o SLEEP(5000);
    end;

    //[Scope('OnPrem')]
    procedure Send()
    var
        Result: Text[1024];
    begin
        Result := '';
        with rSMTPFields do
            Result :=
              varMail.Send(
                "SMTP Server Name",
                "SMTP Server Port",
                false,
                '',
                '',
                true);

        varMail.Dispose;
        Clear(varMail);
        if Result <> '' then
            Error(Text003, Result);
    end;

    //[Scope('OnPrem')]
    procedure AddRecipients(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddRecipients(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    //[Scope('OnPrem')]
    procedure AddCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddCC(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    //[Scope('OnPrem')]
    procedure AddBCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        Result := varMail.AddBCC(Recipients);
        if Result <> '' then
            Error(Text003, Result);
    end;

    //[Scope('OnPrem')]
    procedure AppendBody(BodyPart: Text[1024])
    var
        Result: Text[1024];
    begin
        Result := varMail.AppendBody(BodyPart);
        if Result <> '' then
            Error(Text003, Result);
    end;

    //[Scope('OnPrem')]
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

    //[Scope('OnPrem')]
    procedure CreateAttachPDF(pInvoiceNo: Code[50]; pCustomerInvoice: Code[50])
    var
        lSalesInvHead: Record "Sales Invoice Header";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text;
    begin
        lSalesInvHead.Reset;
        lSalesInvHead.SetRange("No.", pInvoiceNo);
        if lSalesInvHead.FindFirst then begin
            ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');
            Clear(ReportInvoice);
            ReportInvoice.UseRequestPage(false);
            //ReportInvoice.RecebeDados(true, true);
            ReportInvoice.SetTableView(lSalesInvHead);
            ReportInvoice.SaveAsPdf(ServerAttachmentFilePath);

            //SQD004 - 2021.11.22 - #NAV202100711
            //SLEEP(1000);
            Sleep(2000);

            if not Exists(ServerAttachmentFilePath) then
                Error(ServerSaveAsPdfFailedErr);

            rSalesInvoiceHeaderTEMP.Reset;
            rSalesInvoiceHeaderTEMP.SetRange("No.", pInvoiceNo);
            if rSalesInvoiceHeaderTEMP.IsEmpty then begin
                rSalesInvoiceHeaderTEMP.Init;
                rSalesInvoiceHeaderTEMP."No." := pInvoiceNo;
                rSalesInvoiceHeaderTEMP."Sell-to Customer No." := pCustomerInvoice;
                rSalesInvoiceHeaderTEMP."Invoice Path" := ServerAttachmentFilePath;
                rSalesInvoiceHeaderTEMP.Insert;
            end;
        end;
    end;
}

