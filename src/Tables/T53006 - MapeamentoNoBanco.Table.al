table 53006 "Mapeamento No Banco"
{

    fields
    {
        field(1; "Nº Mov"; Integer)
        {
        }
        field(2; "Nº Doc Navision"; Code[20])
        {
        }
        field(3; "Nº Doc Banco"; Code[15])
        {
        }
        field(4; Processado; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Nº Mov")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    //[Scope('OnPrem')]
    procedure NextNoMov(): Integer
    var
        MapNoBanco: Record "Mapeamento No Banco";
    begin
        MapNoBanco.Reset;
        if MapNoBanco.Find('+') then
            exit(MapNoBanco."Nº Mov" + 1)
        else
            exit(1);
    end;
}

