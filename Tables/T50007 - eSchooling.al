table 50007 eSchooling
{
    /*
    IT001 - Parque - 2018.02.22 - Novos campos Endereço Mae, NIF Mae, Endereço Pai, NIF Pai
    */
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }
        field(2; Name; Text[128])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(3; "VAT Registration No."; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.';
        }
        field(4; "Birth Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Birth Date';
        }
        field(5; Sex; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Male,Female;
            Optioncaption = ' ,Male,Female';
            Caption = 'Sex';
        }
        field(6; Address; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Address';
        }
        field(7; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(8; Location; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Localidade';
        }
        field(9; ParentescoEncEdu; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Father,Mother;
            OptionCaption = ' ,Pai,Mãe';
        }
        field(10; NomeMae; Text[128])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(11; TelefoneEmpMae; Text[14])
        {
            DataClassification = ToBeClassified;
            Caption = 'Phone No. 2';
        }
        field(12; TelemovelMae; Text[14])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mobile Phone';
        }
        field(13; "E-mailMae"; Text[64])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-mail';
        }
        field(14; NomePai; Text[128])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(15; TelefoneEmpPai; Text[14])
        {
            DataClassification = ToBeClassified;
            Caption = 'Phone No. 2';
        }
        field(16; TelemovelPai; Text[14])
        {
            DataClassification = ToBeClassified;
            Caption = 'Mobile Phone';
        }
        field(17; "E-mailPai"; Text[64])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-mail';
        }
        field(18; "NIB-IBAN"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'NIB-IBAN';
        }
        field(19; NContribuinteEncEdu; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.';
        }
        field(20; "E-mail"; Text[64])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-mail';
        }
        field(21; EnderecoMae; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Endereço Mãe';
        }
        field(22; CodPostalMae; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cod. Postal Mãe';
        }
        field(23; LocalidadeMae; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Localidade Mãe';
        }
        field(24; NIFMae; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'NIF Mãe';
        }
        field(30; EnderecoPai; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Endereço Pai';
        }
        field(31; CodPostalPai; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cod. Postal Pai';
        }
        field(32; LocalidadePai; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Localidade Pai';
        }
        field(33; NIFPai; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'NIF Pai';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
}