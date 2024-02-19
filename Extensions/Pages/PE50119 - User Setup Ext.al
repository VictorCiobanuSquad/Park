pageextension 50119 "User Setup Ext." extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Reconciliation Admin"; Rec."Reconciliation Admin")
            {
                ApplicationArea = All;
            }
            field("MCT Resp. Filter"; Rec."MCT Resp. Filter")
            {
                ApplicationArea = All;
            }
            field("MCT Admin"; Rec."MCT Admin")
            {
                ApplicationArea = All;
            }
            field("Budget Admin"; Rec."Budget Admin")
            {
                ApplicationArea = All;
            }
            field("Vendor NIB Admin"; Rec."Vendor NIB Admin")
            {
                ApplicationArea = All;
            }
            field("G/L Account Admin"; Rec."G/L Account Admin")
            {
                ApplicationArea = All;
            }
            field("Mgt. Report Admin"; Rec."Mgt. Report Admin")
            {
                ApplicationArea = All;
            }
            field("MCT Contract Reactivation"; Rec."MCT Contract Reactivation")
            {
                ApplicationArea = All;
            }
            field("Delete Consumption Lines"; Rec."Delete Consumption Lines")
            {
                ApplicationArea = All;
            }
            field("View All RCs"; Rec."View All RCs")
            {
                ApplicationArea = All;
            }
            field("Customer NIB Admin"; Rec."Customer NIB Admin")
            {
                ApplicationArea = All;
            }
            field("User Portal"; Rec."User Portal")
            {
                ApplicationArea = All;
            }
        }
        addafter("Purchase Resp. Ctr. Filter")
        {
            field("Education Resp. Ctr. Filter"; Rec."Education Resp. Ctr. Filter")
            {
                ApplicationArea = All;
            }
        }
        addafter("Service Resp. Ctr. Filter")
        {
            field("Debit Card Payment"; Rec."Debit Card Payment")
            {
                ApplicationArea = All;
            }
            field("Check Payment"; Rec."Check Payment")
            {
                ApplicationArea = All;
            }
            field("Credit Card Payment"; Rec."Credit Card Payment")
            {
                ApplicationArea = All;
            }
            field("Cash Payment"; Rec."Cash Payment")
            {
                ApplicationArea = All;
            }
            field("Transfer Payment"; Rec."Transfer Payment")
            {
                ApplicationArea = All;
            }
            field("Allow Credit Memo"; Rec."Allow Credit Memo")
            {
                ApplicationArea = All;
            }
            field("Save Global Filters"; Rec."Save Global Filters")
            {
                ApplicationArea = All;
                Caption = 'Save Global Filters';
            }
        }
    }
}