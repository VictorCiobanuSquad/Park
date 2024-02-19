table 31009754 "Users Family / Students"
{
    /*
    #001 - SQD.HSOARES - Ticket#NAV202200456 - 06/09/2022
        Permission to add or remove more than one education head;
    */
    /*
#002 - SQD.GCUI  27/03/2023
    Permission to add or remove more than one education head;
*/

    Caption = 'Users Family / Students';

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(2; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(3; Kinship; Option)
        {
            Caption = 'Kinship';
            OptionCaption = ' ,Father,Mother,GrandFather,GrandMother,Brother,Sister,Brother in School,Uncle,Aunt,Himself,Tutor,Other';
            OptionMembers = " ",Father,Mother,GrandFather,GrandMother,Brother,Sister,"Brother in School",Uncle,Aunt,Himself,Tutor,Other;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Kinship = CONST("Brother in School")) Students
            ELSE
            IF (Kinship = CONST(Himself)) Students WHERE("No." = FIELD("Student Code No."))
            ELSE
            IF (Kinship = CONST(Father)) "Users Family"
            ELSE
            IF (Kinship = CONST(Mother)) "Users Family"
            ELSE
            IF (Kinship = CONST(GrandFather)) "Users Family"
            ELSE
            IF (Kinship = CONST(GrandMother)) "Users Family"
            ELSE
            IF (Kinship = CONST(Brother)) "Users Family"
            ELSE
            IF (Kinship = CONST(Sister)) "Users Family"
            ELSE
            IF (Kinship = CONST(Uncle)) "Users Family"
            ELSE
            IF (Kinship = CONST(Aunt)) "Users Family"
            ELSE
            IF (Kinship = CONST(Tutor)) "Users Family"
            ELSE
            IF (Kinship = CONST(Other)) "Users Family";

            trigger OnLookup()
            var
                l_Students: Record Students;
            begin
                if rStudents.Get("Student Code No.") then begin
                    if (Kinship = Kinship::Himself) or (Kinship = Kinship::"Brother in School") then begin
                        l_Students.Reset;
                        l_Students.SetFilter("Responsibility Center", rStudents."Responsibility Center");
                        if Kinship = Kinship::"Brother in School" then
                            l_Students.SetFilter("No.", '<>%1', "Student Code No.");
                        if Kinship = Kinship::Himself then
                            l_Students.SetRange("No.", "Student Code No.");

                        if PAGE.RunModal(PAGE::"Students List", l_Students) = ACTION::LookupOK then
                            Validate("No.", l_Students."No.");
                    end else begin
                        rUsersFamily.Reset;
                        rUsersFamily.SetFilter("Responsibility Center", rStudents."Responsibility Center");
                        if "No." <> '' then begin
                            rUsersFamily.SetRange("No.", "No.");
                        end;

                        if PAGE.RunModal(PAGE::"Users Family List", rUsersFamily) = ACTION::LookupOK then
                            Validate("No.", rUsersFamily."No.");
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if (Kinship = Kinship::Himself) then
                    if "Student Code No." <> "No." then
                        Error(Text002);

                if (Kinship = Kinship::"Brother in School") then
                    if "Student Code No." = "No." then
                        Error(Text008);

                //IT - 2016.09.14 - como usam a importação de dados do site
                //não posso deixar aparecer esta mensagem
                /*
                rUsersFamilyStudents.RESET;
                rUsersFamilyStudents.SETRANGE("Student Code No.","Student Code No.");
                rUsersFamilyStudents.SETRANGE("School Year","School Year");
                rUsersFamilyStudents.SETRANGE("No.","No.");
                rUsersFamilyStudents.SETFILTER(Kinship,'<>%1',rUsersFamilyStudents.Kinship::Himself);
                IF rUsersFamilyStudents.FINDFIRST THEN BEGIN
                  IF NOT CONFIRM(Text006,FALSE,"No.") THEN
                    ERROR(Text007);
                END;
                */


                if (Kinship = Kinship::Himself) or (Kinship = Kinship::"Brother in School") then begin
                    if rStudents.Get("No.") then begin
                        Name := rStudents.Name;
                        "Last Name 2" := rStudents."Last Name 2";
                        "Last Name" := rStudents."Last Name";
                        Address := rStudents.Address + ' ' + rStudents."Address 2" + ' ' + Format(rStudents."Post Code") + ' ' +
                                          rStudents.Location;
                        "Phone No." := rStudents."Phone No.";
                        "Mobile Phone" := rStudents."Mobile Phone";
                        "Use GIC" := rStudents."Use GIC";
                        "Use WEB" := rStudents."Use WEB";
                        "User Name" := rStudents."User Name";
                        Password := rStudents.Password;
                    end;
                end else begin
                    if rUsersFamily.Get("No.") then begin
                        Name := rUsersFamily.Name;
                        "Last Name 2" := rUsersFamily."Last Name 2";
                        "Last Name" := rUsersFamily."Last Name";
                        Address := rUsersFamily.Address + ' ' + rUsersFamily."Address 2" + ' ' +
                                          Format(rUsersFamily."Post Code") + ' ' + rUsersFamily.Location;
                        "Phone No." := rUsersFamily."Phone No.";
                        "Mobile Phone" := rUsersFamily."Mobile Phone";
                        "Phone No. 2" := rUsersFamily."Phone No. 2";
                        "E-mail" := rUsersFamily."E-mail";
                        "Use GIC" := rUsersFamily."Use GIC";
                        "Use WEB" := rUsersFamily."Use WEB";
                        "User Name" := rUsersFamily."User Name";
                        Password := rUsersFamily.Password;
                    end;
                end;

                if "No." = '' then begin
                    Name := '';
                    "Last Name 2" := '';
                    "Last Name" := '';
                    Address := '';
                    "Phone No." := '';
                    "Mobile Phone" := '';
                    "Phone No. 2" := '';
                    "E-mail" := '';
                    Password := '';
                    "User Name" := '';
                end;

            end;
        }
        field(5; Name; Text[128])
        {
            Caption = 'Name';
        }
        field(6; Address; Text[180])
        {
            Caption = 'Address';
        }
        field(7; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';
        }
        field(8; "Mobile Phone"; Text[14])
        {
            Caption = 'Mobile Phone';
        }
        field(9; "Education Head"; Boolean)
        {
            Caption = 'Education Head';

            trigger OnValidate()
            begin
                /*
                rUsersFamilyStudents.Reset;
                rUsersFamilyStudents.SetRange("School Year", "School Year");
                rUsersFamilyStudents.SetRange("Student Code No.", "Student Code No.");
                rUsersFamilyStudents.SetRange("Education Head", true);
                rUsersFamilyStudents.SetFilter("No.", '<>%1', "No.");
                if rUsersFamilyStudents.FindFirst then
                    Error(Text001);
                */
            end;
        }
        field(10; "Paying Entity"; Boolean)
        {
            Caption = 'Paying Entity';

            trigger OnValidate()
            begin

                if "Paying Entity" then
                    cStudentServices.CustomerCreate(Rec);
            end;
        }
        field(15; "Phone No. 2"; Text[14])
        {
            Caption = 'Phone No. 2';
        }
        field(16; "E-mail"; Text[64])
        {
            Caption = 'E-mail';

            trigger OnValidate()
            begin
                if "E-mail" = '' then
                    if xRec."E-mail" <> '' then
                        exit;

                //CheckValidEmailAddress("E-mail");
            end;
        }
        field(17; "Remaining Amount"; Decimal)
        {
            CalcFormula = Sum("Student Ledger Entry"."Remaining Amount" WHERE("Entity ID" = FIELD("No."),
                                                                               "Remaining Amount" = FILTER(> 0)));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
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
        field(50000; "Send By Email"; Boolean)
        {
            Caption = 'Send By Email';
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';
        }
        field(73103; "User Name"; Text[30])
        {
            Caption = 'User Name';
            Description = 'WEB';
        }
        field(73104; Password; Text[30])
        {
            Caption = 'Password';
            Description = 'WEB';
        }
        field(73105; Language; Option)
        {
            Caption = 'Language';
            Description = 'WEB';
            InitValue = Castilian;
            OptionCaption = ' ,Castilian,English,Euskara,Galego,Deutsch,Français,Italian,Portuguese,Catalan';
            OptionMembers = " ",Castilian,English,Euskara,Galego,Deutsch,"Français",Italian,Portuguese,Catalan;
        }
        field(73106; "Use GIC"; Boolean)
        {
            Caption = 'Use GIC';
            Description = 'WEB';
        }
        field(73107; "Use WEB"; Boolean)
        {
            Caption = 'Use WEB';
            Description = 'WEB';
        }
        field(73108; "User Family Address"; Boolean)
        {
            Caption = 'User Family Address';

            trigger OnValidate()
            var
                l_Students: Record Students;
            begin
                rUsersFamilyStudents.Reset;
                rUsersFamilyStudents.SetRange("School Year", "School Year");
                rUsersFamilyStudents.SetRange("Student Code No.", "Student Code No.");
                rUsersFamilyStudents.SetRange("User Family Address", true);
                rUsersFamilyStudents.SetFilter("No.", '<>%1', "No.");
                if rUsersFamilyStudents.FindFirst then
                    Error(Text003);

                if Kinship = Kinship::Himself then
                    Error(Text004);
                if "User Family Address" then begin
                    if Confirm(Text005, true) then begin
                        if (Kinship = Kinship::"Brother in School") then begin
                            if rStudents.Get("No.") then begin
                                if l_Students.Get("Student Code No.") then;
                                l_Students.Address := rStudents.Address;
                                l_Students."Address 2" := rStudents."Address 2";
                                l_Students."Post Code" := rStudents."Post Code";
                                l_Students.Location := rStudents.Location;
                                l_Students.Validate(l_Students."Parish/Council/District Code", rStudents."Parish/Council/District Code");
                                l_Students.County := rStudents.County;
                                l_Students."Phone No." := rStudents."Phone No.";
                                l_Students.Modify(true);
                            end;
                        end else begin
                            if rUsersFamily.Get("No.") then begin
                                if l_Students.Get("Student Code No.") then;
                                l_Students.Address := rUsersFamily.Address;
                                l_Students."Address 2" := rUsersFamily."Address 2";
                                l_Students."Post Code" := rUsersFamily."Post Code";
                                l_Students.Location := rUsersFamily.Location;
                                l_Students.Validate(l_Students."Parish/Council/District Code", rUsersFamily."Parish/Council/District Code");
                                l_Students.County := rUsersFamily.County;
                                l_Students."Phone No." := rUsersFamily."Phone No.";
                                l_Students.Modify(true);
                            end;
                        end;
                    end else
                        "User Family Address" := false;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "School Year", "Student Code No.", Kinship, "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
        }
        key(Key3; "School Year", "Student Code No.", "Paying Entity")
        {
            // Unique = true;
        }
        key(Key4; "School Year", "Last Name", "Student Code No.", Kinship)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cMasterTableWEB.DeleteEntityUsersFamily(2, Rec, xRec);
        cMasterTableWEB.DeleteEntityStudent(Rec, xRec);
    end;

    trigger OnInsert()
    var
        lStudents: Record Students;
        lUsersFamily: Record "Users Family";
        lName: Text[1024];
    begin

        if "Last Name 2" <> '' then
            lName := "Last Name" + ' ' + "Last Name 2" + ', ' + Name
        else
            lName := "Last Name" + ', ' + Name;

        if (Kinship = Kinship::Himself) or (Kinship = Kinship::"Brother in School") then begin
            if "Use WEB" then begin
                lStudents.Get("No.");
                cMasterTableWEB.InsertEntity(2, "No.", lName, "User Name",
                Password, lStudents."Responsibility Center", Language);
            end;
        end
        else begin
            if "Use WEB" then begin
                lUsersFamily.Get("No.");
                cMasterTableWEB.InsertEntity(2, "No.", lName, "User Name",
                Password, lUsersFamily."Responsibility Center", Language);
            end;
        end;


        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin
        cMasterTableWEB.ModifyEntityUsersFamily(2, Rec, xRec);
        cMasterTableWEB.ModifyEntityStudent(Rec, xRec);

        if not "Use WEB" and xRec."Use WEB" then
            cMasterTableWEB.DeleteEntityUsersFamily(2, Rec, xRec);
    end;

    var
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        rUsersFamilyStudents: Record "Users Family / Students";
        Text001: Label 'There is already a responsibility of education to the students selected.';
        cStudentServices: Codeunit "Student Services";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        Text002: Label 'The No. should be the same of the student.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text003: Label 'There is already a user address for the students selected.';
        Text004: Label 'Not allowed.';
        Text005: Label 'Do you wish to update the address for the student?';
        Text006: Label 'There is already a user with the No %1. Do you wish to continue?';
        Text007: Label 'Operation cancelled by the user.';
        Text008: Label 'The user cannot select as a brother the same student.';
}

