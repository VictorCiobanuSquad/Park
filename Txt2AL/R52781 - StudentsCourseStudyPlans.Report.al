report 52781 "Students Course/Study Plans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsCourseStudyPlans.rdlc';
    Caption = 'Students Course/Study Plans';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Course Header"; "Course Header")
        {
            DataItemTableView = SORTING(Code);
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Course_Header__School_Year_Begin_; "School Year Begin")
            {
            }
            column(Course_Header_Code; Code)
            {
            }
            column(vTotal; vTotal)
            {
            }
            column(Estudiants_cursCaption; Estudiants_cursCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Header__School_Year_Begin_Caption; FieldCaption("School Year Begin"))
            {
            }
            column(Course_Header_CodeCaption; FieldCaption(Code))
            {
            }
            column(Students_NameCaption; Students.FieldCaption(Name))
            {
            }
            column(Students__No__Caption; Students.FieldCaption("No."))
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(vTotalCaption; vTotalCaptionLbl)
            {
            }
            dataitem(Registration; Registration)
            {
                DataItemLink = Course = FIELD(Code);
                DataItemTableView = SORTING("Student Code No.", "School Year");
                column(Registration_Student_Code_No_; "Student Code No.")
                {
                }
                column(Registration_School_Year; "School Year")
                {
                }
                column(Registration_Responsibility_Center; "Responsibility Center")
                {
                }
                column(Registration_Course; Course)
                {
                }
                dataitem(Students; Students)
                {
                    DataItemLink = "No." = FIELD("Student Code No.");
                    DataItemTableView = SORTING("No.");
                    column(Students__No__; "No.")
                    {
                    }
                    column(Students_Name; Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        vTotal := vTotal + 1;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Registration.SetRange(Registration."School Year", varSchoolYear);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                Clear(vTotal);
            end;

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    if rRespCenter.Get(cUserEducation.GetEducationFilter(UserId)) then
                        nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                if ReportType = ReportType::"Study Plans" then begin
                    CurrReport.Break;
                end;

                SetFilter(Code, varCode);

                if varSchoolYear = '' then Error(Text0001);
            end;
        }
        dataitem("Study Plan Header"; "Study Plan Header")
        {
            DataItemTableView = SORTING(Code);
            column(FORMAT_TODAY_0_4__Control1102059020; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO_Control1102059017;CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo_Picture_Control1102059013; CompanyInfo.Picture)
            {
            }
            column(nomeEscola_Control1102059016; nomeEscola)
            {
            }
            column(Filtros_Control1102059011; Filtros)
            {
            }
            column(Study_Plan_Header__School_Year_; "School Year")
            {
            }
            column(Study_Plan_Header_Code; Code)
            {
            }
            column(vTotal_Control1102065004; vTotal)
            {
            }
            column(Alumnes_Pla_d_EstudisCaption; Alumnes_Pla_d_EstudisCaptionLbl)
            {
            }
            column(CurrReport_PAGENO_Control1102059017Caption; CurrReport_PAGENO_Control1102059017CaptionLbl)
            {
            }
            column(Study_Plan_Header__School_Year_Caption; FieldCaption("School Year"))
            {
            }
            column(Study_Plan_Students_NameCaption; "Study Plan Students".FieldCaption(Name))
            {
            }
            column(Study_Plan_Header_CodeCaption; FieldCaption(Code))
            {
            }
            column(Study_Plan_Students__No__Caption; "Study Plan Students".FieldCaption("No."))
            {
            }
            column(FiltresCaption_Control1102059022; FiltresCaption_Control1102059022Lbl)
            {
            }
            column(vTotal_Control1102065004Caption; vTotal_Control1102065004CaptionLbl)
            {
            }
            dataitem("Study Plan Registration"; Registration)
            {
                DataItemLink = "Study Plan Code" = FIELD(Code), "School Year" = FIELD("School Year");
                DataItemTableView = SORTING("Student Code No.", "School Year");
                column(Study_Plan_Registration_Student_Code_No_; "Student Code No.")
                {
                }
                column(Study_Plan_Registration_School_Year; "School Year")
                {
                }
                column(Study_Plan_Registration_Responsibility_Center; "Responsibility Center")
                {
                }
                column(Study_Plan_Registration_Study_Plan_Code; "Study Plan Code")
                {
                }
                dataitem("Study Plan Students"; Students)
                {
                    DataItemLink = "No." = FIELD("Student Code No.");
                    DataItemTableView = SORTING("No.");
                    column(Study_Plan_Students__No__; "No.")
                    {
                    }
                    column(Study_Plan_Students_Name; Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        vTotal := vTotal + 1;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Registration.SetRange(Registration."School Year", varSchoolYear);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                Clear(vTotal);
            end;

            trigger OnPreDataItem()
            begin
                if ReportType = ReportType::Courses then begin
                    CurrReport.Break;
                end;

                SetFilter(Code, varCode);

                if varSchoolYear = '' then Error(Text0001);

                "Study Plan Header".SetRange("Study Plan Header"."School Year", varSchoolYear);
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
                    field(ReportType; ReportType)
                    {
                        ApplicationArea = All;
                        CaptionClass = Text19071249;
                        OptionCaption = 'Course,Study Plans';
                        ShowCaption = false;
                    }
                    field(varCode; varCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if ReportType = ReportType::"Study Plans" then begin
                                rStudyPlans.Reset;
                                if rStudyPlans.Find('-') then begin
                                    if PAGE.RunModal(PAGE::"Study Plan List", rStudyPlans) = ACTION::LookupOK then
                                        varCode := rStudyPlans.Code;
                                end;
                            end else
                                if ReportType = ReportType::Courses then begin
                                    rCourses.Reset;
                                    if rCourses.Find('-') then begin
                                        if PAGE.RunModal(PAGE::"Course List", rCourses) = ACTION::LookupOK then
                                            varCode := rCourses.Code;
                                    end;
                                end;
                        end;
                    }
                    field(varSchoolYear; varSchoolYear)
                    {
                        ApplicationArea = All;
                        Caption = 'School Year';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if PAGE.RunModal(PAGE::"School Year", rSchoolYear) = ACTION::LookupOK then begin
                                varSchoolYear := rSchoolYear."School Year";
                            end;
                        end;
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := varCode;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rStudyPlans: Record "Study Plan Header";
        rCourses: Record "Course Header";
        rSchoolYear: Record "School Year";
        cUserEducation: Codeunit "User Education";
        varCode: Code[20];
        ReportType: Option Courses,"Study Plans";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        varSchoolYear: Code[10];
        Text0001: Label 'You must fill School Year.';
        vTotal: Integer;
        Text19071249: Label 'Report Type';
        Estudiants_cursCaptionLbl: Label 'Students Course';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        vTotalCaptionLbl: Label 'Total';
        Alumnes_Pla_d_EstudisCaptionLbl: Label 'Students Study Plan';
        CurrReport_PAGENO_Control1102059017CaptionLbl: Label 'Page';
        FiltresCaption_Control1102059022Lbl: Label 'Filters';
        vTotal_Control1102065004CaptionLbl: Label 'Total';
}

