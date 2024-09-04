xmlport 50054 UpsertTempOrders
{
    /*
Squad GCUI 09/02/2023 To Create and Update Temporary Orders from Portal
*/
    Format = Xml;
    UseDefaultNamespace = true;
    Direction = Import;
    Encoding = UTF8;
    schema
    {
        tableelement(TempOrders; "Encomendas Cab")
        {
            UseTemporary = true;
            AutoUpdate = true;
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'UpsertTempOrders';
            fieldelement(No; TempOrders."No.")
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(SelltoCustomerNo; TempOrders."Sell-to Customer No.")
            {
                //Student
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(OrderDate; TempOrders."Order Date")
            {

                MinOccurs = Once;
                MaxOccurs = Once;
                AutoCalcField = false;
                trigger OnAfterAssignField()
                begin
                    orderdate := TempOrders."Order Date";
                end;
            }
            fieldelement(UsersFamilyCustomerNo; TempOrders."Users Family Customer No.")
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(PortalUserId; TempOrders."Portal User Id")
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }

            fieldelement(Created; TempOrders.Created)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Createdby; TempOrders."Created by")
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Modified; TempOrders.Modified)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(Modifiedby; TempOrders."Modified by")
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            tableelement(TempLines; "Encomendas Linhas")
            {
                UseTemporary = true;
                MinOccurs = Once;
                MaxOccurs = Unbounded;
                XmlName = 'UpsertTempLines';
                fieldelement(DocNo; TempLines."No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(LineNo; TempLines."Line No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(SelltoCustomerNo; TempLines."Sell-to Customer No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(ItemNo; TempLines."Item No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(ItemDescription; TempLines."Item Description")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(VariantCode; TempLines."Variant Code")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(Quantity; TempLines.Quantity)
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
            }
            trigger OnAfterInsertRecord()
            begin
                if not RecTempSalesHeader.Get(TempOrders."No.") then begin
                    RecTempSalesHeader.Init();
                    docType := 'Insert';
                end else begin
                    docType := 'Update';
                    //if RecTempSalesHeader.CheckIfHeaderExist(TempOrders."No.") then begin
                    //docType := 'Update';
                    //docType := 'Insert';
                end;
                RecTempSalesHeader.Validate("Sell-to Customer No.", TempOrders."Sell-to Customer No.");
                RecCustomer.get(TempOrders."Sell-to Customer No.");
                TempOrders."Sell-to Customer Name" := RecCustomer.Name;
                RecTempSalesHeader.Validate("Sell-to Customer Name", TempOrders."Sell-to Customer Name");
                RecTempSalesHeader.Validate("Order Date", orderDate);
                if TempOrders."Users Family Customer No." = '' then
                    TempOrders."Users Family Customer No." := TempOrders."Sell-to Customer No.";
                RecTempSalesHeader.Validate("Users Family Customer No.", TempOrders."Users Family Customer No.");
                if TempOrders."Bill-to Customer Name" = '' then begin
                    RecCustomer.get(TempOrders."Users Family Customer No.");
                    TempOrders."Bill-to Customer Name" := RecCustomer.Name;
                end;
                RecTempSalesHeader.Validate("Bill-to Customer Name", TempOrders."Bill-to Customer Name");
                RecTempSalesHeader.Validate("Portal user Id", TempOrders."Portal user Id");

                //dimension?
                if docType = 'Insert' then begin
                    if not RecTempSalesHeader.Insert(true) then begin
                        Error('Insert error');
                    end;
                end;
                RecTempSalesHeader."Order Date" := orderDate;
                if not RecTempSalesHeader.Modify() then begin
                    Error(StrSubstNo('Modify Error: %1', GetLastErrorText));
                end;
                //if RecTempSalesLines.FindSet() then begin
                if TempLines.FindSet() then begin

                    repeat
                        RecTempSalesLines.Init();
                        RecTempSalesLines."Line No." := TempLines."Line No.";
                        RecTempSalesLines."No." := RecTempSalesHeader."No.";
                        //RecTempSalesLines.Validate("No.",TempLines."No.");
                        RecTempSalesLines.Validate("Sell-to Customer No.", TempLines."Sell-to Customer No.");
                        RecTempSalesLines.Validate("Item No.", TempLines."Item No.");
                        RecTempSalesLines.Validate("Item Description", TempLines."Item Description");
                        RecTempSalesLines.Validate("Variant Code", TempLines."Variant Code");
                        RecTempSalesLines.Validate(Quantity, TempLines.Quantity);
                        RecTempSalesLines.Insert();
                    //RecTempSalesLines.UpdateAmounts();
                    until TempLines.next() = 0;
                end;
            end;
        }
    }
    var
        orderDate: Date;
        xmlStr: Text;
        docType: Text;

        RecTempSalesHeader: Record "Encomendas Cab";
        RecTempSalesLines: Record "Encomendas Linhas";
        RecCustomer: Record Customer;
        RecItem: Record Item;
        RecItemVariant: Record "Item Variant";
}