report 52780 "Recover Test / Alert"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RecoverTestAlert.rdlc';
    Caption = 'Recover Test / Alert';

    dataset
    {
        dataitem(Class; Class)
        {
            DataItemTableView = SORTING("School Year", "Schooling Year");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Schooling Year", "School Year", Class;
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Filtros; Filtros)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Class__School_Year_; "School Year")
            {
            }
            column(Schooling_Year______________Class_Letter_; "Schooling Year" + '  - ' + "Class Letter")
            {
            }
            column("Prova_Recuperació___Alerta_cap_ensenyamentCaption"; Prova_Recuperació___Alerta_cap_ensenyamentCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Class__School_Year_Caption; FieldCaption("School Year"))
            {
            }
            column(Classe_Caption; Classe_CaptionLbl)
            {
            }
            column(Class_Class; Class)
            {
            }
            column(Class_Schooling_Year; "Schooling Year")
            {
            }
            column(Nom_completCaption; Nom_completCaptionLbl)
            {
            }
            column(Registration_Subjects__Student_Code_No__Caption; Registration_Subjects__Student_Code_No__CaptionLbl)
            {
            }
            column(Registration_Subjects__Subjects_Code_Caption; "Registration Subjects".FieldCaption("Subjects Code"))
            {
            }
            column(Registration_Subjects__Education_Head_Alert_Caption; Registration_Subjects__Education_Head_Alert_CaptionLbl)
            {
            }
            column(Registration_Subjects__Recover_Test_Caption; Registration_Subjects__Recover_Test_CaptionLbl)
            {
            }
            column(Registration_Subjects__Absence_Option_Caption; "Registration Subjects".FieldCaption("Absence Option"))
            {
            }
            dataitem("Registration Class"; "Registration Class")
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING(Class, "School Year", "Schooling Year", "Study Plan Code", "Student Code No.", Type, "Line No.");
                column(Registration_Class__Student_Code_No__; "Student Code No.")
                {
                }
                column(Registration_Class__Full_Name_; "Full Name")
                {
                }
                column(Registration_Class__Recover_Test_; "Recover Test")
                {
                }
                column(Registration_Class__Education_Head_Alert_; "Education Head Alert")
                {
                }
                column(Registration_Class__Absence_Option_; "Absence Option")
                {
                }
                column(Registration_Class__Absence_Option_Caption; FieldCaption("Absence Option"))
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
                column(Registration_Class_Type; Type)
                {
                }
                column(Registration_Class_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Registration Class"."Recover Test" = false) and ("Registration Class"."Education Head Alert" = false) then
                        CurrReport.Skip;

                    if ("Registration Class"."Recover Test" = true) and ("Registration Class"."Education Head Alert" = false) and
                      (vProvaRec = false) then
                        CurrReport.Skip;

                    if ("Registration Class"."Recover Test" = false) and ("Registration Class"."Education Head Alert" = true) and
                      (vAlertaEncEdu = false) then
                        CurrReport.Skip;
                end;
            }
            dataitem("Registration Subjects"; "Registration Subjects")
            {
                DataItemLink = "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year"), Class = FIELD(Class);
                DataItemTableView = SORTING("Student Code No.", "School Year", "Line No.");
                column(Registration_Subjects__Student_Code_No__; "Student Code No.")
                {
                }
                column(Registration_Subjects__Subjects_Code_; "Subjects Code")
                {
                }
                column(vFullName; vFullName)
                {
                }
                column(Registration_Subjects__Recover_Test_; "Recover Test")
                {
                }
                column(Registration_Subjects__Education_Head_Alert_; "Education Head Alert")
                {
                }
                column(Registration_Subjects__Absence_Option_; "Absence Option")
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
                column(Registration_Subjects_Class; Class)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Registration Subjects"."Recover Test" = false) and ("Registration Subjects"."Education Head Alert" = false) then
                        CurrReport.Skip;

                    if ("Registration Subjects"."Recover Test" = true) and ("Registration Subjects"."Education Head Alert" = false) and
                      (vProvaRec = false) then
                        CurrReport.Skip;

                    if ("Registration Subjects"."Recover Test" = false) and ("Registration Subjects"."Education Head Alert" = true) and
                      (vAlertaEncEdu = false) then
                        CurrReport.Skip;


                    if rStudent.Get("Registration Subjects"."Student Code No.") then
                        vFullName := rStudent.Name;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> CUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                Clear(vCiclo);
                rStructureEduCountry.Reset;
                rStructureEduCountry.SetRange(rStructureEduCountry.Country, "Country/Region Code");
                rStructureEduCountry.SetRange(rStructureEduCountry."Schooling Year", "Schooling Year");
                if rStructureEduCountry.FindFirst then
                    if rStructureEduCountry.Level = rStructureEduCountry.Level::"1º Cycle" then
                        vCiclo := 1
                    else
                        vCiclo := 2;
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(vProvaRec; vProvaRec)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Recover Test';
                    }
                    field(vAlertaEncEdu; vAlertaEncEdu)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Education Head Alert';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            vProvaRec := true;
            vAlertaEncEdu := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := Class.GetFilters;

        if (vProvaRec = false) and (vAlertaEncEdu = false) then Error(Text0001);
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rStudent: Record Students;
        rStructureEduCountry: Record "Structure Education Country";
        CUserEducation: Codeunit "User Education";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        vProvaRec: Boolean;
        vAlertaEncEdu: Boolean;
        vFullName: Text[191];
        vCiclo: Integer;
        Text0001: Label 'You must choose an option.';
        "Prova_Recuperació___Alerta_cap_ensenyamentCaptionLbl": Label 'Recover Test / Education Head Alert';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        Classe_CaptionLbl: Label 'Class:';
        Nom_completCaptionLbl: Label 'Full Name';
        Registration_Subjects__Student_Code_No__CaptionLbl: Label 'Student Code No.';
        Registration_Subjects__Education_Head_Alert_CaptionLbl: Label 'Education Head Alert';
        Registration_Subjects__Recover_Test_CaptionLbl: Label 'Recover Test';
}

