report 31009883 "Alunos - Contactos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './AlunosContactos.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Class; Class)
        {
            column(Class_Class; Class)
            {
            }
            column(ClassDirectorName_Class; "Class Director Name")
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
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem("Registration Class"; "Registration Class")
            {
                DataItemLink = Class = FIELD(Class), "School Year" = FIELD("School Year");
                column(StudentCodeNo_RegistrationClass; "Student Code No.")
                {
                }
                column(Name_RegistrationClass; Name)
                {
                }
                column(Painome; PaiNome)
                {
                }
                column(Paitelefone; PaiTelefone)
                {
                }
                column(Paiemail; PaiEmail)
                {
                }
                column(Maenome; MaeNome)
                {
                }
                column(Maetelefone; MaeTelefone)
                {
                }
                column(Maeemail; MaeEmail)
                {
                }
                column(EncarregadoEdu; EncarregadoEdu)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(PaiNome);
                    Clear(PaiTelefone);
                    Clear(PaiEmail);
                    Clear(MaeNome);
                    Clear(MaeTelefone);
                    Clear(MaeEmail);

                    rUsersFamilyStudents.Reset;
                    rUsersFamilyStudents.SetRange(rUsersFamilyStudents."School Year", "Registration Class"."School Year");
                    rUsersFamilyStudents.SetRange(rUsersFamilyStudents."Student Code No.", "Registration Class"."Student Code No.");
                    rUsersFamilyStudents.SetRange(rUsersFamilyStudents.Kinship, rUsersFamilyStudents.Kinship::Father);
                    if rUsersFamilyStudents.FindFirst then begin
                        PaiNome := rUsersFamilyStudents.Name;
                        if rUsersFamilyStudents."Mobile Phone" <> '' then
                            PaiTelefone := rUsersFamilyStudents."Mobile Phone"
                        else
                            PaiTelefone := rUsersFamilyStudents."Phone No.";
                        PaiEmail := rUsersFamilyStudents."E-mail";
                        if rUsersFamilyStudents."Education Head" then
                            EncarregadoEdu := Format(rUsersFamilyStudents.Kinship::Father);
                    end;

                    rUsersFamilyStudents.SetRange(rUsersFamilyStudents.Kinship, rUsersFamilyStudents.Kinship::Mother);
                    if rUsersFamilyStudents.FindFirst then begin
                        MaeNome := rUsersFamilyStudents.Name;
                        if rUsersFamilyStudents."Mobile Phone" <> '' then
                            MaeTelefone := rUsersFamilyStudents."Mobile Phone"
                        else
                            MaeTelefone := rUsersFamilyStudents."Phone No.";
                        MaeEmail := rUsersFamilyStudents."E-mail";
                        if rUsersFamilyStudents."Education Head" then
                            EncarregadoEdu := Format(rUsersFamilyStudents.Kinship::Mother);
                    end;
                end;
            }

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
        Titulo = 'Alunos - Contactos';
        Turma = 'Turma';
        NumAluno = 'No. Aluno';
        Nome = 'Nome';
        Pai = 'Pai';
        Mae = 'Mãe';
        Contacto = 'Contacto';
        EncEdu = 'Education Head:';
        MailLbl = 'Mail';
    }

    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        cUserEducation: Codeunit "User Education";
        ShowPicture: Boolean;
        rRespCenter: Record "Responsibility Center";
        nomeEscola: Text[128];
        rSchool: Record School;
        PaiNome: Text[250];
        PaiTelefone: Text[15];
        PaiEmail: Text[64];
        MaeNome: Text[250];
        MaeTelefone: Text[15];
        MaeEmail: Text[64];
        rUsersFamilyStudents: Record "Users Family / Students";
        EncarregadoEdu: Text[10];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

