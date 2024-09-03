report 52852 "Value Daily Lunch"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ValueDailyLunch.rdlc';
    Caption = 'Value Daily Lunch';
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
            column(Text0004_________FORMAT_vSpecificDay_; Text0004 + ' ' + Format(vSpecificDay))
            {
            }
            column(Structure_Education_Country__Schooling_Year_; "Schooling Year")
            {
            }
            column(vTotalGlobal; vTotalGlobal)
            {
                DecimalPlaces = 0 : 0;
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Structure_Education_Country__Schooling_Year_Caption; FieldCaption("Schooling Year"))
            {
            }
            column(vTotalGlobalCaption; vTotalGlobalCaptionLbl)
            {
            }
            column(Structure_Education_Country_Country; Country)
            {
            }
            column(Structure_Education_Country_SortingID; "Sorting ID")
            {
            }
            column(Structure_Education_Country_Level; Level)
            {
            }
            dataitem(Registration; Registration)
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("School Year", "Schooling Year", Course);
                RequestFilterFields = "School Year";
                column(vTotal; vTotal)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vTotalCaption; vTotalCaptionLbl)
                {
                }
                column(Registration_Student_Code_No_; "Student Code No.")
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
                dataitem("Students Non Lective Hours"; "Students Non Lective Hours")
                {
                    DataItemLink = "School Year" = FIELD("School Year"), "Student Code No." = FIELD("Student Code No.");
                    DataItemTableView = SORTING("Student Code No.", "School Year", "Week Day", "Responsibility Center");
                    column(vNome; vNome)
                    {
                    }
                    column(Students_Non_Lective_Hours__Student_Code_No__; "Student Code No.")
                    {
                    }
                    column(Text0001_________Registration__Class_Letter_; Text0001 + ' ' + Registration."Class Letter")
                    {
                    }
                    column(Students_Non_Lective_Hours_School_Year; "School Year")
                    {
                    }
                    column(Students_Non_Lective_Hours_Week_Day; "Week Day")
                    {
                    }
                    column(Students_Non_Lective_Hours_Responsibility_Center; "Responsibility Center")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        rDate.Reset;
                        rDate.SetRange(rDate."Period Start", vSpecificDay);
                        if rDate.FindFirst then begin
                            if rDate."Period No." <> ("Students Non Lective Hours"."Week Day" + 1) then
                                CurrReport.Skip;
                        end;

                        rTransportEntry.Reset;
                        rTransportEntry.SetRange(rTransportEntry."Entry Type", rTransportEntry."Entry Type"::"Student Lunch");
                        rTransportEntry.SetRange(rTransportEntry."Student No.", "Students Non Lective Hours"."Student Code No.");
                        rTransportEntry.SetRange(rTransportEntry."Absence Day", vSpecificDay);
                        rTransportEntry.SetRange(rTransportEntry."Lunch Cancelled", false);
                        if rTransportEntry.FindLast then
                            CurrReport.Skip
                        else begin

                            if rStudents.Get(Registration."Student Code No.") then begin
                                vNome := rStudents.Name;
                                vTotalGlobal := vTotalGlobal + 1;
                            end;
                            vTotal := vTotal + 1;

                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if Registration.GetFilter(Registration."School Year") = '' then
                        Error(Text0003, Registration
                        .FieldCaption(Registration."School Year"));
                    vTotal := 0;
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


                if vSpecificDay = 0D then Error(Text0002);
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
                    field(vSpecificDay; vSpecificDay)
                    {
                        ApplicationArea = All;
                        Caption = 'Specific Day';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            vSpecificDay := WorkDate;
        end;
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
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        rStudentsNonLecHours: Record "Students Non Lective Hours";
        rStudents: Record Students;
        rDate: Record Date;
        rTransportEntry: Record "Transport & Lunch Entry ";
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        vTotal: Decimal;
        vTotalGlobal: Decimal;
        vNome: Text[250];
        Text0001: Label 'Class';
        vDay: Text[250];
        vSpecificDay: Date;
        Text0002: Label 'You must fill Specific Day.';
        Text0003: Label 'You must fill %1.';
        Text0004: Label 'Lunch';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        vTotalGlobalCaptionLbl: Label 'Total Global';
        vTotalCaptionLbl: Label 'Total';
}

