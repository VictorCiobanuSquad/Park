table 52831 "Recenseamento Alunos"
{

    fields
    {
        field(1; Turma; Code[20])
        {
        }
        field(2; "Nome Aluno"; Text[150])
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
        field(9; "Necessidades Educativas"; Text[30])
        {
        }
        field(10; "Inglês"; Text[30])
        {
        }
        field(11; "Francês"; Text[30])
        {
        }
        field(12; "Alemão"; Text[30])
        {
        }
        field(13; Espanhol; Text[30])
        {
        }
        field(14; "Escalão"; Integer)
        {
        }
        field(15; Regime; Integer)
        {
        }
        field(16; Contrato; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Turma, "Nome Aluno")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

