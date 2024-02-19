tableextension 50027 "Item Ext." extends Item
{
    trigger OnInsert()
    var
        InvtSetup: Record "Inventory Setup";
    begin
        InvtSetup.get;
        //IT003 - Park - 2017.12.13 - Portal Fardas, sn
        Rec."Item Category Code" := InvtSetup."Item Category Code by Default";
        //Rec."Product Group Code" := InvtSetup."Product Group Code by Default";
        //IT003 - Park - 2017.12.13 - Portal Fardas, en
    end;
}