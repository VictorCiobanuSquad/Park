codeunit 31009759 Parser
{
    // 
    // Utilizado para calculo da Nota Final de curso.
    // Codigo original de Justas Janauskas.
    // www.Mibuso.com


    trigger OnRun()
    begin


        //testes
        //MESSAGE(FORMAT(CalcDecimalExpr('(2*11.5')));

        Message(Format(CalcDecimalExpr('(6,54 + 6,07 + 7,58 + 7,14  )/4 ')));
        //MESSAGE(FORMAT(CalcDecimalExpr('(2*((11.5+2*0+0)/4)+0)/3')));
        //MESSAGE(FORMAT(CalcDecimalExpr('(2^2')));
    end;

    var
        Text003: Label 'Error converting "%1" in expression "%2"';
        Text006: Label 'Function %1 must be called with %2 parameters';
        Text001: Label 'Unknown variable %1';

    local procedure ParseSkipBlanks(var APos: Integer; AMacro: Text[1024])
    begin
        if APos <= StrLen(AMacro) then
            while CopyStr(AMacro, APos, 1) = ' ' do begin
                APos += 1;
                if APos > StrLen(AMacro) then
                    exit;
            end;
    end;

    local procedure ParseReadName(var APos: Integer; AMacro: Text[1024]) Result: Text[1024]
    var
        s: Text[30];
    begin
        ParseSkipBlanks(APos, AMacro);
        s := '';
        if APos <= StrLen(AMacro) then begin
            if CopyStr(AMacro, APos, 1) in ['a' .. 'z', 'A' .. 'Z', '_'] then begin
                s := s + Format(AMacro[APos]);
                APos += 1;

                while CopyStr(AMacro, APos, 1) in ['a' .. 'z', 'A' .. 'Z', '_', '0' .. '9'] do begin
                    s := s + Format(AMacro[APos]);
                    APos += 1;
                end;
            end;
        end;

        ParseSkipBlanks(APos, AMacro);

        Result := s;
    end;

    local procedure ParseTrimBlanks(p_txtExpr: Text[1024]) p_txtResult: Text[1024]
    begin
        if p_txtExpr <> '' then begin
            while CopyStr(p_txtExpr, 1, 1) = ' ' do
                p_txtExpr := DelStr(p_txtExpr, 1, 1);

            while CopyStr(p_txtExpr, StrLen(p_txtExpr), 1) = ' ' do
                p_txtExpr := DelStr(p_txtExpr, StrLen(p_txtExpr), 1);
        end;

        p_txtResult := p_txtExpr;
    end;

    local procedure ParseReadFunctionParams(var APos: Integer; AMacro: Text[1024]; var AParamCount: Integer; var AParams: array[20] of Text[1024])
    var
        s: Text[1024];
        strParam: Text[1024];
        intP: Integer;
        intBegin: Integer;
        intEnd: Integer;
    begin
        ParseSkipBlanks(APos, AMacro);
        AParamCount := 0;
        Clear(AParams);
        if CopyStr(AMacro, APos, 1) = '(' then begin
            s := '';
            intP := 1;
            APos += 1;
            intBegin := APos;
            while (APos <= StrLen(AMacro)) and (intP >= 1) do begin
                case AMacro[APos] of
                    '(':
                        begin
                            intP += 1;
                            APos += 1;
                        end;
                    ')':
                        begin
                            intP -= 1;
                            if intP = 0 then begin
                                intEnd := APos - 1;
                                strParam := ParseTrimBlanks(CopyStr(AMacro, intBegin, intEnd - intBegin + 1));
                                if (AParamCount = 0) and (strParam = '') then begin
                                    // nulis parametru
                                end else begin
                                    AParamCount += 1;
                                    AParams[AParamCount] := strParam;
                                end;
                                intBegin := -1;
                                intEnd := -1;
                            end;
                            APos += 1;
                        end;
                    ',':
                        begin
                            if intP = 1 then begin
                                intEnd := APos - 1;
                                strParam := ParseTrimBlanks(CopyStr(AMacro, intBegin, intEnd - intBegin + 1));
                                AParamCount += 1;
                                AParams[AParamCount] := strParam;
                                APos += 1;
                                intBegin := APos;
                                intEnd := -1;
                            end else
                                APos += 1;
                        end;
                    else begin
                        APos += 1;
                    end;

                end;
            end;
        end;
    end;

    local procedure ParseReadDecimalValue(var APos: Integer; AMacro: Text[1024]) Result: Decimal
    var
        s: Text[30];
        t: Text[1];
        f: Boolean;
    begin
        ParseSkipBlanks(APos, AMacro);
        s := '';
        t := Format(Format(1.1) [2]);
        if APos <= StrLen(AMacro) then begin
            f := true;
            //WHILE (COPYSTR(AMacro, APos, 1) IN ['0'..'9', '.']) OR (f AND (COPYSTR(AMacro, APos, 1) = '-')) DO
            while (CopyStr(AMacro, APos, 1) in ['0' .. '9', ',']) or (f and (CopyStr(AMacro, APos, 1) = '-')) do begin
                f := false;
                //IF AMacro[APos] = '.' THEN
                if AMacro[APos] = ',' then
                    s := s + t
                else
                    s := s + Format(AMacro[APos]);
                APos += 1;
            end;
        end;

        if not Evaluate(Result, s) then
            Error(StrSubstNo(Text003, s, AMacro));
    end;

    local procedure CalcFunction(p_txtName: Text[50]; p_intParamCount: Integer; p_txtParams: array[20] of Text[1024]; var p_decResult: Decimal; var p_txtResult: Text[30])
    var
        intCount: Integer;
        intTypes: array[20] of Integer;
    begin
        p_decResult := 0;
        p_txtResult := '';

        GetFunctionParamCount(p_txtName, intCount, intTypes);

        if intCount <> p_intParamCount then
            Error(StrSubstNo(Text006, p_txtName, intCount));

        case UpperCase(p_txtName) of
            'ABS':
                p_decResult := Calc_ABS(p_txtParams);
        end;
    end;

    local procedure GetFunctionParamCount(p_txtName: Text[1024]; var p_intCount: Integer; var p_intTypes: array[20] of Integer)
    begin
        p_intCount := 0;
        Clear(p_intTypes);

        case UpperCase(p_txtName) of
            'ABS':
                begin
                    p_intCount := 1;
                    p_intTypes[1] := 0;
                end;
        end;
    end;

    local procedure Calc_ABS(p_txtParams: array[20] of Text[1024]) decResult: Decimal
    var
        decParam1: Decimal;
    begin
        decParam1 := CalcDecimalExpr(p_txtParams[1]);

        decResult := Abs(decParam1);
    end;

    local procedure ParseDecimalLevel1(var AResult: Decimal; var AParsePos: Integer; AMacro: Text[1024])
    var
        op: Text[1];
        fltResult: Decimal;
    begin
        ParseDecimalLevel2(AResult, AParsePos, AMacro);
        while CopyStr(AMacro, AParsePos, 1) in ['+', '-'] do begin
            op := Format(AMacro[AParsePos]);
            AParsePos += 1;
            ParseDecimalLevel2(fltResult, AParsePos, AMacro);
            case op of
                '+':
                    AResult := AResult + fltResult;
                '-':
                    AResult := AResult - fltResult;
            end;
        end;
    end;

    local procedure ParseDecimalLevel2(var AResult: Decimal; var AParsePos: Integer; AMacro: Text[1024])
    var
        op: Text[1];
        fltResult: Decimal;
    begin
        ParseDecimalLevel3(AResult, AParsePos, AMacro);
        while CopyStr(AMacro, AParsePos, 1) in ['*', '/'] do begin
            op := Format(AMacro[AParsePos]);
            AParsePos += 1;
            ParseDecimalLevel3(fltResult, AParsePos, AMacro);
            case op of
                '*':
                    AResult := AResult * fltResult;
                '/':
                    begin
                        if fltResult <> 0 then
                            AResult := AResult / fltResult
                        else
                            AResult := 0;
                    end;
            end;
            ParseSkipBlanks(AParsePos, AMacro);
        end;
        ParseSkipBlanks(AParsePos, AMacro);
    end;

    local procedure ParseDecimalLevel3(var AResult: Decimal; var AParsePos: Integer; AMacro: Text[1024])
    var
        fltResult: Decimal;
    begin
        ParseDecimalLevel4(AResult, AParsePos, AMacro);
        while CopyStr(AMacro, AParsePos, 1) = '^' do begin
            AParsePos += 1;
            ParseDecimalLevel4(fltResult, AParsePos, AMacro);
            AResult := Power(AResult, fltResult);
            ParseSkipBlanks(AParsePos, AMacro);
        end;
        ParseSkipBlanks(AParsePos, AMacro);
    end;

    local procedure ParseDecimalLevel4(var AResult: Decimal; var AParsePos: Integer; AMacro: Text[1024])
    begin
        ParseSkipBlanks(AParsePos, AMacro);
        if AParsePos <= StrLen(AMacro) then begin
            if AMacro[AParsePos] = '(' then begin
                AParsePos += 1;
                ParseDecimalLevel1(AResult, AParsePos, AMacro);
                ParseSkipBlanks(AParsePos, AMacro);
                if CopyStr(AMacro, AParsePos, 1) = ')' then
                    AParsePos += 1;
            end else
                ParseDecimalLevel5(AResult, AParsePos, AMacro);

        end;
        ParseSkipBlanks(AParsePos, AMacro);
    end;

    local procedure ParseDecimalLevel5(var AResult: Decimal; var AParsePos: Integer; AMacro: Text[1024])
    var
        strName: Text[1024];
        txtParams: array[20] of Text[1024];
        txtTmp: Text[1024];
        intParamCount: Integer;
    begin
        ParseSkipBlanks(AParsePos, AMacro);
        if AParsePos <= StrLen(AMacro) then begin
            strName := ParseReadName(AParsePos, AMacro);
            // kintamasis arba funkcija
            if strName <> '' then begin
                if CopyStr(AMacro, AParsePos, 1) = '(' then begin
                    ParseReadFunctionParams(AParsePos, AMacro, intParamCount, txtParams);
                    CalcFunction(strName, intParamCount, txtParams, AResult, txtTmp);
                end else begin
                    // variable
                    if UpperCase(strName) = 'PI' then
                        AResult := 3.14
                    else
                        Error(Text001);
                end;
            end else
                // skaicius
                AResult := ParseReadDecimalValue(AParsePos, AMacro);
        end;
        ParseSkipBlanks(AParsePos, AMacro);
    end;

    //[Scope('OnPrem')]
    procedure CalcDecimalExpr(p_txtExpr: Text[1024]) decResult: Decimal
    var
        intPos: Integer;
    begin
        decResult := 0;
        intPos := 1;
        ParseDecimalLevel1(decResult, intPos, p_txtExpr);
        //MESSAGE(FORMAT(decResult));
    end;
}

