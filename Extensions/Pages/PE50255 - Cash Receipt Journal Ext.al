pageextension 50255 "Cash Receipt Journal Ext." extends "Cash Receipt Journal"
{
    /*
    //IT001 - Park - 2018.06.15 - Novo campo Cod. Forma Pagamento
    */
    layout
    {
        addafter("Document Type")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            var
                GenJournalTemplate: Record "Gen. Journal Template";
                GenJournalBatch: Record "Gen. Journal Batch";
            begin
                //2015.08.03
                GenJournalTemplate.RESET;
                GenJournalTemplate.SETRANGE(GenJournalTemplate.Name, Rec."Journal Template Name");
                GenJournalTemplate.SETRANGE(GenJournalTemplate.Type, GenJournalTemplate.Type::"Cash Receipts");
                IF GenJournalTemplate.FINDFIRST THEN BEGIN
                    IF Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" THEN BEGIN
                        GenJournalBatch.RESET;
                        GenJournalBatch.SETRANGE(GenJournalBatch."Journal Template Name", Rec."Journal Template Name");
                        GenJournalBatch.SETRANGE(GenJournalBatch.Name, Rec."Journal Batch Name");
                        IF GenJournalBatch.FINDFIRST THEN
                            Rec.VALIDATE("PTSS Bal: cash-flow code", GenJournalBatch."Bal. cash-flow code");
                    END;
                END;
            end;
        }
    }
}