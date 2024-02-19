table 31009752 School
{
    Caption = 'School';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "School Code"; Integer)
        {
            Caption = 'School Code';
            Description = 'MISI';
        }
        field(3; "School Name"; Text[128])
        {
            Caption = 'School Name';
        }
        field(4; "School Guardianship Name"; Text[128])
        {
            Caption = 'School Guardianship Name';
        }
        field(5; "School Guardianship Code"; Integer)
        {
            Caption = 'School Guardianship Code';
        }
        field(6; "Parish/Council/District Code"; Code[10])
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
        field(7; Town; Text[100])
        {
            Caption = 'Town';
        }
        field(8; County; Text[100])
        {
            Caption = 'County';
        }
        field(9; District; Text[100])
        {
            Caption = 'District';
        }
        field(10; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(11; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(13; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
            end;
        }
        field(14; Location; Text[30])
        {
            Caption = 'Location';

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(Location, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(Location, "Post Code", County, "Country/Region Code", GuiAllowed);
            end;
        }
        field(15; Prefix; Text[6])
        {
            Caption = 'Prefix';
        }
        field(16; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';
        }
        field(17; "Prefix Fax"; Text[6])
        {
            Caption = 'Prefix Fax';
        }
        field(18; "Fax No."; Text[14])
        {
            Caption = 'Fax No.';
        }
        field(19; "E-mail"; Text[64])
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
        field(20; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(21; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", '', DATABASE::School);
            end;
        }
        field(22; NIB; Text[21])
        {
            Caption = 'Bank Account Number';
            Description = 'MISI';
        }
        field(23; "NIB ASE"; Text[21])
        {
            Caption = 'NIB ASE';
        }
        field(24; "Head of Services"; Text[50])
        {
            Caption = 'Head of Services';
        }
        field(25; "Head of Services Name"; Text[128])
        {
            Caption = 'Head of Services Name';
        }
        field(26; "Educational Director"; Text[50])
        {
            Caption = 'Educational Director';
        }
        field(27; "Educational Director Name"; Text[128])
        {
            Caption = 'Educational Director Name';
        }
        field(28; "Export Misi Responsible Name"; Text[128])
        {
            Caption = 'Export Misi Responsible Name';
            Description = 'MISI';
        }
        field(29; "Export Misi Responsible E-Mail"; Text[64])
        {
            Caption = 'Export Misi Responsible E-Mail';
            Description = 'MISI';

            trigger OnValidate()
            begin
                if "Export Misi Responsible E-Mail" = '' then
                    if xRec."Export Misi Responsible E-Mail" <> '' then
                        exit;

                CheckValidEmailAddress("Export Misi Responsible E-Mail");
            end;
        }
        field(30; "Export Misi Responsible Phone"; Text[9])
        {
            Caption = 'Export Misi Responsible Phone';
            Description = 'MISI';
        }
        field(31; "Export Misi Responsible Fax"; Text[9])
        {
            Caption = 'Export Misi Responsible Fax';
            Description = 'MISI';
        }
        field(32; "Guardianship Name 1"; Text[128])
        {
            Caption = 'Guardianship Name 1';
            Description = 'Duvida ENES';
        }
        field(33; "Guardianship Name 2"; Text[128])
        {
            Caption = 'Guardianship Name 2';
            Description = 'Duvida ENES';
        }
        field(34; "Guardianship Name 3"; Text[128])
        {
            Caption = 'Guardianship Name 3';
            Description = 'Duvida ENES';
        }
        field(35; "Logo School"; BLOB)
        {
            Caption = 'Logo School';
        }
        field(36; "Logo Guardianship"; BLOB)
        {
            Caption = 'Logo Guardianship';
        }
        field(38; NISS; Text[20])
        {
            Caption = 'SSN';
            Description = 'Numero identificaçao segurança social';
        }
        field(39; NCGA; Text[11])
        {
            Caption = 'NCGA';
        }
        field(40; "Autonomy Pedagogical"; Option)
        {
            Caption = 'Autonomy Pedagogical';
            Description = 'MISI';
            OptionCaption = 'Does not have Autonomy,1 year,3 years,5 years,Unlimited time';
            OptionMembers = "0","1","3","5",I;
        }
        field(41; "Parallel Pedagogical"; Option)
        {
            Caption = 'Parallel Pedagogical';
            Description = 'MISI';
            OptionCaption = 'Does not have Parallel,1 year,3 years,5 years,Unlimited time';
            OptionMembers = "0","1","3","5",I;
        }
        field(42; Contract1; Option)
        {
            Caption = 'Contract1';
            Description = 'MISI';
            OptionCaption = ' ,Association,Sponsorship,Simple,Development,Cooperation,Not Covered,Program (DRELVT)';
            OptionMembers = " ","1","2","3","4","5","6","7";
        }
        field(43; "Entity Guardianship - Type"; Option)
        {
            Caption = 'Entity Guardianship - Type';
            Description = 'MISI';
            OptionCaption = 'Single Entity,Collective Entity';
            OptionMembers = "1","2";
        }
        field(44; "Entity Guardianship - Desc."; Text[128])
        {
            Caption = 'Entity Guardianship - Desc.';
            Description = 'MISI';
        }
        field(45; "Entity Guardianship -Elements1"; Text[128])
        {
            Caption = 'Entity Guardianship - Elements1';
            Description = 'MISI';
        }
        field(46; "Date 1A Authorization Proof"; Date)
        {
            Caption = 'Date 1A Authorization Proof';
            Description = 'MISI';
        }
        field(47; "No. of Licence"; Code[32])
        {
            Caption = 'No. of License';
            Description = 'MISI';
        }
        field(48; "No. of Approval"; Text[32])
        {
            Caption = 'No. of Approval';
            Description = 'MISI';
        }
        field(49; "Authorized Capacity"; Integer)
        {
            Caption = 'Authorized Capacity';
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
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
        field(73110; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(75000; "Financial Year"; Text[4])
        {
            Caption = 'Financial Year';
            Description = 'MISI';
            Editable = false;
        }
        field(75001; "School Year"; Text[9])
        {
            Caption = 'School Year';
            Description = 'MISI';
            TableRelation = "School Year";

            trigger OnValidate()
            begin
                //2009.08.19 - Nova Versão

                if Moment = Moment::"1" then
                    "Financial Year" := CopyStr("School Year", 1, 4)
                else
                    "Financial Year" := CopyStr("School Year", 6, 4);
            end;
        }
        field(75002; Moment; Option)
        {
            Caption = 'Moment';
            Description = 'MISI';
            OptionCaption = ' ,Begin of School Year,End of Term 1,End of School Year';
            OptionMembers = " ","1","2","3";

            trigger OnValidate()
            begin
                //2009.08.19 - Nova Versão
                if Moment = 0 then Error(Text003);
                if Moment = Moment::"1" then
                    "Financial Year" := CopyStr("School Year", 1, 4)
                else
                    "Financial Year" := CopyStr("School Year", 6, 4);
            end;
        }
        field(75003; Type; Option)
        {
            Caption = 'Type';
            Description = 'MISI';
            OptionCaption = ' ,Staff and Students,Staff,Students';
            OptionMembers = " ","1","2","3";
        }
        field(75004; Contract2; Option)
        {
            Caption = 'Contract2';
            Description = 'MISI';
            OptionCaption = ' ,Association,Sponsorship,Simple,Development,Cooperation,Not Covered,Program (DRELVT)';
            OptionMembers = " ","1","2","3","4","5","6","7";
        }
        field(75005; Contract3; Option)
        {
            Caption = 'Contract3';
            Description = 'MISI';
            OptionCaption = ' ,Association,Sponsorship,Simple,Development,Cooperation,Not Covered,Program (DRELVT)';
            OptionMembers = " ","1","2","3","4","5","6","7";
        }
        field(75006; Contract4; Option)
        {
            Caption = 'Contract4';
            Description = 'MISI';
            OptionCaption = ' ,Association,Sponsorship,Simple,Development,Cooperation,Not Covered,Program (DRELVT)';
            OptionMembers = " ","1","2","3","4","5","6","7";
        }
        field(75007; "Entity Guardianship -Elements2"; Text[128])
        {
            Caption = 'Entity Guardianship - Elements2';
            Description = 'MISI';
        }
        field(75008; "Entity Guardianship -Elements3"; Text[128])
        {
            Caption = 'Entity Guardianship - Elements3';
            Description = 'MISI';
        }
        field(75009; "Entity Guardianship -Elements4"; Text[128])
        {
            Caption = 'Entity Guardianship - Elements4';
            Description = 'MISI';
        }
        field(75010; "Date of Licence"; Date)
        {
            Caption = 'Date of License';
            Description = 'MISI';
        }
        field(75011; "Date of Approval"; Date)
        {
            Caption = 'Date of Approval';
            Description = 'MISI';
        }
        field(75015; "Operating Expenses"; Integer)
        {
            Caption = 'Operating Expenses';
            Description = 'MISI';
            MaxValue = 50;
            MinValue = 35;
        }
        field(75019; Cantina; Option)
        {
            Caption = 'Cantina';
            Description = 'MISI';
            OptionCaption = 'Dont Have,Own,Concessioned';
            OptionMembers = "Não tem",Propria,Concessionada;
        }
        field(75023; "Cantina - Price per Meal"; Decimal)
        {
            Caption = 'Cantina - Price per Meal';
            Description = 'MISI';
        }
        field(75024; "Cantina - Num. of Meals"; Integer)
        {
            Caption = 'Cantina - Num. of Meals';
            Description = 'MISI';
        }
        field(75037; "Application Path WinRAR"; Text[250])
        {
            Caption = 'Application Path WinRAR';
            Description = 'MISI';

            trigger OnLookup()
            begin
                /*IF "Application Path WinRAR" = '' THEN
                  "Application Path WinRAR" := FileMgt.OpenFileDialog(Text002,'','*.exe')
                ELSE
                  "Application Path WinRAR" := FileMgt.OpenFileDialog(Text002,'','*.exe');*/

            end;
        }
        field(75038; "Application Version"; Text[30])
        {
            Caption = 'Application Version';
            Description = 'MISI';
            Editable = false;
        }
        field(75039; "Autonomy Pedagogical2"; Option)
        {
            Caption = 'Autonomy Pedagogical';
            Description = 'MISI';
            OptionCaption = 'Does not have Autonomy,1 year,3 years,5 years,Unlimited time';
            OptionMembers = "0","1","3","5",I;
        }
        field(75040; "Parallel Pedagogical2"; Option)
        {
            Caption = 'Parallel Pedagogical';
            Description = 'MISI';
            OptionCaption = 'Does not have Parallel,1 year,3 years,5 years,Unlimited time';
            OptionMembers = "0","1","3","5",I;
        }
        field(75041; "Education Level AP"; Option)
        {
            Caption = 'Education Level AP';
            Description = 'MISI';
            OptionCaption = 'Basic,Secundary';
            OptionMembers = "1","2";
        }
        field(75042; "Autonomy Date"; Date)
        {
            Caption = 'Autonomy Date';
            Description = 'MISI';
        }
        field(75043; "Education Level AP2"; Option)
        {
            Caption = 'Education Level AP';
            Description = 'MISI';
            OptionCaption = 'Basic,Secundary';
            OptionMembers = "1","2";
        }
        field(75044; "Autonomy Date2"; Date)
        {
            Caption = 'Autonomy Date';
            Description = 'MISI';
        }
        field(75045; "Education Level PP"; Option)
        {
            Caption = 'Education Level PP';
            Description = 'MISI';
            OptionCaption = 'Basic,Secundary';
            OptionMembers = "1","2";
        }
        field(75046; "Parallel Date"; Date)
        {
            Caption = 'Parallel Date';
            Description = 'MISI';
        }
        field(75047; "Education Level PP2"; Option)
        {
            Caption = 'Education Level PP';
            Description = 'MISI';
            OptionCaption = 'Basic,Secundary';
            OptionMembers = "1","2";
        }
        field(75048; "Parallel Date2"; Date)
        {
            Caption = 'Parallel Date';
            Description = 'MISI';
        }
        field(75049; "Basic Covered Classes"; Integer)
        {
            Caption = 'Basic - Covered Classes';
            Description = 'MISI';
        }
        field(75050; "Secundary Covered Classes"; Integer)
        {
            Caption = 'Secondary - Covered Classes';
            Description = 'MISI';
        }
        field(75051; "Recurrent Covered Classes"; Integer)
        {
            Caption = 'Recurrent - Covered Classes';
            Description = 'MISI';
        }
        field(75052; "Cantina-Num of Meals Echelon A"; Integer)
        {
            Caption = 'Cantina - Num. of Meals Echelon A';
            Description = 'MISI';
        }
        field(75053; "Cantina-Num of Meals Echelon B"; Integer)
        {
            Caption = 'Cantina - Num. of Meals Echelon B';
            Description = 'MISI';
        }
        field(75500; "ENES Export Path"; Text[100])
        {
            Caption = 'ENES Export Path';
            Description = 'ENES';

            trigger OnLookup()
            begin

                //"ENES Export Path" := cApplicationMng.SaveDirectoryPath;
            end;
        }
        field(75501; "ENES Import Path"; Text[100])
        {
            Caption = 'ENES Import Path';
            Description = 'ENES';

            trigger OnLookup()
            begin

                //"ENES Import Path" := cApplicationMng.SaveDirectoryPath;
            end;
        }
        field(75502; "ENES Exam Schooling Year1"; Code[10])
        {
            Caption = 'ENES Exam Schooling Year';
            Description = 'ENES';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"),
                                                                                  Type = FILTER(Multi));
        }
        field(75503; "ENES Exam Schooling Year2"; Code[10])
        {
            Caption = 'ENES Exam Schooling Year';
            Description = 'ENES';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"),
                                                                                  Type = FILTER(Multi));
        }
        field(75504; "ENES Exam Schooling Year3"; Code[10])
        {
            Caption = 'ENES Exam Schooling Year';
            Description = 'ENES';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"),
                                                                                  Type = FILTER(Multi));
        }
        field(75600; "ENEB Export Path"; Text[100])
        {
            Caption = 'ENEB Export Path';
            Description = 'ENEB';

            trigger OnLookup()
            begin

                //"ENEB Export Path" := cApplicationMng.SaveDirectoryPath;
            end;
        }
        field(75601; "ENEB Import Path"; Text[100])
        {
            Caption = 'ENEB Import Path';
            Description = 'ENEB';

            trigger OnLookup()
            begin

                //"ENEB Import Path" := cApplicationMng.SaveDirectoryPath;
            end;
        }
        field(75602; "ENEB Exam Schooling Year"; Code[10])
        {
            Caption = 'ENEB Exam Schooling Year';
            Description = 'ENEB';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"),
                                                                                  Type = FILTER(Simple));
        }
        field(75603; "ENEB Student Type"; Code[10])
        {
            Caption = 'ENEB Student Type';
            Description = 'ENEB';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = CONST(StudentType),
                                                                                "Legal Code Type" = CONST(Simple));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'The email address "%1" is invalid.';
        PostCode: Record "Post Code";
        rFregConDistCodes: Record "Legal Codes";
        Text002: Label 'WinRar';
        Text003: Label 'Select a moment.';
        FileMgt: Codeunit "File Management";

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
}

