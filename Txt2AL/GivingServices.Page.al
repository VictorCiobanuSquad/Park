#pragma implicitwith disable
page 31009778 "Giving Services"
{
    // IT001 - Específico CPA - MF - 06-05-2016
    //       - Campo Oculto: "Novo Valor"
    // 
    // IT002 - ET-Funcionalidade ocultada - MF - 06-05-2016
    //       - Melhoria Add-on ainda não validada:
    //         - Campos ocultados:
    //           - Ciclo
    //           - Ano de Escolaridade
    // 
    // //IT005 - 2017.07.21 - Tem de Filtrar por ciclo e não estava

    Caption = 'Atribuir Serviços';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Geral)
            {
                Caption = 'Filtros Estudantes:';

                field(varClass; varClass)
                {
                    Caption = 'Cód. Turma';

                    trigger OnValidate()

                    begin

                        rSchoolYear.RESET;
                        rSchoolYear.SETRANGE(Status, rSchoolYear.Status::Active);
                        IF rSchoolYear.FIND('-') THEN BEGIN
                            rClass.RESET;
                            rClass.SETRANGE("School Year", rSchoolYear."School Year");
                            rClass.SETRANGE(Class, varClass);
                            IF rClass.FIND('-') THEN BEGIN
                                varSchoolingYear := rClass."Schooling Year";
                                varSchoolYear := rClass."School Year";
                                varRespCenter := rClass."Responsibility Center";
                                varSchoolingYear2 := rClass."Schooling Year";
                                recStrutureEdu.RESET;
                                recStrutureEdu.SETRANGE("Schooling Year", varSchoolingYear2);
                                IF recStrutureEdu.FIND('-') THEN
                                    varLevel := recStrutureEdu.Level;
                            END ELSE BEGIN
                                CLEAR(varStudent);
                                rStudentsTemP.DELETEALL;
                                CLEAR(rStudentsTemP);
                            END;
                        END;
                        Filter;
                    end;

                    trigger OnLookup(var varText: Text): Boolean
                    begin

                        CLEAR(varStudent);

                        rSchoolYear.RESET;
                        rSchoolYear.SETRANGE(Status, rSchoolYear.Status::Active);
                        IF rSchoolYear.FINDFIRST THEN;

                        rClass.RESET;
                        rClass.SETRANGE("School Year", rSchoolYear."School Year");
                        IF rClass.FIND('-') THEN BEGIN
                            IF PAGE.RUNMODAL(PAGE::"Class List", rClass) = ACTION::LookupOK THEN BEGIN
                                varClass := rClass.Class;
                                varSchoolingYear := rClass."Schooling Year";
                                varSchoolYear := rClass."School Year";
                                varRespCenter := rClass."Responsibility Center";
                                varSchoolingYear2 := rClass."Schooling Year";
                                recStrutureEdu.RESET;
                                recStrutureEdu.SETRANGE("Schooling Year", varSchoolingYear);
                                IF recStrutureEdu.FIND('-') THEN
                                    varLevel := recStrutureEdu.Level;
                                varStudent := '';
                            END;
                            Filter;

                            CurrPage.fAtribuirServ.PAGE.FiltraCentResp(varRespCenter);
                        END;
                    end;
                }


                field(varStudent; varStudent)
                {
                    Caption = 'Cód. Aluno';


                    trigger OnValidate()
                    var
                    begin
                        Filter;
                    end;

                    trigger OnLookup(var varText: Text): Boolean
                    var
                        myInt: Integer;
                    begin

                        rStudentsTemP.DELETEALL;
                        CLEAR(rStudentsTemP);
                        CLEAR(varStudent);
                        IF varClass <> '' THEN BEGIN
                            rRegistrationClass.RESET;
                            rRegistrationClass.SETRANGE(Class, varClass);
                            rRegistrationClass.SETRANGE("School Year", rSchoolYear."School Year");
                            rRegistrationClass.SETRANGE(Status, rRegistrationClass.Status::Subscribed);
                            rRegistrationClass.SETRANGE("Responsibility Center", varRespCenter);
                            IF rRegistrationClass.FIND('-') THEN BEGIN
                                REPEAT
                                    rStudents.RESET;
                                    rStudents.SETRANGE("No.", rRegistrationClass."Student Code No.");
                                    IF rStudents.FIND('-') THEN BEGIN
                                        rStudentsTemP.RESET;
                                        rStudentsTemP.TRANSFERFIELDS(rStudents);
                                        rStudentsTemP.INSERT;
                                    END;
                                UNTIL rRegistrationClass.NEXT = 0;
                                IF PAGE.RUNMODAL(PAGE::"Students List", rStudentsTemP) = ACTION::LookupOK THEN
                                    varStudent := rStudentsTemP."No.";
                                Filter;
                            END;
                        END ELSE BEGIN
                            CLEAR(varStudent);
                            rStudents.RESET;
                            IF PAGE.RUNMODAL(PAGE::"Students List", rStudents) = ACTION::LookupOK THEN BEGIN
                                varStudent := rStudents."No.";
                                rRegistrationClass.RESET;
                                rRegistrationClass.SETRANGE("Student Code No.", rStudents."No.");
                                rRegistrationClass.SETRANGE("School Year", rSchoolYear."School Year");
                                rRegistrationClass.SETRANGE(Status, rRegistrationClass.Status::Subscribed);
                                rRegistrationClass.SETRANGE("Responsibility Center", varRespCenter);
                                IF rRegistrationClass.FIND('-') THEN BEGIN
                                    varClass := rRegistrationClass.Class;
                                    varSchoolYear := rRegistrationClass."School Year";
                                    varSchoolingYear2 := rRegistrationClass."Schooling Year";
                                    recStrutureEdu.RESET;
                                    recStrutureEdu.SETRANGE("Schooling Year", varSchoolingYear);
                                    IF recStrutureEdu.FIND('-') THEN
                                        varLevel := recStrutureEdu.Level;
                                END;
                                Filter;
                            END;
                        END;
                    end;
                }


                field(varSchoolYear; varSchoolYear)
                {
                    Caption = 'Ano Lectivo';

                    trigger OnValidate()

                    begin
                        Filter();
                    end;

                    trigger OnLookup(var varText: Text): Boolean
                    var
                    begin
                        rSchoolYear.RESET;
                        rSchoolYear.SETRANGE(rSchoolYear.Status, rSchoolYear.Status::Planning, rSchoolYear.Status::Active);
                        IF PAGE.RUNMODAL(PAGE::"School Year", rSchoolYear) = ACTION::LookupOK THEN BEGIN
                            varClass := '';
                            varSchoolYear := rSchoolYear."School Year";
                        END;
                        Filter;
                    end;
                }

            }
            part(fAtribuirServ; "Atribuir Multiplos Serviços")
            {

            }

            part(PagePartServiceList; "P50036 - Services List")
            {
                Caption = ' ';
            }
        }


    }
    actions
    {
        area(creation)
        {
            action(Proccessing)
            {
                Caption = '&Process';
                Image = Process;
                ShortcutKey = F11;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    l_ServicosAAtribuir: Record "Serviços a Atrbuir";
                begin

                    l_ServicosAAtribuir.RESET;
                    l_ServicosAAtribuir.SETRANGE(l_ServicosAAtribuir."User ID", USERID);
                    IF l_ServicosAAtribuir.FIND('-') THEN BEGIN
                        REPEAT
                            IF (l_ServicosAAtribuir.January = FALSE) AND (l_ServicosAAtribuir.February = FALSE) AND
                               (l_ServicosAAtribuir.March = FALSE) AND (l_ServicosAAtribuir.April = FALSE) AND
                               (l_ServicosAAtribuir.May = FALSE) AND (l_ServicosAAtribuir.June = FALSE) AND
                               (l_ServicosAAtribuir.July = FALSE) AND (l_ServicosAAtribuir.August = FALSE) AND
                               (l_ServicosAAtribuir.Setember = FALSE) AND (l_ServicosAAtribuir.October = FALSE) AND
                               (l_ServicosAAtribuir.November = FALSE) AND (l_ServicosAAtribuir.Dezember = FALSE) THEN
                                ERROR(Text50001);
                        UNTIL l_ServicosAAtribuir.NEXT = 0;
                    END;


                    //IF varQuant = 0 THEN
                    //  ERROR(Text0003);
                    l_ServicosAAtribuir.RESET;
                    l_ServicosAAtribuir.SETRANGE(l_ServicosAAtribuir."User ID", USERID);
                    l_ServicosAAtribuir.SETRANGE(l_ServicosAAtribuir.Quantidade, 0);
                    IF l_ServicosAAtribuir.FIND('-') THEN
                        ERROR(Text0003);
                    //IT001 - Park - en


                    IF varSchoolYear = '' THEN
                        ERROR(Text0012);
                    //ValidateUserSelection();
                    ValidateSelection;
                    AtribuirServiços;
                end;
            }
            action("Mark All")
            {
                Caption = '&Mark All';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if varSchoolYear = '' then
                        Error(Text0012)
                    else
                        MarkAll(true);
                end;
            }
            action(UnmarkAll)
            {
                Caption = '&Unmark All';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    MarkAll(false);
                end;
            }


            action("Carregar Plano Serviços")
            {
                Caption = '&Carregar Plano Serviços';
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ServicosAtribuir: record "Serviços a Atrbuir";
                    ServicesPlanLine: record "Services Plan Line";
                begin
                    ServicesPlanLine.RESET;
                    ServicesPlanLine.SETRANGE(ServicesPlanLine.Code, varRespCenter);
                    IF ServicesPlanLine.FINDFIRST THEN BEGIN
                        REPEAT
                            ServicosAtribuir.INIT;
                            ServicosAtribuir."User ID" := USERID;
                            ServicosAtribuir.Tipo := ServicosAtribuir.Tipo::Serviço;
                            ServicosAtribuir.VALIDATE(ServicosAtribuir."No.", ServicesPlanLine."Service Code");
                            ServicosAtribuir.Quantidade := ServicesPlanLine.Qtd; //IT002 - Park- 2018.06.28 - Novo campo qtd
                            ServicosAtribuir.January := ServicesPlanLine.January;
                            ServicosAtribuir.February := ServicesPlanLine.February;
                            ServicosAtribuir.March := ServicesPlanLine.March;
                            ServicosAtribuir.April := ServicesPlanLine.April;
                            ServicosAtribuir.May := ServicesPlanLine.May;
                            ServicosAtribuir.June := ServicesPlanLine.June;
                            ServicosAtribuir.July := ServicesPlanLine.July;
                            ServicosAtribuir.August := ServicesPlanLine.August;
                            ServicosAtribuir.Setember := ServicesPlanLine.Setember;
                            ServicosAtribuir.October := ServicesPlanLine.October;
                            ServicosAtribuir.November := ServicesPlanLine.November;
                            ServicosAtribuir.Dezember := ServicesPlanLine.Dezember;
                            ServicosAtribuir."Service Plan Code" := ServicesPlanLine.Code;
                            ServicosAtribuir.INSERT;
                        UNTIL ServicesPlanLine.NEXT = 0;
                        Message('Plano de Serviço Importado.');
                    END ELSE
                        Message('Não existem planos para serem importados.');
                end;
            }
        }

    }


    trigger OnOpenPage()
    begin

        CLEAR(varClass);
        CLEAR(varSchoolingYear);
        CLEAR(varStudent);

        rSchoolYear.RESET;
        rSchoolYear.SETRANGE(Status, rSchoolYear.Status::Active);
        IF rSchoolYear.FINDFIRST THEN;
        Filter;
    end;


    trigger OnClosePage()
    begin
        CleanRegisterClass;
        CleanAtribuirServicos; //IT001 - Park   
    end;

    local procedure Filter()
    var
        l_recRegistration: Record Registration;
    begin

        l_recRegistration.RESET;
        IF varClass <> '' THEN BEGIN

            l_recRegistration.SETRANGE(Class);
            l_recRegistration.SETRANGE(Class, varClass);
            l_recRegistration.SETRANGE(Status, l_recRegistration.Status::Subscribed);
        END ELSE
            l_recRegistration.SETRANGE(Class, '');


        l_recRegistration.SETFILTER("Student Code No.", varStudent);
        l_recRegistration.SETFILTER("School Year", varSchoolYear);

        IF (varClass = '') AND (varStudent = '') AND (varSchoolYear = '') THEN
            l_recRegistration.SETRANGE("Student Code No.", '');

        if l_recRegistration.findset then BEGIN
            CurrPage.PagePartServiceList.Page.SetTableView(l_recRegistration);
            CurrPage.PagePartServiceList.Page.Update();
        END ELSE begin
            l_recRegistration.reset;
            l_recRegistration.findset;
            CurrPage.PagePartServiceList.Page.SetTableView(l_recRegistration);
            CurrPage.PagePartServiceList.Page.Update();
        end;
        CurrPage.Update(true);
    end;


    local procedure MarkAll(Mark: Boolean)
    begin


        rRegistration.RESET;
        IF varSchoolYear <> '' THEN
            rRegistration.SETRANGE("School Year", varSchoolYear);
        IF varClass <> '' THEN BEGIN
            rRegistration.SETRANGE(Class, varClass);
            rRegistration.SETRANGE(Status, rRegistration.Status::Subscribed);
        END;
        IF varStudent <> '' THEN
            rRegistration.SETRANGE("Student Code No.", varStudent);
        rRegistration.MODIFYALL(Selection, Mark);
        //2011.10.07
        IF Mark = TRUE THEN
            rRegistration.MODIFYALL("User Session", UPPERCASE(USERID))
        ELSE
            rRegistration.MODIFYALL("User Session", '');
        CurrPage.UPDATE();
    end;


    local procedure CleanRegisterClass()
    begin

        rRegistration.RESET;
        rRegistration.SETRANGE(Selection, TRUE);
        IF rRegistration.FIND('-') THEN BEGIN
            rRegistration.MODIFYALL(Selection, FALSE);
            rRegistration.MODIFYALL("User Session", '');
        END;
    end;


    local procedure CleanAtribuirServicos()
    var
        ServicosAtribuir: Record "Serviços a Atrbuir";
    begin

        //IT001 - Park - sn
        ServicosAtribuir.RESET;
        ServicosAtribuir.SETRANGE(ServicosAtribuir."User ID", UPPERCASE(USERID));
        IF ServicosAtribuir.FINDFIRST THEN
            ServicosAtribuir.DELETEALL;
        //IT001 - Park - en    
    end;

    local procedure ValidateSelection()
    var
        myInt: Integer;
    begin

        rRegistration.RESET;
        rRegistration.SETRANGE(Class, varClass);
        rRegistration.SETRANGE(Selection, TRUE);
        rRegistration.SETRANGE("User Session", UPPERCASE(USERID));
        IF NOT rRegistration.FIND('-') THEN
            ERROR(Text0007);
    end;

    local procedure AtribuirServiços()
    var
        int: Integer;
    begin

        IF NOT CONFIRM(Text0008, FALSE) THEN
            EXIT;

        //IT001 - Park - sn
        //IF varServices = '' THEN
        //  ERROR(Text0011);
        //IT001 - Park - en

        rRegistration.RESET;
        IF varClass <> '' THEN
            rRegistration.SETRANGE(Class, varClass);
        rRegistration.SETRANGE("School Year", varSchoolYear);
        IF varSchoolingYear <> '' THEN
            rRegistration.SETRANGE("Schooling Year", varSchoolingYear);
        rRegistration.SETRANGE(Selection, TRUE);
        rRegistration.SETRANGE(rRegistration."User Session", USERID);//IT001 - Park
        IF rRegistration.FIND('-') THEN BEGIN
            REPEAT
                //IT001 - Park - sn
                rServicosaAtribuir.RESET;
                rServicosaAtribuir.SETRANGE(rServicosaAtribuir."User ID", USERID);
                IF rServicosaAtribuir.FINDSET THEN BEGIN
                    REPEAT
                        //IT001 - Park - en

                        rStudentServPlan.RESET;
                        rStudentServPlan.SETRANGE("Student No.", rRegistration."Student Code No.");
                        rStudentServPlan.SETRANGE("School Year", rRegistration."School Year");
                        IF varSchoolingYear <> '' THEN
                            rStudentServPlan.SETRANGE("Schooling Year", varSchoolingYear);
                        //IT001 - Park - sn
                        //rStudentServPlan.SETRANGE("Service Code", varServices);
                        rStudentServPlan.SETRANGE("Service Code", rServicosaAtribuir."No.");
                        //IT001 - Park - en

                        IF rStudentServPlan.FIND('-') THEN BEGIN
                            IF rStudentServPlan.Selected THEN BEGIN
                                IF (int = 0) OR (int <> 3) THEN BEGIN
                                    MESSAGE(Text0001);
                                    int := DIALOG.STRMENU(TextOptions);
                                END;
                                IF int = 0 THEN BEGIN
                                    MESSAGE(Text0004);
                                    EXIT;
                                END ELSE
                                    InsertServices(int, FALSE);
                            END ELSE BEGIN
                                InsertServices(0, FALSE);
                            END;
                        END ELSE
                            InsertServices(int, TRUE);

                        //Actualiza as entidades pagadoras
                        //ValidatePayingEntity(rRegistration."Student Code No.",rSchoolYear."School Year");
                        //Normatica 2012.10.09 - tem de ser o ano que o utilizador escolheu no ecran e não o ativo
                        ValidatePayingEntity(rRegistration."Student Code No.", varSchoolYear);


                        rRegistration.Selection := FALSE;
                        rRegistration."User Session" := '';
                        rRegistration.MODIFY;



                    //IT001 - Park - sn
                    UNTIL rServicosaAtribuir.NEXT = 0;
                END ELSE
                    ERROR(Text0011);
            //IT001 - Park - en

            UNTIL rRegistration.NEXT = 0;
            MESSAGE(Text0006);
        END;


        //IT001 - Park - sn
        /*
        IF varServices = '' THEN BEGIN
                    varDescService := '';
                    varMonths[1] := FALSE;
                    varMonths[2] := FALSE;
                    varMonths[3] := FALSE;
                    varMonths[4] := FALSE;
                    varMonths[5] := FALSE;
                    varMonths[6] := FALSE;
                    varMonths[7] := FALSE;
                    varMonths[8] := FALSE;
                    varMonths[9] := FALSE;
                    varMonths[10] := FALSE;
                    varMonths[11] := FALSE;
                    varMonths[12] := FALSE;

                END;



                IF varQuant <> 0 THEN BEGIN
                    varQuant := 0;

                    //Normatica 2012.10.24 - se não limpa o Cod. do produto/serviço não deve limpar o Preço
                    /*
                    IF varPrice <> 0 THEN
                                    varPrice := 0;
                    
s
        IF vVariant <> '' THEN
            vVariant := '';
    END;

*/
        //IT001 - Park - en    
    end;

    local procedure InsertServices(inAction: Integer; pInsert: Boolean)
    var
        StudentServPlan: Record "Student Service Plan";
        StudentServPlanLine: Record "Student Service Plan";
    begin

        //O Parametro inAction serve para Incrementar/ Subtituir valores nos Plano Serviços Aluno
        IF NOT pInsert THEN BEGIN
            IF inAction <> 3 THEN BEGIN
                //IT001 - Park - sn
                IF inAction = 1 THEN
                    rStudentServPlan.Quantity := rServicosaAtribuir.Quantidade;
                IF inAction = 2 THEN
                    rStudentServPlan.Quantity := rStudentServPlan.Quantity + rServicosaAtribuir.Quantidade;
                IF NOT rStudentServPlan.January THEN
                    rStudentServPlan.January := rServicosaAtribuir.January;
                IF NOT rStudentServPlan.February THEN
                    rStudentServPlan.February := rServicosaAtribuir.February;
                IF NOT rStudentServPlan.March THEN
                    rStudentServPlan.March := rServicosaAtribuir.March;
                IF NOT rStudentServPlan.April THEN
                    rStudentServPlan.April := rServicosaAtribuir.April;
                IF NOT rStudentServPlan.May THEN
                    rStudentServPlan.May := rServicosaAtribuir.May;
                IF NOT rStudentServPlan.June THEN
                    rStudentServPlan.June := rServicosaAtribuir.June;
                IF NOT rStudentServPlan.July THEN
                    rStudentServPlan.July := rServicosaAtribuir.July;
                IF NOT rStudentServPlan.August THEN
                    rStudentServPlan.August := rServicosaAtribuir.August;
                IF NOT rStudentServPlan.Setember THEN
                    rStudentServPlan.Setember := rServicosaAtribuir.Setember;
                IF NOT rStudentServPlan.October THEN
                    rStudentServPlan.October := rServicosaAtribuir.October;
                IF NOT rStudentServPlan.November THEN
                    rStudentServPlan.November := rServicosaAtribuir.November;
                IF NOT rStudentServPlan.Dezember THEN
                    rStudentServPlan.Dezember := rServicosaAtribuir.Dezember;

                IF rServicosaAtribuir."Novo Valor" <> 0 THEN
                    rStudentServPlan."Student Unit Price" := rServicosaAtribuir."Novo Valor";
                //IT001 - Park - en

                rStudentServPlan.Selected := TRUE;
                rStudentServPlan.MODIFY(TRUE);

            END ELSE BEGIN
                StudentServPlanLine.RESET;
                StudentServPlanLine.SETRANGE("Student No.", rRegistration."Student Code No.");
                StudentServPlanLine.SETRANGE("School Year", rRegistration."School Year");
                StudentServPlanLine.SETRANGE("Schooling Year", rRegistration."Schooling Year");
                //IT001 - Park - sn
                //StudentServPlanLine.SETRANGE("Service Code",varServices);
                StudentServPlanLine.SETRANGE("Service Code", rServicosaAtribuir."No.");
                //IT001 - Park - en
                IF StudentServPlanLine.FINDLAST THEN;

                rStudentServPlan.INIT;
                //rStudentServPlan.VALIDATE("Student No.", rRegistrationClass."Student Code No.");
                rStudentServPlan.VALIDATE("Student No.", rRegistration."Student Code No.");
                //rStudentServPlan."Schooling Year" := varSchoolingYear;
                //rStudentServPlan."School Year" := rSchoolYear."School Year";
                rStudentServPlan."Schooling Year" := rRegistration."Schooling Year";
                rStudentServPlan."School Year" := rRegistration."School Year";
                rStudentServPlan."Line No." := StudentServPlanLine."Line No." + 10000;

                IF rServicosaAtribuir.Tipo = rServicosaAtribuir.Tipo::Serviço THEN
                    rStudentServPlan.Type := rStudentServPlan.Type::Service
                ELSE
                    rStudentServPlan.Type := rStudentServPlan.Type::Item;

                rStudentServPlan.VALIDATE("Service Code", rServicosaAtribuir."No.");
                rStudentServPlan.Description := rServicosaAtribuir.Description;
                rStudentServPlan."Variant Code" := rServicosaAtribuir."Variant Code";
                rStudentServPlan.Quantity := rServicosaAtribuir.Quantidade;
                rStudentServPlan."Student Unit Price" := rServicosaAtribuir."Novo Valor";
                rStudentServPlan."Service Type" := rStudentServPlan."Service Type"::Ocasional;
                rStudentServPlan."Responsibility Center" := varRespCenter;
                rStudentServPlan.January := rServicosaAtribuir.January;
                ;
                rStudentServPlan.February := rServicosaAtribuir.February;
                rStudentServPlan.March := rServicosaAtribuir.March;
                rStudentServPlan.April := rServicosaAtribuir.April;
                rStudentServPlan.May := rServicosaAtribuir.May;
                rStudentServPlan.June := rServicosaAtribuir.June;
                rStudentServPlan.July := rServicosaAtribuir.July;
                rStudentServPlan.August := rServicosaAtribuir.August;
                rStudentServPlan.Setember := rServicosaAtribuir.Setember;
                rStudentServPlan.October := rServicosaAtribuir.October;
                rStudentServPlan.November := rServicosaAtribuir.November;
                rStudentServPlan.Dezember := rServicosaAtribuir.Dezember;
                rStudentServPlan.Selected := TRUE;
                rStudentServPlan."Last Date Modified" := TODAY;
                rStudentServPlan."User ID" := USERID;
                rStudentServPlan.INSERT;

            END;
        END;
        IF pInsert THEN BEGIN
            StudentServPlanLine.RESET;
            StudentServPlanLine.SETRANGE("Student No.", rRegistration."Student Code No.");
            StudentServPlanLine.SETRANGE("School Year", rRegistration."School Year");
            StudentServPlanLine.SETRANGE("Schooling Year", rRegistration."Schooling Year");
            //IT001 - Park - sn
            //StudentServPlanLine.SETRANGE("Service Code",varServices);
            StudentServPlanLine.SETRANGE("Service Code", rServicosaAtribuir."No.");
            //IT001 - Park - en
            IF StudentServPlanLine.FINDLAST THEN;

            rStudentServPlan.INIT;
            //rStudentServPlan.VALIDATE("Student No.", rRegistrationClass."Student Code No.");
            rStudentServPlan.VALIDATE("Student No.", rRegistration."Student Code No.");
            //rStudentServPlan."Schooling Year" := varSchoolingYear;
            //rStudentServPlan."School Year" := rSchoolYear."School Year";
            rStudentServPlan."Schooling Year" := rRegistration."Schooling Year";
            rStudentServPlan."School Year" := rRegistration."School Year";
            rStudentServPlan."Line No." := StudentServPlanLine."Line No." + 10000;
            //IT001 - Park - sn
            IF rServicosaAtribuir.Tipo = rServicosaAtribuir.Tipo::Serviço THEN
                rStudentServPlan.Type := rStudentServPlan.Type::Service
            ELSE
                rStudentServPlan.Type := rStudentServPlan.Type::Item;
            rStudentServPlan.VALIDATE("Service Code", rServicosaAtribuir."No.");
            rStudentServPlan.Description := rServicosaAtribuir.Description;
            rStudentServPlan."Variant Code" := rServicosaAtribuir."Variant Code";
            rStudentServPlan.Quantity := rServicosaAtribuir.Quantidade;
            rStudentServPlan."Student Unit Price" := rServicosaAtribuir."Novo Valor";
            //IT001 - Park - en
            rStudentServPlan."Service Type" := rStudentServPlan."Service Type"::Ocasional;
            rStudentServPlan."Responsibility Center" := varRespCenter;

            rStudentServPlan.January := rServicosaAtribuir.January;
            rStudentServPlan.February := rServicosaAtribuir.February;
            rStudentServPlan.March := rServicosaAtribuir.March;
            rStudentServPlan.April := rServicosaAtribuir.April;
            rStudentServPlan.May := rServicosaAtribuir.May;
            rStudentServPlan.June := rServicosaAtribuir.June;
            rStudentServPlan.July := rServicosaAtribuir.July;
            rStudentServPlan.August := rServicosaAtribuir.August;
            rStudentServPlan.Setember := rServicosaAtribuir.Setember;
            rStudentServPlan.October := rServicosaAtribuir.October;
            rStudentServPlan.November := rServicosaAtribuir.November;
            rStudentServPlan.Dezember := rServicosaAtribuir.Dezember;

            rStudentServPlan.Selected := TRUE;
            rStudentServPlan."Last Date Modified" := TODAY;
            rStudentServPlan."User ID" := USERID;
            rStudentServPlan.INSERT;
        END;
    end;

    local procedure ValidatePayingEntity(pStudentCode: Code[20]; pSchoolYear: Code[20])
    var
        rUsersFamiliyStudents: Record "Users Family / Students";
    begin

        rUsersFamiliyStudents.RESET;
        rUsersFamiliyStudents.SETRANGE("School Year", pSchoolYear);
        rUsersFamiliyStudents.SETRANGE("Student Code No.", pStudentCode);
        rUsersFamiliyStudents.SETRANGE("Paying Entity", TRUE);
        IF rUsersFamiliyStudents.FINDFIRST THEN
            cStudentServices.DistributionByEntity(rUsersFamiliyStudents);
    end;

    var
        varClass: code[20];
        varStudent: Code[20];
        rSchoolYear: Record "School Year";
        rClass: Record Class;
        varSchoolingYear: Code[10];
        varSchoolYear: Code[20];
        varRespCenter: Code[10];
        varSchoolingYear2: Code[50];
        recStrutureEdu: Record "Structure Education Country";
        varLevel: Option "Pré-Escolar","1º Ciclo","2º Ciclo","3º Ciclo","Secundário";
        rStudentsTemP: record "Students" temporary;
        rRegistrationClass: Record "Registration Class";
        rStudents: Record Students;
        rRegistration: Record Registration;
        rServicosaAtribuir: Record "Serviços a Atrbuir";
        rStudentServPlan: Record "Student Service Plan";
        cStudentServices: Codeunit "Student Services";
        //rCarregaPlanoServ: Report "Carregar Plano Serv";
        Text0011: Label 'É necessário escolher um serviço antes de o poder processar.';
        Text0012: Label 'Falta selecionar o ano escolar';
        Text50001: Label 'É necessário seleccionar um mês.';
        Text0001: Label 'O Serviço já se encontra associado aos alunos.\Deve escolher uma das opções que se seguem de forma a prosseguir com o processo.';
        Text0003: Label 'Tem de definir a quantidade a processar!';
        Text0004: Label 'Processo Interrompido!';
        Text0006: Label 'O processo de atribuição de serviços foi concluido com sucesso.';
        Text0007: Label 'Não tem um aluno seleccionado para atribuir o serviço.';
        Text0008: Label 'Confirma que deseja processar esses serviços?';
        TextOptions: Label 'Substituir Quantidade, Incrementar Quantidade, Novo Serviço';
}


