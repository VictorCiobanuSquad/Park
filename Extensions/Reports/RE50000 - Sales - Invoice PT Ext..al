reportextension 50000 "Sales - Invoice PT Ext." extends "PTSS Sales - Invoice (PT)"
{
    RDLCLayout = './Park Sales Invoice.rdl';

    dataset
    {

        add("Sales Invoice Header")
        {
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Location_Name; "Responsibility Center") { }
            column(Bill_to_Customer_Name; rCustomer.Name) { }
            column(Turma; Turma) { }
            column(Text50001; Text50001) { }
            column(Text50002; Text50002) { }
            column(Text50003; Text50003) { }
            column(Text50004; Text50004) { }
            column(Text50005; Text50005) { }
            column(Text50006a; Text50006a) { }
            column(Text50006b; Text50006b) { }
            column(Text50007; Text50007) { }
            column(Text50007a; Text50007a) { }
            column(Text50007b; Text50007b) { }
            column(Text50008; Text50008) { }
            column(Text50009; Text50009) { }
            column(Text50010; Text50010) { }
            column(Order_No_; "Order No.") { }
        }

        modify("Sales Invoice Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                //IT002 - Parque 2016.10.27 - ir buscar a localização
                //IF rLocation.GET("Sales Invoice Header"."Location Code") THEN;

                if rCustomer.get("Sales Invoice Header"."Bill-to Customer No.") then;

                //IT002 - Parque 2016.10.27 - ir buscar a localização - en
            end;
        }
    }

    labels
    {
        StudentLbl = 'Student';
        CampusLbl = 'Campus';
        ClassLbl = 'Class';
    }

    var
        rLocation: Record Location;
        rCustomer: Record Customer;
        Text50001: Label 'Registered in Commercial Reg.Office of';
        Text50002: Label 'under no.';
        Text50003: Label 'I intend to return the following products:';
        Text50004: Label '(PROD|SIZE|QTY); ____|____|____; ____|____|____; ____|____|____; ____|____|____; ____|____|____';
        Text50005: Label 'Total Invoice Return:';
        Text50006a: Label 'Posting Date:';
        Text50006b: Label 'Posting Date';
        Text50007: Label 'Bill-to Customer Name:';
        Text50007a: Label 'Campus';
        Text50007b: Label 'Class';
        Text50008: Label 'Student''s Name';
        Text50009: Label 'I received the articles above identified';
        Text50010: Label 'Signature:___________________';
        Text50011: Label 'Enc. Submetida por';
}