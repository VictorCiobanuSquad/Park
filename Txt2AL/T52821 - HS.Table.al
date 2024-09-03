table 52821 "H&S"
{
    Caption = 'Health & Safety Code';
    LookupPageID = "Health & Safety Code List";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Vaccinations,Diseases,Allergies,Legal,Blood Type,Handicapped,Parto,Creche,Fase Sens-Mot,Vocabulário,Hig.Pessoal,Amamentação,Alimentação,Sono,Saúde,Hist.Familiar,Comp.Casa,TarefasCasa,Ling.Estrangeira';
            OptionMembers = " ",Vac,Dis,All,Leg,Blo,Han,Par,Cre,FSM,Voc,HigPes,Amam,Alim,Sono,"Saúde",HistFam,CompCasa,TarCasa,LingEst;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(6; "Observações"; Text[250])
        {
        }
        field(7; Sim; Boolean)
        {
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

    trigger OnInsert()
    begin
        if Type = 0 then
            Error(text001);
    end;

    var
        text001: Label 'Must choose the type.';
}

