report 80000 CPAEnviaEmail_TEMP
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

    Caption = 'Enviar Fatura Email Temp';
    ProcessingOnly = true;
    ApplicationArea = All;//guangai added application area and usage category
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date", "Sell-to Customer No.";
            RequestFilterHeading = 'Faturas Registadas';

            trigger OnAfterGetRecord()
            begin
                if rEduConfiguration.Get then
                    if rEduConfiguration."Send E-Mail Invoice" then
                        if recCustomer.Get("Sales Invoice Header"."Sell-to Customer No.") then
                            CreateAttachPDF("Sales Invoice Header"."No.", "Sales Invoice Header"."Sell-to Customer No.");
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

        rSalesInvoiceHeader.Reset;
        rSalesInvoiceHeader.SetRange("No.", "Sales Invoice Header"."No.");
        if rSalesInvoiceHeader.FindSet then begin
            repeat
                if recCustomerMail.Get(rSalesInvoiceHeader."Sell-to Customer No.") then
                    CheckValidEmailAddresses(recCustomerMail."E-Mail");
                fEnviaEmail(rSalesInvoiceHeader."No.", rSalesInvoiceHeader."Sell-to Customer No.",
                            rSalesInvoiceHeader."Invoice Path", Text0010 + ' ' +
                            rSalesInvoiceHeader."No." + ExtensionFile);
            until rSalesInvoiceHeader.Next = 0;
            Message(Text0009);
        end;

    end;

    trigger OnPreReport()
    begin
        //rSalesInvoiceHeader.DeleteAll;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesInvoiceHeaderTEMP: Record "Sales Invoice Header" temporary;
        recCustomer: Record Customer;
        recCustomerMail: Record Customer;
        recUsersFamilyStudents: Record "Users Family / Students";
        //"Object": Record "Object";
        //guangai commented object
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
        Text0009: Label 'Process Completed.';
        Text0010: Label 'Invoice';
        ExtensionFile: Label '.pdf';
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
        ContMail: Integer;
        IStream: InStream;
        OStream: OutStream;
        CU_EmailMessage: Codeunit "Email Message";
        ToRecipients: List of [Text];
        CCRecipients: List of [Text];
        BCCRecipients: List of [Text];
        MsgBody: Text;

    //[Scope(' ')]
    procedure fEnviaEmail(FactNo: Code[50]; FactCliente: Code[50]; FactPath: Text[260]; FileD: Text[260])
    var
        l_recSalesInvHead: Record "Sales Invoice Header";
    begin
        //ENVIO DO EMAIL
        if recCustomerMail.Get(FactCliente) then
            CreateMessage('', recCustomerMail."E-Mail", '', '', false, FactPath);
    end;

    //[Scope(' ')]
    procedure CreateMessage(SenderAddress: Text[50]; Recipients: Text[1024]; Subject: Text[200]; Body: Text[1024]; HtmlFormatted: Boolean; FileN: Text[260])
    var
        CU_Email: Codeunit Email;
        EmailSubject: Text;
        char10: Char;
        char13: Char;
    begin

        ToRecipients.Add(Recipients);
        Clear(MsgBody);


        rCommentLine.Reset;
        rCommentLine.SetRange("Table Name", rCommentLine."Table Name"::"E-mail");
        rCommentLine.SetRange("No.", Text0005);
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::Invoice);
        if rCommentLine.FindSet then begin
            int := rCommentLine.Count;
            repeat
                if int = 1 then
                    EmailSubject := rCommentLine.Comment
                else begin
                    EmailSubject := InsStr(EmailSubject, ' ', StrLen(EmailSubject) + 1);
                    EmailSubject := InsStr(EmailSubject, rCommentLine.Comment, StrLen(EmailSubject) + 1);
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
                    MsgBody := rCommentLine.Comment
                else begin
                    MsgBody += Format(char13) + Format(char10) + rCommentLine.Comment;
                end;
            until rCommentLine.Next = 0;

        end;

        CU_EmailMessage.Create(ToRecipients, EmailSubject, MsgBody, true, CCRecipients, BCCRecipients);
        if not CheckIfInStreamIsEmpty(IStream) then
            CU_EmailMessage.AddAttachment(FileN, 'application/pdf', IStream);
        CU_Email.Send(CU_EmailMessage);
    end;

    procedure CheckIfInStreamIsEmpty(var InStr: InStream) Result: Boolean;
    var
        TempText: Text[1024];
        BytesRead: Integer;
    begin
        Result := TRUE; // Assume the stream is empty

        // Try to read from the InStream
        BytesRead := InStr.READ(TempText);

        // If BytesRead is greater than 0, the stream is not empty
        if BytesRead > 0 then
            Result := FALSE;
    end;

    procedure AddRecipients(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        ToRecipients.Add(Recipients);
    end;

    procedure AddCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        CCRecipients.Add(Recipients);
    end;

    procedure AddBCC(Recipients: Text[1024])
    var
        Result: Text[1024];
    begin
        CheckValidEmailAddresses(Recipients);
        BCCRecipients.Add(Recipients);
    end;

    procedure AppendBody(BodyPart: Text[1024])
    var
        Result: Text[1024];
    begin
        MsgBody += BodyPart;
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

    procedure CreateAttachPDF(pInvoiceNo: Code[50]; pCustomerInvoice: Code[50])
    var
        lSalesInvHead: Record "Sales Invoice Header";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text;
        CU_TempBlob: Codeunit "Temp Blob";
    begin
        //new Create AttachMent
        Clear(IStream);
        Clear(OStream);

        CU_TempBlob.CreateInStream(IStream);
        CU_TempBlob.CreateOutStream(OStream);
        lSalesInvHead.Reset;
        lSalesInvHead.SetRange("No.", pInvoiceNo);
        if lSalesInvHead.FindFirst then begin
            Clear(ReportInvoice);
            ReportInvoice.UseRequestPage(false);
            //ReportInvoice.RecebeDados(true, true);
            ReportInvoice.SetTableView(lSalesInvHead);
            ReportInvoice.SaveAs('', ReportFormat::Pdf, OStream);
            ///IStream := CU_TempBlob.CreateInStream();
            Sleep(2000);
        end;

    end;
}
