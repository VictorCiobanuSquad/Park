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

    Caption = 'Giving Services';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = Registration;
    SourceTableView = SORTING(Class, "Class No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Geral)
            {
                Caption = 'Filter Students:';
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));

                    trigger OnValidate()
                    begin
                        Filter;
                    end;
                }
                field(varLevel; varLevel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Level';

                    trigger OnValidate()
                    begin
                        Filter;
                    end;
                }
                field(varSchoolingYear2; varSchoolingYear2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin
                        Filter;
                    end;
                }
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class Code ';
                    Importance = Promoted;
                    TableRelation = Class.Class WHERE("School Year" = FIELD("School Year"));

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);

                        rSchoolYear.Reset;
                        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                        if rSchoolYear.FindFirst then begin
                            rClass.Reset;
                            rClass.SetRange("School Year", rSchoolYear."School Year");
                            rClass.SetRange(Class, varClass);
                            if rClass.FindFirst then begin
                                varSchoolingYear := rClass."Schooling Year";
                                varSchoolYear := rClass."School Year";
                            end else begin
                                Clear(varStudent);
                                rStudentsTemP.DeleteAll;
                                Clear(rStudentsTemP);
                            end;
                        end;


                        Filter;
                    end;
                }
                field(varStudent; varStudent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student Code ';
                    Importance = Promoted;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rStudentsTemP.DeleteAll;
                        Clear(rStudentsTemP);
                        Clear(varStudent);
                        if varClass <> '' then begin
                            rRegistrationClass.Reset;
                            rRegistrationClass.SetRange(Class, varClass);
                            rRegistrationClass.SetRange("School Year", rSchoolYear."School Year");
                            rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                            rRegistrationClass.SetRange("Responsibility Center", varRespCenter);
                            if rRegistrationClass.FindSet then begin
                                repeat
                                    rStudents.Reset;
                                    rStudents.SetRange("No.", rRegistrationClass."Student Code No.");
                                    if rStudents.FindFirst then begin
                                        rStudentsTemP.Reset;
                                        rStudentsTemP.TransferFields(rStudents);
                                        rStudentsTemP.Insert;
                                    end;
                                until rRegistrationClass.Next = 0;
                                if PAGE.RunModal(PAGE::"Students List", rStudentsTemP) = ACTION::LookupOK then
                                    varStudent := rStudentsTemP."No.";
                                Filter;
                            end;
                        end else begin
                            Clear(varStudent);
                            rStudents.Reset;
                            if PAGE.RunModal(PAGE::"Students List", rStudents) = ACTION::LookupOK then begin
                                varStudent := rStudents."No.";
                                rRegistrationClass.Reset;
                                rRegistrationClass.SetRange("Student Code No.", rStudents."No.");
                                rRegistrationClass.SetRange("School Year", rSchoolYear."School Year");
                                rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
                                rRegistrationClass.SetRange("Responsibility Center", varRespCenter);
                                if rRegistrationClass.FindFirst then begin
                                    varClass := rRegistrationClass.Class;
                                    varSchoolYear := rRegistrationClass."School Year";
                                end;
                                Filter;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        Filter;
                    end;
                }
            }
            group("Assign Services:")
            {
                Caption = 'Assign Services:';
                field(varType; varType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(varServices; varServices)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service No.';
                    Importance = Promoted;
                    TableRelation = "Services ET"."No.";

                    trigger OnValidate()
                    begin
                        if varServices <> '' then begin
                            ServicesET.Get(varServices);
                            GetService;
                            varDescService := ServicesET.Description;
                            CurrPage.Update(true);
                        end;
                    end;
                }
                field(varDescService; varDescService)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service Description';
                    Editable = false;
                }
                field(varQuant; varQuant)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(varPrice; varPrice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Price';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
            }
            group(Month)
            {
                field("varMonths[9]"; varMonths[9])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'September';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[10]"; varMonths[10])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'October';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[11]"; varMonths[11])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'November';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[12]"; varMonths[12])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'December';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[1]"; varMonths[1])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'January';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[2]"; varMonths[2])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'February';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[3]"; varMonths[3])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'March';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[4]"; varMonths[4])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'April';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[5]"; varMonths[5])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'May';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[6]"; varMonths[6])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'June';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[7]"; varMonths[7])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'July';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("varMonths[8]"; varMonths[8])
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'August';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
            }

            repeater(Control1000000026)
            {
                ShowCaption = false;
                field(Selection; Rec.Selection)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                }
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

                trigger OnAction()
                begin

                    if varQuant = 0 then
                        Error(Text0003);

                    if varSchoolYear = '' then
                        Error(Text0012);
                    //ValidateUserSelection();
                    ValidateSelection;
                    AtribuirServiços;
                end;
            }
            action("Mark All")
            {
                Caption = '&Mark All';
                Image = Allocations;

                trigger OnAction()
                begin

                    if varSchoolYear = '' then Error(Text0012);
                    MarkAll(true);
                end;
            }
            action(UnmarkAll)
            {
                Caption = '&Unmark All';
                Image = CancelAllLines;

                trigger OnAction()
                begin
                    MarkAll(false);
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        CleanRegisterClass;
    end;

    trigger OnOpenPage()
    begin

        Clear(varLevel);
        Clear(varClass);
        Clear(varSchoolingYear);
        Clear(varStudent);
        Clear(varPeriod);
        //RESET;

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;


        Filter;
    end;

    var
        varClass: Code[20];
        varSchoolingYear: Code[10];
        varServices: Code[20];
        varStudent: Code[20];
        varDescService: Text[50];
        varQuant: Integer;
        varMonths: array[12] of Boolean;
        TextOptions: Label 'Insert Quantity, Increment Quantity';
        Text0001: Label 'The Service is already associated with the student.\Choose one of the following options in order to continue with the process.';
        Text0002: Label 'Done';
        Text0003: Label 'You must define the quantity to be processed!';
        Text0004: Label 'Canceled';
        Text0005: Label 'You must choose at least one student to continue with the process!';
        Text0006: Label 'The process of service allocation was completed successfully.';
        Text0007: Label 'There is no selected student in order to assign the service.';
        Text0008: Label 'Confirm that you want to process these services?';
        Text0009: Label 'Feld "Class" is mandatory.';
        Text0010: Label 'Service does not exist.';
        Text0011: Label 'You must choose a Service before being able to process it.';
        Text0012: Label 'The User must select a School Year';
        ServicesET: Record "Services ET";
        rSchoolYear: Record "School Year";
        rClass: Record Class;
        rRegistrationClass: Record "Registration Class";
        rStudentServPlan: Record "Student Service Plan";
        LineNo: Integer;
        cStudentServices: Codeunit "Student Services";
        varRespCenter: Code[10];
        rStudentsTemP: Record Students temporary;
        rStudents: Record Students;
        rRegistration: Record Registration;
        varSchoolYear: Code[20];
        varPrice: Decimal;
        varPeriod: Option " ",Mensal,Trimestral,Anual;
        varType: Option "Serviço",Produto;
        recItem: Record Item;
        varSchoolingYear2: Code[50];
        varLevel: Option "Pré-Escolar","1º Ciclo","2º Ciclo","3º Ciclo","Secundário";
        recStrutureEdu: Record "Structure Education Country";
        Text1102059001: Label 'Filter Students:';
        Text1102059002: Label 'Assign Services:';

    local procedure GetService()
    begin
        if ServicesET.Get(varServices) then begin
            varMonths[1] := ServicesET.January;
            varMonths[2] := ServicesET.February;
            varMonths[3] := ServicesET.March;
            varMonths[4] := ServicesET.April;
            varMonths[5] := ServicesET.May;
            varMonths[6] := ServicesET.June;
            varMonths[7] := ServicesET.July;
            varMonths[8] := ServicesET.August;
            varMonths[9] := ServicesET.Setember;
            varMonths[10] := ServicesET.October;
            varMonths[11] := ServicesET.November;
            varMonths[12] := ServicesET.December;
        end;
    end;

    //[Scope('OnPrem')]
    procedure "AtribuirServiços"()
    var
        recStudServPlan: Record "Student Service Plan";
        int: Integer;
    begin
        if not Confirm(Text0008, false) then
            exit;
        if varServices = '' then
            Error(Text0011);

        rRegistration.Reset;
        if varClass <> '' then
            rRegistration.SetRange(Class, varClass);
        rRegistration.SetRange("School Year", varSchoolYear);
        if varSchoolingYear <> '' then
            rRegistration.SetRange("Schooling Year", varSchoolingYear);
        rRegistration.SetRange(Selection, true);
        if rRegistration.FindSet then begin
            repeat
                rStudentServPlan.Reset;
                rStudentServPlan.SetRange("Student No.", rRegistration."Student Code No.");
                rStudentServPlan.SetRange("School Year", rRegistration."School Year");
                if varSchoolingYear <> '' then
                    rStudentServPlan.SetRange("Schooling Year", varSchoolingYear);
                rStudentServPlan.SetRange("Service Code", varServices);
                if rStudentServPlan.Find('-') then begin
                    if rStudentServPlan.Selected then begin
                        if (int = 0) or (int <> 3) then begin
                            Message(Text0001);
                            int := DIALOG.StrMenu(TextOptions);
                        end;
                        if int = 0 then begin
                            Message(Text0004);
                            exit;
                        end else
                            InsertServices(int, false);
                    end else begin
                        InsertServices(0, false);
                    end;
                end else
                    InsertServices(int, true);

                //Actualiza as entidades pagadoras
                //ValidatePayingEntity(rRegistration."Student Code No.",rSchoolYear."School Year");
                //Normatica 2012.10.09 - tem de ser o ano que o utilizador escolheu no ecran e não o ativo
                ValidatePayingEntity(rRegistration."Student Code No.", varSchoolYear);


                rRegistration.Selection := false;
                rRegistration."User Session" := '';
                rRegistration.Modify;
            until rRegistration.Next = 0;
            Message(Text0006);
        end;

        if varServices = '' then begin
            varDescService := '';
            varMonths[1] := false;
            varMonths[2] := false;
            varMonths[3] := false;
            varMonths[4] := false;
            varMonths[5] := false;
            varMonths[6] := false;
            varMonths[7] := false;
            varMonths[8] := false;
            varMonths[9] := false;
            varMonths[10] := false;
            varMonths[11] := false;
            varMonths[12] := false;
        end;

        if varQuant <> 0 then
            varQuant := 0
    end;

    //[Scope('OnPrem')]
    procedure ValidateStudentServ() outInt: Integer
    var
        StudentServPlanTEMP: Record "Student Service Plan" temporary;
    begin
        //Validar se os alunos já tem o serviço atribuido para o mês que selecionarm

        StudentServPlanTEMP.Reset;
        if varType = varType::"Serviço" then
            StudentServPlanTEMP.SetRange(Type, StudentServPlanTEMP.Type::Service)
        else
            StudentServPlanTEMP.SetRange(Type, StudentServPlanTEMP.Type::Item);
        StudentServPlanTEMP.SetFilter("Service Code", '%1', varServices);
        if StudentServPlanTEMP.Find('-') then begin
            Message(Text0001);
            outInt := DIALOG.StrMenu(TextOptions);
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertServices(inAction: Integer; pInsert: Boolean)
    var
        StudentServPlan: Record "Student Service Plan";
        StudentServPlanLine: Record "Student Service Plan";
        rServicesET: Record "Services ET";
    begin
        //O Parametro inAction serve para Incrementar/ Subtituir valores nos Plano Serviços Aluno
        if not pInsert then begin
            if inAction <> 3 then begin
                if inAction = 1 then
                    rStudentServPlan.Quantity := varQuant;
                if inAction = 2 then
                    rStudentServPlan.Quantity := rStudentServPlan.Quantity + varQuant;
                if not rStudentServPlan.January then
                    rStudentServPlan.January := varMonths[1];
                if not rStudentServPlan.February then
                    rStudentServPlan.February := varMonths[2];
                if not rStudentServPlan.March then
                    rStudentServPlan.March := varMonths[3];
                if not rStudentServPlan.April then
                    rStudentServPlan.April := varMonths[4];
                if not rStudentServPlan.May then
                    rStudentServPlan.May := varMonths[5];
                if not rStudentServPlan.June then
                    rStudentServPlan.June := varMonths[6];
                if not rStudentServPlan.July then
                    rStudentServPlan.July := varMonths[7];
                if not rStudentServPlan.August then
                    rStudentServPlan.August := varMonths[8];
                if not rStudentServPlan.Setember then
                    rStudentServPlan.Setember := varMonths[9];
                if not rStudentServPlan.October then
                    rStudentServPlan.October := varMonths[10];
                if not rStudentServPlan.November then
                    rStudentServPlan.November := varMonths[11];
                if not rStudentServPlan.Dezember then
                    rStudentServPlan.Dezember := varMonths[12];
                if varPrice <> 0 then
                    rStudentServPlan."Student Unit Price" := varPrice
                else begin
                    if rServicesET.Get(varServices) then
                        rStudentServPlan."Student Unit Price" := rServicesET."Unit Price";
                end;
                rStudentServPlan.Selected := true;
                rStudentServPlan.Modify(true);
            end else begin
                StudentServPlanLine.Reset;
                StudentServPlanLine.SetRange("Student No.", rRegistration."Student Code No.");
                StudentServPlanLine.SetRange("School Year", rRegistration."School Year");
                StudentServPlanLine.SetRange("Schooling Year", rRegistration."Schooling Year");
                StudentServPlanLine.SetRange("Service Code", varServices);
                if StudentServPlanLine.FindLast then;

                rStudentServPlan.Init;
                //rStudentServPlan.VALIDATE("Student No.", rRegistrationClass."Student Code No.");
                rStudentServPlan.Validate("Student No.", rRegistration."Student Code No.");
                //rStudentServPlan."Schooling Year" := varSchoolingYear;
                //rStudentServPlan."School Year" := rSchoolYear."School Year";
                rStudentServPlan."Schooling Year" := rRegistration."Schooling Year";
                rStudentServPlan."School Year" := rRegistration."School Year";
                rStudentServPlan."Line No." := StudentServPlanLine."Line No." + 10000;

                if varType = varType::"Serviço" then
                    rStudentServPlan.Type := rStudentServPlan.Type::Service
                else
                    rStudentServPlan.Type := rStudentServPlan.Type::Item;
                rStudentServPlan.Validate("Service Code", varServices);
                rStudentServPlan.Quantity := varQuant;
                if varPrice <> 0 then
                    rStudentServPlan."Student Unit Price" := varPrice
                else begin
                    if rServicesET.Get(varServices) then
                        rStudentServPlan."Student Unit Price" := rServicesET."Unit Price";
                end;
                rStudentServPlan."Service Type" := rStudentServPlan."Service Type"::Ocasional;
                rStudentServPlan."Responsibility Center" := varRespCenter;
                rStudentServPlan.January := varMonths[1];
                rStudentServPlan.February := varMonths[2];
                rStudentServPlan.March := varMonths[3];
                rStudentServPlan.April := varMonths[4];
                rStudentServPlan.May := varMonths[5];
                rStudentServPlan.June := varMonths[6];
                rStudentServPlan.July := varMonths[7];
                rStudentServPlan.August := varMonths[8];
                rStudentServPlan.Setember := varMonths[9];
                rStudentServPlan.October := varMonths[10];
                rStudentServPlan.November := varMonths[11];
                rStudentServPlan.Dezember := varMonths[12];
                rStudentServPlan.Selected := true;
                rStudentServPlan."Last Date Modified" := Today;
                rStudentServPlan."User ID" := UserId;
                rStudentServPlan.Insert;
            end;
        end;


        if pInsert then begin
            StudentServPlanLine.Reset;
            StudentServPlanLine.SetRange("Student No.", rRegistration."Student Code No.");
            StudentServPlanLine.SetRange("School Year", rRegistration."School Year");
            StudentServPlanLine.SetRange("Schooling Year", rRegistration."Schooling Year");
            StudentServPlanLine.SetRange("Service Code", varServices);
            if StudentServPlanLine.FindLast then;

            rStudentServPlan.Init;
            //rStudentServPlan.VALIDATE("Student No.", rRegistrationClass."Student Code No.");
            rStudentServPlan.Validate("Student No.", rRegistration."Student Code No.");
            //rStudentServPlan."Schooling Year" := varSchoolingYear;
            //rStudentServPlan."School Year" := rSchoolYear."School Year";
            rStudentServPlan."Schooling Year" := rRegistration."Schooling Year";
            rStudentServPlan."School Year" := rRegistration."School Year";
            rStudentServPlan."Line No." := StudentServPlanLine."Line No." + 10000;

            if varType = varType::"Serviço" then
                rStudentServPlan.Type := rStudentServPlan.Type::Service
            else
                rStudentServPlan.Type := rStudentServPlan.Type::Item;
            rStudentServPlan.Validate("Service Code", varServices);
            rStudentServPlan.Quantity := varQuant;
            if varPrice <> 0 then
                rStudentServPlan."Student Unit Price" := varPrice
            else begin
                if rServicesET.Get(varServices) then
                    rStudentServPlan."Student Unit Price" := rServicesET."Unit Price";
            end;
            rStudentServPlan."Service Type" := rStudentServPlan."Service Type"::Ocasional;
            rStudentServPlan."Responsibility Center" := varRespCenter;
            rStudentServPlan.January := varMonths[1];
            rStudentServPlan.February := varMonths[2];
            rStudentServPlan.March := varMonths[3];
            rStudentServPlan.April := varMonths[4];
            rStudentServPlan.May := varMonths[5];
            rStudentServPlan.June := varMonths[6];
            rStudentServPlan.July := varMonths[7];
            rStudentServPlan.August := varMonths[8];
            rStudentServPlan.Setember := varMonths[9];
            rStudentServPlan.October := varMonths[10];
            rStudentServPlan.November := varMonths[11];
            rStudentServPlan.Dezember := varMonths[12];
            rStudentServPlan.Selected := true;
            rStudentServPlan."Last Date Modified" := Today;
            rStudentServPlan."User ID" := UserId;
            rStudentServPlan.Insert;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetLastNo(pNo: Code[10])
    begin
        rStudentServPlan.Reset;
        rStudentServPlan.SetRange("Student No.", pNo);
        rStudentServPlan.SetRange("School Year", rSchoolYear."School Year");
        rStudentServPlan.SetRange("Schooling Year", varSchoolingYear);
        if rStudentServPlan.FindLast then
            LineNo := rStudentServPlan."Line No."
        else
            LineNo := 10000;
    end;

    //[Scope('OnPrem')]
    procedure "Filter"()
    begin
        if varClass <> '' then begin
            Rec.SetRange(Class);
            Rec.SetRange(Class, varClass);
            Rec.SetRange(Level);
        end else
            Rec.SetRange(Class, '');

        //IF varStudent <> '' THEN

        Rec.SetFilter("Student Code No.", varStudent);
        Rec.SetFilter("School Year", varSchoolYear);

        if (varClass = '') and (varStudent = '') and (varSchoolYear = '') then
            Rec.SetRange("Student Code No.", '');

        if (varSchoolingYear2 <> '') and (varClass = '') and (varStudent = '') then
            Rec.SetRange("Schooling Year", varSchoolingYear2);

        if (varClass = '') and (varStudent = '') then begin
            Rec.SetRange(Level, varLevel);
            Rec.SetRange(Class);
            Rec.SetRange("Student Code No.");

            if (varSchoolingYear2 <> '') then
                Rec.SetRange("Schooling Year", varSchoolingYear2);
        end;

        CurrPage.Update(true);
    end;

    //[Scope('OnPrem')]
    procedure CleanRegisterClass()
    var
        rRegistrationClass: Record "Registration Class";
    begin
        rRegistration.Reset;
        rRegistration.SetRange(Selection, true);
        if rRegistration.Find('-') then begin
            //rRegistration.RESET;
            rRegistration.ModifyAll("User Session", '');
            rRegistration.ModifyAll(Selection, false);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateSelection()
    var
        rRegistrationClass: Record "Registration Class";
    begin
        rRegistration.Reset;
        if varClass <> '' then
            rRegistration.SetRange(Class, varClass);
        rRegistration.SetRange(Selection, true);
        rRegistration.SetRange("User Session", UpperCase(UserId));
        if not rRegistration.Find('-') then
            Error(Text0007);
    end;

    //[Scope('OnPrem')]
    procedure ValidatePayingEntity(pStudentCode: Code[20]; pSchoolYear: Code[20])
    var
        rUsersFamilyStudents: Record "Users Family / Students";
    begin
        rUsersFamilyStudents.Reset;
        rUsersFamilyStudents.SetRange("School Year", pSchoolYear);
        rUsersFamilyStudents.SetRange("Student Code No.", pStudentCode);
        rUsersFamilyStudents.SetRange("Paying Entity", true);
        if rUsersFamilyStudents.FindFirst then
            cStudentServices.DistributionByEntity(rUsersFamilyStudents);
    end;

    //[Scope('OnPrem')]
    procedure ValidateServices()
    begin
        if varServices = '' then begin
            varDescService := '';
            varMonths[1] := false;
            varMonths[2] := false;
            varMonths[3] := false;
            varMonths[4] := false;
            varMonths[5] := false;
            varMonths[6] := false;
            varMonths[7] := false;
            varMonths[8] := false;
            varMonths[9] := false;
            varMonths[10] := false;
            varMonths[11] := false;
            varMonths[12] := false;

        end;
    end;

    //[Scope('OnPrem')]
    procedure MarkAll(Mark: Boolean)
    begin
        rRegistration.Reset;
        //IT002,so
        //rRegistration.SETRANGE(Level,varLevel);
        //IT002,eo

        //Normatica tem de apanhar só os inscritos   2012.07.09
        rRegistration.SetFilter(rRegistration.Status, '%1|%2', rRegistration.Status::Subscribed, 0);
        //Fim

        if varSchoolingYear2 <> '' then
            rRegistration.SetRange("Schooling Year", varSchoolingYear2);
        if varSchoolYear <> '' then
            rRegistration.SetRange("School Year", varSchoolYear);
        if varClass <> '' then
            rRegistration.SetRange(Class, varClass);
        if varStudent <> '' then
            rRegistration.SetRange("Student Code No.", varStudent);

        //IT005 - 2017.07.21 - Tem de Filtrar por ciclo e não estava
        rRegistration.SetRange(rRegistration.Level, varLevel);
        //IT005 - en

        rRegistration.ModifyAll(Selection, Mark);
        //2011.10.07
        if Mark = true then
            rRegistration.ModifyAll("User Session", UpperCase(UserId))
        else
            rRegistration.ModifyAll("User Session", '');
        //2011.10.07 - fim

        CurrPage.Update(true);
    end;
}

#pragma implicitwith restore

