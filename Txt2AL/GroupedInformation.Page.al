#pragma implicitwith disable
page 31009780 "Grouped Information"
{
    // Globals:
    // 
    // reportInvoicingServices Report 31009752

    Caption = 'Grouped Information';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            part("Planos Serviços Aluno"; "SubForm Student Services Plan")
            {
                Caption = 'Planos Serviços Aluno';
                //Editable = false;
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
            }
            part("Serviços Dist. Ent."; "SubForm Services DistEntity")
            {
                Caption = 'Serviços Dist. Ent.';
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
            }
            part("Mov. Aluno"; "SubForm Student Ledger Entry")
            {
                Caption = 'Mov. Aluno';
                // Editable = false;
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
                SubPageView = WHERE("Registed Invoice No." = FILTER(''));
            }
            part("SubForm Student Ledger Entry"; "SubForm Student Ledger Entry")
            {
                Caption = 'Mov. Faturados Aluno';
                //Editable = false;
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
                SubPageView = WHERE("Registed Invoice No." = FILTER(<> ''));
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Processing Services")
            {
                Caption = '&Processing Services';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rRegistration.Reset;
                    rRegistration.SetRange(rRegistration."Student Code No.", Rec."Student Code No.");
                    rRegistration.SetRange("School Year", Rec."School Year");
                    if rRegistration.Find('-') then begin
                        reportProcessarServiços.SetTableView(rRegistration);
                        reportProcessarServiços.Run;
                    end;
                end;
            }
            action("&Services Bill")
            {
                Caption = '&Services Bill';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*
                    rStudentLedgerEntry.RESET;
                    rStudentLedgerEntry.SETRANGE("Student No.","Student Code No.");
                    rStudentLedgerEntry.SETRANGE("School Year","School Year");
                    IF rStudentLedgerEntry.FIND('-') THEN BEGIN
                       reportInvoicingServices.SETTABLEVIEW(rStudentLedgerEntry);
                       reportInvoicingServices.RUN;
                    
                    END;
                    */

                end;
            }
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

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
            action(Action1102065001)
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rStudentLedgerEntry.Reset;
                    rStudentLedgerEntry.SetRange("Student No.", Rec."Student Code No.");
                    rStudentLedgerEntry.SetRange("School Year", Rec."School Year");
                    if cUserEducation.GetEducationFilter(UserId) <> '' then
                        rStudentLedgerEntry.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                    if rStudentLedgerEntry.Find('-') then
                        REPORT.RunModal(31009808, true, true, rStudentLedgerEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            Rec.SetFilter("School Year", rSchoolYear."School Year");
        end;
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
}

#pragma implicitwith restore

