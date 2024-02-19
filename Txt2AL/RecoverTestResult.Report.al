report 31009842 "Recover Test Result"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RecoverTestResult.rdlc';
    Caption = 'Recover Test Result';

    dataset
    {
        dataitem(Test;Test)
        {
            DataItemTableView = SORTING("Test Type","Test No.","Line Type","Candidate no.","Student No.") WHERE("Line Type"=CONST(Line),"Test Type"=CONST("Recover Test"));
            RequestFilterFields = "School Year","Schooling Year","Student No.";
            column(DateFormated;Format(Today,0,4))
            {
            }
            column(CINFO_Picture;CompanyInfo.Picture)
            {
            }
            column(Filtros;Filtros)
            {
            }
            column(nomeEscola;nomeEscola)
            {
            }
            column(Test_SchoolY;"School Year")
            {
            }
            column(Test_SchoolingY;"Schooling Year")
            {
            }
            column(Test_Date;Date)
            {
            }
            column(Test_StudentNo;"Student No.")
            {
            }
            column(Test_StudentName;"Student Name")
            {
            }
            column(Test_RecoverClassif;"Recover Classif.")
            {
            }
            column(Test_Absent;Absent)
            {
            }
            column(Test_SubjectsCode;"Subjects Code")
            {
            }

            trigger OnPreDataItem()
            begin

                if CUserEducation.GetEducationFilter(UserId) <> '' then begin
                  rRespCenter.Reset;
                  rRespCenter.Get(CUserEducation.GetEducationFilter(UserId));
                     nomeEscola := rRespCenter.Name+' '+rRespCenter."Name 2";
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
        PageCaption = 'Page';
        RepTitleCaption = 'Recovery Exam Result';
        FiltersCaption = 'Filters';
        SchoolYearCaption = 'School Year';
        SchoolingYearCaption = 'Schooling Year';
        DateCaption = 'Date';
        StudentNoCaption = 'Student No.';
        StudentNameCaption = 'Student Name';
        RecoverClassCaption = 'Recover Classif.';
        AbsentCaption = 'Absent';
        SubjectsCodeCaption = 'Subjects Code';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := Test.GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        CUserEducation: Codeunit "User Education";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
}

