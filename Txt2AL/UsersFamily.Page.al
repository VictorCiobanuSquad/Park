#pragma implicitwith disable
page 31009755 "Users Family"
{
    Caption = 'Users Family Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Users Family";

    layout
    {
        area(content)
        {
            group("Users Family")
            {
                Caption = 'Users Family';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Salutation Code"; Rec."Salutation Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Salutation Code';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Name 2"; Rec."Last Name 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(General)
            {
                Caption = 'General';
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Code/City';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parish/Council/District Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(District; Rec.District)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Occupation Code"; Rec."Occupation Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employment Situation Code"; Rec."Employment Situation Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employment Situation"; Rec."Employment Situation")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Academic Training Code"; Rec."Academic Training Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Academic Training"; Rec."Academic Training")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Language spoken to children"; Rec."Language spoken to children")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Identification)
                {
                    Caption = 'Identification';
                    field("Marital Status"; Rec."Marital Status")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Doc. Type Id"; Rec."Doc. Type Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Doc. Number Id"; Rec."Doc. Number Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Archive of Identification"; Rec."Archive of Identification")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date Validity"; Rec."Date Validity")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date Issuance"; Rec."Date Issuance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("VAT Registration No."; Rec."VAT Registration No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(NISS; Rec.NISS)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Local Birth Place"; Rec."Local Birth Place")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Naturalness Code"; Rec."Naturalness Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Naturalness; Rec.Naturalness)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nationality Code"; Rec."Nationality Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Children; "Child List")
            {
                Caption = 'Children';
                Editable = false;
                Enabled = false;
                SubPageLink = "No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = URL;
                }
                field("E-mail2"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field(Work; Rec.Work)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Work Company"; Rec."Work Company")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No. 2"; Rec."Phone No. 2")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Users Family")
            {
                Caption = '&Users Family';
                action("&Bank Account")
                {
                    Caption = '&Bank Account';
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rCustomerBankAccount: Record "Customer Bank Account";
                    begin
                        if Rec."Customer No." <> '' then begin
                            rCustomerBankAccount.Reset;
                            rCustomerBankAccount.SetRange("Customer No.", Rec."Customer No.");
                            PAGE.RunModal(PAGE::"Customer Bank Account List", rCustomerBankAccount);
                        end;
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(31009753),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }

    var
        Text004: Label 'Successfully imported.';
        Text005: Label 'Import Files';
        Attachment: Record "Attached Documents";
        FileMgt: Codeunit "File Management";
        Link: Text;
}

#pragma implicitwith restore

