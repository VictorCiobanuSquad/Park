tableextension 50287 "Customer Bank Account Ext." extends "Customer Bank Account"
{
    fields
    {
        modify(IBAN)
        {
            trigger OnAfterValidate()
            var
                Text0001: Label 'O Swift foi alterado para: %1.';
            begin
                //Normatica 2014.07.16
                IF COPYSTR(IBAN, 5, 4) = '0001' THEN "SWIFT Code" := 'BGALPTTG';
                IF COPYSTR(IBAN, 5, 4) = '0007' THEN "SWIFT Code" := 'BESCPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0008' THEN "SWIFT Code" := 'BAIPPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0010' THEN "SWIFT Code" := 'BBPIPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0012' THEN "SWIFT Code" := 'CDACPTPA';
                IF COPYSTR(IBAN, 5, 4) = '0014' THEN "SWIFT Code" := 'IVVSPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0018' THEN "SWIFT Code" := 'TOTAPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0019' THEN "SWIFT Code" := 'BBVAPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0022' THEN "SWIFT Code" := 'BRASPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0023' THEN "SWIFT Code" := 'ACTVPTPL';//corrigido 2015.04.15
                IF COPYSTR(IBAN, 5, 4) = '0032' THEN "SWIFT Code" := 'BARCPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0033' THEN "SWIFT Code" := 'BCOMPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0035' THEN "SWIFT Code" := 'CGDIPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0036' THEN "SWIFT Code" := 'MPIOPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0038' THEN "SWIFT Code" := 'BNIFPTPL';//Corrigido
                IF COPYSTR(IBAN, 5, 4) = '0043' THEN "SWIFT Code" := 'DEUTPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0045' THEN "SWIFT Code" := 'CCCMPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0046' THEN "SWIFT Code" := 'CRBNPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0061' THEN "SWIFT Code" := 'BDIGPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0065' THEN "SWIFT Code" := 'BESZPTPL';//Corrigido
                IF COPYSTR(IBAN, 5, 4) = '0079' THEN "SWIFT Code" := 'BPNPPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0086' THEN "SWIFT Code" := 'EFISPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0097' THEN "SWIFT Code" := 'CCCHPTP1';
                IF COPYSTR(IBAN, 5, 4) = '0099' THEN "SWIFT Code" := 'CSSOPTPX';
                IF COPYSTR(IBAN, 5, 4) = '0160' THEN "SWIFT Code" := 'BESAPTPA';
                IF COPYSTR(IBAN, 5, 4) = '0183' THEN "SWIFT Code" := 'PRTTPTP1';
                IF COPYSTR(IBAN, 5, 4) = '0188' THEN "SWIFT Code" := 'BCCBPTPL';
                IF COPYSTR(IBAN, 5, 4) = '0244' THEN "SWIFT Code" := 'MPCGPTP1';
                IF COPYSTR(IBAN, 5, 4) = '0269' THEN "SWIFT Code" := 'BKBKPTPL';//criado em 2016.10.14
                IF COPYSTR(IBAN, 5, 4) = '0781' THEN "SWIFT Code" := 'IGCPPTPL';
                IF COPYSTR(IBAN, 5, 4) = '5180' THEN "SWIFT Code" := 'CDCTPTP2';
                IF COPYSTR(IBAN, 5, 4) = '0170' THEN "SWIFT Code" := 'CAGLPTPL';

                MESSAGE(Text0001, "SWIFT Code");
            end;
        }
    }
}