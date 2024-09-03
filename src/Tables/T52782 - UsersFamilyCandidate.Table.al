table 52782 "Users Family / Candidate"
{
    Caption = 'Users Family / Candidate';

    fields
    {
        field(2; "Candidate Code No."; Code[20])
        {
            Caption = 'Candidate Code No.';
            TableRelation = Candidate."No.";
        }
        field(3; Kinship; Option)
        {
            Caption = 'Kinship';
            OptionCaption = ' ,Father,Mother,GrandFather,GrandMother,Brother,Sister,Brother in School,Uncle,Aunt,Himself,Tutor,Other';
            OptionMembers = " ",Father,Mother,GrandFather,GrandMother,Brother,Sister,"Brother in School",Uncle,Aunt,Himself,Tutor,Other;

            trigger OnValidate()
            begin
                if Kinship <> xRec.Kinship then begin
                    "No." := '';
                    Name := '';
                    Address := '';
                    "Phone No." := '';
                    "Mobile Phone" := '';
                end;
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Kinship = CONST("Brother in School")) Students."No."
            ELSE
            IF (Kinship = CONST(Himself)) Candidate."No." WHERE("No." = FIELD("Candidate Code No."))
            ELSE
            IF (Kinship = CONST(Father)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Mother)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(GrandFather)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(GrandMother)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Brother)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Sister)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Uncle)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Aunt)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Tutor)) "Users Family"."No."
            ELSE
            IF (Kinship = CONST(Other)) "Users Family"."No.";

            trigger OnLookup()
            var
                l_Candidate: Record Candidate;
            begin
                if rCandidate.Get("Candidate Code No.") then begin
                    if (Kinship = Kinship::Himself) or (Kinship = Kinship::"Brother in School") then begin
                        if (Kinship = Kinship::Himself) then begin
                            l_Candidate.Reset;
                            l_Candidate.SetFilter("Responsibility Center", rCandidate."Responsibility Center");
                            l_Candidate.SetRange("No.", "Candidate Code No.");
                            if PAGE.RunModal(PAGE::"Candidate List", l_Candidate) = ACTION::LookupOK then
                                Validate("No.", l_Candidate."No.");
                        end;
                        if (Kinship = Kinship::"Brother in School") then begin
                            rStudent.Reset;
                            rStudent.SetRange("Responsibility Center", l_Candidate."Responsibility Center");
                            if "No." <> '' then begin
                                rStudent.SetRange("No.", "No.");
                                if rStudent.FindSet then;
                                rStudent.SetRange("No.");
                            end;
                            if PAGE.RunModal(PAGE::"Students List", rStudent) = ACTION::LookupOK then
                                Validate("No.", rStudent."No.");
                        end;
                    end else begin
                        rUsersFamily.Reset;
                        rUsersFamily.SetFilter("Responsibility Center", rCandidate."Responsibility Center");
                        if "No." <> '' then begin
                            rUsersFamily.SetRange("No.", "No.");
                            if rUsersFamily.FindSet then;
                            rUsersFamily.SetRange("No.");
                        end;
                        if PAGE.RunModal(PAGE::"Users Family List", rUsersFamily) = ACTION::LookupOK then
                            Validate("No.", rUsersFamily."No.");
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if (Kinship = Kinship::Himself) then
                    if "Candidate Code No." <> "No." then
                        Error(Text002);

                rUsersFamilyCandidate.Reset;
                rUsersFamilyCandidate.SetRange("Candidate Code No.", "Candidate Code No.");
                rUsersFamilyCandidate.SetRange("No.", "No.");
                rUsersFamilyCandidate.SetFilter(Kinship, '<>%1', rUsersFamilyCandidate.Kinship::Himself);
                if rUsersFamilyCandidate.FindFirst then begin
                    if not Confirm(Text008, false, "No.") then
                        Error(Text007);
                end;


                if (Kinship = Kinship::Himself) or (Kinship = Kinship::"Brother in School") then begin
                    if (Kinship = Kinship::Himself) then begin
                        if rCandidate.Get("No.") then begin
                            Name := rCandidate.Name;
                            "Last Name 2" := rCandidate."Last Name 2";
                            "Last Name" := rCandidate."Last Name";
                            Address := rCandidate.Address + ' ' + rCandidate."Address 2" + ' ' + rCandidate."Post Code" + ' ' +
                                      rCandidate.Location;
                            "Phone No." := rCandidate."Phone No.";
                            "Mobile Phone" := rCandidate."Mobile Phone";
                        end;
                    end;
                    if (Kinship = Kinship::"Brother in School") then begin
                        if rStudent.Get("No.") then begin
                            Name := rStudent.Name;
                            "Last Name 2" := rStudent."Last Name 2";
                            "Last Name" := rStudent."Last Name";
                            Address := rStudent.Address + ' ' + rStudent."Address 2" + ' ' + rStudent."Post Code" + ' ' +
                                      rStudent.Location;
                            "Phone No." := rStudent."Phone No.";
                            "Mobile Phone" := rStudent."Mobile Phone";
                        end;
                    end;
                end else begin
                    if rUsersFamily.Get("No.") then begin
                        Name := rUsersFamily.Name;
                        "Last Name 2" := rUsersFamily."Last Name 2";
                        "Last Name" := rUsersFamily."Last Name";
                        Address := rUsersFamily.Address + ' ' + rUsersFamily."Address 2" + ' ' +
                                  rUsersFamily."Post Code" + ' ' + rUsersFamily.Location;
                        "Phone No." := rUsersFamily."Phone No.";
                        "Mobile Phone" := rUsersFamily."Mobile Phone";
                    end else begin
                        Name := '';
                        "Last Name 2" := '';
                        "Last Name" := '';
                        Address := '';
                        "Phone No." := '';
                        "Mobile Phone" := '';
                    end;
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
                rUsersFamilyCandidate.Reset;
                rUsersFamilyCandidate.SetRange("Candidate Code No.", "Candidate Code No.");
                rUsersFamilyCandidate.SetRange("Education Head", true);
                rUsersFamilyCandidate.SetFilter("No.", '<>%1', "No.");
                if rUsersFamilyCandidate.FindFirst then
                    Error(Text001);
            end;
        }
        field(10; "Paying Entity"; Boolean)
        {
            Caption = 'Paying Entity';

            trigger OnValidate()
            begin
                if "Paying Entity" then
                    cStudentServices.CandidateCustomerCreate(Rec);
            end;
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
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';
        }
        field(73108; "User Family Address"; Boolean)
        {
            Caption = 'User Family Address';

            trigger OnValidate()
            var
                l_Students: Record Students;
                l_Candidate: Record Candidate;
            begin
                rUsersFamilyCandidate.Reset;
                rUsersFamilyCandidate.SetRange("Candidate Code No.", "Candidate Code No.");
                rUsersFamilyCandidate.SetRange("User Family Address", true);
                rUsersFamilyCandidate.SetFilter("No.", '<>%1', "No.");
                if rUsersFamilyCandidate.FindFirst then
                    Error(Text006);

                if Kinship = Kinship::Himself then
                    Error(Text004);

                if Confirm(Text005, true) then begin
                    if "User Family Address" then begin
                        if (Kinship = Kinship::"Brother in School") then begin
                            if l_Students.Get("No.") then begin
                                if l_Candidate.Get("Candidate Code No.") then;
                                l_Candidate.Address := l_Students.Address;
                                l_Candidate."Address 2" := l_Students."Address 2";
                                l_Candidate."Post Code" := l_Students."Post Code";
                                l_Candidate.Location := l_Students.Location;
                                l_Candidate.Validate(l_Candidate."Parish/Council/District Code", l_Students."Parish/Council/District Code");
                                l_Candidate.County := l_Students.County;
                                l_Candidate."Phone No." := l_Students."Phone No.";
                                l_Candidate.Modify(true);
                            end;
                        end else begin
                            if rUsersFamily.Get("No.") then begin
                                if l_Candidate.Get("Candidate Code No.") then;
                                l_Candidate.Address := rUsersFamily.Address;
                                l_Candidate."Address 2" := rUsersFamily."Address 2";
                                l_Candidate."Post Code" := rUsersFamily."Post Code";
                                l_Candidate.Location := rUsersFamily.Location;
                                l_Candidate.Validate(l_Candidate."Parish/Council/District Code", rUsersFamily."Parish/Council/District Code");
                                l_Candidate.County := rUsersFamily.County;
                                l_Candidate."Phone No." := rUsersFamily."Phone No.";
                                l_Candidate.Modify(true);
                            end;
                        end;
                    end;
                end else
                    "User Family Address" := false;
            end;
        }
    }

    keys
    {
        key(Key1; "Candidate Code No.", Kinship, "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if rCandidate.Get("Candidate Code No.") then
            if rCandidate."Student No." <> '' then
                Error(Text003);
    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rCandidate: Record Candidate;
        rUsersFamily: Record "Users Family";
        rUsersFamilyCandidate: Record "Users Family / Candidate";
        Text001: Label 'There already is an education responsible for the selected Candidate.';
        rStudent: Record Students;
        cStudentServices: Codeunit "Student Services";
        Text002: Label 'The No. should be the same as of the Candidate.';
        Text003: Label 'Not allowed to delete.';
        Text006: Label 'There is already a user address for the students selected.';
        Text004: Label 'Not allowed.';
        Text005: Label 'Do you wish to update the address for the candidate?';
        Text008: Label 'There is already a user with the No %1. Do you wish to continue?';
        Text007: Label 'Operation cancelled by the user.';
}

