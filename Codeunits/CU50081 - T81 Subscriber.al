codeunit 50081 "Gen. Journal Line Subscription"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure ProcessingOnSetupNewLine(var GenJournalLine: Record "Gen. Journal Line"; GenJournalBatch: Record "Gen. Journal Batch")
    begin
        //Normatica 2014.09.30 - para preencher automaticamente o Cod. Fluxo de caixa de contrapartida se este estiver conf. na seccção
        IF GenJournalBatch."Bal. cash-flow code" <> '' THEN
            GenJournalLine."PTSS Bal: cash-flow code" := GenJournalBatch."Bal. cash-flow code";
        // fim
    end;
}