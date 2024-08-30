table 31009750 Students
{
    // //IT - Parque 2016.12.27 - pediram para tirar a validação do NIF
    // //IT001 - Parque - Portal Fardas - 2017.06.05 - campo picture compress = no
    // IT002 - Parque - Portal Fardas - 2017.09.28
    //       - Novo campo "Nº Cliente Fardas"
    // 
    // IT003 - Parque - Idiomas - 2017.10.10
    //       - Novo campo: "Language Code": 50017
    //       - Alteração trigger OnInsert: Preenchimento "Language Code"
    // 
    // IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
    // 
    // IT005 - Park - 2019.11.05 - Validate do campo por causa da importação dos alunos do iSAMS
    //                           - novo campo SchoolID iSAMS

    Caption = 'Students';
    LookupPageID = "Students List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    rEduConfiguration.Get;
                    NoSeriesMgt.TestManual(rEduConfiguration."Student Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[128])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if Name <> '' then
                    ValidateName;

                UpdateFullName;

                UpdateProfile;
            end;
        }
        field(3; "Short Name"; Text[50])
        {
            Caption = 'Short Name';
        }
        field(4; Sex; Option)
        {
            Caption = 'Sex';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(5; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(6; "Nationality Code"; Code[10])
        {
            Caption = 'Citizenship Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(Nacionalidade));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::Nacionalidade, "Nationality Code") then
                    Nationality := rTableMSI.Description
                else
                    Nationality := '';
            end;
        }
        field(7; Nationality; Text[60])
        {
            Caption = 'Citizenship';
            Editable = false;
        }
        field(8; "Naturalness Code"; Code[10])
        {
            Caption = 'Nationality Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(Naturalidade));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::Naturalidade, "Naturalness Code") then
                    Naturalness := rTableMSI.Description
                else
                    Naturalness := '';
            end;
        }
        field(9; Naturalness; Text[60])
        {
            Caption = 'Nationality';
            Editable = false;
        }
        field(10; Town; Text[100])
        {
            Caption = 'Town';
            Description = 'MISI';
            Editable = false;
        }
        field(11; County; Text[100])
        {
            Caption = 'County';
            Description = 'MISI';
            Editable = false;
        }
        field(12; District; Text[100])
        {
            Caption = 'District';
            Description = 'MISI';
            Editable = false;
        }
        field(13; "Doc. Type Id"; Option)
        {
            Caption = 'Doc. Type ID';
            OptionCaption = ' ,Identification Card,Child Identification Card,Passport,Residence Permit,Other,Citizen Card';
            OptionMembers = " ","Identification Card","Child Identification Card",Passport,"Residence Permit",Other,"Citizen Card";
        }
        field(14; "Doc. Number Id"; Text[32])
        {
            Caption = 'Doc. Number ID';

            trigger OnValidate()
            begin
                if "Doc. Number Id" <> '' then begin
                    rStudents.Reset;
                    rStudents.SetRange("Doc. Type Id", "Doc. Type Id");
                    rStudents.SetFilter("No.", '<>%1', "No.");
                    if rStudents.Find('-') then begin
                        repeat
                            if rStudents."Doc. Number Id" = "Doc. Number Id" then
                                Message(Text0002, rStudents."No.");
                        until rStudents.Next = 0;
                    end;
                end;
            end;
        }
        field(15; "Archive of Identification"; Text[30])
        {
            Caption = 'Identification Archive';
        }
        field(16; "Date Validity"; Date)
        {
            Caption = 'Expiration date';
        }
        field(17; "Date of Issuance"; Date)
        {
            Caption = 'Date of Issue';
        }
        field(18; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(19; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(20; Prefix; Text[6])
        {
            Caption = 'Prefix';
        }
        field(21; "Mobile Phone"; Text[14])
        {
            Caption = 'Mobile Phone';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(22; "Mobile Prefix"; Text[9])
        {
            Caption = 'Mobile Prefix';
        }
        field(23; "E-mail"; Text[64])
        {
            Caption = 'E-mail';

            trigger OnValidate()
            begin
                if "E-mail" = '' then
                    if xRec."E-mail" <> '' then
                        exit;

                CheckValidEmailAddress("E-mail");
            end;
        }
        field(24; Address; Text[65])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(25; "Address 2"; Text[65])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(27; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                tempCounty: Code[20];
            begin
                if (County <> '') or (County = '') then
                    tempCounty := County;
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
                County := tempCounty;
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(Location, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                UpdateProfile;
            end;
        }
        field(28; Location; Text[30])
        {
            Caption = 'Location';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(Location, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                UpdateProfile;
            end;
        }
        field(29; NISS; Text[20])
        {
            Caption = 'SSN';
            Description = 'Numero de Identificaçao Segurança Social MISI';
        }
        field(30; NCGA; Text[11])
        {
            Caption = 'NCGA';
            Description = 'MISI';
        }
        field(31; "Student/Worker"; Boolean)
        {
            Caption = 'Student/Worker';
            Description = 'MISI';
        }
        field(32; "Recipient of the SASE"; Option)
        {
            Caption = 'Recipient of the SASE';
            Description = 'MISI';
            OptionCaption = 'No benefits,Category B,Category A';
            OptionMembers = "Não Beneficia","Escalão B","Escalão A";
        }
        field(33; "Special Needs"; Boolean)
        {
            Caption = 'Special Needs';
            Description = 'MISI';
        }
        field(34; "Special Needs Descripton"; Text[60])
        {
            Caption = 'Special Needs Descripton';
        }
        field(35; Computer; Boolean)
        {
            Caption = 'Computer';
            Description = 'MISI';
        }
        field(36; Internet; Boolean)
        {
            Caption = 'Internet';
            Description = 'MISI';
        }
        field(37; "Code Academic Training"; Code[10])
        {
            Caption = 'Code Academic Training';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER("Formação"));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::"Formação", "Code Academic Training") then
                    "Academic Training" := rTableMSI.Description
                else
                    "Academic Training" := '';
            end;
        }
        field(38; "Academic Training"; Text[60])
        {
            Caption = 'Academic Training';
            Editable = false;
        }
        field(39; "Occupation Code"; Code[4])
        {
            Caption = 'Occupation Code';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(CodProfissao));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::CodProfissao, "Occupation Code") then
                    Occupation := rTableMSI.Description
                else
                    Occupation := '';
            end;
        }
        field(40; Occupation; Text[160])
        {
            Caption = 'Occupation';
            Editable = false;
        }
        field(41; "Employment Situation Code"; Code[10])
        {
            Caption = 'Employment Situation Code';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(SituacaoEmp));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::SituacaoEmp, "Employment Situation Code") then
                    "Employment Situation" := rTableMSI.Description
                else
                    "Employment Situation" := '';
            end;
        }
        field(42; "Employment Situation"; Text[60])
        {
            Caption = 'Employment Situation';
            Editable = false;
        }
        field(43; "Father Deceased/Unknown"; Boolean)
        {
            Caption = 'Deceased Father/Unknown';
        }
        field(44; "Deceased Mother/Unknown"; Boolean)
        {
            Caption = 'Mother Deceased/Unknown';
        }
        field(45; Picture; BLOB)
        {
            Caption = 'Picture';
            Compressed = false;
        }
        field(46; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(47; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                rRegistration: Record Registration;
                Text0001: Label 'To change the Responsibility center first delete the registration for the active year.';
            begin

                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));

                rSchoolYear.Reset;
                rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                if rSchoolYear.Find('-') then;



                rRegistration.Reset;
                rRegistration.SetRange("Student Code No.", "No.");
                rRegistration.SetRange("School Year", rSchoolYear."School Year");
                if rRegistration.Find('-') then
                    Error(Text0001);
            end;
        }
        field(48; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                rCustomer: Record Customer;
            begin
                //IT 2015.12.21 - para apagar a ligação do cliente ao aluno, quando apaga o nº de cliente na ficha do aluno
                if "Customer No." = '' then
                    if rCustomer.Get(xRec."Customer No.") then begin
                        rCustomer."Student No." := '';
                        rCustomer.Modify;
                    end;
            end;
        }
        field(49; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method" WHERE("Payment Edu" = FILTER(true));
        }
        field(50; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                //IT - Parque 2016.12.27 - pediram para tirar a validação do NIF

                //VATRegNoFormat.Test("VAT Registration No.","Country/Region Code", "No.", DATABASE::Students);
                //ValidateNIF;
            end;
        }
        field(51; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(52; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(53; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(54; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(55; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(56; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(57; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(58; "Parish/Council/District Code"; Code[10])
        {
            Caption = 'Parish/Council/District Code';
            Description = 'Morada - MISI';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Parish));

            trigger OnValidate()
            begin
                if rFregConDistCodes.Get(rFregConDistCodes.Type::Parish,
                                         rFregConDistCodes."Legal Code Type"::" ",
                                         "Parish/Council/District Code") then begin

                    Town := rFregConDistCodes.Town;
                    County := rFregConDistCodes.County;
                    District := rFregConDistCodes.District;
                end else begin
                    Town := '';
                    County := '';
                    District := '';
                end;
            end;
        }
        field(59; "Local Birth Place"; Text[40])
        {
            Caption = 'Birth Place';
            Description = 'ENES';
        }
        field(60; "Birth County"; Text[30])
        {
            Caption = 'Birth County';
            Description = 'ENES';
        }
        field(61; "Birth District"; Text[30])
        {
            Caption = 'Birth District';
            Description = 'ENES';
        }
        field(62; "Brother Number"; Integer)
        {
            BlankZero = true;
            Caption = 'Number Brothers';
        }
        field(63; "Brother Hierarchy"; Integer)
        {
            BlankZero = true;
            Caption = 'Brother Hierarchy';
        }
        field(64; "NEE legal Doc"; Code[20])
        {
            Caption = 'NEE legal Doc';
        }
        field(65; "NEE Type"; Text[30])
        {
            Caption = 'NEE Type';
        }
        field(66; "First Foreign Language"; Text[30])
        {
            Caption = 'First Foreign Language';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject));
        }
        field(67; "Second Foreign Language"; Text[30])
        {
            Caption = 'Second Foreign Language';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject));
        }
        field(68; Religion; Text[30])
        {
            Caption = 'Religion';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject));
        }
        field(69; "Stage Type"; Text[30])
        {
            Caption = 'Stage Type';
        }
        field(70; "PAAU Type"; Text[30])
        {
            Caption = 'PAAU Type';
        }
        field(71; "Study Hour"; Text[30])
        {
            Caption = 'Study Hour';
        }
        field(72; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(73; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(74; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Student),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(75; ACI; Option)
        {
            Caption = 'ACI';
            OptionCaption = ' ,Opinion of the EAP,The EAP report,Stretches: opinion / report PPP,Authorization curricular modifications,Other';
            OptionMembers = " ","Opinion of the EAP","The EAP report","Stretches: opinion / report PPP","Authorization curricular modifications",Other;

            trigger OnValidate()
            var
                l_HealthSafetyStudents: Record "Health & Safety Students";
            begin
                if ACI = ACI::" " then begin
                    l_HealthSafetyStudents.Reset;
                    l_HealthSafetyStudents.SetRange("Student Code", l_HealthSafetyStudents."Student Code");
                    l_HealthSafetyStudents.SetRange(Type, l_HealthSafetyStudents.Type::Han);
                    if not FindFirst then
                        Error(Text0011);
                end;
            end;
        }
        field(81; "Use Student Disc. Group"; Boolean)
        {
            Caption = 'Use Student Discount Group';
            Description = 'Por defeito usa os descontos da entidade pag. Se este campo estiver assinalado usa sempre os desc. do Aluno';
        }
        field(82; "Global Remaining Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("Customer No."),
                                                                         "PTSS Excluded from calculation" = CONST(false)));
            Caption = 'Global Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83; "Student Remaining Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("Customer No."),
                                                                         "PTSS Excluded from calculation" = CONST(false)));
            Caption = 'Student Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(85; Class; Code[20])
        {
            CalcFormula = Lookup(Registration.Class WHERE("School Year" = FIELD("School Year"),
                                                           "Student Code No." = FIELD("No.")));
            Caption = 'Class';
            FieldClass = FlowField;
            TableRelation = Class;
        }
        field(86; "Class No."; Integer)
        {
            CalcFormula = Lookup(Registration."Class No." WHERE("School Year" = FIELD("School Year"),
                                                                 Class = FIELD(Class),
                                                                 "Student Code No." = FIELD("No.")));
            Caption = 'Class No.';
            FieldClass = FlowField;
        }
        field(87; "School Year"; Code[9])
        {
            Caption = 'School Year';
            FieldClass = FlowFilter;
            TableRelation = "School Year"."School Year";
        }
        field(88; "Temp Class No."; Integer)
        {
            Caption = 'Temp. Class No.';
            Description = 'Usado só em tabelas temporárias par poder ordenar os alunos';
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(50000; IBAN; Text[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            begin
                CheckCustomerNIBAdmin;
                UpdateCustomer;
            end;
        }
        field(50001; NIB; Text[50])
        {
            Caption = 'NIB';

            trigger OnValidate()
            begin
                CheckCustomerNIBAdmin;

                if (StrLen(NIB) <> 21) and (NIB <> '') then
                    Message(Text50000);

                UpdateCustomer;
            end;
        }
        field(50002; "Referencia ADC"; Code[11])
        {

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(50003; "Débitos Directos"; Option)
        {
            OptionCaption = ' ,BPI,Caixa Agrícola,Deutsch,BCP,Totta';
            OptionMembers = " ",BPI,"Caixa Agrícola",Deutsch,BCP,Totta;

            trigger OnValidate()
            begin
                //JD MM

                rBankAccount.Reset;
                rBankAccount.SetRange("Débitos Directos", "Débitos Directos");
                if rBankAccount.Find('-') then begin
                    "ID CRED" := rBankAccount."ID CRED";
                    Modify;
                end;

                UpdateCustomer;
            end;
        }
        field(50004; "EAN Enviado"; Boolean)
        {

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(50005; "ID CRED"; Code[6])
        {

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(50006; "Periodicidade Pagamento"; Option)
        {
            Description = 'CSJB';
            OptionCaption = ' ,Mensal,Trimestral,Anual';
            OptionMembers = " ",Mensal,Trimestral,Anual;
        }
        field(50007; "Estado da Matricula"; Option)
        {
            CalcFormula = Lookup(Registration.Status WHERE("School Year" = FIELD("School Year"),
                                                            "Student Code No." = FIELD("No.")));
            Description = 'PArque';
            FieldClass = FlowField;
            OptionCaption = ' ,Subscribed,Transfer,Annulled';
            OptionMembers = " ",Subscribed,Transfer,Cancelled;
        }
        field(50008; "Login Site"; Text[15])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50009; "Password Site"; Text[15])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50010; "Emergência Nome 1"; Text[80])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50011; "Emergência Telefone 1"; Text[30])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50012; "Emergência Parentesco 1"; Text[25])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50013; "Emergência Nome 2"; Text[80])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50014; "Emergência Telefone 2"; Text[30])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50015; "Emergência Parentesco 2"; Text[25])
        {
            Description = 'Parque, interface site alunos';
        }
        field(50016; "Uniform Customer No."; Code[20])
        {
            Caption = 'Uniform Customer No.';
            Description = 'IT002-PortalFardas';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                rCustomer: Record Customer;
            begin
            end;
        }
        field(50017; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            Description = 'IT003';
            TableRelation = Language;

            trigger OnValidate()
            begin
                //IT003,sn
                Clear(rCustomer2);
                rCustomer2.SetRange("Student No.", "No.");
                if rCustomer2.FindFirst then begin
                    rCustomer2."Language Code" := "Language Code";
                    SalesSetup.Get;
                    if ("Language Code" = '') or ("Language Code" = Text50003) then begin
                        rCustomer2."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
                        rCustomer2."Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
                    end else begin
                        rCustomer2."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
                        rCustomer2."Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
                    end;
                    rCustomer2.Modify;
                end;
                //IT003,en
            end;
        }
        field(50018; "E-mail2"; Text[64])
        {
            Caption = 'E-mail';
            Description = 'IT004-envios por email';

            trigger OnValidate()
            begin
                //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email

                if "E-mail2" = '' then
                    if xRec."E-mail2" <> '' then
                        exit;

                CheckValidEmailAddress("E-mail2");
            end;
        }
        field(50020; "SchoolID iSAMS"; Text[30])
        {
            Caption = 'Nº Aluno iSAMS';
            Description = 'IT005';
        }

        field(50021; "JDE Payer No."; Code[20])
        {
            caption = 'Pagador JDE';
            FieldClass = FlowField;

            CalcFormula = Lookup(Customer."JDE Payer No." WHERE("No." = FIELD("Customer No.")
                                                           ));
        }

        field(50022; "JDE Pupil No."; Code[20])
        {
            caption = 'Aluno JDE';
            FieldClass = FlowField;

            CalcFormula = Lookup(Customer."JDE Pupil No." WHERE("No." = FIELD("Customer No.")
                                                           ));
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';

            trigger OnValidate()
            begin
                ValidateName;
                UpdateFullName;
            end;
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';

            trigger OnValidate()
            begin
                ValidateName;
                UpdateFullName;
            end;
        }
        field(73102; County1; Text[30])
        {
            Caption = 'County1';
        }
        field(73103; "User Name"; Text[30])
        {
            Caption = 'User Name';

            trigger OnValidate()
            var
                cValidateUserID: Codeunit "Validate User ID";
            begin
                cValidateUserID.ValidateUser("User Name");
            end;
        }
        field(73104; Password; Text[30])
        {
            Caption = 'Password';

            trigger OnValidate()
            begin
                if StrLen(Password) < 6 then
                    Error(Text73100);
            end;
        }
        field(73105; Language; Option)
        {
            Caption = 'Language';
            InitValue = Portuguese;
            OptionCaption = ' ,Castilian,English,Euskara,Galego,Deutsch,Français,Italian,Portuguese,Catalan';
            OptionMembers = " ",Castilian,English,Euskara,Galego,Deutsch,"Français",Italian,Portuguese,Catalan;
        }
        field(73106; "Use GIC"; Boolean)
        {
            Caption = 'Use GIC';
        }
        field(73107; "Use WEB"; Boolean)
        {
            Caption = 'Use WEB';
        }
        field(73108; Domain; Option)
        {
            Caption = 'Domain';
            OptionCaption = ' ,Domain 1,Domain 2,Domain 3,Domain 4,Domain 5';
            OptionMembers = " ","Domain 1","Domain 2","Domain 3","Domain 4","Domain 5";
        }
        field(73109; "User Group"; Code[20])
        {
            Caption = 'User Group';
            TableRelation = "User Group GIC".Code WHERE(Type = FILTER(Group));
        }
        field(73110; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(73111; "Pediatricians Name"; Text[80])
        {
            Caption = 'Legal Student No.';
            Description = 'Eduardo Neves [16.11.11] Alteração a partir do Nº Oficial de Aluno';
        }
        field(73112; "Full Name"; Text[191])
        {
            Caption = 'Full Name';
        }
        field(73113; "Pediatricians Phone Number"; Text[30])
        {
            Caption = 'Pediatra Telefone';
            Description = 'Eduardo Neves [16.11.11]';
        }
        field(73114; "Pediatricians Mobile Phone"; Text[30])
        {
            Caption = 'Pediatra Telemóvel';
            Description = 'Eduardo Neves [16.11.11] Por fazer sentido face às emergências médicas';
        }
        field(75000; "Contract ME"; Option)
        {
            Caption = 'EM Contract';
            Description = 'MISI';
            InitValue = "6";
            OptionCaption = 'Association,Sponsorship,Simple,Development,Cooperation,Not Covered,Program (DRELVT)';
            OptionMembers = "1","2","3","4","5","6","7";
        }
        field(75001; Capitation; Decimal)
        {
            Caption = 'Capitation';
            Description = 'MISI';
        }
        field(75002; "Plans Order 50"; Option)
        {
            Caption = 'Plans Order 50';
            Description = 'MISI';
            OptionCaption = 'There is no plan, Recovery Plan, Development Plan, Monitoring Plan';
            OptionMembers = "0","1","2","3";
        }
        field(75003; "Family Allowance Echelon"; Option)
        {
            Caption = 'Family Allowance Echelon';
            Description = 'MISI';
            OptionCaption = ' ,1,2,3,4,5,6';
            OptionMembers = "0","1","2","3","4","5","6";
        }
        field(75500; "BI Type"; Option)
        {
            Caption = 'ID Type';
            Description = 'ENES';
            OptionCaption = ' ,Civilian,Macau,Army,Navy,Air Force,Metropolitan Police,Republican Guard,Customs,Internal Number ';
            OptionMembers = " ","1","2","3","4","5","6","7","8","9";
        }
        field(75501; "Parish/Council/District Birth"; Code[10])
        {
            Caption = 'Parish/Council/District Birth';
            Description = 'ENES';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Parish));

            trigger OnValidate()
            begin
                if rFregConDistCodes.Get(rFregConDistCodes.Type::Parish,
                                         rFregConDistCodes."Legal Code Type"::" ",
                                         "Parish/Council/District Birth") then begin

                    "Local Birth Place" := rFregConDistCodes.Town;
                    "Birth County" := CopyStr("Parish/Council/District Birth", 3, 2);
                    "Birth District" := CopyStr("Parish/Council/District Birth", 1, 2);

                end else begin
                    "Local Birth Place" := '';
                end;
            end;
        }
        field(75503; eIniciativasASE; Option)
        {
            Caption = 'eIniciativasASE';
            Description = 'MISI';
            OptionCaption = 'No benefits,Category B,Category A,Category C';
            OptionMembers = "Não Beneficia","Escalão B","Escalão A","Escalão C";
        }
        field(75504; Province; Code[10])
        {
            Caption = 'Province';
            Description = 'VERI';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Province));

            trigger OnValidate()
            begin
                if rFregConDistCodes.Get(rFregConDistCodes.Type::Province,
                                         rFregConDistCodes."Legal Code Type"::" ",
                                         Province) then begin
                    "Province Description" := rFregConDistCodes.Town;
                end else begin
                    "Province Description" := '';
                end;
            end;
        }
        field(75505; "Province Description"; Text[30])
        {
            Caption = 'Province Description';
            Description = 'VERI';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Full Name")
        {
        }
        key(Key3; "Temp Class No.")
        {
        }
        key(Key4; "Birth Date")
        {
        }
        key(Key5; "Referencia ADC")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rRegistration: Record Registration;
        rRegistrationSubjectsServices: Record "Registration Subjects";
        rStudentServicePlan: Record "Student Service Plan";
        rRegistrationClass: Record "Registration Class";
    begin
        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", "No.");
        rRegistration.SetFilter(Status, '<>%1', 0);
        if rRegistration.FindFirst then
            Error(Text0005);


        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetRange("Student No.", "No.");
        if rStudentLedgerEntry.FindFirst then
            Error(Text0006);

        //if Confirm(Text0001, false, "No.") then begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            rUsersFamiliyStudents.Reset;
            rUsersFamiliyStudents.SetRange("School Year", rSchoolYear."School Year");
            rUsersFamiliyStudents.SetRange("Student Code No.", "No.");
            rUsersFamiliyStudents.DeleteAll(true);
        end;
        //  end else
        //     Error(Text0010);


        rRegistrationClass.Reset;
        rRegistrationClass.SetRange("Student Code No.", "No.");
        rRegistrationClass.DeleteAll(true);

        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", "No.");
        rRegistration.DeleteAll(true);

        rRegistrationSubjectsServices.Reset;
        rRegistrationSubjectsServices.SetRange("Student Code No.", "No.");
        rRegistrationSubjectsServices.DeleteAll(true);

        rStudentServicePlan.Reset;
        rStudentServicePlan.SetRange("Student No.", "No.");
        rStudentServicePlan.DeleteAll(true);
        cMasterTableWEB.DeleteStudent(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        rEduConfiguration.Get; //IT003,n
        if "No." = '' then begin
            //IT003,o rEduConfiguration.GET;
            rEduConfiguration.TestField("Student Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Student Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            InsertUsersStudent;
            if rUserSetup.Get(UserId) then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

            "Payment Method Code" := rEduConfiguration."Payment Method Code";
            "Currency Code" := rEduConfiguration."Currency Code";
            "Payment Terms Code" := rEduConfiguration."Payment Terms Code";
            "Customer Disc. Group" := rEduConfiguration."Customer Disc. Group";
            "Allow Line Disc." := rEduConfiguration."Allow Line Disc.";
            "Customer Posting Group" := rEduConfiguration."Customer Posting Group";
            "Gen. Bus. Posting Group" := rEduConfiguration."Gen. Bus. Posting Group";
            "VAT Bus. Posting Group" := rEduConfiguration."VAT Bus. Posting Group";
            "Use Student Disc. Group" := rEduConfiguration."Use Student Disc. Group";
            // Preencher com 'PT' por defeito, solicitado pelo cliente
            Validate("Nationality Code", cStudentsRegistration.GetCountry);
            Validate("Naturalness Code", cStudentsRegistration.GetCountry);
            //
        end;

        Validate("Language Code", rEduConfiguration."Language Code"); //IT003,n
        "Country/Region Code" := cStudentsRegistration.GetCountry;
        "User Id" := UserId;
        Date := WorkDate;

        cMasterTableWEB.InsertStudent(Rec, xRec);
    end;

    trigger OnModify()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            rUsersFamiliyStudents.Reset;
            rUsersFamiliyStudents.SetRange("School Year", rSchoolYear."School Year");
            rUsersFamiliyStudents.SetFilter(Kinship, '%1|%2', rUsersFamiliyStudents.Kinship::"Brother in School",
                                            rUsersFamiliyStudents.Kinship::Himself);
            rUsersFamiliyStudents.SetRange("No.", "No.");
            rUsersFamiliyStudents.ModifyAll(Name, Name);
            rUsersFamiliyStudents.ModifyAll("Last Name", "Last Name");
            rUsersFamiliyStudents.ModifyAll("Last Name 2", "Last Name 2");
            rUsersFamiliyStudents.ModifyAll(Address, Address + ' ' + "Address 2" + ' ' + ' ' + "Post Code" + ' ' + Location);

            rUsersFamiliyStudents.ModifyAll("Phone No.", "Phone No.");
            rUsersFamiliyStudents.ModifyAll("Mobile Phone", "Mobile Phone");
            rUsersFamiliyStudents.ModifyAll("E-mail", "E-mail");
            rUsersFamiliyStudents.ModifyAll("Use GIC", "Use GIC");
            rUsersFamiliyStudents.ModifyAll("Use WEB", "Use WEB");
            rUsersFamiliyStudents.ModifyAll("User Name", "User Name");
            rUsersFamiliyStudents.ModifyAll(Password, Password, true);
            ValidateStudentsAddress(rSchoolYear."School Year");
        end;

        rRegistrationClass.Reset;
        rRegistrationClass.SetRange("Student Code No.", "No.");
        rRegistrationClass.ModifyAll(Name, Name);
        rRegistrationClass.ModifyAll("Last Name", "Last Name");
        rRegistrationClass.ModifyAll("Last Name 2", "Last Name 2");
        rRegistrationClass.ModifyAll("Full Name", "Full Name");

        UpdateCustomer;

        cMasterTableWEB.ModifyStudent(Rec, xRec);



        //Dimension Integration
        //Update Customer Entry
        //
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0012, TableCaption);*/
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        rSchoolYear: Record "School Year";
        rUsersFamiliyStudents: Record "Users Family / Students";
        Text0001: Label 'Are you sure you want to delete the Student?';
        rStudents: Record Students;
        Text0002: Label 'There already is a Student %1 with the same Document ID.';
        Text0003: Label 'There already is a Student %1 with the same Name.';
        rTableMSI: Record "Table MISI";
        recStudentsPrint: Record Students;
        varName: Text[250];
        varTotalNames: Integer;
        VarName3: Text[250];
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        Text0005: Label 'Cannot delete students that have active registrations in the school.';
        rFregConDistCodes: Record "Legal Codes";
        Text73100: Label 'The password must have more than 6 characters.';
        Text001: Label 'The email address "%1" is invalid.';
        cStudentsRegistration: Codeunit "Students Registration";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        rStudentLedgerEntry: Record "Student Ledger Entry";
        Text0006: Label 'Cannot delete student. The Student has processed services.';
        Text0010: Label 'Operation cancelled by the user.';
        DimMgt: Codeunit DimensionManagement;
        Text0011: Label 'The student must have a handicapped to use this option.';
        rRegistrationClass: Record "Registration Class";
        Text0012: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";
        rBankAccount: Record "Bank Account";
        Text50000: Label 'Insira o NIB com 21 caracteres.';
        Text50001: Label 'Por Favor preencha o nif do aluno %1.';
        Text50002: Label 'Preenchimento incorrecto do NIF do aluno %1.';
        rCustomer: Record Customer;
        rCustomer2: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        Text50003: Label 'PTG';

    //[Scope('OnPrem')]
    procedure AssistEdit(OldStudent: Record Students): Boolean
    var
        Students: Record Students;
    begin

        // Students := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Student Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Student Nos.", OldStudent."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            //Rec := Students;
            //exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateProfile()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1|%2', rSchoolYear.Status::Active, rSchoolYear.Status::Planning);
        if rSchoolYear.Find('-') then begin
            repeat
                rUsersFamiliyStudents.Reset;
                rUsersFamiliyStudents.SetRange("School Year", rSchoolYear."School Year");
                rUsersFamiliyStudents.SetRange("No.", "No.");
                if rUsersFamiliyStudents.Find('-') then begin
                    repeat
                        rUsersFamiliyStudents.Name := Name;
                        rUsersFamiliyStudents."Last Name" := "Last Name";
                        rUsersFamiliyStudents."Last Name 2" := "Last Name 2";
                        rUsersFamiliyStudents.Address := Address + ' ' + "Address 2" + ' ' + "Post Code" + ' ' + Location;
                        rUsersFamiliyStudents."Phone No." := "Phone No.";
                        rUsersFamiliyStudents."Mobile Phone" := "Mobile Phone";
                        rUsersFamiliyStudents.Modify;

                    until rUsersFamiliyStudents.Next = 0;
                end;
            until rSchoolYear.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertUsersStudent()
    begin

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            rUsersFamiliyStudents.Init;
            rUsersFamiliyStudents."School Year" := rSchoolYear."School Year";
            rUsersFamiliyStudents."Student Code No." := "No.";
            rUsersFamiliyStudents.Kinship := rUsersFamiliyStudents.Kinship::Himself;
            rUsersFamiliyStudents."No." := "No."; //IT005
            rUsersFamiliyStudents.Insert;
            //IT005,sn
            rUsersFamiliyStudents.Validate("No.", "No.");
            rUsersFamiliyStudents.Modify;
            //IT005,en
        end;
    end;

    //[Scope('OnPrem')]
    procedure RegisterStudent(pType: Integer)
    var
        rRegistration: Record Registration;
        fRegistration: Page Registration;
    begin
        //pType = 1 Activo
        //pType = 2 Em Preparação
        //pType = 3 Em Fecho

        rSchoolYear.Reset;
        case pType of
            1:
                rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
            2:
                rSchoolYear.SetRange(Status, rSchoolYear.Status::Planning);
            3:
                rSchoolYear.SetRange(Status, rSchoolYear.Status::Closing);
        end;
        if rSchoolYear.FindFirst then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "No.");
            rRegistration.SetRange("School Year", rSchoolYear."School Year");
            //   IF rRegistration.FIND('-') THEN BEGIN
            fRegistration.SetTableView(rRegistration);
            fRegistration.RunModal
            //   END;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateCustomer()
    var
        rCustomer: Record Customer;
        rUsersFamily: Record "Users Family";
        rCandidate: Record Candidate;
        rCustBankAccount: Record "Customer Bank Account";
    begin
        if "Customer No." <> '' then begin
            if rCustomer.Get("Customer No.") then begin

                //Normatica 2014.07.07 atualizar o NIB na ficha da conta bancária
                if rCustomer.NIB <> NIB then begin
                    rCustBankAccount.Reset;
                    rCustBankAccount.SetRange(rCustBankAccount."Customer No.", rCustomer."No.");
                    if rCustBankAccount.FindFirst then begin
                        rCustBankAccount.Validate(rCustBankAccount.IBAN, 'PT50' + NIB);
                        rCustBankAccount.Modify;

                    end;
                end;
                //Normatica 2014.07.07 fim

                rCustomer.Name := Name;
                rCustomer."Post Code" := "Post Code";
                rCustomer.City := Location;
                rCustomer.Address := Address;
                rCustomer."Address 2" := "Address 2";
                rCustomer."Phone No." := "Phone No.";
                if "E-mail" <> '' then
                    rCustomer."E-Mail" := "E-mail";
                //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
                if "E-mail2" <> '' then
                    rCustomer."E-Mail2" := "E-mail2";
                rCustomer."Home Page" := "Home Page";
                rCustomer."Payment Method Code" := "Payment Method Code";
                rCustomer."Currency Code" := "Currency Code";
                rCustomer."Payment Terms Code" := "Payment Terms Code";
                rCustomer."Customer Disc. Group" := "Customer Disc. Group";
                rCustomer."Allow Line Disc." := "Allow Line Disc.";
                rCustomer."Customer Posting Group" := "Customer Posting Group";
                rCustomer."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                rCustomer."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                rCustomer."VAT Registration No." := "VAT Registration No.";
                rCustomer."Responsibility Center" := "Responsibility Center";
                rCustomer.IBAN := IBAN;
                rCustomer.NIB := NIB;
                rCustomer."Referencia ADC" := "Referencia ADC";
                rCustomer."Débitos Directos" := "Débitos Directos";
                rCustomer."EAN Enviado" := "EAN Enviado";
                rCustomer."ID CRED" := "ID CRED";
                rCustomer."Mobile Phone No." := "Mobile Phone"

                // rCustomer.MODIFY(TRUE);
            end;
            rCustomer.Modify;


        end;
        if "No." <> '' then begin
            rUsersFamily.Reset;
            rUsersFamily.SetRange("Customer No.", "No.");
            rUsersFamily.ModifyAll("Payment Method Code", "Payment Method Code");
            rUsersFamily.ModifyAll("Payment Terms Code", "Payment Terms Code");
            rUsersFamily.ModifyAll("Customer Disc. Group", "Customer Disc. Group");
            rUsersFamily.ModifyAll("Allow Line Disc.", "Allow Line Disc.");
            rUsersFamily.ModifyAll("Customer Posting Group", "Customer Posting Group");
            rUsersFamily.ModifyAll("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rUsersFamily.ModifyAll("VAT Bus. Posting Group", "VAT Bus. Posting Group");
        end;

        if "No." <> '' then begin
            rCandidate.Reset;
            rCandidate.SetRange("Customer No.", "No.");
            rCandidate.ModifyAll("Payment Method Code", "Payment Method Code");
            rCandidate.ModifyAll("Payment Terms Code", "Payment Terms Code");
            rCandidate.ModifyAll("Customer Disc. Group", "Customer Disc. Group");
            rCandidate.ModifyAll("Allow Line Disc.", "Allow Line Disc.");
            rCandidate.ModifyAll("Customer Posting Group", "Customer Posting Group");
            rCandidate.ModifyAll("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rCandidate.ModifyAll("VAT Bus. Posting Group", "VAT Bus. Posting Group");
        end;
    end;

    //[Scope('OnPrem')]
    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "Report Selections";
    begin
        recStudentsPrint.Copy(Rec);
        ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Student");
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.Find('-');
        repeat
            REPORT.RunModal(ReportSelection."Report ID", ShowRequestForm, false, recStudentsPrint);
        until ReportSelection.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure CheckValidEmailAddress(EmailAddress: Text[250])
    var
        i: Integer;
        NoOfAtSigns: Integer;
    begin
        if EmailAddress = '' then
            Error(Text001, EmailAddress);

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
            Error(Text001, EmailAddress);

        for i := 1 to StrLen(EmailAddress) do begin
            if EmailAddress[i] = '@' then
                NoOfAtSigns := NoOfAtSigns + 1;
            if not (
              ((EmailAddress[i] >= 'a') and (EmailAddress[i] <= 'z')) or
              ((EmailAddress[i] >= 'A') and (EmailAddress[i] <= 'Z')) or
              ((EmailAddress[i] >= '0') and (EmailAddress[i] <= '9')) or
              (EmailAddress[i] in ['@', '.', '-', '_']))
            then
                Error(Text001, EmailAddress);
        end;

        if NoOfAtSigns <> 1 then
            Error(Text001, EmailAddress);
    end;

    //[Scope('OnPrem')]
    procedure ValidateStudentsAddress(pSchoolYear: Code[9])
    var
        l_Students: Record Students;
    begin

        rUsersFamiliyStudents.Reset;
        rUsersFamiliyStudents.SetRange("School Year", pSchoolYear);
        rUsersFamiliyStudents.SetRange(Kinship, rUsersFamiliyStudents.Kinship::"Brother in School");
        rUsersFamiliyStudents.SetRange("No.", "No.");
        rUsersFamiliyStudents.SetRange("User Family Address", true);
        if rUsersFamiliyStudents.Find('-') then begin
            repeat
                if l_Students.Get(rUsersFamiliyStudents."Student Code No.") then
                    l_Students.Address := Address;
                l_Students."Address 2" := "Address 2";
                l_Students."Post Code" := "Post Code";
                l_Students.Location := Location;
                l_Students."Phone No." := "Phone No.";
                l_Students.Modify(true);
            until rUsersFamiliyStudents.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateName(): Boolean
    begin
        rStudents.Reset;
        if Name <> '' then
            rStudents.SetRange(Name, Name)
        else
            rStudents.SetRange(Name, '');
        if "Last Name" <> '' then
            rStudents.SetFilter("Last Name", "Last Name")
        else
            rStudents.SetRange("Last Name", '');

        if "Last Name 2" <> '' then
            rStudents.SetRange("Last Name 2", "Last Name 2")
        else
            rStudents.SetRange("Last Name 2", '');

        rStudents.SetFilter("No.", '<>%1', "No.");
        rStudents.SetRange("Responsibility Center", "Responsibility Center");
        if rStudents.FindFirst then begin
            Message(Text0003, rStudents."No.");
            exit(true);
        end else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure UpdateFullName()
    begin
        if rEduConfiguration.Get then begin
            if rEduConfiguration."Full Name syntax" = 0 then begin
                if "Last Name 2" <> '' then
                    "Full Name" := "Last Name" + ' ' + "Last Name 2" + ', ' + Name
                else
                    "Full Name" := "Last Name" + ', ' + Name;
            end else begin
                if "Last Name 2" <> '' then
                    "Full Name" := Name + ' ' + "Last Name 2" + ' ' + "Last Name"
                else
                    "Full Name" := Name + ' ' + "Last Name";
            end;

        end;


        if "Last Name 2" <> '' then
            varName := Name + ' ' + "Last Name 2" + ' ' + "Last Name"
        else
            varName := Name + ' ' + "Last Name";

        varTotalNames := 1;
        //Tirar espaços à esquerda
        while CopyStr(varName, 1, 1) = ' ' do begin
            varName := CopyStr(varName, 2);
        end;
        //Tirar espaços à direita
        while CopyStr(varName, StrLen(varName), 1) = ' ' do begin
            varName := CopyStr(varName, 1, StrLen(varName) - 1);
        end;
        //Saber quantas palavras tem o nome
        VarName3 := varName;
        while StrPos(VarName3, ' ') <> 0 do begin
            VarName3 := CopyStr(VarName3, StrPos(VarName3, ' ') + 1);
            varTotalNames := varTotalNames + 1
        end;
        if ((varTotalNames = 1) or (varTotalNames = 2) or (varTotalNames = 3)) then begin
            if rEduConfiguration."Full Name syntax" = rEduConfiguration."Full Name syntax"::"Name + Last Name" then
                Validate("Short Name", varName)
            else
                Validate("Short Name", "Last Name" + ', ' + Name);
        end;
        if varTotalNames > 3 then begin
            VarName3 := varName;
            while StrPos(VarName3, ' ') <> 0 do begin
                VarName3 := CopyStr(VarName3, StrPos(VarName3, ' ') + 1);
            end;
            if rEduConfiguration."Full Name syntax" = rEduConfiguration."Full Name syntax"::"Name + Last Name" then
                Validate("Short Name", CopyStr(varName, 1, StrPos(varName, ' ') - 1) + ' ' +
                       CopyStr(CopyStr(varName, StrPos(varName, ' ') + 1), 1, StrPos(CopyStr(varName, StrPos(varName, ' ') + 1), ' ') - 1) +
                       ' ' + CopyStr(VarName3, StrPos(VarName3, ' ') + 1))
            else
                Validate("Short Name", CopyStr(VarName3, StrPos(VarName3, ' ') + 1) + ', ' +
                         CopyStr(varName, 1, StrPos(varName, ' ') - 1) + ' ' +
                         CopyStr(CopyStr(varName, StrPos(varName, ' ') + 1), 1, StrPos(CopyStr(varName, StrPos(varName, ' ') + 1), ' ') - 1));
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Students, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    /*//[Scope('OnPrem')]
    procedure OpenFile(WindowTitle: Text[50]; DefaultFileName: Text[250]; DefaultFileType: Option " ",Text,Excel,Word,Custom; FilterString: Text[250]; "Action": Option Open,Save; var FileNameImport: Text[250]; var Extension: Code[50]; var Path: Text[250]) returnText: Text[260]
    var
        Text0031: Label '.txt';
        Text0032: Label '.xls';
        Text0033: Label '.doc';
        pos: Integer;
        fileName: Text[250];
        FileMgt: Codeunit "File Management";
    begin

        /*CommonDialogControl.FileName := DefaultFileName;
        CommonDialogControl.DialogTitle := WindowTitle;
        
        IF DefaultFileType = DefaultFileType::Custom THEN BEGIN
          IF STRPOS(UPPERCASE(FilterString),'.DOC') > 0 THEN
            DefaultFileType := DefaultFileType::Word;
          IF STRPOS(UPPERCASE(FilterString),'.XL') > 0 THEN
            DefaultFileType := DefaultFileType::Excel;
        END;
        
        CASE DefaultFileType OF
          DefaultFileType::Text:
            CommonDialogControl.Filter := Text0031;
          DefaultFileType::Excel:
            CommonDialogControl.Filter := Text0032;
          DefaultFileType::Word:
            CommonDialogControl.Filter := Text0033;
          DefaultFileType::Custom:
            CommonDialogControl.Filter := FilterString;
        END;
        
        CommonDialogControl.InitDir := DefaultFileName;*//*
        if Action = Action::Open then
            //CommonDialogControl.ShowOpen
            FileNameImport := FileMgt.OpenFileDialog(WindowTitle, DefaultFileName, FilterString)
        else
            //CommonDialogControl.ShowSave;
            FileNameImport := FileMgt.SaveFileDialog(WindowTitle, DefaultFileName, FilterString);

        returnText := FileNameImport;

        //FileNameImport := CommonDialogControl.FileName;
        if FileNameImport <> '' then begin
            Path := FileNameImport;
            fileName := FileNameImport;
            while StrPos(fileName, '.') <> 0 do begin
                fileName := CopyStr(fileName, StrPos(fileName, '.') + 1);
            end;
            Extension := fileName;
            while StrPos(FileNameImport, '\') <> 0 do begin
                FileNameImport := CopyStr(FileNameImport, StrPos(FileNameImport, '\') + 1);
            end;
            FileNameImport := CopyStr(FileNameImport, 1, StrPos(FileNameImport, '.') - 1);
        end;

        //EXIT(CommonDialogControl.FileName);

    end;*/

    //[Scope('OnPrem')]
    procedure GetOpenCreditNotes(): Boolean
    var
        rCompany: Record Company;
        rUsersFamilyStudent: Record "Users Family / Students";
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        rCustomer: Record Customer;
    begin
        /*rCompany.RESET;
        rCompany.SETFILTER("Master Company",'<>%1','');
        IF rCompany.FINDSET THEN BEGIN
          REPEAT*/
        rUsersFamilyStudent.Reset;
        rUsersFamilyStudent.SetRange("Paying Entity", true);
        rUsersFamilyStudent.SetRange("Student Code No.", "No.");
        if rUsersFamilyStudent.FindSet then begin
            repeat
                if (rUsersFamilyStudent.Kinship = rUsersFamilyStudent.Kinship::Himself) or
                  (rUsersFamilyStudent.Kinship = rUsersFamilyStudent.Kinship::"Brother in School") then begin
                    rCustomer.Reset;
                    rCustomer.SetRange("Student No.", "No.");
                    if rCustomer.FindFirst then begin
                        Clear(rCustLedgerEntry);
                        rCustLedgerEntry.Reset;
                        //rCustLedgerEntry.CHANGECOMPANY(rCompany.Name);
                        rCustLedgerEntry.SetRange(Open, true);
                        rCustLedgerEntry.SetRange("Customer No.", rCustomer."No.");
                        rCustLedgerEntry.SetRange("Document Type", rCustLedgerEntry."Document Type"::"Credit Memo");
                        if rCustLedgerEntry.FindFirst then begin
                            exit(true);
                        end;
                    end;
                end;
                if (rUsersFamilyStudent.Kinship <> rUsersFamilyStudent.Kinship::Himself) or
                  (rUsersFamilyStudent.Kinship <> rUsersFamilyStudent.Kinship::"Brother in School") then begin
                    rCustomer.Reset;
                    rCustomer.SetRange("User Family No.", rUsersFamilyStudent."No.");
                    if rCustomer.FindFirst then begin
                        Clear(rCustLedgerEntry);
                        rCustLedgerEntry.Reset;
                        //rCustLedgerEntry.CHANGECOMPANY(rCompany.Name);
                        rCustLedgerEntry.SetRange(Open, true);
                        rCustLedgerEntry.SetRange("Customer No.", rCustomer."No.");
                        rCustLedgerEntry.SetRange("Document Type", rCustLedgerEntry."Document Type"::"Credit Memo");
                        if rCustLedgerEntry.FindFirst then begin
                            exit(true);
                        end;
                    end;
                end;
            until rUsersFamilyStudent.Next = 0;
        end;
        //UNTIL rCompany.NEXT = 0;
        //END;

    end;

    //[Scope('OnPrem')]
    procedure CheckCustomerNIBAdmin()
    var
        "rUser Setup": Record "User Setup";
    begin
        "rUser Setup".Get(UserId);
        "rUser Setup".TestField("Customer NIB Admin");
    end;

    //[Scope('OnPrem')]
    procedure ValidateNIF()
    begin
        if ("VAT Registration No." = '') then
            Error(Text50001, "No.");

        if (StrLen(Format("VAT Registration No.")) <> 9) then
            Error(Text50002, "No.");
    end;
}

