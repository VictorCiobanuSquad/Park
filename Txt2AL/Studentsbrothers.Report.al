report 31009771 "Students brothers"
{
    // //IT001 - ET - 2016.10.26 - Correcção de erro: não estava a mostrar a turma correcta do aluno
    DefaultLayout = RDLC;
    RDLCLayout = './Studentsbrothers.rdlc';

    Caption = 'Students Brothers';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Students; Students)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Name, "Brother Hierarchy";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(nomeEscola; nomeEscola)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Students_Name; Name)
            {
            }
            column(Students_Students__No__; Students."No.")
            {
            }
            column(vClassStu; vClassStu)
            {
            }
            column(Germans_dels_alumnesCaption; Germans_dels_alumnesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column("Núm__codi_estudiantCaption"; Núm__codi_estudiantCaptionLbl)
            {
            }
            column(NomCaption; NomCaptionLbl)
            {
            }
            column("Núm__codi_estudiantCaption_Control1102065022"; Núm__codi_estudiantCaption_Control1102065022Lbl)
            {
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(tempAlunos_Name; tempAlunos.Name)
                {
                }
                column(tempAlunos__No__; tempAlunos."No.")
                {
                }
                column(vClass_Control1102065001; vClass)
                {
                }
                column(Integer2_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        tempAlunos.FindSet
                    else
                        tempAlunos.Next;

                    Clear(vClass);
                    rRegistration.Reset;
                    rRegistration.SetRange(rRegistration."School Year", varSchoolYear);
                    rRegistration.SetRange(rRegistration."Student Code No.", tempAlunos."No.");
                    rRegistration.SetRange(rRegistration.Status, rRegistration.Status::Subscribed);
                    if rRegistration.FindFirst then
                        vClass := rRegistration."Schooling Year" + '-' + rRegistration."Class Letter";
                end;

                trigger OnPreDataItem()
                begin
                    tempAlunos.Reset;
                    SetRange(Number, 1, tempAlunos.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                tempAlunos.DeleteAll;

                rUsersFamilyStudents.Reset;
                rUsersFamilyStudents.SetRange("School Year", varSchoolYear);
                rUsersFamilyStudents.SetRange("Student Code No.", Students."No.");
                rUsersFamilyStudents.SetFilter(Kinship, '%1|%2|%3', rUsersFamilyStudents.Kinship::Father,
                                                                  rUsersFamilyStudents.Kinship::Mother,
                                                                  rUsersFamilyStudents.Kinship::"Brother in School");
                if rUsersFamilyStudents.FindSet then begin
                    repeat
                        rUsersFamilyStudents2.Reset;
                        rUsersFamilyStudents2.SetRange("School Year", varSchoolYear);
                        rUsersFamilyStudents2.SetRange("No.", rUsersFamilyStudents."No.");
                        rUsersFamilyStudents2.SetFilter(Kinship, '%1|%2|%3', rUsersFamilyStudents2.Kinship::Father,
                                                                          rUsersFamilyStudents2.Kinship::Mother,
                                                                          rUsersFamilyStudents2.Kinship::"Brother in School");
                        if rUsersFamilyStudents2.FindSet then begin
                            repeat
                                if rstudents.Get(rUsersFamilyStudents2."Student Code No.") then begin
                                    tempAlunos.Reset;
                                    tempAlunos.SetRange("No.", rstudents."No.");
                                    if not tempAlunos.FindFirst then begin
                                        if Students."No." <> rstudents."No." then begin
                                            tempAlunos.Init;
                                            tempAlunos.TransferFields(rstudents);
                                            tempAlunos.Insert;
                                        end;
                                    end;
                                end;
                            until rUsersFamilyStudents2.Next = 0;
                        end;
                    until rUsersFamilyStudents.Next = 0;
                end;

                Clear(vClass);
                rRegistration.Reset;
                rRegistration.SetRange(rRegistration."School Year", varSchoolYear);
                rRegistration.SetRange(rRegistration."Student Code No.", Students."No.");
                rRegistration.SetRange(rRegistration.Status, rRegistration.Status::Subscribed);
                if rRegistration.FindFirst then
                    //IT001 - ET - 2016.10.26 - Correcção de erro: não estava a mostrar a turma correcta do aluno
                    //vClass := rRegistration."Schooling Year" + '-' + rRegistration."Class Letter";
                    vClassStu := rRegistration."Schooling Year" + '-' + rRegistration."Class Letter";
            end;

            trigger OnPreDataItem()
            begin
                if varSchoolYear = '' then Error(Text0001);

                Filtros := varSchoolYear + ' ; ' + Students.GetFilters;
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

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        tempAlunos: Record Students temporary;
        rRegistration: Record Registration;
        cUserEducation: Codeunit "User Education";
        i: Integer;
        nomeEscola: Text[128];
        Filtros: Text[1024];
        VarNamestud: Text[1024];
        rstudents: Record Students;
        rUsersFamilyStudents: Record "Users Family / Students";
        rUsersFamilyStudents2: Record "Users Family / Students";
        varSchoolYear: Code[20];
        varStudentNo: Code[20];
        rSchoolYear: Record "School Year";
        Text0001: Label 'You must fill School Year.';
        vClass: Text[30];
        Germans_dels_alumnesCaptionLbl: Label 'Students Brothers';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        "Núm__codi_estudiantCaptionLbl": Label 'Student Code No.';
        NomCaptionLbl: Label 'Name';
        "Núm__codi_estudiantCaption_Control1102065022Lbl": Label 'Student Code No.';
        vClassStu: Text[30];

    //[Scope('OnPrem')]
    procedure RecebeDados(inSchoolYear: Code[50])
    begin
        varSchoolYear := inSchoolYear;
    end;
}

