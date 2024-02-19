codeunit 50080 "Sales-Post Subscription"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    local procedure SchoolProcessingOnAfterSalesInvHeaderInsert(SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    var
        rStudentLedgerEntry: Record "Student Ledger Entry";
        varSalesLineCount: Integer;
        SalesInvLine: Record "Sales Invoice Line";
    begin
        //C+ ET03
        CLEAR(rStudentLedgerEntry);
        rStudentLedgerEntry.RESET;
        /*IF SalesHeader.Company <> '' THEN BEGIN
          rStudentLedgerEntry.CHANGECOMPANY(SalesHeader.Company);
          rStudentLedgerEntry.SETRANGE(Company,COMPANYNAME);
        END;*/
        rStudentLedgerEntry.SETRANGE("Invoice No.", SalesHeader."No.");
        IF rStudentLedgerEntry.FIND('-') THEN BEGIN
            REPEAT
                IF SalesHeader.Company = '' THEN
                    rStudentLedgerEntry.VALIDATE("Registed Invoice No.", SalesInvHeader."No.")
                ELSE BEGIN
                    rStudentLedgerEntry."Registed Invoice No." := SalesInvHeader."No.";
                    rStudentLedgerEntry.Registed := TRUE;
                    CLEAR(varSalesLineCount);
                END;
                rStudentLedgerEntry.MODIFY(TRUE);
            UNTIL rStudentLedgerEntry.NEXT = 0;
        END;

        //END C+ ET03
        //C+ - 2011.11.29 - Incluir uma linha inicial com a indicação da número da encomenda
        IF SalesInvHeader."Order No." <> '' THEN BEGIN
            SalesInvLine.INIT;
            SalesInvLine."Line No." := 500;
            SalesInvLine."Document No." := SalesInvHeader."No.";
            SalesInvLine.Description := SalesInvHeader."Order No.";
            SalesInvLine.INSERT;
        END;
        //C+ - 2011.11.29 - fim
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeRunGenJnlPostLine', '', false, false)]
    local procedure SchoolProcessingOnBeforePostJnl(var GenJnlLine: Record "Gen. Journal Line"; SalesInvHeader: Record "Sales Invoice Header")
    begin
        //C+ RSC
        //GenJnlLine."PTSS Acc: cash-flow code" := InvPostingBuffer[1]."Cash-flow code";
        //
        GenJnlLine."Process by Education" := SalesInvHeader."Process by Education";
    end;
}