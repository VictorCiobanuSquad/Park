tableextension 50038 "Purchase Header Ext." extends "Purchase Header"
{
    fields
    {
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            var
                PaymentTerms: Record "Payment Terms";
                nDueDay: Integer;
            begin
                //C+_RSC_C+ - 2010.04.15 - Associar a data de vencimento à data de entrad
                if PaymentTerms.get("Payment Terms Code") and ("Document Date" <> 0D) then begin
                    IF not (("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) AND
                        NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos") then begin
                        case PaymentTerms."P&P Adjustment Base Date" of
                            PaymentTerms."P&P Adjustment Base Date"::"Post. Date":
                                "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Posting Date");
                            PaymentTerms."P&P Adjustment Base Date"::"Entry Date":
                                "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Entry Date");
                        end;
                        "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation", "Entry Date");
                    end;

                    nDueDay := DATE2DMY("Due Date", 1);
                    IF PaymentTerms."P&P Adjustment Base Date" <> PaymentTerms."P&P Adjustment Base Date"::" " THEN
                        IF nDueDay <= PaymentTerms."Adjustment Day 1" THEN
                            nDueDay := PaymentTerms."Adjustment Day 1"
                        ELSE
                            IF nDueDay <= PaymentTerms."Adjustment Day 2" THEN
                                nDueDay := PaymentTerms."Adjustment Day 2"
                            ELSE
                                IF nDueDay <= PaymentTerms."Adjustment Day 3" THEN
                                    nDueDay := PaymentTerms."Adjustment Day 3"
                                ELSE
                                    IF nDueDay <= PaymentTerms."Adjustment Day 4" THEN
                                        nDueDay := PaymentTerms."Adjustment Day 4"
                                    ELSE
                                        nDueDay := PaymentTerms."Adjustment Day 1";

                    IF nDueDay <> 0 THEN
                        "Due Date" := CalculateDate("Due Date", nDueDay);
                end;
            end;
        }
        field(50000; "Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry Date';

            trigger OnValidate()
            begin
                VALIDATE("Payment Terms Code");
            end;
        }
    }

    procedure CalculateDate(StartingDate: Date; NewDay: Integer): Date
    var
        NewYear: Integer;
        NewMonth: Integer;
        LocalDate: Date;
    begin
        NewYear := DATE2DMY(StartingDate, 3);
        NewMonth := DATE2DMY(StartingDate, 2);

        IF NewDay < DATE2DMY(StartingDate, 1) THEN NewMonth := NewMonth + 1;
        IF NewMonth > 12 THEN BEGIN
            NewMonth := 1;
            NewYear := NewYear + 1;
        END;

        IF (NewMonth = 2) AND (NewDay > 28) THEN BEGIN
            NewDay := 28;
            LocalDate := DMY2DATE(28, 2, NewYear) + 1;
            IF DATE2DMY(LocalDate, 1) = 29 THEN
                NewDay := 29;
        END;

        CASE NewMonth OF
            4, 6, 9, 11:
                IF NewDay = 31 THEN
                    NewDay := 30;
        END;

        EXIT(DMY2DATE(NewDay, NewMonth, NewYear));
    end;
}