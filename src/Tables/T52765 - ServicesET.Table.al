table 52765 "Services ET"
{
    Caption = 'Services ET';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Service ET List";
    LookupPageID = "Service ET List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    rEduConf.Get;
                    NoSeriesMgt.TestManual(rEduConf."Service Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := Description;
            end;
        }
        field(3; "Search Description"; Code[80])
        {
            Caption = 'Search Description';
        }
        field(4; "Description 2"; Text[80])
        {
            Caption = 'Description 2';
        }
        field(5; "Unit of Measure Type"; Option)
        {
            Caption = 'Unit of Measure Type';
            OptionCaption = 'Hour,Day,Week,Month,Quarter,Unit';
            OptionMembers = Hour,Day,Week,Month,Quarter,Unit;
        }
        field(6; Periodicity; Option)
        {
            Caption = 'Periodicity';
            OptionCaption = ' ,Monthly,Trimestrally,Quarterly,Anual';
            OptionMembers = " ",Monthly,Trimestrally,Quarterly,Anual;
        }
        field(7; Subsidy; Boolean)
        {
            Caption = 'Allowance';
        }
        field(8; "Subsidy Type"; Option)
        {
            Caption = 'Allowance Type';
            OptionCaption = ' ,Meal,Transport,Lodging,Training Scholarship,Other';
            OptionMembers = " ",Meal,Transport,Lodging,"Training Scholarship",Other;
        }
        field(9; "Service Disc. Group"; Code[10])
        {
            Caption = 'Service Disc. Group';
            TableRelation = "Service Discount Group".Code;
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
        }
        field(11; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(12; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(13; "Gen. Serv. Posting Group"; Code[10])
        {
            Caption = 'Gen. Serv. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin

                if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Serv. Posting Group") then
                    Validate("VAT Serv. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(14; "VAT Serv. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(15; "IRS Declaration Code"; Code[10])
        {
            Caption = 'IRS Declaration Code';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(IRS),
                                                                                "Legal Code Type" = FILTER(" "));

            trigger OnValidate()
            begin
                rLegalCodes.Reset;
                rLegalCodes.SetRange("Parish/Council/District Code", "IRS Declaration Code");
                rLegalCodes.SetRange(Type, rLegalCodes.Type::IRS);
                rLegalCodes.SetRange("Legal Code Type", rLegalCodes."Legal Code Type"::" ");
                if rLegalCodes.FindFirst then
                    "IRS Declaration Description" := rLegalCodes.Description
                else
                    "IRS Declaration Description" := '';
            end;
        }
        field(16; "IRS Declaration Description"; Text[80])
        {
            Caption = 'IRS Declaration Description';
        }
        field(17; "Service Depending Other"; Boolean)
        {
            Caption = 'Service Depending on Another';
        }
        field(18; "Service Depending Code"; Code[20])
        {
            Caption = 'Service Depending Code';
            TableRelation = "Services ET"."No.";
        }
        field(19; "Percent %"; Decimal)
        {
            Caption = 'Percent %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
        }
        field(20; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(21; "Unit Price Purchase"; Decimal)
        {
            Caption = 'Unit Price Purchase';
        }
        field(22; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Service),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(23; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code;
        }
        field(24; "Service Type"; Option)
        {
            Caption = 'Service Type';
            OptionCaption = ' ,Required,Optional,Depending,Ocasional';
            OptionMembers = " ",Required,Optional,Depending,Ocasional;
        }
        field(30; January; Boolean)
        {
            Caption = 'January';
        }
        field(31; February; Boolean)
        {
            Caption = 'February';
        }
        field(32; March; Boolean)
        {
            Caption = 'March';
        }
        field(33; April; Boolean)
        {
            Caption = 'April';
        }
        field(34; May; Boolean)
        {
            Caption = 'May';
        }
        field(35; June; Boolean)
        {
            Caption = 'June';
        }
        field(36; July; Boolean)
        {
            Caption = 'July';
        }
        field(37; August; Boolean)
        {
            Caption = 'August';
        }
        field(38; Setember; Boolean)
        {
            Caption = 'September';
        }
        field(39; October; Boolean)
        {
            Caption = 'October';
        }
        field(40; November; Boolean)
        {
            Caption = 'November';
        }
        field(41; December; Boolean)
        {
            Caption = 'December';
        }
        field(42; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(43; "Multiple invoices per month"; Boolean)
        {
            Caption = 'Multiple invoices per month';
            InitValue = true;
        }
        field(72; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(73; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(74; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company.Name;

            trigger OnLookup()
            var
                lCompany: Record Company;
            begin
                lCompany.Reset;
                //lCompany.SETRANGE("Master Company",COMPANYNAME);
                if PAGE.RunModal(0, lCompany) = ACTION::LookupOK then
                    Company := lCompany.Name;
            end;
        }
        field(1000; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(1001; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        key(Key3; "Gen. Serv. Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rServicesPlanLine.Reset;
        rServicesPlanLine.SetRange("Service Code", "No.");
        if rServicesPlanLine.FindFirst then
            Error(Text0005);

        rStudentServicePlan.Reset;
        rStudentServicePlan.SetRange("Service Code", "No.");
        if rStudentServicePlan.FindFirst then
            Error(Text0006);

        //C+ - Multi-Company invoicing
        //   MultiCompanyInvoicing.Multi_Service(Rec, false, false, true);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            rEduConf.Get;
            rEduConf.TestField("Service Nos.");
            NoSeriesMgt.InitSeries(rEduConf."Service Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;


        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";


        "Last Date Modified" := Today;
        "User ID" := UserId;

        //C+ - Multi-Company invoicing
        //  MultiCompanyInvoicing.Multi_Service(Rec, true, false, false);
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;

        //C+ - Multi-Company invoicing
        // MultiCompanyInvoicing.Multi_Service(Rec, false, true, false);
    end;

    var
        rEduConf: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        rServicesPlanLine: Record "Services Plan Line";
        Text0005: Label 'There are Service Plans with the selected Service. Deleting is not allowed.';
        rStudentServicePlan: Record "Student Service Plan";
        Text0006: Label 'There are Student Service Plans with the selected Service. Deleting is not allowed.';
        DimMgt: Codeunit DimensionManagement;
        MultiCompanyInvoicing: Codeunit "Multi-Company Invoicing";
        rLegalCodes: Record "Legal Codes";

    //[Scope('OnPrem')]
    procedure AssistEdit(OldService: Record "Services ET"): Boolean
    var
        ServicesET: Record "Services ET";
    begin
        rEduConf.Get;
        rEduConf.TestField("Service Nos.");
        if NoSeriesMgt.SelectSeries(rEduConf."Service Nos.", OldService."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            // Rec := ServicesET;
            // exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Services ET", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;
}

