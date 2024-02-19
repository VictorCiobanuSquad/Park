tableextension 50003 "Payment Terms Ext." extends "Payment Terms"
{
    fields
    {
        field(51001; "S&R Adjustment Base Date"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'S&R Adjustment Base Date';
            OptionMembers = " ","Post. Date","Doc. Date";
            OptionCaption = ' ,Post. Date,Doc. Date';
            Description = 'ADDED BY NCS PORTUGAL';
        }
        field(51002; "Adjustment Day 1"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ADDED BY NCS PORTUGAL';
            MinValue = 0;
            MaxValue = 31;

            trigger OnValidate()
            begin
                CheckAdjustmentDays();
            end;
        }
        field(51003; "Adjustment Day 2"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ADDED BY NCS PORTUGAL';
            MinValue = 0;
            MaxValue = 31;

            trigger OnValidate()
            begin
                IF "Adjustment Day 2" <> 0 THEN
                    IF "Adjustment Day 1" = 0 THEN ERROR(Text000, FIELDCAPTION("Adjustment Day 1"));
                CheckAdjustmentDays();
            end;
        }
        field(51004; "Adjustment Day 3"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ADDED BY NCS PORTUGAL';
            MinValue = 0;
            MaxValue = 31;

            trigger OnValidate()
            begin
                IF "Adjustment Day 3" <> 0 THEN
                    IF "Adjustment Day 2" = 0 THEN ERROR(Text000, FIELDCAPTION("Adjustment Day 1"));
                CheckAdjustmentDays();
            end;
        }
        field(51005; "Adjustment Day 4"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ADDED BY NCS PORTUGAL';
            MinValue = 0;
            MaxValue = 31;

            trigger OnValidate()
            begin
                IF "Adjustment Day 4" <> 0 THEN
                    IF "Adjustment Day 3" = 0 THEN ERROR(Text000, FIELDCAPTION("Adjustment Day 1"));
                CheckAdjustmentDays();
            end;
        }
        field(51006; "P&P Adjustment Base Date"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'P&P Adjustment Base Date';
            Description = 'ADDED BY NCS PORTUGAL';
            OptionMembers = " ","Post. Date","Doc. Date","Entry Date";
            OptionCaption = ' ,Post. Date,Doc. Date,Entry Date';

        }
    }

    var
        Text000: Label 'Os dias deve estar em ordem crescente e preenchidos a partir de %1';

    procedure CheckAdjustmentDays()
    var
        bError: Boolean;
    begin
        TESTFIELD("S&R Adjustment Base Date");

        IF "Adjustment Day 4" <> 0 THEN
            IF "Adjustment Day 3" >= "Adjustment Day 4" THEN bError := TRUE;

        IF "Adjustment Day 3" <> 0 THEN
            IF "Adjustment Day 2" >= "Adjustment Day 3" THEN bError := TRUE;

        IF "Adjustment Day 2" <> 0 THEN
            IF "Adjustment Day 1" >= "Adjustment Day 2" THEN bError := TRUE;

        IF bError THEN ERROR(Text000, FIELDCAPTION("Adjustment Day 1"));
    end;
}