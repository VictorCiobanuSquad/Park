codeunit 56620 "Copy Document Mgt. Sub."
{
    /*
    //IT002 - Park - 2019.02.01 - Quando copia o documento ter o texto em multilingua
    */
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesDocNoLine', '', false, false)]
    local procedure ProcessOnBeforeInsertOldSalesDocNoLine(var ToSalesHeader: Record "Sales Header"; OldDocNo: Code[20]; OldDocType: Option)
    var
        Cust: Record Customer;
        ToSalesLine2: Record "Sales Line";
        Text013: Label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
        Text015: Label '%1 %2:';
        Text50000: Label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
    begin
        //IT002, sn
        //ToSalesLine2.Description := STRSUBSTNO(Text015,SELECTSTR(OldDocType,Text013),OldDocNo);
        IF Cust.GET(ToSalesHeader."Bill-to Customer No.") THEN BEGIN
            IF (Cust."Language Code" = 'PTG') OR (Cust."Language Code" = '') THEN
                ToSalesLine2.Description := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text013), OldDocNo)
            ELSE
                ToSalesLine2.Description := STRSUBSTNO(Text015, SELECTSTR(OldDocType, Text50000), OldDocNo);
        END;
        //IT002, en
    end;
}