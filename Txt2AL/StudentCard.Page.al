#pragma implicitwith disable
page 31009750 "Student Card"
{
    // // Botoes - Student estao sobrepostos
    // // Botao - Aluno2 está configurado para History->Student Entry->Student Card.
    // //PT - tem o campo vClassAndNo
    // //PT - o campo Nota de creditro pendente registo para portugal é invisivel
    // 
    // IT001 - Específicos CPA - MF - 2016-03-22
    //       - Adicionados novos campos:
    //         - Desistência
    //         - Observações
    //       - Adicionada Informação Ano/Turma e Idade
    // 
    // IT002 - Adicionado novo botão:
    //         - "Registo Biográfico 1º CEB (v2018)"
    // 
    // SQUAD003 - JTP - 2020.11.26
    //   Moved Field "NISS" from Tabe Others to General
    //   New Field
    //     Health User No.

    Caption = 'Student Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Students;

    layout
    {
        area(content)
        {
            group(Student)
            {
                Caption = 'Student';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Name 2"; Rec."Last Name 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Estado da Matricula"; Rec."Estado da Matricula")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                    ShowCaption = false;
                }
                field("FORMAT(""Periodicidade Pagamento"") + ' Anos'"; Format(Rec."Periodicidade Pagamento") + ' Anos')
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    TableRelation = Integer;
                }
                field(vClassAndNo; vClassAndNo)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    Style = AttentionAccent;
                    StyleExpr = TRUE;
                    TableRelation = Integer;
                }
            }
            group(General)
            {
                Caption = 'General';
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
                field(Province; Rec.Province)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Province Description"; Rec."Province Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pediatricians Name"; Rec."Pediatricians Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NISS; Rec.NISS)
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Identification)
                {
                    Caption = 'Identification';
                    field("Doc. Type Id"; Rec."Doc. Type Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Doc. Number Id"; Rec."Doc. Number Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("BI Type"; Rec."BI Type")
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
                    field("Date of Issuance"; Rec."Date of Issuance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("VAT Registration No."; Rec."VAT Registration No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parish/Council/District Birth"; Rec."Parish/Council/District Birth")
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
            }
            part(SubFormUsersFamily; "Users Family / Students")
            {
                Caption = 'Associados';
                SubPageLink = "Student Code No." = FIELD("No.");
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
                }
                field("Student Remaining Amount"; Rec."Student Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(vOpenCreditMemos; vOpenCreditMemos)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Credit Memos not registered';
                    Editable = false;
                    Visible = false;
                }
                field("Use Student Disc. Group"; Rec."Use Student Disc. Group")
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
            }
            group(Others)
            {
                Caption = 'Others';
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Internet; Rec.Internet)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student/Worker"; Rec."Student/Worker")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Father Deceased/Unknown"; Rec."Father Deceased/Unknown")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Deceased Mother/Unknown"; Rec."Deceased Mother/Unknown")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NCGA; Rec.NCGA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Recipient of the SASE"; Rec."Recipient of the SASE")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(eIniciativasASE; Rec.eIniciativasASE)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Family Allowance Echelon"; Rec."Family Allowance Echelon")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Brother Number"; Rec."Brother Number")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Number of Brothers';
                }
                field("Brother Hierarchy"; Rec."Brother Hierarchy")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Special Needs"; Rec."Special Needs")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Special Needs Descripton"; Rec."Special Needs Descripton")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ACI; Rec.ACI)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code Academic Training"; Rec."Code Academic Training")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Academic Training"; Rec."Academic Training")
                {
                    ApplicationArea = Basic, Suite;
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
                field("Contract ME"; Rec."Contract ME")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Capitation; Rec.Capitation)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Plans Order 50"; Rec."Plans Order 50")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SubAbsence; "Absences Counter")
            {
                Caption = 'Faltas';
                SubPageLink = "Student/Teacher Code No." = FIELD("No."),
                              "Student/Teacher" = FILTER(Student);
                SubPageView = SORTING("Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.")
                              ORDER(Ascending)
                              WHERE("Student/Teacher" = FILTER(Student));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Aluno)
            {
                Caption = '&Student';
                Visible = AlunoVisible;
                action("S&tudent Registration")
                {
                    Caption = 'S&tudent Registration';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        l_Registration: Record Registration;
                        fRegistrationArchive: Page "Registration Archive";
                    begin
                        Rec.RegisterStudent(1);
                    end;
                }
                action("&Preparation Year/Renewal Registration")
                {
                    Caption = '&Preparation Year/Renewal Registration';
                    Image = UpdateDescription;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.RegisterStudent(2);
                    end;
                }
                action("&Assessments")
                {
                    Caption = '&Assessments';
                    Image = Evaluate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        fStudentClassification: Page "Student Classification";
                    begin
                        rSchoolYear.Reset;
                        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                        if rSchoolYear.FindFirst then;
                        fStudentClassification.GetInfo(rSchoolYear."School Year", Rec."No.");
                        fStudentClassification.RunModal;
                    end;
                }
                separator(Action1110088)
                {
                }
                action("School &Entry")
                {
                    Caption = 'School &Entry';
                    Image = PeriodEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Registration Class Entry";
                    RunPageLink = "Student Code No." = FIELD("No.");
                    RunPageView = SORTING("Entry No.")
                                  ORDER(Descending);
                }
                action("School &Transfers")
                {
                    Caption = 'School &Transfers';
                    Image = TransferOrder;
                    Promoted = true;
                    RunObject = Page "Students Transfers School";
                    RunPageLink = "Student Code" = FIELD("No.");
                    Visible = false;
                }
                separator(Action1110094)
                {
                }
                action("&Dimensions")
                {
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(31009750),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("&Services")
                {
                    Caption = '&Services';
                    Image = ServiceTasks;
                    RunObject = Page "Grouped Information";
                    RunPageLink = "Student Code No." = FIELD("No.");
                }
                action("&Bank Accounts")
                {
                    Caption = '&Bank Accounts';
                    Image = BankAccount;

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
                separator(Action1110117)
                {
                }
                action("&Health and Safety Students")
                {
                    Caption = '&Health and Safety Students';
                    Image = SocialSecurityTax;
                    RunObject = Page "Health & Safety Students";
                    RunPageLink = "Student Code" = FIELD("No.");
                }
            }
        }
        area(reporting)
        {
            group("Biographic &Records")
            {
                Caption = 'Biographic &Records';
                action("Biographic Records &Primary")
                {
                    Caption = 'Biographic Records &Primary';
                    Image = Post;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rTemplates: Record Templates;
                        fTemplates: Page Templates;
                    begin
                        VarSchoolYear := GetRegistrationsYears;
                        Clear(fTemplates);
                        if VarSchoolYear = '' then
                            exit;
                        rTemplates.Reset;
                        rTemplates.SetRange(Type, rTemplates.Type::"Biographic Record Primary");
                        fTemplates.SetTableView(rTemplates);
                        fTemplates.SetFormStudents(Rec."No."
                                                  , VarSchoolYear
                                                  , ''
                                                  , ''
                                                  , ''
                                                  , false
                                                  , ''
                                                  , ''
                                                  , rTemplates.Type::"Biographic Record Primary"
                                                  , ''
                                                  , ''
                                                  , true);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
                action("Biographic Records &Lower Secondary")
                {
                    Caption = 'Biographic Records &Lower Secondary';
                    Image = Post;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rTemplates: Record Templates;
                        fTemplates: Page Templates;
                    begin
                        VarSchoolYear := GetRegistrationsYears;
                        Clear(fTemplates);
                        if VarSchoolYear = '' then
                            exit;
                        rTemplates.Reset;
                        rTemplates.SetRange(Type, rTemplates.Type::"Biographic Record Lower Secondary");
                        fTemplates.SetTableView(rTemplates);
                        fTemplates.SetFormStudents(Rec."No."
                                                  , VarSchoolYear
                                                  , ''
                                                  , ''
                                                  , ''
                                                  , false
                                                  , ''
                                                  , ''
                                                  , rTemplates.Type::"Biographic Record Lower Secondary"
                                                  , ''
                                                  , ''
                                                  , true);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
                action("Biographic Records &Upper Secondary")
                {
                    Caption = 'Biographic Records &Upper Secondary';
                    Image = Post;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rTemplates: Record Templates;
                        fTemplates: Page Templates;
                    begin
                        VarSchoolYear := GetRegistrationsYears;
                        Clear(fTemplates);
                        if VarSchoolYear = '' then
                            exit;
                        rTemplates.Reset;
                        rTemplates.SetRange(Type, rTemplates.Type::"Biographic Record Upper Secondary");
                        fTemplates.SetTableView(rTemplates);
                        fTemplates.SetFormStudents(Rec."No."
                                                  , VarSchoolYear
                                                  , ''
                                                  , ''
                                                  , ''
                                                  , false
                                                  , ''
                                                  , ''
                                                  , rTemplates.Type::"Biographic Record Upper Secondary"
                                                  , ''
                                                  , ''
                                                  , true);
                        fTemplates.LookupMode(true);
                        fTemplates.RunModal;
                    end;
                }
            }
        }
        area(processing)
        {
            group("Funções")
            {
                Caption = 'Funções';
                action("Irmãos")
                {
                    Caption = 'Irmãos';
                    Image = ChangeCustomer;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        Clear(repIrmaos);

                        recSchoolYear.Reset;
                        recSchoolYear.SetRange(Status, recSchoolYear.Status::Active);
                        if recSchoolYear.Find('-') then;

                        recStudents.Reset;
                        recStudents.SetRange("No.", Rec."No.");
                        if recStudents.Find('-') then begin
                            repIrmaos.RecebeDados(recSchoolYear."School Year");
                            repIrmaos.SetTableView(recStudents);
                        end;

                        repIrmaos.UseRequestPage := true;
                        repIrmaos.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("No.");
        SetSubformFilter;

        Rec.CalcFields(Class, "Class No.");
        rClass.Reset;
        rClass.SetRange(rClass.Class, Rec.Class);
        rClass.SetRange(rClass."School Year", cStudentsRegistration.GetShoolYearActive);
        if rClass.FindFirst then
            vClassAndNo := rClass."Schooling Year" + ' - ' + rClass."Class Letter"
        else
            vClassAndNo := ''
    end;

    trigger OnInit()
    begin
        butPhotoVisible := true;
        Aluno2Visible := true;
        AlunoVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if AlunoVisible then
            Aluno2Visible := false;

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        vOpenCreditMemos := Rec.GetOpenCreditNotes;

        Rec.SetRange("School Year", cStudentsRegistration.GetShoolYearActive);
    end;

    var
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
        recStudentsPrint: Record Students;
        rSchoolYear: Record "School Year";
        rAbsence: Record Absence;
        rStruEduCountry: Record "Structure Education Country";
        rtemplates: Record Templates;
        rRegistrationClassEntry: Record "Registration Class Entry";
        rClass: Record Class;
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";
        gSchoolYear: Code[9];
        VarSchoolYear: Code[20];
        varSchoolingYear: Code[20];
        Text003: Label 'This option for this schooling year is not valid, please choose another.';
        varClass: Code[20];
        Attachment: Record "Attached Documents";
        Text004: Label 'Successfully imported.';
        Text005: Label 'Import Files';
        vClassAndNo: Text[30];
        Text006: Label 'No.';
        vOpenCreditMemos: Boolean;
        repIrmaos: Report "Students brothers";
        recStudents: Record Students;
        recSchoolYear: Record "School Year";
        [InDataSet]
        AlunoVisible: Boolean;
        [InDataSet]
        Aluno2Visible: Boolean;
        [InDataSet]
        butPhotoVisible: Boolean;
        Text19027266: Label 'Débitos Directos';
        fTemplates: Page Templates;
        FileMgt: Codeunit "File Management";
        Link: Text;

    //[Scope('OnPrem')]
    procedure NotEditable()
    begin
        CurrPage.Editable(false);
        AlunoVisible := false;
        butPhotoVisible := false;
        Aluno2Visible := true;
    end;

    //[Scope('OnPrem')]
    procedure SetSubformFilter()
    var
        rUsersFamilyStudents: Record "Users Family / Students";
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;

        rAbsence.Reset;
        if gSchoolYear = '' then
            rAbsence.SetRange("School Year", rSchoolYear."School Year")
        else
            rAbsence.SetRange("School Year", gSchoolYear);

        rAbsence.SetRange("Student/Teacher Code No.", Rec."No.");
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
        if rAbsence.FindSet then begin
            CurrPage.SubAbsence.PAGE.SetTableView(rAbsence);
            CurrPage.SubAbsence.PAGE.FormUpdate;
        end;

        rUsersFamilyStudents.Reset;
        if gSchoolYear = '' then
            rUsersFamilyStudents.SetRange("School Year", rSchoolYear."School Year")
        else
            rUsersFamilyStudents.SetRange("School Year", gSchoolYear);
        rUsersFamilyStudents.SetRange("Student Code No.", Rec."No.");
        if rUsersFamilyStudents.FindSet then;

        SetSchoolYear(rSchoolYear."School Year"); //APD NEW

        CurrPage.SubFormUsersFamily.PAGE.SetTableView(rUsersFamilyStudents);

        CurrPage.SubFormUsersFamily.PAGE.FormUpdate;

        CurrPage.SubFormUsersFamily.PAGE.GetStudentCode(Rec."No.");
    end;

    //[Scope('OnPrem')]
    procedure SetSchoolYear(pSchoolYear: Code[9])
    begin
        gSchoolYear := pSchoolYear;
    end;

    //[Scope('OnPrem')]
    procedure GetRegistrationsYears() SchoolYear: Code[20]
    var
        l_rRegistration: Record Registration;
        rSchoolYearTemp: Record "School Year" temporary;
    begin
        rSchoolYearTemp.Reset;
        rSchoolYearTemp.DeleteAll;
        l_rRegistration.Reset;
        l_rRegistration.SetRange("Student Code No.", Rec."No.");
        if varSchoolingYear <> '' then
            l_rRegistration.SetRange("Schooling Year", varSchoolingYear);
        if l_rRegistration.FindSet then begin
            repeat
                if rSchoolYear.Get(l_rRegistration."School Year") then
                    if not rSchoolYearTemp.Get(rSchoolYear."School Year") then begin
                        rSchoolYearTemp.Init;
                        rSchoolYearTemp.TransferFields(rSchoolYear);
                        rSchoolYearTemp.Insert;
                    end;
            until l_rRegistration.Next = 0;
        end;

        if PAGE.RunModal(0, rSchoolYearTemp) = ACTION::LookupOK then
            exit(rSchoolYearTemp."School Year");
    end;

    //[Scope('OnPrem')]
    procedure GetSchoolingYears()
    begin
        rRegistrationClassEntry.Reset;
        rRegistrationClassEntry.SetRange("Student Code No.", Rec."No.");
        if PAGE.RunModal(PAGE::"Students Entry", rRegistrationClassEntry) = ACTION::LookupOK then begin
            varSchoolingYear := rRegistrationClassEntry."Schooling Year";
            VarSchoolYear := rRegistrationClassEntry."School Year";
            varClass := rRegistrationClassEntry.Class;
        end;
    end;
}

#pragma implicitwith restore

