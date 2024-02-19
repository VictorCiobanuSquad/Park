reportextension 50188 "Create Reminders Ext." extends "Create Reminders"
{
    procedure GetData(pCustomer: Code[20]; pDocumentType: Option)
    begin
        Customer.SETFILTER("No.", '=%1', pCustomer);
        CustLedgEntry2.SETFILTER("Document Type", '=%1', pDocumentType);
    end;
}