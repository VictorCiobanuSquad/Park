table 52753 "Users Family"
{
    // //IT001 - Parque - Portal Fardas - 2017.04.26 - novo campo Password portal
    // 
    // IT002 - Idiomas - 2017.10.10
    //       - Novo campo: "Language Code": 50017
    //       - Alteração trigger OnInsert: Preenchimento "Language Code"
    // 
    // //IT003 - Parque - 2017.11.21 -  sinconização dados entre associado e cliente
    // 
    // IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
    // 
    // It005 - Park - 2019.07.02 - Novos campos usados no portal das fardas para o login e mudança de email
    //                           - Temp E-mail
    //                           - ID Login Modify
    //                           - E-mail checked

    Caption = 'Users Family';
    LookupPageID = "Users Family List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    rEduConfiguration.Get;
                    NoSeriesMgt.TestManual(rEduConfiguration."Users Family Nos.");
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



                UpdateProfile;
                CreateShortName;
            end;
        }
        field(3; Address; Text[60])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(4; "Address 2"; Text[50])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(6; "Post Code"; Code[20])
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
                PostCode.ValidatePostCode(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
                UpdateProfile;
            end;
        }
        field(7; Location; Text[30])
        {
            Caption = 'Location';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
                UpdateProfile;
            end;
        }
        field(8; "Parish/Council/District Code"; Code[10])
        {
            Caption = 'Parish/Council/District Code';
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
        field(9; Town; Text[100])
        {
            Caption = 'Town';
            Editable = false;
        }
        field(10; County; Text[100])
        {
            Caption = 'County';
            Editable = false;
        }
        field(11; District; Text[100])
        {
            Caption = 'District';
            Editable = false;
        }
        field(12; Prefix; Text[9])
        {
            Caption = 'Prefix';
        }
        field(13; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(14; "Mobile Prefix"; Text[6])
        {
            Caption = 'Mobile Prefix';
        }
        field(15; "Mobile Phone"; Text[14])
        {
            Caption = 'Mobile Phone';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(16; "E-mail"; Text[64])
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
        field(17; "Naturalness Code"; Code[10])
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
        field(18; Naturalness; Text[60])
        {
            Caption = 'Nationality';
            Editable = false;
        }
        field(19; "Nationality Code"; Code[10])
        {
            Caption = 'Citizenship Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = CONST(Nacionalidade));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::Nacionalidade, "Nationality Code") then
                    Nationality := rTableMSI.Description
                else
                    Nationality := '';
            end;
        }
        field(20; Nationality; Text[60])
        {
            Caption = 'Citizenship';
            Editable = false;
        }
        field(21; "Academic Training Code"; Code[10])
        {
            Caption = 'Academic Training Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER("Formação"));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::"Formação", "Academic Training Code") then
                    "Academic Training" := rTableMSI.Description
                else
                    "Academic Training" := '';
            end;
        }
        field(22; "Academic Training"; Text[60])
        {
            Caption = 'Academic Training';
            Editable = false;
        }
        field(23; "Occupation Code"; Code[10])
        {
            Caption = 'Occupation Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(CodProfissao));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::CodProfissao, "Occupation Code") then
                    Occupation := rTableMSI.Description
                else
                    Occupation := '';
            end;
        }
        field(24; Occupation; Text[160])
        {
            Caption = 'Occupation';
            Editable = false;
        }
        field(25; "Employment Situation Code"; Code[10])
        {
            Caption = 'Employment Situation Code';
            Description = 'MISI';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(SituacaoEmp));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::SituacaoEmp, "Employment Situation Code") then
                    "Employment Situation" := rTableMSI.Description
                else
                    "Employment Situation" := '';
            end;
        }
        field(26; "Employment Situation"; Text[60])
        {
            Caption = 'Employment Situation';
            Editable = false;
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(28; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(29; "Doc. Type Id"; Option)
        {
            Caption = 'Doc. Type Id';
            OptionCaption = ' ,Identification Card,Child Identification Card,Passport,Residence Permit,Citizen Card';
            OptionMembers = " ",BI,"Cédula",Passporte,"Autorização de Residência","Cartão Cidadão";
        }
        field(30; "Doc. Number Id"; Text[32])
        {
            Caption = 'Doc. Number ID';

            trigger OnValidate()
            begin
                rUsersFamily.Reset;
                rUsersFamily.SetRange("Doc. Type Id", "Doc. Type Id");
                rUsersFamily.SetFilter("No.", '<>%1', "No.");
                if rUsersFamily.Find('-') then begin
                    repeat
                        if rUsersFamily."Doc. Number Id" = "Doc. Number Id" then
                            Message(Text0002, rUsersFamily."No.");
                    until rUsersFamily.Next = 0;
                end;
            end;
        }
        field(31; "Archive of Identification"; Text[30])
        {
            Caption = 'Identification Archive';
        }
        field(32; "Date Validity"; Date)
        {
            Caption = 'Expiration date';
        }
        field(33; "Date Issuance"; Date)
        {
            Caption = 'Date of issue';
        }
        field(35; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(37; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::"Users Family");
            end;
        }
        field(38; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(39; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(40; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method" WHERE("Payment Edu" = FILTER(true));
        }
        field(41; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(42; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(43; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(44; "Gen. Bus. Posting Group"; Code[10])
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
        field(45; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(48; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(49; Sex; Option)
        {
            Caption = 'Sex';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(50; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(51; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionCaption = 'Single,Married,Divorced,Widow,Other';
            OptionMembers = Single,Married,Divorced,Widowed,Other;
        }
        field(52; "Phone No. 2"; Text[14])
        {
            Caption = 'Phone No. 2';
        }
        field(53; Work; Text[30])
        {
            Caption = 'Work';
        }
        field(54; "Work Company"; Text[30])
        {
            Caption = 'Work Company';
        }
        field(55; "Language spoken to children"; Text[30])
        {
            Caption = 'Language spoken to children';
        }
        field(56; "Short Name"; Text[50])
        {
            Caption = 'Short Name';
        }
        field(59; "Local Birth Place"; Text[30])
        {
            Caption = 'Birth Place';
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
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Users Family"),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
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
        field(50000; "Student No."; Code[20])
        {
            CalcFormula = Lookup("Users Family / Students"."Student Code No." WHERE("No." = FIELD("No.")));
            Caption = 'Student No.';
            Description = 'CPA.01';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Students;
        }
        field(50001; "Password Portal"; Text[30])
        {
            Description = 'Parque - Portal Fardas';
        }
        field(50002; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            Description = 'IT002';
            TableRelation = Language;

            trigger OnValidate()
            begin
                //IT002,en
                Clear(rCustomer);
                rCustomer.SetRange("User Family No.", "No.");
                if rCustomer.FindFirst then begin
                    rCustomer."Language Code" := "Language Code";
                    SalesSetup.Get;
                    if ("Language Code" = '') or ("Language Code" = Text50000) then begin
                        rCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
                        rCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
                    end else begin
                        rCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
                        rCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
                    end;
                    rCustomer.Modify;
                end;
                //IT002,en
            end;
        }
        field(50003; "E-mail2"; Text[64])
        {
            Caption = 'E-mail';

            trigger OnValidate()
            begin
                //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email

                if "E-mail2" = '' then
                    if xRec."E-mail2" <> '' then
                        exit;

                CheckValidEmailAddress("E-mail2");
            end;
        }
        field(50004; "Temp E-mail"; Text[64])
        {
            Description = 'Park - Portal Fardas';
        }
        field(50005; "ID Login Modify"; Text[50])
        {
            Description = 'Park - Portal Fardas';
        }
        field(50006; "E-mail checked"; Boolean)
        {
            Description = 'Park - Portal Fardas';
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';

            trigger OnValidate()
            begin
                ValidateName;
                UpdateProfile;
                CreateShortName;
            end;
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';

            trigger OnValidate()
            begin
                ValidateName;
                UpdateProfile;
                CreateShortName;
            end;
        }
        field(73102; County1; Text[30])
        {
            Caption = 'County';
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
            InitValue = Castilian;
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
        field(73108; Picture; BLOB)
        {
            Caption = 'Picture';
            Compressed = false;
        }
        field(73109; Domain; Option)
        {
            Caption = 'Domain';
            OptionCaption = ' ,Domain 1,Domain 2,Domain 3,Domain 4,Domain 5';
            OptionMembers = " ","Domain 1","Domain 2","Domain 3","Domain 4","Domain 5";
        }
        field(73110; NISS; Text[20])
        {
            Caption = 'SSN';
            Description = 'Numero de Identificaçao Segurança Social';
        }
        field(73111; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(73112; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Last Name", "Last Name 2", Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rUsersFamilyCandidate.Reset;
        rUsersFamilyCandidate.SetFilter(Kinship, '<>%1&<>%2', rUsersFamilyCandidate.Kinship::"Brother in School",
           rUsersFamilyCandidate.Kinship::Himself);
        rUsersFamilyCandidate.SetRange("No.", "No.");
        if rUsersFamilyCandidate.FindFirst then
            Error(Text002, rUsersFamilyCandidate."Candidate Code No.");


        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetFilter(Kinship, '<>%1&<>%2', rUsersFamilyStudents.Kinship::"Brother in School",
           rUsersFamilyStudents.Kinship::Himself);
        rUsersFamilyStudents.SetRange("No.", "No.");
        if rUsersFamilyStudents.FindFirst then
            Error(Text003, rUsersFamilyStudents."Student Code No.");
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Users Family Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Users Family Nos.", xRec."No. Series", 0D, "No.", "No. Series");
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
            Validate("Language Code", rEduConfiguration."Language Code"); //IT002,n

        end;


        "Country/Region Code" := cStudentsRegistration.GetCountry;
        "User Id" := UserId;
        Date := WorkDate;

        UpdateCustomer;
    end;

    trigger OnModify()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then begin
            rUsersFamilyStudents.Reset;
            rUsersFamilyStudents.SetRange("School Year", rSchoolYear."School Year");
            rUsersFamilyStudents.SetFilter(Kinship, '<>%1&<>%2', rUsersFamilyStudents.Kinship::"Brother in School",
                                            rUsersFamilyStudents.Kinship::Himself);
            rUsersFamilyStudents.SetRange("No.", "No.");
            rUsersFamilyStudents.ModifyAll(Name, Name);
            rUsersFamilyStudents.ModifyAll("Last Name", "Last Name");
            rUsersFamilyStudents.ModifyAll("Last Name 2", "Last Name 2");
            rUsersFamilyStudents.ModifyAll(Address, Address);
            rUsersFamilyStudents.ModifyAll("Phone No.", "Phone No.");
            rUsersFamilyStudents.ModifyAll("Mobile Phone", "Mobile Phone");
            rUsersFamilyStudents.ModifyAll("Phone No. 2", "Phone No. 2");
            rUsersFamilyStudents.ModifyAll("E-mail", "E-mail");
            rUsersFamilyStudents.ModifyAll("Use GIC", "Use GIC");
            rUsersFamilyStudents.ModifyAll("Use WEB", "Use WEB");
            rUsersFamilyStudents.ModifyAll("User Name", "User Name");
            rUsersFamilyStudents.ModifyAll(Language, Language);
            rUsersFamilyStudents.ModifyAll(Password, Password, true);
            ValidateStudentsAddress(rSchoolYear."School Year");
        end;

        UpdateCustomer;
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
        rSchoolYear: Record "School Year";
        rUsersFamily: Record "Users Family";
        Text0002: Label 'There already is a Users Family %1 with the same Name.';
        Text0003: Label 'There already is a Users Family %1 with the same Name.';
        rTableMSI: Record "Table MISI";
        PostCode: Record "Post Code";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        rFregConDistCodes: Record "Legal Codes";
        Text73100: Label 'The password must have more then 6 characters.';
        Text001: Label 'The e-mail address "%1" is invalid.';
        rUsersFamilyStudents: Record "Users Family / Students";
        rUsersFamilyCandidate: Record "Users Family / Candidate";
        Text002: Label 'The Users Family is associated to candidate %1';
        Text003: Label 'The Users Family is associated to Student %1';
        varName: Text[250];
        varTotalNames: Integer;
        VarName3: Text[250];
        cStudentsRegistration: Codeunit "Students Registration";
        DimMgt: Codeunit DimensionManagement;
        Text0012: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";
        UpdateUF: Codeunit "Validate User ID";
        rCustomer: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        Text50000: Label 'EN';

    //[Scope('OnPrem')]
    procedure AssistEdit(OldUserFamily: Record "Users Family"): Boolean
    var
        UserFamily: Record "Users Family";
    begin
        //  UserFamily := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Users Family Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Users Family Nos.", OldUserFamily."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            //   Rec := UserFamily;
            //exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateProfile()
    var
        rUsersFamilyStudents: Record "Users Family / Students";
        rUsersFamilyCandidate: Record "Users Family / Candidate";
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetFilter(Status, '%1|%2', rSchoolYear.Status::Active, rSchoolYear.Status::Planning);
        if rSchoolYear.Find('-') then begin
            repeat
                rUsersFamilyStudents.Reset;
                rUsersFamilyStudents.SetRange("School Year", rSchoolYear."School Year");
                rUsersFamilyStudents.SetRange("No.", "No.");
                if rUsersFamilyStudents.Find('-') then begin
                    repeat
                        rUsersFamilyStudents.Name := Name;
                        rUsersFamilyStudents."Last Name" := "Last Name";
                        rUsersFamilyStudents."Last Name 2" := "Last Name 2";
                        rUsersFamilyStudents.Address := Address + ' ' + "Address 2" + ' ' + "Post Code" + ' ' + Location;
                        rUsersFamilyStudents."Phone No." := "Phone No.";
                        rUsersFamilyStudents."Mobile Phone" := "Mobile Phone";
                        rUsersFamilyStudents.Modify;

                    until rUsersFamilyStudents.Next = 0;
                end;
            until rSchoolYear.Next = 0;
        end;

        rUsersFamilyCandidate.Reset;
        rUsersFamilyCandidate.SetRange("No.", "No.");
        if rUsersFamilyCandidate.Find('-') then begin
            repeat
                rUsersFamilyCandidate.Name := Name;
                rUsersFamilyCandidate.Address := Address + ' ' + "Address 2" + ' ' + "Post Code" + ' ' + Location;
                rUsersFamilyCandidate."Phone No." := "Phone No.";
                rUsersFamilyCandidate."Mobile Phone" := "Mobile Phone";
                rUsersFamilyCandidate.Modify;

            until rUsersFamilyCandidate.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateCustomer()
    var
        rCustomer: Record Customer;
        rStudents: Record Students;
        rCandidate: Record Candidate;
    begin
        if "Customer No." <> '' then begin
            if rCustomer.Get("Customer No.") then begin
                rCustomer.Name := CopyStr(Name, 1, 50);
                rCustomer."Name 2" := CopyStr("Last Name" + ' ' + "Last Name 2", 1, 50);
                rCustomer."Post Code" := "Post Code";
                rCustomer.City := Location;
                rCustomer.Address := Address;
                rCustomer."Address 2" := "Address 2";
                rCustomer."Phone No." := "Phone No.";
                rCustomer."E-Mail" := "E-mail";
                //IT004 - Park - 2018.01.10 - novo campo Email2 para os envios por email
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
                //IT003 - Parque - 2017.11.21 -  sinconização dados entre associado e cliente
                rCustomer."Country/Region Code" := "Country/Region Code";
                rCustomer."VAT Registration No." := "VAT Registration No.";
                rCustomer."Language Code" := "Language Code";
                rCustomer."Mobile Phone No." := "Mobile Phone";
                //IT003 - Parque - 2017.11.21 -  en

                //rCustomer.MODIFY(TRUE);
                rCustomer.Modify;
            end;
        end;

        if "No." <> '' then begin
            rStudents.Reset;
            rStudents.SetRange("Customer No.", "No.");
            rStudents.ModifyAll("Payment Method Code", "Payment Method Code");
            rStudents.ModifyAll("Payment Terms Code", "Payment Terms Code");
            rStudents.ModifyAll("Customer Disc. Group", "Customer Disc. Group");
            rStudents.ModifyAll("Allow Line Disc.", "Allow Line Disc.");
            rStudents.ModifyAll("Customer Posting Group", "Customer Posting Group");
            rStudents.ModifyAll("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            rStudents.ModifyAll("VAT Bus. Posting Group", "VAT Bus. Posting Group");
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
        l_UsersFamilyCandidate: Record "Users Family / Candidate";
        l_Candidate: Record Candidate;
    begin

        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetRange("No.", "No.");
        rUsersFamilyStudents.SetRange("School Year", pSchoolYear);
        rUsersFamilyStudents.SetFilter(Kinship, '<>%1&<>%2', rUsersFamilyStudents.Kinship::"Brother in School",
                                        rUsersFamilyStudents.Kinship::Himself);
        rUsersFamilyStudents.SetRange("User Family Address", true);
        if rUsersFamilyStudents.Find('-') then begin
            repeat
                if l_Students.Get(rUsersFamilyStudents."Student Code No.") then
                    l_Students.Address := Address;
                l_Students."Address 2" := "Address 2";
                l_Students."Post Code" := "Post Code";
                l_Students.Location := Location;
                l_Students."Phone No." := "Phone No.";
                l_Students.Modify(true);
            until rUsersFamilyStudents.Next = 0;
        end;


        l_UsersFamilyCandidate.Reset;
        l_UsersFamilyCandidate.SetRange("No.", "No.");
        l_UsersFamilyCandidate.SetFilter(Kinship, '<>%1&<>%2', l_UsersFamilyCandidate.Kinship::"Brother in School",
                                        l_UsersFamilyCandidate.Kinship::Himself);
        l_UsersFamilyCandidate.SetRange("User Family Address", true);
        if l_UsersFamilyCandidate.Find('-') then begin
            repeat
                if l_Candidate.Get(l_UsersFamilyCandidate."Candidate Code No.") then begin
                    l_Candidate.Address := Address;
                    l_Candidate."Address 2" := "Address 2";
                    l_Candidate."Post Code" := "Post Code";
                    l_Candidate.Location := Location;
                    l_Candidate."Phone No." := "Phone No.";
                    l_Candidate.Modify(true);
                end;
            until l_UsersFamilyCandidate.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateName()
    begin
        rUsersFamily.Reset;
        if Name <> '' then
            rUsersFamily.SetRange(Name, Name)
        else
            rUsersFamily.SetRange(Name, '');

        if "Last Name" <> '' then
            rUsersFamily.SetRange("Last Name", "Last Name")
        else
            rUsersFamily.SetRange("Last Name", '');
        if "Last Name 2" <> '' then
            rUsersFamily.SetRange("Last Name 2", "Last Name 2")
        else
            rUsersFamily.SetRange("Last Name 2", '');

        //IT - 2016.09.14 - como usam a importação de dados do site
        //não posso deixar aparecer esta mensagem
        /*
        rUsersFamily.SETRANGE("No.",'<>%1',"No.");
        rUsersFamily.SETRANGE("Responsibility Center","Responsibility Center");
        IF rUsersFamily.FINDFIRST THEN
           MESSAGE(Text0002,rUsersFamily."No.");
        */

    end;

    //[Scope('OnPrem')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Users Family", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    //[Scope('OnPrem')]
    procedure CreateShortName()
    begin
        if rEduConfiguration.Get then begin
            if rEduConfiguration."Full Name syntax" = 0 then begin
                if "Last Name 2" <> '' then
                    varName := "Last Name" + ' ' + "Last Name 2" + ', ' + Name
                else
                    varName := "Last Name" + ', ' + Name;
            end else begin
                if "Last Name 2" <> '' then
                    varName := Name + ' ' + "Last Name 2" + ' ' + "Last Name"
                else
                    varName := Name + ' ' + "Last Name";
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
    end;

    //[Scope('OnPrem')]
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
        
        CommonDialogControl.InitDir := DefaultFileName;*/
        /*if Action = Action::Open then
            //CommonDialogControl.ShowOpen
            FileNameImport := FileMgt.OpenFileDialog(WindowTitle, DefaultFileName, FilterString)
        else
            //CommonDialogControl.ShowSave;
            FileNameImport := FileMgt.SaveFileDialog(WindowTitle, DefaultFileName, FilterString);*/

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

    end;
}

