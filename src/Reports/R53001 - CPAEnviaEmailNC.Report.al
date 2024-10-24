report 53001 EnviaEmailCrMemo
{
    // IT001 - CPA - Upgrade Report - MF - 2016-04-15
    //       - New Version

    Caption = 'Enviar Nota Crédito Email';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

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
        if rEduConfiguration.Get then
            if rEduConfiguration."Send E-Mail Invoice" then begin
                SalesCredMemoTEMP.Reset;
                SalesCredMemoTEMP.SetRange("No.", "Sales Cr.Memo Header"."No.");
                if SalesCredMemoTEMP.FindSet then
                    repeat
                        if recCustomerMail.Get(SalesCredMemoTEMP."Sell-to Customer No.") then
                            CheckValidEmailAddresses(recCustomerMail."E-Mail");
                        CreateAttachPDF(SalesCredMemoTEMP."No.", SalesCredMemoTEMP."Sell-to Customer No.");
                        fEnviaEmail(SalesCredMemoTEMP."No.", SalesCredMemoTEMP."Sell-to Customer No.", SalesCredMemoTEMP."Invoice Path",
                        TxtCrMemo + ' ' + SalesCredMemoTEMP."No." + ExtensionFile);
                    until SalesCredMemoTEMP.Next = 0;

                Message(Text0009);
            end;
    end;

    trigger OnPreReport()
    begin

    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        rSalesCMHeader: Record "Sales Cr.Memo Header";
        recCustomer: Record Customer;
        recCustomerMail: Record Customer;
        recUsersFamilyStudents: Record "Users Family / Students";
        rCompInfo: Record "Company Information";
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
        ExtensionFile: Label '.pdf';
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
        TxtCrMemo: Label 'Credit Memo';
        SalesCredMemoTEMP: Record "Sales Cr.Memo Header" temporary;
        ContMail: Integer;
        IStream: InStream;
        OStream: OutStream;
        CU_EmailMessage: Codeunit "Email Message";
        ToRecipients: List of [Text];
        CCRecipients: List of [Text];
        BCCRecipients: List of [Text];
        MsgBody: Text;
        FileN: Text[260];
        RecRef: RecordRef;
        CU_TempBlob: Codeunit "Temp Blob";


    procedure fEnviaEmail(FactNo: Code[50]; FactCliente: Code[50]; FactPath: Text[260]; FileD: Text[260])
    var
        l_recSalesCreditHead: Record "Sales Cr.Memo Header";
    begin
        if recCustomerMail.Get(FactCliente) then
            CreateMessage('', recCustomerMail."E-Mail", '', '', false);
    end;


    procedure CreateMessage(SenderAddress: Text[50]; Recipients: Text[1024]; Subject: Text[200]; Body: Text[1024]; HtmlFormatted: Boolean)
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
        rCommentLine.SetRange("Document Type", rCommentLine."Document Type"::"Credit Memo");
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
        if EmailSubject = '' then
            EmailSubject := CompanyName + '' + '-' + '' + TxtCrMemo + '' + "Sales Cr.Memo Header"."No.";

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
                    MsgBody := rCommentLine.Comment
                else begin
                    MsgBody += (Format(char13) + Format(char10) + rCommentLine.Comment);
                end;
            until rCommentLine.Next = 0;

        end;
        if MsgBody = '' then
            MsgBody := 'Please find in attachment';

        CU_EmailMessage.Create(ToRecipients, EmailSubject, MsgBody, true, CCRecipients, BCCRecipients);
        DownloadFromStream(IStream, 'Export', '', 'All Files (*.*)|*.*', FileN);
        //test if the pdf file is ok

        //if not CheckIfInStreamIsEmpty(IStream) then
        CU_EmailMessage.AddAttachment(FileN, 'pdf', IStream);

        CU_Email.Send(CU_EmailMessage, Enum::"Email Scenario"::Default);
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


    procedure CreateAttachPDF(pCreditMemoNo: Code[50]; pCustomerCreditMemo: Code[50])
    var
        lSalesCredMemoHead: Record "Sales Cr.Memo Header";
        ServerAttachmentFilePath: Text;
    begin
        Clear(IStream);
        Clear(OStream);

        lSalesCredMemoHead.Reset;
        lSalesCredMemoHead.SetRange("No.", pCreditMemoNo);
        if lSalesCredMemoHead.FindFirst then begin
            FileN := TxtCrMemo + lSalesCredMemoHead."No." + '.pdf';
            Clear(RecRef);
            RecRef.GetTable(lSalesCredMemoHead);
            CU_TempBlob.CreateOutStream(OStream);
            CU_TempBlob.CreateInStream(IStream);
            Report.SaveAs(Report::"PTSS Sales - Credit Memo (PT)", '', ReportFormat::Pdf, OStream, RecRef);
            Sleep(2000);
        end;
    end;
}
