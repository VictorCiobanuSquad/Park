report 31009757 "Student Card"
{
    // //IT001 - CPA -  2017.02.10  - Novos campos: NIF e Data Validade C. Cidadao
    //                              - Retirar Campos: Naturalidade e Concelho
    // 
    // //IT002 - 2017.02.24 - Correcção ao enc. educacao
    //         - estavam a aparecer 2 end. diferentes, porque 1 foi EE em 2014 e outro em 2017
    DefaultLayout = RDLC;
    RDLCLayout = './StudentCard.rdlc';

    Caption = 'Student Card';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola2; nomeEscola)
            {
            }
            column(Fitxa_de_l_AlumneCaption; Fitxa_de_l_AlumneCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
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
        }
        dataitem(Students; Students)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.";
            column(Filtros; Filtros)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo__Name_2_; CompanyInfo."Name 2")
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
                IncludeCaption = true;
            }
            column(Students_Students_Name; Students.Name)
            {
            }
            column(Students__Doc__Number_Id_; "Doc. Number Id")
            {
            }
            column(Students__Date_of_Issuance_; "Date of Issuance")
            {
            }
            column(Students_Date_Validity; "Date Validity")
            {
            }
            column(Students_NIF; "VAT Registration No.")
            {
            }
            column(Students__Archive_of_Identification_; "Archive of Identification")
            {
            }
            column(Students_Naturalness; Naturalness)
            {
            }
            column(Students_County; County)
            {
            }
            column(Students__Birth_Date_; "Birth Date")
            {
            }
            column(Students_Address; Address)
            {
            }
            column(Students__Address_2_; "Address 2")
            {
            }
            column(Students__Post_Code_; "Post Code")
            {
            }
            column(Students_Location; Location)
            {
            }
            column(Students__Phone_No__; "Phone No.")
            {
            }
            column(varEncEduc; varEncEduc)
            {
            }
            column(varEncEduc2; varEncEduc2)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Students_Students_NameCaption; Students_Students_NameCaptionLbl)
            {
            }
            column(Students__Doc__Number_Id_Caption; FieldCaption("Doc. Number Id"))
            {
            }
            column(Students_NaturalnessCaption; FieldCaption(Naturalness))
            {
            }
            column(Students_CountyCaption; FieldCaption(County))
            {
            }
            column(Students__Birth_Date_Caption; FieldCaption("Birth Date"))
            {
            }
            column(Students_AddressCaption; FieldCaption(Address))
            {
            }
            column(Students__Post_Code_Caption; FieldCaption("Post Code"))
            {
            }
            column(Students_LocationCaption; FieldCaption(Location))
            {
            }
            column(Students__Phone_No__Caption; FieldCaption("Phone No."))
            {
            }
            column(varEncEducCaption; varEncEducCaptionLbl)
            {
            }
            column(varEncEduc2Caption; varEncEduc2CaptionLbl)
            {
            }
            column(Students_No_; "No.")
            {
            }
            column("Identificació_tutorCaption"; Identificació_tutorCaptionLbl)
            {
            }
            column(Students_No_Caption; FieldCaption("No."))
            {
            }
            column(DataValidade_Caption; Data_ValidadeLbl)
            {
            }
            column(NIF_Caption; NIFLbl)
            {
            }
            dataitem("Users Family / Students"; "Users Family / Students")
            {
                DataItemLink = "Student Code No." = FIELD("No.");
                DataItemTableView = SORTING("School Year", "Student Code No.", Kinship, "No.") ORDER(Descending) WHERE("Education Head" = FILTER(true));
                PrintOnlyIfDetail = false;
                column(Users_Family___Students_School_Year; "School Year")
                {
                }
                column(Users_Family___Students_Student_Code_No_; "Student Code No.")
                {
                }
                column(Users_Family___Students_Kinship; Kinship)
                {
                }
                column(Users_Family___Students_No_; "No.")
                {
                }
                dataitem("Users Family"; "Users Family")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = SORTING("No.");
                    PrintOnlyIfDetail = false;
                    column(varEndEnc; varEndEnc)
                    {
                    }
                    column(varNomeEnc; varNomeEnc)
                    {
                    }
                    column(Users_Family__Post_Code_; "Post Code")
                    {
                    }
                    column(Users_Family_Location; Location)
                    {
                    }
                    column(Users_Family__Phone_No__; "Phone No.")
                    {
                    }
                    column(Users_Family__Mobile_Phone_; "Mobile Phone")
                    {
                    }
                    column(Users_Family__E_mail_; "E-mail")
                    {
                    }
                    column(varEndEncCaption; varEndEncCaptionLbl)
                    {
                    }
                    column(Nome_CompletoCaption; Nome_CompletoCaptionLbl)
                    {
                    }
                    column(Users_Family__Post_Code_Caption; FieldCaption("Post Code"))
                    {
                    }
                    column(Users_Family_LocationCaption; FieldCaption(Location))
                    {
                    }
                    column(Users_Family__Phone_No__Caption; FieldCaption("Phone No."))
                    {
                    }
                    column(Users_Family__Mobile_Phone_Caption; FieldCaption("Mobile Phone"))
                    {
                    }
                    column(Users_Family__E_mail_Caption; FieldCaption("E-mail"))
                    {
                    }
                    column(Users_Family_No_; "No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //APD Teste docido sections
                        varNomeEnc := "Users Family".Name;
                        if "Users Family"."Last Name 2" <> '' then
                            varNomeEnc := varNomeEnc + ' ' + "Users Family"."Last Name 2";

                        if "Users Family"."Last Name" <> '' then
                            varNomeEnc := varNomeEnc + ' ' + "Users Family"."Last Name";

                        varEndEnc := "Users Family".Address;
                        if "Users Family"."Address 2" <> '' then
                            varEndEnc := varEndEnc + ' ' + "Users Family"."Address 2"
                    end;
                }

                trigger OnAfterGetRecord()
                begin


                    Flag := Flag + 1;
                end;

                trigger OnPreDataItem()
                begin

                    Clear(Flag);

                    //IT002 - 2017.02.24 - Correcção ao enc. educacao
                    "Users Family / Students".SetRange("Users Family / Students"."School Year", cStudentsRegistration.GetShoolYearActive);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //----------------------------------------------------------------------------------------------------------------------------------
                // Ir buscar a informação relativa aos pais do aluno - C+_RSC_C+ - 30.06.2008
                //----------------------------------------------------------------------------------------------------------------------------------
                recUsersFamilyStudents.Reset;
                recUsersFamilyStudents.SetRange("Student Code No.", Students."No.");
                recUsersFamilyStudents.SetFilter(Kinship, '%1|%2', recUsersFamilyStudents.Kinship::Father, recUsersFamilyStudents.Kinship::Mother)
                ;
                if recUsersFamilyStudents.Find('-') then
                    repeat
                        if recUsersFamilyStudents.Kinship = recUsersFamilyStudents.Kinship::Father then begin
                            varEncEduc := recUsersFamilyStudents.Name;
                        end;

                        if recUsersFamilyStudents.Kinship = recUsersFamilyStudents.Kinship::Mother then begin
                            varEncEduc2 := recUsersFamilyStudents.Name;

                        end;
                    until recUsersFamilyStudents.Next = 0;
                //----------------------------------------------------------------------------------------------------------------------------------
                // Fim - C+_RSC_C+ - 30.06.2008
                //----------------------------------------------------------------------------------------------------------------------------------

                varStudentName := Students.Name;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");

                SetRange("School Year", cStudentsRegistration.GetShoolYearActive);//normatica 2013.09.25
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
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;


        Filtros := Students.GetFilters;
    end;

    var
        cUserEducation: Codeunit "User Education";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        recUsersFamilyStudents: Record "Users Family / Students";
        CompanyInfo: Record "Company Information";
        nomeEscola: Text[128];
        Filtros: Text[1024];
        varEncEduc: Text[250];
        varEncEduc2: Text[250];
        cStudentsRegistration: Codeunit "Students Registration";
        Flag: Integer;
        varStudentName: Text[250];
        varNomeEnc: Text[250];
        varEndEnc: Text[250];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Fitxa_de_l_AlumneCaptionLbl: Label 'Student Card';
        FiltresCaptionLbl: Label 'Filters';
        Students_Students_NameCaptionLbl: Label 'Name';
        varEncEducCaptionLbl: Label 'Son of';
        varEncEduc2CaptionLbl: Label 'And';
        "Identificació_tutorCaptionLbl": Label 'Tutor Identification';
        varEndEncCaptionLbl: Label 'Address';
        Nome_CompletoCaptionLbl: Label 'Nome Completo';
        Data_ValidadeLbl: Label 'Data de Validade';
        NIFLbl: Label 'Nº Contribuinte';
}

