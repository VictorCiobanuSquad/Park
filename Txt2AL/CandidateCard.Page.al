#pragma implicitwith disable
page 31009808 "Candidate Card"
{
    Caption = 'Candidate Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Candidate;

    layout
    {
        area(content)
        {
            group(Candidate)
            {
                Caption = 'Candidate';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = NameEditable;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Short NameEditable";
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "E-mailEditable";
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(General)
            {
                Caption = 'General';
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AddressEditable;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Address 2Editable";
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Code/City';
                    Editable = "Post CodeEditable";
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = LocationEditable;
                }
                field("Parish/Council/District Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ParishCouncilDistrictCodeEdita;
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
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Phone No.Editable";
                    Importance = Promoted;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Mobile PhoneEditable";
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Responsibility CenterEditable";
                }
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SexEditable;
                }
                field("Doc. Type Id"; Rec."Doc. Type Id")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Doc. Type IdEditable";
                }
                field("Doc. Number Id"; Rec."Doc. Number Id")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Doc. Number IdEditable";
                    Importance = Promoted;
                }
                field("Archive of Identification"; Rec."Archive of Identification")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ArchiveofIdentificationEditabl;
                }
                field("Date Validity"; Rec."Date Validity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Date ValidityEditable";
                }
                field("Date Issuance"; Rec."Date Issuance")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Date IssuanceEditable";
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Birth DateEditable";
                }
                field("Naturalness Code"; Rec."Naturalness Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Naturalness CodeEditable";
                }
                field(Naturalness; Rec.Naturalness)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nationality Code"; Rec."Nationality Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Nationality CodeEditable";
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Ffamily; "Users Family/Candidate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Associados';
                Editable = FfamilyEditable;
                SubPageLink = "Candidate Code No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Payment Method CodeEditable";
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Payment Terms CodeEditable";
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Customer Disc. GroupEditable";
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Allow Line Disc.Editable";
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Customer Posting GroupEditable";
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = GenBusPostingGroupEditable;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "VAT Bus. Posting GroupEditable";
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ComputerEditable;
                }
                field(Internet; Rec.Internet)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = InternetEditable;
                }
                field("Student/Worker"; Rec."Student/Worker")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Student/WorkerEditable";
                }
                field("Father Deceased/Unknown"; Rec."Father Deceased/Unknown")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = FatherDeceasedUnknownEditable;
                }
                field("Deceased Mother/Unknown"; Rec."Deceased Mother/Unknown")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = DeceasedMotherUnknownEditable;
                }
                field(NISS; Rec.NISS)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = NISSEditable;
                }
                field(NCGA; Rec.NCGA)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = NCGAEditable;
                }
                field("Recipient of the SASE"; Rec."Recipient of the SASE")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Recipient of the SASEEditable";
                    OptionCaption = 'No benefits, Category A, Category B, Category C';
                }
                field("Special Needs"; Rec."Special Needs")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Special NeedsEditable";
                }
                field("Special Needs Descripton"; Rec."Special Needs Descripton")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SpecialNeedsDescriptonEditable;
                }
                field("Academic Training Code"; Rec."Academic Training Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Academic Training CodeEditable";
                }
                field("Academic Training"; Rec."Academic Training")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Occupation Code"; Rec."Occupation Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Occupation CodeEditable";
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employment Situation Code"; Rec."Employment Situation Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = EmploymentSituationCodeEditabl;
                }
                field("Employment Situation"; Rec."Employment Situation")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(CandidateEntry; "Candidate Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Candidaturas';
                Editable = CandidateEntryEditable;
                SubPageLink = "Candidate No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Aluno)
            {
                Caption = '&Candidate';
                Image = User;
                separator(Action1110088)
                {
                }
                action("&Create Test")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Create Test';
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Rec."Student No." = '' then
                            CurrPage.CandidateEntry.PAGE.FormCreateTest
                        else
                            Error(Text003);
                    end;
                }
                action("&Open Test")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Open Test';
                    Image = OpenJournal;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.CandidateEntry.PAGE.FormOpenTest;
                    end;
                }
                separator(Action1102065002)
                {
                }
                action("&Post Placement Reservation")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Post Placement Reservation';
                    Image = NewInvoice;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        l_InvoiceNo: Code[20];
                        l_rSalesHeader: Record "Sales Header";
                    begin
                        l_InvoiceNo := Rec.InvoicingServices;
                        if l_rSalesHeader.Get(l_rSalesHeader."Document Type"::Invoice, l_InvoiceNo) then
                            PAGE.Run(PAGE::"Sales Invoice", l_rSalesHeader);
                    end;
                }
                separator(Action1102065007)
                {
                }
                action("Pre-registration Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pre-registration Report';
                    Image = ExternalDocument;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rTemplates: Record Templates;
                        fTemplates: Page Templates;
                    begin
                        Clear(fTemplates);
                        rTemplates.Reset;
                        rTemplates.SetRange(Type, rTemplates.Type::"Pre-registration");
                        fTemplates.SetTableView(rTemplates);
                        fTemplates.SetFormCandidates(Rec);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Picture);
        feditable;
    end;

    trigger OnInit()
    begin
        CandidateEntryEditable := true;
        FfamilyEditable := true;
        LocationEditable := true;
        EmploymentSituationCodeEditabl := true;
        "Occupation CodeEditable" := true;
        "Academic Training CodeEditable" := true;
        "Special NeedsEditable" := true;
        SpecialNeedsDescriptonEditable := true;
        "Recipient of the SASEEditable" := true;
        NISSEditable := true;
        NCGAEditable := true;
        DeceasedMotherUnknownEditable := true;
        FatherDeceasedUnknownEditable := true;
        "Student/WorkerEditable" := true;
        InternetEditable := true;
        ComputerEditable := true;
        "Payment Method CodeEditable" := true;
        "VAT Bus. Posting GroupEditable" := true;
        GenBusPostingGroupEditable := true;
        "Customer Posting GroupEditable" := true;
        "Allow Line Disc.Editable" := true;
        "Customer Disc. GroupEditable" := true;
        "Payment Terms CodeEditable" := true;
        "Nationality CodeEditable" := true;
        ParishCouncilDistrictCodeEdita := true;
        "Naturalness CodeEditable" := true;
        "Birth DateEditable" := true;
        SexEditable := true;
        "Date IssuanceEditable" := true;
        "Date ValidityEditable" := true;
        ArchiveofIdentificationEditabl := true;
        "Doc. Number IdEditable" := true;
        "Doc. Type IdEditable" := true;
        "Phone No.Editable" := true;
        "Responsibility CenterEditable" := true;
        "Mobile PhoneEditable" := true;
        "E-mailEditable" := true;
        "Short NameEditable" := true;
        "Post CodeEditable" := true;
        NameEditable := true;
        "Address 2Editable" := true;
        AddressEditable := true;
    end;

    var
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete this picture?';
        cUserEducation: Codeunit "User Education";
        Text003: Label 'You cannot create a test for a candidate which has been converted into a student.';
        Text004: Label 'Successfully imported.';
        Text005: Label 'Import Files';
        Attachment: Record "Attached Documents";
        [InDataSet]
        AddressEditable: Boolean;
        [InDataSet]
        "Address 2Editable": Boolean;
        [InDataSet]
        NameEditable: Boolean;
        [InDataSet]
        "Post CodeEditable": Boolean;
        [InDataSet]
        "Short NameEditable": Boolean;
        [InDataSet]
        "E-mailEditable": Boolean;
        [InDataSet]
        "Mobile PhoneEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        "Phone No.Editable": Boolean;
        [InDataSet]
        "Doc. Type IdEditable": Boolean;
        [InDataSet]
        "Doc. Number IdEditable": Boolean;
        [InDataSet]
        ArchiveofIdentificationEditabl: Boolean;
        [InDataSet]
        "Date ValidityEditable": Boolean;
        [InDataSet]
        "Date IssuanceEditable": Boolean;
        [InDataSet]
        SexEditable: Boolean;
        [InDataSet]
        "Birth DateEditable": Boolean;
        [InDataSet]
        "Naturalness CodeEditable": Boolean;
        [InDataSet]
        ParishCouncilDistrictCodeEdita: Boolean;
        [InDataSet]
        "Nationality CodeEditable": Boolean;
        [InDataSet]
        "Payment Terms CodeEditable": Boolean;
        [InDataSet]
        "Customer Disc. GroupEditable": Boolean;
        [InDataSet]
        "Allow Line Disc.Editable": Boolean;
        [InDataSet]
        "Customer Posting GroupEditable": Boolean;
        [InDataSet]
        GenBusPostingGroupEditable: Boolean;
        [InDataSet]
        "VAT Bus. Posting GroupEditable": Boolean;
        [InDataSet]
        "Payment Method CodeEditable": Boolean;
        [InDataSet]
        ComputerEditable: Boolean;
        [InDataSet]
        InternetEditable: Boolean;
        [InDataSet]
        "Student/WorkerEditable": Boolean;
        [InDataSet]
        FatherDeceasedUnknownEditable: Boolean;
        [InDataSet]
        DeceasedMotherUnknownEditable: Boolean;
        [InDataSet]
        NCGAEditable: Boolean;
        [InDataSet]
        NISSEditable: Boolean;
        [InDataSet]
        "Recipient of the SASEEditable": Boolean;
        [InDataSet]
        SpecialNeedsDescriptonEditable: Boolean;
        [InDataSet]
        "Special NeedsEditable": Boolean;
        [InDataSet]
        "Academic Training CodeEditable": Boolean;
        [InDataSet]
        "Occupation CodeEditable": Boolean;
        [InDataSet]
        EmploymentSituationCodeEditabl: Boolean;
        [InDataSet]
        LocationEditable: Boolean;
        [InDataSet]
        FfamilyEditable: Boolean;
        [InDataSet]
        CandidateEntryEditable: Boolean;
        FileMgt: Codeunit "File Management";

    //[Scope('OnPrem')]
    procedure feditable()
    begin
        /*
      IF "Student No."  <> ''  THEN BEGIN
         CurrForm.Address.EDITABLE(FALSE);
         CurrForm."Address 2".EDITABLE(FALSE);
         CurrForm.Name.EDITABLE(FALSE);
         CurrForm."Last Name".EDITABLE(FALSE);
         CurrForm."Post Code".EDITABLE(FALSE);
         CurrForm."Last Name 2".EDITABLE(FALSE);
         CurrForm."Short Name".EDITABLE(FALSE);
         CurrForm."E-mail".EDITABLE(FALSE);
         CurrForm."Mobile Phone".EDITABLE(FALSE);
         CurrForm."Responsibility Center".EDITABLE(FALSE);
         CurrForm."Phone No.".EDITABLE(FALSE);
         CurrForm."Doc. Type Id".EDITABLE(FALSE);
         CurrForm."Doc. Number Id".EDITABLE(FALSE);
         CurrForm."Archive of Identification".EDITABLE(FALSE);
         CurrForm."Date Validity".EDITABLE(FALSE);
         CurrForm."Date Issuance".EDITABLE(FALSE);
         CurrForm.Sex.EDITABLE(FALSE);
         CurrForm."Birth Date".EDITABLE(FALSE);
         CurrForm."Naturalness Code".EDITABLE(FALSE);
         CurrForm."Parish/Council/District Code".EDITABLE(FALSE);
         CurrForm."Nationality Code".EDITABLE(FALSE);
         CurrForm."Payment Terms Code".EDITABLE(FALSE);
         CurrForm."Customer Disc. Group".EDITABLE(FALSE);
         CurrForm."Allow Line Disc.".EDITABLE(FALSE);
         CurrForm."Customer Posting Group".EDITABLE(FALSE);
         CurrForm."Gen. Bus. Posting Group".EDITABLE(FALSE);
         CurrForm."VAT Bus. Posting Group".EDITABLE(FALSE);
         CurrForm."Payment Method Code".EDITABLE(FALSE);
         CurrForm.Computer.EDITABLE(FALSE);
         CurrForm.Internet.EDITABLE(FALSE);
         CurrForm."Student/Worker".EDITABLE(FALSE);
         CurrForm."Father Deceased/Unknown".EDITABLE(FALSE);
         CurrForm."Deceased Mother/Unknown".EDITABLE(FALSE);
         CurrForm.NCGA.EDITABLE(FALSE);
         CurrForm.NISS.EDITABLE(FALSE);
         CurrForm."Recipient of the SASE".EDITABLE(FALSE);
         CurrForm."Special Needs Descripton".EDITABLE(FALSE);
         CurrForm."Special Needs".EDITABLE(FALSE);
         CurrForm."Academic Training Code".EDITABLE(FALSE);
         CurrForm."Occupation Code".EDITABLE(FALSE);
         CurrForm."Employment Situation Code".EDITABLE(FALSE);
         CurrForm.Location.EDITABLE(FALSE);
      // SubForm
         CurrForm.Ffamily.EDITABLE(FALSE);
         CurrForm.CandidateEntry.EDITABLE(FALSE);
      // SubFrom
        */
        //END ELSE BEGIN
        AddressEditable := true;
        "Address 2Editable" := true;
        NameEditable := true;
        "Post CodeEditable" := true;
        "Short NameEditable" := true;
        "E-mailEditable" := true;
        "Mobile PhoneEditable" := true;
        "Responsibility CenterEditable" := true;
        "Phone No.Editable" := true;
        "Doc. Type IdEditable" := true;
        "Doc. Number IdEditable" := true;
        ArchiveofIdentificationEditabl := true;
        "Date ValidityEditable" := true;
        "Date IssuanceEditable" := true;
        SexEditable := true;
        "Birth DateEditable" := true;
        "Naturalness CodeEditable" := true;
        ParishCouncilDistrictCodeEdita := true;
        "Nationality CodeEditable" := true;
        "Payment Terms CodeEditable" := true;
        "Customer Disc. GroupEditable" := true;
        "Allow Line Disc.Editable" := true;
        "Customer Posting GroupEditable" := true;
        GenBusPostingGroupEditable := true;
        "VAT Bus. Posting GroupEditable" := true;
        "Payment Method CodeEditable" := true;
        ComputerEditable := true;
        InternetEditable := true;
        "Student/WorkerEditable" := true;
        FatherDeceasedUnknownEditable := true;
        DeceasedMotherUnknownEditable := true;
        NCGAEditable := true;
        NISSEditable := true;
        "Recipient of the SASEEditable" := true;
        SpecialNeedsDescriptonEditable := true;
        "Special NeedsEditable" := true;
        "Academic Training CodeEditable" := true;
        "Occupation CodeEditable" := true;
        EmploymentSituationCodeEditabl := true;
        LocationEditable := true;
        // SubForm
        FfamilyEditable := true;
        CandidateEntryEditable := true;
        // SubFrom

        //END;

    end;
}

#pragma implicitwith restore

