codeunit 31009779 "Sales-Post + Print EDUSOL"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        Text000: Label '&Ship,&Invoice,Ship &and Invoice';
        Text001: Label 'Do you want to post and print the %1?';
        Text002: Label '&Receive,&Invoice,Receive &and Invoice';
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReportSelection: Record "Report Selections";
        SalesPost: Codeunit "Sales-Post";
        Selection: Integer;

    local procedure "Code"()
    begin

        SalesPost.Run(SalesHeader);

        GetReport(SalesHeader);
        Commit;
    end;

    //[Scope('OnPrem')]
    procedure GetReport(var SalesHeader: Record "Sales Header")
    begin

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    if SalesHeader.Ship then begin
                        SalesShptHeader."No." := SalesHeader."Last Shipping No.";
                        SalesShptHeader.SetRecFilter;
                        PrintReport(ReportSelection.Usage::"S.Shipment");
                    end;
                    if SalesHeader.Invoice then begin
                        SalesInvHeader."No." := SalesHeader."Last Posting No.";
                        SalesInvHeader.SetRecFilter;
                        PrintReport(ReportSelection.Usage::"S.Invoice");
                    end;
                end;
            SalesHeader."Document Type"::Invoice:
                begin
                    if SalesHeader."Last Posting No." = '' then
                        SalesInvHeader."No." := SalesHeader."No."
                    else
                        SalesInvHeader."No." := SalesHeader."Last Posting No.";
                    SalesInvHeader.SetRecFilter;
                    PrintReport(ReportSelection.Usage::"S.Invoice");
                end;
            SalesHeader."Document Type"::"Return Order":
                begin
                    if SalesHeader.Receive then begin
                        ReturnRcptHeader."No." := SalesHeader."Last Return Receipt No.";
                        ReturnRcptHeader.SetRecFilter;
                        PrintReport(ReportSelection.Usage::"S.Ret.Rcpt.");
                    end;
                    if SalesHeader.Invoice then begin
                        SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
                        SalesCrMemoHeader.SetRecFilter;
                        PrintReport(ReportSelection.Usage::"S.Cr.Memo");
                    end;
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    if SalesHeader."Last Posting No." = '' then
                        SalesCrMemoHeader."No." := SalesHeader."No."
                    else
                        SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
                    SalesCrMemoHeader.SetRecFilter;
                    PrintReport(ReportSelection.Usage::"S.Cr.Memo");
                end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Enum "Report Selection Usage")
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, ReportUsage);
        ReportSelection.FindSet;
        repeat
            ReportSelection.TestField("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"SM.Invoice":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesInvHeader);
                ReportSelection.Usage::"SM.Credit Memo":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesCrMemoHeader);
                ReportSelection.Usage::"S.Invoice":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesInvHeader);
                ReportSelection.Usage::"S.Cr.Memo":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesCrMemoHeader);
                ReportSelection.Usage::"S.Shipment":
                    REPORT.Run(ReportSelection."Report ID", false, false, SalesShptHeader);
                ReportSelection.Usage::"S.Ret.Rcpt.":
                    REPORT.Run(ReportSelection."Report ID", false, false, ReturnRcptHeader);
            end;
        until ReportSelection.Next = 0;
    end;
}

