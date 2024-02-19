report 31009812 "Students Absence"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsAbsence.rdlc';
    Caption = 'Students Absence';

    dataset
    {
        dataitem(Registration; Registration)
        {
            DataItemTableView = SORTING(Class, "Class No.");
            RequestFilterFields = "School Year", Class, "Student Code No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(RegistrationLevel; Format(Level, 0, 9))
            {
            }
            column(vShowDetail; vShowDetail)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(rCompanyInfo_Picture; rCompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Schooling_Year____________Registration__Class_Letter_; "Schooling Year" + ' - ' + Registration."Class Letter")
            {
            }
            column(StudentName; StudentName)
            {
            }
            column(Registration__Class_No__; "Class No.")
            {
            }
            column(Registration__Student_Code_No__; "Student Code No.")
            {
            }
            column(vStudentTotalAbsence; vStudentTotalAbsence)
            {
            }
            column(vStudentUnjustifiedAbsence; vStudentUnjustifiedAbsence)
            {
            }
            column(vMaxTotalAbsence; vMaxTotalAbsence)
            {
            }
            column(vMaxUnjustifiedAbsence; vMaxUnjustifiedAbsence)
            {
            }
            column(Registration__Student_Code_No___Control1102065000; "Student Code No.")
            {
            }
            column(StudentName_Control1102065005; StudentName)
            {
            }
            column(Registration__Class_No___Control1102065009; "Class No.")
            {
            }
            column(Students_AbsenceCaption; Students_AbsenceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(ClassCaption; ClassCaptionLbl)
            {
            }
            column(Limite_FaltasCaption; Limite_FaltasCaptionLbl)
            {
            }
            column(Faltas_DadasCaption; Faltas_DadasCaptionLbl)
            {
            }
            column(UnjustifiedCaption; UnjustifiedCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(UnjustifiedCaption_Control1102065030; UnjustifiedCaption_Control1102065030Lbl)
            {
            }
            column(TotalCaption_Control1102065031; TotalCaption_Control1102065031Lbl)
            {
            }
            column(Registration_Subjects_DescriptionCaption; "Registration Subjects".FieldCaption(Description))
            {
            }
            column(UnjustifiedCaption_Control1102065012; UnjustifiedCaption_Control1102065012Lbl)
            {
            }
            column(TotalCaption_Control1102065015; TotalCaption_Control1102065015Lbl)
            {
            }
            column(UnjustifiedCaption_Control1102065016; UnjustifiedCaption_Control1102065016Lbl)
            {
            }
            column(TotalCaption_Control1102065018; TotalCaption_Control1102065018Lbl)
            {
            }
            column(Limite_FaltasCaption_Control1102065019; Limite_FaltasCaption_Control1102065019Lbl)
            {
            }
            column(Faltas_DadasCaption_Control1102065020; Faltas_DadasCaption_Control1102065020Lbl)
            {
            }
            column(Registration_School_Year; "School Year")
            {
            }
            column(Registration_Responsibility_Center; "Responsibility Center")
            {
            }
            column(Registration_Class; Class)
            {
            }
            column(Registration_Schooling_Year; "Schooling Year")
            {
            }
            dataitem("Registration Subjects"; "Registration Subjects")
            {
                DataItemLink = "Student Code No." = FIELD("Student Code No."), "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("Student Code No.", "School Year", "Sorting ID") WHERE(Enroled = CONST(true));
                column(Registration_Subjects_Description; Description)
                {
                }
                column(vMaxUnjustifiedAbsence_Control1102065011; vMaxUnjustifiedAbsence)
                {
                }
                column(vMaxTotalAbsence_Control1102065014; vMaxTotalAbsence)
                {
                }
                column(vStudentUnjustifiedAbsence_Control1102065013; vStudentUnjustifiedAbsence)
                {
                }
                column(vStudentTotalAbsence_Control1102065017; vStudentTotalAbsence)
                {
                }
                column(Registration_Subjects_Student_Code_No_; "Student Code No.")
                {
                }
                column(Registration_Subjects_School_Year; "School Year")
                {
                }
                column(Registration_Subjects_Line_No_; "Line No.")
                {
                }
                column(Registration_Subjects_Schooling_Year; "Schooling Year")
                {
                }
                column(Registration_Subjects_Study_Plan_Code; "Study Plan Code")
                {
                }
                column(Registration_Subjects_Class; Class)
                {
                }
                column(Registration_Subjects_Subjects_Code; "Subjects Code")
                {
                }
                column(Absence_DayCaption; Absence.FieldCaption(Day))
                {
                }
                column(Absence__Incidence_Description_Caption; Absence.FieldCaption("Incidence Description"))
                {
                }
                column(Absence__Absence_Status_Caption; Absence.FieldCaption("Absence Status"))
                {
                }
                dataitem(Absence; Absence)
                {
                    DataItemLink = "School Year" = FIELD("School Year"), "Study Plan" = FIELD("Study Plan Code"), Class = FIELD(Class), Subject = FIELD("Subjects Code"), "Student/Teacher Code No." = FIELD("Student Code No.");
                    DataItemTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, "Absence Type", "Student/Teacher Code No.") WHERE("Incidence Type" = CONST(Absence), Category = CONST(Class));
                    column(Absence_Day; Day)
                    {
                    }
                    column(Absence__Incidence_Description_; "Incidence Description")
                    {
                    }
                    column(Absence__Absence_Status_; "Absence Status")
                    {
                    }
                    column(Absence_Timetable_Code; "Timetable Code")
                    {
                    }
                    column(Absence_School_Year; "School Year")
                    {
                    }
                    column(Absence_Study_Plan; "Study Plan")
                    {
                    }
                    column(Absence_Class; Class)
                    {
                    }
                    column(Absence_Type; Type)
                    {
                    }
                    column(Absence_Line_No__Timetable; "Line No. Timetable")
                    {
                    }
                    column(Absence_Incidence_Type; "Incidence Type")
                    {
                    }
                    column(Absence_Incidence_Code; "Incidence Code")
                    {
                    }
                    column(Absence_Category; Category)
                    {
                    }
                    column(Absence_Subcategory_Code; "Subcategory Code")
                    {
                    }
                    column(Absence_Student_Teacher; "Student/Teacher")
                    {
                    }
                    column(Absence_Student_Teacher_Code_No_; "Student/Teacher Code No.")
                    {
                    }
                    column(Absence_Responsibility_Center; "Responsibility Center")
                    {
                    }
                    column(Absence_Line_No_; "Line No.")
                    {
                    }
                    column(Absence_Subject; Subject)
                    {
                    }

                    trigger OnPreDataItem()
                    begin

                        Absence.SetRange(Absence.Day, vIniDate, vFinalDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(vMaxUnjustifiedAbsence);
                    Clear(vMaxTotalAbsence);
                    Clear(vStudentTotalAbsence);
                    Clear(vStudentUnjustifiedAbsence);

                    if "Registration Subjects".Type = "Registration Subjects".Type::Simple then begin
                        rStudyPlanLines.Reset;
                        rStudyPlanLines.SetRange(rStudyPlanLines.Code, "Registration Subjects"."Study Plan Code");
                        rStudyPlanLines.SetRange(rStudyPlanLines."School Year", "Registration Subjects"."School Year");
                        rStudyPlanLines.SetRange(rStudyPlanLines."Schooling Year", "Registration Subjects"."Schooling Year");
                        rStudyPlanLines.SetRange(rStudyPlanLines."Subject Code", "Registration Subjects"."Subjects Code");
                        if rStudyPlanLines.FindFirst then begin
                            vMaxUnjustifiedAbsence := rStudyPlanLines."Maximum Unjustified Absences";
                            vMaxTotalAbsence := rStudyPlanLines."Maximum Total Absence";
                        end;
                    end;

                    if "Registration Subjects".Type = "Registration Subjects".Type::Multi then begin
                        rCourseLines.Reset;
                        rCourseLines.SetRange(rCourseLines.Code, "Registration Subjects"."Study Plan Code");
                        rCourseLines.SetRange(rCourseLines."Subject Code", "Registration Subjects"."Subjects Code");
                        if rCourseLines.FindFirst then begin
                            vMaxUnjustifiedAbsence := rCourseLines."Maximum Unjustified Absences";
                            vMaxTotalAbsence := rCourseLines."Maximum Total Absences";
                        end;
                    end;

                    vStudentTotalAbsence := cEvaluationsIncide.CalFaltasLegalReports(
                                            "Registration Subjects"."School Year",
                                            "Registration Subjects"."Schooling Year",
                                            "Registration Subjects".Class,
                                            "Registration Subjects"."Student Code No.",
                                            "Registration Subjects"."Subjects Code",
                                            vFinalDate,
                                            0,
                                            vIniDate);

                    vStudentUnjustifiedAbsence := cEvaluationsIncide.CalFaltasLegalReports(
                                                  "Registration Subjects"."School Year",
                                                  "Registration Subjects"."Schooling Year",
                                                  "Registration Subjects".Class,
                                                  "Registration Subjects"."Student Code No.",
                                                  "Registration Subjects"."Subjects Code",
                                                  vFinalDate,
                                                  1,
                                                  vIniDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin


                if rStudents.Get(Registration."Student Code No.") then
                    StudentName := rStudents.Name;


                Clear(vMaxUnjustifiedAbsence);
                Clear(vMaxTotalAbsence);

                if "Registration Subjects".Type = "Registration Subjects".Type::Simple then begin
                    rStudyPlanHeader.Reset;
                    rStudyPlanHeader.SetRange(rStudyPlanHeader.Code, Registration."Study Plan Code");
                    rStudyPlanHeader.SetRange(rStudyPlanHeader."School Year", Registration."School Year");
                    rStudyPlanHeader.SetRange(rStudyPlanHeader."Schooling Year", Registration."Schooling Year");
                    if rStudyPlanHeader.FindFirst then begin
                        vMaxUnjustifiedAbsence := rStudyPlanHeader."Maximum Unjustified Absence";
                        vMaxTotalAbsence := rStudyPlanHeader."Maximum Total Absence";
                    end;
                end;

                Clear(vStudentTotalAbsence);
                Clear(vStudentUnjustifiedAbsence);

                vStudentTotalAbsence := cEvaluationsIncide.CalFaltasLegalReports(Registration."School Year", Registration."Schooling Year",
                                        Registration.Class, rStudents."No.", '', vFinalDate, 0, vIniDate);
                vStudentUnjustifiedAbsence := cEvaluationsIncide.CalFaltasLegalReports(Registration."School Year",
                                              Registration."Schooling Year", Registration.Class, rStudents."No.", '', vFinalDate, 1, vIniDate);
            end;

            trigger OnPreDataItem()
            begin
                if vFinalDate = 0D then Error(Text0002);
                if Registration.GetFilter(Registration."School Year") = '' then
                    Error(Text0001, Registration.FieldCaption(Registration."School Year"));

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
                group(Options)
                {
                    Caption = 'Options';
                    field(vIniDate; vIniDate)
                    {
                        Caption = 'Inicial Date';
                    }
                    field(vFinalDate; vFinalDate)
                    {
                        Caption = 'Final Date';
                    }
                    field(vShowDetail; vShowDetail)
                    {
                        Caption = 'Show Detail';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            vFinalDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        rCompanyInfo.Get;
        rCompanyInfo.CalcFields(Picture);

        Filtros := Registration.GetFilters;
    end;

    var
        rCompanyInfo: Record "Company Information";
        rStudents: Record Students;
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cEvaluationsIncide: Codeunit "Evaluations-Incidences";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        StudentName: Text[191];
        vMaxUnjustifiedAbsence: Integer;
        vMaxTotalAbsence: Integer;
        vStudentUnjustifiedAbsence: Integer;
        vStudentTotalAbsence: Integer;
        vIniDate: Date;
        vFinalDate: Date;
        Text0001: Label 'You must fill %1.';
        vShowDetail: Boolean;
        Text0002: Label 'You must fill Final Date.';
        Students_AbsenceCaptionLbl: Label 'Students Absence';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        ClassCaptionLbl: Label 'Class';
        Limite_FaltasCaptionLbl: Label 'Limite Faltas';
        Faltas_DadasCaptionLbl: Label 'Faltas Dadas';
        UnjustifiedCaptionLbl: Label 'Unjustified';
        TotalCaptionLbl: Label 'Total';
        UnjustifiedCaption_Control1102065030Lbl: Label 'Unjustified';
        TotalCaption_Control1102065031Lbl: Label 'Total';
        UnjustifiedCaption_Control1102065012Lbl: Label 'Unjustified';
        TotalCaption_Control1102065015Lbl: Label 'Total';
        UnjustifiedCaption_Control1102065016Lbl: Label 'Unjustified';
        TotalCaption_Control1102065018Lbl: Label 'Total';
        Limite_FaltasCaption_Control1102065019Lbl: Label 'Limite Faltas';
        Faltas_DadasCaption_Control1102065020Lbl: Label 'Faltas Dadas';
}

