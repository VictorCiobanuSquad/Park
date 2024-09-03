report 52851 "Students Transport and Lunch"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsTransportandLunch.rdlc';
    Caption = 'Students Transport and Lunch';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Structure Education Country"; "Structure Education Country")
        {
            DataItemTableView = SORTING("Sorting ID");
            PrintOnlyIfDetail = true;
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Text0001; Text0001)
            {
            }
            column(Text0002; Text0002)
            {
            }
            column(Text0003; Text0003)
            {
            }
            column(Structure_Education_Country__Schooling_Year_; "Schooling Year")
            {
            }
            column(vTotal; vTotal)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Alumnes_de_Transports_i_CantinaCaption; Alumnes_de_Transports_i_CantinaCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Structure_Education_Country__Schooling_Year_Caption; FieldCaption("Schooling Year"))
            {
            }
            column(vTotalCaption; vTotalCaptionLbl)
            {
            }
            column(Structure_Education_Country_Country; Country)
            {
            }
            column(Structure_Education_Country_Level; Level)
            {
            }
            column(ShowWhat; ShowWhatint)
            {
            }
            column(SEC_SortingID; "Sorting ID")
            {
            }
            dataitem(Registration; Registration)
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("School Year", "Schooling Year", Course);
                RequestFilterFields = "School Year";
                column(Registration__Student_Code_No__; "Student Code No.")
                {
                }
                column(vNome; vNome)
                {
                }
                column(vDay; vDay)
                {
                }
                column(vTotal_Control1102065006; vTotal)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vTotal_Control1102065006Caption; vTotal_Control1102065006CaptionLbl)
                {
                }
                column(Registration_School_Year; "School Year")
                {
                }
                column(Registration_Responsibility_Center; "Responsibility Center")
                {
                }
                column(Registration_Schooling_Year; "Schooling Year")
                {
                }
                column(VTGlob; VTGlob)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(vDay);
                    rStudentsNonLecHours.Reset;
                    rStudentsNonLecHours.SetRange(rStudentsNonLecHours."School Year", Registration."School Year");
                    rStudentsNonLecHours.SetRange(rStudentsNonLecHours."Student Code No.", Registration."Student Code No.");
                    if ShowWhat = ShowWhat::Lunch then
                        rStudentsNonLecHours.SetRange(rStudentsNonLecHours.Lunch, true);
                    if ShowWhat = ShowWhat::"Morning Transport" then
                        rStudentsNonLecHours.SetFilter(rStudentsNonLecHours."Collect Transport", '<>%1', '');
                    if ShowWhat = ShowWhat::"Afternoon Transport" then
                        rStudentsNonLecHours.SetFilter(rStudentsNonLecHours."Deliver Transport", '<>%1', '');

                    if rStudentsNonLecHours.FindFirst then begin
                        VTGlob := VTGlob + 1;
                        vTotal := vTotal + 1;
                        if rStudents.Get(Registration."Student Code No.") then
                            vNome := rStudents.Name;
                        repeat
                            vDay := vDay + ' / ' + Format(rStudentsNonLecHours."Week Day");
                        until rStudentsNonLecHours.Next = 0;
                    end else
                        CurrReport.Skip
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
                ShowWhatint := ShowWhat;

                // CurrReport.CreateTotals(vTotal);
                VTGlob := 0;
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
                    field(ShowWhat; ShowWhat)
                    {
                        ApplicationArea = All;
                        OptionCaption = 'Lunch,Morning Transport,Afternoon Transport';
                        ShowCaption = false;
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

        Filtros := Format(ShowWhat);
    end;

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        rStudentsNonLecHours: Record "Students Non Lective Hours";
        rStudents: Record Students;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        vTotal: Decimal;
        ShowWhat: Option Lunch,"Morning Transport","Afternoon Transport";
        vNome: Text[250];
        Text0001: Label 'Lunch';
        Text0002: Label 'Morning Transport';
        Text0003: Label 'Afternoon Transport';
        vDay: Text[250];
        Alumnes_de_Transports_i_CantinaCaptionLbl: Label 'Students Transport and Lunch';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        vTotalCaptionLbl: Label 'Total Global';
        vTotal_Control1102065006CaptionLbl: Label 'Total';
        ShowWhatint: Integer;
        VTGlob: Integer;
}

