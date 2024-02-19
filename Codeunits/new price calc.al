codeunit 50013 "Price Calculation"
{
    var
        Currency: Record Currency;
        Qty: Decimal;
        GLSetup: Record "General Ledger Setup";
        ExchRateDate: Date;
        CurrencyFactor: Decimal;
        PricesInCurrency: Boolean;
        TempSalesLineDisc: Record "Sales Line Discount ET" temporary;
        QtyPerUOM: Decimal;
        ServicesET: Record "Services ET";
        DateCaption: Text[30];




    //[Scope('OnPrem')]
    procedure FindServiceLineLineDisc(UsersFamily: Record "Users Family"; var StudentLedgerEntry: Record "Student Ledger Entry")
    begin

        SetCurrency(UsersFamily."Currency Code", 0, 0D);
        //SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        Qty := 1;

        if StudentLedgerEntry.Type = StudentLedgerEntry.Type::Service then begin
            ServiceLineDiscExists(UsersFamily, StudentLedgerEntry, false);
            CalcBestLineDisc(TempSalesLineDisc);
            StudentLedgerEntry."Line Discount %" := TempSalesLineDisc."Line Discount %";

            //CalcBestServiceLineDisc(TempSalesLineDisc);
        end;
    end;

    //[Scope('OnPrem')]
    local procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.Get(CurrencyCode2);
            Currency.TestField("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        end else
            GLSetup.Get;
    end;

    //[Scope('OnPrem')]
    local procedure CalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount ET")
    var
        BestSalesLineDisc: Record "Sales Line Discount ET";
    begin
        //with SalesLineDisc do begin
        if SalesLineDisc.FindSet then
            repeat
                if IsInMinQty(SalesLineDisc."Unit of Measure Code", SalesLineDisc."Minimum Quantity") then
                    case true of
                        ((BestSalesLineDisc."Currency Code" = '') and (SalesLineDisc."Currency Code" <> '')) or
                      ((BestSalesLineDisc."Variant Code" = '') and (SalesLineDisc."Variant Code" <> '')):
                            BestSalesLineDisc := SalesLineDisc;
                        ((BestSalesLineDisc."Currency Code" = '') or (SalesLineDisc."Currency Code" <> '')) and
                      ((BestSalesLineDisc."Variant Code" = '') or (SalesLineDisc."Variant Code" <> '')):
                            if BestSalesLineDisc."Line Discount %" < SalesLineDisc."Line Discount %" then
                                BestSalesLineDisc := SalesLineDisc;
                    end;
            until SalesLineDisc.Next = 0;
        //end;

        SalesLineDisc := BestSalesLineDisc;
    end;

    //[Scope('OnPrem')]
    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    //[Scope('OnPrem')]
    procedure ServiceLineDiscExists(UsersFamily: Record "Users Family"; var StudentLedgerEntry: Record "Student Ledger Entry"; ShowAll: Boolean): Boolean
    var
        l_Customer: Record Customer;
        l_Student: Record Students;
    begin

        //with StudentLedgerEntry do
        if (StudentLedgerEntry.Type = StudentLedgerEntry.Type::Service) and ServicesET.Get(StudentLedgerEntry."Service Code") then begin

            //IF l_Users Family.get(StudentLedgerEntry."Entity ID") THEN

            if l_Student.Get(StudentLedgerEntry."Student No.") then begin
                if l_Student."Use Student Disc. Group" = true then begin
                    if l_Customer.Get(l_Student."Customer No.") then begin
                        if l_Customer."Allow Line Disc." then
                            FindServiceLineDisc(
                              TempSalesLineDisc, l_Student."Customer No.", '', l_Customer."Customer Disc. Group", '',
                              StudentLedgerEntry."Service Code", ServicesET."Service Disc. Group", '', '',
                              l_Customer."Currency Code", StudentLedgerEntry."Posting Date", ShowAll);
                    end;
                end else begin
                    if l_Customer.Get(StudentLedgerEntry."Entity Customer No.") then begin
                        if l_Customer."Allow Line Disc." then
                            FindServiceLineDisc(
                              TempSalesLineDisc, StudentLedgerEntry."Entity Customer No.", '', l_Customer."Customer Disc. Group", '',
                              StudentLedgerEntry."Service Code", ServicesET."Service Disc. Group", '', '',
                              l_Customer."Currency Code", StudentLedgerEntry."Posting Date", ShowAll);
                    end;
                end;
            end;



            exit(TempSalesLineDisc.Find('-'));
        end;
        exit(false);
    end;

    //[Scope('OnPrem')]
    procedure FindServiceLineDisc(var ToSalesLineDisc: Record "Sales Line Discount ET"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount ET";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin


        FromSalesLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromSalesLineDisc.SetFilter("Variant Code", '%1|%2', VariantCode, '');
        if not ShowAll then begin
            FromSalesLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesLineDisc.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
        end;

        ToSalesLineDisc.Reset;
        ToSalesLineDisc.DeleteAll;


        for FromSalesLineDisc."Sales Type" := FromSalesLineDisc."Sales Type"::Customer to FromSalesLineDisc."Sales Type"::Campaign do
            if (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"All Customers") or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Customer) and (CustNo <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Campaign) and
                   not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;


                FromSalesLineDisc.SetRange(FromSalesLineDisc."Sales Type", FromSalesLineDisc."Sales Type");
                case FromSalesLineDisc."Sales Type" of
                    FromSalesLineDisc."Sales Type"::"All Customers":
                        FromSalesLineDisc.SetRange("Sales Code");
                    FromSalesLineDisc."Sales Type"::Customer:
                        FromSalesLineDisc.SetRange("Sales Code", CustNo);
                    FromSalesLineDisc."Sales Type"::"Customer Disc. Group":
                        FromSalesLineDisc.SetRange("Sales Code", CustDiscGrCode);

                end;

                repeat
                    FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::Service);
                    FromSalesLineDisc.SetRange(Code, ItemNo);
                    CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                    if ItemDiscGrCode <> '' then begin
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::"Service Disc. Group");
                        FromSalesLineDisc.SetRange(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    end;

                until not InclCampaigns;
            end;
    end;

    //[Scope('OnPrem')]
    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line Discount ET"; var ToSalesLineDisc: Record "Sales Line Discount ET")
    begin
        if FromSalesLineDisc.FindSet then
            repeat
                if FromSalesLineDisc."Line Discount %" <> 0 then begin
                    ToSalesLineDisc := FromSalesLineDisc;
                    ToSalesLineDisc.Insert;
                end;
            until FromSalesLineDisc.Next = 0;
    end;

    procedure FindSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        //with SalesLine do begin
        SetCurrency(SalesHeader."Currency Code", 0, 0D);
        SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");

        SalesLine.TestField("Qty. per Unit of Measure");

        if SalesLine.Type = SalesLine.Type::Service then begin
            SalesLineLineDiscExists(SalesHeader, SalesLine, false);
            CalcBestLineDisc(TempSalesLineDisc);

            SalesLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
        end;
    end;
    //end;

    local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    procedure SalesLineLineDiscExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    begin
        //with SalesLine do
        if (SalesLine.Type = SalesLine.Type::Service) and ServicesET.Get(SalesLine."No.") then begin
            FindSalesLineDisc(
              TempSalesLineDisc, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
              SalesLine."Customer Disc. Group", '', SalesLine."No.", ServicesET."Service Disc. Group", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
              SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
            exit(TempSalesLineDisc.FindFirst);
        end;
        exit(false);
    end;

    procedure FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount ET"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount ET";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        //with FromSalesLineDisc do begin
        FromSalesLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromSalesLineDisc.SetFilter("Variant Code", '%1|%2', VariantCode, '');
        if not ShowAll then begin
            FromSalesLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesLineDisc.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
        end;

        ToSalesLineDisc.Reset;
        ToSalesLineDisc.DeleteAll;
        for FromSalesLineDisc."Sales Type" := FromSalesLineDisc."Sales Type"::Customer to FromSalesLineDisc."Sales Type"::Campaign do
            if (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"All Customers") or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Customer) and (CustNo <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Campaign) and
                not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;

                FromSalesLineDisc.SetRange("Sales Type", FromSalesLineDisc."Sales Type");
                case FromSalesLineDisc."Sales Type" of
                    FromSalesLineDisc."Sales Type"::"All Customers":
                        FromSalesLineDisc.SetRange("Sales Code");
                    FromSalesLineDisc."Sales Type"::Customer:
                        FromSalesLineDisc.SetRange("Sales Code", CustNo);
                    FromSalesLineDisc."Sales Type"::"Customer Disc. Group":
                        FromSalesLineDisc.SetRange("Sales Code", CustDiscGrCode);
                    FromSalesLineDisc."Sales Type"::Campaign:
                        begin
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                end;

                repeat
                    FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::Service);
                    FromSalesLineDisc.SetRange(Code, ItemNo);
                    CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                    if ItemDiscGrCode <> '' then begin
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::"Service Disc. Group");
                        FromSalesLineDisc.SetRange(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    end;

                    if InclCampaigns then begin
                        InclCampaigns := TempCampaignTargetGr.Next <> 0;
                        FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                    end;
                until not InclCampaigns;
            end;
    end;
    //end;

    local procedure SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        //with SalesHeader do
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then begin
            DateCaption := SalesHeader.FieldCaption("Posting Date");
            exit(SalesHeader."Posting Date")
        end else begin
            DateCaption := SalesHeader.FieldCaption("Order Date");
            exit(SalesHeader."Order Date");
        end;
    end;

    local procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
    begin
        //with FromCampaignTargetGr do begin
        ToCampaignTargetGr.Reset;
        ToCampaignTargetGr.DeleteAll;

        if CampaignNo <> '' then begin
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.Insert;
        end else begin
            FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Customer);
            FromCampaignTargetGr.SetRange("No.", CustNo);
            if FromCampaignTargetGr.FindSet then
                repeat
                    ToCampaignTargetGr := FromCampaignTargetGr;
                    ToCampaignTargetGr.Insert;
                until FromCampaignTargetGr.Next = 0
            else begin
                if Cont.Get(ContNo) then begin
                    FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SetRange("No.", Cont."Company No.");
                    if FromCampaignTargetGr.FindSet then
                        repeat
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.Insert;
                        until FromCampaignTargetGr.Next = 0;
                end;
            end;
        end;
        exit(ToCampaignTargetGr.FindFirst);
    end;
    //end;
    // procedure FindSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer)
    // begin
    //     with SalesLine do begin
    //         SetCurrency(
    //           SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));
    //         SetVAT(SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
    //         SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
    //         SetLineDisc("Line Discount %", "Allow Line Disc.", "Allow Invoice Disc.");

    //         TestField("Qty. per Unit of Measure");
    //         if PricesInCurrency then
    //             SalesHeader.TestField("Currency Factor");

    //         case Type of
    //             Type::Service:
    //                 begin
    //                     ServicesET.Get("No.");
    //                     SalesLinePriceExists(SalesHeader, SalesLine, false);
    //                     CalcBestUnitPrice(TempSalesPrice);

    //                     if FoundSalesPrice or
    //                        not ((CalledByFieldNo = FieldNo(Quantity)) or
    //                             (CalledByFieldNo = FieldNo("Variant Code")))
    //                     then begin
    //                         "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
    //                         "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
    //                         "Unit Price" := TempSalesPrice."Unit Price";
    //                     end;
    //                     if not "Allow Line Disc." then
    //                         "Line Discount %" := 0;
    //                 end;
    //         end;
    //     end;
    // end;
    //  local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    // begin
    //     with SalesHeader do begin
    //         if ("Document Type" in ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
    //            ("Posting Date" = 0D)
    //         then
    //             exit(WorkDate);
    //         exit("Posting Date");
    //     end;
    // end;
    // procedure SalesLinePriceExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    // begin
    //     with SalesLine do
    //         if (Type = Type::Service) and ServicesET.Get("No.") then begin
    //             FindSalesPrice(
    //               TempSalesPrice, "Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
    //               "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
    //               SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
    //             exit(TempSalesPrice.FindFirst);
    //         end;
    //     exit(false);
    // end;


}