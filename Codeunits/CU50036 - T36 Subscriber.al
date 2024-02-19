codeunit 50036 "Sales Header Subscription"
{
    /*            
    IT001 - 03-09-2016
        - Para encomendas:
            - Alterado o preenchimento do número de série conforme configuração do campo "Registed Nos"
            - Ao criar o documento o campo "Preços IVA Incluído" = TRUE
            
    IT003 - Parque - 2016.10.06

    IT004 - Parque - 2016.10.13 - preencher automaticamente texto registo
    */
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure ProcessingOnInitRecord(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."Posting Description" := FORMAT(SalesHeader."Document Type");        //Norm 1 new        
        //IT001,sn
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
            SalesHeader."Prices Including VAT" := TRUE;
        //IT001,en
    end;
}