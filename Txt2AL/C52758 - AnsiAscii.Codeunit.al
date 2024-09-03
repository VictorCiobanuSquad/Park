codeunit 52758 "Ansi Ascii"
{

    trigger OnRun()
    begin
    end;

    var
        AnsiStr: Text[350];
        AsciiStr: Text[350];
        CharVar: array[200] of Char;
        AsciiNormal: Text[350];
        Ascii7Bits: Text[350];

    //[Scope('OnPrem')]
    procedure Ansi2Ascii(_Text: Text[350]): Text[350]
    begin
        MakeVars;
        exit(ConvertStr(_Text, AnsiStr, AsciiStr));
    end;

    //[Scope('OnPrem')]
    procedure Ascii2Ansi(_Text: Text[350]): Text[350]
    begin
        MakeVars;
        exit(ConvertStr(_Text, AsciiStr, AnsiStr));
    end;

    //[Scope('OnPrem')]
    procedure MakeVars()
    begin
        AsciiStr := ' ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+';
        AsciiStr := AsciiStr + '¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        CharVar[1] := 196;
        CharVar[2] := 197;
        CharVar[3] := 201;
        CharVar[4] := 242;
        CharVar[5] := 220;
        CharVar[6] := 186;
        CharVar[7] := 191;
        CharVar[8] := 188;
        CharVar[9] := 187;
        CharVar[10] := 193;
        CharVar[11] := 194;
        CharVar[12] := 192;
        CharVar[13] := 195;
        CharVar[14] := 202;
        CharVar[15] := 203;
        CharVar[16] := 200;
        CharVar[17] := 205;
        CharVar[18] := 206;
        CharVar[19] := 204;
        CharVar[20] := 175;
        CharVar[21] := 223;
        CharVar[22] := 213;
        CharVar[23] := 254;
        CharVar[24] := 218;
        CharVar[25] := 219;
        CharVar[26] := 217;
        CharVar[27] := 180;
        CharVar[28] := 177;
        CharVar[29] := 176;
        CharVar[30] := 185;
        CharVar[31] := 179;
        CharVar[32] := 178;
        AnsiStr := ' Ã³ÚÔõÓÕþÛÙÞ´¯ý' + Format(CharVar[1]) + Format(CharVar[2]) + Format(CharVar[3]) + 'µã¶÷' + Format(CharVar[4]);
        AnsiStr := AnsiStr + '¹¨ Í' + Format(CharVar[5]) + '°úÏÎâßÝ¾·±Ð¬' + Format(CharVar[6]) + Format(CharVar[7]);
        AnsiStr := AnsiStr + '«¼¢' + Format(CharVar[8]) + 'í½' + Format(CharVar[9]) + '___ªª' + Format(CharVar[10]) + Format(CharVar[11]);
        AnsiStr := AnsiStr + Format(CharVar[12]) + '®ªª++óÑ++--+-+Ò' + Format(CharVar[13]) + '++--ª-+ñ­ð';
        AnsiStr := AnsiStr + Format(CharVar[14]) + Format(CharVar[15]) + Format(CharVar[16]) + 'i' + Format(CharVar[17]) + Format(CharVar[18]);
        AnsiStr := AnsiStr + '¤++__ª' + Format(CharVar[19]) + Format(CharVar[20]) + 'Ë' + Format(CharVar[21]) + 'ÈÊ§';
        AnsiStr := AnsiStr + Format(CharVar[22]) + 'Á' + Format(CharVar[23]) + 'Ì' + Format(CharVar[24]) + Format(CharVar[25]);
        AnsiStr := AnsiStr + Format(CharVar[26]) + '²¦»' + Format(CharVar[27]) + '¡' + Format(CharVar[28]) + '=¥Âº¸©' + Format(CharVar[29]
        );
        AnsiStr := AnsiStr + '¿À' + Format(CharVar[30]) + Format(CharVar[31]) + Format(CharVar[32]) + '_ ';
    end;

    //[Scope('OnPrem')]
    procedure Ascii2Ascii7bit(_Text: Text[350]): Text[350]
    begin
        //**************************************************************************
        //HG 06.05.05 - TIRA OS CARACTERES PORTUGUESES - USADO NO QUADRO DE PESSOAL
        //**************************************************************************
        AsciiNormal := 'áàãéíóúçÁÀÃÉÍÓÚÇºª';
        Ascii7Bits := 'aaaeioucAAAEIOUCoa';
        exit(ConvertStr(_Text, AsciiNormal, Ascii7Bits));
    end;
}

