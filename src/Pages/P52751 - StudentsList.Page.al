#pragma implicitwith disable
page 52751 "Students List"
{
    //  //PT - tem o campo vClassAndNo
    // 
    // IT001 - Específicos CPA - MF - 2016-03-22
    //       - Campos adicionados:
    //        - EE_Name
    //        - EE_Address
    //        - EE_Phone
    //        - EE_Mobile
    //        - EE_Email
    //       - Campo "Ciclo" e "Turma" removido
    // 
    // CPA:
    //   // 2014.10.28 - CPA - novo pedido de desenvolvimento
    // 
    // SQUAD001 - JTP - 2021.07.05
    //   New Field
    //     Health User No.

    Caption = 'Students List';
    CardPageID = "Student Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Students;

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(vClassAndNo; vClassAndNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class and Class No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Nº Cliente';
                    ApplicationArea = All;
                }

                field("JDE Payer No."; Rec."JDE Payer No.")
                {
                    ApplicationArea = All;
                }
                field("JDE Pupil No."; Rec."JDE Pupil No.")
                {
                    ApplicationArea = All;
                }

                field("Date Validity"; Rec."Date Validity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Doc. Number Id"; Rec."Doc. Number Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Doc. Type Id"; Rec."Doc. Type Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("First Foreign Language"; Rec."First Foreign Language")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Second Foreign Language"; Rec."Second Foreign Language")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Special Needs"; Rec."Special Needs")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Sex; Rec.Sex)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NISS; Rec.NISS)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(NIB; Rec.NIB)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Referencia ADC"; Rec."Referencia ADC")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Débitos Directos"; Rec."Débitos Directos")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EAN Enviado"; Rec."EAN Enviado")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ID CRED"; Rec."ID CRED")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(DELETEALL)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Studentsass: Record Students;

                    rRegistration: Record Registration;
                    rRegistrationSubjectsServices: Record "Registration Subjects";
                    rStudentServicePlan: Record "Student Service Plan";
                    rRegistrationClass: Record "Registration Class";
                    rStudentLedgerEntry: Record "Student Ledger Entry";
                    rSchoolYear: Record "School Year";
                    rUsersFamiliyStudents: Record "Users Family / Students";
                    aapagar: boolean;
                begin
                    Studentsass.RESET;
                    if Studentsass.findset then begin
                        repeat
                            aapagar := true;
                            rRegistration.Reset;
                            rRegistration.SetRange("Student Code No.", Studentsass."No.");
                            rRegistration.SetFilter(Status, '<>%1', 0);
                            if rRegistration.FindFirst then
                                aapagar := false;


                            rStudentLedgerEntry.Reset;
                            rStudentLedgerEntry.SetRange("Student No.", Studentsass."No.");
                            if rStudentLedgerEntry.FindFirst then
                                aapagar := false;


                            if aapagar then begin
                                if Studentsass.Class = '' then begin
                                    Studentsass.CalcFields("Estado da Matricula");
                                    if Studentsass."Estado da Matricula" = Studentsass."Estado da Matricula"::" " then begin
                                        Studentsass.Delete(true);
                                    end;
                                end;
                            end;
                        until Studentsass.next = 0;
                    end
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Class, "Class No.");

        rClass.Reset;
        rClass.SetRange(rClass.Class, Rec.Class);
        rClass.SetRange(rClass."School Year", cStudentsRegistration.GetShoolYearActive);
        if rClass.FindFirst then
            //Normatica 2014.10.28 - CPA - novo pedido de desenvolvimento
            //vClassAndNo := rClass."Schooling Year" + ' - ' + rClass."Class Letter" + '   ' + Text006 + ' ' + FORMAT("Class No.")
            vClassAndNo := rClass.Class
        else
            vClassAndNo := ''
    end;

    trigger OnOpenPage()
    begin

        CurrPage.LookupMode(true);

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("School Year", cStudentsRegistration.GetShoolYearActive);
    end;

    var
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";
        rClass: Record Class;
        vClassAndNo: Text[30];
        Text006: Label 'No.';
}

#pragma implicitwith restore

