table 52832 "Recenseamento Não Docentes"
{

    fields
    {
        field(2; "Nome Empregado"; Text[150])
        {
        }
        field(3; "Tipo Documento"; Integer)
        {
        }
        field(4; "Numero Documento"; Text[32])
        {
        }
        field(5; "Data Nascimento"; Text[30])
        {
        }
        field(6; Sexo; Text[30])
        {
        }
        field(7; "Cod. Postal"; Text[4])
        {
        }
        field(8; Nacionalidade; Code[10])
        {
        }
        field(9; "Formação Académica"; Integer)
        {
        }
        field(10; "Função"; Integer)
        {
        }
        field(12; "Contrato Indeterminado"; Text[30])
        {
        }
        field(13; "Contrato Termo"; Text[30])
        {
        }
        field(14; "Prestação Serviços"; Text[30])
        {
        }
        field(15; "Acumulação"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Nome Empregado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

