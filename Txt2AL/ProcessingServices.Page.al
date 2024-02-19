#pragma implicitwith disable
page 31009952 "Processing Services"
{
    // #001 SQD RTV 20211029 Ticket#NAV202100701
    //   Made "Mov. Aluno" editable to allow correction of services
    // 
    // Variavel: reportInvoicingServices Report 31009752

    Caption = 'Processing Services';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            part("Student Ledger Entry"; "SubForm Student Ledger Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Student Ledger Entry';
                SubPageLink = "School Year" = FIELD("School Year");
                SubPageView = WHERE("Registed Invoice No." = FILTER(''));
            }
            part("Student Invoiced Ledger Entry"; "SubForm Student Ledger Entry F")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Student Invoiced Ledger Entry';
                Editable = false;
                SubPageLink = "School Year" = FIELD("School Year");
                SubPageView = WHERE("Registed Invoice No." = FILTER(<> ''));
            }
            part("Plano Serviços Alunos"; "SubForm Student Services Plan")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Plano Serviços Alunos';
                SubPageLink = "School Year" = FIELD("School Year");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("P&rocessing Services")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&rocessing Services';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rRegistration.Reset;
                    rRegistration.SetRange("School Year", varSchoolYear);
                    if rRegistration.Find('-') then begin
                        Clear(reportProcessarServiços);
                        reportProcessarServiços.SetTableView(rRegistration);
                        reportProcessarServiços.RunModal;
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("&Services Bill")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Services Bill';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rStudentLedgerEntry.Reset;
                    rStudentLedgerEntry.SetRange("School Year", varSchoolYear);
                    if rStudentLedgerEntry.Find('-') then begin
                        Clear(reportInvoicingServices);
                        reportInvoicingServices.SetTableView(rStudentLedgerEntry);
                        reportInvoicingServices.Run;
                    end;
                end;
            }
        }
        area(reporting)
        {
            action("&Pre Invoice Detail")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Pre Invoice Detail';
                Image = PreviewChecks;

                trigger OnAction()
                begin
                    rStudentLedgerEntry.Reset;
                    rStudentLedgerEntry.SetRange("School Year", Rec."School Year");
                    if cUserEducation.GetEducationFilter(UserId) <> '' then
                        rStudentLedgerEntry.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                    if rStudentLedgerEntry.Find('-') then
                        REPORT.RunModal(31009808, true, true, rStudentLedgerEntry);
                end;
            }
            action("Print &Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print &Invoice';
                Image = PrintReport;

                trigger OnAction()
                begin
                    rSalesInvoiceHeader.Reset;
                    //rSalesInvoiceHeader.SETRANGE("No.",CurrPage."SubForm Student Ledger Entry".Page.GetRecord);
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
            }
        }
    }

    trigger OnOpenPage()
    begin
        //cStudentsRegistration.CompanyLimitation;
        Rec.Reset;
        GetSchoolYear;
        Rec.SetRange("School Year", varSchoolYear);
    end;

    var
        "reportProcessarServiços": Report "Processing Services";
        rStudentServicePlan: Record "Student Service Plan";
        rSchoolYear: Record "School Year";
        rStudentLedgerEntry: Record "Student Ledger Entry";
        rRegistration: Record Registration;
        rSalesInvoiceHeader: Record "Sales Invoice Header";
        rReportSelection: Record "Report Selections";
        cUserEducation: Codeunit "User Education";
        vInvoiceCode: Code[20];
        varSchoolYear: Code[20];
        cStudentsRegistration: Codeunit "Students Registration";
        reportInvoicingServices: Report "Invoicing Services";

    //[Scope('OnPrem')]
    procedure GetSchoolYear()
    var
        tLectiveYear: Text[1024];
        int: Integer;
        l_SchoolYear: Record "School Year";
    begin
        Clear(varSchoolYear);
        l_SchoolYear.Reset;
        l_SchoolYear.SetFilter(Status, '%1|%2|%3', l_SchoolYear.Status::Active,
                               l_SchoolYear.Status::Planning,
                               l_SchoolYear.Status::Closing);

        if l_SchoolYear.Find('-') then begin
            repeat
                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
            until l_SchoolYear.Next = 0;

            Clear(int);

            if tLectiveYear <> '' then begin
                int := StrMenu(tLectiveYear);
                l_SchoolYear.Reset;
                l_SchoolYear.SetFilter(Status, '%1|%2|%3', l_SchoolYear.Status::Active,
                                       l_SchoolYear.Status::Planning,
                                       l_SchoolYear.Status::Closing);
                if l_SchoolYear.Find('-') and (int <> 0) then
                    l_SchoolYear.Next := int - 1
                else
                    exit;
            end;

            varSchoolYear := l_SchoolYear."School Year";

        end;
    end;
}

#pragma implicitwith restore

