codeunit 31009776 "Multi-Company Invoicing"
{

    trigger OnRun()
    begin
    end;

    //[Scope('OnPrem')]
    procedure Multi_GLAccount(pGLAccount: Record "G/L Account"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lGLAccount: Record "G/L Account";
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lGLAccount.Reset;
                    lGLAccount.ChangeCompany(lCompany.Name);
                    lGLAccount.Init;
                    lGLAccount.TransferFields(pGLAccount);
                    lGLAccount."Global Dimension 1 Code" := '';
                    lGLAccount."Global Dimension 2 Code" := '';
                    if IsModify then
                        if not lGLAccount.Modify then
                            lGLAccount.Insert;
                    if IsInsert then
                        lGLAccount.Insert;
                end else begin
                    lGLAccount.Reset;
                    lGLAccount.ChangeCompany(lCompany.Name);
                    lGLAccount.Get(pGLAccount."No.");
                    lGLAccount.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_Customer(pCustomer: Record Customer; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lCustomer: Record Customer;
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lCustomer.Reset;
                    lCustomer.ChangeCompany(lCompany.Name);
                    lCustomer.Init;
                    lCustomer.TransferFields(pCustomer);
                    lCustomer."Global Dimension 1 Code" := '';
                    lCustomer."Global Dimension 2 Code" := '';
                    if IsModify then
                        if not lCustomer.Modify then
                            lCustomer.Insert;
                    if IsInsert then
                        lCustomer.Insert;
                end else begin
                    lCustomer.Reset;
                    lCustomer.ChangeCompany(lCompany.Name);
                    lCustomer.Get(pCustomer."No.");
                    lCustomer.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_Service(pService: Record "Services ET"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lService: Record "Services ET";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lService.Reset;
                    lService.ChangeCompany(lCompany.Name);
                    lService.Init;
                    lService.TransferFields(pService);
                    lService."Global Dimension 1 Code" := '';
                    lService."Global Dimension 2 Code" := '';
                    lService.Company := '';
                    if IsModify then
                        if not lService.Modify then
                            lService.Insert;
                    if IsInsert then
                        lService.Insert;
                end else begin
                    lService.Reset;
                    lService.ChangeCompany(lCompany.Name);
                    lService.Get(pService."No.");
                    lService.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_Bank(pBankAccount: Record "Bank Account"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lBankAccount: Record "Bank Account";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lBankAccount.Reset;
                    lBankAccount.ChangeCompany(lCompany.Name);
                    lBankAccount.Init;
                    lBankAccount.TransferFields(pBankAccount);
                    lBankAccount."Global Dimension 1 Code" := '';
                    lBankAccount."Global Dimension 2 Code" := '';
                    if IsModify then
                        if not lBankAccount.Modify then
                            lBankAccount.Insert;
                    if IsInsert then
                        lBankAccount.Insert;
                end else begin
                    lBankAccount.Reset;
                    lBankAccount.ChangeCompany(lCompany.Name);
                    lBankAccount.Get(lBankAccount."No.");
                    lBankAccount.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_PaymentTerms(pPaymentTerms: Record "Payment Terms"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lPaymentTerms: Record "Payment Terms";
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lPaymentTerms.Reset;
                    lPaymentTerms.ChangeCompany(lCompany.Name);
                    lPaymentTerms.Init;
                    lPaymentTerms.TransferFields(pPaymentTerms);
                    if IsModify then
                        if not lPaymentTerms.Modify then
                            lPaymentTerms.Insert;
                    if IsInsert then
                        lPaymentTerms.Insert;
                end else begin
                    lPaymentTerms.Reset;
                    lPaymentTerms.ChangeCompany(lCompany.Name);
                    lPaymentTerms.Get(pPaymentTerms.Code);
                    lPaymentTerms.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_PaymentMethod(pPaymentMethod: Record "Payment Method"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lPaymentMethod: Record "Payment Method";
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lPaymentMethod.Reset;
                    lPaymentMethod.ChangeCompany(lCompany.Name);
                    lPaymentMethod.Init;
                    lPaymentMethod.TransferFields(pPaymentMethod);
                    if IsModify then
                        if not lPaymentMethod.Modify then
                            lPaymentMethod.Insert;
                    if IsInsert then
                        lPaymentMethod.Insert;
                end else begin
                    lPaymentMethod.Reset;
                    lPaymentMethod.ChangeCompany(lCompany.Name);
                    lPaymentMethod.Get(pPaymentMethod.Code);
                    lPaymentMethod.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_ServiceDiscountGroup(pServiceDiscountGroup: Record "Service Discount Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lServiceDiscountGroup: Record "Service Discount Group";
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lServiceDiscountGroup.Reset;
                    lServiceDiscountGroup.ChangeCompany(lCompany.Name);
                    lServiceDiscountGroup.Init;
                    lServiceDiscountGroup.TransferFields(pServiceDiscountGroup);
                    if IsModify then
                        if not lServiceDiscountGroup.Modify then
                            lServiceDiscountGroup.Insert;
                    if IsInsert then
                        lServiceDiscountGroup.Insert;
                end else begin
                    lServiceDiscountGroup.Reset;
                    lServiceDiscountGroup.ChangeCompany(lCompany.Name);
                    lServiceDiscountGroup.Get(pServiceDiscountGroup.Code);
                    lServiceDiscountGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_CustomerDiscountGroup(pCustomerDiscountGroup: Record "Customer Discount Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        lCustomerDiscountGroup: Record "Customer Discount Group";
        Text0001: Label 'The table must be updated in the %1 Company';
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lCustomerDiscountGroup.Reset;
                    lCustomerDiscountGroup.ChangeCompany(lCompany.Name);
                    lCustomerDiscountGroup.Init;
                    lCustomerDiscountGroup.TransferFields(pCustomerDiscountGroup);
                    if IsModify then
                        if not lCustomerDiscountGroup.Modify then
                            lCustomerDiscountGroup.Insert;
                    if IsInsert then
                        lCustomerDiscountGroup.Insert;
                end else begin
                    lCustomerDiscountGroup.Reset;
                    lCustomerDiscountGroup.ChangeCompany(lCompany.Name);
                    lCustomerDiscountGroup.Get(pCustomerDiscountGroup.Code);
                    lCustomerDiscountGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_CustomerPostingGroup(pCustomerPostingGroup: Record "Customer Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lCustomerPostingGroup: Record "Customer Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lCustomerPostingGroup.Reset;
                    lCustomerPostingGroup.ChangeCompany(lCompany.Name);
                    lCustomerPostingGroup.Init;
                    lCustomerPostingGroup.TransferFields(pCustomerPostingGroup);
                    if IsModify then
                        if not lCustomerPostingGroup.Modify then
                            lCustomerPostingGroup.Insert;
                    if IsInsert then
                        lCustomerPostingGroup.Insert;
                end else begin
                    lCustomerPostingGroup.Reset;
                    lCustomerPostingGroup.ChangeCompany(lCompany.Name);
                    lCustomerPostingGroup.Get(pCustomerPostingGroup.Code);
                    lCustomerPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_GenBusinessPostingGroup(pGenBusinessPostingGroup: Record "Gen. Business Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lGenBusinessPostingGroup: Record "Gen. Business Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lGenBusinessPostingGroup.Reset;
                    lGenBusinessPostingGroup.ChangeCompany(lCompany.Name);
                    lGenBusinessPostingGroup.Init;
                    lGenBusinessPostingGroup.TransferFields(pGenBusinessPostingGroup);
                    if IsModify then
                        if not lGenBusinessPostingGroup.Modify then
                            lGenBusinessPostingGroup.Insert;
                    if IsInsert then
                        lGenBusinessPostingGroup.Insert;
                end else begin
                    lGenBusinessPostingGroup.Reset;
                    lGenBusinessPostingGroup.ChangeCompany(lCompany.Name);
                    lGenBusinessPostingGroup.Get(pGenBusinessPostingGroup.Code);
                    lGenBusinessPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_GenProductPostingGroup(pGenProductPostingGroup: Record "Gen. Product Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lGenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lGenProductPostingGroup.Reset;
                    lGenProductPostingGroup.ChangeCompany(lCompany.Name);
                    lGenProductPostingGroup.Init;
                    lGenProductPostingGroup.TransferFields(pGenProductPostingGroup);
                    if IsModify then
                        if not lGenProductPostingGroup.Modify then
                            lGenProductPostingGroup.Insert;
                    if IsInsert then
                        lGenProductPostingGroup.Insert;
                end else begin
                    lGenProductPostingGroup.Reset;
                    lGenProductPostingGroup.ChangeCompany(lCompany.Name);
                    lGenProductPostingGroup.Get(pGenProductPostingGroup.Code);
                    lGenProductPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_GeneralPostingSetup(pGeneralPostingSetup: Record "General Posting Setup"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lGeneralPostingSetup: Record "General Posting Setup";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lGeneralPostingSetup.Reset;
                    lGeneralPostingSetup.ChangeCompany(lCompany.Name);
                    lGeneralPostingSetup.Init;
                    lGeneralPostingSetup.TransferFields(pGeneralPostingSetup);
                    if IsModify then
                        if not lGeneralPostingSetup.Modify then
                            lGeneralPostingSetup.Insert;
                    if IsInsert then
                        lGeneralPostingSetup.Insert;
                end else begin
                    lGeneralPostingSetup.Reset;
                    lGeneralPostingSetup.ChangeCompany(lCompany.Name);
                    lGeneralPostingSetup.Get(pGeneralPostingSetup."Gen. Bus. Posting Group", pGeneralPostingSetup."Gen. Prod. Posting Group");
                    lGeneralPostingSetup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_VATBusinessPostingGroup(pVATBusinessPostingGroup: Record "VAT Business Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lVATBusinessPostingGroup: Record "VAT Business Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lVATBusinessPostingGroup.Reset;
                    lVATBusinessPostingGroup.ChangeCompany(lCompany.Name);
                    lVATBusinessPostingGroup.Init;
                    lVATBusinessPostingGroup.TransferFields(pVATBusinessPostingGroup);
                    if IsModify then
                        if not lVATBusinessPostingGroup.Modify then
                            lVATBusinessPostingGroup.Insert;
                    if IsInsert then
                        lVATBusinessPostingGroup.Insert;
                end else begin
                    lVATBusinessPostingGroup.Reset;
                    lVATBusinessPostingGroup.ChangeCompany(lCompany.Name);
                    lVATBusinessPostingGroup.Get(pVATBusinessPostingGroup.Code);
                    lVATBusinessPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_VATProductPostingGroup(pVATProductPostingGroup: Record "VAT Product Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lVATProductPostingGroup: Record "VAT Product Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lVATProductPostingGroup.Reset;
                    lVATProductPostingGroup.ChangeCompany(lCompany.Name);
                    lVATProductPostingGroup.Init;
                    lVATProductPostingGroup.TransferFields(pVATProductPostingGroup);
                    if IsModify then
                        if not lVATProductPostingGroup.Modify then
                            lVATProductPostingGroup.Insert;
                    if IsInsert then
                        lVATProductPostingGroup.Insert;
                end else begin
                    lVATProductPostingGroup.Reset;
                    lVATProductPostingGroup.ChangeCompany(lCompany.Name);
                    lVATProductPostingGroup.Get(pVATProductPostingGroup.Code);
                    lVATProductPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_VATGeneralPostingSetup(pVATPostingSetup: Record "VAT Posting Setup"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lVATPostingSetup: Record "VAT Posting Setup";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lVATPostingSetup.Reset;
                    lVATPostingSetup.ChangeCompany(lCompany.Name);
                    lVATPostingSetup.Init;
                    lVATPostingSetup.TransferFields(pVATPostingSetup);
                    if IsModify then
                        if not lVATPostingSetup.Modify then
                            lVATPostingSetup.Insert;
                    if IsInsert then
                        lVATPostingSetup.Insert;
                end else begin
                    lVATPostingSetup.Reset;
                    lVATPostingSetup.ChangeCompany(lCompany.Name);
                    lVATPostingSetup.Get(
                      pVATPostingSetup."VAT Bus. Posting Group", pVATPostingSetup."VAT Prod. Posting Group");
                    lVATPostingSetup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_BankPostingGroup(pBankAccountPostingGroup: Record "Bank Account Posting Group"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lpBankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lpBankAccountPostingGroup.Reset;
                    lpBankAccountPostingGroup.ChangeCompany(lCompany.Name);
                    lpBankAccountPostingGroup.Init;
                    lpBankAccountPostingGroup.TransferFields(pBankAccountPostingGroup);
                    if IsModify then
                        if not lpBankAccountPostingGroup.Modify then
                            lpBankAccountPostingGroup.Insert;
                    if IsInsert then
                        lpBankAccountPostingGroup.Insert;
                end else begin
                    lpBankAccountPostingGroup.Reset;
                    lpBankAccountPostingGroup.ChangeCompany(lCompany.Name);
                    lpBankAccountPostingGroup.Get(pBankAccountPostingGroup.Code);
                    lpBankAccountPostingGroup.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_SalesLineDiscountET(pSalesLineDiscountET: Record "Sales Line Discount ET"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lSalesLineDiscountET: Record "Sales Line Discount ET";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lSalesLineDiscountET.Reset;
                    lSalesLineDiscountET.ChangeCompany(lCompany.Name);
                    lSalesLineDiscountET.Init;
                    lSalesLineDiscountET.TransferFields(pSalesLineDiscountET);
                    if IsModify then
                        if not lSalesLineDiscountET.Modify then
                            lSalesLineDiscountET.Insert;
                    if IsInsert then
                        lSalesLineDiscountET.Insert;
                end else begin
                    lSalesLineDiscountET.Reset;
                    lSalesLineDiscountET.ChangeCompany(lCompany.Name);
                    lSalesLineDiscountET.Get(
                      pSalesLineDiscountET.Type, pSalesLineDiscountET.Code, pSalesLineDiscountET."Sales Type", pSalesLineDiscountET."Sales Code",
                      pSalesLineDiscountET."Starting Date", pSalesLineDiscountET."Currency Code", pSalesLineDiscountET."Variant Code",
                      pSalesLineDiscountET."Unit of Measure Code", pSalesLineDiscountET."Minimum Quantity");
                    lSalesLineDiscountET.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure Multi_CustomerBanck(pCustomerBankAccount: Record "Customer Bank Account"; IsInsert: Boolean; IsModify: Boolean; IsDelete: Boolean)
    var
        lCompany: Record Company;
        Text0001: Label 'The table must be updated in the %1 Company';
        lCustomerBankAccount: Record "Customer Bank Account";
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        lCompany.Reset;
        //lCompany.SETRANGE("Master Company",COMPANYNAME);
        if lCompany.FindSet then
            repeat
                if not IsDelete then begin
                    lCustomerBankAccount.Reset;
                    lCustomerBankAccount.ChangeCompany(lCompany.Name);
                    lCustomerBankAccount.Init;
                    lCustomerBankAccount.TransferFields(pCustomerBankAccount);
                    if IsModify then
                        if not lCustomerBankAccount.Modify then
                            lCustomerBankAccount.Insert;
                    if IsInsert then
                        lCustomerBankAccount.Insert;
                end else begin
                    lCustomerBankAccount.Reset;
                    lCustomerBankAccount.ChangeCompany(lCompany.Name);
                    lCustomerBankAccount.Get(pCustomerBankAccount."Customer No.", pCustomerBankAccount.Code);
                    lCustomerBankAccount.Delete;
                end;
            until lCompany.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure CreateNewCompany()
    var
        lCompany: Record Company;
        lGLAccount: Record "G/L Account";
        lGenBusinessPostingGroup: Record "Gen. Business Posting Group";
        lGenProductPostingGroup: Record "Gen. Product Posting Group";
        lGeneralPostingSetup: Record "General Posting Setup";
        lVATBusinessPostingGroup: Record "VAT Business Posting Group";
        lVATProductPostingGroup: Record "VAT Product Posting Group";
        lVATPostingSetup: Record "VAT Posting Setup";
        lCustomer: Record Customer;
        lCustomerPostingGroup: Record "Customer Posting Group";
        lCustomerDiscountGroup: Record "Customer Discount Group";
        lSalesLineDiscountET: Record "Sales Line Discount ET";
        lPaymentTerms: Record "Payment Terms";
        lPaymentMethod: Record "Payment Method";
        lCustomerBankAccount: Record "Customer Bank Account";
        lServiceDiscountGroup: Record "Service Discount Group";
        lServicesET: Record "Services ET";
        Text0001: Label 'The company must be updated in the %1 Company';
        lBankAccount: Record "Bank Account";
        lBankAccountPostingGroup: Record "Bank Account Posting Group";
        nReg: Integer;
        i: Integer;
        Text0002: Label 'Update table #1############################## \ @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Window: Dialog;
    begin
        //Test if the change is done in a child company
        lCompany.Reset;
        lCompany.SetRange(Name, CompanyName);
        //IF lCompany.FINDSET AND (lCompany."Master Company" <> '') THEN
        //ERROR(Text0001, lCompany."Master Company");

        nReg := lGLAccount.Count +
          lGenBusinessPostingGroup.Count +
          lGenProductPostingGroup.Count +
          lGeneralPostingSetup.Count +
          lVATBusinessPostingGroup.Count +
          lVATProductPostingGroup.Count +
          lVATPostingSetup.Count +
          lCustomer.Count +
          lCustomerPostingGroup.Count +
          lCustomerDiscountGroup.Count +
          lSalesLineDiscountET.Count +
          lPaymentTerms.Count +
          lPaymentMethod.Count +
          lCustomerBankAccount.Count +
          lServiceDiscountGroup.Count +
          lServicesET.Count +
          lBankAccountPostingGroup.Count +
          lBankAccount.Count;

        Window.Open(Text0002);

        Window.Update(1, CopyStr(lGLAccount.TableCaption, 1, 30));
        if lGLAccount.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                //lGLAccount.MODIFY(TRUE);
                Multi_GLAccount(lGLAccount, false, true, false);
            until lGLAccount.Next = 0;

        Window.Update(1, CopyStr(lGenBusinessPostingGroup.TableCaption, 1, 30));
        if lGenBusinessPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lGenBusinessPostingGroup.Modify(true);
            until lGenBusinessPostingGroup.Next = 0;

        Window.Update(1, CopyStr(lGenProductPostingGroup.TableCaption, 1, 30));
        if lGenProductPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lGenProductPostingGroup.Modify(true);
            until lGenProductPostingGroup.Next = 0;

        Window.Update(1, CopyStr(lGeneralPostingSetup.TableCaption, 1, 30));
        if lGeneralPostingSetup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lGeneralPostingSetup.Modify(true);
            until lGeneralPostingSetup.Next = 0;

        Window.Update(1, CopyStr(lVATBusinessPostingGroup.TableCaption, 1, 30));
        if lVATBusinessPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lVATBusinessPostingGroup.Modify(true);
            until lVATBusinessPostingGroup.Next = 0;

        Window.Update(1, CopyStr(lVATProductPostingGroup.TableCaption, 1, 30));
        if lVATProductPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lVATProductPostingGroup.Modify(true);
            until lVATProductPostingGroup.Next = 0;

        Window.Update(1, CopyStr(lVATPostingSetup.TableCaption, 1, 30));
        if lVATPostingSetup.FindSet(true, true) then
            repeat
                lVATPostingSetup.Modify(true);
            until lVATPostingSetup.Next = 0;

        Window.Update(1, CopyStr(lCustomer.TableCaption, 1, 30));
        if lCustomer.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lCustomer.Modify(true);
            until lCustomer.Next = 0;

        Window.Update(1, CopyStr(lCustomerPostingGroup.TableCaption, 1, 30));
        if lCustomerPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lCustomerPostingGroup.Modify(true);
            until lCustomerPostingGroup.Next = 0;

        Window.Update(1, CopyStr(lCustomerDiscountGroup.TableCaption, 1, 30));
        if lCustomerDiscountGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lCustomerDiscountGroup.Modify(true);
            until lCustomerDiscountGroup.Next = 0;

        Window.Update(1, CopyStr(lSalesLineDiscountET.TableCaption, 1, 30));
        if lSalesLineDiscountET.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lSalesLineDiscountET.Modify(true);
            until lSalesLineDiscountET.Next = 0;

        Window.Update(1, CopyStr(lPaymentTerms.TableCaption, 1, 30));
        if lPaymentTerms.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lPaymentTerms.Modify(true);
            until lPaymentTerms.Next = 0;

        Window.Update(1, CopyStr(lPaymentMethod.TableCaption, 1, 30));
        if lPaymentMethod.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lPaymentMethod.Modify(true);
            until lPaymentMethod.Next = 0;

        Window.Update(1, CopyStr(lCustomerBankAccount.TableCaption, 1, 30));
        if lCustomerBankAccount.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lCustomerBankAccount.Modify(true);
            until lCustomerBankAccount.Next = 0;

        Window.Update(1, CopyStr(lServiceDiscountGroup.TableCaption, 1, 30));
        if lServiceDiscountGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lServiceDiscountGroup.Modify(true);
            until lServiceDiscountGroup.Next = 0;

        Window.Update(1, CopyStr(lServicesET.TableCaption, 1, 30));
        if lServicesET.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lServicesET.Modify(true);
            until lServicesET.Next = 0;

        Window.Update(1, CopyStr(lBankAccount.TableCaption, 1, 30));
        if lBankAccount.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lBankAccount.Modify(true);
            until lBankAccount.Next = 0;

        Window.Update(1, CopyStr(lBankAccountPostingGroup.TableCaption, 1, 30));
        if lBankAccountPostingGroup.FindSet(true, true) then
            repeat
                i += 1;
                Window.Update(2, Round(i / nReg * 10000, 1));
                lBankAccountPostingGroup.Modify(true);
            until lBankAccountPostingGroup.Next = 0;


        Window.Close;
    end;
}

