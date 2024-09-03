report 52782 "Class Course/Study Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ClassCourseStudyPlan.rdlc';
    Caption = 'Class Course/Study Plan';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Course Header"; "Course Header")
        {
            DataItemTableView = SORTING(Code);
            column(Filtros; Filtros)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
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
            column(Course_Header__School_Year_Begin_; "School Year Begin")
            {
            }
            column(Course_Header_Code; Code)
            {
            }
            column(Classes_CursCaption; Classes_CursCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Class_DescriptionCaption; Class.FieldCaption(Description))
            {
            }
            column(Class__Class_Director_Name_Caption; Class.FieldCaption("Class Director Name"))
            {
            }
            column(Course_Header__School_Year_Begin_Caption; FieldCaption("School Year Begin"))
            {
            }
            column(Class_ClassCaption; Class.FieldCaption(Class))
            {
            }
            column(Course_Header_CodeCaption; FieldCaption(Code))
            {
            }
            dataitem(Class; Class)
            {
                DataItemLink = "Study Plan Code" = FIELD(Code);
                DataItemTableView = SORTING(Class, "School Year") WHERE(Type = CONST(Multi));
                column(Class_Class; Class)
                {
                }
                column(Class_Description; Description)
                {
                }
                column(Schooling_Year_____________Class_Letter_; "Schooling Year" + ' - ' + "Class Letter")
                {
                }
                column(Class__Class_Director_Name_; "Class Director Name")
                {
                }
                column(Class_School_Year; "School Year")
                {
                }
                column(Class_Study_Plan_Code; "Study Plan Code")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;
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
            end;
        }
        dataitem("Structure Education Country"; "Structure Education Country")
        {
            DataItemTableView = SORTING("Sorting ID");
            column(Filtros_Control1102059010; Filtros)
            {
            }
            column(CompanyInfo_Picture_Control1102059011; CompanyInfo.Picture)
            {
            }
            column(nomeEscola_Control1102059012; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO_Control1102059016;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4__Control1102059022; Format(Today, 0, 4))
            {
            }
            column(FiltresCaption_Control1102059020; FiltresCaption_Control1102059020Lbl)
            {
            }
            column(Classe_Pla_d_EstudisCaption; Classe_Pla_d_EstudisCaptionLbl)
            {
            }
            column(CurrReport_PAGENO_Control1102059016Caption; CurrReport_PAGENO_Control1102059016CaptionLbl)
            {
            }
            column(Structure_Education_Country_Country; Country)
            {
            }
            column(Structure_Education_Country_Level; Level)
            {
            }
            column(Structure_Education_Country_Schooling_Year; "Schooling Year")
            {
            }
            column(SortingID_SEC; "Sorting ID")
            {
            }
            dataitem("Study Plan Header"; "Study Plan Header")
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING(Code);
                PrintOnlyIfDetail = true;
                column(Study_Plan_Header__School_Year_; "School Year")
                {
                }
                column(Study_Plan_Header_Code; Code)
                {
                }
                column(Study_Plan_Header__School_Year_Caption; FieldCaption("School Year"))
                {
                }
                column(Study_Plan_Header_CodeCaption; FieldCaption(Code))
                {
                }
                column(Study_Plan_Class_DescriptionCaption; "Study Plan Class".FieldCaption(Description))
                {
                }
                column(Study_Plan_Class__Class_Director_Name_Caption; "Study Plan Class".FieldCaption("Class Director Name"))
                {
                }
                column(Study_Plan_Class_ClassCaption; "Study Plan Class".FieldCaption(Class))
                {
                }
                column(Study_Plan_Header_Schooling_Year; "Schooling Year")
                {
                }
                dataitem("Study Plan Class"; Class)
                {
                    DataItemLink = "Study Plan Code" = FIELD(Code);
                    DataItemTableView = SORTING(Class, "School Year");
                    column(Study_Plan_Class_Class; Class)
                    {
                    }
                    column(Study_Plan_Class_Description; Description)
                    {
                    }
                    column(Schooling_Year_____________Class_Letter__Control1102065004; "Schooling Year" + ' - ' + "Class Letter")
                    {
                    }
                    column(Study_Plan_Class__Class_Director_Name_; "Class Director Name")
                    {
                    }
                    column(Study_Plan_Class_School_Year; "School Year")
                    {
                    }
                    column(Study_Plan_Class_Study_Plan_Code; "Study Plan Code")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if ReportType = ReportType::Courses then begin
                        CurrReport.Break;
                    end;

                    SetFilter(Code, varCode);

                    if varSchoolYear <> '' then
                        "Study Plan Header".SetRange("Study Plan Header"."School Year", varSchoolYear);
                end;
            }

            trigger OnPreDataItem()
            begin
                if ReportType = ReportType::Courses then begin
                    CurrReport.Break;
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
                    field(ReportType; ReportType)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = Text19071249;
                        OptionCaption = 'Courses,Study Plans';
                        ShowCaption = false;
                    }
                    field(varCode; varCode)
                    {
                        ApplicationArea = Basic, Suite;
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
                        ApplicationArea = Basic, Suite;
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
        Text19071249: Label 'Report Type';
        Classes_CursCaptionLbl: Label 'Class Course';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        FiltresCaption_Control1102059020Lbl: Label 'Filters';
        Classe_Pla_d_EstudisCaptionLbl: Label 'Class Study Plan';
        CurrReport_PAGENO_Control1102059016CaptionLbl: Label 'Page';
}

