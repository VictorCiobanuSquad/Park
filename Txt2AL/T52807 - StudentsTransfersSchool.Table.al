table 52807 "Students Transfers School"
{
    Caption = 'Students Transfers School';
    Permissions = TableData "Assessing Students" = rimd,
                  TableData "Assessing Students Final" = rimd;

    fields
    {
        field(1; "Student Code"; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(6; "School Code"; Code[10])
        {
            Caption = 'School Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE("Legal Code Type" = FILTER(" "),
                                                                                Type = FILTER(School));

            trigger OnValidate()
            begin
                rLegalCodes.Reset;
                rLegalCodes.SetRange(Type, rLegalCodes.Type::School);
                rLegalCodes.SetRange("Legal Code Type", rLegalCodes."Legal Code Type"::" ");
                rLegalCodes.SetRange("Parish/Council/District Code", "School Code");
                if rLegalCodes.FindSet then begin
                    "School Name" := rLegalCodes."School Name";
                    Address := rLegalCodes.Address;
                    "Address 2" := rLegalCodes."Address 2";
                    "Post Code" := rLegalCodes."Post Code";
                    Location := rLegalCodes.Location;
                    "Phone No." := rLegalCodes."Phone No.";
                    "E-mail" := rLegalCodes."E-mail";
                    County := rLegalCodes.County;
                end else begin
                    "School Name" := '';
                    Address := '';
                    "Address 2" := '';
                    "Post Code" := '';
                    Location := '';
                    "Phone No." := '';
                    "E-mail" := '';
                    County := '';

                end;
            end;
        }
        field(7; "School Name"; Text[128])
        {
            Caption = 'School Name';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(Location,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(Location,"Post Code");
            end;
        }
        field(11; Location; Text[30])
        {
            Caption = 'Location';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(Location,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(Location,"Post Code");
            end;
        }
        field(12; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';
        }
        field(13; "E-mail"; Text[64])
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
        field(14; County; Text[100])
        {
            Caption = 'County';
        }
        field(15; Transfer; Option)
        {
            Caption = 'Transfer';
            OptionCaption = 'From,To';
            OptionMembers = From,"To";
        }
        field(16; Class; Text[30])
        {
            Caption = 'Class';
        }
        field(17; "Class Letter"; Code[2])
        {
            Caption = 'Class Letter';
        }
        field(18; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
        }
        field(19; "Actual Status"; Option)
        {
            Caption = 'Actual Status';
            OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Tranfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences,School Certificate';
            OptionMembers = " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Tranfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences","School Certificate";

            trigger OnValidate()
            var
                rCommentLine: Record "Comment Line";
                NumLinha: Integer;
            begin
            end;
        }
        field(20; "Registration Created"; Boolean)
        {
            CalcFormula = Exist(Registration WHERE("School Year" = FIELD("School Year"),
                                                    "Student Code No." = FIELD("Student Code")));
            Caption = 'Registration Created';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Student Code", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Student Code", "School Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteRecord;
    end;

    trigger OnModify()
    begin
        UpdateRegistration;
    end;

    var
        PostCode: Record "Post Code";
        Text001: Label 'The email address "%1" is invalid.';
        rLegalCodes: Record "Legal Codes";

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
    procedure InsertRegistration()
    var
        l_Registration: Record Registration;
        l_Students: Record Students;
    begin
        CalcFields("Registration Created");
        if not "Registration Created" then begin
            TestField("School Year");
            TestField("Schooling Year");
            if l_Students.Get("Student Code") then begin
                l_Registration.Init;
                l_Registration."Student Code No." := "Student Code";
                l_Registration."School Year" := "School Year";
                l_Registration."Responsibility Center" := l_Students."Responsibility Center";
                l_Registration.Validate("Schooling Year", "Schooling Year");
                l_Registration."Registration Date" := "Registration Date";
                l_Registration."Actual Status" := "Actual Status";
                l_Registration.Insert;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateRegistration()
    var
        l_Registration: Record Registration;
        l_Students: Record Students;
    begin
        CalcFields("Registration Created");
        if "Registration Created" then begin
            if l_Students.Get("Student Code") then begin
                l_Registration.Reset;
                l_Registration.SetRange("Student Code No.", "Student Code");
                l_Registration.SetRange("School Year", "School Year");
                l_Registration.SetRange("Responsibility Center", l_Students."Responsibility Center");
                if l_Registration.FindSet(true, true) then begin
                    l_Registration."Registration Date" := "Registration Date";
                    l_Registration."Actual Status" := "Actual Status";
                    l_Registration.Modify;
                end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteRecord()
    var
        Text0001: Label 'Confirm you want to delete the record?\Deleting this record will delete all evaluations for this school Year!';
        Text0002: Label 'Delete aborted by user!';
        l_Registration: Record Registration;
        l_AssessingStudents: Record "Assessing Students";
        l_AssessingStudentsFinal: Record "Assessing Students Final";
    begin
        CalcFields("Registration Created");
        if "Registration Created" then begin
            if not Confirm(Text0001, false) then
                Error(Text0002);
            l_AssessingStudents.Reset;
            l_AssessingStudents.SetRange("School Year", "School Year");
            l_AssessingStudents.SetRange("Student Code No.", "Student Code");
            l_AssessingStudents.DeleteAll;

            l_AssessingStudentsFinal.Reset;
            l_AssessingStudentsFinal.SetRange("School Year", "School Year");
            l_AssessingStudentsFinal.SetRange("Student Code No.", "Student Code");
            l_AssessingStudentsFinal.DeleteAll;

            l_Registration.Reset;
            l_Registration.SetRange("School Year", "School Year");
            l_Registration.SetRange("Schooling Year", "Schooling Year");
            l_Registration.SetRange("Student Code No.", "Student Code");
            l_Registration.DeleteAll;
        end;
    end;
}

