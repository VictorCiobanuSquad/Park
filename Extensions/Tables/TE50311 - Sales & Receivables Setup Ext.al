tableextension 50311 "Sales & Receivables Setup Ext." extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Fin. Charges Memo PT Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fin. Charge PT Code';
            Description = 'IT001';
            TableRelation = "Finance Charge Terms";
        }
        field(50001; "Fin. Charges Memo ENG Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fin. Charge ENG Code';
            Description = 'IT001';
            TableRelation = "Finance Charge Terms";
        }
        field(50002; "Reminder Terms Code PT"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reminder Terms Code PT';
            Description = 'IT001';
            TableRelation = "Reminder Terms";
        }
        field(50003; "Reminder Terms Code ENG"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reminder Terms Code';
            Description = 'IT001';
            TableRelation = "Reminder Terms";
        }
    }
}