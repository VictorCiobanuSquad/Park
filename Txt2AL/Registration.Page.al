#pragma implicitwith disable
page 31009768 Registration
{
    // //IT001 - 2017.03.14 - para atualizar a turma de transferência

    Caption = 'Registration';
    PageType = Card;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            group("Matrícula")
            {
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = SchoolingYearEditable;

                    trigger OnValidate()
                    begin
                        feditavel;
                    end;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Next School Year"; Rec."Next School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = StudyPlanCodeEditable;
                }
                field(Course; Rec.Course)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CourseEditable;
                }
                field("Services Plan Code"; Rec."Services Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ServicesPlanCodeEditable;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = ResponsibilityCenterEditable;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field("Actual Status"; Rec."Actual Status")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        //IT - Deixar mudar para prever falhas do Nav e do Portal. Mas perguntar se quer mudar 2015.05.30
                        if not Confirm(Text0015) then
                            Error('');
                    end;
                }
            }
            group(Geral)
            {
                part(Control1000000040; "Student Registration")
                {
                    SubPageLink = "No." = FIELD("Student Code No.");
                }
                group("Situation prior to entry into the School")
                {
                    Caption = 'Situation prior to entry into the School';
                    field("Pre-primary Education"; Rec."Pre-primary Education")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Pre School"; Rec."Pre School")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Pre Grouping"; Rec."Pre Grouping")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Preschool Years"; Rec."Preschool Years")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Special Education Situations")
                {
                    Caption = 'Special Education Situations';
                    field("Compulsory Edu. Amendment Req."; Rec."Compulsory Edu. Amendment Req.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Need Special Education"; Rec."Need Special Education")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Need Special Education Desc."; Rec."Need Special Education Desc.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Evidence Documents"; Rec."Evidence Documents")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Evidence Description"; Rec."Evidence Description")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            part(Associados; "Reg.Family/Students")
            {
                Caption = 'Associados';
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Student Code No." = FIELD("Student Code No.");
            }
            group(Outros)
            {
                group("School Social Action")
                {
                    Caption = 'School Social Action';
                    field(Residence; Rec.Residence)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Contains Residence"; Rec."Contains Residence")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Benefits; Rec.Benefits)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Contains Benefits"; Rec."Contains Benefits")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Transportation; Rec.Transportation)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Transportation Local"; Rec."Transportation Local")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("ENEB/PFEB")
                {
                    Caption = 'ENEB/PFEB';
                    field("ENEB Student Type"; Rec."ENEB Student Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(VERI)
                {
                    Caption = 'VERI';
                    field("Last Year Code"; Rec."Last Year Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            part(SubFormstudentsSubjects; "Student Study Plan")
            {
                Caption = 'Plano Estudos';
                SubPageLink = "Student Code No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year");
            }
            part("Plano Serviços"; "SubForm Student Services Plan")
            {
                Caption = 'Plano Serviços';
                SubPageLink = "Student No." = FIELD("Student Code No."),
                              "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year");
            }
            part("Transporte e Cantina"; "Students Non Lective Hours")
            {
                Caption = 'Transporte e Cantina';
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Student Code No." = FIELD("Student Code No."),
                              "Responsibility Center" = FIELD("Responsibility Center");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Disciplina)
            {
                Caption = '&Subjects';
                action(InscreverForaPlanoEstudo)
                {
                    Caption = 'Subsc&ribe away Study Plan';
                    Image = PostOrder;

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::" " then begin
                            Error(Text0009);
                        end else
                            if Rec.Status = Rec.Status::Subscribed then begin

                                PAGE.Run(31009903, Rec);
                            end;
                    end;
                }
                action(SelecionarAnosAnteriores)
                {
                    Caption = 'Se&lect Previous Years';
                    Image = PostedReturnReceipt;

                    trigger OnAction()
                    begin
                        fEnrollPreviousYears.GetInfo(Rec."School Year", Rec."Schooling Year", Rec."Student Code No.", Rec.Course);
                        fEnrollPreviousYears.RunModal;
                    end;
                }
            }
            separator(Action1000000037)
            {
            }
            action(Imprimir)
            {
                Caption = 'Pr&int';
                Image = Print;

                trigger OnAction()
                begin

                    Clear(fTemplates);
                    rTemplates.Reset;
                    rTemplates.SetRange(Type, rTemplates.Type::"Registration Sheet");
                    fTemplates.SetTableView(rTemplates);
                    fTemplates.SetFormRegistration(Rec, rTemplates.Type::"Registration Sheet", true);
                    fTemplates.LookupMode(true);
                    fTemplates.RunModal;
                end;
            }
            action(AtualizarMatricula)
            {
                Caption = 'Registration Update';
                Image = UpdateDescription;

                trigger OnAction()
                var
                    l_RegistrationSubjects: Record "Registration Subjects";
                    l_RegistrationSubjects2: Record "Registration Subjects";
                    l_class: Record Class;
                    l_RegistrationClass: Record "Registration Class";
                begin

                    //Normatica 2013.11.05
                    //Esta função foi desenvolvida para o seguinte caso: um aluno que se encontra no secundário, resolve mudar de curso
                    //já depois das aulas iniciarem, o processo de transferência de turma não funciona, porque o curso é diferente e ele não deixa
                    //assim sendo a unica forma é ir à matricula do aluno e transferir disciplina a disciplina as que se mantêm e anular as disciplinas
                    //que deixarem de existir  e inscrever as novas disciplinas
                    //Quando se faz este processo o aluno fica automaticamente inscrito na nova turma, mas no entanto a ficha da matricula não é atualiz

                    l_RegistrationSubjects.Reset;
                    l_RegistrationSubjects.SetRange(l_RegistrationSubjects."Student Code No.", Rec."Student Code No.");
                    l_RegistrationSubjects.SetRange(l_RegistrationSubjects."School Year", Rec."School Year");
                    l_RegistrationSubjects.SetRange(l_RegistrationSubjects.Class, Rec.Class);
                    l_RegistrationSubjects.SetRange(l_RegistrationSubjects.Status, l_RegistrationSubjects.Status::Subscribed);
                    if not l_RegistrationSubjects.FindFirst then begin
                        l_RegistrationSubjects2.Reset;
                        l_RegistrationSubjects2.SetRange(l_RegistrationSubjects2."Student Code No.", Rec."Student Code No.");
                        l_RegistrationSubjects2.SetRange(l_RegistrationSubjects2."School Year", Rec."School Year");
                        l_RegistrationSubjects2.SetRange(l_RegistrationSubjects2.Status, l_RegistrationSubjects2.Status::Subscribed);
                        if l_RegistrationSubjects2.FindFirst then begin

                            //IT001 - 2017.03.14 - para atualizar a turma de transferência
                            l_RegistrationClass.Reset;
                            l_RegistrationClass.SetRange(l_RegistrationClass."School Year", Rec."School Year");
                            l_RegistrationClass.SetRange(l_RegistrationClass.Class, Rec.Class);
                            l_RegistrationClass.SetRange(l_RegistrationClass."Schooling Year", Rec."Schooling Year");
                            l_RegistrationClass.SetRange(l_RegistrationClass."Student Code No.", Rec."Student Code No.");
                            if l_RegistrationClass.FindFirst then begin
                                if l_RegistrationClass.Status = l_RegistrationClass.Status::Transfer then begin
                                    l_RegistrationClass."Transfer Class" := l_RegistrationSubjects2.Class;
                                    l_RegistrationClass.Modify;
                                end;
                            end;
                            //IT001 - en

                            Rec.Class := l_RegistrationSubjects2.Class;
                            l_class.Reset;
                            l_class.SetRange(l_class.Class, l_RegistrationSubjects2.Class);
                            l_class.SetRange(l_class."School Year", l_RegistrationSubjects2."School Year");
                            if l_class.FindFirst then
                                Rec."Class Letter" := l_class."Class Letter";
                            if Rec."Study Plan Code" <> '' then Rec."Study Plan Code" := l_RegistrationSubjects2."Study Plan Code";
                            if Rec.Course <> '' then Rec.Course := l_RegistrationSubjects2."Study Plan Code";
                            Rec."Class No." := l_RegistrationSubjects2."Class No.";
                            Rec.Modify;

                        end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        feditavel;
    end;

    trigger OnOpenPage()
    begin
        feditavel;
    end;

    var
        rStudentledgerEntry: Record "Student Ledger Entry";
        Text0001: Label 'Student is enroled in a class with the subject %1.';
        Text0002: Label 'Option only for the Course.';
        Text0003: Label 'You can only create aspects if the student %1 is Subscribed.';
        Text0004: Label 'You can only create aspects if the student %1 is Enroled.';
        Text0005: Label 'You can only open the Sub Subjects if the Student is enroled on a Subject having Sub Subjects.';
        Text0006: Label 'The student registration is Annuled. You cannot access these options.';
        Text0007: Label 'The Student is already subscribed in a Class.';
        Text0008: Label 'You can only subscribe  if the Student is enroled in a class.';
        Text0009: Label 'The student must be registered in a class.';
        fRegisterStudent: Page "Register Student";
        rRegistrationSubjects: Record "Registration Subjects";
        rStctuEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        fCancelSubjectsWizard: Page "Cancel Subjects Wizard";
        fEnrollPreviousYears: Page "Select Previous Years";
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        fStudentSubSubjectsPlan: Page "Student Sub-Subjects Plan";
        fTemplates: Page Templates;
        rTemplates: Record Templates;
        StudyPlanCodeEditable: Boolean;
        CourseEditable: Boolean;
        ServicesPlanCodeEditable: Boolean;
        ResponsibilityCenterEditable: Boolean;
        SchoolingYearEditable: Boolean;
        Text0015: Label 'Confirma que deseja alterar o Estado Actual do Aluno?';

    //[Scope('OnPrem')]
    procedure feditavel()
    begin

        StudyPlanCodeEditable := true;
        SchoolingYearEditable := true;
        CourseEditable := true;
        ResponsibilityCenterEditable := true;
        ServicesPlanCodeEditable := true;

        if Rec.Status <> Rec.Status::" " then begin
            StudyPlanCodeEditable := false;
            SchoolingYearEditable := false;
            CourseEditable := false;
            ResponsibilityCenterEditable := false;
            if (Rec."Services Plan Code" = '') or (not Rec.ChekIfInvoice) then
                ServicesPlanCodeEditable := true
            else
                ServicesPlanCodeEditable := false;
            exit;
        end;

        // IF Already Have Invoices But the status is empty
        if (Rec."Services Plan Code" = '') or (not Rec.ChekIfInvoice) then
            ServicesPlanCodeEditable := true
        else
            ServicesPlanCodeEditable := false;

        if Rec.Type = Rec.Type::Simple then begin
            CourseEditable := false;
            StudyPlanCodeEditable := true;
        end;

        if Rec.Type = Rec.Type::Multi then begin
            CourseEditable := true;
            StudyPlanCodeEditable := false;
        end;
    end;
}

#pragma implicitwith restore

