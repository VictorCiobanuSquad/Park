table 52757 "Table MISI"
{
    Caption = 'Table MISI';
    LookupPageID = "MISI List";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Nationality,Training,,Code Occupation,Employment Situation,,Place of Birth,General,Scientific-Human,Technological,Artistic,Professional,CEF,Appellant,EFA,Cod Course,Subject,Universities,College Courses,Groups Teaching,Waiver situation,Situation';
            OptionMembers = " ",Nacionalidade,"Formação",,CodProfissao,SituacaoEmp,,Naturalidade,GR,CH,TE,AR,PRO,CEF,REC,EFA,CodCurso,Disc,Universidades,"Cursos Superiores","Grupos Docência","Dispensa Sit",Situacao;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[160])
        {
            Caption = 'Description';
        }
        field(5; "Relational Code"; Code[10])
        {
            Caption = 'Relation Code';
        }
        field(6; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Multi));
        }
        field(10; Code2; Code[100])
        {
            Caption = 'Code2';
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

