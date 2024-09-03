#pragma implicitwith disable
page 52786 "Registration Class"
{
    AutoSplitKey = true;
    Caption = 'Registration Class';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Registration Class";
    SourceTableView = SORTING("Class No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        ClassNoOnAfterValidate;
                    end;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("School Name Transfer"; Rec."School Name Transfer")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer Class"; Rec."Transfer Class")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Inscrever)
                {
                    ApplicationArea = All;
                    Caption = '&Subscribe';
                    Image = Register;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        //Normatica 2013.07.22 - Não deixar fazer este processo se o ano estiver fechado
                        rAnoLetivo.Reset;
                        rAnoLetivo.SetRange(rAnoLetivo."School Year", Rec."School Year");
                        rAnoLetivo.SetRange(rAnoLetivo.Status, rAnoLetivo.Status::Closed);
                        if rAnoLetivo.FindFirst then
                            Error(Text0015);
                        //Normatica 2013.07.22 - Fim

                        rClass.Reset;
                        rClass.SetRange(rClass.Class, Rec.Class);
                        rClass.SetRange(rClass."School Year", Rec."School Year");
                        if rClass.FindFirst then begin

                            if (Rec.Status = Rec.Status::" ") then
                                rClass.SubscribedRegistrationClass
                            else
                                Error(Text005, Rec.Status);
                        end;
                    end;
                }
                action(Anular)
                {
                    ApplicationArea = All;
                    Caption = 'A&nnul Registration';
                    Image = CancelledEntries;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        //Normatica 2013.07.22 - Não deixar fazer este processo se o ano estiver fechado
                        rAnoLetivo.Reset;
                        rAnoLetivo.SetRange(rAnoLetivo."School Year", Rec."School Year");
                        rAnoLetivo.SetRange(rAnoLetivo.Status, rAnoLetivo.Status::Closed);
                        if rAnoLetivo.FindFirst then
                            Error(Text0015);
                        //Normatica 2013.07.22 - Fim

                        rClass.Reset;
                        rClass.SetRange(rClass.Class, Rec.Class);
                        rClass.SetRange(rClass."School Year", Rec."School Year");
                        if rClass.FindFirst then begin

                            if Rec.Status = Rec.Status::Subscribed then begin
                                rClass.CancelRegistrationClass(Rec);
                            end else begin
                                if Rec.Status = Rec.Status::" " then
                                    Error(Text006)
                                else
                                    Error(Text005, Rec.Status);
                            end;
                        end;
                    end;
                }
                action(Corrigir)
                {
                    ApplicationArea = All;
                    Caption = '&Correct Registration';
                    Image = EditLines;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin

                        //Normatica 2013.07.22 - Não deixar fazer este processo se o ano estiver fechado
                        rAnoLetivo.Reset;
                        rAnoLetivo.SetRange(rAnoLetivo."School Year", Rec."School Year");
                        rAnoLetivo.SetRange(rAnoLetivo.Status, rAnoLetivo.Status::Closed);
                        if rAnoLetivo.FindFirst then
                            Error(Text0015);
                        //Normatica 2013.07.22 - Fim

                        rClass.Reset;
                        rClass.SetRange(rClass.Class, Rec.Class);
                        rClass.SetRange(rClass."School Year", Rec."School Year");
                        if rClass.FindFirst then begin

                            if (Rec.Status <> Rec.Status::" ") then
                                rClass.CorrectRegistrationClass(Rec)
                            else begin
                                if Rec.Status = Rec.Status::" " then
                                    Error(Text006)
                                else
                                    Error(Text005, Rec.Status);
                            end;
                        end;
                    end;
                }
                action(Transferir)
                {
                    ApplicationArea = All;
                    Caption = '&Transfer';
                    Image = TransferOrder;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
                        fTransferWizard: Page "Transfer Wizard";
                    begin

                        //Normatica 2013.07.22 - Não deixar fazer este processo se o ano estiver fechado
                        rAnoLetivo.Reset;
                        rAnoLetivo.SetRange(rAnoLetivo."School Year", Rec."School Year");
                        rAnoLetivo.SetRange(rAnoLetivo.Status, rAnoLetivo.Status::Closed);
                        if rAnoLetivo.FindFirst then
                            Error(Text0015);
                        //Normatica 2013.07.22 - Fim


                        if Rec.Status = Rec.Status::Subscribed then begin
                            if rRegistration.Get(Rec."Student Code No.", Rec."School Year", Rec."Responsibility Center") then;
                            if Rec.Class = rRegistration.Class then begin
                                fTransferWizard.GetRegistrationClass(Rec);
                                fTransferWizard.RunModal;
                            end else
                                Error(Text0010);
                        end else begin
                            if Rec.Status = Rec.Status::" " then
                                Error(Text006)
                            else
                                Error(Text005, Rec.Status);
                        end;
                        //Inserção dos alunos no respectivo calendário
                        if Rec.Status = Rec.Status::Transfer then begin
                            cTimetableCalendarMgt.ApagarAlunosFaltas(Rec."School Year", Rec."Study Plan Code",
                                                                     Rec.Class, 0D, 0D, 0D);
                        end;
                    end;
                }
            }
            group(Aluno)
            {
                Caption = 'Aluno';
                action(FichaAluno)
                {
                    ApplicationArea = All;
                    Caption = 'Stu&dent Card';
                    Image = User;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        l_RegistrationClass: Record "Registration Class";
                        l_Students: Record Students;
                        fStudents: Page "Student Card";
                    begin

                        l_Students.Reset;
                        l_Students.SetRange("No.", Rec."Student Code No.");

                        fStudents.SetTableView(l_Students);
                        fStudents.RunModal
                    end;
                }
                action(MatriculaAluno)
                {
                    ApplicationArea = All;
                    Caption = 'St&udent Registration';
                    Image = Document;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        l_RegistrationClass: Record "Registration Class";
                        fRegistration: Page Registration;
                    begin
                        CurrPage.GetRecord(l_RegistrationClass);

                        rRegistration.Reset;
                        rRegistration.SetRange("Student Code No.", l_RegistrationClass."Student Code No.");
                        rRegistration.SetRange("School Year", l_RegistrationClass."School Year");
                        rRegistration.SetRange("Responsibility Center", l_RegistrationClass."Responsibility Center");
                        if rRegistration.Find('-') then begin
                            fRegistration.SetTableView(rRegistration);
                            fRegistration.RunModal
                        end;
                    end;
                }
            }
        }
    }

    var
        Text005: Label 'The student registration is already %1 !';
        Text006: Label 'The only available option is to subscribe the student.';
        Text0030: Label 'You can not assign automatic numbering. Fill in the numbers manually.';
        rAnoLetivo: Record "School Year";
        Text0015: Label 'Não pode executar este processo para anos letivos já fechados.';
        rClass: Record Class;
        rRegistration: Record Registration;
        Text0010: Label 'The student belongs to another level of education / study plan, to access this feature, please use the functions of the student''s study plan.';

    //[Scope('OnPrem')]
    procedure Aspects()
    begin
        Rec.SubjectsAspects;
    end;

    local procedure ClassNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

