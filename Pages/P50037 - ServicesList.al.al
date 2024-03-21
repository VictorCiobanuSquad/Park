#pragma implicitwith disable
page 50037 "Service ET List 2"
{
    Caption = 'Service List';
    PageType = List;
    SourceTable = "Services ET";
    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subsidy; Rec.Subsidy)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Subsidy Type"; Rec."Subsidy Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Disc. Group"; Rec."Service Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Serv. Posting Group"; Rec."Gen. Serv. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Serv. Posting Group"; Rec."VAT Serv. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IRS Declaration Code"; Rec."IRS Declaration Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IRS Declaration Description"; Rec."IRS Declaration Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Depending Other"; Rec."Service Depending Other")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Depending Code"; Rec."Service Depending Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Percent %"; Rec."Percent %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price Purchase"; Rec."Unit Price Purchase")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }



}

