table 50006 "Apoio à Declaração IRS"
{

    fields
    {
        field(1; "No. Cliente"; Code[20])
        {
        }
        field(2; "No. Aluno"; Code[20])
        {
        }
        field(3; "No. Associado"; Code[20])
        {
        }
        field(4; Nome; Text[200])
        {
        }
        field(5; Turma; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No. Cliente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

