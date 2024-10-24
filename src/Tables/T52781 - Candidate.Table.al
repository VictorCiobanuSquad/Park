table 52781 Candidate
{
    Caption = 'Candidates';
    LookupPageID = "Candidate List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    rEduConfiguration.Get;
                    //NoSeriesMgt.TestManual(rEduConfiguration."Candidate Nos.");
                    CU_NoSeries.TestManual(rEduConfiguration."Candidate Nos.");
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
                UpdateFullName;
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
            Caption = 'Nationality Code';
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
            Caption = 'Nationality';
            Editable = false;
        }
        field(8; "Naturalness Code"; Code[10])
        {
            Caption = 'Naturalness Code';
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
            Caption = 'Naturalness';
            Editable = false;
        }
        field(10; Town; Text[100])
        {
            Caption = 'Town';
            Editable = false;
        }
        field(11; County; Text[100])
        {
            Caption = 'County';
            Editable = false;
        }
        field(12; District; Text[100])
        {
            Caption = 'District';
            Editable = false;
        }
        field(13; "Doc. Type Id"; Option)
        {
            Caption = 'Doc. Type Id';
            OptionCaption = ' ,Identification Card,Child Identification Card,Passport,Residence Permit,Other,Citizen Card';
            OptionMembers = " ",BI,"Cédula",Passporte,"Autorização de Residência",Outro,"Cartão Cidadão";
        }
        field(14; "Doc. Number Id"; Text[32])
        {
            Caption = 'Doc. Number ID';

            trigger OnValidate()
            begin
                rCandidate.Reset;
                rCandidate.SetRange("Doc. Type Id", "Doc. Type Id");
                rCandidate.SetFilter("No.", '<>%1', "No.");
                if rCandidate.Find('-') then begin
                    repeat
                        if rCandidate."Doc. Number Id" = "Doc. Number Id" then
                            Message(Text0002, rCandidate."No.");
                    until rCandidate.Next = 0;
                end;
            end;
        }
        field(15; "Archive of Identification"; Text[30])
        {
            Caption = 'Identification Archive';
        }
        field(16; "Date Validity"; Date)
        {
            Caption = 'Expiration date ';
        }
        field(17; "Date Issuance"; Date)
        {
            Caption = 'Date of issue';
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
        field(24; Address; Text[50])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                UpdateProfile;
            end;
        }
        field(25; "Address 2"; Text[50])
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
            begin
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
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
                PostCode.ValidateCity(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
                UpdateProfile;
            end;
        }
        field(29; NISS; Text[20])
        {
            Caption = 'SSN';
            Description = 'Numero de Identificaçao Segurança Social';
        }
        field(30; NCGA; Text[11])
        {
            Caption = 'NCGA';
        }
        field(31; "Student/Worker"; Boolean)
        {
            Caption = 'Student/Worker';
        }
        field(32; "Recipient of the SASE"; Option)
        {
            Caption = 'Recipient of the SASE';
            OptionCaption = 'No benefits, Category B, Category A, Category C';
            OptionMembers = "Não Beneficia","Escalão B","Escalão A","Escalão C";
        }
        field(33; "Special Needs"; Boolean)
        {
            Caption = 'Special Needs';
        }
        field(34; "Special Needs Descripton"; Text[60])
        {
            Caption = 'Special Needs Descripton';
        }
        field(35; Computer; Boolean)
        {
            Caption = 'Computer';
        }
        field(36; Internet; Boolean)
        {
            Caption = 'Internet';
        }
        field(37; "Academic Training Code"; Code[10])
        {
            Caption = 'Academic Training Code';
            TableRelation = "Table MISI".Code WHERE(Type = FILTER("Formação"));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::"Formação", "Academic Training Code") then
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
        field(39; "Occupation Code"; Code[10])
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
            Caption = 'Father Deceased/Unknown';
        }
        field(44; "Deceased Mother/Unknown"; Boolean)
        {
            Caption = 'Deceased Mother/Unknown';
        }
        field(45; Picture; BLOB)
        {
            Caption = 'Picture';
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
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(49; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(50; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::"Users Family");
            end;
        }
        field(51; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(52; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(53; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(54; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(55; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
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

                UpdateCustomer;
            end;
        }
        field(57; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                UpdateCustomer;
            end;
        }
        field(58; "Parish/Council/District Code"; Code[10])
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
        field(1000; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User ID");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(2002; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            Editable = false;
            TableRelation = Students."No.";
        }
        field(2003; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';

            trigger OnValidate()
            begin
                if "Last Name" <> '' then
                    ValidateName;

                UpdateFullName;
            end;
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';

            trigger OnValidate()
            begin
                if "Last Name 2" <> '' then
                    ValidateName;

                UpdateFullName;
            end;
        }
        field(73102; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(73112; "Full Name"; Text[191])
        {
            Caption = 'Full Name';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        /*//PT tem de estar comentado
        IF CONFIRM(Text0001,FALSE,"No.") THEN BEGIN
           rCandidateEntry.RESET;
           rCandidateEntry.SETRANGE("Candidate No.","No.");
           IF rCandidateEntry.FIND('-') THEN
              ERROR(Text0005);
        
        
           rUsersFamilyCandidate.RESET;
           rUsersFamilyCandidate.SETRANGE("Candidate Code No.","No.");
           rUsersFamilyCandidate.DELETEALL;
        END;
        */

    end;

    trigger OnInsert()
    begin
        //PT não precisa de If

        rEduConfiguration.Get;
        rEduConfiguration.TestField("Candidate Nos.");
        //NoSeriesMgt.InitSeries(rEduConfiguration."Candidate Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        //TODO: to test NoSeries
        if CU_NoSeries.AreRelated(rEduConfiguration."Users Family Nos.", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := CU_NoSeries.GetNextNo("No. Series");
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

        InsertUsersCanidate;


        "Country/Region Code" := cStudentsRegistration.GetCountry;

        "User ID" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin
        rUsersFamilyCandidate.Reset;
        rUsersFamilyCandidate.SetFilter(Kinship, '%1|%2', rUsersFamilyCandidate.Kinship::"Brother in School",
                                        rUsersFamilyCandidate.Kinship::Himself);
        rUsersFamilyCandidate.SetRange("No.", "No.");
        rUsersFamilyCandidate.ModifyAll(Name, Name);
        rUsersFamilyCandidate.ModifyAll("Last Name", "Last Name");
        rUsersFamilyCandidate.ModifyAll("Last Name 2", "Last Name 2");
        rUsersFamilyCandidate.ModifyAll(Address, Address + ' ' + "Address 2" + ' ' + "Post Code" + ' ' + Location);
        rUsersFamilyCandidate.ModifyAll("Phone No.", "Phone No.");
        rUsersFamilyCandidate.ModifyAll("Mobile Phone", "Mobile Phone");


        ValidateCandidateAddress;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        rUsersFamilyCandidate: Record "Users Family / Candidate";
        Text0001: Label 'Are You Sure to Delete the Candidate?';
        rCandidate: Record Candidate;
        Text0002: Label 'There already is a Candidate %1 with the same Document ID.';
        Text0003: Label 'There already is a Candidate %1 with the same Name.';
        rTableMSI: Record "Table MISI";
        rAttachedDocuments: Record "Attached Documents";
        rAttachedDocuments2: Record "Attached Documents";
        varName: Text[250];
        varTotalNames: Integer;
        VarName3: Text[250];
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        rFregConDistCodes: Record "Legal Codes";
        rCandidateEntry: Record "Candidate Entry";
        Text0005: Label 'Cannot delete the Candidate.';
        Text001: Label 'The e-mail address "%1" is invalid.';
        cStudentsRegistration: Codeunit "Students Registration";
        Text0006: Label 'The Candidate doesn''t have a Paying Entity.';
        UpdateCand: Codeunit "Validate User ID";
        CU_NoSeries: Codeunit "No. Series";


    procedure AssistEdit(OldCandidate: Record Candidate): Boolean
    var
        Candidate: Record Candidate;
    begin
        Candidate := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Candidate Nos.");
        //if NoSeriesMgt.SelectSeries(rEduConfiguration."Candidate Nos.", OldCandidate."No. Series", "No. Series") then begin
        //NoSeriesMgt.SetSeries("No.");
        if CU_NoSeries.LookupRelatedNoSeries(OldCandidate."No. Series", rEduConfiguration."Candidate Nos.", "No. Series") then begin
            CU_NoSeries.GetNextNo("No.");
            //TODO: to test NoSeries
            Rec := Candidate;
            exit(true);
        end;
    end;


    procedure UpdateProfile()
    begin
        rUsersFamilyCandidate.Reset;
        rUsersFamilyCandidate.SetRange(Kinship, rUsersFamilyCandidate.Kinship::Himself);
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


    procedure CreateStudent(var pCandidate: Record Candidate; var pCandidateEntry: Record "Candidate Entry")
    var
        rStudent: Record Students;
        rUsersFamilyCandidate: Record "Users Family / Candidate";
        rUsersFamilyStudents: Record "Users Family / Students";
        rRegistration: Record Registration;
        rStructureEducationCountry: Record "Structure Education Country";
    begin
        if pCandidate."Student No." = '' then begin
            rStudent.Init;
            pCandidate.CalcFields(Picture);
            rStudent.TransferFields(pCandidate);
            rStudent."No." := '';
            rStudent."No. Series" := '';
            rStudent."Customer No." := pCandidate."Customer No.";
            rStudent.Insert(true);
            rStudent.UpdateProfile;
            rStudent.UpdateFullName;
            rStudent."Responsibility Center" := pCandidate."Responsibility Center";
            rStudent.Modify;
            pCandidate."Student No." := rStudent."No.";
            pCandidate.Modify;
            UpdateCustomerStudent(rStudent."No.");
        end
        else
            rStudent.Get(pCandidate."Student No.");

        rRegistration.Init;
        rRegistration."Student Code No." := rStudent."No.";
        rRegistration."School Year" := pCandidateEntry."School Year";
        //rRegistration."Schooling Year" := pCandidateEntry."Schooling Year";
        rRegistration.Validate("Schooling Year", pCandidateEntry."Schooling Year");
        rRegistration.Level := pCandidateEntry.Level;
        if rStructureEducationCountry.Get(pCandidateEntry."Country/Region Code", pCandidateEntry.Level, pCandidateEntry."Schooling Year")
        then
            rRegistration.Type := rStructureEducationCountry.Type;
        rRegistration.Insert(true);

        rUsersFamilyCandidate.Reset;
        rUsersFamilyCandidate.SetRange("Candidate Code No.", pCandidate."No.");
        if rUsersFamilyCandidate.FindSet(false, false) then
            repeat
                if rUsersFamilyCandidate.Kinship <> rUsersFamilyCandidate.Kinship::Himself then begin
                    rUsersFamilyStudents.Init;
                    rUsersFamilyStudents.TransferFields(rUsersFamilyCandidate);
                    rUsersFamilyStudents."Student Code No." := rStudent."No.";
                    rUsersFamilyStudents."School Year" := pCandidateEntry."School Year";
                    rUsersFamilyStudents.Insert(true);
                end;
                if rUsersFamilyCandidate.Kinship = rUsersFamilyCandidate.Kinship::Himself then begin
                    rUsersFamilyStudents.Reset;
                    rUsersFamilyStudents.SetRange(Kinship, rUsersFamilyStudents.Kinship::Himself);
                    rUsersFamilyStudents.SetRange("Student Code No.", rStudent."No.");
                    if rUsersFamilyStudents.Find('-') then begin
                        rUsersFamilyStudents."Education Head" := rUsersFamilyCandidate."Education Head";
                        rUsersFamilyStudents."Paying Entity" := rUsersFamilyCandidate."Paying Entity";
                        rUsersFamilyStudents.Modify(true);
                    end;
                    /*
                     rUsersFamilyStudentsMOD.INIT;
                     rUsersFamilyStudentsMOD.TRANSFERFIELDS(rUsersFamilyCandidate);
                     rUsersFamilyStudentsMOD."Student Code No." := rStudent."No.";
                     rUsersFamilyStudentsMOD."No." := rStudent."No.";
                     rUsersFamilyStudentsMOD."School Year" := pCandidateEntry."School Year";
                     rUsersFamilyStudentsMOD.INSERT(TRUE);

                     rUsersFamilyStudents.DELETE;
                     */

                end;
            until rUsersFamilyCandidate.Next = 0;

        rAttachedDocuments.Reset;
        rAttachedDocuments.SetRange(rAttachedDocuments.Table, rAttachedDocuments.Table::Candidate);
        rAttachedDocuments.SetRange(rAttachedDocuments."No.", "No.");
        if rAttachedDocuments.FindSet then begin
            repeat
                rAttachedDocuments.CalcFields(rAttachedDocuments.Attach);
                rAttachedDocuments2.Init;
                rAttachedDocuments2.TransferFields(rAttachedDocuments);
                rAttachedDocuments2.Table := rAttachedDocuments2.Table::Students;
                rAttachedDocuments2."No." := rStudent."No.";
                rAttachedDocuments2.Insert;
            until rAttachedDocuments.Next = 0;
        end;

    end;


    procedure InsertUsersCanidate()
    begin

        rUsersFamilyCandidate.Init;
        rUsersFamilyCandidate."Candidate Code No." := "No.";
        rUsersFamilyCandidate.Kinship := rUsersFamilyCandidate.Kinship::Himself;
        rUsersFamilyCandidate."No." := "No.";
        rUsersFamilyCandidate.Insert;
    end;


    procedure UpdateCustomer()
    var
        rCustomer: Record Customer;
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
    begin
        if "Customer No." <> '' then begin
            if rCustomer.Get("Customer No.") then begin
                rCustomer."Payment Method Code" := "Payment Method Code";
                rCustomer."Currency Code" := "Currency Code";
                rCustomer."Payment Terms Code" := "Payment Terms Code";
                rCustomer."Customer Disc. Group" := "Customer Disc. Group";
                rCustomer."Allow Line Disc." := "Allow Line Disc.";
                rCustomer."Customer Posting Group" := "Customer Posting Group";
                rCustomer."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                rCustomer."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                rCustomer.Modify;
            end;
        end;

        if "No." <> '' then begin
            rStudents.Reset;
            rStudents.SetRange("Customer No.", "No.");
            if rStudents.Find('-') then begin
                rStudents."Payment Method Code" := "Payment Method Code";
                rStudents."Currency Code" := "Currency Code";
                rStudents."Payment Terms Code" := "Payment Terms Code";
                rStudents."Customer Disc. Group" := "Customer Disc. Group";
                rStudents."Allow Line Disc." := "Allow Line Disc.";
                rStudents."Customer Posting Group" := "Customer Posting Group";
                rStudents."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                rStudents."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                rStudents.Modify;
            end;
        end;

        if "No." <> '' then begin
            rUsersFamily.Reset;
            rUsersFamily.SetRange("Customer No.", "No.");
            if rUsersFamily.Find('-') then begin
                rUsersFamily."Payment Method Code" := "Payment Method Code";
                rUsersFamily."Currency Code" := "Currency Code";
                rUsersFamily."Payment Terms Code" := "Payment Terms Code";
                rUsersFamily."Customer Disc. Group" := "Customer Disc. Group";
                rUsersFamily."Allow Line Disc." := "Allow Line Disc.";
                rUsersFamily."Customer Posting Group" := "Customer Posting Group";
                rUsersFamily."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                rUsersFamily."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                rUsersFamily.Modify;
            end;
        end;


        if "No." <> '' then begin
            rCandidate.Reset;
            rCandidate.SetRange("Customer No.", "No.");
            if rStudents.Find('-') then begin
                rStudents."Payment Method Code" := "Payment Method Code";
                rStudents."Currency Code" := "Currency Code";
                rStudents."Payment Terms Code" := "Payment Terms Code";
                rStudents."Customer Disc. Group" := "Customer Disc. Group";
                rStudents."Allow Line Disc." := "Allow Line Disc.";
                rStudents."Customer Posting Group" := "Customer Posting Group";
                rStudents."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                rStudents."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                rStudents.Modify;
            end;
        end;
    end;


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


    procedure ValidateCandidateAddress()
    var
        l_Candidate: Record Candidate;
        l_UsersFamilyCandidate: Record "Users Family / Candidate";
    begin

        l_UsersFamilyCandidate.Reset;
        l_UsersFamilyCandidate.SetRange(Kinship, l_UsersFamilyCandidate.Kinship::"Brother in School");
        l_UsersFamilyCandidate.SetRange("No.", "No.");
        l_UsersFamilyCandidate.SetRange("User Family Address", true);
        if l_UsersFamilyCandidate.Find('-') then begin
            repeat
                if l_Candidate.Get(l_UsersFamilyCandidate."Candidate Code No.") then
                    l_Candidate.Address := Address;
                l_Candidate."Address 2" := "Address 2";
                l_Candidate."Post Code" := "Post Code";
                l_Candidate.Location := Location;
                l_Candidate."Phone No." := "Phone No.";
                l_Candidate.Modify(true);
            until l_UsersFamilyCandidate.Next = 0;
        end;
    end;


    procedure ValidateName()
    begin
        rCandidate.Reset;
        if Name <> '' then
            rCandidate.SetRange(Name, Name)
        else
            rCandidate.SetRange(Name, '');
        if "Last Name" <> '' then
            rCandidate.SetRange("Last Name", "Last Name")
        else
            rCandidate.SetRange("Last Name", '');
        if "Last Name 2" <> '' then
            rCandidate.SetRange("Last Name 2", "Last Name 2")
        else
            rCandidate.SetRange("Last Name 2", '');
        rCandidate.SetFilter("Responsibility Center", "Responsibility Center");
        rCandidate.SetFilter("No.", '<>%1', "No.");
        if rCandidate.FindFirst then
            Message(Text0003, rCandidate."No.");
    end;


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


    procedure InvoicingServices() Invoice: Code[20]
    var
        l_rUsersFamilyCand: Record "Users Family / Candidate";
        l_rUsersFamily: Record "Users Family";
        l_rCustomer: Record Customer;
        l_rSalesRecSetup: Record "Sales & Receivables Setup";
        l_rSalesHeader: Record "Sales Header";
        l_rSalesLine: Record "Sales Line";
        l_rEduConfig: Record "Edu. Configuration";
        l_rServices: Record "Services ET";
        l_rCandidate: Record Candidate;
        l_rStudent: Record Students;
        //NoSeriesManagement: Codeunit NoSeriesManagement;
        vCustomer: Code[20];
    begin
        //Faturar a reserva vaga
        TestField("Payment Method Code");
        TestField("Payment Terms Code");
        TestField("Customer Posting Group");
        TestField("Gen. Bus. Posting Group");
        TestField("VAT Bus. Posting Group");

        l_rUsersFamilyCand.Reset;
        l_rUsersFamilyCand.SetRange(l_rUsersFamilyCand."Candidate Code No.", "No.");
        l_rUsersFamilyCand.SetRange(l_rUsersFamilyCand."Paying Entity", true);
        if l_rUsersFamilyCand.FindFirst then begin
            if l_rUsersFamilyCand.Kinship = l_rUsersFamilyCand.Kinship::Himself then begin
                if l_rCandidate.Get(l_rUsersFamilyCand."No.") then
                    vCustomer := l_rCandidate."Customer No.";
            end else begin
                if l_rUsersFamilyCand.Kinship = l_rUsersFamilyCand.Kinship::"Brother in School" then begin
                    if l_rStudent.Get(l_rUsersFamilyCand."No.") then
                        vCustomer := l_rStudent."Customer No.";
                end else begin
                    if l_rUsersFamily.Get(l_rUsersFamilyCand."No.") then
                        vCustomer := l_rUsersFamily."Customer No."
                end;
            end;

            if l_rCustomer.Get(vCustomer) then begin
                l_rCustomer.TestField("Payment Method Code");
                l_rCustomer.TestField("Payment Terms Code");
                l_rCustomer.TestField("Customer Posting Group");
                l_rCustomer.TestField("Gen. Bus. Posting Group");
                l_rCustomer.TestField("VAT Bus. Posting Group");
            end;

        end else
            Error(Text0006);



        // --- Nota:
        // Os serviços iram ser Vendidos ao Aluno e facturdos a(s) entidade(s) Pagadora(s)

        Clear(l_rSalesRecSetup);
        Clear(l_rSalesHeader);
        l_rSalesRecSetup.Reset;
        l_rSalesHeader.Reset;

        Clear(CU_NoSeries);

        if l_rSalesRecSetup.Get then;
        if l_rEduConfig.Get then
            l_rEduConfig.TestField(l_rEduConfig."Placement Reser. Service Cod.");


        l_rSalesHeader.Init;
        l_rSalesHeader.SetHideValidationDialog(true);
        //l_rSalesHeader."No." := NoSeriesManagement.GetNextNo(l_rSalesRecSetup."Invoice Nos.", WorkDate, true);
        //TODO: to test
        l_rSalesHeader."No." := CU_NoSeries.GetNextNo(l_rSalesRecSetup."Invoice Nos.", WorkDate, true);
        l_rSalesHeader."Document Type" := l_rSalesHeader."Document Type"::Invoice;
        l_rSalesHeader."Order Date" := WorkDate;
        l_rSalesHeader."Posting Date" := WorkDate;
        l_rSalesHeader."Document Date" := WorkDate;
        l_rSalesHeader."No. Series" := l_rSalesRecSetup."Invoice Nos.";
        l_rSalesHeader."Posting No. Series" := l_rSalesRecSetup."Posted Invoice Nos.";
        l_rSalesHeader."Shipping No. Series" := l_rSalesRecSetup."Posted Shipment Nos.";
        if "Responsibility Center" <> '' then
            l_rSalesHeader.Validate("Responsibility Center", "Responsibility Center");
        l_rSalesHeader.Validate("Sell-to Customer No.", "Customer No.");
        l_rSalesHeader.Validate("Bill-to Customer No.", vCustomer);
        l_rSalesHeader."Process by Education" := true;
        //2013.02.04 - Normatica para preencher na 21 e na 17 para depois ir para o saft
        l_rSalesHeader."Posting Description" := 'Fatura ' + l_rSalesHeader."No.";
        l_rSalesHeader.Insert;


        Clear(l_rSalesLine);
        l_rSalesLine.Reset;

        l_rSalesLine.Init;
        l_rSalesLine."Document Type" := l_rSalesLine."Document Type"::Invoice;
        l_rSalesLine.Type := l_rSalesLine.Type::Service;
        l_rSalesLine."Document No." := l_rSalesHeader."No.";
        l_rSalesLine."Line No." := 10000;

        l_rSalesLine.Validate("No.", l_rEduConfig."Placement Reser. Service Cod.");
        //l_rSalesLine.Description := "Student Ledger Entry".Description;
        //l_rSalesLine."Description 2" := "Student Ledger Entry"."Description 2";
        l_rSalesLine.Validate("Sell-to Customer No.", "Customer No.");
        l_rSalesLine.Validate("Bill-to Customer No.", vCustomer);
        l_rSalesLine.Validate(Quantity, 1);

        if l_rServices.Get(l_rEduConfig."Placement Reser. Service Cod.") then;
        l_rSalesLine.Validate("Unit Price", l_rServices."Unit Price");
        l_rSalesLine.Validate("Line Amount", l_rServices."Unit Price");
        l_rSalesLine.Validate(Amount, l_rServices."Unit Price");
        //l_rSalesLine.VALIDATE("VAT Base Amount", ROUND("Student Ledger Entry"."VAT Base Amount"
        //            * "Student Ledger Entry"."Percent %" / 100,0.01));
        //l_rSalesLine.VALIDATE("VAT %", "Student Ledger Entry"."VAT %");
        l_rSalesLine."Responsibility Center" := "Responsibility Center";
        l_rSalesLine.Insert;

        exit(l_rSalesHeader."No.");
    end;


    procedure UpdateCustomerStudent(varStudentNo: Code[20])
    var
        rCustomer: Record Customer;
        l_student: Record Students;
    begin
        if "Customer No." <> '' then begin
            if rCustomer.Get("Customer No.") then begin
                if l_student.Get(varStudentNo) then begin
                    rCustomer."Payment Method Code" := l_student."Payment Method Code";
                    rCustomer."Currency Code" := l_student."Currency Code";
                    rCustomer."Payment Terms Code" := l_student."Payment Terms Code";
                    rCustomer."Customer Disc. Group" := l_student."Customer Disc. Group";
                    rCustomer."Allow Line Disc." := l_student."Allow Line Disc.";
                    rCustomer."Customer Posting Group" := l_student."Customer Posting Group";
                    rCustomer."Gen. Bus. Posting Group" := l_student."Gen. Bus. Posting Group";
                    rCustomer."VAT Bus. Posting Group" := l_student."VAT Bus. Posting Group";
                    rCustomer."Student No." := l_student."No.";
                    rCustomer.Modify;
                end;
            end;
        end;
    end;

    /* 
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
        
        CommonDialogControl.InitDir := DefaultFileName;
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
}

