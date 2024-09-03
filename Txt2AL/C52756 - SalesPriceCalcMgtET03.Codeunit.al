codeunit 52756 "Sales Price Calc. Mgt.ET03"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        ResPrice: Record "Resource Price";
        Res: Record Resource;
        Currency: Record Currency;
        Text000: Label '%1 is less than %2 in the %3.';
        Text010: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        TempSalesPrice: Record "Sales Price" temporary;
        TempSalesLineDisc: Record "Sales Line Discount ET" temporary;
        ResFindUnitPrice: Codeunit "Resource-Find Price";
        LineDiscPerCent: Decimal;
        Qty: Decimal;
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        // VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        //backup
        VATCalcType: Enum "Tax Calculation Type";
        VATBusPostingGr: Code[10];
        QtyPerUOM: Decimal;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        Text018: Label '%1 %2 is greater than %3 and was adjusted to %4.';
        FoundSalesPrice: Boolean;
        Text001: Label 'The %1 in the %2 must be same as in the %3.';
        HideResUnitPriceMessage: Boolean;
        DateCaption: Text[30];
        ServicesET: Record "Services ET";

    //[Scope('OnPrem')]
    procedure FindSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer)
    begin
        with SalesLine do begin
            SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));
            SetVAT(SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            SetLineDisc("Line Discount %", "Allow Line Disc.", "Allow Invoice Disc.");

            TestField("Qty. per Unit of Measure");
            if PricesInCurrency then
                SalesHeader.TestField("Currency Factor");

            case Type of
                Type::Service:
                    begin
                        ServicesET.Get("No.");
                        SalesLinePriceExists(SalesHeader, SalesLine, false);
                        CalcBestUnitPrice(TempSalesPrice);

                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then begin
                            "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                            "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                            "Unit Price" := TempSalesPrice."Unit Price";
                        end;
                        if not "Allow Line Disc." then
                            "Line Discount %" := 0;
                    end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindItemJnlLinePrice(var ItemJnlLine: Record "Item Journal Line"; CalledByFieldNo: Integer)
    begin
        with ItemJnlLine do begin
            SetCurrency('', 0, 0D);
            SetVAT(false, 0, VATCalcType::"Normal VAT", '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            Item.Get("Item No.");

            FindSalesPrice(
              TempSalesPrice, '', '', '', '', "Item No.", "Variant Code",
              "Unit of Measure Code", '', "Posting Date", false);
            CalcBestUnitPrice(TempSalesPrice);
            if FoundSalesPrice or
               not ((CalledByFieldNo = FieldNo(Quantity)) or
                    (CalledByFieldNo = FieldNo("Variant Code")))
            then
                Validate("Unit Amount", TempSalesPrice."Unit Price");
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; CalledByFieldNo: Integer)
    var
        ServCost: Record "Service Cost";
        Res: Record Resource;
    begin
        with ServLine do begin
            ServHeader.Get("Document Type", "Document No.");
            if Type <> Type::" " then begin
                SetCurrency(
                  ServHeader."Currency Code", ServHeader."Currency Factor", ServHeaderExchDate(ServHeader));
                SetVAT(ServHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                SetLineDisc("Line Discount %", "Allow Line Disc.", false);

                TestField("Qty. per Unit of Measure");
                if PricesInCurrency then
                    ServHeader.TestField("Currency Factor");
            end;

            case Type of
                Type::Item:
                    begin
                        Item.Get("No.");
                        FindSalesPrice(
                          TempSalesPrice, "Bill-to Customer No.", ServHeader."Contact No.",
                          "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                          ServHeader."Currency Code", ServHeader."Order Date", false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then begin
                            if "Line Discount Type" = "Line Discount Type"::"Line Disc." then
                                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                            "Unit Price" := TempSalesPrice."Unit Price";
                        end;
                        if not "Allow Line Disc." and ("Line Discount Type" = "Line Discount Type"::"Line Disc.") then
                            "Line Discount %" := 0;
                    end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
            SetCurrency(SalesHeader."Currency Code", 0, 0D);
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            TestField("Qty. per Unit of Measure");

            if Type = Type::Service then begin
                SalesLineLineDiscExists(SalesHeader, SalesLine, false);
                CalcBestLineDisc(TempSalesLineDisc);

                "Line Discount %" := TempSalesLineDisc."Line Discount %";
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindServLineDisc(ServHeader: Record "Service Header"; var ServInvLine: Record "Service Line")
    begin
        with ServInvLine do begin
            SetCurrency(ServHeader."Currency Code", 0, 0D);
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            TestField("Qty. per Unit of Measure");

            if Type = Type::Item then begin
                Item.Get("No.");
                FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", ServHeader."Contact No.",
                  "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code",
                  "Unit of Measure Code", ServHeader."Currency Code", ServHeader."Order Date", false);
                CalcBestLineDisc(TempSalesLineDisc);
                "Line Discount %" := TempSalesLineDisc."Line Discount %";
            end;
            if Type in [Type::Resource, Type::Cost, Type::"G/L Account"] then begin
                "Line Discount %" := 0;
                "Line Discount Amount" :=
                  Round(
                    Round(CalcChargeableQty * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindStdItemJnlLinePrice(var StdItemJnlLine: Record "Standard Item Journal Line"; CalledByFieldNo: Integer)
    begin
        with StdItemJnlLine do begin
            SetCurrency('', 0, 0D);
            SetVAT(false, 0, VATCalcType::"Normal VAT", '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            Item.Get("Item No.");

            FindSalesPrice(
              TempSalesPrice, '', '', '', '', "Item No.", "Variant Code",
              "Unit of Measure Code", '', WorkDate, false);
            CalcBestUnitPrice(TempSalesPrice);
            if FoundSalesPrice or
               not ((CalledByFieldNo = FieldNo(Quantity)) or
                    (CalledByFieldNo = FieldNo("Variant Code")))
            then
                Validate("Unit Amount", TempSalesPrice."Unit Price");
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindAnalysisReportPrice(ItemNo: Code[20]; Date: Date): Decimal
    begin
        SetCurrency('', 0, 0D);
        SetVAT(false, 0, 0, '');
        SetVAT(false, 0, VATCalcType::"Normal VAT", '');
        SetUoM(0, 1);
        Item.Get(ItemNo);

        FindSalesPrice(TempSalesPrice, '', '', '', '', ItemNo, '', '', '', Date, false);
        CalcBestUnitPrice(TempSalesPrice);
        if FoundSalesPrice then
            exit(TempSalesPrice."Unit Price");
        exit(Item."Unit Price");
    end;

    local procedure CalcBestUnitPrice(var SalesPrice: Record "Sales Price")
    var
        BestSalesPrice: Record "Sales Price";
    begin
        with SalesPrice do begin
            FoundSalesPrice := FindSet;
            if FoundSalesPrice then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity") then begin
                        ConvertPriceToVAT(
                          "Price Includes VAT", Item."VAT Prod. Posting Group",
                          "VAT Bus. Posting Gr. (Price)", "Unit Price");
                        ConvertPriceToUoM("Unit of Measure Code", "Unit Price");
                        ConvertPriceLCYToFCY("Currency Code", "Unit Price");

                        case true of
                            ((BestSalesPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                          ((BestSalesPrice."Variant Code" = '') and ("Variant Code" <> '')):
                                BestSalesPrice := SalesPrice;
                            ((BestSalesPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesPrice."Variant Code" = '') or ("Variant Code" <> '')):
                                if (BestSalesPrice."Unit Price" = 0) or
                                   (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                                then
                                    BestSalesPrice := SalesPrice;
                        end;
                    end;
                until Next = 0;
        end;

        // No price found in agreement
        if BestSalesPrice."Unit Price" = 0 then begin
            ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceToUoM('', Item."Unit Price");
            ConvertPriceLCYToFCY('', Item."Unit Price");

            Clear(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := AllowLineDisc;
            BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
        end;

        SalesPrice := BestSalesPrice;
    end;

    local procedure CalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount ET")
    var
        BestSalesLineDisc: Record "Sales Line Discount ET";
    begin
        with SalesLineDisc do begin
            if FindSet then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity") then
                        case true of
                            ((BestSalesLineDisc."Currency Code" = '') and ("Currency Code" <> '')) or
                          ((BestSalesLineDisc."Variant Code" = '') and ("Variant Code" <> '')):
                                BestSalesLineDisc := SalesLineDisc;
                            ((BestSalesLineDisc."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesLineDisc."Variant Code" = '') or ("Variant Code" <> '')):
                                if BestSalesLineDisc."Line Discount %" < "Line Discount %" then
                                    BestSalesLineDisc := SalesLineDisc;
                        end;
                until Next = 0;
        end;

        SalesLineDisc := BestSalesLineDisc;
    end;

    //[Scope('OnPrem')]
    procedure FindSalesPrice(var ToSalesPrice: Record "Sales Price"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesPrice: Record "Sales Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        with FromSalesPrice do begin
            SetRange("Item No.", ItemNo);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            if not ShowAll then begin
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
                SetRange("Starting Date", 0D, StartingDate);
            end;

            ToSalesPrice.Reset;
            ToSalesPrice.DeleteAll;

            SetRange("Sales Type", "Sales Type"::"All Customers");
            SetRange("Sales Code");
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

            if CustNo <> '' then begin
                SetRange("Sales Type", "Sales Type"::Customer);
                SetRange("Sales Code", CustNo);
                CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if CustPriceGrCode <> '' then begin
                SetRange("Sales Type", "Sales Type"::"Customer Price Group");
                SetRange("Sales Code", CustPriceGrCode);
                CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
                SetRange("Sales Type", "Sales Type"::Campaign);
                if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                    repeat
                        SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                    until TempTargetCampaignGr.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount ET"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount ET";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        with FromSalesLineDisc do begin
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;
            for "Sales Type" := "Sales Type"::Customer to "Sales Type"::Campaign do
                if ("Sales Type" = "Sales Type"::"All Customers") or
                   (("Sales Type" = "Sales Type"::Customer) and (CustNo <> '')) or
                   (("Sales Type" = "Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
                   (("Sales Type" = "Sales Type"::Campaign) and
                    not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
                then begin
                    InclCampaigns := false;

                    SetRange("Sales Type", "Sales Type");
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            SetRange("Sales Code");
                        "Sales Type"::Customer:
                            SetRange("Sales Code", CustNo);
                        "Sales Type"::"Customer Disc. Group":
                            SetRange("Sales Code", CustDiscGrCode);
                        "Sales Type"::Campaign:
                            begin
                                InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                                SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                            end;
                    end;

                    repeat
                        SetRange(Type, Type::Service);
                        SetRange(Code, ItemNo);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                        if ItemDiscGrCode <> '' then begin
                            SetRange(Type, Type::"Service Disc. Group");
                            SetRange(Code, ItemDiscGrCode);
                            CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                        end;

                        if InclCampaigns then begin
                            InclCampaigns := TempCampaignTargetGr.Next <> 0;
                            SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                    until not InclCampaigns;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopySalesPrice(var SalesPrice: Record "Sales Price")
    begin
        SalesPrice.DeleteAll;
        CopySalesPriceToSalesPrice(TempSalesPrice, SalesPrice);
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price"; var ToSalesPrice: Record "Sales Price")
    begin
        with ToSalesPrice do begin
            if FromSalesPrice.FindSet then
                repeat
                    if FromSalesPrice."Unit Price" <> 0 then begin
                        ToSalesPrice := FromSalesPrice;
                        Insert;
                    end;
                until FromSalesPrice.Next = 0;
        end;
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line Discount ET"; var ToSalesLineDisc: Record "Sales Line Discount ET")
    begin
        with ToSalesLineDisc do begin
            if FromSalesLineDisc.FindSet then
                repeat
                    if FromSalesLineDisc."Line Discount %" <> 0 then begin
                        ToSalesLineDisc := FromSalesLineDisc;
                        Insert;
                    end;
                until FromSalesLineDisc.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure SetResPrice(JobNo: Code[20]; Code2: Code[20]; WorkTypeCode: Code[10]; CurrencyCode: Code[10])
    begin
        with ResPrice do begin
            Init;
            //"Job No." := JobNo;
            Code := Code2;
            "Work Type Code" := WorkTypeCode;
            "Currency Code" := CurrencyCode;
        end;
    end;

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

    // local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[10])
    // begin
    //     PricesInclVAT := PriceInclVAT2;
    //     VATPerCent := VATPerCent2;
    //     VATCalcType := VATCalcType2;
    //     VATBusPostingGr := VATBusPostingGr2;
    // end;
    //original

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Enum "Tax Calculation Type"; VATBusPostingGr2: Code[10])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    local procedure SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[10]; FromVATBusPostingGr: Code[10]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);

            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case VATCalcType of
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    begin
                        if PricesInclVAT then begin
                            if VATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := Round(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure CalcLineAmount(SalesPrice: Record "Sales Price"): Decimal
    begin
        with SalesPrice do begin
            if "Allow Line Disc." then
                exit("Unit Price" * (1 - LineDiscPerCent / 100));
            exit("Unit Price");
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLinePriceExists(SalesHeader, SalesLine, true);

        with SalesLine do
            if PAGE.RunModal(PAGE::"Get Sales Price", TempSalesPrice) = ACTION::LookupOK then begin
                SetVAT(
                  SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                SetCurrency(
                  SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));

                if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                    Error(
                      Text000,
                      FieldCaption(Quantity),
                      TempSalesPrice.FieldCaption("Minimum Quantity"),
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesPrice.FieldCaption("Starting Date"),
                      TempSalesPrice.TableCaption);

                ConvertPriceToVAT(
                  TempSalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
                ConvertPriceToUoM("Unit of Measure Code", TempSalesPrice."Unit Price");
                ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                if not "Allow Line Disc." then
                    "Line Discount %" := 0;

                Validate("Unit Price", TempSalesPrice."Unit Price");
            end;
    end;

    //[Scope('OnPrem')]
    procedure GetSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLineLineDiscExists(SalesHeader, SalesLine, true);

        with SalesLine do
            if PAGE.RunModal(PAGE::"Get Sales Line Disc.", TempSalesLineDisc) = ACTION::LookupOK then begin
                SetCurrency(SalesHeader."Currency Code", 0, 0D);
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

                if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
                then
                    Error(
                      Text000, FieldCaption(Quantity),
                      TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if TempSalesLineDisc."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesLineDisc.FieldCaption("Starting Date"),
                      TempSalesLineDisc.TableCaption);

                TestField("Allow Line Disc.");
                Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
    end;

    //[Scope('OnPrem')]
    procedure SalesLinePriceExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    begin
        with SalesLine do
            if (Type = Type::Service) and ServicesET.Get("No.") then begin
                FindSalesPrice(
                  TempSalesPrice, "Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                  "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                  SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                exit(TempSalesPrice.FindFirst);
            end;
        exit(false);
    end;

    //[Scope('OnPrem')]
    procedure SalesLineLineDiscExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    begin
        with SalesLine do
            if (Type = Type::Service) and ServicesET.Get("No.") then begin
                FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                  "Customer Disc. Group", '', "No.", ServicesET."Service Disc. Group", "Variant Code", "Unit of Measure Code",
                  SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                exit(TempSalesLineDisc.FindFirst);
            end;
        exit(false);
    end;

    //[Scope('OnPrem')]
    procedure GetServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
        ServLinePriceExists(ServHeader, ServLine, true);

        with ServLine do
            if PAGE.RunModal(PAGE::"Get Sales Price", TempSalesPrice) = ACTION::LookupOK then begin
                SetVAT(
                  ServHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                SetCurrency(
                  ServHeader."Currency Code", ServHeader."Currency Factor", ServHeaderExchDate(ServHeader));

                if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                    Error(
                      Text000,
                      FieldCaption(Quantity),
                      TempSalesPrice.FieldCaption("Minimum Quantity"),
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if TempSalesPrice."Starting Date" > ServHeaderStartDate(ServHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesPrice.FieldCaption("Starting Date"),
                      TempSalesPrice.TableCaption);

                ConvertPriceToVAT(
                  TempSalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
                ConvertPriceToUoM("Unit of Measure Code", TempSalesPrice."Unit Price");
                ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                if not "Allow Line Disc." then
                    "Line Discount %" := 0;

                Validate("Unit Price", TempSalesPrice."Unit Price");
                ConfirmAdjPriceLineChange;
            end;
    end;

    //[Scope('OnPrem')]
    procedure GetServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
        ServLineLineDiscExists(ServHeader, ServLine, true);

        with ServLine do
            if PAGE.RunModal(PAGE::"Get Sales Line Disc.", TempSalesLineDisc) = ACTION::LookupOK then begin
                SetCurrency(ServHeader."Currency Code", 0, 0D);
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

                if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
                then
                    Error(
                      Text000, FieldCaption(Quantity),
                      TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if TempSalesLineDisc."Starting Date" > ServHeaderStartDate(ServHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesLineDisc.FieldCaption("Starting Date"),
                      TempSalesLineDisc.TableCaption);

                TestField("Allow Line Disc.");
                CheckLineDiscount(TempSalesLineDisc."Line Discount %");
                Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
                ConfirmAdjPriceLineChange;
            end;
    end;

    //[Scope('OnPrem')]
    procedure ServLinePriceExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                FindSalesPrice(
                  TempSalesPrice, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                  "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                  ServHeader."Currency Code", ServHeaderStartDate(ServHeader, DateCaption), ShowAll);
                exit(TempSalesPrice.Find('-'));
            end;
        exit(false);
    end;

    //[Scope('OnPrem')]
    procedure ServLineLineDiscExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                  "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  ServHeader."Currency Code", ServHeaderStartDate(ServHeader, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
    begin
        with FromCampaignTargetGr do begin
            ToCampaignTargetGr.Reset;
            ToCampaignTargetGr.DeleteAll;

            if CampaignNo <> '' then begin
                ToCampaignTargetGr."Campaign No." := CampaignNo;
                ToCampaignTargetGr.Insert;
            end else begin
                SetRange(Type, Type::Customer);
                SetRange("No.", CustNo);
                if FindSet then
                    repeat
                        ToCampaignTargetGr := FromCampaignTargetGr;
                        ToCampaignTargetGr.Insert;
                    until Next = 0
                else begin
                    if Cont.Get(ContNo) then begin
                        SetRange(Type, Type::Contact);
                        SetRange("No.", Cont."Company No.");
                        if FindSet then
                            repeat
                                ToCampaignTargetGr := FromCampaignTargetGr;
                                ToCampaignTargetGr.Insert;
                            until Next = 0;
                    end;
                end;
            end;
            exit(ToCampaignTargetGr.FindFirst);
        end;
    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        with SalesHeader do begin
            if ("Document Type" in ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
               ("Posting Date" = 0D)
            then
                exit(WorkDate);
            exit("Posting Date");
        end;
    end;

    local procedure SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        with SalesHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                DateCaption := FieldCaption("Order Date");
                exit("Order Date");
            end;
    end;

    local procedure ServHeaderExchDate(ServHeader: Record "Service Header"): Date
    begin
        with ServHeader do begin
            if ("Document Type" = "Document Type"::Quote) and
               ("Posting Date" = 0D)
            then
                exit(WorkDate);
            exit("Posting Date");
        end;
    end;

    local procedure ServHeaderStartDate(ServHeader: Record "Service Header"; var DateCaption: Text[30]): Date
    begin
        with ServHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                DateCaption := FieldCaption("Order Date");
                exit("Order Date");
            end;
    end;

    //[Scope('OnPrem')]
    procedure NoOfSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLinePriceExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;

    //[Scope('OnPrem')]
    procedure NoOfSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLineLineDiscExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;

    //[Scope('OnPrem')]
    procedure NoOfServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLinePriceExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;

    //[Scope('OnPrem')]
    procedure NoOfServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLineLineDiscExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;

    //[Scope('OnPrem')]
    procedure FindJobPlanningLinePrice(var JobPlanningLine: Record "Job Planning Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
    begin
        with JobPlanningLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Planning Date");
            SetVAT(false, 0, VATCalcType::"Normal VAT", '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            case Type of
                Type::Item:
                    begin
                        Job.Get("Job No.");
                        Item.Get("No.");
                        TestField("Qty. per Unit of Measure");
                        FindSalesPrice(
                          TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                          Job."Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                          Job."Currency Code", "Planning Date", false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then
                            "Unit Price" := TempSalesPrice."Unit Price";
                    end;
                Type::Resource:
                    begin
                        Job.Get("Job No.");
                        SetResPrice("Job No.", "No.", "Work Type Code", "Currency Code");
                        ResFindUnitPrice.Run(ResPrice);
                        ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                        "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
                    end;

            end;
        end;
        JobPlanningLineFindJTPrice(JobPlanningLine);
    end;

    //[Scope('OnPrem')]
    procedure JobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        with JobPlanningLine do begin
            case Type of
                Type::Item:
                    begin
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        JobItemPrice.SetRange("Variant Code", "Variant Code");
                        JobItemPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        JobItemPrice.SetRange("Currency Code", "Currency Code");
                        JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobItemPrice.Find('-') then
                            CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice)
                        else begin
                            JobItemPrice.SetRange("Job Task No.", ' ');
                            if JobItemPrice.Find('-') then
                                CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                        end;
                    end;
                Type::Resource:
                    begin
                        Res.Get("No.");
                        JobResPrice.SetRange("Job No.", "Job No.");
                        JobResPrice.SetRange("Currency Code", "Currency Code");
                        JobResPrice.SetRange("Job Task No.", "Job Task No.");
                        case true of
                            JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                            else begin
                                JobResPrice.SetRange("Job Task No.", '');
                                case true of
                                    JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::Resource):
                                        CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                    JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                        CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                    JobPlanningLineFindJobResPrice(JobPlanningLine, JobResPrice, JobResPrice.Type::All):
                                        CopyJobResPriceToJobPlanLine(JobPlanningLine, JobResPrice);
                                end;
                            end;
                        end;
                    end;
                Type::"G/L Account":
                    begin
                        JobGLAccPrice.SetRange("Job No.", "Job No.");
                        JobGLAccPrice.SetRange("G/L Account No.", "No.");
                        JobGLAccPrice.SetRange("Currency Code", "Currency Code");
                        JobGLAccPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobGLAccPrice.Find('-') then
                            CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice)
                        else begin
                            JobGLAccPrice.SetRange("Job Task No.", '');
                            if JobGLAccPrice.Find('-') then;
                            CopyJobGLAccPriceToJobPlanLine(JobPlanningLine, JobGLAccPrice);
                        end;
                    end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobItemPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobItemPrice: Record "Job Item Price")
    begin
        with JobPlanningLine do begin
            if JobItemPrice."Apply Job Price" then begin
                "Unit Price" := JobItemPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobItemPrice."Unit Cost Factor";
            end;
            if JobItemPrice."Apply Job Discount" then
                "Line Discount %" := JobItemPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobResPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobResPrice: Record "Job Resource Price")
    begin
        with JobPlanningLine do begin
            if JobResPrice."Apply Job Price" then begin
                "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobResPrice."Unit Cost Factor";
            end;
            if JobResPrice."Apply Job Discount" then
                "Line Discount %" := JobResPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure JobPlanningLineFindJobResPrice(var JobPlanningLine: Record "Job Planning Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    var
        ResUOM: Record "Resource Unit of Measure";
    begin
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange("Work Type Code", JobPlanningLine."Work Type Code");
                    JobResPrice.SetRange(Code, JobPlanningLine."No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    exit(JobResPrice.Find('-'));
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobGLAccPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        with JobPlanningLine do begin
            "Unit Cost" := JobGLAccPrice."Unit Cost";
            "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
            "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
            "Line Discount %" := JobGLAccPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindJobJnlLinePrice(var JobJnlLine: Record "Job Journal Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
    begin
        with JobJnlLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Posting Date");
            SetVAT(false, 0, VATCalcType::"Normal VAT", '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            case Type of
                Type::Item:
                    begin
                        Item.Get("No.");
                        TestField("Qty. per Unit of Measure");
                        Job.Get("Job No.");

                        FindSalesPrice(
                          TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                          "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                          "Currency Code", "Posting Date", false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then
                            "Unit Price" := TempSalesPrice."Unit Price";
                    end;
                Type::Resource:
                    begin
                        Job.Get("Job No.");
                        SetResPrice("Job No.", "No.", "Work Type Code", "Currency Code");
                        ResFindUnitPrice.Run(ResPrice);
                        ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                        "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
                    end;

            end;
        end;
        JobJnlLineFindJTPrice(JobJnlLine);
    end;

    //[Scope('OnPrem')]
    procedure JobJnlLineFindJobResPrice(var JobJnlLine: Record "Job Journal Line"; var JobResPrice: Record "Job Resource Price"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    var
        ResUOM: Record "Resource Unit of Measure";
    begin
        case PriceType of
            PriceType::Resource:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::Resource);
                    JobResPrice.SetRange("Work Type Code", JobJnlLine."Work Type Code");
                    JobResPrice.SetRange(Code, JobJnlLine."No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::"Group(Resource)");
                    JobResPrice.SetRange(Code, Res."Resource Group No.");
                    exit(JobResPrice.Find('-'));
                end;
            PriceType::All:
                begin
                    JobResPrice.SetRange(Type, JobResPrice.Type::All);
                    exit(JobResPrice.Find('-'));
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobResPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobResPrice: Record "Job Resource Price")
    begin
        with JobJnlLine do begin
            if JobResPrice."Apply Job Price" then begin
                "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobResPrice."Unit Cost Factor";
            end;
            if JobResPrice."Apply Job Discount" then
                "Line Discount %" := JobResPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobGLAccPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        with JobJnlLine do begin
            "Unit Cost" := JobGLAccPrice."Unit Cost";
            "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
            "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
            "Line Discount %" := JobGLAccPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure JobJnlLineFindJTPrice(var JobJnlLine: Record "Job Journal Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        with JobJnlLine do begin
            case Type of
                Type::Item:
                    begin
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        JobItemPrice.SetRange("Variant Code", "Variant Code");
                        JobItemPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        JobItemPrice.SetRange("Currency Code", "Currency Code");
                        JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobItemPrice.Find('-') then
                            CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice)
                        else begin
                            JobItemPrice.SetRange("Job Task No.", ' ');
                            if JobItemPrice.Find('-') then
                                CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice);
                        end;
                    end;
                Type::Resource:
                    begin
                        Res.Get("No.");
                        JobResPrice.SetRange("Job No.", "Job No.");
                        JobResPrice.SetRange("Currency Code", "Currency Code");
                        JobResPrice.SetRange("Job Task No.", "Job Task No.");
                        case true of
                            JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                            else begin
                                JobResPrice.SetRange("Job Task No.", '');
                                case true of
                                    JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::Resource):
                                        CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                    JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::"Group(Resource)"):
                                        CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                    JobJnlLineFindJobResPrice(JobJnlLine, JobResPrice, JobResPrice.Type::All):
                                        CopyJobResPriceToJobJnlLine(JobJnlLine, JobResPrice);
                                end;
                            end;
                        end;
                    end;
                Type::"G/L Account":
                    begin
                        JobGLAccPrice.SetRange("Job No.", "Job No.");
                        JobGLAccPrice.SetRange("G/L Account No.", "No.");
                        JobGLAccPrice.SetRange("Currency Code", "Currency Code");
                        JobGLAccPrice.SetRange("Job Task No.", "Job Task No.");
                        if JobGLAccPrice.Find('-') then
                            CopyJobGLAccPriceToJobJnlLine(JobJnlLine, JobGLAccPrice)
                        else begin
                            JobGLAccPrice.SetRange("Job Task No.", '');
                            if JobGLAccPrice.Find('-') then;
                            CopyJobGLAccPriceToJobJnlLine(JobJnlLine, JobGLAccPrice);
                        end;
                    end;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyJobItemPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobItemPrice: Record "Job Item Price")
    begin
        with JobJnlLine do begin
            if JobItemPrice."Apply Job Price" then begin
                "Unit Price" := JobItemPrice."Unit Price" * "Qty. per Unit of Measure";
                "Cost Factor" := JobItemPrice."Unit Cost Factor";
            end;
            if JobItemPrice."Apply Job Discount" then
                "Line Discount %" := JobItemPrice."Line Discount %";
        end;
    end;

    //[Scope('OnPrem')]
    procedure FindJobPlanningLineLineDisc(Job: Record Job; var JobPlanningLine: Record "Job Planning Line")
    begin
        with JobPlanningLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Planning Date");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            TestField("Qty. per Unit of Measure");

            if JobPlanningLine.Type = Type::Item then begin
                JobPlanningLineLineDiscExists(Job, JobPlanningLine, false);
                CalcBestLineDisc(TempSalesLineDisc);

                Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure JobPlanningLineLineDiscExists(Job: Record Job; var JobPlanningLine: Record "Job Planning Line"; ShowAll: Boolean): Boolean
    var
        Cust: Record Customer;
    begin
        with JobPlanningLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get(JobPlanningLine."Job No.");
                FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", JobPlanningLineStartDate(JobPlanningLine, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure JobPlanningLineStartDate(JobPlanningLine: Record "Job Planning Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobPlanningLine.FieldCaption("Planning Date");
        exit(JobPlanningLine."Planning Date");
    end;

    //[Scope('OnPrem')]
    procedure FindJobJnlLineLineDisc(Job: Record Job; var JobJnlLine: Record "Job Journal Line")
    begin
        with JobJnlLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Posting Date");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            TestField("Qty. per Unit of Measure");

            if JobJnlLine.Type = Type::Item then begin
                JobJnlLineLineDiscExists(Job, JobJnlLine, false);
                CalcBestLineDisc(TempSalesLineDisc);
                Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure JobJnlLineLineDiscExists(Job: Record Job; var JobJnlLine: Record "Job Journal Line"; ShowAll: Boolean): Boolean
    begin
        with JobJnlLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get(JobJnlLine."Job No.");
                FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", JobJnlLineStartDate(JobJnlLine, DateCaption), ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure JobJnlLineStartDate(JobJnlLine: Record "Job Journal Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobJnlLine.FieldCaption("Posting Date");
        exit(JobJnlLine."Posting Date");
    end;

    //[Scope('OnPrem')]
    procedure FindServiceLineLineDisc(UsersFamily: Record "Users Family"; var StudentLedgerEntry: Record "Student Ledger Entry")
    begin

        with StudentLedgerEntry do begin
            SetCurrency(UsersFamily."Currency Code", 0, 0D);
            //SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

            Qty := 1;

            if StudentLedgerEntry.Type = StudentLedgerEntry.Type::Service then begin
                ServiceLineDiscExists(UsersFamily, StudentLedgerEntry, false);
                CalcBestLineDisc(TempSalesLineDisc);
                "Line Discount %" := TempSalesLineDisc."Line Discount %";

                //CalcBestServiceLineDisc(TempSalesLineDisc);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ServiceLineDiscExists(UsersFamily: Record "Users Family"; var StudentLedgerEntry: Record "Student Ledger Entry"; ShowAll: Boolean): Boolean
    var
        l_Customer: Record Customer;
        l_Student: Record Students;
    begin

        with StudentLedgerEntry do
            if (Type = Type::Service) and ServicesET.Get("Service Code") then begin

                //IF l_Users Family.get(StudentLedgerEntry."Entity ID") THEN

                if l_Student.Get("Student No.") then begin
                    if l_Student."Use Student Disc. Group" = true then begin
                        if l_Customer.Get(l_Student."Customer No.") then begin
                            if l_Customer."Allow Line Disc." then
                                FindServiceLineDisc(
                                  TempSalesLineDisc, l_Student."Customer No.", '', l_Customer."Customer Disc. Group", '',
                                  "Service Code", ServicesET."Service Disc. Group", '', '',
                                  l_Customer."Currency Code", "Posting Date", ShowAll);
                        end;
                    end else begin
                        if l_Customer.Get("Entity Customer No.") then begin
                            if l_Customer."Allow Line Disc." then
                                FindServiceLineDisc(
                                  TempSalesLineDisc, "Entity Customer No.", '', l_Customer."Customer Disc. Group", '',
                                  "Service Code", ServicesET."Service Disc. Group", '', '',
                                  l_Customer."Currency Code", "Posting Date", ShowAll);
                        end;
                    end;
                end;



                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure CalcBestServiceLineDisc(var SalesLineDisc: Record "Sales Line Discount ET")
    var
        BestSalesLineDisc: Record "Sales Line Discount ET";
    begin

        with SalesLineDisc do begin
            if Find('-') then
                repeat
                    if IsInMinQtyService("Minimum Quantity") then
                        case true of
                            ((BestSalesLineDisc."Currency Code" = '') and ("Currency Code" <> '')) or
                          ((BestSalesLineDisc."Variant Code" = '') and ("Variant Code" <> '')):
                                BestSalesLineDisc := SalesLineDisc;
                            ((BestSalesLineDisc."Currency Code" = '') or ("Currency Code" <> '')) and
                          ((BestSalesLineDisc."Variant Code" = '') or ("Variant Code" <> '')):
                                if BestSalesLineDisc."Line Discount %" < "Line Discount %" then
                                    BestSalesLineDisc := SalesLineDisc;
                        end;
                until Next = 0;
        end;

        SalesLineDisc := BestSalesLineDisc;
    end;

    //[Scope('OnPrem')]
    procedure FindServiceLineDisc(var ToSalesLineDisc: Record "Sales Line Discount ET"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount ET";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin

        with FromSalesLineDisc do begin
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;


            for "Sales Type" := "Sales Type"::Customer to "Sales Type"::Campaign do
                if ("Sales Type" = "Sales Type"::"All Customers") or
                   (("Sales Type" = "Sales Type"::Customer) and (CustNo <> '')) or
                   (("Sales Type" = "Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
                   (("Sales Type" = "Sales Type"::Campaign) and
                       not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
                then begin
                    InclCampaigns := false;


                    SetRange("Sales Type", "Sales Type");
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            SetRange("Sales Code");
                        "Sales Type"::Customer:
                            SetRange("Sales Code", CustNo);
                        "Sales Type"::"Customer Disc. Group":
                            SetRange("Sales Code", CustDiscGrCode);

                    end;

                    repeat
                        SetRange(Type, Type::Service);
                        SetRange(Code, ItemNo);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                        if ItemDiscGrCode <> '' then begin
                            SetRange(Type, Type::"Service Disc. Group");
                            SetRange(Code, ItemDiscGrCode);
                            CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                        end;

                    until not InclCampaigns;
                end;
        end;
    end;

    local procedure IsInMinQtyService(MinQty: Decimal): Boolean
    begin

        exit(MinQty <= Qty);
    end;
}

