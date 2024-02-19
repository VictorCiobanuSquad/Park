report 31009768 "Teacher Class List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TeacherClassList.rdlc';
    Caption = 'Teacher Class List';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }

            trigger OnAfterGetRecord()
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
        dataitem(Class; Class)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Schooling Year", Class;
            RequestFilterHeading = 'Teacher-Class';
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(vMapaClass; vMapa)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(Filtros; Filtros)
            {
            }
            column(Class_Class; Class)
            {
            }
            column(Schooling_Year_____________Class_Letter_; "Schooling Year" + ' - ' + "Class Letter")
            {
            }
            column(Class__Class_Director_Name_; "Class Director Name")
            {
            }
            column(Llista_de_Docents_CursCaption; Llista_de_Docents_CursCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Teacher_Class__Sub_Subject_Code_Caption; Teacher_Class__Sub_Subject_Code_CaptionLbl)
            {
            }
            column(Teacher_Class__Subject_Description_Caption; "Teacher Class".FieldCaption("Subject Description"))
            {
            }
            column(Teacher_Class__Subject_Code_Caption; "Teacher Class".FieldCaption("Subject Code"))
            {
            }
            column(Name__________Last_Name_Caption; Name__________Last_Name_CaptionLbl)
            {
            }
            column(Teacher_Class_UserCaption; Teacher_Class_UserCaptionLbl)
            {
            }
            column(Classe_Caption; Classe_CaptionLbl)
            {
            }
            column(Director_de_la_classe_Caption; Director_de_la_classe_CaptionLbl)
            {
            }
            column(Teacher_Class_TurnCaption; "Teacher Class".FieldCaption(Turn))
            {
            }
            column(Class_School_Year; "School Year")
            {
            }
            dataitem("Teacher Class"; "Teacher Class")
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year");
                DataItemTableView = SORTING(User, "Subject Code", Class) WHERE("User Type" = FILTER(Teacher));
                column(Teacher_Class_User; User)
                {
                }
                column(Teacher_Class__Subject_Code_; "Subject Code")
                {
                }
                column(Teacher_Class__Subject_Description_; "Subject Description")
                {
                }
                column(Teacher_Class__Sub_Subject_Code_; "Sub-Subject Code")
                {
                }
                column(Name__________Last_Name_; Name + ' ' + "Last Name")
                {
                }
                column(Teacher_Class_Turn; Turn)
                {
                }
                column(Teacher_Class_User_Type; "User Type")
                {
                }
                column(Teacher_Class_Line_No_; "Line No.")
                {
                }
                column(Teacher_Class_Full_Name; "Full Name")
                {
                }
                column(Teacher_Class_Class; Class)
                {
                }
                column(Teacher_Class_School_Year; "School Year")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if rClass.Get("Teacher Class".Class, "Teacher Class"."School Year") then
                        if rClass."Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                            CurrReport.Skip;

                    if "Teacher Class"."Subject Code" = '' then CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Filtros := GetFilters;

                if vMapa = vMapa::"2" then CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin

                if varSchoolYear = '' then Error(Text0001);
                SetRange("School Year", varSchoolYear);
            end;
        }
        dataitem(Teacher; Teacher)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Teacher -Subject';
            column(FORMAT_TODAY_0_4__Control1102065003; Format(Today, 0, 4))
            {
            }
            column(vMapaTeacher; vMapa)
            {
            }
            // column(CurrReport_PAGENO_Control1102065009;CurrReport.PageNo)
            // {
            // }
            column(nomeEscola_Control1102065013; nomeEscola)
            {
            }
            column(Filtros_Control1102065014; Filtros)
            {
            }
            column(Teacher_Name_________Teacher__Last_Name_; Teacher.Name + ' ' + Teacher."Last Name")
            {
            }
            column(Teacher__No__; "No.")
            {
            }
            column(Llista_de_Docents___MateriaCaption; Llista_de_Docents___MatèriaCaptionLbl)
            {
            }
            column(CurrReport_PAGENO_Control1102065009Caption; CurrReport_PAGENO_Control1102065009CaptionLbl)
            {
            }
            column(FiltresCaption_Control1102065015; FiltresCaption_Control1102065015Lbl)
            {
            }
            column(Teacher__No__Caption; Teacher__No__CaptionLbl)
            {
            }
            column(vClassCaption; vClassCaptionLbl)
            {
            }
            column(ProfessorDisciplina__Sub_Subject_Code_Caption; ProfessorDisciplina__Sub_Subject_Code_CaptionLbl)
            {
            }
            column(ProfessorDisciplina__Subject_Description_Caption; ProfessorDisciplina.FieldCaption("Subject Description"))
            {
            }
            column(ProfessorDisciplina__Subject_Code_Caption; ProfessorDisciplina.FieldCaption("Subject Code"))
            {
            }
            column(ProfessorDisciplina_TurnCaption; ProfessorDisciplina.FieldCaption(Turn))
            {
            }
            dataitem(ProfessorDisciplina; "Teacher Class")
            {
                DataItemLink = User = FIELD("No.");
                DataItemTableView = SORTING("School Year", Class, "Subject Code", "Sub-Subject Code", "Allow Assign Evaluations") WHERE("User Type" = FILTER(Teacher), "Subject Code" = FILTER(<> ''));
                column(vClass; vClass)
                {
                }
                column(ProfessorDisciplina__Subject_Code_; "Subject Code")
                {
                }
                column(ProfessorDisciplina__Subject_Description_; "Subject Description")
                {
                }
                column(ProfessorDisciplina__Sub_Subject_Code_; "Sub-Subject Code")
                {
                }
                column(ProfessorDisciplina_Turn; Turn)
                {
                }
                column(ProfessorDisciplina_User_Type; "User Type")
                {
                }
                column(ProfessorDisciplina_User; User)
                {
                }
                column(ProfessorDisciplina_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    rClass.Reset;
                    rClass.SetRange(rClass.Class, ProfessorDisciplina.Class);
                    rClass.SetRange(rClass."School Year", ProfessorDisciplina."School Year");
                    if rClass.FindFirst then
                        vClass := rClass."Schooling Year" + ' - ' + rClass."Class Letter";
                end;

                trigger OnPreDataItem()
                begin
                    if varSchoolYear = '' then Error(Text0001);
                    ProfessorDisciplina.SetRange(ProfessorDisciplina."School Year", varSchoolYear);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if vMapa = vMapa::"1" then CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                Filtros := Teacher.GetFilters;
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
                    field(varSchoolYear; varSchoolYear)
                    {
                        Caption = 'School Year';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if PAGE.RunModal(PAGE::"School Year", rSchoolYear) = ACTION::LookupOK then begin
                                varSchoolYear := rSchoolYear."School Year";
                            end;
                        end;
                    }
                    field(vMapa; vMapa)
                    {
                        Caption = 'Report';
                        OptionCaption = 'Teacher-Class List,Teacher -Subject List';
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
    end;

    var
        CompanyInfo: Record "Company Information";
        rClass: Record Class;
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        rSchoolYear: Record "School Year";
        cUserEducation: Codeunit "User Education";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        vMapa: Option "1","2";
        vClass: Text[50];
        varSchoolYear: Code[10];
        Text0001: Label 'You must fill School Year.';
        Llista_de_Docents_CursCaptionLbl: Label 'Teacher-Class List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        Teacher_Class__Sub_Subject_Code_CaptionLbl: Label 'Sub-Subject Code';
        Name__________Last_Name_CaptionLbl: Label 'Name';
        Teacher_Class_UserCaptionLbl: Label 'Teacher';
        Classe_CaptionLbl: Label 'Class:';
        Director_de_la_classe_CaptionLbl: Label 'Class Director:';
        "Llista_de_Docents___MatèriaCaptionLbl": Label 'Teacher -Subject List';
        CurrReport_PAGENO_Control1102065009CaptionLbl: Label 'Page';
        FiltresCaption_Control1102065015Lbl: Label 'Filters';
        Teacher__No__CaptionLbl: Label 'No.';
        vClassCaptionLbl: Label 'Class';
        ProfessorDisciplina__Sub_Subject_Code_CaptionLbl: Label 'Sub-Subject Code';
}

