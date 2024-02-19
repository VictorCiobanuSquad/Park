tableextension 50081 "Gen. Journal Line Ext." extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Bank Entity"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Account Description"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Account Description';
        }
        field(50002; "Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry Date';
        }
        field(50003; "Automatic Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Automatic Hold';
        }
        field(73000; "Process by Education"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process by Education';
        }
    }

    trigger OnAfterDelete()
    begin
        DeletePaymentFileErrors; //TFS354624,n
    end;
}