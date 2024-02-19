xmlport 50057 CreateReturnOrders
{
    /*
Squad GCUI 09/02/2023 To Create and Update Return Orders from Portal
*/
    Format = Xml;
    UseDefaultNamespace = true;
    Direction = Import;
    Encoding = UTF8;
    schema
    {
        tableelement(ReturnOrders; "Devolucoes Cab")
        {
            UseTemporary = true;
            AutoUpdate = true;
            MaxOccurs = Once;
            MinOccurs = Once;
            XmlName = 'CreateReturnOrders';
            // fieldelement(SelltoCustomerNo; ReturnOrders."Sell-to Customer No.")
            // {
            //     //Student
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(SelltoCustomerName; ReturnOrders."Sell-to Customer Name")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            fieldelement("Date"; ReturnOrders.Date)
            {//today
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(InvoiceNo; ReturnOrders."Invoice No.")
            {

                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Created; ReturnOrders.Created)
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(CreatedBy; ReturnOrders."Created by")
            {
                MinOccurs = Once;
                MaxOccurs = Once;
            }
            fieldelement(Modified; ReturnOrders.Modified)
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            fieldelement(ModifiedBy; ReturnOrders."Modified by")
            {
                MinOccurs = Zero;
                MaxOccurs = Once;
            }
            // tableelement(ReturnLines; "Devolucoes Linhas")
            // {
            //     UseTemporary = true;
            //     MinOccurs = Once;
            //     MaxOccurs = Unbounded;
            //     XmlName = 'InsertReturnLines';
            // fieldelement(ReturnNo; ReturnLines."No.")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(LineNo; ReturnLines."Line No.")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(SelltoCustomerNo; ReturnLines."Sell-to Customer No.")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(ItemNo; ReturnLines."Item No.")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(ItemDescription; ReturnLines."Item Description")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(VariantCode; ReturnLines."Variant Code")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(Quantity; ReturnLines.Quantity)
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(SalesInvoiceLine; ReturnLines."Sales Invoice Line")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // fieldelement(ReturnReasonCode; ReturnLines."Return Reason Code")
            // {
            //     MinOccurs = Once;
            //     MaxOccurs = Once;
            // }
            // }
            trigger OnAfterInsertRecord()
            begin
                RecReturHeader.Validate("Sell-to Customer No.", ReturnOrders."Sell-to Customer No.");
                RecReturHeader.Validate("Sell-to Customer Name", ReturnOrders."Sell-to Customer Name");
                RecReturHeader.Validate("Date", ReturnOrders.Date);
                RecReturHeader.Validate("Invoice No.", ReturnOrders."Invoice No.");
                if not RecReturHeader.Insert(true) then begin
                    Error('Insert error');
                end;
                // if ReturnLines.FindSet() then begin

                //     repeat
                //         RecReturnLines.Init();
                //         RecReturnLines."Line No." := ReturnLines."Line No.";
                //         RecReturnLines."No." := RecReturHeader."No.";
                //         //RecTempSalesLines.Validate("No.",TempLines."No.");
                //         RecReturnLines.Validate("Sell-to Customer No.", ReturnLines."Sell-to Customer No.");
                //         RecReturnLines.Validate("Item No.", ReturnLines."Item No.");
                //         RecReturnLines.Validate("Item Description", ReturnLines."Item Description");
                //         RecReturnLines.Validate("Variant Code", ReturnLines."Variant Code");
                //         RecReturnLines.Validate(Quantity, ReturnLines.Quantity);
                //         RecReturnLines.Insert();
                //     //RecTempSalesLines.UpdateAmounts();
                //     until ReturnLines.next() = 0;
                // end;
            end;
        }
    }
    var
        RecReturHeader: Record "Devolucoes Cab";
        RecReturnLines: Record "Devolucoes Linhas";
}