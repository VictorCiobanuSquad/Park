codeunit 31009755 "Student Services"
{
    // IT001 - Parque - Idiomas - 2017.10.12
    //       - Alteração Função "CustomerCreate"
    // 
    // IT002 - Parque 2018.01.10 - novo campo Email2 para os envios por email
    // 
    // IT003 - Park - 2018.09.18 - Park pediu para ser 0
    // 
    // IT004 - Park - 2019.04.04 - O parque pediu para não passar o NIB do aluno no caso de ser um associado


    trigger OnRun()
    begin
    end;

    var
        LineNo: Integer;
        Text50003: Label 'PTG';

    //[Scope('OnPrem')]
    procedure DistributionByEntity(pUsersFamilyStudents: Record "Users Family / Students") retValue: Boolean
    var
        UsersFamilyStud: Record "Users Family / Students";
        StudentServPlan: Record "Student Service Plan";
        ServDistribEntity: Record "Services Distributed by Entity";
        Text002: Label 'Does not exist Paying entity to the student "%1 - %2".';
        ServDistribEntityTEMP: Record "Services Distributed by Entity" temporary;
        ServDistribEntityFirst: Record "Services Distributed by Entity";
        Students: Record Students;
        varService: Code[20];
        varVariant: Code[20];
    begin
        LineNo := 0;
        ServDistribEntityTEMP.DeleteAll;

        ServDistribEntity.Reset;
        ServDistribEntity.SetRange("Student No.", pUsersFamilyStudents."Student Code No.");
        ServDistribEntity.SetRange("School Year", pUsersFamilyStudents."School Year");
        if ServDistribEntity.Find('-') then begin
            repeat
                ServDistribEntityTEMP.Init;
                ServDistribEntityTEMP.TransferFields(ServDistribEntity);
                ServDistribEntityTEMP.Insert;
            until ServDistribEntity.Next = 0;
            ServDistribEntity.DeleteAll;
        end;

        UsersFamilyStud.Reset;
        UsersFamilyStud.SetRange("School Year", pUsersFamilyStudents."School Year");
        UsersFamilyStud.SetRange("Student Code No.", pUsersFamilyStudents."Student Code No.");
        UsersFamilyStud.SetRange("Paying Entity", true);
        if UsersFamilyStud.FindSet(false, false) then begin
            repeat
                StudentServPlan.Reset;
                StudentServPlan.SetRange("School Year", UsersFamilyStud."School Year");
                StudentServPlan.SetRange("Student No.", UsersFamilyStud."Student Code No.");
                StudentServPlan.SetRange(Selected, true);
                if StudentServPlan.FindSet(false, false) then
                    repeat
                        if StudentServPlan.Type = StudentServPlan.Type::Item then begin
                            if StudentServPlan."Service Code" <> varService then begin
                                LineNo += 10000;
                                ServDistribEntity.Init;
                                ServDistribEntity."Line No." := LineNo;
                                ServDistribEntity.Type := StudentServPlan.Type;
                                ServDistribEntity."School Year" := StudentServPlan."School Year";
                                ServDistribEntity."Schooling Year" := StudentServPlan."Schooling Year";
                                ServDistribEntity."Student No." := StudentServPlan."Student No.";
                                ServDistribEntity.Kinship := UsersFamilyStud.Kinship;
                                ServDistribEntity.Validate("Service Code", StudentServPlan."Service Code");
                                ServDistribEntity."No." := UsersFamilyStud."No.";
                                //ServDistribEntity."Percent %" := ROUND(100 / UsersFamilyStud.COUNT, 0.01);
                                ServDistribEntityTEMP.Reset;
                                ServDistribEntityTEMP.SetRange("Student No.", pUsersFamilyStudents."Student Code No.");
                                ServDistribEntityTEMP.SetRange("School Year", pUsersFamilyStudents."School Year");
                                //Normatica 2012.06.04
                                ServDistribEntityTEMP.SetRange("Service Code", StudentServPlan."Service Code");
                                ServDistribEntityTEMP.SetRange(Kinship, UsersFamilyStud.Kinship);
                                //ServDistribEntityTEMP.SETRANGE("Line No.",LineNo);
                                //Normatica fim

                                if ServDistribEntityTEMP.Find('-') then begin
                                    if ServDistribEntityTEMP."Percent %" = Round(100 / UsersFamilyStud.Count, 0.01) then
                                        ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01)
                                    else
                                        ServDistribEntity."Percent %" := ServDistribEntityTEMP."Percent %";
                                end else
                                    //Normatica 2012.06.04
                                    ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01);
                                //Normatica fim

                                ServDistribEntity."Name of Associate" := UsersFamilyStud.Name;
                                ServDistribEntity.Description := StudentServPlan.Description;
                                ServDistribEntity."Description 2" := StudentServPlan."Description 2";
                                ServDistribEntity."Variant Code" := StudentServPlan."Variant Code";

                                ServDistribEntity."User ID" := UserId;
                                ServDistribEntity."Last Date Modified" := Today;
                                ServDistribEntity.Validate("Customer No.");
                                if not ServDistribEntity.Insert then
                                    ServDistribEntity.Modify;
                            end else begin
                                if (StudentServPlan."Variant Code" <> varVariant) then begin
                                    LineNo += 10000;
                                    ServDistribEntity.Init;
                                    ServDistribEntity."Line No." := LineNo;
                                    ServDistribEntity.Type := StudentServPlan.Type;
                                    ServDistribEntity."School Year" := StudentServPlan."School Year";
                                    ServDistribEntity."Schooling Year" := StudentServPlan."Schooling Year";
                                    ServDistribEntity."Student No." := StudentServPlan."Student No.";
                                    ServDistribEntity.Kinship := UsersFamilyStud.Kinship;
                                    ServDistribEntity.Validate("Service Code", StudentServPlan."Service Code");
                                    ServDistribEntity."No." := UsersFamilyStud."No.";
                                    //ServDistribEntity."Percent %" := ROUND(100 / UsersFamilyStud.COUNT, 0.01);
                                    ServDistribEntityTEMP.Reset;
                                    ServDistribEntityTEMP.SetRange("Student No.", pUsersFamilyStudents."Student Code No.");
                                    ServDistribEntityTEMP.SetRange("School Year", pUsersFamilyStudents."School Year");
                                    //Normatica 2012.06.04
                                    ServDistribEntityTEMP.SetRange("Service Code", StudentServPlan."Service Code");
                                    ServDistribEntityTEMP.SetRange(Kinship, UsersFamilyStud.Kinship);
                                    //ServDistribEntityTEMP.SETRANGE("Line No.",LineNo);
                                    //Normatica fim

                                    if ServDistribEntityTEMP.Find('-') then begin
                                        if ServDistribEntityTEMP."Percent %" = Round(100 / UsersFamilyStud.Count, 0.01) then
                                            ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01)
                                        else
                                            ServDistribEntity."Percent %" := ServDistribEntityTEMP."Percent %";
                                    end else
                                        //Normatica 2012.06.04
                                        ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01);
                                    //Normatica fim


                                    ServDistribEntity."Name of Associate" := UsersFamilyStud.Name;
                                    ServDistribEntity.Description := StudentServPlan.Description;
                                    ServDistribEntity."Description 2" := StudentServPlan."Description 2";
                                    ServDistribEntity."Variant Code" := StudentServPlan."Variant Code";

                                    ServDistribEntity."User ID" := UserId;
                                    ServDistribEntity."Last Date Modified" := Today;
                                    ServDistribEntity.Validate("Customer No.");
                                    if not ServDistribEntity.Insert then
                                        ServDistribEntity.Modify;
                                end;
                            end;
                        end else begin
                            if StudentServPlan."Service Code" <> varService then begin
                                LineNo += 10000;
                                ServDistribEntity.Init;
                                ServDistribEntity."Line No." := LineNo;
                                ServDistribEntity.Type := StudentServPlan.Type;
                                ServDistribEntity."School Year" := StudentServPlan."School Year";
                                ServDistribEntity."Schooling Year" := StudentServPlan."Schooling Year";
                                ServDistribEntity."Student No." := StudentServPlan."Student No.";
                                ServDistribEntity.Kinship := UsersFamilyStud.Kinship;
                                ServDistribEntity.Validate("Service Code", StudentServPlan."Service Code");
                                ServDistribEntity."No." := UsersFamilyStud."No.";
                                //ServDistribEntity."Percent %" := ROUND(100 / UsersFamilyStud.COUNT, 0.01);
                                ServDistribEntityTEMP.Reset;
                                ServDistribEntityTEMP.SetRange("Student No.", pUsersFamilyStudents."Student Code No.");
                                ServDistribEntityTEMP.SetRange("School Year", pUsersFamilyStudents."School Year");

                                //Normatica 2012.06.04
                                ServDistribEntityTEMP.SetRange("Service Code", StudentServPlan."Service Code");
                                ServDistribEntityTEMP.SetRange(Kinship, UsersFamilyStud.Kinship);
                                //ServDistribEntityTEMP.SETRANGE("Line No.",LineNo);
                                //Normatica fim

                                if ServDistribEntityTEMP.Find('-') then begin
                                    if ServDistribEntityTEMP."Percent %" = Round(100 / UsersFamilyStud.Count, 0.01) then
                                        ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01)
                                    else
                                        ServDistribEntity."Percent %" := ServDistribEntityTEMP."Percent %";
                                end else
                                    //Normatica 2012.06.04
                                    ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01);
                                //Normatica fim

                                ServDistribEntity."Name of Associate" := UsersFamilyStud.Name;
                                ServDistribEntity.Description := StudentServPlan.Description;
                                ServDistribEntity."Description 2" := StudentServPlan."Description 2";
                                ServDistribEntity."Variant Code" := StudentServPlan."Variant Code";

                                ServDistribEntity."User ID" := UserId;
                                ServDistribEntity."Last Date Modified" := Today;
                                ServDistribEntity.Validate("Customer No.");
                                if not ServDistribEntity.Insert then
                                    ServDistribEntity.Modify;
                            end;
                        end;
                        varService := StudentServPlan."Service Code";
                        varVariant := StudentServPlan."Variant Code";
                    until StudentServPlan.Next = 0;
                Clear(varService);//Normatica 2014.09.10
                Clear(varVariant);//Normatica 2014.09.10
            until UsersFamilyStud.Next = 0;
            retValue := true;
        end;

        PercentValidate(pUsersFamilyStudents);
    end;

    //[Scope('OnPrem')]
    procedure CustomerCreate(var pUsersFamilyStudents: Record "Users Family / Students")
    var
        Text002: Label 'You must select one Paying entity';
        recCustomer: Record Customer;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'The Candidate %1 already has a customer %2';
        Text004: Label 'Paying entity "%1 - %2" is not created as a customer.\ Do you want to create this customer?';
        rStudents: Record Students;
        rUsersFamily: Record "Users Family";
        Text003: Label 'Operation interrupted by the user.';
        rDefaultDimension: Record "Default Dimension";
        rDefaultDimensionNEW: Record "Default Dimension";
        rStudents2: Record Students;
        Text005: Label 'Não é possível criar a referência ADC porque o aluno %1, não tem o campo ID Cred preenchido.';
        rCustomer: Record Customer;
        rCustomer2: Record Customer;
        rUsersFamily2: Record "Users Family";
        txtRefADC: Text[30];
        l_UsersFamilyStudent: Record "Users Family / Students";
        l_UsersFamily: Record "Users Family";
        l_Customer: Record Customer;
        cStudentRegistration: Codeunit "Students Registration";
        encontrou: Boolean;
        l_rRiminderTerms: Record "Reminder Terms";
        l_PaymentMethod: Record "Payment Method";
        SalesSetup: Record "Sales & Receivables Setup";
    begin


        if rSalesReceivablesSetup.Get then;
        rSalesReceivablesSetup.TestField(rSalesReceivablesSetup."Customer Nos.");


        if (pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::Himself) or
            (pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::"Brother in School") then begin
            if rStudents.Get(pUsersFamilyStudents."No.") then;
            if rStudents."Customer No." = '' then begin
                if Confirm(StrSubstNo(Text004, pUsersFamilyStudents."No.", pUsersFamilyStudents.Name)) = false then
                    Error(Text003)
                else begin
                    recCustomer.Init;
                    recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
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
                    //IT002 - Parque 2018.01.10 - novo campo Email2 para os envios por email
                    recCustomer.Validate("E-Mail2", rStudents."E-mail2");
                    recCustomer.Validate("Home Page", rStudents."Home Page");
                    recCustomer."Invoice Disc. Code" := recCustomer."No.";
                    recCustomer.Validate("Responsibility Center", rStudents."Responsibility Center");
                    recCustomer."Global Dimension 1 Code" := rStudents."Global Dimension 1 Code";
                    recCustomer."Global Dimension 2 Code" := rStudents."Global Dimension 2 Code";
                    recCustomer."VAT Registration No." := rStudents."VAT Registration No.";
                    recCustomer.IBAN := rStudents.IBAN;
                    recCustomer.NIB := rStudents.NIB;
                    recCustomer."Referencia ADC" := rStudents."Referencia ADC";
                    recCustomer."Débitos Directos" := rStudents."Débitos Directos";
                    recCustomer."EAN Enviado" := rStudents."EAN Enviado";
                    recCustomer."ID CRED" := rStudents."ID CRED";
                    recCustomer."Invoice Copies" := 0;  //IT003 - Park - 2018.09.18 - Park pediu para ser 0

                    //IT001 - Parque - Idiomas - 2017.10.12
                    recCustomer."Language Code" := rStudents."Language Code"; //IT001,n
                                                                              //Normatica 2012.11.21 - Preencher automaticamente o Cód. Carta Aviso
                                                                              //l_rRiminderTerms.RESET;
                                                                              //IF l_rRiminderTerms.FINDFIRST THEN
                                                                              //  recCustomer."Reminder Terms Code" := l_rRiminderTerms.Code;
                                                                              //Normatica 2012.11.21 - fim
                    SalesSetup.Get;
                    if (recCustomer."Language Code" = '') or (recCustomer."Language Code" = Text50003) then begin
                        recCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
                        recCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
                    end else begin
                        recCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
                        recCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
                    end;
                    //IT001 en

                    recCustomer."Country/Region Code" := rStudents."Country/Region Code"; //Normatica 2013.01.30

                    recCustomer.Insert;
                    rStudents."Customer No." := recCustomer."No.";
                    rStudents.Modify;

                    //Normatica 2014.06.16 - Preencher dados do SEPA caso o aluno tenha dédito directo
                    /*IF l_Customer.GET(recCustomer."No.") THEN BEGIN
                      l_PaymentMethod.RESET;
                      l_PaymentMethod.SETRANGE(l_PaymentMethod.Code,l_Customer."Payment Method Code");
                      l_PaymentMethod.SETRANGE(l_PaymentMethod."Direct Debit",TRUE);
                      IF l_PaymentMethod.FINDFIRST THEN BEGIN
                        l_Customer."Preferred Bank Account Code" := 'CB' + COPYSTR(l_Customer."No.",4);//2014.09.26 - trirar o cli
                        l_Customer."Partner Type" := recCustomer."Partner Type"::"2";
                        l_Customer.MODIFY;
                        CriaAutorizacao(l_Customer."No.",l_Customer.NIB);
                      END;
                    END;*/
                    //Normatica 2014.06.16 - FIM




                    rDefaultDimension.Reset;
                    rDefaultDimension.SetRange("Table ID", DATABASE::Students);
                    rDefaultDimension.SetRange("No.", rStudents."No.");
                    if rDefaultDimension.FindSet then
                        repeat
                            rDefaultDimensionNEW.Init;
                            rDefaultDimensionNEW.TransferFields(rDefaultDimension);
                            rDefaultDimensionNEW."Table ID" := DATABASE::Customer;
                            rDefaultDimensionNEW."No." := recCustomer."No.";
                            rDefaultDimensionNEW."Value Posting" := rDefaultDimensionNEW."Value Posting"::" ";
                            rDefaultDimensionNEW.Insert;
                        until rDefaultDimension.Next = 0;

                end;
            end;
        end else begin
            if rUsersFamily.Get(pUsersFamilyStudents."No.") then;
            if rUsersFamily."Customer No." = '' then begin
                if Confirm(StrSubstNo(Text004, pUsersFamilyStudents."No.", pUsersFamilyStudents.Name)) = false then
                    Error(Text003)
                else begin
                    recCustomer.Init;
                    recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
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
                    //IT002 - Parque 2018.01.10 - novo campo Email2 para os envios por email
                    recCustomer.Validate("E-Mail2", rUsersFamily."E-mail2");
                    recCustomer.Validate("Home Page", rUsersFamily."Home Page");
                    recCustomer."User Family No." := pUsersFamilyStudents."No.";
                    recCustomer.Validate("Responsibility Center", rUsersFamily."Responsibility Center");
                    recCustomer."Invoice Disc. Code" := recCustomer."No.";
                    recCustomer."Global Dimension 1 Code" := rUsersFamily."Global Dimension 1 Code";
                    recCustomer."Global Dimension 2 Code" := rUsersFamily."Global Dimension 2 Code";
                    recCustomer."VAT Registration No." := rUsersFamily."VAT Registration No.";
                    //IT001 - Parque - Idiomas - 2017.10.12
                    recCustomer."Language Code" := rUsersFamily."Language Code"; //IT001,n
                    SalesSetup.Get;
                    if (recCustomer."Language Code" = '') or (recCustomer."Language Code" = Text50003) then begin
                        recCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo PT Code";
                        recCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code PT";
                    end else begin
                        recCustomer."Fin. Charge Terms Code" := SalesSetup."Fin. Charges Memo ENG Code";
                        recCustomer."Reminder Terms Code" := SalesSetup."Reminder Terms Code ENG";
                    end;
                    //IT001 en
                    recCustomer."Invoice Copies" := 1;
                    recCustomer."Country/Region Code" := rUsersFamily."Country/Region Code"; //Normatica 2013.01.30
                    recCustomer.Insert;
                    rUsersFamily."Customer No." := recCustomer."No.";
                    rUsersFamily.Modify;


                    //Normatica 2014.06.16 - Preencher dados do SEPA caso o pai/mae tenha dédito directo
                    //O NIB vai buscar à ficha do aluno
                    if l_Customer.Get(recCustomer."No.") then begin
                        l_PaymentMethod.Reset;
                        l_PaymentMethod.SetRange(l_PaymentMethod.Code, l_Customer."Payment Method Code");
                        l_PaymentMethod.SetRange(l_PaymentMethod."Direct Debit", true);
                        if l_PaymentMethod.FindFirst then begin
                            l_Customer."Preferred Bank Account Code" := 'CB' + CopyStr(l_Customer."No.", 4);//2014.09.26 - trirar o cli
                            l_Customer."Partner Type" := recCustomer."Partner Type"::Person;
                            l_Customer.Modify;

                            rStudents.Reset;
                            if rStudents.Get(pUsersFamilyStudents."Student Code No.") then;
                            //IT004 - Park - 2019.04.04
                            //CriaAutorizacao(l_Customer."No.",rStudents.NIB);
                            CriaAutorizacao(l_Customer."No.", '');
                            //IT004 - Park - 2019.04.04, en
                        end;
                    end;
                    //Normatica 2014.06.16 - FIM

                    rDefaultDimension.Reset;
                    rDefaultDimension.SetRange("Table ID", DATABASE::"Users Family");
                    rDefaultDimension.SetRange("No.", rUsersFamily."No.");
                    if rDefaultDimension.FindSet then
                        repeat
                            rDefaultDimensionNEW.Init;
                            rDefaultDimensionNEW.TransferFields(rDefaultDimension);
                            rDefaultDimensionNEW."Table ID" := DATABASE::Customer;
                            rDefaultDimensionNEW."No." := recCustomer."No.";
                            rDefaultDimensionNEW.Insert;
                        until rDefaultDimension.Next = 0;

                end;
            end;
        end;

        /*
        //Normatica 2014.06.16 - com o SEPA isto deixa de existir
        
        // Verificar se o aluno já tem nº de cliente
        rStudents.RESET;
        IF rStudents.GET(pUsersFamilyStudents."Student Code No.") THEN BEGIN
           IF rStudents."Customer No." = '' THEN BEGIN
              recCustomer.INIT;
              recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D,TRUE);
              recCustomer.VALIDATE(Name, rStudents."Full Name");
              recCustomer.VALIDATE("Post Code", rStudents."Post Code");
              recCustomer.VALIDATE("Gen. Bus. Posting Group", rStudents."Gen. Bus. Posting Group");
              recCustomer.VALIDATE("Customer Posting Group", rStudents."Customer Posting Group");
              recCustomer.VALIDATE("VAT Bus. Posting Group", rStudents."VAT Bus. Posting Group");
              recCustomer.VALIDATE("Payment Terms Code",rStudents."Payment Terms Code");
              recCustomer.VALIDATE("Payment Method Code",rStudents."Payment Method Code");
              recCustomer.VALIDATE("Customer Disc. Group",rStudents."Customer Disc. Group");
              recCustomer."Student No." :=pUsersFamilyStudents."Student Code No.";
              recCustomer.VALIDATE(Address,rStudents.Address);
              recCustomer.VALIDATE("Address 2",rStudents."Address 2");
              recCustomer.VALIDATE("Phone No.",rStudents."Phone No.");
              recCustomer.VALIDATE("E-Mail",rStudents."E-mail");
              recCustomer.VALIDATE("Home Page",rStudents."Home Page");
              recCustomer."Invoice Disc. Code" :=recCustomer."No.";
              recCustomer.VALIDATE("Responsibility Center",rStudents."Responsibility Center");
              recCustomer."Global Dimension 1 Code" := rStudents."Global Dimension 1 Code";
              recCustomer."Global Dimension 2 Code" := rStudents."Global Dimension 2 Code";
              recCustomer."VAT Registration No." := rStudents."VAT Registration No.";
              recCustomer.IBAN := rStudents.IBAN;
              recCustomer.NIB := rStudents.NIB;
              recCustomer."Referencia ADC" := rStudents."Referencia ADC";
              recCustomer."Débitos Directos" := rStudents."Débitos Directos";
              recCustomer."EAN Enviado" := rStudents."EAN Enviado";
              recCustomer."ID CRED" := rStudents."ID CRED";
              recCustomer."Invoice Copies" := 1;
              //Normatica 2012.11.21 - Preencher automaticamente o Cód. Carta Aviso
              l_rRiminderTerms.RESET;
              IF l_rRiminderTerms.FINDFIRST THEN
                recCustomer."Reminder Terms Code" := l_rRiminderTerms.Code;
              //Normatica 2012.11.21 - fim
              recCustomer.INSERT;
              rStudents."Customer No." := recCustomer."No.";
              rStudents.MODIFY;
        
           END;
        END;
        // Fim
        
        
        
        //Normatica 2012.06.06 - gerar a referencia ADC automaticamente qd se criar a entidade pagadora
        IF ((pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::Himself) OR
           (pUsersFamilyStudents.Kinship = pUsersFamilyStudents.Kinship::"Brother in School")) AND
           (pUsersFamilyStudents."Paying Entity" = TRUE)   THEN BEGIN
          //Aluno é entidade pagadora
        
          //2012.08.16 - foi pedido tg que veja se o associado é ent. pagadora e se for aproveita a ref ADC deste
          encontrou := FALSE;
          l_UsersFamilyStudent.RESET;
          l_UsersFamilyStudent.SETRANGE(l_UsersFamilyStudent."School Year",cStudentRegistration.GetShoolYearActive);
          l_UsersFamilyStudent.SETRANGE(l_UsersFamilyStudent."Student Code No.",pUsersFamilyStudents."No.");
          l_UsersFamilyStudent.SETFILTER(l_UsersFamilyStudent.Kinship,'<>%1',l_UsersFamilyStudent.Kinship::Himself);
          IF l_UsersFamilyStudent.FINDSET THEN BEGIN
            REPEAT
              IF l_UsersFamily.GET(l_UsersFamilyStudent."No.") THEN BEGIN
                IF (l_UsersFamily."Customer No." <> '') THEN BEGIN
                  IF (l_Customer.GET(l_UsersFamily."Customer No.")) AND (l_Customer."Referencia ADC" <> '') THEN BEGIN
                    //Aproveita a ref adc do associado
                    encontrou := TRUE;
                    rStudents2.RESET;
                    IF rStudents2.GET(pUsersFamilyStudents."No.") THEN BEGIN
                      IF rStudents2."ID CRED" <> '' THEN BEGIN
                        rStudents2.VALIDATE(rStudents2."Débitos Directos",l_Customer."Débitos Directos");
                        rStudents2.VALIDATE(rStudents2.NIB,l_Customer.NIB);
                        rStudents2.VALIDATE(rStudents2."Referencia ADC",l_Customer."Referencia ADC");
                        rStudents2.VALIDATE(rStudents2."EAN Enviado",l_Customer."EAN Enviado");
                        rStudents2.MODIFY;
                        l_Customer.VALIDATE("Referencia ADC",'');
                        l_Customer.VALIDATE(NIB,'');
                        l_Customer.MODIFY;
                      END ELSE
                        ERROR(Text005,rStudents2."No.");
                    END;
                  END;
                END;
              END;
            UNTIL l_UsersFamilyStudent.NEXT =0;
          END;
        
          IF encontrou = FALSE THEN BEGIN //2012.08.16 - novo if para só criar caso não aproveite a ref adc do associado
            rStudents2.RESET;
            IF rStudents2.GET(pUsersFamilyStudents."No.") THEN BEGIN
              IF rStudents2."ID CRED" <> '' THEN BEGIN
                rCustomer.RESET;
                rCustomer.SETCURRENTKEY("Referencia ADC");
                IF rCustomer.FINDLAST THEN BEGIN
                  txtRefADC := COPYSTR(rCustomer."Referencia ADC",1,9);
                  txtRefADC := INCSTR(txtRefADC);
                  rStudents2.VALIDATE(rStudents2."Referencia ADC", fGerarADC.GerarADCAutomatico(rStudents2."No.",rStudents2."ID CRED",
                                                 rStudents2."Débitos Directos",txtRefADC));
                  rStudents2.MODIFY;
                END;
              END ELSE
                ERROR(Text005,rStudents2."No.");
            END;
          END;
        
        
        END ELSE BEGIN
          IF (pUsersFamilyStudents."Paying Entity" = TRUE) THEN BEGIN
            //A entidade pagadora é outra que não o aluno
            //Tem de ver se o aluno já tem referencia adc criada, porque se tiver, vai usar esta para o Pai/Mae
            //Se não tiver então é que cria.
        
            rStudents2.RESET;
            IF rStudents2.GET(pUsersFamilyStudents."Student Code No.") THEN;
        
            IF rStudents2."Referencia ADC" = '' THEN BEGIN
        
              rUsersFamily2.RESET;
              IF rUsersFamily2.GET(pUsersFamilyStudents."No.") THEN BEGIN
                IF rCustomer2.GET(rUsersFamily2."Customer No.") THEN BEGIN
                  IF rStudents2."ID CRED" <> '' THEN BEGIN
                    rCustomer.RESET;
                    rCustomer.SETCURRENTKEY("Referencia ADC");
                    IF rCustomer.FINDLAST THEN BEGIN
                      txtRefADC := COPYSTR(rCustomer."Referencia ADC",1,9);
                      txtRefADC := INCSTR(txtRefADC);
                      rCustomer2.VALIDATE(rCustomer2."Referencia ADC", fGerarADC.GerarADCAutomatico(rCustomer2."No.",rStudents2."ID CRED",
                                                     rStudents2."Débitos Directos",txtRefADC));
                      rCustomer2.VALIDATE(rCustomer2."Débitos Directos",rStudents2."Débitos Directos");
                      rCustomer2.MODIFY;
                    END;
                  END ELSE
                    ERROR(Text005,rStudents2."No.");
                END;
              END;
        
            END ELSE BEGIN
        
              //aproveita o NIB e a ref para o pai/mae
              IF rUsersFamily2.GET(pUsersFamilyStudents."No.") THEN BEGIN
                IF rCustomer2.GET(rUsersFamily2."Customer No.") THEN BEGIN
                  rCustomer2.VALIDATE(rCustomer2."Débitos Directos",rStudents2."Débitos Directos");
                  rCustomer2.VALIDATE(rCustomer2.NIB,rStudents2.NIB);
                  rCustomer2.VALIDATE(rCustomer2."Referencia ADC",rStudents2."Referencia ADC");
                  rCustomer2.VALIDATE(rCustomer2."EAN Enviado",rStudents2."EAN Enviado");//Normatica 2012.08.16 - pedido pela Isabel
                  rCustomer2.MODIFY;
                  rStudents2.VALIDATE("Referencia ADC",'');
                  rStudents2.VALIDATE(NIB,'');
                  rStudents2.MODIFY;
                END;
              END;
        
            END;
        
        
          END;
        END;
        */

    end;

    //[Scope('OnPrem')]
    procedure CandidateCustomerCreate(var pUsersFamilyCandidate: Record "Users Family / Candidate")
    var
        Text002: Label 'You must select one Paying entity';
        recCustomer: Record Customer;
        rSalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'The Candidate %1 already has a customer %2';
        Text004: Label 'The Paying entity "%1" is not created as a customer.\Do you want to create it as a customer?';
        rCandidate: Record Candidate;
        rUsersFamily: Record "Users Family";
        Text003: Label 'Operation interrupted by the user.';
        rStudents: Record Students;
        vCustomer: Code[20];
        vPerson: Code[20];
    begin

        if rUsersFamily.Get(pUsersFamilyCandidate."No.") then
            if rUsersFamily."Customer No." = '' then
                if Confirm(StrSubstNo(Text004, pUsersFamilyCandidate."No.", pUsersFamilyCandidate.Name)) = false then
                    Error(Text003);

        //IF CONFIRM(STRSUBSTNO(Text004, pUsersFamilyCandidate."No." ,pUsersFamilyCandidate.Name)) = FALSE THEN BEGIN
        //  ERROR(Text003);
        //END;

        if rSalesReceivablesSetup.Get then;
        rSalesReceivablesSetup.TestField(rSalesReceivablesSetup."Customer Nos.");

        if (pUsersFamilyCandidate.Kinship = pUsersFamilyCandidate.Kinship::Himself) or
            (pUsersFamilyCandidate.Kinship = pUsersFamilyCandidate.Kinship::"Brother in School") then begin

            if pUsersFamilyCandidate.Kinship = pUsersFamilyCandidate.Kinship::Himself then begin
                if rCandidate.Get(pUsersFamilyCandidate."No.") then begin
                    vCustomer := rCandidate."Customer No.";
                    vPerson := rCandidate."No.";
                end;
            end else
                if rStudents.Get(pUsersFamilyCandidate."No.") then begin
                    vCustomer := rStudents."Customer No.";
                    vPerson := rStudents."No.";
                end;

            if vCustomer = '' then begin
                recCustomer.Init;
                recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rCandidate."Short Name");
                recCustomer.Validate(Address, rCandidate.Address);
                recCustomer.Validate("Address 2", rCandidate."Address 2");
                recCustomer.Validate("Post Code", rCandidate."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rCandidate."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rCandidate."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rCandidate."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rCandidate."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rCandidate."Payment Method Code");
                recCustomer.Validate("E-Mail", rCandidate."E-mail");
                recCustomer."Student No." := vPerson;
                recCustomer."Invoice Copies" := 1;
                recCustomer.Insert;
                rCandidate."Customer No." := recCustomer."No.";
                rCandidate.Modify;
            end;
        end else begin
            if rUsersFamily.Get(pUsersFamilyCandidate."No.") then;
            if rUsersFamily."Customer No." = '' then begin
                recCustomer.Init;
                recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rUsersFamily."Short Name");
                recCustomer.Validate(Address, rUsersFamily.Address);
                recCustomer.Validate("Post Code", rUsersFamily."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rUsersFamily."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rUsersFamily."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rUsersFamily."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rUsersFamily."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rUsersFamily."Payment Method Code");
                recCustomer.Validate("E-Mail", rUsersFamily."E-mail");
                recCustomer."User Family No." := pUsersFamilyCandidate."No.";
                recCustomer."Invoice Copies" := 1;
                recCustomer.Insert;
                rUsersFamily."Customer No." := recCustomer."No.";
                rUsersFamily.Modify;
            end;
        end;

        // Verificar se o aluno já tem nrº de cliente
        rCandidate.Reset;
        if rCandidate.Get(pUsersFamilyCandidate."Candidate Code No.") then begin
            if rCandidate."Customer No." = '' then begin
                recCustomer.Init;
                recCustomer."No." := NoSeriesMgt.GetNextNo(rSalesReceivablesSetup."Customer Nos.", 0D, true);
                recCustomer.Validate(Name, rCandidate."Short Name");
                recCustomer.Validate(Address, rCandidate.Address);
                recCustomer.Validate("Address 2", rCandidate."Address 2");
                recCustomer.Validate("Post Code", rCandidate."Post Code");
                recCustomer.Validate("Gen. Bus. Posting Group", rCandidate."Gen. Bus. Posting Group");
                recCustomer.Validate("Customer Posting Group", rCandidate."Customer Posting Group");
                recCustomer.Validate("VAT Bus. Posting Group", rCandidate."VAT Bus. Posting Group");
                recCustomer.Validate("Payment Terms Code", rCandidate."Payment Terms Code");
                recCustomer.Validate("Payment Method Code", rCandidate."Payment Method Code");
                recCustomer.Validate("E-Mail", rCandidate."E-mail");
                recCustomer."Student No." := rCandidate."No.";
                recCustomer."Invoice Copies" := 1;
                recCustomer.Insert;

                rCandidate."Customer No." := recCustomer."No.";
                rCandidate.Modify;
            end;
        end;
        // Fim -
    end;

    //[Scope('OnPrem')]
    procedure FilterDate(pPostingDate: Date; var pBeginDate: Date; var pEndDate: Date)
    var
        rDate: Record Date;
        vartxtBeginDate: Date;
        vartxtEndDate: Text[30];
    begin

        //EVALUATE(vartxtBeginDate,FORMAT(pPostingDate,0,'01-<Month,2>-<Year,4>'));

        vartxtBeginDate := CalcDate('<-CM>', pPostingDate);

        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Month);
        rDate.SetRange("Period Start", vartxtBeginDate);
        if rDate.FindFirst then begin
            pBeginDate := rDate."Period Start";
            vartxtEndDate := CopyStr(Format(rDate."Period End"), 2, StrLen(Format(rDate."Period End")));
            Evaluate(pEndDate, vartxtEndDate);

        end;
    end;

    //[Scope('OnPrem')]
    procedure DistributionByEntityRegis(var pStudentServPlan: Record "Student Service Plan")
    var
        UsersFamilyStud: Record "Users Family / Students";
        ServDistribEntity: Record "Services Distributed by Entity";
        Text002: Label 'Does not exist Paying entity to the student "%1 - %2".';
        Students: Record Students;
    begin

        ServDistribEntity.Reset;
        ServDistribEntity.SetRange("Student No.", pStudentServPlan."Student No.");
        ServDistribEntity.SetRange("School Year", pStudentServPlan."School Year");
        ServDistribEntity.SetRange("Service Code", pStudentServPlan."Service Code");
        if ServDistribEntity.Find('-') then
            ServDistribEntity.DeleteAll;

        ServDistribEntity.Reset;
        ServDistribEntity.SetRange("Student No.", pStudentServPlan."Student No.");
        ServDistribEntity.SetRange("School Year", pStudentServPlan."School Year");
        if ServDistribEntity.Find('+') then
            LineNo := ServDistribEntity."Line No."
        else
            LineNo := 0;

        UsersFamilyStud.Reset;
        UsersFamilyStud.SetRange("School Year", pStudentServPlan."School Year");
        UsersFamilyStud.SetRange("Student Code No.", pStudentServPlan."Student No.");
        UsersFamilyStud.SetRange("Paying Entity", true);
        if UsersFamilyStud.FindSet(false, false) then begin
            repeat
                LineNo += 10000;
                ServDistribEntity.Init;
                ServDistribEntity."Line No." := LineNo;
                ServDistribEntity."School Year" := pStudentServPlan."School Year";
                ServDistribEntity."Schooling Year" := pStudentServPlan."Schooling Year";
                ServDistribEntity."Student No." := pStudentServPlan."Student No.";
                ServDistribEntity.Kinship := UsersFamilyStud.Kinship;
                //Normatica 2012.10.24 - tem de prever Item e Service
                if pStudentServPlan.Type = pStudentServPlan.Type::Item then
                    ServDistribEntity.Type := ServDistribEntity.Type::Item;
                if pStudentServPlan.Type = pStudentServPlan.Type::Service then
                    ServDistribEntity.Type := ServDistribEntity.Type::Service;
                ServDistribEntity."Variant Code" := pStudentServPlan."Variant Code";
                //Normatica - Fim
                ServDistribEntity.Validate("Service Code", pStudentServPlan."Service Code");
                ServDistribEntity."No." := UsersFamilyStud."No.";
                ServDistribEntity."Percent %" := Round(100 / UsersFamilyStud.Count, 0.01);
                ServDistribEntity.Validate("Customer No.");
                ServDistribEntity."Name of Associate" := UsersFamilyStud.Name;
                ServDistribEntity.Description := pStudentServPlan.Description;
                ServDistribEntity."Description 2" := pStudentServPlan."Description 2";
                ServDistribEntity."User ID" := UserId;
                ServDistribEntity."Last Date Modified" := Today;
                if not ServDistribEntity.Insert then
                    ServDistribEntity.Modify;

            until UsersFamilyStud.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure DelDistributionByEntity(var pStudentServPlan: Record "Student Service Plan")
    var
        UsersFamilyStud: Record "Users Family / Students";
        ServDistribEntity: Record "Services Distributed by Entity";
        Text002: Label 'Does not exist Paying entity to the student "%1 - %2".';
        Students: Record Students;
    begin
        ServDistribEntity.Reset;
        ServDistribEntity.SetRange("Student No.", pStudentServPlan."Student No.");
        ServDistribEntity.SetRange("School Year", pStudentServPlan."School Year");
        ServDistribEntity.SetRange("Service Code", pStudentServPlan."Service Code");
        if ServDistribEntity.Find('-') then
            ServDistribEntity.DeleteAll;
    end;

    //[Scope('OnPrem')]
    procedure PercentValidate(pUsersFamilyStudents: Record "Users Family / Students")
    var
        UsersFamilyStud: Record "Users Family / Students";
        StudentServPlan: Record "Student Service Plan";
        ServDistribEntity: Record "Services Distributed by Entity";
        Students: Record Students;
        varTotal: Decimal;
        varLast: Decimal;
    begin

        StudentServPlan.Reset;
        StudentServPlan.SetRange("School Year", pUsersFamilyStudents."School Year");
        StudentServPlan.SetRange("Student No.", pUsersFamilyStudents."Student Code No.");
        StudentServPlan.SetRange(Selected, true);
        if StudentServPlan.Find('-') then begin
            repeat
                Clear(varTotal);
                ServDistribEntity.Reset;
                ServDistribEntity.SetRange("School Year", StudentServPlan."School Year");
                ServDistribEntity.SetRange("Student No.", StudentServPlan."Student No.");
                ServDistribEntity.SetRange("Service Code", StudentServPlan."Service Code");
                ServDistribEntity.SetRange("Variant Code", StudentServPlan."Variant Code");
                if ServDistribEntity.Find('-') then begin
                    repeat
                        varTotal += ServDistribEntity."Percent %";
                    until ServDistribEntity.Next = 0;
                    if varTotal <> 100 then begin
                        varLast := 100 - varTotal;
                        ServDistribEntity."Percent %" := ServDistribEntity."Percent %" + varLast;
                        ServDistribEntity.Modify;
                    end;
                end;
            until StudentServPlan.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CriaAutorizacao(CustNo: Code[20]; CustNIB: Text[50])
    var
        CustBankAcc: Record "Customer Bank Account";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
    begin
        /*CustBankAcc.RESET;
        CustBankAcc.INIT;
        CustBankAcc."Customer No." := CustNo;
        CustBankAcc.Code := 'CB' + COPYSTR(CustNo,4);//2014.09.26 - trirar o cli
        //IT004 - Park - 2019.04.04
        IF CustNIB <> '' THEN BEGIN
        //IT004 - Park - 2019.04.04, en
          CustBankAcc.IBAN := 'PT50' + CustNIB;
          IF COPYSTR(CustNIB,1,4) = '0001' THEN  CustBankAcc."SWIFT Code" := 'BGALPTTG';
          IF COPYSTR(CustNIB,1,4) = '0007' THEN  CustBankAcc."SWIFT Code" := 'BESCPTPL';
          IF COPYSTR(CustNIB,1,4) = '0008' THEN  CustBankAcc."SWIFT Code" := 'BAIPPTPL';
          IF COPYSTR(CustNIB,1,4) = '0010' THEN  CustBankAcc."SWIFT Code" := 'BBPIPTPL';
          IF COPYSTR(CustNIB,1,4) = '0012' THEN  CustBankAcc."SWIFT Code" := 'CDACPTPA';
          IF COPYSTR(CustNIB,1,4) = '0014' THEN  CustBankAcc."SWIFT Code" := 'IVVSPTPL';
          IF COPYSTR(CustNIB,1,4) = '0018' THEN  CustBankAcc."SWIFT Code" := 'TOTAPTPL';
          IF COPYSTR(CustNIB,1,4) = '0019' THEN  CustBankAcc."SWIFT Code" := 'BBVAPTPL';
          IF COPYSTR(CustNIB,1,4) = '0022' THEN  CustBankAcc."SWIFT Code" := 'BRASPTPL';
          IF COPYSTR(CustNIB,1,4) = '0023' THEN  CustBankAcc."SWIFT Code" := 'ACTVPTPL';//corrigido 2015.04.15
          IF COPYSTR(CustNIB,1,4) = '0032' THEN  CustBankAcc."SWIFT Code" := 'BARCPTPL';
          IF COPYSTR(CustNIB,1,4) = '0033' THEN  CustBankAcc."SWIFT Code" := 'BCOMPTPL';
          IF COPYSTR(CustNIB,1,4) = '0035' THEN  CustBankAcc."SWIFT Code" := 'CGDIPTPL';
          IF COPYSTR(CustNIB,1,4) = '0036' THEN  CustBankAcc."SWIFT Code" := 'MPIOPTPL';
          IF COPYSTR(CustNIB,1,4) = '0038' THEN  CustBankAcc."SWIFT Code" := 'BNIFPTPL';//Corrigido
          IF COPYSTR(CustNIB,1,4) = '0043' THEN  CustBankAcc."SWIFT Code" := 'DEUTPTPL';
          IF COPYSTR(CustNIB,1,4) = '0045' THEN  CustBankAcc."SWIFT Code" := 'CCCMPTPL';
          IF COPYSTR(CustNIB,1,4) = '0046' THEN  CustBankAcc."SWIFT Code" := 'CRBNPTPL';
          IF COPYSTR(CustNIB,1,4) = '0061' THEN  CustBankAcc."SWIFT Code" := 'BDIGPTPL';
          IF COPYSTR(CustNIB,1,4) = '0065' THEN  CustBankAcc."SWIFT Code" := 'BESZPTPL';//Corrigido
          IF COPYSTR(CustNIB,1,4) = '0079' THEN  CustBankAcc."SWIFT Code" := 'BPNPPTPL';
          IF COPYSTR(CustNIB,1,4) = '0086' THEN  CustBankAcc."SWIFT Code" := 'EFISPTPL';
          IF COPYSTR(CustNIB,1,4) = '0097' THEN  CustBankAcc."SWIFT Code" := 'CCCHPTP1';
          IF COPYSTR(CustNIB,1,4) = '0099' THEN  CustBankAcc."SWIFT Code" := 'CSSOPTPX';
          IF COPYSTR(CustNIB,1,4) = '0160' THEN  CustBankAcc."SWIFT Code" := 'BESAPTPA';
          IF COPYSTR(CustNIB,1,4) = '0183' THEN  CustBankAcc."SWIFT Code" := 'PRTTPTP1';
          IF COPYSTR(CustNIB,1,4) = '0188' THEN  CustBankAcc."SWIFT Code" := 'BCCBPTPL';
          IF COPYSTR(CustNIB,1,4) = '0244' THEN  CustBankAcc."SWIFT Code" := 'MPCGPTP1';
          IF COPYSTR(CustNIB,1,4) = '0269' THEN  CustBankAcc."SWIFT Code" := 'BKBKPTPL';//criado em 2016.10.14
          IF COPYSTR(CustNIB,1,4) = '0781' THEN  CustBankAcc."SWIFT Code" := 'IGCPPTPL';
          IF COPYSTR(CustNIB,1,4) = '5180' THEN  CustBankAcc."SWIFT Code" := 'CDCTPTP2';
        END;
        CustBankAcc.INSERT;

        SEPADDMandate.RESET;
        SEPADDMandate.INIT;

        SalesSetup.GET;
        SalesSetup.TESTFIELD("Direct Debit Mandate Nos.");
        //NoSeriesMgt.InitSeries(SalesSetup."Direct Debit Mandate Nos.",'',0D,NewNo,"No. Series");

        NewNo := NoSeriesMgt.GetNextNo(SalesSetup."Direct Debit Mandate Nos.",0D,TRUE);
        SEPADDMandate.ID := NewNo;
        SEPADDMandate."Customer No." := CustNo;
        SEPADDMandate."Customer Bank Account Code" := 'CB' + COPYSTR(CustNo,4);//2014.09.26 - trirar o cli;
        SEPADDMandate."Valid From" := WORKDATE;
        SEPADDMandate."Valid To" := 31122099D;
        SEPADDMandate."Date of Signature" := WORKDATE;
        SEPADDMandate."Sequence Type" := SEPADDMandate."Sequence Type"::"1";
        SEPADDMandate."Expected Number of Debits" := 9999;
        IF NOT SEPADDMandate.INSERT THEN;
        */

    end;
}

