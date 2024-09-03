#pragma implicitwith disable
page 52805 "Sales Line Discounts ET"
{
    // Do campo "SalesTypeFilter" retirei algunas opções
    // e ficou assim "Cliente,Grupo Desconto Cliente,,,Nenhum"

    Caption = 'Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Sales Line Discount ET";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Discount Group,All Customers,Campaign,None';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustDiscGrList: Page "Customer Disc. Groups";
                        CampaignList: Page "Campaign List";
                        ItemList: Page "Item List";
                    begin
                        if SalesTypeFilter = SalesTypeFilter::"All Customers" then exit;

                        case SalesTypeFilter of
                            SalesTypeFilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = ACTION::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::"Customer Discount Group":
                                begin
                                    CustDiscGrList.LookupMode := true;
                                    if CustDiscGrList.RunModal = ACTION::LookupOK then
                                        Text := CustDiscGrList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::Campaign:
                                begin
                                    CampaignList.LookupMode := true;
                                    if CampaignList.RunModal = ACTION::LookupOK then
                                        Text := CampaignList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemTypeFilter; ItemTypeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type Filter';
                    OptionCaption = 'Service,Service Disc. Group,None';

                    trigger OnValidate()
                    begin
                        ItemTypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl; CodeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Service ET List";
                        ItemDiscGrList: Page "Service Discounts Group";
                    begin
                        //C+ -LCF- 28.04.2008
                        //Mudei as variaveis, anteriormente estavam
                        /*
                        ItemList Form  Lista Serviços
                        ItemDiscGrList  Form  Item Disc. Groups
                        */


                        case Rec.Type of
                            Rec.Type::Service:
                                begin
                                    ItemList.LookupMode := true;
                                    if ItemList.RunModal = ACTION::LookupOK then
                                        Text := ItemList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Rec.Type::"Service Disc. Group":
                                begin
                                    ItemDiscGrList.LookupMode := true;
                                    if ItemDiscGrList.RunModal = ACTION::LookupOK then
                                        Text := ItemDiscGrList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);

                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    var
                        TextMgt: Codeunit "PTSS TextManagement";
                    begin
                        if TextMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Sales CodeEditable";
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilter; CurrencyCodeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CurrencyList: Page Currencies;
                    begin
                        CurrencyList.LookupMode := true;
                        if CurrencyList.RunModal = ACTION::LookupOK then
                            Text := CurrencyList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeFilterOnAfterValid;
                        //StartingDateFilterOnAfterValid
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        "Sales CodeEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Cust: Record Customer;
        CustDiscGr: Record "Customer Discount Group";
        Campaign: Record Campaign;
        Item: Record "Services ET";
        ItemDiscGr: Record "Item Discount Group";
        SalesTypeFilter: Option Customer,"Customer Discount Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        ItemTypeFilter: Option Service,"Service Discount Group","None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: Label 'All Customers';
        CurrencyCodeFilter: Text[250];
        [InDataSet]
        "Sales CodeEditable": Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;

    //[Scope('OnPrem')]
    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then
                SalesTypeFilter := Rec."Sales Type"
            else
                SalesTypeFilter := SalesTypeFilter::None;

            if Rec.GetFilter(Type) <> '' then
                ItemTypeFilter := Rec.Type
            else
                ItemTypeFilter := ItemTypeFilter::None;

            SalesCodeFilter := Rec.GetFilter("Sales Code");
            CodeFilter := Rec.GetFilter(Code);
            CurrencyCodeFilter := Rec.GetFilter("Currency Code");
            Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;

    //[Scope('OnPrem')]
    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;
        CodeFilterCtrlEnable := true;
        //C+ -LCF-
        //CLEAR(CodeFilter);

        if SalesTypeFilter <> SalesTypeFilter::None then
            Rec.SetRange("Sales Type", SalesTypeFilter)
        else
            Rec.SetRange("Sales Type");

        if SalesTypeFilter in [SalesTypeFilter::"All Customers", SalesTypeFilter::None] then begin
            SalesCodeFilterCtrlEnable := false;
            SalesCodeFilter := '';
        end;

        if SalesCodeFilter <> '' then
            Rec.SetFilter("Sales Code", SalesCodeFilter)
        else
            Rec.SetRange("Sales Code");

        if ItemTypeFilter <> ItemTypeFilter::None then
            Rec.SetRange(Type, ItemTypeFilter)
        else
            Rec.SetRange(Type);

        if ItemTypeFilter = ItemTypeFilter::None then begin
            CodeFilterCtrlEnable := false;
            CodeFilter := '';
        end;

        if CodeFilter <> '' then begin
            Rec.SetFilter(Code, CodeFilter);
        end else
            Rec.SetRange(Code);

        if CurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", CurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;
        "Sales CodeEditable" := Rec."Sales Type" <> Rec."Sales Type"::"All Customers";


        //C+ -LCF- 28.04.2008
        //Mudei a variavel Item de "Serviços" para "Services ET"
        // reestruturei tb o codigo a baixo
        /*
        SourceTableName := '';
        CASE ItemTypeFilter OF
          ItemTypeFilter::Service:
            BEGIN
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);
              Item."No." := CodeFilter;
            END;
          ItemTypeFilter::"Service Discount Group":
            BEGIN
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,341);
              ItemDiscGr.Code := CodeFilter;
            END;
        END;
        */

        SourceTableName := '';
        case ItemTypeFilter of
            ItemTypeFilter::Service:
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 73015);
                    Item."No." := CodeFilter;
                end;
            ItemTypeFilter::"Service Discount Group":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 341);
                    ItemDiscGr.Code := CodeFilter;
                end;
        end;

        //C+ -LCF-  FIM

        SalesSrcTableName := '';
        case SalesTypeFilter of
            SalesTypeFilter::Customer:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                    Cust."No." := SalesCodeFilter;
                    if Cust.Find then
                        Description := Cust.Name;
                end;
            SalesTypeFilter::"Customer Discount Group":
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 340);
                    CustDiscGr.Code := SalesCodeFilter;
                    if CustDiscGr.Find then
                        Description := CustDiscGr.Description;
                end;
            SalesTypeFilter::Campaign:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5071);
                    Campaign."No." := SalesCodeFilter;
                    if Campaign.Find then
                        Description := Campaign.Description;
                end;

            SalesTypeFilter::"All Customers":
                begin
                    SalesSrcTableName := Text000;
                    Description := '';
                end;
        end;

        if SalesSrcTableName = Text000 then
            exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));

    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ItemTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        "Sales CodeEditable" := Rec."Sales Type" <> Rec."Sales Type"::"All Customers";
    end;
}

#pragma implicitwith restore

