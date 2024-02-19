reportextension 50001 "Sales - Credit Memo PT Ext." extends "PTSS Sales - Credit Memo (PT)"
{
    RDLCLayout = './Sales - Credit Memo PT Ext.rdlc';

    dataset
    {
        add("Sales Cr.Memo Header")
        {
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Location_Name; rLocation.Name) { }
            column(Turma; Turma) { }
        }

        modify("Sales Cr.Memo Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                //IT002 - Parque 2016.10.27 - ir buscar a localização
                IF rLocation.GET("Sales Cr.Memo Header"."Location Code") THEN;
                //IT002 - Parque 2016.10.27 - ir buscar a localização - en
            end;
        }
    }

    labels
    {
        StudentLbl = 'Student';
        ampusLbl = 'Campus';
        ClassLbl = 'Class';
    }

    var
        rLocation: Record Location;
}