report 31009850 "Teachers Absence"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TeachersAbsence.rdlc';
    Caption = 'Teachers Absence';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Teacher; Teacher)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
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
            column(Teacher_Name; Name)
            {
            }
            column(Teacher__No__; "No.")
            {
            }
            column(Teachers_AbsenceCaption; Teachers_AbsenceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(Absence__Absence_Type_Caption; Absence.FieldCaption("Absence Type"))
            {
            }
            column(Absence__Absence_Status_Caption; Absence.FieldCaption("Absence Status"))
            {
            }
            column(Absence__Results_in_loss_of_pay_Caption; Absence__Results_in_loss_of_pay_CaptionLbl)
            {
            }
            column(Absence_DayCaption; Absence.FieldCaption(Day))
            {
            }
            column(Absence_ClassCaption; Absence.FieldCaption(Class))
            {
            }
            column(Absence_SubjectCaption; Absence_SubjectCaptionLbl)
            {
            }
            column(Absence__Incidence_Description_Caption; Absence.FieldCaption("Incidence Description"))
            {
            }
            column(Absence__Justified_Description_Caption; Absence.FieldCaption("Justified Description"))
            {
            }
            dataitem(Absence; Absence)
            {
                DataItemLink = "Student/Teacher Code No." = FIELD("No.");
                DataItemTableView = SORTING("School Year", "Student/Teacher Code No.", "Absence Type", Day) WHERE("Incidence Type" = CONST(Absence), Category = CONST(Teacher));
                column(Absence_Day; Day)
                {
                }
                column(Absence__Absence_Status_; "Absence Status")
                {
                }
                column(Absence_Class; Class)
                {
                }
                column(Absence_Subject; Subject)
                {
                }
                column(Absence__Absence_Type_; "Absence Type")
                {
                }
                column(Absence__Results_in_loss_of_pay_; "Results in loss of pay")
                {
                }
                column(Absence__Incidence_Description_; "Incidence Description")
                {
                }
                column(Absence__Justified_Description_; "Justified Description")
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

                trigger OnPreDataItem()
                begin
                    Absence.SetRange(Absence.Day, vIniDate, vFinalDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                if vFinalDate = 0D then Error(Text0002);

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
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            vIniDate := CalcDate('<CM-1M+1D>', WorkDate);
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

        Filtros := Teacher.GetFilters + ' ' + Absence.GetFilters;
    end;

    var
        rCompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        vIniDate: Date;
        vFinalDate: Date;
        Text0001: Label 'You must fill %1.';
        Text0002: Label 'You must fill Final Date.';
        Teachers_AbsenceCaptionLbl: Label 'Teachers Absence';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        Absence__Results_in_loss_of_pay_CaptionLbl: Label 'Loss of pay';
        Absence_SubjectCaptionLbl: Label 'Subject / Non scholar comp.';
}

