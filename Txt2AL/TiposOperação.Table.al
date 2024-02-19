table 50003 "Tipos Operação"
{

    fields
    {
        field(1; "Tipo Operação"; Integer)
        {
        }
        field(2; "Descrição"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Tipo Operação")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

