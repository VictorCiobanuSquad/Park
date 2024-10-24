codeunit 50038 "Purchase Header Subscription"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    local procedure ProcessingOnInitRecord(var PurchHeader: Record "Purchase Header")
    var
        recNoSeries: Record "No. Series";
    //NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            //Início - C+_RSC_C+ 18.02.2010 - Alteração da númeração de série
            IF recNoSeries.GET(PurchHeader."No. Series") THEN
                PurchHeader."Posting No. Series" := recNoSeries."Registed Nos.";
        //TODO: to test line above
        //NoSeriesMgt.SetDefaultSeries(PurchHeader."Posting No. Series", recNoSeries."Registed Nos.");
        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" then
            //Início - C+_RSC_C+ 18.02.2010 - Alteração da númeração de série
            IF recNoSeries.GET(PurchHeader."No. Series") THEN
                PurchHeader."Posting No. Series" := recNoSeries."Registed Nos.";
        //TODO: to test line above
        //NoSeriesMgt.SetDefaultSeries(PurchHeader."Posting No. Series", recNoSeries."Registed Nos.");
        //RSC
        PurchHeader."Entry Date" := WORKDATE;
        //
    end;
}