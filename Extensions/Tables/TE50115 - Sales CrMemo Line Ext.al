tableextension 50115 "Sales Cr.Memo Line Ext." extends "Sales Cr.Memo Line"
{
    /*
    JDE_INT SQD RTV 20210625
        New field: 50000 - "JDE Integrated"
    */
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            else
            if (Type = const(Service)) "Services ET";
        }
        field(50002; "JDE Integrated"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Old,"Not Integrated",Integrated;
            OptionCaption = 'Old,Not Integrated,Integrated';
            Caption = 'JDE Integrated';
            Description = 'JDE_INT SQD RTV 20210625';
            InitValue = "Not Integrated";
        }
    }
}