table 31009780 "Service Discount Group"
{
    Caption = 'Service Discount Group';
    LookupPageID = "Service Discounts Group";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SalesLineDiscountET: Record "Sales Line Discount ET";
    begin
        SalesLineDiscountET.SetRange(Type,SalesLineDiscountET.Type::"Service Disc. Group");
        SalesLineDiscountET.SetRange(Code,Code);
        if SalesLineDiscountET.FindSet then
          Error(Text0001);

        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_ServiceDiscountGroup(Rec,false,false,true);
    end;

    trigger OnInsert()
    begin
        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_ServiceDiscountGroup(Rec,true,false,false);
    end;

    trigger OnModify()
    begin
        //C+ - Multi-Company invoicing
        MultiCompanyInvoicing.Multi_ServiceDiscountGroup(Rec,false,true,false);
    end;

    var
        Text0001: Label 'Cannot delete the selected code.';
        MultiCompanyInvoicing: Codeunit "Multi-Company Invoicing";
}

