report 52763 "Attendance Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AttendanceRegistration.rdlc';
    Caption = 'Attendance Registration';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Class; Class)
        {
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Schooling_Year_____________Class_Letter_; Class)
            {
            }
            column(Class__School_Year_; "School Year")
            {
            }
            column(Class__Class_Director_Name_; NomeProf)
            {
            }
            column(Full_de_puntCaption; Full_de_puntCaptionLbl)
            {
            }
            column(ClassCaption; ClassCaptionLbl)
            {
            }
            column(School_YearCaption; School_YearCaptionLbl)
            {
            }
            column(Class__Class_Director_Name_Caption; FieldCaption("Class Director Name"))
            {
            }
            column(Class_Class; Class)
            {
            }
            dataitem("Registration Class"; "Registration Class")
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year");
                DataItemTableView = SORTING("Class No.");
                column(print1; print1)
                {
                }
                column(AlunosVar1_Picture; AlunosVar1.Picture)
                {
                }
                column(print2; print2)
                {
                }
                column(AlunosVar2_Picture; AlunosVar2.Picture)
                {
                }
                column(print3; print3)
                {
                }
                column(AlunosVar3_Picture; AlunosVar3.Picture)
                {
                }
                column(print4; print4)
                {
                }
                column(AlunosVar4_Picture; AlunosVar4.Picture)
                {
                }
                column(print5; print5)
                {
                }
                column(AlunosVar5_Picture; AlunosVar5.Picture)
                {
                }
                column(print6; print6)
                {
                }
                column(AlunosVar6_Picture; AlunosVar6.Picture)
                {
                }
                column(Registration_Class_Class; Class)
                {
                }
                column(Registration_Class_School_Year; "School Year")
                {
                }
                column(Registration_Class_Schooling_Year; "Schooling Year")
                {
                }
                column(Registration_Class_Study_Plan_Code; "Study Plan Code")
                {
                }
                column(Registration_Class_Student_Code_No_; "Student Code No.")
                {
                }
                column(Registration_Class_Type; Type)
                {
                }
                column(Registration_Class_Line_No_; "Line No.")
                {
                }
                column(Registration_Class_No; "Class No.")
                {
                }
                column(ResponsableTeacherLbl; ResponsableTeacherLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                        CurrReport.Skip;


                    Clear(AlunosVar1);
                    Clear(AlunosVar2);
                    Clear(AlunosVar3);
                    Clear(AlunosVar4);
                    Clear(AlunosVar5);
                    Clear(AlunosVar6);

                    Clear(print1);
                    Clear(print2);
                    Clear(print3);
                    Clear(print4);
                    Clear(print5);
                    Clear(print6);

                    if AlunosVar1.Get("Student Code No.") then begin
                        AlunosVar1.CalcFields(Picture);
                        if AlunosVar1."No." <> '' then begin
                            print1 := Format("Class No.") + ' ' + AlunosVar1.Name + ' ' + AlunosVar1."Last Name";
                        end;
                    end;

                    if "Registration Class".Next <> 0 then begin
                        if "Student Code No." <> '' then begin
                            print2 := Format("Class No.") + ' ' + Name + ' ' + "Last Name";
                        end;
                        if AlunosVar2.Get("Student Code No.") then begin
                            AlunosVar2.CalcFields(Picture);
                        end;
                    end;

                    if "Registration Class".Next <> 0 then begin
                        if "Student Code No." <> '' then begin
                            print3 := Format("Class No.") + ' ' + Name + ' ' + "Last Name";
                        end;
                        if AlunosVar3.Get("Student Code No.") then begin
                            AlunosVar3.CalcFields(Picture);
                        end;
                    end;

                    if "Registration Class".Next <> 0 then begin
                        if "Student Code No." <> '' then begin
                            print4 := Format("Class No.") + ' ' + Name + ' ' + "Last Name";
                        end;
                        if AlunosVar4.Get("Student Code No.") then begin
                            AlunosVar4.CalcFields(Picture);
                        end;
                    end;

                    if "Registration Class".Next <> 0 then begin
                        if "Student Code No." <> '' then begin
                            print5 := Format("Class No.") + ' ' + Name + ' ' + "Last Name";
                        end;
                        if AlunosVar5.Get("Student Code No.") then begin
                            AlunosVar5.CalcFields(Picture);
                        end;
                    end;

                    if "Registration Class".Next <> 0 then begin
                        if "Student Code No." <> '' then begin
                            print6 := Format("Class No.") + ' ' + Name + ' ' + "Last Name";
                        end;
                        if AlunosVar6.Get("Student Code No.") then begin
                            AlunosVar6.CalcFields(Picture);
                        end;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                SetFilter(Class, reqClass);
                SetFilter("School Year", reqSchoolYear);
                SetFilter("Schooling Year", reqSchoolingYear);

                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Attendance Registration")
                {
                    Caption = 'Attendance Registration';
                    field(reqClass; reqClass)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Class';
                        TableRelation = Class;
                    }
                    field(reqSchoolYear; reqSchoolYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'School Year';
                        TableRelation = "School Year"."School Year";
                    }
                    field(reqSchoolingYear; reqSchoolingYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Schooling Year';
                        TableRelation = "Structure Education Country"."Schooling Year";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then;
        CompanyInfo.CalcFields(Picture);

        Filtros := "Registration Class".GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rClass: Record Class;
        cUserEducation: Codeunit "User Education";
        AlunosVar1: Record Students;
        AlunosVar2: Record Students;
        AlunosVar3: Record Students;
        AlunosVar4: Record Students;
        AlunosVar5: Record Students;
        AlunosVar6: Record Students;
        print1: Text[100];
        print2: Text[100];
        print3: Text[100];
        print4: Text[100];
        print5: Text[100];
        print6: Text[100];
        nomeEscola: Text[128];
        Filtros: Text[128];
        vClass: Text[50];
        Full_de_puntCaptionLbl: Label 'Attendance Registration';
        ClassCaptionLbl: Label 'Class';
        School_YearCaptionLbl: Label 'School Year';
        reqClass: Code[20];
        reqSchoolYear: Code[9];
        reqSchoolingYear: Code[10];
        ResponsableTeacherLbl: Label 'Responsable Teacher';
        rTeacher: Record Teacher;
        NomeProf: Text[100];
        Text001: Label 'Class Transferred';
        Text002: Label 'School Transferred';
}

