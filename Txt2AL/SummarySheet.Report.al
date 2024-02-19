report 31009796 "Summary Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SummarySheet.rdlc';
    Caption = 'Summary Sheet';

    dataset
    {
        dataitem(Class; Class)
        {
            RequestFilterFields = Class, "School Year";
            column(Filtros; Filtros)
            {
            }
            column(rCompanyInfo_Picture; rCompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Schooling_Year_____________Class_Letter_; "Schooling Year" + ' - ' + "Class Letter")
            {
            }
            column(Class__School_Year_; "School Year")
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Full_de_ResumCaption; Full_de_ResumCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Class__School_Year_Caption; FieldCaption("School Year"))
            {
            }
            column(ClasseCaption; ClasseCaptionLbl)
            {
            }
            column(Class_Class; Class)
            {
            }
            dataitem(Timetable; Timetable)
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year");
                DataItemTableView = SORTING("Timetable Code");
                column(Timetable_Timetable_Code; "Timetable Code")
                {
                }
                column(Timetable_Class; Class)
                {
                }
                column(Timetable_School_Year; "School Year")
                {
                }
                dataitem(Calendar; Calendar)
                {
                    DataItemLink = "Timetable Code" = FIELD("Timetable Code"), "School Year" = FIELD("School Year"), Class = FIELD(Class);
                    DataItemTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, "Line No.") WHERE("Type Subject" = CONST(Subject));
                    column(Calendar_Subject; Subject)
                    {
                    }
                    column(Calendar__Start_Hour_; "Start Hour")
                    {
                    }
                    column(vSummary; vSummary)
                    {
                    }
                    column(vFaltas; vFaltas)
                    {
                    }
                    column(Calendar__Filter_Period_; "Filter Period")
                    {
                    }
                    column(Data_i_HoraCaption; Data_i_HoraCaptionLbl)
                    {
                    }
                    column(ResumCaption; ResumCaptionLbl)
                    {
                    }
                    column(Nombre_d_alumnes_absentsCaption; Nombre_d_alumnes_absentsCaptionLbl)
                    {
                    }
                    column(Signatura_del_professorCaption; Signatura_del_professorCaptionLbl)
                    {
                    }
                    column(Calendar_Timetable_Code; "Timetable Code")
                    {
                    }
                    column(Calendar_School_Year; "School Year")
                    {
                    }
                    column(Calendar_Study_Plan; "Study Plan")
                    {
                    }
                    column(Calendar_Class; Class)
                    {
                    }
                    column(Calendar_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        //Sumario
                        //---------------------
                        Clear(vSummary);
                        rRemarks.Reset;
                        rRemarks.SetRange(rRemarks."Type Remark", rRemarks."Type Remark"::Summary);
                        rRemarks.SetRange(rRemarks."Timetable Code", Calendar."Timetable Code");
                        rRemarks.SetRange(rRemarks."Calendar Line", Calendar."Line No.");
                        rRemarks.SetRange(rRemarks.Subject, Calendar.Subject);
                        if rRemarks.Find('-') then
                            repeat
                                vSummary := vSummary + ' ' + rRemarks.Textline
                            until rRemarks.Next = 0;


                        //Sumario
                        //---------------------
                        Clear(vFaltas);
                        Clear(vIncidenceCode);
                        rAbsence.Reset;
                        rAbsence.SetRange(rAbsence."Timetable Code", Calendar."Timetable Code");
                        rAbsence.SetRange(rAbsence."Line No. Timetable", Calendar."Line No.");
                        rAbsence.SetRange(rAbsence.Subject, Calendar.Subject);
                        rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
                        rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Student);
                        rAbsence.SetRange(rAbsence.Day, Calendar."Filter Period");
                        if rAbsence.FindSet then
                            repeat
                                if vIncidenceCode <> rAbsence."Incidence Code" then begin
                                    if vFaltas = '' then
                                        vFaltas := rAbsence."Incidence Code" + ': ' + Format(rAbsence."Class No.")
                                    else
                                        vFaltas := vFaltas + StrSubstNo(Text0003, rAbsence."Incidence Code") + ': ' + Format(rAbsence."Class No.")

                                end else
                                    vFaltas := vFaltas + ',' + Format(rAbsence."Class No.");
                                vIncidenceCode := rAbsence."Incidence Code"
                            until rAbsence.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Calendar.SetRange(Calendar."Filter Period", vDataIni, vDataFim);
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                if vDataIni = 0D then Error(Text0001);
                if vDataFim = 0D then Error(Text0002);

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
                    field(vDataIni; vDataIni)
                    {
                        Caption = 'Inicial Date';
                    }
                    field(vDataFim; vDataFim)
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
            vDataIni := WorkDate;
            vDataFim := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        rCompanyInfo.Get;
        rCompanyInfo.CalcFields(Picture);

        Filtros := Class.GetFilters;
    end;

    var
        rCompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rRemarks: Record Remarks;
        rAbsence: Record Absence;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[250];
        Filtros: Text[1024];
        Text0001: Label 'You must fill Inicial Date.';
        Text0002: Label 'You must fill Final Date.';
        vDataIni: Date;
        vDataFim: Date;
        vSummary: Text[1024];
        vFaltas: Text[1024];
        vIncidenceCode: Code[20];
        Text0003: Label ' \%1';
        FiltresCaptionLbl: Label 'Filters';
        Full_de_ResumCaptionLbl: Label 'Summary Sheet';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ClasseCaptionLbl: Label 'Class';
        Data_i_HoraCaptionLbl: Label 'Date and Time';
        ResumCaptionLbl: Label 'Summary';
        Nombre_d_alumnes_absentsCaptionLbl: Label 'Number of absent students';
        Signatura_del_professorCaptionLbl: Label 'Signature of teacher';
}

