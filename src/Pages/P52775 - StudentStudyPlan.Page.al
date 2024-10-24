#pragma implicitwith disable
page 52775 "Student Study Plan"
{
    AutoSplitKey = true;
    Caption = 'Student Study Plan';
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Registration Subjects";
    SourceTableView = SORTING("Student Code No.", Enroled, "Formation Component")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Enroled; Rec.Enroled)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        EnroledOnAfterValidate;
                    end;
                }
                field("No. Students"; Rec."No. Students")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Subjects Code"; Rec."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mandatory/Optional Type"; Rec."Mandatory/Optional Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = "Mandatory/Optional TypeVisible";
                }
                field("Curriculum Type"; Rec."Curriculum Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Option Group"; Rec."Option Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = "Option GroupVisible";
                }
                field("Formation Component"; Rec."Formation Component")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = "Formation ComponentVisible";
                }
                field("Evaluation Type"; Rec."Evaluation Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = "Schooling YearVisible";
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-subject"; Rec."Sub-subject")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject';
                    Editable = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = TurnEditable;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Sub-subject");
                        if (Rec."Sub-subject") and (Rec."Sub-subjects for assess. only" = false) then
                            Error(Text001);
                        TurnOnAfterValidate;
                    end;
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Attendance Situation"; Rec."Attendance Situation")
                {
                }
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
                action(Inscrever)
                {
                    ApplicationArea = All;
                    Caption = 'Su&bscribe';
                    Image = CreateDocument;

                    trigger OnAction()
                    var
                        recRegistration: Record Registration;
                    begin
                        recRegistration.Reset;
                        recRegistration.SetRange("Student Code No.", Rec."Student Code No.");
                        recRegistration.SetRange("School Year", Rec."School Year");
                        recRegistration.SetRange("Schooling Year", Rec."Schooling Year");
                        if recRegistration.FindFirst then;
                        if recRegistration.Status <> Rec.Status::" " then begin
                            CurrPage.GetRecord(rRegistrationSubjects);
                            if rRegistrationSubjects.Status <> rRegistrationSubjects.Status::Cancelled then begin
                                if (Rec.Class = rRegistrationSubjects.Class) and (Rec.Status = Rec.Status::Cancelled) then
                                    Error(Text0006);

                                rStctuEducationCountry.Reset;
                                rStctuEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                rStctuEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStctuEducationCountry.FindSet(false, false) then begin
                                    if rStctuEducationCountry."Edu. Level" = 0 then begin
                                        rRegistrationSubjects.Reset;

                                        fRegisterStudent.GetStudentSubjects(rRegistrationSubjects);
                                        fRegisterStudent.RunModal;

                                    end else begin
                                        if rRegistrationSubjects.Status <> rRegistrationSubjects.Status::Subscribed then begin
                                            rRegistrationSubjects.Reset;
                                            Clear(fRegisterStudent);
                                            fRegisterStudent.GetStudentSubjects(rRegistrationSubjects);
                                            fRegisterStudent.RunModal;
                                        end else
                                            Error(Text0007)
                                    end;
                                end;
                            end else
                                Error(Text0006);
                        end else
                            Error(Text0008);
                    end;
                }
                action(Anular)
                {
                    ApplicationArea = All;
                    Caption = '&Annul';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        Text001: Label 'Selected Subject can not be Cancel.';
                        Text002: Label 'Option available for the secondary.';
                        Text003: Label 'The student %1 is not registered in the Subject.';
                    begin
                        if Rec.Status <> Rec.Status::" " then begin
                            CurrPage.GetRecord(rRegistrationSubjects);
                            if (Rec.Class = rRegistrationSubjects.Class) and (Rec.Status = Rec.Status::Cancelled) then
                                Error(Text0006);
                        end;
                        rStctuEducationCountry.Reset;
                        rStctuEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        rStctuEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
                        if rStctuEducationCountry.FindSet(false, false) then begin
                            if rStctuEducationCountry."Edu. Level" = 0 then begin
                                rRegistrationSubjects.Reset;
                                CurrPage.GetRecord(rRegistrationSubjects);
                                if (rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed) then begin
                                    Clear(fCancelSubjectsWizard);
                                    fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 3);
                                    fCancelSubjectsWizard.RunModal;
                                end else
                                    Error(Text003, Rec."Student Code No.");
                            end else begin

                                rRegistrationSubjects.Reset;
                                CurrPage.GetRecord(rRegistrationSubjects);
                                if (rRegistrationSubjects.Class <> '') then begin
                                    if (rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed) then begin
                                        Clear(fCancelSubjectsWizard);
                                        fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 3);
                                        fCancelSubjectsWizard.RunModal;
                                    end else
                                        Error(Text003, Rec."Student Code No.");
                                end;
                            end;
                        end;
                    end;
                }
                action(Corrigir)
                {
                    ApplicationArea = All;
                    Caption = '&Correct';
                    Image = DocumentEdit;

                    trigger OnAction()
                    var
                        Text001: Label 'Selected Subject can not be Cancel.';
                        Text002: Label 'Option available for the secondary.';
                        Text003: Label 'The student %1 is not registered in the Subject.';
                    begin
                        rStctuEducationCountry.Reset;
                        rStctuEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        rStctuEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
                        if rStctuEducationCountry.FindSet(false, false) then begin
                            if rStctuEducationCountry."Edu. Level" = 0 then begin
                                rRegistrationSubjects.Reset;

                                if (rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed) then begin
                                    Clear(fCancelSubjectsWizard);
                                    fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 0);
                                    fCancelSubjectsWizard.RunModal;
                                end else
                                    Error(Text003, Rec."Student Code No.");
                            end else begin

                                rRegistrationSubjects.Reset;
                                CurrPage.GetRecord(rRegistrationSubjects);
                                if (rRegistrationSubjects.Class <> '') then begin
                                    if (rRegistrationSubjects.Status <> rRegistrationSubjects.Status::" ") then begin
                                        Clear(fCancelSubjectsWizard);
                                        fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 0);
                                        fCancelSubjectsWizard.RunModal;
                                    end else
                                        Error(Text003, Rec."Student Code No.");
                                end;
                            end;
                        end;
                    end;
                }
                action(Transferir)
                {
                    ApplicationArea = All;
                    Caption = '&Transfer';
                    Image = TransferOrder;

                    trigger OnAction()
                    var
                        Text001: Label 'Selected Subject can not be Cancel.';
                        Text002: Label 'Option available for the secondary.';
                        Text003: Label 'The student %1 is not registered in the Subject.';
                    begin
                        if Rec.Status <> Rec.Status::" " then begin
                            CurrPage.GetRecord(rRegistrationSubjects);
                            if (Rec.Class = rRegistrationSubjects.Class) and (Rec.Status = Rec.Status::Cancelled) then
                                Error(Text0006);
                        end;

                        rStctuEducationCountry.Reset;
                        rStctuEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        rStctuEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
                        if rStctuEducationCountry.FindSet(false, false) then begin
                            if rStctuEducationCountry."Edu. Level" = 0 then begin
                                rRegistrationSubjects.Reset;
                                CurrPage.GetRecord(rRegistrationSubjects);
                                if (rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed) then begin
                                    Clear(fCancelSubjectsWizard);
                                    fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 2);
                                    fCancelSubjectsWizard.RunModal;
                                end else
                                    Error(Text003, Rec."Student Code No.");
                            end else begin

                                rRegistrationSubjects.Reset;
                                CurrPage.GetRecord(rRegistrationSubjects);
                                if (rRegistrationSubjects.Class <> '') then begin
                                    if (rRegistrationSubjects.Status = rRegistrationSubjects.Status::Subscribed) then begin
                                        Clear(fCancelSubjectsWizard);
                                        fCancelSubjectsWizard.GetStudentSubjects(rRegistrationSubjects, 2);
                                        fCancelSubjectsWizard.RunModal;
                                    end else
                                        Error(Text003, Rec."Student Code No.");
                                end;
                            end;
                        end;
                    end;
                }
                action(SubDisciplinas)
                {
                    ApplicationArea = All;
                    Caption = 'S&ub-Subjects';
                    Image = Documents;

                    trigger OnAction()
                    var
                        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                        fStudentSubSubjectsPlan: Page "Student Sub-Subjects Plan";
                    begin

                        rRegistrationSubjects.Reset;
                        CurrPage.GetRecord(rRegistrationSubjects);

                        if (Rec.Class = rRegistrationSubjects.Class) and (Rec.Status = Rec.Status::Cancelled) then
                            Error(Text0006);


                        rRegistrationSubjects.CalcFields("Sub-subject");
                        if rRegistrationSubjects."Sub-subject" and rRegistrationSubjects.Enroled then begin

                            rStudentSubSubjectsPlan.Reset;
                            rStudentSubSubjectsPlan.SetRange("Student Code No.", Rec."Student Code No.");
                            rStudentSubSubjectsPlan.SetRange("School Year", Rec."School Year");
                            rStudentSubSubjectsPlan.SetRange("Schooling Year", rRegistrationSubjects."Schooling Year");
                            rStudentSubSubjectsPlan.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then
                                rStudentSubSubjectsPlan.SetRange("Line No.", rRegistrationSubjects."Line No.");
                            if rStudentSubSubjectsPlan.Find('-') then begin
                                rStudentSubSubjectsPlan.FilterGroup(2);
                                Clear(fStudentSubSubjectsPlan);
                                fStudentSubSubjectsPlan.SetTableView(rStudentSubSubjectsPlan);
                                fStudentSubSubjectsPlan.RunModal;
                            end;
                        end else
                            Error(Text0005);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Sub-subject");
        if (Rec."Sub-subject") and (Rec."Sub-subjects for assess. only" = false) then
            TurnEditable := false
        else
            TurnEditable := true;
    end;

    trigger OnInit()
    begin
        "Schooling YearVisible" := true;
        "Formation ComponentVisible" := true;
        "Mandatory/Optional TypeVisible" := true;
        TurnEditable := true;
    end;

    trigger OnOpenPage()
    begin
        FieldsVisible;
    end;

    var
        rRegistrationSubjects: Record "Registration Subjects";
        Text0006: Label 'The student registration is Annuled. You cannot access these options.';
        Text001: Label 'The Subject has Sub-Subjects. Please choose the turn in the Sub-Subjects Form.';
        [InDataSet]
        TurnEditable: Boolean;
        [InDataSet]
        "Option GroupVisible": Boolean;
        [InDataSet]
        "Mandatory/Optional TypeVisible": Boolean;
        [InDataSet]
        "Formation ComponentVisible": Boolean;
        [InDataSet]
        "Schooling YearVisible": Boolean;
        rStctuEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        fRegisterStudent: Page "Register Student";
        Text0007: Label 'The Student is already subscribed in a Class.';
        Text0008: Label 'You can only subscribe  if the Student is enroled in a class.';
        Text0009: Label 'The student must be registered in a class.';
        fCancelSubjectsWizard: Page "Cancel Subjects Wizard";
        Text0001: Label 'Student is enroled in a class with the subject %1.';
        fEnrollPreviousYears: Page "Select Previous Years";
        MasterCourse: Code[20];
        Text0005: Label 'You can only open the Sub Subjects if the Student is enroled on a Subject having Sub Subjects.';


    procedure FieldsVisible()
    var
        rRegistrationSubjects: Record "Registration Subjects";
    begin
        if Rec.Find('-') then begin
            if Rec.Type = Rec.Type::Simple then begin
                "Option GroupVisible" := false;
                "Mandatory/Optional TypeVisible" := true;
                "Formation ComponentVisible" := false;
                "Schooling YearVisible" := false;
            end else begin
                "Option GroupVisible" := true;
                "Mandatory/Optional TypeVisible" := true;
                "Formation ComponentVisible" := true;
                "Schooling YearVisible" := true;
            end;
        end else begin
            "Option GroupVisible" := false;
            "Mandatory/Optional TypeVisible" := false;
            "Schooling YearVisible" := false;
            "Formation ComponentVisible" := false;
        end;

        Rec.CalcFields("Sub-subject");
        if Rec."Sub-subject" then
            TurnEditable := false
        else
            TurnEditable := true;
    end;

    local procedure EnroledOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure TurnOnAfterValidate()
    begin
        CurrPage.Update;
    end;


    procedure SetCourse(Course: Code[20])
    begin
        MasterCourse := Course;
    end;
}

#pragma implicitwith restore

