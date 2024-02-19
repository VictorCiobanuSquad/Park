#pragma implicitwith disable
page 31009765 "Service ET"
{
    // //IT001 - ET: 2016.09.19 - Foi eliminado o campo Use Student Unit Price
    // //Caso o Aluno tenha um preço diferente basta preencher o novo preço na atribuição dos serviços

    Caption = 'Services Card';
    PageType = Card;
    SourceTable = "Services ET";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
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
                field("IRS Declaration Code"; Rec."IRS Declaration Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IRS Declaration Description"; Rec."IRS Declaration Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Multiple invoices per month"; Rec."Multiple invoices per month")
                {
                    ApplicationArea = Basic, Suite;
                }
                group("Associated with the subject")
                {

                    Caption = 'Associated with the subject';
                    field("Subject Code"; Rec."Subject Code")
                    {
                    }
                }
                group("Invoicing in")
                {
                    Caption = 'Invoicing in';
                    group(Control1000000000)
                    {
                        ShowCaption = false;
                        field(January; Rec.January)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(February; Rec.February)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(March; Rec.March)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(April; Rec.April)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(May; Rec.May)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(June; Rec.June)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    group(Control1000000001)
                    {
                        ShowCaption = false;
                        field(July; Rec.July)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(August; Rec.August)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(Setember; Rec.Setember)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(October; Rec.October)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(November; Rec.November)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                        field(Dezember; Rec.December)
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price Purchase"; Rec."Unit Price Purchase")
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
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Disc. Group"; Rec."Service Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Services")
            {
                Caption = '&Services';
                Image = ServiceLines;
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    Visible = false;
                    action("L&edger Entries")
                    {
                        Caption = 'L&edger Entries';
                        Image = LedgerEntries;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("&Reservation Entries")
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = CONST(Reservation),
                                      "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.", "Variant Code", "Location Code", "Reservation Status");
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                    }
                    action("&Value Entries")
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Service),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(31009765),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Line &Discounts")
                {
                    Caption = 'Line &Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts ET";
                    RunPageLink = Type = CONST(Service),
                                  Code = FIELD("No.");
                    RunPageView = SORTING(Type, Code);
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Multiple invoices per month" := false;
    end;
}

#pragma implicitwith restore

