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


    procedure FindSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer)
    begin
        SetCurrency(
  SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));
        SetVAT(SalesHeader."Prices Including VAT", SalesLine."VAT %", SalesLine."VAT Calculation Type", SalesLine."VAT Bus. Posting Group");
        SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
        SetLineDisc(SalesLine."Line Discount %", SalesLine."Allow Line Disc.", SalesLine."Allow Invoice Disc.");

        SalesLine.TestField("Qty. per Unit of Measure");
        if PricesInCurrency then
            SalesHeader.TestField("Currency Factor");

        case SalesLine.Type of
            SalesLine.Type::Service:
                begin
                    ServicesET.Get(SalesLine."No.");
                    SalesLinePriceExists(SalesHeader, SalesLine, false);
                    CalcBestUnitPrice(TempSalesPrice);

                    if FoundSalesPrice or
                       not ((CalledByFieldNo = SalesLine.FieldNo(Quantity)) or
                            (CalledByFieldNo = SalesLine.FieldNo("Variant Code")))
                    then begin
                        SalesLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                        SalesLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                        SalesLine."Unit Price" := TempSalesPrice."Unit Price";
                    end;
                    if not SalesLine."Allow Line Disc." then
                        SalesLine."Line Discount %" := 0;
                end;
        end;
    end;


    procedure FindItemJnlLinePrice(var ItemJnlLine: Record "Item Journal Line"; CalledByFieldNo: Integer)
    begin
        SetCurrency('', 0, 0D);
        SetVAT(false, 0, VATCalcType::"Normal VAT", '');
        SetUoM(Abs(ItemJnlLine.Quantity), ItemJnlLine."Qty. per Unit of Measure");
        ItemJnlLine.TestField("Qty. per Unit of Measure");
        Item.Get(ItemJnlLine."Item No.");

        FindSalesPrice(
          TempSalesPrice, '', '', '', '', ItemJnlLine."Item No.", ItemJnlLine."Variant Code",
          ItemJnlLine."Unit of Measure Code", '', ItemJnlLine."Posting Date", false);
        CalcBestUnitPrice(TempSalesPrice);
        if FoundSalesPrice or
           not ((CalledByFieldNo = ItemJnlLine.FieldNo(Quantity)) or
                (CalledByFieldNo = ItemJnlLine.FieldNo("Variant Code")))
        then
            ItemJnlLine.Validate("Unit Amount", TempSalesPrice."Unit Price");
    end;


    procedure FindServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; CalledByFieldNo: Integer)
    var
        ServCost: Record "Service Cost";
        Res: Record Resource;
    begin
        ServHeader.Get(ServLine."Document Type", ServLine."Document No.");
        if ServLine.Type <> ServLine.Type::" " then begin
            SetCurrency(
              ServHeader."Currency Code", ServHeader."Currency Factor", ServHeaderExchDate(ServHeader));
            SetVAT(ServHeader."Prices Including VAT", ServLine."VAT %", ServLine."VAT Calculation Type", ServLine."VAT Bus. Posting Group");
            SetUoM(Abs(ServLine.Quantity), ServLine."Qty. per Unit of Measure");
            SetLineDisc(ServLine."Line Discount %", ServLine."Allow Line Disc.", false);

            ServLine.TestField("Qty. per Unit of Measure");
            if PricesInCurrency then
                ServHeader.TestField("Currency Factor");
        end;

        case ServLine.Type of
            ServLine.Type::Item:
                begin
                    Item.Get(ServLine."No.");
                    FindSalesPrice(
                      TempSalesPrice, ServLine."Bill-to Customer No.", ServHeader."Contact No.",
                      ServLine."Customer Price Group", '', ServLine."No.", ServLine."Variant Code", ServLine."Unit of Measure Code",
                      ServHeader."Currency Code", ServHeader."Order Date", false);
                    CalcBestUnitPrice(TempSalesPrice);
                    if FoundSalesPrice or
                       not ((CalledByFieldNo = ServLine.FieldNo(Quantity)) or
                            (CalledByFieldNo = ServLine.FieldNo("Variant Code")))
                    then begin
                        if ServLine."Line Discount Type" = ServLine."Line Discount Type"::"Line Disc." then
                            ServLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                        ServLine."Unit Price" := TempSalesPrice."Unit Price";
                    end;
                    if not ServLine."Allow Line Disc." and (ServLine."Line Discount Type" = ServLine."Line Discount Type"::"Line Disc.") then
                        ServLine."Line Discount %" := 0;
                end;
        end;
    end;


    procedure FindSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SetCurrency(SalesHeader."Currency Code", 0, 0D);
        SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");

        SalesLine.TestField("Qty. per Unit of Measure");

        if SalesLine.Type = SalesLine.Type::Service then begin
            SalesLineLineDiscExists(SalesHeader, SalesLine, false);
            CalcBestLineDisc(TempSalesLineDisc);

            SalesLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
        end;
    end;


    procedure FindServLineDisc(ServHeader: Record "Service Header"; var ServInvLine: Record "Service Line")
    begin
        SetCurrency(ServHeader."Currency Code", 0, 0D);
        SetUoM(Abs(ServInvLine.Quantity), ServInvLine."Qty. per Unit of Measure");

        ServInvLine.TestField("Qty. per Unit of Measure");

        if ServInvLine.Type = ServInvLine.Type::Item then begin
            Item.Get(ServInvLine."No.");
            FindSalesLineDisc(
              TempSalesLineDisc, ServInvLine."Bill-to Customer No.", ServHeader."Contact No.",
              ServInvLine."Customer Disc. Group", '', ServInvLine."No.", Item."Item Disc. Group", ServInvLine."Variant Code",
              ServInvLine."Unit of Measure Code", ServHeader."Currency Code", ServHeader."Order Date", false);
            CalcBestLineDisc(TempSalesLineDisc);
            ServInvLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
        end;
        if ServInvLine.Type in [ServInvLine.Type::Resource, ServInvLine.Type::Cost, ServInvLine.Type::"G/L Account"] then begin
            ServInvLine."Line Discount %" := 0;
            ServInvLine."Line Discount Amount" :=
              Round(
                Round(ServInvLine.CalcChargeableQty * ServInvLine."Unit Price", Currency."Amount Rounding Precision") *
                ServInvLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
            ServInvLine."Inv. Discount Amount" := 0;
            ServInvLine."Inv. Disc. Amount to Invoice" := 0;
        end;
    end;


    procedure FindStdItemJnlLinePrice(var StdItemJnlLine: Record "Standard Item Journal Line"; CalledByFieldNo: Integer)
    begin
        SetCurrency('', 0, 0D);
        SetVAT(false, 0, VATCalcType::"Normal VAT", '');
        SetUoM(Abs(StdItemJnlLine.Quantity), StdItemJnlLine."Qty. per Unit of Measure");
        StdItemJnlLine.TestField("Qty. per Unit of Measure");
        Item.Get(StdItemJnlLine."Item No.");

        FindSalesPrice(
          TempSalesPrice, '', '', '', '', StdItemJnlLine."Item No.", StdItemJnlLine."Variant Code",
          StdItemJnlLine."Unit of Measure Code", '', WorkDate, false);
        CalcBestUnitPrice(TempSalesPrice);
        if FoundSalesPrice or
           not ((CalledByFieldNo = StdItemJnlLine.FieldNo(Quantity)) or
                (CalledByFieldNo = StdItemJnlLine.FieldNo("Variant Code")))
        then
            StdItemJnlLine.Validate("Unit Amount", TempSalesPrice."Unit Price");
    end;


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
        FoundSalesPrice := SalesPrice.FindSet;
        if FoundSalesPrice then
            repeat
                if IsInMinQty(SalesPrice."Unit of Measure Code", SalesPrice."Minimum Quantity") then begin
                    ConvertPriceToVAT(
                      SalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                      SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Unit Price");
                    ConvertPriceToUoM(SalesPrice."Unit of Measure Code", SalesPrice."Unit Price");
                    ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Unit Price");

                    case true of
                        ((BestSalesPrice."Currency Code" = '') and (SalesPrice."Currency Code" <> '')) or
                      ((BestSalesPrice."Variant Code" = '') and (SalesPrice."Variant Code" <> '')):
                            BestSalesPrice := SalesPrice;
                        ((BestSalesPrice."Currency Code" = '') or (SalesPrice."Currency Code" <> '')) and
                      ((BestSalesPrice."Variant Code" = '') or (SalesPrice."Variant Code" <> '')):
                            if (BestSalesPrice."Unit Price" = 0) or
                               (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                            then
                                BestSalesPrice := SalesPrice;
                    end;
                end;
            until SalesPrice.Next = 0;

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

        SalesLineDisc := BestSalesLineDisc;
    end;


    procedure FindSalesPrice(var ToSalesPrice: Record "Sales Price"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesPrice: Record "Sales Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromSalesPrice.SetRange("Item No.", ItemNo);
        FromSalesPrice.SetFilter("Variant Code", '%1|%2', VariantCode, '');
        FromSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        if not ShowAll then begin
            FromSalesPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesPrice.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            FromSalesPrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
        FromSalesPrice.SetRange("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::Customer);
            FromSalesPrice.SetRange("Sales Code", CustNo);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
            FromSalesPrice.SetRange("Sales Code", CustPriceGrCode);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromSalesPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;


    procedure FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount ET"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[10]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
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


    procedure CopySalesPrice(var SalesPrice: Record "Sales Price")
    begin
        SalesPrice.DeleteAll;
        CopySalesPriceToSalesPrice(TempSalesPrice, SalesPrice);
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price"; var ToSalesPrice: Record "Sales Price")
    begin
        if FromSalesPrice.FindSet then
            repeat
                if FromSalesPrice."Unit Price" <> 0 then begin
                    ToSalesPrice := FromSalesPrice;
                    ToSalesPrice.Insert;
                end;
            until FromSalesPrice.Next = 0;
    end;

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


    procedure SetResPrice(JobNo: Code[20]; Code2: Code[20]; WorkTypeCode: Code[10]; CurrencyCode: Code[10])
    begin
        ResPrice.Init;
        //"Job No." := JobNo;
        ResPrice.Code := Code2;
        ResPrice."Work Type Code" := WorkTypeCode;
        ResPrice."Currency Code" := CurrencyCode;
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
        if SalesPrice."Allow Line Disc." then
            exit(SalesPrice."Unit Price" * (1 - LineDiscPerCent / 100));
        exit(SalesPrice."Unit Price");
    end;


    procedure GetSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLinePriceExists(SalesHeader, SalesLine, true);

        if PAGE.RunModal(PAGE::"Get Sales Price", TempSalesPrice) = ACTION::LookupOK then begin
            SetVAT(
              SalesHeader."Prices Including VAT", SalesLine."VAT %", SalesLine."VAT Calculation Type", SalesLine."VAT Bus. Posting Group");
            SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
            SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));

            if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                Error(
                  Text000,
                  SalesLine.FieldCaption(Quantity),
                  TempSalesPrice.FieldCaption("Minimum Quantity"),
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Currency Code" in [SalesLine."Currency Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Currency Code"),
                  SalesLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Unit of Measure Code" in [SalesLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine.TableCaption,
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
            ConvertPriceToUoM(SalesLine."Unit of Measure Code", TempSalesPrice."Unit Price");
            ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

            SalesLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            SalesLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            if not SalesLine."Allow Line Disc." then
                SalesLine."Line Discount %" := 0;

            SalesLine.Validate("Unit Price", TempSalesPrice."Unit Price");
        end;
    end;


    procedure GetSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLineLineDiscExists(SalesHeader, SalesLine, true);

        if PAGE.RunModal(PAGE::"Get Sales Line Disc.", TempSalesLineDisc) = ACTION::LookupOK then begin
            SetCurrency(SalesHeader."Currency Code", 0, 0D);
            SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");

            if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
            then
                Error(
                  Text000, SalesLine.FieldCaption(Quantity),
                  TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                  TempSalesLineDisc.TableCaption);
            if not (TempSalesLineDisc."Currency Code" in [SalesLine."Currency Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Currency Code"),
                  SalesLine.TableCaption,
                  TempSalesLineDisc.TableCaption);
            if not (TempSalesLineDisc."Unit of Measure Code" in [SalesLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine.TableCaption,
                  TempSalesLineDisc.TableCaption);
            if TempSalesLineDisc."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                Error(
                  Text000,
                  DateCaption,
                  TempSalesLineDisc.FieldCaption("Starting Date"),
                  TempSalesLineDisc.TableCaption);

            SalesLine.TestField("Allow Line Disc.");
            SalesLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
        end;
    end;


    procedure SalesLinePriceExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    begin
        if (SalesLine.Type = SalesLine.Type::Service) and ServicesET.Get(SalesLine."No.") then begin
            FindSalesPrice(
              TempSalesPrice, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
              SalesLine."Customer Price Group", '', SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
              SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
            exit(TempSalesPrice.FindFirst);
        end;
        exit(false);
    end;


    procedure SalesLineLineDiscExists(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    begin
        if (SalesLine.Type = SalesLine.Type::Service) and ServicesET.Get(SalesLine."No.") then begin
            FindSalesLineDisc(
              TempSalesLineDisc, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
              SalesLine."Customer Disc. Group", '', SalesLine."No.", ServicesET."Service Disc. Group", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
              SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
            exit(TempSalesLineDisc.FindFirst);
        end;
        exit(false);
    end;


    procedure GetServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
        ServLinePriceExists(ServHeader, ServLine, true);

        if PAGE.RunModal(PAGE::"Get Sales Price", TempSalesPrice) = ACTION::LookupOK then begin
            SetVAT(
              ServHeader."Prices Including VAT", ServLine."VAT %", ServLine."VAT Calculation Type", ServLine."VAT Bus. Posting Group");
            SetUoM(Abs(ServLine.Quantity), ServLine."Qty. per Unit of Measure");
            SetCurrency(
              ServHeader."Currency Code", ServHeader."Currency Factor", ServHeaderExchDate(ServHeader));

            if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                Error(
                  Text000,
                  ServLine.FieldCaption(Quantity),
                  TempSalesPrice.FieldCaption("Minimum Quantity"),
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Currency Code" in [ServLine."Currency Code", '']) then
                Error(
                  Text001,
                  ServLine.FieldCaption("Currency Code"),
                  ServLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Unit of Measure Code" in [ServLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  ServLine.FieldCaption("Unit of Measure Code"),
                  ServLine.TableCaption,
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
            ConvertPriceToUoM(ServLine."Unit of Measure Code", TempSalesPrice."Unit Price");
            ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

            ServLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            ServLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            if not ServLine."Allow Line Disc." then
                ServLine."Line Discount %" := 0;

            ServLine.Validate("Unit Price", TempSalesPrice."Unit Price");
            ServLine.ConfirmAdjPriceLineChange;
        end;
    end;


    procedure GetServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
        ServLineLineDiscExists(ServHeader, ServLine, true);

        if PAGE.RunModal(PAGE::"Get Sales Line Disc.", TempSalesLineDisc) = ACTION::LookupOK then begin
            SetCurrency(ServHeader."Currency Code", 0, 0D);
            SetUoM(Abs(ServLine.Quantity), ServLine."Qty. per Unit of Measure");

            if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
            then
                Error(
                  Text000, ServLine.FieldCaption(Quantity),
                  TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                  TempSalesLineDisc.TableCaption);
            if not (TempSalesLineDisc."Currency Code" in [ServLine."Currency Code", '']) then
                Error(
                  Text001,
                  ServLine.FieldCaption("Currency Code"),
                  ServLine.TableCaption,
                  TempSalesLineDisc.TableCaption);
            if not (TempSalesLineDisc."Unit of Measure Code" in [ServLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  ServLine.FieldCaption("Unit of Measure Code"),
                  ServLine.TableCaption,
                  TempSalesLineDisc.TableCaption);
            if TempSalesLineDisc."Starting Date" > ServHeaderStartDate(ServHeader, DateCaption) then
                Error(
                  Text000,
                  DateCaption,
                  TempSalesLineDisc.FieldCaption("Starting Date"),
                  TempSalesLineDisc.TableCaption);

            ServLine.TestField("Allow Line Disc.");
            ServLine.CheckLineDiscount(TempSalesLineDisc."Line Discount %");
            ServLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            ServLine.ConfirmAdjPriceLineChange;
        end;
    end;


    procedure ServLinePriceExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        if (ServLine.Type = ServLine.Type::Item) and Item.Get(ServLine."No.") then begin
            FindSalesPrice(
              TempSalesPrice, ServLine."Bill-to Customer No.", ServHeader."Bill-to Contact No.",
              ServLine."Customer Price Group", '', ServLine."No.", ServLine."Variant Code", ServLine."Unit of Measure Code",
              ServHeader."Currency Code", ServHeaderStartDate(ServHeader, DateCaption), ShowAll);
            exit(TempSalesPrice.Find('-'));
        end;
        exit(false);
    end;


    procedure ServLineLineDiscExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        if (ServLine.Type = ServLine.Type::Item) and Item.Get(ServLine."No.") then begin
            FindSalesLineDisc(
              TempSalesLineDisc, ServLine."Bill-to Customer No.", ServHeader."Bill-to Contact No.",
              ServLine."Customer Disc. Group", '', ServLine."No.", Item."Item Disc. Group", ServLine."Variant Code", ServLine."Unit of Measure Code",
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

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::"Blanket Order", SalesHeader."Document Type"::Quote]) and
   (SalesHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(SalesHeader."Posting Date");
    end;

    local procedure SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then begin
            DateCaption := SalesHeader.FieldCaption("Posting Date");
            exit(SalesHeader."Posting Date")
        end else begin
            DateCaption := SalesHeader.FieldCaption("Order Date");
            exit(SalesHeader."Order Date");
        end;
    end;

    local procedure ServHeaderExchDate(ServHeader: Record "Service Header"): Date
    begin
        if (ServHeader."Document Type" = ServHeader."Document Type"::Quote) and
   (ServHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(ServHeader."Posting Date");
    end;

    local procedure ServHeaderStartDate(ServHeader: Record "Service Header"; var DateCaption: Text[30]): Date
    begin
        if ServHeader."Document Type" in [ServHeader."Document Type"::Invoice, ServHeader."Document Type"::"Credit Memo"] then begin
            DateCaption := ServHeader.FieldCaption("Posting Date");
            exit(ServHeader."Posting Date")
        end else begin
            DateCaption := ServHeader.FieldCaption("Order Date");
            exit(ServHeader."Order Date");
        end;
    end;


    procedure NoOfSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLinePriceExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;


    procedure NoOfSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLineLineDiscExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;


    procedure NoOfServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLinePriceExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;


    procedure NoOfServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLineLineDiscExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;


    procedure FindJobPlanningLinePrice(var JobPlanningLine: Record "Job Planning Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
    begin
        SetCurrency(JobPlanningLine."Currency Code", JobPlanningLine."Currency Factor", JobPlanningLine."Planning Date");
        SetVAT(false, 0, VATCalcType::"Normal VAT", '');
        SetUoM(Abs(JobPlanningLine.Quantity), JobPlanningLine."Qty. per Unit of Measure");

        case JobPlanningLine.Type of
            JobPlanningLine.Type::Item:
                begin
                    Job.Get(JobPlanningLine."Job No.");
                    Item.Get(JobPlanningLine."No.");
                    JobPlanningLine.TestField("Qty. per Unit of Measure");
                    FindSalesPrice(
                      TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                      Job."Customer Price Group", '', JobPlanningLine."No.", JobPlanningLine."Variant Code", JobPlanningLine."Unit of Measure Code",
                      Job."Currency Code", JobPlanningLine."Planning Date", false);
                    CalcBestUnitPrice(TempSalesPrice);
                    if FoundSalesPrice or
                       not ((CalledByFieldNo = JobPlanningLine.FieldNo(Quantity)) or
                            (CalledByFieldNo = JobPlanningLine.FieldNo("Variant Code")))
                    then
                        JobPlanningLine."Unit Price" := TempSalesPrice."Unit Price";
                end;
            JobPlanningLine.Type::Resource:
                begin
                    Job.Get(JobPlanningLine."Job No.");
                    SetResPrice(JobPlanningLine."Job No.", JobPlanningLine."No.", JobPlanningLine."Work Type Code", JobPlanningLine."Currency Code");
                    ResFindUnitPrice.Run(ResPrice);
                    ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                    JobPlanningLine."Unit Price" := ResPrice."Unit Price" * JobPlanningLine."Qty. per Unit of Measure";
                end;

        end;
        JobPlanningLineFindJTPrice(JobPlanningLine);
    end;


    procedure JobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        case JobPlanningLine.Type of
            JobPlanningLine.Type::Item:
                begin
                    JobItemPrice.SetRange("Job No.", JobPlanningLine."Job No.");
                    JobItemPrice.SetRange("Item No.", JobPlanningLine."No.");
                    JobItemPrice.SetRange("Variant Code", JobPlanningLine."Variant Code");
                    JobItemPrice.SetRange("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
                    JobItemPrice.SetRange("Currency Code", JobPlanningLine."Currency Code");
                    JobItemPrice.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
                    if JobItemPrice.Find('-') then
                        CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice)
                    else begin
                        JobItemPrice.SetRange("Job Task No.", ' ');
                        if JobItemPrice.Find('-') then
                            CopyJobItemPriceToJobPlanLine(JobPlanningLine, JobItemPrice);
                    end;
                end;
            JobPlanningLine.Type::Resource:
                begin
                    Res.Get(JobPlanningLine."No.");
                    JobResPrice.SetRange("Job No.", JobPlanningLine."Job No.");
                    JobResPrice.SetRange("Currency Code", JobPlanningLine."Currency Code");
                    JobResPrice.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
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
            JobPlanningLine.Type::"G/L Account":
                begin
                    JobGLAccPrice.SetRange("Job No.", JobPlanningLine."Job No.");
                    JobGLAccPrice.SetRange("G/L Account No.", JobPlanningLine."No.");
                    JobGLAccPrice.SetRange("Currency Code", JobPlanningLine."Currency Code");
                    JobGLAccPrice.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
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


    procedure CopyJobItemPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobItemPrice: Record "Job Item Price")
    begin
        if JobItemPrice."Apply Job Price" then begin
            JobPlanningLine."Unit Price" := JobItemPrice."Unit Price" * JobPlanningLine."Qty. per Unit of Measure";
            JobPlanningLine."Cost Factor" := JobItemPrice."Unit Cost Factor";
        end;
        if JobItemPrice."Apply Job Discount" then
            JobPlanningLine."Line Discount %" := JobItemPrice."Line Discount %";
    end;


    procedure CopyJobResPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobResPrice: Record "Job Resource Price")
    begin
        if JobResPrice."Apply Job Price" then begin
            JobPlanningLine."Unit Price" := JobResPrice."Unit Price" * JobPlanningLine."Qty. per Unit of Measure";
            JobPlanningLine."Cost Factor" := JobResPrice."Unit Cost Factor";
        end;
        if JobResPrice."Apply Job Discount" then
            JobPlanningLine."Line Discount %" := JobResPrice."Line Discount %";
    end;


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


    procedure CopyJobGLAccPriceToJobPlanLine(var JobPlanningLine: Record "Job Planning Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        JobPlanningLine."Unit Cost" := JobGLAccPrice."Unit Cost";
        JobPlanningLine."Unit Price" := JobGLAccPrice."Unit Price" * JobPlanningLine."Qty. per Unit of Measure";
        JobPlanningLine."Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        JobPlanningLine."Line Discount %" := JobGLAccPrice."Line Discount %";
    end;


    procedure FindJobJnlLinePrice(var JobJnlLine: Record "Job Journal Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
    begin
        SetCurrency(JobJnlLine."Currency Code", JobJnlLine."Currency Factor", JobJnlLine."Posting Date");
        SetVAT(false, 0, VATCalcType::"Normal VAT", '');
        SetUoM(Abs(JobJnlLine.Quantity), JobJnlLine."Qty. per Unit of Measure");

        case JobJnlLine.Type of
            JobJnlLine.Type::Item:
                begin
                    Item.Get(JobJnlLine."No.");
                    JobJnlLine.TestField("Qty. per Unit of Measure");
                    Job.Get(JobJnlLine."Job No.");

                    FindSalesPrice(
                      TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                      JobJnlLine."Customer Price Group", '', JobJnlLine."No.", JobJnlLine."Variant Code", JobJnlLine."Unit of Measure Code",
                      JobJnlLine."Currency Code", JobJnlLine."Posting Date", false);
                    CalcBestUnitPrice(TempSalesPrice);
                    if FoundSalesPrice or
                       not ((CalledByFieldNo = JobJnlLine.FieldNo(Quantity)) or
                            (CalledByFieldNo = JobJnlLine.FieldNo("Variant Code")))
                    then
                        JobJnlLine."Unit Price" := TempSalesPrice."Unit Price";
                end;
            JobJnlLine.Type::Resource:
                begin
                    Job.Get(JobJnlLine."Job No.");
                    SetResPrice(JobJnlLine."Job No.", JobJnlLine."No.", JobJnlLine."Work Type Code", JobJnlLine."Currency Code");
                    ResFindUnitPrice.Run(ResPrice);
                    ConvertPriceLCYToFCY(ResPrice."Currency Code", ResPrice."Unit Price");
                    JobJnlLine."Unit Price" := ResPrice."Unit Price" * JobJnlLine."Qty. per Unit of Measure";
                end;

        end;
        JobJnlLineFindJTPrice(JobJnlLine);
    end;


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


    procedure CopyJobResPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobResPrice: Record "Job Resource Price")
    begin
        if JobResPrice."Apply Job Price" then begin
            JobJnlLine."Unit Price" := JobResPrice."Unit Price" * JobJnlLine."Qty. per Unit of Measure";
            JobJnlLine."Cost Factor" := JobResPrice."Unit Cost Factor";
        end;
        if JobResPrice."Apply Job Discount" then
            JobJnlLine."Line Discount %" := JobResPrice."Line Discount %";
    end;


    procedure CopyJobGLAccPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobGLAccPrice: Record "Job G/L Account Price")
    begin
        JobJnlLine."Unit Cost" := JobGLAccPrice."Unit Cost";
        JobJnlLine."Unit Price" := JobGLAccPrice."Unit Price" * JobJnlLine."Qty. per Unit of Measure";
        JobJnlLine."Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        JobJnlLine."Line Discount %" := JobGLAccPrice."Line Discount %";
    end;


    procedure JobJnlLineFindJTPrice(var JobJnlLine: Record "Job Journal Line")
    var
        JobItemPrice: Record "Job Item Price";
        JobResPrice: Record "Job Resource Price";
        JobGLAccPrice: Record "Job G/L Account Price";
    begin
        case JobJnlLine.Type of
            JobJnlLine.Type::Item:
                begin
                    JobItemPrice.SetRange("Job No.", JobJnlLine."Job No.");
                    JobItemPrice.SetRange("Item No.", JobJnlLine."No.");
                    JobItemPrice.SetRange("Variant Code", JobJnlLine."Variant Code");
                    JobItemPrice.SetRange("Unit of Measure Code", JobJnlLine."Unit of Measure Code");
                    JobItemPrice.SetRange("Currency Code", JobJnlLine."Currency Code");
                    JobItemPrice.SetRange("Job Task No.", JobJnlLine."Job Task No.");
                    if JobItemPrice.Find('-') then
                        CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice)
                    else begin
                        JobItemPrice.SetRange("Job Task No.", ' ');
                        if JobItemPrice.Find('-') then
                            CopyJobItemPriceToJobJnlLine(JobJnlLine, JobItemPrice);
                    end;
                end;
            JobJnlLine.Type::Resource:
                begin
                    Res.Get(JobJnlLine."No.");
                    JobResPrice.SetRange("Job No.", JobJnlLine."Job No.");
                    JobResPrice.SetRange("Currency Code", JobJnlLine."Currency Code");
                    JobResPrice.SetRange("Job Task No.", JobJnlLine."Job Task No.");
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
            JobJnlLine.Type::"G/L Account":
                begin
                    JobGLAccPrice.SetRange("Job No.", JobJnlLine."Job No.");
                    JobGLAccPrice.SetRange("G/L Account No.", JobJnlLine."No.");
                    JobGLAccPrice.SetRange("Currency Code", JobJnlLine."Currency Code");
                    JobGLAccPrice.SetRange("Job Task No.", JobJnlLine."Job Task No.");
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


    procedure CopyJobItemPriceToJobJnlLine(var JobJnlLine: Record "Job Journal Line"; JobItemPrice: Record "Job Item Price")
    begin
        if JobItemPrice."Apply Job Price" then begin
            JobJnlLine."Unit Price" := JobItemPrice."Unit Price" * JobJnlLine."Qty. per Unit of Measure";
            JobJnlLine."Cost Factor" := JobItemPrice."Unit Cost Factor";
        end;
        if JobItemPrice."Apply Job Discount" then
            JobJnlLine."Line Discount %" := JobItemPrice."Line Discount %";
    end;


    procedure FindJobPlanningLineLineDisc(Job: Record Job; var JobPlanningLine: Record "Job Planning Line")
    begin
        SetCurrency(JobPlanningLine."Currency Code", JobPlanningLine."Currency Factor", JobPlanningLine."Planning Date");
        SetUoM(Abs(JobPlanningLine.Quantity), JobPlanningLine."Qty. per Unit of Measure");

        JobPlanningLine.TestField("Qty. per Unit of Measure");

        if JobPlanningLine.Type = JobPlanningLine.Type::Item then begin
            JobPlanningLineLineDiscExists(Job, JobPlanningLine, false);
            CalcBestLineDisc(TempSalesLineDisc);

            JobPlanningLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
        end;
    end;


    procedure JobPlanningLineLineDiscExists(Job: Record Job; var JobPlanningLine: Record "Job Planning Line"; ShowAll: Boolean): Boolean
    var
        Cust: Record Customer;
    begin
        if (JobPlanningLine.Type = JobPlanningLine.Type::Item) and Item.Get(JobPlanningLine."No.") then begin
            Job.Get(JobPlanningLine."Job No.");
            FindSalesLineDisc(
              TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
              Job."Customer Disc. Group", '', JobPlanningLine."No.", Item."Item Disc. Group", JobPlanningLine."Variant Code", JobPlanningLine."Unit of Measure Code",
              JobPlanningLine."Currency Code", JobPlanningLineStartDate(JobPlanningLine, DateCaption), ShowAll);
            exit(TempSalesLineDisc.Find('-'));
        end;
        exit(false);
    end;

    local procedure JobPlanningLineStartDate(JobPlanningLine: Record "Job Planning Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobPlanningLine.FieldCaption("Planning Date");
        exit(JobPlanningLine."Planning Date");
    end;


    procedure FindJobJnlLineLineDisc(Job: Record Job; var JobJnlLine: Record "Job Journal Line")
    begin
        SetCurrency(JobJnlLine."Currency Code", JobJnlLine."Currency Factor", JobJnlLine."Posting Date");
        SetUoM(Abs(JobJnlLine.Quantity), JobJnlLine."Qty. per Unit of Measure");

        JobJnlLine.TestField("Qty. per Unit of Measure");

        if JobJnlLine.Type = JobJnlLine.Type::Item then begin
            JobJnlLineLineDiscExists(Job, JobJnlLine, false);
            CalcBestLineDisc(TempSalesLineDisc);
            JobJnlLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
        end;
    end;


    procedure JobJnlLineLineDiscExists(Job: Record Job; var JobJnlLine: Record "Job Journal Line"; ShowAll: Boolean): Boolean
    begin
        if (JobJnlLine.Type = JobJnlLine.Type::Item) and Item.Get(JobJnlLine."No.") then begin
            Job.Get(JobJnlLine."Job No.");
            FindSalesLineDisc(
              TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
              Job."Customer Disc. Group", '', JobJnlLine."No.", Item."Item Disc. Group", JobJnlLine."Variant Code", JobJnlLine."Unit of Measure Code",
              JobJnlLine."Currency Code", JobJnlLineStartDate(JobJnlLine, DateCaption), ShowAll);
            exit(TempSalesLineDisc.Find('-'));
        end;
        exit(false);
    end;

    local procedure JobJnlLineStartDate(JobJnlLine: Record "Job Journal Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobJnlLine.FieldCaption("Posting Date");
        exit(JobJnlLine."Posting Date");
    end;


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


    procedure ServiceLineDiscExists(UsersFamily: Record "Users Family"; var StudentLedgerEntry: Record "Student Ledger Entry"; ShowAll: Boolean): Boolean
    var
        l_Customer: Record Customer;
        l_Student: Record Students;
    begin

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

    local procedure CalcBestServiceLineDisc(var SalesLineDisc: Record "Sales Line Discount ET")
    var
        BestSalesLineDisc: Record "Sales Line Discount ET";
    begin

        if SalesLineDisc.Find('-') then
            repeat
                if IsInMinQtyService(SalesLineDisc."Minimum Quantity") then
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

        SalesLineDisc := BestSalesLineDisc;
    end;


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


                FromSalesLineDisc.SetRange("Sales Type", FromSalesLineDisc."Sales Type");
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

    local procedure IsInMinQtyService(MinQty: Decimal): Boolean
    begin

        exit(MinQty <= Qty);
    end;
}

