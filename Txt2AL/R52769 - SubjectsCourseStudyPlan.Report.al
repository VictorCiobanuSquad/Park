report 52769 "Subjects Course/Study Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SubjectsCourseStudyPlan.rdlc';
    Caption = 'Subjects Course/Study Plan';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Structure Education Country"; "Structure Education Country")
        {
            DataItemTableView = SORTING("Sorting ID");
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(SortingID_SEC; "Sorting ID")
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
            column(Disciplines_per_pla_d_estudisCaption; Disciplines_per_pla_d_estudisCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Study_Plan_Sub_Subjects_Lines__Sub_Subject_Code_Caption; Study_Plan_Sub_Subjects_Lines__Sub_Subject_Code_CaptionLbl)
            {
            }
            column(Study_Plan_Lines__Subject_Code_Caption; "Study Plan Lines".FieldCaption("Subject Code"))
            {
            }
            column(Study_Plan_Lines__Subject_Description_Caption; "Study Plan Lines".FieldCaption("Subject Description"))
            {
            }
            column(Study_Plan_Sub_Subjects_Lines__Sub_Subject_Description_Caption; "Study Plan Sub-Subjects Lines".FieldCaption("Sub-Subject Description"))
            {
            }
            column(Study_Plan_Lines__School_Year_Caption; "Study Plan Lines".FieldCaption("School Year"))
            {
            }
            column(Study_Plan_Lines__Mandatory_Optional_Type_Caption; "Study Plan Lines".FieldCaption("Mandatory/Optional Type"))
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
            dataitem("Study Plan Lines"; "Study Plan Lines")
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING(Code, "School Year", "Schooling Year", "Sorting ID");
                column(Study_Plan_Lines_Code; Code)
                {
                }
                column(Study_Plan_Lines__Subject_Code_; "Subject Code")
                {
                }
                column(Study_Plan_Lines__Subject_Description_; "Subject Description")
                {
                }
                column(Study_Plan_Lines__School_Year_; "School Year")
                {
                }
                column(Study_Plan_Lines__Mandatory_Optional_Type_; "Mandatory/Optional Type")
                {
                }
                column(Study_Plan_Lines_CodeCaption; FieldCaption(Code))
                {
                }
                column(Study_Plan_Lines_Schooling_Year; "Schooling Year")
                {
                }
                column(BoolShow2; BoolShow2)
                {
                }
                dataitem("Study Plan Sub-Subjects Lines"; "Study Plan Sub-Subjects Lines")
                {
                    DataItemLink = Code = FIELD(Code), "Subject Code" = FIELD("Subject Code");
                    DataItemTableView = SORTING(Code, "Schooling Year", "Subject Code", "Sorting ID");
                    column(Study_Plan_Sub_Subjects_Lines__Sub_Subject_Code_; "Sub-Subject Code")
                    {
                    }
                    column(Study_Plan_Sub_Subjects_Lines__Sub_Subject_Description_; "Sub-Subject Description")
                    {
                    }
                    column(Study_Plan_Sub_Subjects_Lines_Type; Type)
                    {
                    }
                    column(Study_Plan_Sub_Subjects_Lines_Code; Code)
                    {
                    }
                    column(Study_Plan_Sub_Subjects_Lines_Schooling_Year; "Schooling Year")
                    {
                    }
                    column(Study_Plan_Sub_Subjects_Lines_Subject_Code; "Subject Code")
                    {
                    }
                    column(BoolShow; BoolShow)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BoolShow := false;
                        // continuar a descodificar as condições
                        if LastStudyPlanID = '' then begin
                            LastStudyPlanID := "Study Plan Lines"."Subject Code";
                            BoolShow := true;
                        end;
                        if LastStudyPlanID <> "Study Plan Lines"."Subject Code" then begin
                            LastStudyPlanID := "Study Plan Lines"."Subject Code";
                            BoolShow := true;
                        end;
                        // End condições
                    end;

                    trigger OnPreDataItem()
                    begin
                        LastStudyPlanID := '';
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                        CurrReport.Skip;

                    Clear(StudyPlanSubSubjectsLines);
                    StudyPlanSubSubjectsLines.SetRange(Code, "Study Plan Lines".Code);
                    StudyPlanSubSubjectsLines.SetRange("Subject Code", "Study Plan Lines"."Subject Code");
                    if StudyPlanSubSubjectsLines.IsEmpty then
                        BoolShow2 := false
                    else
                        BoolShow2 := true;
                end;

                trigger OnPreDataItem()
                begin

                    if ReportType = ReportType::Courses then begin
                        CurrReport.Break;
                    end;

                    SetFilter(Code, varCode);
                end;
            }

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


                if ReportType = ReportType::Courses then begin
                    CurrReport.Break;
                end;
            end;
        }
        dataitem("Course Lines"; "Course Lines")
        {
            DataItemTableView = SORTING(Code, "Line No.");
            column(CompanyInfo_Picture_Control1102059043; CompanyInfo.Picture)
            {
            }
            column(Filtros_Control1102059048; Filtros)
            {
            }
            column(nomeEscola_Control1102059049; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO_Control1102059052;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4__Control1102059055; Format(Today, 0, 4))
            {
            }
            column(Course_Lines_Code; Code)
            {
            }
            column(Course_Lines__Subject_Code_; "Subject Code")
            {
            }
            column(Course_Lines__Subject_Description_; "Subject Description")
            {
            }
            column(Course_Lines__Schooling_Year_Begin_; "Schooling Year Begin")
            {
            }
            column(Course_Lines__Formation_Component_; "Formation Component")
            {
            }
            column(Temes_del_cursCaption; Temes_del_cursCaptionLbl)
            {
            }
            column(Course_Plan_Sub_Subjects_Lines__Sub_Subject_Description_Caption; "Course Plan Sub-Subjects Lines".FieldCaption("Sub-Subject Description"))
            {
            }
            column(Course_Plan_Sub_Subjects_Lines__Sub_Subject_Code_Caption; Course_Plan_Sub_Subjects_Lines__Sub_Subject_Code_CaptionLbl)
            {
            }
            column(Course_Lines__Subject_Description_Caption; FieldCaption("Subject Description"))
            {
            }
            column(Course_Lines__Subject_Code_Caption; FieldCaption("Subject Code"))
            {
            }
            column(FiltresCaption_Control1102059051; FiltresCaption_Control1102059051Lbl)
            {
            }
            column(CurrReport_PAGENO_Control1102059052Caption; CurrReport_PAGENO_Control1102059052CaptionLbl)
            {
            }
            column(Course_Lines__Schooling_Year_Begin_Caption; FieldCaption("Schooling Year Begin"))
            {
            }
            column(Course_Lines__Formation_Component_Caption; FieldCaption("Formation Component"))
            {
            }
            column(Course_Lines_CodeCaption; FieldCaption(Code))
            {
            }
            column(Course_Lines_Line_No_; "Line No.")
            {
            }
            column(BoolShowCourses; BoolShowCourses)
            {
            }
            dataitem("Course Plan Sub-Subjects Lines"; "Study Plan Sub-Subjects Lines")
            {
                DataItemLink = Code = FIELD(Code), "Subject Code" = FIELD("Subject Code"), "Schooling Year" = FIELD("Schooling Year Begin");
                DataItemTableView = SORTING(Type, Code, "Schooling Year", "Subject Code", "Sub-Subject Code");
                column(Course_Plan_Sub_Subjects_Lines__Sub_Subject_Code_; "Sub-Subject Code")
                {
                }
                column(Course_Plan_Sub_Subjects_Lines__Sub_Subject_Description_; "Sub-Subject Description")
                {
                }
                column(Course_Plan_Sub_Subjects_Lines_Type; Type)
                {
                }
                column(Course_Plan_Sub_Subjects_Lines_Code; Code)
                {
                }
                column(Course_Plan_Sub_Subjects_Lines_Schooling_Year; "Schooling Year")
                {
                }
                column(Course_Plan_Sub_Subjects_Lines_Subject_Code; "Subject Code")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                BoolShowCourses := false;
                // continuar a descodificar as condições
                if LastStudyPlanID = '' then begin
                    LastStudyPlanID := "Course Lines".Code;
                    BoolShowCourses := true;
                end;
                if LastStudyPlanID <> "Course Lines".Code then begin
                    LastStudyPlanID := "Course Lines".Code;
                    BoolShowCourses := true;
                end;
                // End condições
            end;

            trigger OnPreDataItem()
            begin
                if ReportType = ReportType::"Study Plans" then begin
                    CurrReport.Break;
                end;

                SetFilter(Code, varCode);
                LastStudyPlanID := '';
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
        rStudyPlans: Record "Study Plan Header";
        rCourses: Record "Course Header";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        CompanyInfo: Record "Company Information";
        cUserEducation: Codeunit "User Education";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        ReportType: Option Courses,"Study Plans";
        varCode: Code[20];
        LastStudyPlanID: Code[20];
        Text19071249: Label 'Report Type';
        Disciplines_per_pla_d_estudisCaptionLbl: Label 'Subjects Study Plan';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        Study_Plan_Sub_Subjects_Lines__Sub_Subject_Code_CaptionLbl: Label 'Sub-Subject Code';
        Temes_del_cursCaptionLbl: Label 'Subjects Course';
        Course_Plan_Sub_Subjects_Lines__Sub_Subject_Code_CaptionLbl: Label 'Sub-Subject Code';
        FiltresCaption_Control1102059051Lbl: Label 'Filters';
        CurrReport_PAGENO_Control1102059052CaptionLbl: Label 'Page';
        BoolShow: Boolean;
        BoolShowCourses: Boolean;
        StudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        BoolShow2: Boolean;
}

