report 31009778 "Class List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ClassList.rdlc';
    Caption = 'Class List';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(dataitemClass; Class)
        {
            DataItemTableView = SORTING("School Year", "Schooling Year");
            RequestFilterFields = "School Year", "Schooling Year";
            column(DateFormated; Format(Today, 0, 4))
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Class_SchoolYear; "School Year")
            {
                IncludeCaption = true;
            }
            column(Class_SchoolingYear; "Schooling Year")
            {
                IncludeCaption = true;
            }
            column(Class_Class; Class)
            {
                IncludeCaption = true;
            }
            column(SchoolYear_ClassLetter; "Schooling Year" + '  - ' + "Class Letter")
            {
            }
            column(Class_ClassDirectorName; "Class Director Name")
            {
                IncludeCaption = true;
            }
            column(totalRegis; totalRegis)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> CUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;
                Clear(totalRegis);
                rRegisClass.Reset;
                rRegisClass.SetRange(Class, Class);
                if rRegisClass.Find('-') then
                    totalRegis := rRegisClass.Count;
            end;

            trigger OnPreDataItem()
            begin
                if CUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(CUserEducation.GetEducationFilter(UserId));
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
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Class List';
        PageCaption = 'Page';
        RegisteredCaption = 'Registered Total';
        FilterCaption = 'Filters';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        Filtros := dataitemClass.GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rRegisClass: Record "Registration Class";
        CUserEducation: Codeunit "User Education";
        totalRegis: Integer;
        Filtros: Text[1024];
        nomeEscola: Text[128];
        reqClass: Code[20];
        reqSchoolYear: Code[9];
        reqSchoolingYear: Code[10];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

