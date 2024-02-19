tableextension 50114 "Sales Cr.Memo Header Ext." extends "Sales Cr.Memo Header"
{
    /*
    //IT001 - Parque - 2016.10.12 - movo campo 50001 "Transferida de Armazem" para indicar se já foi feita a transferencia de armazém

    IT002 - Parque - 2017.03.20 - Novo campo Ano Escolaridade

    IT003 - Parque - Portal Fardas - 2017.05.18 - novo campo Origem Portal Fardas - para sabermos que este doc vem do portal e o portal
                                                só mostrar este tipo de documentos

    IT009 - Park - Novo campo Aluno - 2018.01.30 - pedido 1095

    IT010 - Park - Novo campo 	Portal Created by	 - 2018.01.30 - pedido 1093

    JDE_INT SQD RTV 20210625
        New field: 50013 - "JDE Integrated"
    */
    fields
    {
        field(50000; "Invoice Path"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Path';
            Description = 'CPA.01';
            Editable = false;
        }
        field(50001; "Transferida de Armazem"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Parque';
        }
        field(50002; "Origem Portal Fardas"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Parque - Portal Fardas';
        }
        field(50009; Turma; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Turma onde o Aluno está inserido, para efeitos de ordenação';
            TableRelation = Class.Class;
        }
        field(50010; "Ano Escolaridade"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Parque';
        }
        field(50011; Aluno; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Park';
        }
        field(50012; "Portal Created by"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'User Criação Portal';
            Description = 'Park';
        }
        field(50013; "JDE Integrated"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Old,"Not Integrated",Integrated;
            OptionCaption = 'Old,Not Integrated,Integrated';
            Caption = 'JDE Integrated';
            Description = 'JDE_INT SQD RTV 20210625';
            InitValue = "Not Integrated";
        }
        field(73000; "Process by Education"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Process by Education';
        }
    }
}