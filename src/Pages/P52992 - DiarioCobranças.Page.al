#pragma implicitwith disable
page 52992 "Diario Cobranças"
{
    AutoSplitKey = true;
    Caption = 'Cash Receipt Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("'""Transaction No.""'"; '"Transaction No."')
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("'""Payment Method Code""'"; '"Payment Method Code"')
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_PaymentMethod: Record "Payment Method";
                    begin
                        l_PaymentMethod.Reset;
                        /*
                        IF "Payment Method Code" <> '' THEN BEGIN
                          l_PaymentMethod.SETRANGE(Code,"Payment Method Code");
                          IF l_PaymentMethod.FIND('-') THEN;
                          l_PaymentMethod.SETRANGE(Code);
                        END;
                        IF FORM.RUNMODAL(0,l_PaymentMethod) = ACTION::LookupOK THEN BEGIN
                           VALIDATE("Payment Method Code",l_PaymentMethod.Code);
                        END;
                        */

                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type"; Rec."Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("'""Applies-to Bill No.""'"; '"Applies-to Bill No."')
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            group(Control24)
            {
                ShowCaption = false;
                field(AccName; AccName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Name';
                    Editable = false;
                }
                field(BalAccName; BalAccName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bal. Account Name';
                    Editable = false;
                }
                field(Balance; Balance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatType = 1;
                    Caption = 'Balance';
                    Editable = false;
                    Visible = BalanceVisible;
                }
                field(TotalBalance; TotalBalance + Rec."Balance (LCY)" - xRec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatType = 1;
                    Caption = 'Total Balance';
                    Editable = false;
                    Visible = TotalBalanceVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Apply Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert Conv. LCY Rndg. Lines';
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action(Reconcile)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //FBC
                        ValidateValorPendente;
                        //

                        //C+ -LCF- 07.09.2007
                        // O valor do campo sair é preenchido conforme o valor do CONFIRM da funcao "ValidateValorPedente"
                        if Sair = false then begin
                            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                            CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        end
                        else
                            exit;

                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        //FBC
                        ValidateValorPendente;
                        //


                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);

                        //-MPS
                        CurrPage.Close;
                        //+MPS
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);

        //C+ -LCF- 02.10.2007
        // comentei a linha a baixo porque o tipo de documento varia entre pagamente e reembolso
        //"Document Type" := 1;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        Rec."Document Type" := Rec."Document Type"::Payment;
        Rec.SetUpNewLine(xRec, Balance, BelowxRec);
        Clear(ShortcutDimCode);
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        //GenJnlManagement.TemplateSelection(FORM::"Cash Receipt Journal",3,FALSE,Rec,JnlSelected);
        //IF NOT JnlSelected THEN
        //  ERROR('');
        //GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        CurrentJnlBatchName := Rec.GetFilter("Journal Batch Name");
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Text50001: Label 'O valor a liquidar para a documento Nº %1 é superior ao valor pendente da mesma.';
        Question: Text[250];
        Sair: Boolean;
        ValorDocAPagar: Decimal;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        GLReconcile: Page Reconciliation;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;


    procedure ValidateValorPendente()
    var
        GenJournalLineTEMP: Record "Gen. Journal Line";
        SalesInvoiceHeaderTEMP: Record "Sales Invoice Header" temporary;
        CustLedgerEntryTEMP: Record "Cust. Ledger Entry";
        PaymentMethod: Record "Payment Method";
        Text0001: Label 'O método de pagamento que escolheu obriga que preencha o campo "Nº Cheque" do documento %1.';
    begin
        //C+ -LCF- 08.10.2007
        //Este form esta feito só para as Faturas, agora deverá funcionar para todos os tipos de Documentos,
        //fiz alterações em toda a funcão

        //FBC
        ValorDocAPagar := 0;

        SalesInvoiceHeaderTEMP.DeleteAll;
        GenJournalLineTEMP.Reset;
        GenJournalLineTEMP.Copy(Rec);
        if GenJournalLineTEMP.Find('-') then begin

            CustLedgerEntryTEMP.Reset;
            CustLedgerEntryTEMP.SetRange("Applies-to ID", GenJournalLineTEMP."Applies-to ID");
            if CustLedgerEntryTEMP.Find('-') then begin
                repeat
                    //C+ -LCF- 08.10.2007
                    CustLedgerEntryTEMP.CalcFields("Remaining Amount");
                    ValorDocAPagar := ValorDocAPagar + CustLedgerEntryTEMP."Remaining Amount";
                until CustLedgerEntryTEMP.Next = 0;

                if Abs(ValorDocAPagar) < Abs(GenJournalLineTEMP.Amount) then begin
                    Question := 'O valor de pagamento é superior ao valor a liquidar dos documentos. Desejar continuar ?';
                    if not Confirm(Question, false) then begin
                        Sair := true;
                        exit;
                    end
                    else
                        Sair := false;
                end;
            end;
        end;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance;
    end;
}

#pragma implicitwith restore

