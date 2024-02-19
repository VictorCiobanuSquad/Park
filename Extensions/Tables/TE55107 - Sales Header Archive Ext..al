tableextension 55107 "Sales Header Archive Ext." extends "Sales Header Archive"
{
    /*
    IT002 - Parque - 06.10.2016 - Novos campos Turma e Ano Escolaridade

    IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093
    */
    fields
    {
        field(50009; Turma; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Turma onde o Aluno está inserido, para efeitos de ordenação';
        }
        field(50010; "Ano Escolaridade"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Parque';
        }
        field(50012; "Portal Created by"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'User Criação Portal';
            Description = 'Park';
        }
    }
}