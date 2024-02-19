report 31009770 "Students Birthdays"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsBirthdays.rdlc';
    Caption = 'Students Birthdays';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Students; Students)
        {
            RequestFilterFields = "No.", Name, "Birth Date";
            column(TodayFormated; Format(Today, 0, 4))
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(No_Student; "No.")
            {
            }
            column(Name_Student; Name)
            {
            }
            column(Birthdate_Student; "Birth Date")
            {
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
        }

        actions
        {
        }
    }

    labels
    {
        Filters = 'Filters';
        PageCap = 'Page';
        NProcess = 'Process No.';
        Name = 'Name';
        BirthDate = 'Birth Date';
        ReportTitle = 'Students Birthdays';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := Students.GetFilters;
    end;

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        Filtros: Text[1024];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

