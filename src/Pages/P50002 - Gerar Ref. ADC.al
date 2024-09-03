page 50002 "Gerar Ref. ADC"
{
    PageType = Card;

    layout
    {
        area(Content)
        {
            field(CodigoCliente; CodigoCliente)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(CodigoIDCRED; CodigoIDCRED)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(preADC; preADC)
            {
                ApplicationArea = All;
            }
            field(ADC; ADC)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(gADC)
            {
                Caption = 'ADC';

                action(GenADC)
                {
                    ApplicationArea = All;
                    Caption = 'Gerar Ref. ADC';

                    trigger OnAction()
                    begin
                        GenerateADC;

                        ADC := PreencheZerosEsquerda(preADC + CheckDigit, 11);
                    end;
                }
            }
        }
    }

    var
        CodigoCliente: Code[20];
        CodigoIDCRED: Code[6];
        preADC: Text[17];
        ADC: Text[17];
        Text50000: Label 'Insira um valor com 9 digitos';
        p_ADC: Text[17];
        Total: Decimal;
        Iteration: Integer;
        i: Integer;
        j: Integer;
        Weight: Decimal;
        CurrentDigit: Integer;
        CheckDigit: Text[17];

    procedure GenerateADC()
    begin
        IF STRLEN(preADC) = 0 THEN
            ERROR(Text50000);

        p_ADC := CodigoIDCRED + PreencheZerosEsquerda(preADC, 9) + '00';

        Total := 0;

        Iteration := 0;
        FOR i := STRLEN(p_ADC) DOWNTO 1 DO BEGIN
            Iteration += 1;
            Weight := 1;
            IF (Iteration <> 1) AND (Iteration <> 2) THEN BEGIN
                FOR j := 1 TO Iteration - 1 DO BEGIN
                    Weight := Weight * 10;
                    Weight := Weight MOD 97;
                END;
                EVALUATE(CurrentDigit, COPYSTR(p_ADC, i, 1));
                Total := Weight * CurrentDigit + Total;
            END;
        END;

        // Let's calculate the checkDigit
        Total := Total MOD 97;
        Total := 98 - Total;
        CheckDigit := FORMAT(Total);
        IF STRLEN(CheckDigit) = 1 THEN
            CheckDigit := '0' + CheckDigit;
    end;

    procedure GetADC(VAR p_ADCValue: Code[11])
    begin
        p_ADCValue := ADC;
    end;

    procedure RecebeCodCliente(TempCodCliente: Code[20]; TempIDCred: Code[6]; TempCodigoDD: Option; TempADC: Text[17])
    begin
        CodigoCliente := TempCodCliente;
        CodigoIDCRED := TempIDCred;
        //CodigoDD := TempCodigoDD;
        IF TempADC <> '' THEN
            preADC := TempADC;
    end;

    procedure PreencheZerosEsquerda(Texto: Text[50]; casas: Integer) texto1: Text[50]
    var
        textozeros: Text[50];
        i: Integer;
    begin
        textozeros := '';
        FOR i := 1 TO (casas - STRLEN(Texto)) DO
            textozeros := '0' + textozeros;

        texto1 := textozeros + Texto;
    end;

    procedure GenerateADC2()
    begin
        IF STRLEN(preADC) = 0 THEN
            ERROR(Text50000);

        p_ADC := CodigoIDCRED + PreencheZerosEsquerda(preADC, 9) + '00';

        Total := 0;

        Iteration := 0;
        FOR i := STRLEN(p_ADC) DOWNTO 1 DO BEGIN
            Iteration += 1;
            Weight := 1;
            IF (Iteration <> 1) AND (Iteration <> 2) THEN BEGIN
                FOR j := 1 TO Iteration - 1 DO BEGIN
                    Weight := Weight * 10;
                    Weight := Weight MOD 97;
                END;
                EVALUATE(CurrentDigit, COPYSTR(p_ADC, i, 1));
                Total := Weight * CurrentDigit + Total;
            END;
        END;

        // Let's calculate the checkDigit
        Total := Total MOD 97;
        Total := 98 - Total;
        CheckDigit := FORMAT(Total);
        IF STRLEN(CheckDigit) = 1 THEN
            CheckDigit := '0' + CheckDigit;

        ADC := PreencheZerosEsquerda(preADC + CheckDigit, 11);
    end;

    procedure GerarADCAutomatico(TempCodCliente: Code[20]; TempIDCred: Code[6]; TempCodigoDD: Option; TempADC: Text[17]) ADCfinal: Text[30]
    begin
        //Normatica - 06.06.2012 - função que vai ser usada para gerar a refADC qd se pica a entidade pagadora
        RecebeCodCliente(TempCodCliente, TempIDCred, TempCodigoDD, TempADC);
        GenerateADC;
        ADCfinal := PreencheZerosEsquerda(preADC + CheckDigit, 11);
    end;
}