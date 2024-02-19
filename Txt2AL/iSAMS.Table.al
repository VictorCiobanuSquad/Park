table 50017 iSAMS
{
    // IT001 - Parque - 2018.02.22 - Novos campos Endereço Mae, NIF Mae, Endereço Pai, NIF Pai


    fields
    {
        field(1; "Nº Processo"; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(4; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(5; Sex; Option)
        {
            Caption = 'Sex';
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",M,F;
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "Post Code"; Code[20])
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
            end;
        }
        field(8; Location; Text[30])
        {
            Caption = 'Localidade';
        }
        field(9; ParentescoEncEdu; Option)
        {
            Caption = 'Parentesco Enc. Edu';
            OptionMembers = " ",Father,Mother,Other;
        }
        field(10; NomeMae; Text[128])
        {
            Caption = 'Name';
        }
        field(11; TelefoneEmpMae; Text[14])
        {
            Caption = 'Phone No. 2';
        }
        field(12; TelemovelMae; Text[14])
        {
            Caption = 'Mobile Phone';
        }
        field(13; "E-mailMae"; Text[64])
        {
            Caption = 'E-mail';
        }
        field(14; NomePai; Text[128])
        {
            Caption = 'Name';
        }
        field(15; TelefoneEmpPai; Text[14])
        {
            Caption = 'Phone No. 2';
        }
        field(16; TelemovelPai; Text[14])
        {
            Caption = 'Mobile Phone';
        }
        field(17; "E-mailPai"; Text[64])
        {
            Caption = 'E-mail';
        }
        field(18; "NIB-IBAN"; Text[50])
        {
            Caption = 'NIB-IBAN';
        }
        field(19; NContribuinteEncEdu; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(20; "E-mail"; Text[64])
        {
            Caption = 'E-mail';
        }
        field(21; EnderecoMae; Text[100])
        {
            Caption = 'Endereço Mãe';
        }
        field(22; CodPostalMae; Code[20])
        {
            Caption = 'Cod. Postal Mãe';
        }
        field(23; LocalidadeMae; Text[30])
        {
            Caption = 'Localidade Mãe';
        }
        field(24; NIFMae; Text[20])
        {
            Caption = 'NIF Mãe';
        }
        field(30; EnderecoPai; Text[100])
        {
            Caption = 'Endereço Pai';
        }
        field(31; CodPostalPai; Code[20])
        {
            Caption = 'Cod. Postal Pai';
        }
        field(32; LocalidadePai; Text[30])
        {
            Caption = 'Localidade Pai';
        }
        field(33; NIFPai; Text[20])
        {
            Caption = 'NIF Pai';
        }
        field(100; "Student Surname"; Text[30])
        {
        }
        field(101; "Student Firstname"; Text[250])
        {
        }
        field(102; Address2; Text[100])
        {
            Caption = 'Address';
        }
        field(103; Country; Text[30])
        {
        }
        field(104; Forename1; Text[100])
        {
        }
        field(105; Surname1; Text[30])
        {
        }
        field(106; Forename2; Text[100])
        {
        }
        field(107; Surname2; Text[30])
        {
        }
        field(108; Relationtype; Text[30])
        {
        }
        field(109; Mobile1; Text[14])
        {
        }
        field(110; Mobile2; Text[14])
        {
        }
        field(111; Email1; Text[64])
        {
        }
        field(112; Email2; Text[64])
        {
        }
        field(113; "School ID"; Text[30])
        {
        }
        field(114; NIFAss; Text[20])
        {
            Caption = 'NIFAsso';
        }
        field(200; NMov; Integer)
        {
        }
        field(201; Duplicado; Boolean)
        {
            Editable = false;
        }
        field(300; NomeOutro; Text[128])
        {
            Caption = 'Name';
        }
        field(301; TelefoneEmpOutro; Text[14])
        {
            Caption = 'Phone No. 2';
        }
        field(302; TelemovelOutro; Text[14])
        {
            Caption = 'Mobile Phone';
        }
        field(303; "E-mailOutro"; Text[64])
        {
            Caption = 'E-mail';
        }
        field(304; EnderecoOutro; Text[100])
        {
            Caption = 'Endereço Outro';
        }
        field(305; CodPostalOutro; Code[20])
        {
            Caption = 'Cod. Postal Outro';
        }
        field(306; LocalidadeOutro; Text[30])
        {
            Caption = 'Localidade Outro';
        }
        field(307; NIFOutro; Text[20])
        {
            Caption = 'NIF Outro';
        }
    }

    keys
    {
        key(Key1; NMov)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        riSAMS.RESET;
        riSAMS.SETRANGE(riSAMS."Nº Processo", "Nº Processo");
        IF riSAMS.COUNT = 2 THEN BEGIN
            riSAMS.SETFILTER(riSAMS.NMov, '<>%1', NMov);
            IF riSAMS.FINDFIRST THEN BEGIN
                riSAMS.Duplicado := FALSE;
                riSAMS.MODIFY;
            END;
        END;
    end;

    var
        riSAMS: Record iSAMS;
}

