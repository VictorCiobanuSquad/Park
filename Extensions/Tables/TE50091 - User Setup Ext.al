tableextension 50091 "User Setup Extension" extends "User Setup"
{
    fields
    {
        field(50000; "MCT Resp. Filter"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'MCT Resp. Ctr. Filter';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                "Sales Resp. Ctr. Filter" := "MCT Resp. Filter";
                "Purchase Resp. Ctr. Filter" := "MCT Resp. Filter";
                "Service Resp. Ctr. Filter" := "MCT Resp. Filter";
            end;
        }
        field(50001; "MCT Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Budget Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Vendor NIB Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Admin NIB Fornecedor';
        }
        field(50004; "G/L Account Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Mgt. Report Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Reconciliation Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "MCT Contract Reactivation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Delete Consumption Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Delete Consumption Lines';
        }
        field(50009; "View All RCs"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Customer NIB Admin"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Admin NIB Cliente';
        }
        field(50011; "User Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Utilizador Portal';
        }
        field(73000; "Education Resp. Ctr. Filter"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Education Resp. Ctr. Filter';
            TableRelation = "Responsibility Center";
        }
        field(73002; "Debit Card Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Debit Card Payment';
            //TableRelation = "Payment Method" WHERE ("Payment Edu"=FILTER(Yes));
        }
        field(73003; "Check Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Check Payment';
            //TableRelation = "Payment Method" WHERE ("Payment Edu"=FILTER(Yes));
        }
        field(73004; "Credit Card Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Card Payment';
            //TableRelation = "Payment Method" WHERE ("Payment Edu"=FILTER(Yes));
        }
        field(73005; "Cash Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cash Payment';
            //TableRelation = "Payment Method" WHERE ("Payment Edu"=FILTER(Yes));
        }
        field(73006; "Transfer Payment"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Transfer Payment';
            //TableRelation = "Payment Method" WHERE ("Payment Edu"=FILTER(Yes));
        }
        field(73007; "Save Global Filters"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Save Global Filters';
        }
        field(73008; "Allow Credit Memo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allow Credit Memo';
        }
    }
}