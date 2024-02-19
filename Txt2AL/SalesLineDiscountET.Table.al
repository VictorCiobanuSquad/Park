table 31009779 "Sales Line Discount ET"
{
    Caption = 'Sales Line Discount ET';
    LookupPageID = "SubForm Giving Services";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF (Type=CONST(Service)) "Services ET"
                            ELSE IF (Type=CONST("Service Disc. Group")) "Service Discount Group";

            trigger OnValidate()
            begin
                if xRec.Code <> Code then begin
                  "Variant Code" := '';
                  "Unit of Measure Code" := '';
                end;
            end;
        }
        field(2;"Sales Code";Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Sales Type"=CONST("Customer Disc. Group")) "Customer Discount Group"
                            ELSE IF ("Sales Type"=CONST(Customer)) Customer
                            ELSE IF ("Sales Type"=CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then begin
                  case "Sales Type" of
                    "Sales Type"::"All Customers":
                      Error(Text001,FieldCaption("Sales Code"));
                    "Sales Type"::Campaign:
                      begin
                        Campaign.Get("Sales Code");
                        "Starting Date" := Campaign."Starting Date";
                        "Ending Date" := Campaign."Ending Date";
                      end;
                  end;
                end;
            end;
        }
        field(3;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                  Error(Text000,FieldCaption("Starting Date"),FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                  exit else
                    if "Sales Type" = "Sales Type"::Campaign then
                      Error(Text003,FieldCaption("Starting Date"),FieldCaption("Ending Date"),FieldCaption("Sales Type"),("Sales Type"));
            end;
        }
        field(5;"Line Discount %";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(13;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then
                  Validate("Sales Code",'');
            end;
        }
        field(14;"Minimum Quantity";Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");

                if CurrFieldNo = 0 then
                  exit else
                    if "Sales Type" = "Sales Type"::Campaign then
                      Error(Text003,FieldCaption("Starting Date"),FieldCaption("Ending Date"),FieldCaption("Sales Type"),("Sales Type"));
            end;
        }
        field(21;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service,Service Disc. Group';
            OptionMembers = Service,"Service Disc. Group";

            trigger OnValidate()
            begin
                if xRec.Type <> Type then
                  Validate(Code,'');
            end;
        }
        field(5400;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Service)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD(Code));

            trigger OnValidate()
            begin
                TestField(Type,Type::Service);
            end;
        }
        field(5700;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Service)) "Item Variant".Code WHERE ("Item No."=FIELD(Code));

            trigger OnValidate()
            begin
                TestField(Type,Type::Service);
            end;
        }
    }

    keys
    {
        key(Key1;Type,"Code","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key2;"Sales Type","Sales Code",Type,"Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_SalesLineDiscountET(Rec,false,false,true);
    end;

    trigger OnInsert()
    begin
        if "Sales Type" = "Sales Type"::"All Customers" then
          "Sales Code" := ''
        else
          TestField("Sales Code");
        TestField(Code);

        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_SalesLineDiscountET(Rec,true,false,false);
    end;

    trigger OnModify()
    begin
        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_SalesLineDiscountET(Rec,false,true,false);
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "Sales Type"::"All Customers" then
          TestField("Sales Code");
        TestField(Code);
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Text003: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
        MultiCompanyInvoicing: Codeunit "Multi-Company Invoicing";
}

