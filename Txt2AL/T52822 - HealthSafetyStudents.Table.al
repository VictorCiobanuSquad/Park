table 52822 "Health & Safety Students"
{
    Caption = 'Health & Safety Students';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Vaccinations,Diseases,Allergies,Legal,Blood Type,Handicapped,Parto,Creche,Fase Sens-Mot,Vocabulário,Hig.Pessoal,Amamentação,Alimentação,Sono,Saúde,Hist.Familiar,Comp.Casa,TarefasCasa,Ling.Estrangeira';
            OptionMembers = " ",Vac,Dis,All,Leg,Blo,Han,Par,Cre,FSM,Voc,HigPes,Amam,Alim,Sono,"Saúde",HistFam,CompCasa,TarCasa,LingEst;

            trigger OnValidate()
            begin
                if Code <> '' then begin
                    rcodedesc.Reset;
                    rcodedesc.SetRange(Type, Type);
                    rcodedesc.SetRange(Code, Code);
                    if not rcodedesc.FindFirst then
                        Error(text001);
                end else
                    Validate(Code, '');
            end;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnLookup()
            begin
                rcodedesc2.Reset;
                rcodedesc2.SetRange(Type, Type);

                if PAGE.RunModal(52912, rcodedesc2) = ACTION::LookupOK then
                    Validate(Code, rcodedesc2.Code);
            end;

            trigger OnValidate()
            begin
                if rcodedesc.Get(Type, Code) then
                    Description := rcodedesc.Description
                else
                    Description := '';
            end;
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
        field(6; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(7; "Student Code"; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(1002; Sim; Boolean)
        {
        }
        field(1004; "Observações"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Student Code", "Line No")
        {
            Clustered = true;
        }
        key(Key2; Type)
        {
        }
        key(Key3; "Code")
        {
        }
        key(Key4; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rcodedesc: Record "H&S";
        text001: Label 'The Code does not exist for the select type.';
        rcodedesc2: Record "H&S";
}

