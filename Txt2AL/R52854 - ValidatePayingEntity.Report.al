report 52854 "Validate Paying Entity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ValidatePayingEntity.rdlc';
    Caption = 'Validate Paying Entity';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Registration; Registration)
        {
            RequestFilterFields = "School Year", Class;
            dataitem(Students; Students)
            {
                DataItemLink = "No." = FIELD("Student Code No.");
                DataItemTableView = SORTING("No.");

                trigger OnAfterGetRecord()
                var
                    l_Students: Record Students;
                    l_UsersFamily: Record "Users Family";
                begin

                    rUsersFamilyStudents.Reset;
                    rUsersFamilyStudents.SetRange("School Year", varSchoolYear);
                    rUsersFamilyStudents.SetRange("Student Code No.", Students."No.");
                    rUsersFamilyStudents.SetRange("Paying Entity", true);
                    if rUsersFamilyStudents.FindSet then begin
                        repeat
                            //Proprio
                            if rUsersFamilyStudents.Kinship = rUsersFamilyStudents.Kinship::Himself then begin
                                if Students."Payment Method Code" = '' then begin
                                    //Sem Metodo de pagamento
                                    tempStudents.Init;
                                    tempStudents."School Year" := varSchoolYear;
                                    tempStudents."Student Code No." := Students."No.";
                                    tempStudents."No." := '';
                                    tempStudents.Name := Students.Name;
                                    tempStudents.Address := Text0003;
                                    tempStudents."E-mail" := '';
                                    if tempStudents.Insert then; //MF

                                end else begin
                                    if (rPaymentMethods.Get(Students."Payment Method Code")) and
                                      (rPaymentMethods."Bal. Account Type" = rPaymentMethods."Bal. Account Type"::"Bank Account") then begin
                                        rCustomerBankAccount.Reset;
                                        rCustomerBankAccount.SetRange(rCustomerBankAccount."Customer No.", Students."Customer No.");
                                        if not rCustomerBankAccount.FindFirst then begin
                                            //Sem banco configurado
                                            tempStudents.Init;
                                            tempStudents."School Year" := varSchoolYear;
                                            tempStudents."Student Code No." := Students."No.";
                                            tempStudents."No." := '';
                                            tempStudents.Name := Students.Name;
                                            tempStudents.Address := Text0004;
                                            tempStudents."E-mail" := Students."Payment Method Code";
                                            if tempStudents.Insert then; //MF
                                        end else begin
                                            tempStudents.Init;
                                            tempStudents."School Year" := varSchoolYear;
                                            tempStudents."Student Code No." := Students."No.";
                                            tempStudents."No." := '';
                                            tempStudents.Name := Students.Name;
                                            tempStudents.Address := rCustomerBankAccount."PTSS CCC No.";
                                            tempStudents."E-mail" := Students."Payment Method Code";
                                            if tempStudents.Insert then; //MF
                                        end;
                                    end;
                                end;
                            end;

                            //Irmão na escola
                            if rUsersFamilyStudents.Kinship = rUsersFamilyStudents.Kinship::"Brother in School" then begin
                                if l_Students.Get(rUsersFamilyStudents."No.") then begin
                                    if l_Students."Payment Method Code" = '' then begin
                                        //Sem Metodo de pagamento
                                        tempStudents.Init;
                                        tempStudents."School Year" := varSchoolYear;
                                        tempStudents."Student Code No." := Students."No.";
                                        tempStudents."No." := rUsersFamilyStudents."No.";
                                        tempStudents.Name := Students.Name;
                                        tempStudents.Address := Text0003;
                                        tempStudents."E-mail" := '';
                                        if tempStudents.Insert then; //MF

                                    end else begin
                                        if (rPaymentMethods.Get(l_Students."Payment Method Code")) and
                                          (rPaymentMethods."Bal. Account Type" = rPaymentMethods."Bal. Account Type"::"Bank Account") then begin
                                            rCustomerBankAccount.Reset;
                                            rCustomerBankAccount.SetRange(rCustomerBankAccount."Customer No.", l_Students."Customer No.");
                                            if not rCustomerBankAccount.FindFirst then begin
                                                //Sem banco configurado
                                                tempStudents.Init;
                                                tempStudents."School Year" := varSchoolYear;
                                                tempStudents."Student Code No." := Students."No.";
                                                tempStudents."No." := rUsersFamilyStudents."No.";
                                                tempStudents.Name := Students.Name;
                                                tempStudents.Address := Text0004;
                                                tempStudents."E-mail" := l_Students."Payment Method Code";
                                                if tempStudents.Insert then; //MF
                                            end else begin
                                                tempStudents.Init;
                                                tempStudents."School Year" := varSchoolYear;
                                                tempStudents."Student Code No." := Students."No.";
                                                tempStudents."No." := rUsersFamilyStudents."No.";
                                                tempStudents.Name := Students.Name;
                                                tempStudents.Address := rCustomerBankAccount."PTSS CCC No.";
                                                tempStudents."E-mail" := l_Students."Payment Method Code";
                                                if tempStudents.Insert then; //MF

                                            end;
                                        end;
                                    end;
                                end;
                            end;

                            //Outro
                            if (rUsersFamilyStudents.Kinship <> rUsersFamilyStudents.Kinship::Himself)
                            and (rUsersFamilyStudents.Kinship <> rUsersFamilyStudents.Kinship::"Brother in School") then begin
                                if l_UsersFamily.Get(rUsersFamilyStudents."No.") then begin
                                    if l_UsersFamily."Payment Method Code" = '' then begin
                                        //Sem Metodo de pagamento
                                        tempStudents.Init;
                                        tempStudents."School Year" := varSchoolYear;
                                        tempStudents."Student Code No." := Students."No.";
                                        tempStudents."No." := rUsersFamilyStudents."No.";
                                        tempStudents.Name := Students.Name;
                                        tempStudents.Address := Text0003;
                                        tempStudents."E-mail" := '';
                                        if tempStudents.Insert then; //MF

                                    end else begin
                                        if (rPaymentMethods.Get(l_UsersFamily."Payment Method Code")) and
                                          (rPaymentMethods."Bal. Account Type" = rPaymentMethods."Bal. Account Type"::"Bank Account") then begin
                                            rCustomerBankAccount.Reset;
                                            rCustomerBankAccount.SetRange(rCustomerBankAccount."Customer No.", l_UsersFamily."Customer No.");
                                            if not rCustomerBankAccount.FindFirst then begin
                                                //Sem banco configurado
                                                tempStudents.Init;
                                                tempStudents."School Year" := varSchoolYear;
                                                tempStudents."Student Code No." := Students."No.";
                                                tempStudents."No." := rUsersFamilyStudents."No.";
                                                tempStudents.Name := Students.Name;
                                                tempStudents.Address := Text0004;
                                                tempStudents."E-mail" := l_UsersFamily."Payment Method Code";
                                                if tempStudents.Insert then; //MF
                                            end else begin
                                                tempStudents.Init;
                                                tempStudents."School Year" := varSchoolYear;
                                                tempStudents."Student Code No." := Students."No.";
                                                tempStudents."No." := rUsersFamilyStudents."No.";
                                                tempStudents.Name := Students.Name;
                                                tempStudents.Address := rCustomerBankAccount."PTSS CCC No.";
                                                tempStudents."E-mail" := l_UsersFamily."Payment Method Code";
                                                if tempStudents.Insert then; //MF
                                            end;
                                        end;
                                    end;
                                end;
                            end;


                        until rUsersFamilyStudents.Next = 0;

                    end else begin
                        //Não tem entidade pagadora
                        tempStudents.Init;
                        tempStudents."School Year" := varSchoolYear;
                        tempStudents."Student Code No." := Students."No.";
                        tempStudents."No." := '';
                        tempStudents.Name := Students.Name;
                        tempStudents.Address := Text0002;
                        tempStudents."E-mail" := '';
                        if tempStudents.Insert then; //MF
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                        rRespCenter.Reset;
                        rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                        nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                    end else begin
                        rSchool.Reset;
                        if rSchool.Find('-') then
                            nomeEscola := rSchool."School Name";
                    end;
                    Clear(tempStudents);
                end;
            }

            trigger OnPreDataItem()
            begin

                varSchoolYear := Registration.GetFilter(Registration."School Year");
                Filtros := varSchoolYear;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            column(DateFormated; Format(Today, 0, 4))
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(CINFO_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(TempS_StudentCodeNo; tempStudents."Student Code No.")
            {
            }
            column(TempS_Name; tempStudents.Name)
            {
            }
            column(TempS_No; tempStudents."No.")
            {
            }
            column(TempS_Email; tempStudents."E-mail")
            {
            }
            column(TempS_Address; tempStudents.Address)
            {
            }
            column(CurrReport_PAGENOCaptionLbl; CurrReport_PAGENOCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Integer.Number <> 1 then
                    tempStudents.Next()
                else
                    tempStudents.Find('-');
            end;

            trigger OnPreDataItem()
            begin
                Integer.SetRange(Integer.Number, 1, tempStudents.Count);
                tempStudents.Reset;
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
        ReportTitleCaption = 'Validate Paying Entity';
        PageCaption = 'Page';
        FiltersCaption = 'Filters';
        ProcessCaption = 'No.';
        NameCaption = 'Name';
        PayingEntityCaption = 'Paying Entity';
        PayingMethodCaption = 'Payment Method Code';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        rRegistration: Record Registration;
        rUsersFamilyStudents: Record "Users Family / Students";
        rUsersFamily: Record "Users Family";
        rCustomerBankAccount: Record "Customer Bank Account";
        rPaymentMethods: Record "Payment Method";
        tempStudents: Record "Users Family / Students" temporary;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        varSchoolYear: Code[9];
        Text0001: Label 'You must fill School Year.';
        Text0002: Label 'Student without paying entity.';
        Text0003: Label 'No method of payment.';
        Text0004: Label 'No Bank Account set up.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

