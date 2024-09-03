table 50011 "Portal User"
{


    DataClassification = ToBeClassified;
    Caption = 'Portal User';

    fields
    {
        field(1; UserType; Option)
        {
            Caption = 'UserType';
            OptionCaption = ' ,Administrador,Associado';
            OptionMembers = " ",Administrador,Associado;
        }
        field(2; UserID; Integer)
        {
            AutoIncrement = true;
        }
        field(3; LastPassDate; DateTime)
        {

        }
        field(4; Salt; Text[40])
        {

        }
        field(5; Pass; Text[100])
        {

        }
        field(6; RecoverGUID; Guid)
        {

        }
        field(7; RecoverDate; DateTime)
        {

        }
        field(8; Name; Text[30])
        {

        }
        field(9; Email; Text[30])
        {
            trigger OnValidate()
            begin
                if Email = '' then
                    if xRec.Email <> '' then
                        exit;

                CheckValidEmailAddress(Email);
                if UserType = UserType::Associado then begin
                    RecUsersFamily.Reset();
                    RecUsersFamily.SetRange("E-mail", Email);
                    if not RecUsersFamily.FindFirst() then
                        Error(Text002, Email);
                end;
            end;
        }
        field(10; Status; Option)
        {
            Caption = 'Estado';
            OptionCaption = ' ,Activo,Inactivo';
            OptionMembers = " ",Activo,Inactivo;
        }
    }
    keys
    {
        key(Key1; UserID, UserType)
        {
            Clustered = true;
        }
        key(Key2; Email)
        {
            Unique = true;
        }

    }
    trigger OnInsert()
    begin

    end;

    var
        Text001: Label 'The e-mail address "%1" is invalid.';
        Text002: Label 'The e-mail address "%1" is not registered as Family';
        RecUsersFamily: Record "Users Family";
        RecPortalUser: Record "Portal User";

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