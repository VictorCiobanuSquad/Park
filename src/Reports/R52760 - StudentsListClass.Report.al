report 52760 "Students - List Class"
{
    // IT001-CPA
    //     - Alteração Layout
    //       - Old: "Nome Diretor Turma"
    //       - New: "Professor Responsável"
    //       - Não mostrar o nº do aluno na turma
    //       - 2014.10.28 - pedido por CPA - não mostrar para o Infantil
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsListClass.rdlc';

    Caption = 'Students - List Class';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(classs; Class)
        {
            DataItemTableView = SORTING(Class, "School Year") ORDER(Ascending);
            column(classs_Class; Class)
            {
            }
            column(classs_School_Year; "School Year")
            {
            }
            column(classs_Schooling_Year; "Schooling Year")
            {
            }
            column(Filtros; Filtros)
            {
            }
            dataitem("Registration Class"; "Registration Class")
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("Class No.") ORDER(Ascending);
                column(ShowPicture; ShowPicture)
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(nomeEscola; nomeEscola)
                {
                }
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                {
                }
                // column(CurrReport_PAGENO;CurrReport.PageNo)
                // {
                // }
                column(Registration_Class__Registration_Class__Class; "Registration Class".Class)
                {
                }
                column(classs__Schooling_Year____________classs__Class_Letter_; opcional)
                {
                }
                column(classs__Class_Director_Name_; classs."Class Director Name")
                {
                }
                column(classs__Secretary_Name_; classs."Secretary Name")
                {
                }
                column(classs_Room; classs.Room)
                {
                }
                column(Registration_Class__Registration_Class___School_Year_; "Registration Class"."School Year")
                {
                }
                column(rStudents_Picture; rStudents.Picture)
                {
                }
                column(Registration_Class_Name; Name)
                {
                }
                column(Registration_Class__Class_No__; "Class No.")
                {
                }
                column(Registration_Class__Student_Code_No__; "Student Code No.")
                {
                }
                column(Registration_Class_Status; Status)
                {
                }
                column(Registration_Class_Name_Control1102059003; Name)
                {
                }
                column(Registration_Class__Class_No___Control1102059004; "Class No.")
                {
                }
                column(Registration_Class__Student_Code_No___Control1102059005; "Student Code No.")
                {
                }
                column(Registration_Class_Status_Control1102065005; Status)
                {
                }
                column(vTotal; vTotal)
                {
                }
                column(Filtres_Caption; Filtres_CaptionLbl)
                {
                }
                column(Llista_d_alumnes_per_classeCaption; Llista_d_alumnes_per_classeCaptionLbl)
                {
                }
                column("Any_Acadèmic_Caption"; Any_Acadèmic_CaptionLbl)
                {
                }
                column(Classe_Caption; Classe_CaptionLbl)
                {
                }
                column(Secretari_Caption; Secretari_CaptionLbl)
                {
                }
                column(Director_de_la_classe_Caption; Director_de_la_classe_CaptionLbl)
                {
                }
                column(Sala_Caption; Sala_CaptionLbl)
                {
                }
                column(Codi_de_l_alumneCaption; Codi_de_l_alumneCaptionLbl)
                {
                }
                column(NomCaption; NomCaptionLbl)
                {
                }
                column(N__de_la_classeCaption; N__de_la_classeCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Registration_Class_StatusCaption; FieldCaption(Status))
                {
                }
                column(vTotalCaption; vTotalCaptionLbl)
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
                column(ResponsableTeacherLbl; ResponsableTeacherLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Registration Class".Status = "Registration Class".Status::Subscribed then
                        vTotal := vTotal + 1;

                    if ShowPicture then begin
                        rStudents.Get("Student Code No.");
                        rStudents.CalcFields(Picture);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if ShowAll = true then
                        "Registration Class".SetRange("Registration Class".Status)
                    else
                        "Registration Class".SetFilter("Registration Class".Status, '<>%1', 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                Clear(vTotal);


                //2014.10.28 - pedido por CPA
                Clear(opcional);
                if classs.Stage <> classs.Stage::Infant then
                    opcional := classs."Schooling Year" + ' - ' + classs."Class Letter"
            end;

            trigger OnPreDataItem()
            begin
                if varClass <> '' then
                    classs.SetRange(Class, varClass);
                if varSchoolYear <> '' then
                    classs.SetRange("School Year", varSchoolYear);
                if varSchoolingYear <> '' then
                    classs.SetRange("Schooling Year", varSchoolingYear);
                if varStudyPlan <> '' then
                    classs.SetRange("Study Plan Code", varStudyPlan);

                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                Filtros := classs.GetFilters;
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
                    field(ShowPicture; ShowPicture)
                    {
                        ApplicationArea = All;
                        Caption = 'Picture';
                    }
                    field(ShowAll; ShowAll)
                    {
                        ApplicationArea = All;
                        Caption = 'Show all students';
                    }
                    field(varClass; varClass)
                    {
                        ApplicationArea = All;
                        Caption = 'Class';
                        TableRelation = Class;
                    }
                    field(varSchoolYear; varSchoolYear)
                    {
                        ApplicationArea = All;
                        Caption = 'School Year';
                        TableRelation = "School Year";
                    }
                    field(varSchoolingYear; varSchoolingYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Schooling Year';
                        TableRelation = "Structure Education Country"."Schooling Year";
                    }
                    field(varStudyPlan; varStudyPlan)
                    {
                        ApplicationArea = All;
                        Caption = 'Study Plan';
                        TableRelation = "Study Plan Header";
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
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        rStudents: Record Students;
        cUserEducation: Codeunit "User Education";
        Filtros: Text[1024];
        ShowPicture: Boolean;
        rRespCenter: Record "Responsibility Center";
        nomeEscola: Text[128];
        rSchool: Record School;
        vTotal: Integer;
        ShowAll: Boolean;
        Filtres_CaptionLbl: Label 'Filters:';
        Llista_d_alumnes_per_classeCaptionLbl: Label 'Students Class List';
        "Any_Acadèmic_CaptionLbl": Label 'School Year:';
        Classe_CaptionLbl: Label 'Class:';
        Secretari_CaptionLbl: Label 'Secretary:';
        Director_de_la_classe_CaptionLbl: Label 'Class Director:';
        Sala_CaptionLbl: Label 'Room:';
        Codi_de_l_alumneCaptionLbl: Label 'Student Code N.';
        NomCaptionLbl: Label 'Name';
        N__de_la_classeCaptionLbl: Label 'Class No.';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        vTotalCaptionLbl: Label 'Total';
        varClass: Code[20];
        varSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        varStudyPlan: Code[20];
        ResponsableTeacherLbl: Label 'Responsable Teacher';
        opcional: Text[100];
}

