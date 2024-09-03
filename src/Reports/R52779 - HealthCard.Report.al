report 52779 "Health Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './HealthCard.rdlc';
    Caption = 'Health Card';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Students; Students)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Name;
            RequestFilterHeading = 'Name';
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Students__Date_Validity_; "Date Validity")
            {
            }
            column(Students_District; District)
            {
            }
            column(Students_Location; Location)
            {
            }
            column(Students_Naturalness; Naturalness)
            {
            }
            column(Students__Doc__Number_Id_; "Doc. Number Id")
            {
            }
            column(Students_NISS; NISS)
            {
            }
            column(Students__Birth_Date_; "Birth Date")
            {
            }
            column(Students__Post_Code_; "Post Code")
            {
            }
            column(Students_Nationality; Nationality)
            {
            }
            column(varStudentName; varStudentName)
            {
            }
            column(Students__Archive_of_Identification_; "Archive of Identification")
            {
            }
            column(Students_County; County)
            {
            }
            column(Students_Address; Address)
            {
            }
            column(Students__Doc__Type_Id_; "Doc. Type Id")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Health_CardCaption; Health_CardCaptionLbl)
            {
            }
            column(STUDENT_IDENTIFICATIONCaption; STUDENT_IDENTIFICATIONCaptionLbl)
            {
            }
            column(Students__Date_Validity_Caption; FieldCaption("Date Validity"))
            {
            }
            column(Students_LocationCaption; FieldCaption(Location))
            {
            }
            column(Students_NaturalnessCaption; FieldCaption(Naturalness))
            {
            }
            column(Students__Birth_Date_Caption; FieldCaption("Birth Date"))
            {
            }
            column(Students__Post_Code_Caption; FieldCaption("Post Code"))
            {
            }
            column(Students_NISSCaption; FieldCaption(NISS))
            {
            }
            column(Students_DistrictCaption; FieldCaption(District))
            {
            }
            column(Students__Doc__Number_Id_Caption; FieldCaption("Doc. Number Id"))
            {
            }
            column(Students__Archive_of_Identification_Caption; FieldCaption("Archive of Identification"))
            {
            }
            column(Students_NationalityCaption; FieldCaption(Nationality))
            {
            }
            column(Students_CountyCaption; FieldCaption(County))
            {
            }
            column(varStudentNoCaption; varStudentNoCaptionLbl)
            {
            }
            column(varStudentNameCaption; varStudentNameCaptionLbl)
            {
            }
            column(Ending_DateCaption; Ending_DateCaptionLbl)
            {
            }
            column(Starting_DateCaption; Starting_DateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(CodeCaption; CodeCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(Students_AddressCaption; FieldCaption(Address))
            {
            }
            column(Students__Doc__Type_Id_Caption; FieldCaption("Doc. Type Id"))
            {
            }
            column(Students_No_; "No.")
            {
            }
            column(ObservationsCaption; ObservationsCaptionLbl)
            {
            }
            dataitem("Health & Safety Students"; "Health & Safety Students")
            {
                DataItemLink = "Student Code" = FIELD("No.");
                DataItemTableView = SORTING(Type) ORDER(Ascending);
                column(Health___Safety_Students__Ending_Date_; "Ending Date")
                {
                }
                column(Health___Safety_Students__Starting_Date_; "Starting Date")
                {
                }
                column(Health___Safety_Students_Description; Description)
                {
                }
                column(Health___Safety_Students_Code; Code)
                {
                }
                column(Health___Safety_Students_Type; Type)
                {
                }
                column(Health___Safety_Students_Student_Code; "Student Code")
                {
                }
                column(Health___Safety_Students_Line_No; "Line No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                varStudentName := Students.Name
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
    }

    trigger OnPreReport()
    begin

        if CompanyInfo.Get() then;
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        Filtros := Students.GetFilters;
    end;

    var
        Text001: Label 'On';
        Text002: Label 'valid until';
        CompanyInfo: Record "Company Information";
        dados_saude: Record "Health & Safety Students";
        type: Option Vaccinations;
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        Filtros: Text[1024];
        varStudentName: Text[250];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Health_CardCaptionLbl: Label 'Health Card';
        STUDENT_IDENTIFICATIONCaptionLbl: Label 'STUDENT IDENTIFICATION';
        varStudentNoCaptionLbl: Label 'No.';
        varStudentNameCaptionLbl: Label 'Name';
        Ending_DateCaptionLbl: Label 'Ending Date';
        Starting_DateCaptionLbl: Label 'Starting Date';
        DescriptionCaptionLbl: Label 'Description';
        CodeCaptionLbl: Label 'Code';
        TypeCaptionLbl: Label 'Type';
        ObservationsCaptionLbl: Label 'Observations';
}

