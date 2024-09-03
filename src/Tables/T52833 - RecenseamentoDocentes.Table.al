table 52833 "Recenseamento Docentes"
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
        field(10; "Funções Lectivas"; Text[30])
        {
        }
        field(11; "Grupo Docência"; Code[10])
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
        field(19; "Componente Formação"; Integer)
        {
        }
        field(20; Turma1; Code[20])
        {
        }
        field(21; Turma2; Code[20])
        {
        }
        field(22; Turma3; Code[20])
        {
        }
        field(23; Turma4; Code[20])
        {
        }
        field(24; "Tipo Função"; Integer)
        {
        }
        field(27; "Horas Pré-Escolar"; Integer)
        {
        }
        field(28; "Horas 1 Ciclo"; Integer)
        {
        }
        field(29; "Horas 2 Ciclo"; Integer)
        {
        }
        field(30; "Horas 3 Ciclo"; Integer)
        {
        }
        field(31; "Horas Secundário"; Integer)
        {
        }
        field(32; "Horas letivas"; Integer)
        {
        }
        field(33; "Horas não letivas"; Integer)
        {
        }
        field(34; "Horas pós-secundário"; Integer)
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

