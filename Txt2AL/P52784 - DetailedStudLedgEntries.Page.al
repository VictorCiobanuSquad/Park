#pragma implicitwith disable
page 52784 "Detailed Stud. Ledg. Entries"
{
    Caption = 'Detailed Stud. Ledg. Entries';
    DataCaptionFields = "Cust. Ledger Entry No.", "Customer No.";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Detailed Stud. Ledg. Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount in VAT Report"; Rec."Amount in VAT Report")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Initial Entry Due Date"; Rec."Initial Entry Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Unapplied; Rec.Unapplied)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unapplied by Entry No."; Rec."Unapplied by Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    case Rec."Document Type" of
                        Rec."Document Type"::Invoice:
                            begin
                                rSalesInvoiceHeader.Reset;
                                rSalesInvoiceHeader.SetRange("No.", Rec."Document No.");
                                if rSalesInvoiceHeader.FindSet then begin
                                    rReportSelection.Reset;
                                    rReportSelection.SetRange(Usage, rReportSelection.Usage::"S.Invoice");
                                    if rReportSelection.FindSet then begin
                                        repeat
                                            REPORT.Run(rReportSelection."Report ID", true, false, rSalesInvoiceHeader);
                                        until rReportSelection.Next = 0;
                                    end;
                                end;
                            end;
                        Rec."Document Type"::Payment:
                            begin
                                if rEduConfiguration.Get then begin
                                    if rGenJnlTemplate.Get(rEduConfiguration."Journal Template Name") then begin
                                        if rGenJnlTemplate."Cust. Receipt Report ID" <> 0 then begin
                                            rCustLedgEntry.Reset;
                                            rCustLedgEntry.SetRange("Document Type", Rec."Document Type"::Payment);
                                            rCustLedgEntry.SetRange("Document No.", Rec."Document No.");
                                            REPORT.Run(rGenJnlTemplate."Cust. Receipt Report ID", true, false, rCustLedgEntry);
                                        end;
                                    end;
                                end;
                            end;
                        Rec."Document Type"::"Credit Memo":
                            begin
                                rSalesCrMemoHeader.Reset;
                                rSalesCrMemoHeader.SetRange("No.", Rec."Document No.");
                                if rSalesCrMemoHeader.FindSet then begin
                                    rReportSelection.Reset;
                                    rReportSelection.SetRange(Usage, rReportSelection.Usage::"S.Cr.Memo");
                                    if rReportSelection.FindSet then begin
                                        repeat
                                            REPORT.Run(rReportSelection."Report ID", true, false, rSalesCrMemoHeader);
                                        until rReportSelection.Next = 0;
                                    end;
                                end;
                            end;
                    end;
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        rCustLedgEntry: Record "Cust. Ledger Entry";
        rEduConfiguration: Record "Edu. Configuration";
        rGenJnlTemplate: Record "Gen. Journal Template";
        rReportSelection: Record "Report Selections";
        Navigate: Page Navigate;
}

#pragma implicitwith restore

