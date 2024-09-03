table 52801 "Legal Codes"
{
    Caption = 'Legal Codes';
    DrillDownPageID = "FregConDist Codes";
    LookupPageID = "FregConDist Codes";

    fields
    {
        field(1; "Parish/Council/District Code"; Code[10])
        {
            Caption = 'Parish/Council/District Code';
        }
        field(2; Town; Text[30])
        {
            Caption = 'Town/Province';
        }
        field(3; TownASCII; Text[30])
        {
            Caption = 'TownASCII';
        }
        field(4; County; Text[30])
        {
            Caption = 'County';
        }
        field(5; CountyASCII; Text[30])
        {
            Caption = 'CountyASCII';
        }
        field(6; District; Text[30])
        {
            Caption = 'District';
        }
        field(7; DistrictASCII; Text[30])
        {
            Caption = 'DistrictASCII';
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Parish,Course,Subject,Exams,School,IRS,StudentType,Province';
            OptionMembers = Parish,Course,Subject,Exams,School,IRS,StudentType,Province;
        }
        field(9; Description; Text[61])
        {
            Caption = 'Description';
        }
        field(10; "ASCII Description"; Text[61])
        {
            Caption = 'ASCII Description';
        }
        field(11; "Legal Code Type"; Option)
        {
            Caption = 'Legal Code Type';
            OptionCaption = ' ,Multi,Simple';
            OptionMembers = " ",Multi,Simple;
        }
        field(12; "School Name"; Text[128])
        {
            Caption = 'School Name';
        }
        field(13; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(14; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(15; "Post Code"; Code[20])
        {
            Caption = 'Post Code';

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(Location,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(Location,"Post Code",County);
            end;
        }
        field(16; Location; Text[30])
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
        field(17; "Phone No."; Text[14])
        {
            Caption = 'Phone No.';
        }
        field(18; "E-mail"; Text[64])
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
    }

    keys
    {
        key(Key1; Type, "Legal Code Type", "Parish/Council/District Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
        Text001: Label 'The email address "%1" is invalid.';

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

