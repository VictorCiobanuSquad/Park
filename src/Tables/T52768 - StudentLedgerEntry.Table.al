table 52768 "Student Ledger Entry"
{
    Caption = 'Services Payment Plan';

    fields
    {
        field(1; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            TableRelation = Students."No.";

            trigger OnValidate()
            begin
                if rStudents.Get("Student No.") then
                    "Student Customer No." := rStudents."Customer No.";
            end;
        }
        field(2; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(5; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            TableRelation = IF (Type = FILTER(Service)) "Services ET"."No."
            ELSE
            IF (Type = FILTER(Item)) Item."No.";

            trigger OnValidate()
            begin
                if Type = Type::Service then begin
                    GetService;

                    ServicesET.TestField(Blocked, false);

                    Description := ServicesET.Description;
                    "Description 2" := ServicesET."Description 2";
                    if (not ServicesET."Service Depending Other") then
                        Validate("Unit Price", ServicesET."Unit Price");
                    "Currency Code" := '';
                    UpdateUnitPrice(FieldNo("Service Code"));
                end else begin
                    if recItem.Get("Service Code") then;
                    recItem.TestField(Blocked, false);
                    Description := CopyStr(recItem.Description, 1, 30);
                    "Description 2" := CopyStr(recItem."Description 2", 1, 30);

                    "Currency Code" := '';
                end;
            end;
        }
        field(6; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(8; "Service Type"; Option)
        {
            Caption = 'Service Type';
            OptionCaption = ' ,Required,Optional,Depending,Ocasional';
            OptionMembers = " ",Required,Optional,Depending,Ocasional;
        }
        field(9; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(10; Quantity; Integer)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                Validate("Line Discount %");
                Validate(Amount);
            end;
        }
        field(11; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(12; Processed; Boolean)
        {
            Caption = 'Processed';
            Editable = false;
        }
        field(13; "Entity ID"; Code[20])
        {
            Caption = 'Entity ID';
            TableRelation = IF (Kinship = CONST("Irmão na Escola")) Students
            ELSE
            IF (Kinship = CONST("Próprio")) Students
            ELSE
            IF (Kinship = CONST(Pai)) "Users Family"
            ELSE
            IF (Kinship = CONST("Mãe")) "Users Family"
            ELSE
            IF (Kinship = CONST("Avô")) "Users Family"
            ELSE
            IF (Kinship = CONST("Avó")) "Users Family"
            ELSE
            IF (Kinship = CONST("Irmão")) "Users Family"
            ELSE
            IF (Kinship = CONST("Irmã")) "Users Family"
            ELSE
            IF (Kinship = CONST(Tio)) "Users Family"
            ELSE
            IF (Kinship = CONST(Tia)) "Users Family"
            ELSE
            IF (Kinship = CONST(Tutor)) "Users Family"
            ELSE
            IF (Kinship = CONST(Outro)) "Users Family";

            trigger OnValidate()
            begin
                GetUsersFamily;
                if (Kinship = Kinship::"Próprio") or (Kinship = Kinship::"Irmão na Escola") then begin
                    "Entity Customer No." := rStudents."Customer No.";
                    "Payment Method Code" := rStudents."Currency Code";
                end else begin
                    "Entity Customer No." := UsersFamily."Customer No.";
                    "Payment Method Code" := UsersFamily."Currency Code";
                end;
            end;
        }
        field(14; "Entity Customer No."; Code[20])
        {
            Caption = 'Entity Customer No.';
            TableRelation = Customer."No.";
        }
        field(15; "Percent %"; Decimal)
        {
            Caption = 'Percent %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;

            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(16; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Sales Header"."No.";
        }
        field(17; "Registed Invoice No."; Code[20])
        {
            Caption = 'Registered Invoice No.';
            TableRelation = IF (Company = FILTER(= '')) "Sales Invoice Header"."No.";

            trigger OnValidate()
            begin
                Registed := true;

                if "Registed Invoice No." = '' then
                    Registed := false;
            end;
        }
        field(18; Registed; Boolean)
        {
            Caption = 'Registered';
        }
        field(19; "Remaining Payment"; Boolean)
        {
            Caption = 'Remaining Payment';
            Editable = false;
        }
        field(20; "Payment Method Code"; Code[20])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method".Code;
        }
        field(21; "Check No."; Code[100])
        {
            Caption = 'Check No.';
        }
        field(22; Allowance; Boolean)
        {
            Caption = 'Allowance';
        }
        field(23; "Allowance Type"; Option)
        {
            Caption = 'Allowance Type';
            OptionCaption = ' ,Meal,Transport,Lodging,Training Scholarship,Other';
            OptionMembers = " ",Meal,Transport,Lodging,"Training Scholarship",Other;
        }
        field(25; "Type Fine"; Boolean)
        {
            Caption = 'Type Fine';
        }
        field(26; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Type = Type::Service then begin
                    GetService;
                    ServicesET.TestField(Blocked, false);
                end else begin
                    if recItem.Get("Service Code") then;
                    recItem.TestField(Blocked, false);
                end;

                if "Currency Code" <> '' then begin
                    "Line Discount Amount" :=
                      Round(Round((Quantity * "Unit Price") * "Percent %" / 100, Currency."Amount Rounding Precision") *
                        "Line Discount %" / 100, Currency."Amount Rounding Precision");

                    Validate(Amount);
                end
                else begin
                    if GLSetup.Get() then begin
                        "Line Discount Amount" :=
                          Round(Round((Quantity * "Unit Price") * "Percent %" / 100, GLSetup."Amount Rounding Precision") *
                            "Line Discount %" / 100, GLSetup."Amount Rounding Precision");

                        Validate(Amount);
                    end;
                end;

                //Validate("VAT Base Amount");
            end;
        }
        field(27; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(28; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                //Amount := (Quantity * "Unit Price")- ROUND(Amount,Currency."Amount Rounding Precision");


                if "Currency Code" <> '' then begin
                    Amount :=
                      Round(Round((Quantity * "Unit Price") * "Percent %" / 100, Currency."Amount Rounding Precision") -
                        "Line Discount Amount", Currency."Amount Rounding Precision");

                    Validate("VAT Base Amount", Amount);

                    //temporariamente o VAlor com IVA fica igual ao  Valor
                    "Amount Including VAT" := Amount;
                end
                else begin
                    if GLSetup.Get() then begin
                        Amount :=
                          Round(Round((Quantity * "Unit Price") * "Percent %" / 100, GLSetup."Amount Rounding Precision") -
                            "Line Discount Amount", GLSetup."Amount Rounding Precision");

                        Validate("VAT Base Amount", Amount);

                        //temporariamente o VAlor com IVA fica igual ao  Valor
                        "Amount Including VAT" := Amount;
                    end;
                end;


                // IVA
                //VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                if Customer.Get("Entity Customer No.") then
                    if VATPostingSetup.Get(
                           Customer."Customer Posting Group", ServicesET."VAT Serv. Posting Group") then begin
                        "VAT %" := VATPostingSetup."VAT %";
                        "Amount Including VAT" := Round("VAT Base Amount" * ("VAT %" / 100 + 1), GLSetup."Amount Rounding Precision");
                    end;
            end;
        }
        field(29; "Line Disc. Amount (DL)"; Decimal)
        {
            Caption = 'Line Discount Amount (DL)';
        }
        field(31; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;

            trigger OnLookup()
            var
                l_rDetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
            begin
                l_rDetailedStudLedgEntry.Reset;
                l_rDetailedStudLedgEntry.SetRange("Student Ledger Entry No.", "Entry No.");
                l_rDetailedStudLedgEntry.SetRange("Document Type", rDetailedStudLedgEntry."Document Type"::Payment);
                if PAGE.RunModal(PAGE::"Detailed Stud. Ledg. Entries", l_rDetailedStudLedgEntry) = ACTION::LookupOK then;
            end;
        }
        field(32; "Amount In Cre. Memo"; Decimal)
        {
            CalcFormula = - Sum("Detailed Stud. Ledg. Entry".Amount WHERE("Student Ledger Entry No." = FIELD("Entry No."),
                                                                          "Initial Document Type" = FILTER(Invoice | "Credit Memo"),
                                                                          "Entry Type" = FILTER(Annulment),
                                                                          "Document Type" = FILTER("Credit Memo")));
            Caption = 'Amount In Cre. Memo';
            FieldClass = FlowField;
        }
        field(33; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(42; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(43; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(44; "Adjusted Currency Factor"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 0 : 15;
        }
        field(45; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(46; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
        }
        field(47; "Student Customer No."; Code[20])
        {
            Caption = 'Student Client No.';
            TableRelation = Customer."No.";
        }
        field(48; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'Service,Item';
            OptionMembers = Service,Item;
        }
        field(49; "Course Code"; Code[30])
        {
            Caption = 'Course Code';
            Editable = false;
        }
        field(50; "Class Code"; Code[20])
        {
            Caption = 'Class Code';
            Editable = false;
            TableRelation = Class.Class;
        }
        field(51; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                // Validar o que fazer com isto, ou seja, se as regras que estao a ser aplicadas são ou nao para
                //continuar a ser usadas
            end;
        }
        field(52; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(53; "GL Entry No."; Integer)
        {
            Caption = 'GL Entry No.';
            Editable = false;
            TableRelation = "G/L Entry";
        }
        field(54; Kinship; Option)
        {
            Caption = 'Kinship';
            OptionCaption = ' ,Father,Mother,GrandFather,GrandMother,Brother,Sister,Brother in School,Uncle,Aunt,Himself,Tutor,Other';
            OptionMembers = " ",Pai,"Mãe","Avô","Avó","Irmão","Irmã","Irmão na Escola",Tio,Tia,"Próprio",Tutor,Outro;
        }
        field(55; "Debit Card Payment"; Decimal)
        {
            Caption = 'Debit Card Payment';
        }
        field(56; "Check Payment"; Decimal)
        {
            Caption = 'Check Payment';
        }
        field(57; "Credit Card Payment"; Decimal)
        {
            Caption = 'Credit Card Payment';
        }
        field(58; "Cash Payment"; Decimal)
        {
            Caption = 'Cash Payment';
        }
        field(59; "Transfer Payment"; Decimal)
        {
            Caption = 'Transfer Payment';
        }
        field(61; "Credit Note"; Boolean)
        {
            Caption = 'Credit Note';

            trigger OnValidate()
            begin
                if Payment then
                    Error(Text002, FieldCaption(Payment));


                if "Credit Note" then
                    "User Session" := UserId
                else begin
                    "User Session" := '';
                    "Amout Credit Note" := 0;
                end;
            end;
        }
        field(62; "Amout Credit Note"; Decimal)
        {
            Caption = 'Amout Credit Note';
        }
        field(63; Payment; Boolean)
        {
            Caption = 'Payment';

            trigger OnValidate()
            begin
                if "Credit Note" then
                    Error(Text002, FieldCaption("Credit Note"));


                if Payment then
                    "User Session" := UserId
                else begin
                    "User Session" := '';
                    "Debit Card Payment" := 0;
                    "Check Payment" := 0;
                    "Credit Card Payment" := 0;
                    "Cash Payment" := 0;
                    "Transfer Payment" := 0;
                end;
            end;
        }
        field(64; "User Session"; Code[20])
        {
            Caption = 'User Session';
            TableRelation = User;
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
        field(75; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Entry No.";
        }
        field(76; "Document Situation"; Option)
        {
            Caption = 'Document Situation';
            Editable = false;
            OptionCaption = ' ,Posted BG/PO,Closed BG/PO,BG/PO,Cartera,Closed Documents';
            OptionMembers = " ","Posted BG/PO","Closed BG/PO","BG/PO",Cartera,"Closed Documents";
        }
        field(77; "Document Status"; Option)
        {
            Caption = 'Document Status';
            Editable = false;
            OptionCaption = ' ,Open,Honored,Rejected,Redrawn';
            OptionMembers = " ",Open,Honored,Rejected,Redrawn;
        }
        field(78; "Total Remaning Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Stud. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Cust. Ledger Entry No.")));
            Caption = 'Total Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Company Remaning Amount"; Decimal)
        {
            Caption = 'Company Remaining Amount';
            Editable = false;
        }
        field(80; "Total Company Remaning Amount"; Decimal)
        {
            CalcFormula = Sum("Student Ledger Entry"."Company Remaning Amount" WHERE("Registed Invoice No." = FIELD("Registed Invoice No.")));
            Caption = 'Total Company Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81; "Multi Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Multi Cust. Ledger Entry No.';
            Editable = false;
        }
        field(82; "Total Amount for Credit Memo"; Decimal)
        {
            CalcFormula = Sum("Student Ledger Entry".Amount WHERE("Registed Invoice No." = FIELD("Registed Invoice No."),
                                                                   "Remaining Amount" = FILTER(= 0)));
            Caption = 'Total Amount for Credit Memo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Responsibility Center"; Code[10])
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
        field(1000; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
        }
        field(1001; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(50000; "Variant Code"; Code[50])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Student No.", Class, "School Year", "Schooling Year", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Remaining Amount";
        }
        key(Key3; "Service Code", "Student No.")
        {
        }
        key(Key4; "Student No.", Class, "Entity ID", Company)
        {
        }
        key(Key5; "Registed Invoice No.", "Remaining Amount")
        {
            SumIndexFields = Amount, "Company Remaning Amount";
        }
        key(Key6; "Entity ID")
        {
        }
        key(Key7; "Schooling Year", Class, "Student No.", "Entity ID", "Remaining Amount")
        {
            SumIndexFields = "Remaining Amount";
        }
        key(Key8; "School Year", "Service Code", Registed, Amount, "Posting Date", "Student No.", Class, "Responsibility Center")
        {
            SumIndexFields = Amount;
        }
        key(Key9; Company, Registed, "Student No.", "Entity Customer No.", "Registed Invoice No.")
        {
        }
        key(Key10; "Student No.")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*rCompany.RESET;
        rCompany.SETRANGE("Master Company",COMPANYNAME);
        IF rCompany.FINDFIRST THEN BEGIN
          IF Company <> COMPANYNAME THEN
          IF ("Invoice No." <> '') AND ("Registed Invoice No." = '') THEN
            ERROR(Text0005);
        END;*/

    end;

    trigger OnInsert()
    begin
        "User ID" := UserId;
        "Last Date Modified" := Today;
        UpdateFields(Rec);
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
        "Last Date Modified" := Today;
        Modify;
    end;

    var
        ServicesET: Record "Services ET";
        rStudents: Record Students;
        UsersFamily: Record "Users Family";
        Customer: Record Customer;
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.ET03";
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        Text001: Label 'The selected line is attribued to a user %1, it cannot be used.';
        Text002: Label 'The line is already selected for the type of document %1.';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0005: Label 'The line can not be deleted because its a multi-company invoice, this must be done by Processing Services.';
        rCompany: Record Company;
        rDetailedStudLedgEntry: Record "Detailed Stud. Ledg. Entry";
        rCustLedgerEntry: Record "Cust. Ledger Entry";
        TempRemaningAmount: Decimal;
        Text0006: Label 'The payment amount can''t be more then remaining amount.';
        recItem: Record Item;

    local procedure GetService()
    begin
        TestField("Service Code");
        if "Service Code" <> ServicesET."No." then
            ServicesET.Get("Service Code");
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        GetUsersFamily;

        case Type of
            Type::Item:
                begin
                    // PriceCalcMgt.FindSalesLineLineDisc(SalesHeader, Rec);
                    // PriceCalcMgt.FindSalesLinePrice(SalesHeader, Rec, CalledByFieldNo);
                    //guangai commented
                    //TODO: to uncomment
                end;
            Type::Service:
                begin
                    PriceCalcMgt.FindServiceLineLineDisc(UsersFamily, Rec);
                end;
        end;
        Validate("Unit Price");
    end;

    //[Scope('OnPrem')]
    procedure GetUsersFamily()
    begin
        TestField("Entity ID");
        if (Kinship = Kinship::"Próprio") or (Kinship = Kinship::"Irmão na Escola") then begin
            if "Entity ID" <> rStudents."No." then
                if rStudents.Get("Entity ID") then;
        end else begin
            if "Entity ID" <> UsersFamily."No." then
                if UsersFamily.Get("Entity ID") then;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetCurrencyCode()
    begin
        TestField("Currency Code");
        if "Currency Code" <> Currency.Code then
            Currency.Get("Currency Code");
    end;

    local procedure UpdateVATAmounts()
    var
        SalesLine2: Record "Sales Line";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
    begin



        // Validar o que fazer com isto, ou seja, se as regras que estao a ser aplicadas são ou nao para
        //continuar a ser usadas

        /*
        
        SalesLine2.SETRANGE("Document Type","Document Type");
        SalesLine2.SETRANGE("Document No.","Document No.");
        SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
        IF "Line Amount" = 0 THEN
          IF xRec."Line Amount" >= 0 THEN
            SalesLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            SalesLine2.SETFILTER(Amount,'<%1',0)
        ELSE
          IF "Line Amount" > 0 THEN
            SalesLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            SalesLine2.SETFILTER(Amount,'<%1',0);
        SalesLine2.SETRANGE("VAT Identifier","VAT Identifier");
        SalesLine2.SETRANGE("Tax Group Code","Tax Group Code");
        
        IF "Line Amount" = "Inv. Discount Amount" THEN BEGIN
          Amount := 0;
          "VAT Base Amount" := 0;
          "Amount Including VAT" := 0;
          IF "Line No." <> 0 THEN
            IF MODIFY THEN
              IF SalesLine2.FIND('+') THEN BEGIN
                SalesLine2.UpdateAmounts;
                SalesLine2.MODIFY;
              END;
        END ELSE BEGIN
          TotalLineAmount := 0;
          TotalInvDiscAmount := 0;
          TotalAmount := 0;
          TotalAmountInclVAT := 0;
          TotalQuantityBase := 0;
            IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
             (("VAT Calculation Type" IN
        
        //--PT----
             ["VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"No Taxable VAT",
              "VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
        //--------
        
          THEN BEGIN
            IF SalesLine2.FIND('-') THEN
              REPEAT
                TotalLineAmount := TotalLineAmount + SalesLine2."Line Amount";
                TotalInvDiscAmount := TotalInvDiscAmount + SalesLine2."Inv. Discount Amount";
                TotalAmount := TotalAmount + SalesLine2.Amount;
                TotalAmountInclVAT := TotalAmountInclVAT + SalesLine2."Amount Including VAT";
                TotalQuantityBase := TotalQuantityBase + SalesLine2."Quantity (Base)";
              UNTIL SalesLine2.NEXT = 0;
          END;
        
          IF SalesHeader."Prices Including VAT" THEN
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT",
        
        //--PT----
              "VAT Calculation Type"::"No Taxable VAT":
        //--------
        
                BEGIN
                  Amount :=
                    ROUND(
        
        //--PT----
                      (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + ("VAT %" + "ND %") / 100),
        //--------
        
                      Currency."Amount Rounding Precision") -
                    TotalAmount;
                  "VAT Base Amount" :=
                    ROUND(
                      Amount * (1 - SalesHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalLineAmount + "Line Amount" +
                    ROUND(
        
        //--PT----
                      (TotalAmount + Amount) * (SalesHeader."VAT Base Discount %" / 100) * ("VAT %" + "ND %") / 100,
        //--------
        
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  SalesHeader.TESTFIELD("VAT Base Discount %",0);
                  Amount :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                      SalesHeader."Currency Factor") -
                    TotalAmount;
                  IF Amount <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                  ELSE
        
        //--PT----
                    BEGIN
                      "VAT %" := 0;
                      "ND %" := 0;
                    END;
        //--------
                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                END;
        //--------
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT",
        
        //--PT----
              "VAT Calculation Type"::"No Taxable VAT":
        //--------
        
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" :=
                     ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
        
        //--PT----
                      (TotalAmount + Amount) * (1 - SalesHeader."VAT Base Discount %" / 100) * ("VAT %" + "ND %") / 100,
        //--------
        
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                  "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      SalesTaxCalculate.CalculateTax(
                        "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                        (TotalAmount + Amount),(TotalQuantityBase + "Quantity (Base)"),
                        SalesHeader."Currency Factor"),Currency."Amount Rounding Precision") -
                    TotalAmountInclVAT;
                  IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
        
        //--PT----
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.000001)
                  ELSE
                    BEGIN
                      "VAT %" := 0;
                      "ND %" := 0;
                    END;
        //--------
        
                END;
            END;
          END;
        
        */

    end;

    //[Scope('OnPrem')]
    procedure ApplyAllEntries(pField: Integer)
    var
        l_rStudentLedgerEntry: Record "Student Ledger Entry";
    begin
        case pField of
            FieldNo(Payment):
                begin
                    if Company = '' then begin
                        if ("Total Remaning Amount" < "Debit Card Payment") or
                           ("Total Remaning Amount" < "Check Payment") or
                           ("Total Remaning Amount" < "Credit Card Payment") or
                           ("Total Remaning Amount" < "Cash Payment") or
                           ("Total Remaning Amount" < "Transfer Payment") then
                            Error(Text0006);
                    end else begin
                        if ("Total Company Remaning Amount" < "Debit Card Payment") or
                           ("Total Company Remaning Amount" < "Check Payment") or
                           ("Total Company Remaning Amount" < "Credit Card Payment") or
                           ("Total Company Remaning Amount" < "Cash Payment") or
                           ("Total Company Remaning Amount" < "Transfer Payment") then
                            Error(Text0006);
                    end;
                    Clear(TempRemaningAmount);
                    //Current Line
                    DistValueForEntries(pField, Rec, true);
                    //

                    l_rStudentLedgerEntry.Reset;
                    if Company = '' then
                        l_rStudentLedgerEntry.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry No.")
                    else
                        l_rStudentLedgerEntry.SetRange("Registed Invoice No.", "Registed Invoice No.");
                    l_rStudentLedgerEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
                    l_rStudentLedgerEntry.SetFilter("Remaining Amount", '>%1', 0);
                    if l_rStudentLedgerEntry.FindSet then begin
                        repeat
                            l_rStudentLedgerEntry.Payment := Payment;
                            l_rStudentLedgerEntry.Validate(Payment);
                            DistValueForEntries(pField, l_rStudentLedgerEntry, false);
                        until l_rStudentLedgerEntry.Next = 0;
                        Clear(TempRemaningAmount);
                    end;
                end;
            FieldNo("Credit Note"):
                begin

                    Clear(TempRemaningAmount);
                    //Current Line
                    DistValueForEntries(pField, Rec, true);
                    //

                    l_rStudentLedgerEntry.Reset;
                    if Company = '' then
                        l_rStudentLedgerEntry.SetRange("Cust. Ledger Entry No.", "Cust. Ledger Entry No.")
                    else
                        l_rStudentLedgerEntry.SetRange("Registed Invoice No.", "Registed Invoice No.");
                    l_rStudentLedgerEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
                    if Rec."Remaining Amount" = 0 then
                        l_rStudentLedgerEntry.SetFilter("Remaining Amount", '=%1', 0)
                    else
                        l_rStudentLedgerEntry.SetFilter("Remaining Amount", '>%1', 0);
                    if l_rStudentLedgerEntry.FindSet then begin
                        repeat
                            l_rStudentLedgerEntry."Credit Note" := "Credit Note";
                            l_rStudentLedgerEntry.Validate("Credit Note");
                            DistValueForEntries(pField, l_rStudentLedgerEntry, false);
                        until l_rStudentLedgerEntry.Next = 0;
                        Clear(TempRemaningAmount);
                    end;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DistValueForEntries(pField: Integer; pRec: Record "Student Ledger Entry"; CurrentLine: Boolean)
    var
        l_ClearTempPayment: Boolean;
    begin
        case pField of
            FieldNo(Payment):
                begin
                    if CurrentLine then begin
                        Clear(TempRemaningAmount);
                        if pRec."Remaining Amount" < pRec."Debit Card Payment" then begin
                            TempRemaningAmount := pRec."Debit Card Payment" - pRec."Remaining Amount";
                            "Debit Card Payment" := pRec."Remaining Amount";
                        end;
                        if pRec."Remaining Amount" < pRec."Check Payment" then begin
                            TempRemaningAmount := pRec."Check Payment" - pRec."Remaining Amount";
                            "Check Payment" := pRec."Remaining Amount";
                        end;
                        if pRec."Remaining Amount" < pRec."Credit Card Payment" then begin
                            TempRemaningAmount := pRec."Credit Card Payment" - pRec."Remaining Amount";
                            "Credit Card Payment" := pRec."Remaining Amount";
                        end;
                        if pRec."Remaining Amount" < pRec."Cash Payment" then begin
                            TempRemaningAmount := pRec."Cash Payment" - pRec."Remaining Amount";
                            "Cash Payment" := pRec."Remaining Amount";
                        end;
                        if pRec."Remaining Amount" < pRec."Transfer Payment" then begin
                            TempRemaningAmount := pRec."Transfer Payment" - pRec."Remaining Amount";
                            "Transfer Payment" := pRec."Remaining Amount";
                        end;
                        Modify(true);

                    end else begin
                        l_ClearTempPayment := false;
                        if "Debit Card Payment" <> 0 then begin
                            if pRec."Remaining Amount" < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                pRec."Debit Card Payment" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Debit Card Payment" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            pRec."Debit Card Payment" := 0;
                            if TempRemaningAmount = 0 then
                                pRec.Payment := false;
                        end;

                        if "Check Payment" <> 0 then begin
                            if pRec."Remaining Amount" < pRec."Check Payment" then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                pRec."Check Payment" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Check Payment" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            pRec."Check Payment" := 0;
                            if TempRemaningAmount = 0 then
                                pRec.Payment := false;
                        end;

                        if "Credit Card Payment" <> 0 then begin
                            if pRec."Remaining Amount" < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                pRec."Credit Card Payment" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Credit Card Payment" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            pRec."Credit Card Payment" := 0;
                            if TempRemaningAmount = 0 then
                                pRec.Payment := false;
                        end;

                        if "Cash Payment" <> 0 then begin
                            if pRec."Remaining Amount" < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                pRec."Cash Payment" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Cash Payment" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            pRec."Cash Payment" := 0;
                            if TempRemaningAmount = 0 then
                                pRec.Payment := false;
                        end;

                        if "Transfer Payment" <> 0 then begin
                            if pRec."Remaining Amount" < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                "Transfer Payment" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Transfer Payment" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            pRec."Transfer Payment" := 0;
                            if TempRemaningAmount = 0 then
                                pRec.Payment := false;
                        end;
                        if l_ClearTempPayment then
                            TempRemaningAmount := 0;
                        pRec.Modify(true);

                    end;
                end;
            FieldNo("Credit Note"):
                begin
                    if CurrentLine then begin
                        if pRec."Remaining Amount" > 0 then begin
                            if pRec."Remaining Amount" < pRec."Amout Credit Note" then begin
                                TempRemaningAmount := pRec."Amout Credit Note" - pRec."Remaining Amount";
                                "Amout Credit Note" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end;
                        end else begin
                            if pRec.Amount < pRec."Amout Credit Note" then begin
                                TempRemaningAmount := pRec."Amout Credit Note" - pRec.Amount;
                                "Amout Credit Note" := pRec.Amount;
                                l_ClearTempPayment := false;
                            end;
                        end;
                        Modify;
                    end else begin
                        if pRec."Remaining Amount" > 0 then begin
                            if pRec."Remaining Amount" < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec."Remaining Amount";
                                pRec."Amout Credit Note" := pRec."Remaining Amount";
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Amout Credit Note" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end else begin
                            if pRec.Amount < TempRemaningAmount then begin
                                TempRemaningAmount := TempRemaningAmount - pRec.Amount;
                                pRec."Amout Credit Note" := pRec.Amount;
                                l_ClearTempPayment := false;
                            end else begin
                                pRec."Amout Credit Note" := TempRemaningAmount;
                                l_ClearTempPayment := true;
                            end;
                        end;
                        if TempRemaningAmount = 0 then
                            pRec."Credit Note" := false;

                        if l_ClearTempPayment then
                            TempRemaningAmount := 0;
                        pRec.Modify(true);
                    end;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure UpdateFields(pRec: Record "Student Ledger Entry")
    var
        l_rStudentLedgerEntry: Record "Student Ledger Entry";
    begin
        // Remaining Amount //
        if pRec.Company = '' then begin
            rDetailedStudLedgEntry.Reset;
            rDetailedStudLedgEntry.SetCurrentKey("Initial Document Type", "Student Ledger Entry No.");
            rDetailedStudLedgEntry.SetRange("Student Ledger Entry No.", pRec."Entry No.");
            rDetailedStudLedgEntry.SetFilter("Initial Document Type", '%1|%2|%3|%4|%5',
                                            rDetailedStudLedgEntry."Initial Document Type"::Invoice,
                                            rDetailedStudLedgEntry."Initial Document Type"::Payment,
                                            rDetailedStudLedgEntry."Initial Document Type"::"Credit Memo",
                                            rDetailedStudLedgEntry."Initial Document Type"::Bill,
                                            rDetailedStudLedgEntry."Initial Document Type"::Refund);
            if rDetailedStudLedgEntry.CalcSums(Amount) then begin
                if l_rStudentLedgerEntry.Get(pRec."Entry No.") then begin
                    l_rStudentLedgerEntry."Remaining Amount" := rDetailedStudLedgEntry.Amount;
                    l_rStudentLedgerEntry.Modify(false);
                end;
            end;
        end else begin
            "Remaining Amount" := pRec."Company Remaning Amount";
            Modify(false);
        end;

        // Doc Situation //
        if pRec.Company = '' then begin
            rCustLedgerEntry.Reset;
            rCustLedgerEntry.SetCurrentKey("Entry No.");
            rCustLedgerEntry.SetRange("Document No.", pRec."Registed Invoice No.");
            //rCustLedgerEntry.SetFilter("Document Situation", '<>%1', 0);
            if rCustLedgerEntry.FindLast then begin
                if l_rStudentLedgerEntry.Get(pRec."Entry No.") then begin
                    //l_rStudentLedgerEntry."Document Situation" := rCustLedgerEntry."Document Situation";
                    l_rStudentLedgerEntry.Modify(false);
                end;
            end;
        end else begin
            Clear(rCustLedgerEntry);
            rCustLedgerEntry.ChangeCompany(Company);
            rCustLedgerEntry.Reset;
            rCustLedgerEntry.SetCurrentKey("Entry No.");
            rCustLedgerEntry.SetRange("Document No.", pRec."Registed Invoice No.");
            //rCustLedgerEntry.SetFilter("Document Situation", '<>%1', 0);
            if rCustLedgerEntry.FindLast then begin
                //"Document Situation" := rCustLedgerEntry."Document Situation";
                Modify(false);
            end;
        end;


        // Doc Status //
        if pRec.Company = '' then begin
            rCustLedgerEntry.Reset;
            rCustLedgerEntry.SetCurrentKey("Entry No.");
            rCustLedgerEntry.SetRange("Document No.", pRec."Registed Invoice No.");
            // rCustLedgerEntry.SetFilter("Document Status", '<>%1', 0);
            if rCustLedgerEntry.FindLast then begin
                if l_rStudentLedgerEntry.Get(pRec."Entry No.") then begin
                    //l_rStudentLedgerEntry."Document Status" := rCustLedgerEntry."Document Status";
                    if l_rStudentLedgerEntry."Document Status" = l_rStudentLedgerEntry."Document Status"::Honored then
                        l_rStudentLedgerEntry."Remaining Amount" := 0;
                    l_rStudentLedgerEntry.Modify(false);
                end;
            end;
        end else begin
            Clear(rCustLedgerEntry);
            rCustLedgerEntry.ChangeCompany(Company);
            rCustLedgerEntry.Reset;
            rCustLedgerEntry.SetCurrentKey("Entry No.");
            rCustLedgerEntry.SetRange("Document No.", pRec."Registed Invoice No.");
            //rCustLedgerEntry.SetFilter("Document Status", '<>%1', 0);
            if rCustLedgerEntry.FindLast then begin
                //"Document Status" := rCustLedgerEntry."Document Status";
                if "Document Status" = "Document Status"::Honored then
                    "Remaining Amount" := 0;
                Modify(false);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure RefreshTable()
    var
        l_rStudentLedgerEntry: Record "Student Ledger Entry";
        l_rStudentLedgerEntryTEMP: Record "Student Ledger Entry" temporary;
    begin
        l_rStudentLedgerEntry.Reset;
        if l_rStudentLedgerEntry.FindSet then begin
            l_rStudentLedgerEntryTEMP.DeleteAll;
            repeat
                if not l_rStudentLedgerEntryTEMP.Get(l_rStudentLedgerEntry."Entry No.") then begin
                    l_rStudentLedgerEntryTEMP.Init;
                    l_rStudentLedgerEntryTEMP.TransferFields(l_rStudentLedgerEntry);
                    l_rStudentLedgerEntryTEMP.Insert;
                end;
            until l_rStudentLedgerEntry.Next = 0;
        end;
        l_rStudentLedgerEntryTEMP.Reset;
        if l_rStudentLedgerEntryTEMP.FindSet then begin
            repeat
                l_rStudentLedgerEntryTEMP.UpdateFields(l_rStudentLedgerEntryTEMP);
            until l_rStudentLedgerEntryTEMP.Next = 0;
        end;
    end;
}

