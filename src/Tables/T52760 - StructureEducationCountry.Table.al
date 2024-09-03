table 52760 "Structure Education Country"
{
    Caption = 'Structure Education country';
    LookupPageID = "Structure Education country";

    fields
    {
        field(1; Country; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Country/Region".Code;
        }
        field(2; "Education Level"; Text[30])
        {
            Caption = 'Education Level Descripton';
        }
        field(3; Level; Option)
        {
            Caption = 'Levels';
            OptionCaption = 'Pre-school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
        }
        field(5; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(6; Granule; Option)
        {
            Caption = 'Granule';
            OptionCaption = 'pre school,compulsory education,secondary education';
            OptionMembers = "Pre escolar","Obrigatório","Secundário";
        }
        field(7; "Absence Type"; Option)
        {
            Caption = 'Absence Type';
            OptionCaption = 'Lecture,Daily';
            OptionMembers = Lecture,Daily;
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(73101; Course; Option)
        {
            Caption = 'Course';
            OptionCaption = ' ,1º,2º,3º,4º,5º,6º,P0,P1,P2,P3,P4,P5';
            OptionMembers = " ","1º","2º","3º","4º","5º","6º",P0,P1,P2,P3,P4,P5;
        }
        field(73102; "Edu. Level"; Option)
        {
            Caption = 'Education Level';
            OptionCaption = ' ,Pre-Primary Edu.,Primary Edu.,Lower Secondary Edu.,Upper Secondary Edu.,Formative Cycles';
            OptionMembers = " ","Pre-Primary Edu.","Primary Edu.","Lower Secondary Edu.","Upper Secondary Edu.","Formative Cycles";
        }
        field(73103; "Interface Type GIC"; Option)
        {
            Caption = 'Interface Type GIC';
            OptionCaption = ' ,Adults,Youth,Children';
            OptionMembers = " ",Adultos,Jovenes,Infantiles;
        }
        field(73104; "Interface Type WEB"; Option)
        {
            Caption = 'Interface Type WEB';
            OptionCaption = 'General,Infantil';
            OptionMembers = General,Infantil;
        }
        field(73105; "Final Cycle Caption"; Text[30])
        {
            Caption = 'Final Cycle Caption';
        }
        field(73106; "Final Stage Caption"; Text[30])
        {
            Caption = 'Final Stage Caption';
        }
    }

    keys
    {
        key(Key1; Country, Level, "Schooling Year")
        {
            Clustered = true;
        }
        key(Key2; "Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        lInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
    begin
        //Update lines in WEB
        lInsertNAVGeneralTable.ModStructureEducationCountry(Rec);
    end;
}

