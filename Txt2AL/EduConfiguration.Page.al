#pragma implicitwith disable
page 31009754 "Edu. Configuration"
{
    // #002 SQD RTV 20201016 Ticket#NAV202000547
    //   Added fields "Student Photos Export" and "Teacher Photos Export"
    // 
    // #001 SQD RTV 20200417
    //   Fixed actions for editing Credit Memo texts

    Caption = 'Edu. Configuration';
    PageType = Card;
    SourceTable = "Edu. Configuration";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Candidate Nos."; Rec."Candidate Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Nos."; Rec."Student Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Users Family Nos."; Rec."Users Family Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Teacher Nos."; Rec."Teacher Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Nos."; Rec."Service Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Nos."; Rec."Study Plan Nos.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan Nos';
                }
                field("Course Nos."; Rec."Course Nos.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Course Nos';
                }
                field("Service Plan Nos."; Rec."Service Plan Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class Nos."; Rec."Class Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Timetable Nos."; Rec."Timetable Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Test Nos."; Rec."Test Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Room Nos."; Rec."Room Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transport Nos."; Rec."Transport Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Recover Test Nos."; Rec."Recover Test Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Equipment Nos."; Rec."Equipment Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Group Equipment Nos."; Rec."Group Equipment Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("Use Student Disc. Group"; Rec."Use Student Disc. Group")
                {
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("No. Series Journals"; Rec."No. Series Journals")
                {
                }
                field("Placement Reser. Service Cod."; Rec."Placement Reser. Service Cod.")
                {
                }
                field("Send E-Mail Reminder"; Rec."Send E-Mail Reminder")
                {
                }
                group("Servidor Email")
                {
                    Caption = 'Servidor Email';
                }
                field("Send E-Mail Invoice"; Rec."Send E-Mail Invoice")
                {
                }
                field("Send E-Mail Receipt"; Rec."Send E-Mail Receipt")
                {
                }
            }
            group("General Data")
            {
                Caption = 'General Data';
                field("Use Formation Component"; Rec."Use Formation Component")
                {
                }
                field("Order Class"; Rec."Order Class")
                {
                }
                field("Full Name syntax"; Rec."Full Name syntax")
                {
                    Caption = 'Sintaxe Nome Abreviado';
                }
                field("School Calendar"; Rec."School Calendar")
                {
                }
                field("Daily Equity Absences"; Rec."Daily Equity Absences")
                {
                }
            }
            group(Fotos)
            {
                Caption = 'Fotos';
                field("Student Photos"; Rec."Student Photos")
                {
                }
                field("Candidate Photos"; Rec."Candidate Photos")
                {
                }
                field("Teacher Photos"; Rec."Teacher Photos")
                {
                }
                field("Users Family Photos"; Rec."Users Family Photos")
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&IRS / E-mail Statement Config")
            {
                Caption = '&IRS / E-mail Statement Config';
                action("&Section - 1 IRS")
                {
                    Caption = '&Section - 1 IRS';
                    Image = CalculateSalesTax;
                    ToolTip = '%1 - Name of Student;%2 - Name of the Father;%3 - Name of the Mother;%4 - Date of Birth;%5 -Civil year';

                    trigger OnAction()
                    begin
                        cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"IRS Statement", text001, Type::Irs, 0);
                    end;
                }
                action("&Section - 2 IRS")
                {
                    Caption = '&Section - 2 IRS';
                    Image = CalculateSalesTax;

                    trigger OnAction()
                    begin
                        cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"IRS Statement", text002, Type::Irs, 0);
                    end;
                }
            }
            group("&Texto E-Mail")
            {
                Caption = '&Texto E-Mail';
                Image = Text;
                group("&Faturas")
                {
                    Caption = '&Faturas';
                    Image = Invoice;
                    action("&Subject E-Mail")
                    {
                        Caption = '&Subject E-Mail';
                        Image = Email;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text003, Type::Email, 1);
                        end;
                    }
                    action("&Body E-Mail")
                    {
                        Caption = '&Body E-Mail';
                        Image = OutlookSyncSubFields;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text004, Type::Email, 1);
                        end;
                    }
                }
                group("&Notas Crédito")
                {
                    Caption = '&Notas Crédito';
                    Image = CreditMemo;
                    action("&Assunto E-Mail")
                    {
                        Caption = '&Assunto E-Mail';
                        Image = Email;

                        trigger OnAction()
                        begin
                            //#001 START SQD RTV 20200417
                            //cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"Invoice Email",text003,Type::Email,3);
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-mail", text003, Type::Email, 3);
                            //#001 STOP SQD RTV 20200417
                        end;
                    }
                    action("&Corpo E-mail")
                    {
                        Caption = '&Corpo E-mail';
                        Image = OutlookSyncSubFields;

                        trigger OnAction()
                        begin
                            //#001 START SQD RTV 20200417
                            //cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"Invoice Email",text004,Type::Email,3);
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-mail", text004, Type::Email, 3);
                            //#001 STOP SQD RTV 20200417
                        end;
                    }
                }
                group("&Avisos de Cobrança")
                {
                    Caption = '&Avisos de Cobrança';
                    Image = CarryOutActionMessage;
                    action(Action1000000006)
                    {
                        Caption = '&Assunto E-Mail';
                        Image = Email;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text003, Type::Email, 2);
                        end;
                    }
                    action(Action1000000007)
                    {
                        Caption = '&Corpo E-mail';
                        Image = OutlookSyncSubFields;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text004, Type::Email, 2);
                        end;
                    }
                }
                group("&Recibos")
                {
                    Caption = '&Recibos';
                    Image = CashReceiptJournal;
                    action(Action1000000009)
                    {
                        Caption = '&Assunto E-Mail';
                        Image = Email;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text003, Type::Email, 4);
                        end;
                    }
                    action(Action1000000010)
                    {
                        Caption = '&Corpo E-mail';
                        Image = OutlookSyncSubFields;

                        trigger OnAction()
                        begin
                            cuRemarks.EditCommentLineText(l_rCommentLine."Table Name"::"E-Mail", text004, Type::Email, 4);
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            action("&Update Invoice Data")
            {
                Caption = '&Update Invoice Data';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.UpdateInvoiceData;
                end;
            }
        }
    }

    var
        cuRemarks: Codeunit Remarks;
        cuStudentsRegistration: Codeunit "Students Registration";
        l_rCommentLine: Record "Comment Line";
        text001: Label 'Section 1';
        text002: Label 'Section 2';
        text003: Label 'E-mail Subject';
        text004: Label 'E-mail Body';
        Type: Option Irs,Email;
        FileMgt: Codeunit "File Management";
}

#pragma implicitwith restore

