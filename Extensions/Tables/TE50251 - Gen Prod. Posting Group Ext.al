tableextension 50251 "Gen. Prod. Posting Group Ext." extends "Gen. Product Posting Group"
{
    /*
    //IT001 - Parque 2016.09.30 - para mudar nos serviços
    */
    fields
    {
        modify("Def. VAT Prod. Posting Group")
        {
            trigger OnAfterValidate()
            var
                Text000: Label 'Change all occurrences of %1 in %2\where %3 is %4\and %1 is %5.';
                ServicesET: Record "Services ET";
                ServicesET2: Record "Services ET";
            begin
                //IT001 - Parque 2016.09.30 - para mudar nos serviços
                IF CONFIRM(
                    Text000, FALSE,
                    ServicesET.FIELDCAPTION("VAT Serv. Posting Group"), ServicesET.TABLECAPTION,
                    ServicesET.FIELDCAPTION("Gen. Serv. Posting Group"), Code,
                    xRec."Def. VAT Prod. Posting Group")
                THEN BEGIN
                    ServicesET.SETCURRENTKEY("Gen. Serv. Posting Group");
                    ServicesET.SETRANGE("Gen. Serv. Posting Group", Code);
                    ServicesET.SETRANGE("VAT Serv. Posting Group", xRec."Def. VAT Prod. Posting Group");
                    IF ServicesET.FIND('-') THEN
                        REPEAT
                            ServicesET2 := ServicesET;
                            ServicesET2."VAT Serv. Posting Group" := "Def. VAT Prod. Posting Group";
                            ServicesET2.MODIFY;
                        UNTIL ServicesET.NEXT = 0;
                END;
                //IT001 - Parque 2016.09.30 - en
            end;
        }
    }
}