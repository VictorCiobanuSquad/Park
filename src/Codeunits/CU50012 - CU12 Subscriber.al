// codeunit 50012 "Gen. Jnl.-Post Line Sub."
// {
//     //PTSS Bill Commented 
//     //GCUI SQD
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
//     local procedure ProcessingOnPostCust(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
//     begin
//         //C+ ET.0004
//         IF CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Payment THEN
//             CustLedgerEntry."Process by Education" := GenJournalLine."Process by Education";
//         CustLedgerEntry."Payment Method Code" := GenJournalLine."Payment Method Code";
//         //
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnUnapplyCustLedgEntryOnAfterCreateGLEntriesForTotalAmounts', '', false, false)]
//     local procedure ProcessingOnUnapply(DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
//     var
//         DtlStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
//         lNextEntryNo: Integer;
//         DtlStudLedgEntryNEW: Record "Detailed Stud. Ledg. Entry";
//     begin
//         //C+ - ET.03.004 - Reverse student ledger entry
//         DtlStudLedgEntry.RESET;
//         IF DtlStudLedgEntry.FIND('+') THEN
//             lNextEntryNo := DtlStudLedgEntry."Entry No."
//         ELSE
//             lNextEntryNo := 1;

//         DtlStudLedgEntry.RESET;
//         DtlStudLedgEntry.SETRANGE("Entry Type", DtlStudLedgEntry."Entry Type"::Application);
//         DtlStudLedgEntry.SETRANGE("Document Type", DetailedCustLedgEntry."Document Type");
//         DtlStudLedgEntry.SETRANGE("Document No.", DetailedCustLedgEntry."Document No.");
//         IF DtlStudLedgEntry.FIND('-') THEN BEGIN
//             REPEAT
//                 IF NOT ((DtlStudLedgEntry."Document Type" = DtlStudLedgEntry."Document Type"::Payment) AND (DtlStudLedgEntry.Amount > 0)) THEN BEGIN
//                     lNextEntryNo += 1;
//                     DtlStudLedgEntryNEW.INIT;
//                     DtlStudLedgEntryNEW.TRANSFERFIELDS(DtlStudLedgEntry);
//                     DtlStudLedgEntryNEW."Entry No." := lNextEntryNo;
//                     DtlStudLedgEntryNEW.Amount := DtlStudLedgEntryNEW.Amount * -1;
//                     DtlStudLedgEntryNEW."Amount (LCY)" := DtlStudLedgEntryNEW."Amount (LCY)" * -1;
//                     DtlStudLedgEntryNEW."Debit Amount" := DtlStudLedgEntryNEW."Debit Amount" * -1;
//                     DtlStudLedgEntryNEW."Credit Amount" := DtlStudLedgEntryNEW."Credit Amount" * -1;
//                     DtlStudLedgEntryNEW."Debit Amount (LCY)" := DtlStudLedgEntryNEW."Debit Amount (LCY)" * -1;
//                     DtlStudLedgEntryNEW."Credit Amount (LCY)" := DtlStudLedgEntryNEW."Credit Amount (LCY)" * -1;
//                     DtlStudLedgEntryNEW."Amount in VAT Report" := DtlStudLedgEntryNEW."Amount in VAT Report" * -1;
//                     DtlStudLedgEntryNEW."Entry Type" := DtlStudLedgEntryNEW."Entry Type"::Annulment;
//                     DtlStudLedgEntryNEW.INSERT;
//                 END;
//             UNTIL DtlStudLedgEntry.NEXT = 0;
//         END;
//         //
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostDtldCustLedgEntriesOnBeforeCreateGLEntriesForTotalAmountsV19', '', false, false)]
//     local procedure StudentProcessingOnPostDtldCustLedgEntries(var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var GenJnlLine: Record "Gen. Journal Line")
//     var
//         Process: Boolean;
//         rCustLedgEntry: Record "Cust. Ledger Entry";
//         rSalesCMHeader: Record "Sales Header";
//         rSalesCMLine: Record "Sales Line";
//         StudentLedgerEntry: Record "Student Ledger Entry";
//         DtldStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
//         DtldStudLedgEntryNoOffset: Integer;
//         rSalesInvoiceHeader: Record "Sales Invoice Header";
//         rPaymentMethod: Record "Payment Method";
//         l_StudentLedgerEntry: Record "Student Ledger Entry";
//         l_DetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
//         InsertLine: Boolean;
//         CorrectLine: Boolean;
//         InsertNextLine: Boolean;
//         PendingAmount: Decimal;
//         StudentLedgerEntry2: Record "Student Ledger Entry";
//         DtldCustLedgEntry2: Record "Detailed Stud. Ledg. Entry";
//     begin

//         //C+ ET - Inserir os movs. de liquidação e Faturação do aluno
//         IF (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::"Initial Entry") OR
//            (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application) THEN BEGIN
//             Process := TRUE;

//             IF (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::" ") AND
//                  NOT ((DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::Invoice)
//                  OR
//                  (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill")
//                  )
//                  THEN
//                 Process := FALSE;
//             IF GenJnlLine."Process by Education" THEN BEGIN
//                 IF (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Payment) THEN
//                     Process := FALSE;
//             END ELSE
//                 Process := FALSE;


//             IF Process THEN BEGIN
//                 IF ((DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::"Credit Memo") OR
//                    (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Refund)) THEN BEGIN
//                     IF rCustLedgEntry.GET(DtldCVLedgEntryBuf."CV Ledger Entry No.") THEN BEGIN

//                         rSalesCMHeader.RESET;
//                         rSalesCMHeader.SETRANGE("Document Type", rSalesCMHeader."Document Type"::"Credit Memo");
//                         rSalesCMHeader.SETRANGE("Posting No.", DtldCVLedgEntryBuf."Document No.");
//                         rSalesCMHeader.SETRANGE("Process by Education", TRUE);
//                         IF rSalesCMHeader.FIND('-') THEN BEGIN
//                             rSalesCMLine.RESET;
//                             rSalesCMLine.SETRANGE("Document Type", rSalesCMLine."Document Type"::"Credit Memo");
//                             rSalesCMLine.SETRANGE("Document No.", rSalesCMHeader."No.");
//                             rSalesCMLine.SETFILTER(Type, '<>%1', 0);
//                             rSalesCMLine.SETFILTER("No.", '<>''''');
//                             IF rSalesCMLine.FIND('-') THEN
//                                 REPEAT
//                                     StudentLedgerEntry.RESET;
//                                     StudentLedgerEntry.SETRANGE("Registed Invoice No.", rCustLedgEntry."Document No.");
//                                     StudentLedgerEntry.SETRANGE("Service Code", rSalesCMLine."No.");
//                                     IF StudentLedgerEntry.FIND('-') THEN BEGIN
//                                         DtldStudLedgEntryNoOffset := 0;
//                                         DtldStudLedgEntry.RESET;
//                                         IF DtldStudLedgEntry.FIND('+') THEN
//                                             DtldStudLedgEntryNoOffset := DtldStudLedgEntry."Entry No."
//                                         ELSE
//                                             DtldStudLedgEntryNoOffset := 0;

//                                         REPEAT
//                                             CLEAR(DtldStudLedgEntry);
//                                             DtldStudLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);

//                                             IF (DtldStudLedgEntry."Document Type" =
//                                                  DtldStudLedgEntry."Document Type"::"Credit Memo") OR
//                                                (DtldStudLedgEntry."Document Type" =
//                                                  DtldStudLedgEntry."Document Type"::"Finance Charge Memo") THEN
//                                                 DtldStudLedgEntry."Entry Type" := DtldStudLedgEntry."Entry Type"::Annulment;
//                                             DtldStudLedgEntryNoOffset += 1;
//                                             DtldStudLedgEntry."Entry No." := DtldStudLedgEntryNoOffset;
//                                             DtldStudLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
//                                             DtldStudLedgEntry."Reason Code" := GenJnlLine."Reason Code";
//                                             DtldStudLedgEntry."Source Code" := GenJnlLine."Source Code";
//                                             //DtldStudLedgEntry."Transaction No." := NextTransactionNo;
//                                             DtldStudLedgEntry."Document No." := GenJnlLine."Document No.";
//                                             IF DtldCVLedgEntryBuf.Amount > 0 THEN
//                                                 DtldStudLedgEntry.Amount := StudentLedgerEntry."Amout Credit Note";
//                                             IF DtldCVLedgEntryBuf.Amount < 0 THEN
//                                                 DtldStudLedgEntry.Amount := -StudentLedgerEntry."Amout Credit Note";
//                                             DtldStudLedgEntry."Amount (LCY)" := StudentLedgerEntry."Amount (LCY)";
//                                             StudentUpdateDebitCredit(GenJnlLine.Correction, DtldStudLedgEntry);
//                                             DtldStudLedgEntry."Student Ledger Entry No." := StudentLedgerEntry."Entry No.";
//                                             DtldStudLedgEntry.INSERT;
//                                         UNTIL StudentLedgerEntry.NEXT = 0;
//                                     END;
//                                 UNTIL rSalesCMLine.NEXT = 0;
//                         END;
//                     END;
//                 END ELSE BEGIN
//                     IF NOT ((DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::" ") AND
//                       (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::" ") AND
//                       (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application)) THEN BEGIN
//                         IF NOT ((DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Invoice) AND
//                           (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::"Credit Memo") AND
//                           (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application))
//                         THEN BEGIN
//                             StudentLedgerEntry.RESET;
//                             StudentLedgerEntry.SETCURRENTKEY("Registed Invoice No.");
//                             IF rCustLedgEntry.GET(DtldCVLedgEntryBuf."CV Ledger Entry No.") THEN
//                                 StudentLedgerEntry.SETRANGE("Registed Invoice No.", rCustLedgEntry."Document No.")
//                             ELSE BEGIN
//                                 IF (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Payment) THEN BEGIN
//                                     IF rSalesInvoiceHeader.GET(GenJnlLine."Applies-to Doc. No.") THEN BEGIN
//                                         IF rPaymentMethod.GET(rSalesInvoiceHeader."Payment Method Code") THEN
//                                             StudentLedgerEntry.SETRANGE("Registed Invoice No.", DtldCVLedgEntryBuf."Document No.");
//                                     END;
//                                 END ELSE
//                                     StudentLedgerEntry.SETRANGE("Registed Invoice No.", DtldCVLedgEntryBuf."Document No.");
//                             END;
//                             IF StudentLedgerEntry.FIND('-') THEN BEGIN
//                                 l_StudentLedgerEntry.COPY(StudentLedgerEntry);
//                                 l_StudentLedgerEntry.CALCSUMS(Amount);

//                                 DtldStudLedgEntryNoOffset := 0;
//                                 DtldStudLedgEntry.RESET;
//                                 IF DtldStudLedgEntry.FIND('+') THEN
//                                     DtldStudLedgEntryNoOffset := DtldStudLedgEntry."Entry No."
//                                 ELSE
//                                     DtldStudLedgEntryNoOffset := 0;
//                                 REPEAT
//                                     IF (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Invoice) AND
//                                        (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application) AND
//                                        (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::Invoice)
//                                     THEN BEGIN
//                                         IF ((StudentLedgerEntry.Amount + DtldCVLedgEntryBuf.Amount) >= 0) THEN BEGIN
//                                             IF NOT InsertNextLine THEN BEGIN
//                                                 InsertLine := FALSE;
//                                                 CorrectLine := FALSE;
//                                                 IF PendingAmount < 0 THEN BEGIN
//                                                     InsertLine := FALSE;
//                                                     CorrectLine := TRUE;
//                                                 END;
//                                             END ELSE
//                                                 InsertLine := TRUE;
//                                             IF (StudentLedgerEntry.Amount + DtldCVLedgEntryBuf.Amount = 0) THEN
//                                                 InsertNextLine := TRUE;
//                                         END ELSE BEGIN
//                                             IF ((StudentLedgerEntry.Amount + DtldCVLedgEntryBuf.Amount) < 0) THEN BEGIN
//                                                 IF NOT InsertNextLine THEN BEGIN
//                                                     InsertLine := FALSE;
//                                                     CorrectLine := TRUE;
//                                                 END ELSE
//                                                     InsertLine := TRUE;
//                                             END;
//                                         END;
//                                     END ELSE BEGIN
//                                         IF (DtldCVLedgEntryBuf."Document Type" = DtldCVLedgEntryBuf."Document Type"::Payment) AND
//                                            (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::Payment)
//                                         THEN BEGIN
//                                             IF (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::Application) THEN BEGIN
//                                                 IF StudentLedgerEntry."Remaining Amount" > 0 THEN BEGIN
//                                                     InsertLine := FALSE;
//                                                     CorrectLine := TRUE;
//                                                 END ELSE BEGIN
//                                                     IF StudentLedgerEntry."Remaining Amount" = 0 THEN
//                                                         InsertLine := TRUE
//                                                     ELSE
//                                                         InsertLine := FALSE;
//                                                 END;
//                                             END ELSE BEGIN
//                                                 IF (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::"Initial Entry") THEN BEGIN
//                                                     IF StudentLedgerEntry."Remaining Amount" > 0 THEN BEGIN
//                                                         InsertLine := FALSE;
//                                                         CorrectLine := TRUE;
//                                                     END ELSE BEGIN
//                                                         InsertLine := TRUE;
//                                                     END;
//                                                 END ELSE BEGIN
//                                                     InsertLine := FALSE;
//                                                     CorrectLine := FALSE;
//                                                 END;
//                                             END;
//                                         END;
//                                     END;
//                                     IF NOT InsertLine THEN BEGIN
//                                         CLEAR(DtldStudLedgEntry);
//                                         DtldStudLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);

//                                         IF (DtldStudLedgEntry."Document Type" = DtldStudLedgEntry."Document Type"::"Credit Memo") OR
//                                            (DtldStudLedgEntry."Document Type" = DtldStudLedgEntry."Document Type"::"Finance Charge Memo") THEN
//                                             DtldStudLedgEntry."Entry Type" := DtldStudLedgEntry."Entry Type"::Annulment;
//                                         DtldStudLedgEntryNoOffset += 1;
//                                         DtldStudLedgEntry."Entry No." := DtldStudLedgEntryNoOffset;
//                                         DtldStudLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
//                                         DtldStudLedgEntry."Reason Code" := GenJnlLine."Reason Code";
//                                         DtldStudLedgEntry."Source Code" := GenJnlLine."Source Code";
//                                         //DtldStudLedgEntry."Transaction No." := NextTransactionNo;

//                                         IF DtldCVLedgEntryBuf.Amount > 0 THEN BEGIN
//                                             IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice THEN BEGIN
//                                                 IF l_StudentLedgerEntry.Amount <> DtldCVLedgEntryBuf.Amount THEN BEGIN
//                                                     DtldStudLedgEntry.Amount := DtldCVLedgEntryBuf.Amount;
//                                                 END ELSE
//                                                     DtldStudLedgEntry.Amount := StudentLedgerEntry.Amount;
//                                             END ELSE
//                                                 DtldStudLedgEntry.Amount := StudentLedgerEntry."Amout Credit Note";
//                                         END;

//                                         IF DtldCVLedgEntryBuf.Amount < 0 THEN BEGIN
//                                             IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Invoice THEN BEGIN
//                                                 IF -l_StudentLedgerEntry.Amount <> DtldCVLedgEntryBuf.Amount THEN BEGIN
//                                                     IF NOT CorrectLine THEN BEGIN
//                                                         DtldStudLedgEntry.Amount := DtldCVLedgEntryBuf.Amount;
//                                                         InsertNextLine := TRUE;
//                                                     END ELSE BEGIN
//                                                         IF (PendingAmount = 0) AND ((StudentLedgerEntry.Amount + PendingAmount) >= 0) THEN BEGIN
//                                                             IF (PendingAmount = 0) THEN BEGIN
//                                                                 DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                                                 PendingAmount := (StudentLedgerEntry.Amount + DtldCVLedgEntryBuf.Amount);
//                                                             END ELSE BEGIN
//                                                                 IF (StudentLedgerEntry.Amount + PendingAmount) >= 0 THEN BEGIN
//                                                                     DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                                                     PendingAmount := (StudentLedgerEntry.Amount + PendingAmount);
//                                                                     IF PendingAmount >= 0 THEN
//                                                                         InsertNextLine := TRUE;
//                                                                 END ELSE
//                                                                     DtldStudLedgEntry.Amount := PendingAmount;
//                                                             END;
//                                                         END ELSE BEGIN
//                                                             IF (PendingAmount <> 0) AND ((StudentLedgerEntry.Amount + PendingAmount) >= 0) THEN BEGIN
//                                                                 DtldStudLedgEntry.Amount := PendingAmount;
//                                                                 PendingAmount := (StudentLedgerEntry.Amount + PendingAmount);
//                                                                 IF PendingAmount >= 0 THEN
//                                                                     InsertNextLine := TRUE;
//                                                             END ELSE BEGIN
//                                                                 DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                                                 PendingAmount := (StudentLedgerEntry.Amount + PendingAmount);
//                                                             END;
//                                                         END;
//                                                     END;
//                                                 END ELSE
//                                                     DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                             END ELSE
//                                                 DtldStudLedgEntry.Amount := -StudentLedgerEntry."Amout Credit Note";
//                                         END;

//                                         //Para as linhas do tipo Titulo
//                                         IF DtldCVLedgEntryBuf.Amount < 0 THEN BEGIN
//                                             IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment)
//                                               OR
//                                               (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"PTSS Bill")
//                                               ) AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill") THEN
//                                                 IF DtldCVLedgEntryBuf.Amount <> -l_StudentLedgerEntry.Amount THEN
//                                                     DtldStudLedgEntry.Amount := (StudentLedgerEntry.Amount / l_StudentLedgerEntry.Amount) *
//                                                     DtldCVLedgEntryBuf.Amount
//                                                 ELSE
//                                                     DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount
//                                         END;

//                                         //Para as linhas do tipo Titulo
//                                         IF DtldCVLedgEntryBuf.Amount > 0 THEN BEGIN
//                                             IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) OR
//                                               (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"PTSS Bill")) AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill") THEN
//                                                 IF DtldCVLedgEntryBuf.Amount <> -l_StudentLedgerEntry.Amount THEN
//                                                     DtldStudLedgEntry.Amount := (StudentLedgerEntry.Amount / l_StudentLedgerEntry.Amount) *
//                                                     DtldCVLedgEntryBuf.Amount
//                                                 ELSE
//                                                     DtldStudLedgEntry.Amount := StudentLedgerEntry.Amount
//                                         END;

//                                         //para quando é Pagamento
//                                         IF DtldCVLedgEntryBuf.Amount < 0 THEN BEGIN
//                                             IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" <> DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill")
//                                             THEN BEGIN
//                                                 IF DtldCVLedgEntryBuf.Amount <> -l_StudentLedgerEntry.Amount THEN BEGIN
//                                                     IF NOT CorrectLine THEN
//                                                         DtldStudLedgEntry.Amount := DtldCVLedgEntryBuf.Amount
//                                                     ELSE
//                                                         DtldStudLedgEntry.Amount := -StudentLedgerEntry."Remaining Amount";
//                                                 END ELSE BEGIN
//                                                     IF NOT CorrectLine THEN
//                                                         DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount
//                                                     ELSE
//                                                         DtldStudLedgEntry.Amount := -StudentLedgerEntry."Remaining Amount";
//                                                 END;
//                                             END;
//                                         END;

//                                         //para quando é Pagamento
//                                         IF DtldCVLedgEntryBuf.Amount > 0 THEN BEGIN
//                                             IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" <> DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill")
//                                             THEN BEGIN
//                                                 IF DtldCVLedgEntryBuf.Amount <> l_StudentLedgerEntry.Amount THEN
//                                                     DtldStudLedgEntry.Amount := DtldCVLedgEntryBuf.Amount
//                                                 ELSE
//                                                     DtldStudLedgEntry.Amount := StudentLedgerEntry.Amount;
//                                             END;
//                                         END;

//                                         //Converte a Invoice para Bill
//                                         IF DtldCVLedgEntryBuf.Amount < 0 THEN BEGIN
//                                             IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::" ") AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::Invoice)
//                                             THEN BEGIN
//                                                 IF DtldCVLedgEntryBuf.Amount <> -l_StudentLedgerEntry.Amount THEN
//                                                     DtldStudLedgEntry.Amount := DtldCVLedgEntryBuf.Amount
//                                                 ELSE
//                                                     DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                             END;
//                                         END;

//                                         //Converte a Redraw da Bill
//                                         IF DtldCVLedgEntryBuf.Amount < 0 THEN BEGIN
//                                             IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::" ") AND
//                                               (DtldCVLedgEntryBuf."Initial Document Type" = DtldCVLedgEntryBuf."Initial Document Type"::"PTSS Bill")
//                                             THEN BEGIN
//                                                 InsertNextLine := TRUE;
//                                                 IF DtldCVLedgEntryBuf.Amount <> -l_StudentLedgerEntry.Amount THEN
//                                                     DtldStudLedgEntry.Amount := (StudentLedgerEntry.Amount / l_StudentLedgerEntry.Amount) *
//                                                     DtldCVLedgEntryBuf.Amount
//                                                 ELSE
//                                                     DtldStudLedgEntry.Amount := -StudentLedgerEntry.Amount;
//                                             END;
//                                         END;

//                                         DtldStudLedgEntry."Amount (LCY)" := StudentLedgerEntry."Amount (LCY)";
//                                         StudentUpdateDebitCredit(GenJnlLine.Correction, DtldStudLedgEntry);
//                                         DtldStudLedgEntry."Student Ledger Entry No." := StudentLedgerEntry."Entry No.";
//                                         DtldStudLedgEntry.INSERT;
//                                     END;
//                                 UNTIL StudentLedgerEntry.NEXT = 0;

//                                 StudentLedgerEntry2.RESET;
//                                 StudentLedgerEntry2.COPY(StudentLedgerEntry);
//                                 IF StudentLedgerEntry2.FINDSET THEN BEGIN
//                                     REPEAT
//                                         StudentLedgerEntry2.UpdateFields(StudentLedgerEntry2);
//                                     UNTIL StudentLedgerEntry2.NEXT = 0;
//                                 END;
//                             END;
//                         END;
//                     END;
//                 END;
//             END;
//         END;
//         //C+
//     end;

//     local procedure StudentUpdateDebitCredit(Correction: Boolean; VAR DtldStudLedgEntry: Record "Detailed Stud. Ledg. Entry")
//     begin
//         IF ((DtldStudLedgEntry.Amount > 0) OR (DtldStudLedgEntry."Amount (LCY)" > 0)) AND NOT Correction OR ((DtldStudLedgEntry.Amount < 0) OR (DtldStudLedgEntry."Amount (LCY)" < 0)) AND Correction THEN BEGIN
//             DtldStudLedgEntry."Debit Amount" := DtldStudLedgEntry.Amount;
//             DtldStudLedgEntry."Credit Amount" := 0;
//             DtldStudLedgEntry."Debit Amount (LCY)" := DtldStudLedgEntry."Amount (LCY)";
//             DtldStudLedgEntry."Credit Amount (LCY)" := 0;
//         END ELSE BEGIN
//             DtldStudLedgEntry."Debit Amount" := 0;
//             DtldStudLedgEntry."Credit Amount" := -DtldStudLedgEntry.Amount;
//             DtldStudLedgEntry."Debit Amount (LCY)" := 0;
//             DtldStudLedgEntry."Credit Amount (LCY)" := -DtldStudLedgEntry."Amount (LCY)";
//         END;
//     end;
// }