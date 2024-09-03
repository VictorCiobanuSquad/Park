table 58800 "Tabela Novos CC"
{

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Nome; Text[50])
        {
        }
        field(3; "Novo Código"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

