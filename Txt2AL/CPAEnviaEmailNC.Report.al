report 50026 CPAEnviaEmailNC
{
    // IT001 - CPA - Upgrade Report - MF - 2016-04-15
    //       - New Version

    Caption = 'Enviar Nota Crédito Email';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date", "Sell-to Customer No.";
            RequestFilterHeading = 'Notas de Crédito Registadas';

            trigger OnAfterGetRecord()
            begin
                if rEduConfiguration.Get then
                    if rEduConfiguration."Send E-Mail Invoice" then
                        if recCustomer.Get("Sales Cr.Memo Header"."Sell-to Customer No.") then begin
                            recUsersFamilyStudents.Reset;
                            recUsersFamilyStudents.SetRange("No.", recCustomer."Student No.");
                            recUsersFamilyStudents.SetRange("Paying Entity", true);
                            if recUsersFamilyStudents.FindLast then
                                CreateAttachPDF("Sales Cr.Memo Header"."No.", "Sales Cr.Memo Header"."Sell-to Customer No.");
                        end;
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
        SalesCredMemoTEMP.Reset;
        if SalesCredMemoTEMP.FindSet then
            repeat
                if recCustomerMail.Get(SalesCredMemoTEMP."Sell-to Customer No.") then
                    CheckValidEmailAddresses(recCustomerMail."E-Mail");
                fEnviaEmail(SalesCredMemoTEMP."No.", SalesCredMemoTEMP."Sell-to Customer No.", SalesCredMemoTEMP."Invoice Path",
                Text0010 + ' ' + SalesCredMemoTEMP."No." + ExtensionFile);
            until SalesCredMemoTEMP.Next = 0;

        Message(Text0009);
    end;

    trigger OnPreReport()
    begin
        SalesCredMemoTEMP.DeleteAll;

        ContMail := 0;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        rSalesCMHeader: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        recCustomerMail: Record Customer;
        recUsersFamilyStudents: Record "Users Family / Students";
        "Object": Record "Object";
        rCompInfo: Record "Company Information";
        rSMTPFields: Record "SMTP Fields";
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
        Text0008: Label '\\cparodc\data$\CPA Docs\';
        //SMTPMailSetup: Record "SMTP Mail Setup";
        Text0009: Label 'Process Completed.';
        varMail: DotNet SmtpMessage;
        ExtensionFile: Label '.pdf';
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
        Text0010: Label 'Credit Memo';
        SalesCredMemoTEMP: Record "Sales Cr.Memo Header" temporary;
        ContMail: Integer;

    //[Scope('OnPrem')]
    procedure fEnviaEmail(FactNo: Code[50]; FactCliente: Code[50]; FactPath: Text[260]; FileD: Text[260])
    var
        l_recSalesInvHead: Record "Sales Invoice Header";
    begin
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
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::"Credit Memo");
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
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::"Credit Memo");
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
        varMail.Timeout(20000);

        Send;

        Sleep(5000);
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
    procedure CreateAttachPDF(pCreditMemoNo: Code[50]; pCustomerCreditMemo: Code[50])
    var
        lSalesCredMemoHead: Record "Sales Cr.Memo Header";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text;
        ReportCredMemo: Report "PTSS Sales - Credit Memo (PT)";
    begin
        lSalesCredMemoHead.Reset;
        lSalesCredMemoHead.SetRange("No.", pCreditMemoNo);
        if lSalesCredMemoHead.FindFirst then begin
            ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');
            Clear(ReportCredMemo);
            ReportCredMemo.UseRequestPage(false);
            //ReportCredMemo.RecebeDados(true, true);
            ReportCredMemo.SetTableView(lSalesCredMemoHead);
            ReportCredMemo.SaveAsPdf(ServerAttachmentFilePath);

            if not Exists(ServerAttachmentFilePath) then
                Error(ServerSaveAsPdfFailedErr);

            SalesCredMemoTEMP.Reset;
            SalesCredMemoTEMP.SetRange("No.", pCreditMemoNo);
            if SalesCredMemoTEMP.IsEmpty then begin
                SalesCredMemoTEMP.Init;
                SalesCredMemoTEMP."No." := pCreditMemoNo;
                SalesCredMemoTEMP."Sell-to Customer No." := pCustomerCreditMemo;
                SalesCredMemoTEMP."Invoice Path" := ServerAttachmentFilePath;
                SalesCredMemoTEMP.Insert;
            end;
        end;
    end;
}
