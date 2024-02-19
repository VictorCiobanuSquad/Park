tableextension 50025 "Vendor Ledger Entry Ext." extends "Vendor Ledger Entry"
{
    fields
    {
        modify("On Hold")
        {
            trigger OnAfterValidate()
            begin
                //NCS
                "Automatic Hold" := FALSE;

                "rResponsibility Center".RESET;
                "rResponsibility Center".FIND('-');

                IF "rResponsibility Center".Treasurer <> UPPERCASE(USERID) THEN BEGIN
                    IF "On Hold" = '' THEN
                        IF xRec."Automatic Hold" THEN
                            UnHold
                        ELSE
                            xRec.TESTFIELD("On Hold", USERID)
                    ELSE BEGIN
                        IF NOT xRec."Automatic Hold" THEN
                            xRec.TESTFIELD("On Hold", '');
                        UnHold;
                        "On Hold" := UPPERCASE(USERID);
                    END;
                END;
                //
            end;
        }
        field(50000; "Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry Date';
        }
        field(50001; "Automatic Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Automatic Hold';
        }
    }

    var
        "rResponsibility Center": Record "Responsibility Center";
        Text51000: Label 'Não tem autorização ou valor do documento excede o seu limite de bloqueio';

    procedure Hold()
    //var "rMCT - Payment Hold Authoriz.": Record "MCT - Payment Hold Authoriz.";
    begin
        /*"rMCT - Payment Hold Authoriz.".RESET;
        "rMCT - Payment Hold Authoriz.".SETRANGE("User ID",USERID);
        IF NOT "rMCT - Payment Hold Authoriz.".FIND('-') THEN
            ERROR(Text51000);

        CALCFIELDS("Amount (LCY)");
        IF ABS("Amount (LCY)") > ABS("rMCT - Payment Hold Authoriz."."Max. Amount") THEN
            ERROR(Text51000);
        "On Hold" := UPPERCASE(USERID);*/
    end;

    procedure UnHold()
    //var "rMCT - Payment Hold Authoriz.": Record "MCT - Payment Hold Authoriz.";
    begin
        /*"rMCT - Payment Hold Authoriz.".RESET;
        "rMCT - Payment Hold Authoriz.".SETRANGE("User ID",USERID);
        IF NOT "rMCT - Payment Hold Authoriz.".FIND('-') THEN
            ERROR(Text51000);

        CALCFIELDS("Amount (LCY)");
        IF ABS("Amount (LCY)") > ABS("rMCT - Payment Hold Authoriz."."Max. Amount") THEN
            ERROR(Text51000);*/
    end;
}