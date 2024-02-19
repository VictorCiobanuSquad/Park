codeunit 50000 "NoSeries Custom"
{
    trigger OnRun()
    begin

    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Record "No. Series";
        LastNoSeriesLine: Record "No. Series Line";
        WarningNoSeriesCode: Code[20];
        TryNoSeriesCode: Code[20];
        Text004: Label 'You cannot assign new numbers from the number series %1 on %2.';
        Text005: Label 'You cannot assign new numbers from the number series %1.';
        Text006: Label 'You cannot assign new numbers from the number series %1 on a date before %2.';
        Text007: Label 'You cannot assign numbers greater than %1 from the number series %2.';

    procedure GetNextNoMultiCompany(pNoSeriesCode: Code[10]; SeriesDate: Date; ModifySeries: Boolean; pCompany: Text[30]): Code[20]
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        //C+ - MultiCompany get next number
        IF SeriesDate = 0D THEN
            SeriesDate := WORKDATE;

        CLEAR(NoSeriesLine);
        NoSeriesLine.RESET;
        //IF pCompany <> '' THEN
        //  NoSeriesLine.CHANGECOMPANY(pCompany);

        IF ModifySeries OR (LastNoSeriesLine."Series Code" = '') THEN BEGIN
            IF ModifySeries THEN
                NoSeriesLine.LOCKTABLE;
            CLEAR(NoSeries);
            NoSeries.RESET;
            IF pCompany <> '' THEN
                NoSeries.CHANGECOMPANY(pCompany);

            NoSeries.GET(pNoSeriesCode);

            //SetNoSeriesLineFilterMC(NoSeriesLine,NoSeriesCode,SeriesDate,pCompany);
            IF SeriesDate = 0D THEN
                SeriesDate := WORKDATE;

            NoSeriesLine.SETCURRENTKEY("Series Code", "Starting Date");
            NoSeriesLine.SETRANGE("Series Code", pNoSeriesCode);
            NoSeriesLine.SETRANGE("Starting Date", 0D, SeriesDate);
            IF NoSeriesLine.FINDLAST THEN BEGIN
                NoSeriesLine.SETRANGE("Starting Date", NoSeriesLine."Starting Date");
                NoSeriesLine.SETRANGE(Open, TRUE);
            END;

            IF NOT NoSeriesLine.FINDFIRST THEN BEGIN
                NoSeriesLine.SETRANGE("Starting Date");
                IF NOT NoSeriesLine.ISEMPTY THEN
                    ERROR(Text004, pNoSeriesCode, SeriesDate);
                ERROR(Text005, pNoSeriesCode);
            END;
        END ELSE
            NoSeriesLine := LastNoSeriesLine;

        IF NoSeries."Date Order" AND (SeriesDate < NoSeriesLine."Last Date Used") THEN
            ERROR(Text006, NoSeries.Code, NoSeriesLine."Last Date Used");
        NoSeriesLine."Last Date Used" := SeriesDate;
        IF NoSeriesLine."Last No. Used" = '' THEN BEGIN
            NoSeriesLine.TESTFIELD("Starting No.");
            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No.";
        END ELSE
            IF NoSeriesLine."Increment-by No." <= 1 THEN
                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
            ELSE
                NoSeriesMgt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
        IF (NoSeriesLine."Ending No." <> '') AND
        (NoSeriesLine."Last No. Used" > NoSeriesLine."Ending No.")
        THEN
            ERROR(Text007, NoSeriesLine."Ending No.", pNoSeriesCode);
        IF (NoSeriesLine."Ending No." <> '') AND
        (NoSeriesLine."Warning No." <> '') AND
        (NoSeriesLine."Last No. Used" >= NoSeriesLine."Warning No.") AND
        (pNoSeriesCode <> WarningNoSeriesCode) AND
        (TryNoSeriesCode = '')
        THEN BEGIN
            WarningNoSeriesCode := pNoSeriesCode;
            MESSAGE(Text007, NoSeriesLine."Ending No.", pNoSeriesCode);
        END;

        NoSeriesLine.VALIDATE(Open);

        IF ModifySeries THEN
            NoSeriesLine.MODIFY
        ELSE
            LastNoSeriesLine := NoSeriesLine;
        EXIT(NoSeriesLine."Last No. Used");
    end;
}