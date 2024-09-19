report 52802 "Create Customer Form Students"
{
    Caption = 'Create Customer Form Students';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Students; Students)
        {

            trigger OnAfterGetRecord()
            begin

                Students."Payment Method Code" := rEduConfig."Payment Method Code";
                Students."Payment Terms Code" := rEduConfig."Payment Terms Code";
                Students."Customer Disc. Group" := rEduConfig."Customer Disc. Group";
                Students."Customer Posting Group" := rEduConfig."Customer Posting Group";
                Students."Gen. Bus. Posting Group" := rEduConfig."Gen. Bus. Posting Group";
                Students."VAT Bus. Posting Group" := rEduConfig."VAT Bus. Posting Group";
                CustomerCreate(Students);
            end;

            trigger OnPreDataItem()
            begin
                rEduConfig.Get;
                rEduConfig.TestField("Payment Method Code");
                rEduConfig.TestField("Payment Terms Code");
                rEduConfig.TestField("Customer Posting Group");
                rEduConfig.TestField("Gen. Bus. Posting Group");
                rEduConfig.TestField("VAT Bus. Posting Group");
            end;
        }
        dataitem("Users Family / Students"; "Users Family / Students")
        {
            DataItemTableView = SORTING("School Year", "Student Code No.", Kinship, "No.") WHERE("Paying Entity" = FILTER(true));

            trigger OnAfterGetRecord()
            begin
                CustomerCreate2("Users Family / Students");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text001);
    end;

    var
        rEduConfig: Record "Edu. Configuration";
        rCustomer: Record Customer;
        Text001: Label 'Done.';

    //[Scope('OnPrem')]
    procedure CustomerCreate(var rstudents: Record Students)
    var
        Text002: Label 'You must select one Paying entity';
        recCustomer: Record Customer;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        Text001: Label 'The Candidate %1 already has a customer %2';
        Text004: Label 'The Paying entity "%1 - %2" does not created as customer.\ Do you whant create as customer?';
        rUsersFamily: Record "Users Family";
        Text003: Label 'Operation interrupted by the user.';
    begin

        if rSalesReceivablesSetup.Get then;
        rSalesReceivablesSetup.TestField(rSalesReceivablesSetup."Customer Nos.");

        recCustomer.Init;
        //recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
        recCustomer."No." := CU_NoSeries.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
        recCustomer.Validate(Name, rstudents."Short Name");
        recCustomer.Validate("Post Code", rstudents."Post Code");
        recCustomer.Validate("Gen. Bus. Posting Group", rstudents."Gen. Bus. Posting Group");
        recCustomer.Validate("Customer Posting Group", rstudents."Customer Posting Group");
        recCustomer.Validate("VAT Bus. Posting Group", rstudents."VAT Bus. Posting Group");
        recCustomer.Validate("Payment Terms Code", rstudents."Payment Terms Code");
        recCustomer.Validate("Payment Method Code", rstudents."Payment Method Code");
        recCustomer.Validate("Customer Disc. Group", rstudents."Customer Disc. Group");
        recCustomer."Student No." := rstudents."No.";
        recCustomer."VAT Registration No." := rstudents."VAT Registration No.";
        recCustomer.Insert;
        rstudents."Customer No." := recCustomer."No.";
        rstudents.Modify;
    end;

    //[Scope('OnPrem')]
    procedure CustomerCreate2(var pUsersFamilyStudents: Record "Users Family / Students")
    var
        Text002: Label 'You must select one Paying entity';
        recCustomer: Record Customer;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        Text001: Label 'The Candidate %1 already has a customer %2';
        Text004: Label 'Paying entity "%1 - %2" is not created as a customer.\ Do you want to create this customer?';
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        Text003: Label 'Operation interrupted by the user.';
    begin


        if rSalesReceivablesSetup.Get then;
        rSalesReceivablesSetup.TestField(rSalesReceivablesSetup."Customer Nos.");


        if (pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::Himself) or
            (pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::"Brother in School") then begin
            if rStudents.Get(pUsersFamilyStudents."No.") then;
            if rStudents."Customer No." = '' then begin
                recCustomer.Init;
                //recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                //TODO: to test
                recCustomer."No." := CU_NoSeries.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rStudents."Short Name");
                recCustomer.Validate("Post Code", rStudents."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rStudents."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rStudents."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rStudents."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rStudents."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rStudents."Payment Method Code");
                recCustomer.Validate("Customer Disc. Group", rStudents."Customer Disc. Group");
                recCustomer."Student No." := pUsersFamilyStudents."Student Code No.";
                recCustomer.Validate(Address, rStudents.Address);
                recCustomer.Validate("Address 2", rStudents."Address 2");
                recCustomer.Validate("Phone No.", rStudents."Phone No.");
                recCustomer.Validate("E-Mail", rStudents."E-mail");
                recCustomer.Validate("Home Page", rStudents."Home Page");
                recCustomer."Invoice Disc. Code" := recCustomer."No.";
                recCustomer.Validate("Responsibility Center", rStudents."Responsibility Center");
                recCustomer.Insert;
                rStudents."Customer No." := recCustomer."No.";
                rStudents.Modify;
            end;
        end else begin
            if rUsersFamily.Get(pUsersFamilyStudents."No.") then;
            if rUsersFamily."Customer No." = '' then begin
                recCustomer.Init;
                //recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer."No." := CU_NoSeries.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rUsersFamily."Short Name");
                recCustomer.Validate("Post Code", rUsersFamily."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rUsersFamily."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rUsersFamily."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rUsersFamily."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rUsersFamily."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rUsersFamily."Payment Method Code");
                recCustomer.Validate("Customer Disc. Group", rUsersFamily."Customer Disc. Group");
                recCustomer.Validate(Address, rUsersFamily.Address);
                recCustomer.Validate("Address 2", rUsersFamily."Address 2");
                recCustomer.Validate("Phone No.", rUsersFamily."Phone No.");
                recCustomer.Validate("E-Mail", rUsersFamily."E-mail");
                recCustomer.Validate("Home Page", rUsersFamily."Home Page");
                recCustomer."User Family No." := pUsersFamilyStudents."No.";
                recCustomer.Validate("Responsibility Center", rUsersFamily."Responsibility Center");
                recCustomer."Invoice Disc. Code" := recCustomer."No.";
                recCustomer.Insert;
                rUsersFamily."Customer No." := recCustomer."No.";
                rUsersFamily.Modify;
            end;
        end;

        // Verificar se o aluno já tem nº de cliente
        rStudents.Reset;
        if rStudents.Get(pUsersFamilyStudents."Student Code No.") then begin
            if rStudents."Customer No." = '' then begin
                recCustomer.Init;
                //recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer."No." := CU_NoSeries.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rStudents."Short Name");
                recCustomer.Validate("Post Code", rStudents."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rStudents."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rStudents."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rStudents."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rStudents."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rStudents."Payment Method Code");
                recCustomer."Student No." := pUsersFamilyStudents."Student Code No.";
                recCustomer."Invoice Disc. Code" := recCustomer."No.";
                recCustomer.Validate(Address, rStudents.Address);
                recCustomer.Validate("Address 2", rStudents."Address 2");
                recCustomer.Validate("Phone No.", rStudents."Phone No.");
                recCustomer.Validate("E-Mail", rStudents."E-mail");
                recCustomer.Validate("Home Page", rStudents."Home Page");
                recCustomer.Validate("Responsibility Center", rStudents."Responsibility Center");
                recCustomer.Insert;

                rStudents."Customer No." := recCustomer."No.";
                rStudents.Modify;
            end;
        end;
        // Fim
    end;
}

