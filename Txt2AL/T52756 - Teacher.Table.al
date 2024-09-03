table 52756 Teacher
{
    Caption = 'Teacher';
    DrillDownPageID = "Teacher List";
    LookupPageID = "Teacher List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    rEduConfiguration.Get;
                    NoSeriesMgt.TestManual(rEduConfiguration."Teacher Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[128])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                ValidateName;
            end;
        }
        field(3; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(4; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
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
        }
        field(14; "Mobile Prefix"; Text[6])
        {
            Caption = 'Mobile Prefix';
        }
        field(15; "Mobile Phone"; Text[14])
        {
            Caption = 'Mobile Phone';
        }
        field(16; "E-mail"; Text[64])
        {
            Caption = 'E-Mail';

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
            TableRelation = "Table MISI".Code WHERE(Type = FILTER(Naturalidade));

            trigger OnValidate()
            begin
                if rTableMSI.Get(rTableMSI.Type::Naturalidade, "Naturalness Code") then
                    "Birth Place" := rTableMSI.Description
                else
                    "Birth Place" := '';
            end;
        }
        field(18; "Birth Place"; Text[60])
        {
            Caption = 'Nationality';
            Editable = false;
        }
        field(19; "Nationality Code"; Code[10])
        {
            Caption = 'Citizenship Code';
            TableRelation = "Table MISI".Code WHERE(Type = CONST(Nacionalidade));

            trigger OnValidate()
            var
                rTableMSI: Record "Table MISI";
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
        field(21; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(22; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(23; "Doc. Type Id"; Option)
        {
            Caption = 'Doc. Type ID';
            OptionCaption = ' ,Identification Card,Child Identification Card,Passport,Residence Permit,Citizen Card';
            OptionMembers = " ",BI,"Cédula",Passporte,"Autorização de Residência","Cartão Cidadão";
        }
        field(24; "Doc. Number Id"; Text[32])
        {
            Caption = 'Doc. Number ID';

            trigger OnValidate()
            begin
                rTeacher.Reset;
                rTeacher.SetRange("Doc. Type Id", "Doc. Type Id");
                rTeacher.SetFilter("No.", '<>%1', "No.");
                if rTeacher.Find('-') then begin
                    repeat
                        if rTeacher."Doc. Number Id" = "Doc. Number Id" then
                            Message(Text0002, rTeacher."No.");
                    until rTeacher.Next = 0;
                end;
            end;
        }
        field(25; "Archive of Identification"; Text[30])
        {
            Caption = 'Identification Archive';
        }
        field(26; "Date Validity"; Date)
        {
            Caption = 'Expiration date';
        }
        field(27; "Date Issuance"; Date)
        {
            Caption = 'Date of issue';
        }
        field(28; "Responsibility Center"; Code[10])
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
        field(29; Sex; Option)
        {
            Caption = 'Sex';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(30; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(31; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::Teacher);
            end;
        }
        field(32; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionCaption = 'Single,Married,Divorced,Widow,Other';
            OptionMembers = Single,Married,Divorced,Widow,Other;
        }
        field(50; "NAV User Id"; Code[20])
        {
            Caption = 'NAV User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("NAV User Id");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Selection";
            begin
                LoginMgt.ValidateUserName("NAV User Id");
            end;
        }
        field(74; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Teacher),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(80; "Daily Equity Absences"; Integer)
        {
            Caption = 'Daily Equity Absences';
            Description = 'Qts tempos de falta correspondem a 1 dia de falta de um professor';
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
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';

            trigger OnValidate()
            begin
                ValidateName;
            end;
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';

            trigger OnValidate()
            begin
                ValidateName;
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
        field(73110; NISS; Code[20])
        {
            Caption = 'SSN';
        }
        field(73111; "Incidence Type"; Option)
        {
            Caption = 'Incidence Type';
            OptionCaption = ' ,Default,Absence,Both';
            OptionMembers = " ",Default,Absence,Both;
        }
        field(73112; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(73113; "Country/Region Code"; Code[10])
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
        recSubjectsGroup.Reset;
        recSubjectsGroup.SetCurrentKey(Type, Code, "Teacher No.");
        recSubjectsGroup.SetRange(Type, recSubjectsGroup.Type::Teacher);
        recSubjectsGroup.SetRange("Teacher No.", "No.");
        if recSubjectsGroup.FindFirst then
            Error(Text0005, "No.");


        recTeacherClass.Reset;
        recTeacherClass.SetRange(recTeacherClass."User Type", recTeacherClass."User Type"::Teacher);
        recTeacherClass.SetRange(User, "No.");
        if recTeacherClass.FindFirst then
            Error(Text0006, "No.");

        //Ligação a RH
        /*rEmpregado.RESET;
        rEmpregado.SETRANGE(rEmpregado."Nº Professor","No.");
        IF rEmpregado.FINDFIRST THEN BEGIN
          rEmpregado."Nº Professor" := '';
          rEmpregado.MODIFY;
        END;*/

    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Teacher Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Teacher Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            if rUserSetup.Get(UserId) then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
        end;

        "Country/Region Code" := cStudentsRegistration.GetCountry;
        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then begin
            rTeacherClass.Reset;
            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
            rTeacherClass.SetRange(rTeacherClass."School Year", rSchoolYear."School Year");
            rTeacherClass.SetFilter(rTeacherClass.User, "No.");
            rTeacherClass.ModifyAll(rTeacherClass."NAV User Id", "NAV User Id");
            rTeacherClass.ModifyAll(Name, Name);
            rTeacherClass.ModifyAll("Last Name", "Last Name");
            rTeacherClass.ModifyAll("Last Name 2", "Last Name 2");
            rTeacherClass.ModifyAll("Use GIC", "Use GIC");
            rTeacherClass.ModifyAll("Use WEB", "Use WEB");
            rTeacherClass.ModifyAll(Password, Password);
            rTeacherClass.ModifyAll("User Name", "User Name", true);

        end;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0012, TableName);*/
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        rTeacher: Record Teacher;
        Text0002: Label 'There already is a Users Family %1 with the same Document ID.';
        PostCode: Record "Post Code";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0003: Label 'There already is a Users Family %1 with the same name.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rFregConDistCodes: Record "Legal Codes";
        Text73100: Label 'The password must have more then 6 characters.';
        Text001: Label 'The e-mail address "%1" is invalid.';
        recSubjectsGroup: Record "Subjects Group";
        Text0005: Label 'You cannot delete the teacher %1 because he/she has associated departments.';
        recTeacherClass: Record "Teacher Class";
        rSchoolYear: Record "School Year";
        Text0006: Label 'You cannot delete the teacher %1 because he/she has associated subjects.';
        rTeacherClass: Record "Teacher Class";
        cStudentsRegistration: Codeunit "Students Registration";
        rTableMSI: Record "Table MISI";
        Text0012: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";

    //[Scope('OnPrem')]
    procedure AssistEdit(OldTeacher: Record Teacher): Boolean
    var
        Teacher: Record Teacher;
    begin
        //Teacher := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Teacher Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Teacher Nos.", OldTeacher."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            //  Rec := Teacher;
            exit(true);
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
    procedure ValidateName()
    begin
        rTeacher.Reset;
        if Name <> '' then
            rTeacher.SetRange(Name, Name)
        else
            rTeacher.SetRange(Name, '');
        if "Last Name" <> '' then
            rTeacher.SetRange("Last Name", "Last Name")
        else
            rTeacher.SetRange("Last Name", '');

        if "Last Name 2" <> '' then
            rTeacher.SetRange("Last Name 2", "Last Name 2")
        else
            rTeacher.SetRange("Last Name 2", '');

        rTeacher.SetFilter("No.", '<>%1', "No.");
        rTeacher.SetRange("Responsibility Center", "Responsibility Center");
        if rTeacher.FindFirst then
            Message(Text0003, rTeacher."No.");
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
}

