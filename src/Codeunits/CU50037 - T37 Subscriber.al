codeunit 50037 "Sales Line Subscription"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPrice', '', false, false)]
    local procedure ProcessingOnSalesHeaderInsert(var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer)
    var
        SalesPriceCalcMgtET: Codeunit "Sales Price Calc. Mgt.ET03";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        //C+ ET.0004
        if SalesLine.Type = SalesLine.Type::Service then begin
            SalesPriceCalcMgtET.FindSalesLineLineDisc(SalesHeader, SalesLine);
            SalesPriceCalcMgtET.FindSalesLinePrice(SalesHeader, SalesLine, CalledByFieldNo);
        end;
        //
    end;
}