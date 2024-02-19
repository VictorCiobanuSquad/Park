report 31009783 "Students Fixed Services"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsFixedServices.rdlc';
    Caption = 'Students Fixed Services';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Registration; Registration)
        {
            DataItemTableView = SORTING("Student Code No.", "School Year");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Student Code No.", "School Year", Level, Class;
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(Filtros; Filtros)
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
            column(rStudent_Name; rStudent.Name)
            {
            }
            column(Registration_Registration__Student_Code_No__; Registration."Student Code No.")
            {
            }
            column(Registration_Registration__School_Year_; Registration."School Year")
            {
            }
            column(vQuantFinalTotal; vQuantFinalTotal)
            {
            }
            column(vAmountTotal; vAmountTotal)
            {
            }
            column(Alumnes_Serveis_fixosCaption; Alumnes_Serveis_fixosCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Registration_Registration__Student_Code_No__Caption; FieldCaption("Student Code No."))
            {
            }
            column(Registration_Registration__School_Year_Caption; FieldCaption("School Year"))
            {
            }
            column(Total_Geral_Caption; Total_Geral_CaptionLbl)
            {
            }
            column(Registration_Responsibility_Center; "Responsibility Center")
            {
            }
            column(Registration_Schooling_Year; "Schooling Year")
            {
            }
            dataitem("Student Service Plan"; "Student Service Plan")
            {
                DataItemLink = "Student No." = FIELD("Student Code No."), "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("Student No.", Selected) ORDER(Ascending) WHERE(Selected = CONST(true));
                RequestFilterFields = "Service Code";
                column(Student_Service_Plan_January; January)
                {
                }
                column(Student_Service_Plan_February; February)
                {
                }
                column(Student_Service_Plan_March; March)
                {
                }
                column(Student_Service_Plan_April; April)
                {
                }
                column(Student_Service_Plan_May; May)
                {
                }
                column(Student_Service_Plan_June; June)
                {
                }
                column(Student_Service_Plan_July; July)
                {
                }
                column(Student_Service_Plan_August; August)
                {
                }
                column(Student_Service_Plan_Setember; Setember)
                {
                }
                column(Student_Service_Plan_October; October)
                {
                }
                column(Student_Service_Plan_November; November)
                {
                }
                column(Student_Service_Plan_Dezember; Dezember)
                {
                }
                column(Student_Service_Plan__Service_Code_; "Service Code")
                {
                }
                column(Student_Service_Plan_Description; Description)
                {
                }
                column(mes_1_; mes[1])
                {
                }
                column(mes_2_; mes[2])
                {
                }
                column(mes_3_; mes[3])
                {
                }
                column(mes_4_; mes[4])
                {
                }
                column(mes_5_; mes[5])
                {
                }
                column(mes_6_; mes[6])
                {
                }
                column(mes_7_; mes[7])
                {
                }
                column(mes_8_; mes[8])
                {
                }
                column(mes_9_; mes[9])
                {
                }
                column(mes_10_; mes[10])
                {
                }
                column(mes_11_; mes[11])
                {
                }
                column(mes_12_; mes[12])
                {
                }
                column(vQuantFinal; vQuantFinal)
                {
                }
                column(vAmount; vAmount)
                {
                }
                column(Student_Service_Plan__Service_Code_Caption; FieldCaption("Service Code"))
                {
                }
                column(Student_Service_Plan_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Student_Service_Plan_FebruaryCaption; FieldCaption(February))
                {
                }
                column(Student_Service_Plan_MarchCaption; FieldCaption(March))
                {
                }
                column(Student_Service_Plan_AprilCaption; FieldCaption(April))
                {
                }
                column(Student_Service_Plan_JuneCaption; FieldCaption(June))
                {
                }
                column(Student_Service_Plan_JulyCaption; FieldCaption(July))
                {
                }
                column(Student_Service_Plan_AugustCaption; FieldCaption(August))
                {
                }
                column(Student_Service_Plan_SetemberCaption; FieldCaption(Setember))
                {
                }
                column(Student_Service_Plan_OctoberCaption; FieldCaption(October))
                {
                }
                column(Student_Service_Plan_NovemberCaption; FieldCaption(November))
                {
                }
                column(Student_Service_Plan_DezemberCaption; FieldCaption(Dezember))
                {
                }
                column(Student_Service_Plan_JanuaryCaption; FieldCaption(January))
                {
                }
                column(Student_Service_Plan_MayCaption; FieldCaption(May))
                {
                }
                column(vQuantFinalCaption; vQuantFinalCaptionLbl)
                {
                }
                column(vAmountCaption; vAmountCaptionLbl)
                {
                }
                column(Student_Service_Plan_Student_No_; "Student No.")
                {
                }
                column(Student_Service_Plan_School_Year; "School Year")
                {
                }
                column(Student_Service_Plan_Schooling_Year; "Schooling Year")
                {
                }
                column(Student_Service_Plan_Line_No_; "Line No.")
                {
                }
                column(TotalMonth1; AmountTotalMonth[1])
                {
                }
                column(TotalMonth2; AmountTotalMonth[2])
                {
                }
                column(TotalMonth3; AmountTotalMonth[3])
                {
                }
                column(TotalMonth4; AmountTotalMonth[4])
                {
                }
                column(TotalMonth5; AmountTotalMonth[5])
                {
                }
                column(TotalMonth6; AmountTotalMonth[6])
                {
                }
                column(TotalMonth7; AmountTotalMonth[7])
                {
                }
                column(TotalMonth8; AmountTotalMonth[8])
                {
                }
                column(TotalMonth9; AmountTotalMonth[9])
                {
                }
                column(TotalMonth10; AmountTotalMonth[10])
                {
                }
                column(TotalMonth11; AmountTotalMonth[11])
                {
                }
                column(TotalMonth12; AmountTotalMonth[12])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(mes);
                    Clear(vQuant);
                    Clear(vAmount);
                    Clear(vQuantFinal);

                    if "Student Service Plan".January then begin
                        //mes[1] := 'X';
                        vQuant[1] := vQuant[1] + 1;
                        mes[1] := Format(vQuant[1]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".February then begin
                        //mes[2] := 'X';
                        vQuant[2] := vQuant[2] + 1;
                        mes[2] := Format(vQuant[2]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".March then begin
                        //mes[3] := 'X';
                        vQuant[3] := vQuant[3] + 1;
                        mes[3] := Format(vQuant[3]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".April then begin
                        //mes[4] := 'X';
                        vQuant[4] := vQuant[4] + 1;
                        mes[4] := Format(vQuant[4]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".May then begin
                        //mes[5] := 'X';
                        vQuant[5] := vQuant[5] + 1;
                        mes[5] := Format(vQuant[5]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".June then begin
                        //mes[6] := 'X';
                        vQuant[6] := vQuant[6] + 1;
                        mes[6] := Format(vQuant[6]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".July then begin
                        //mes[7] := 'X';
                        vQuant[7] := vQuant[7] + 1;
                        mes[7] := Format(vQuant[7]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".August then begin
                        //mes[8] := 'X';
                        vQuant[8] := vQuant[8] + 1;
                        mes[8] := Format(vQuant[8]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".Setember then begin
                        //mes[9] := 'X';
                        vQuant[9] := vQuant[9] + 1;
                        mes[9] := Format(vQuant[9]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".October then begin
                        //mes[10] := 'X';
                        vQuant[10] := vQuant[10] + 1;
                        mes[10] := Format(vQuant[10]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".November then begin
                        //mes[11] := 'X';
                        vQuant[11] := vQuant[11] + 1;
                        mes[11] := Format(vQuant[11]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    if "Student Service Plan".Dezember then begin
                        //mes[12] := 'X';
                        vQuant[12] := vQuant[12] + 1;
                        mes[12] := Format(vQuant[12]);
                        vQuantFinal := vQuantFinal + 1;
                    end;

                    //vQuantFinal := "Student Service Plan".Quantity * vQuant;

                    if "Student Service Plan"."Student Unit Price" = 0 then begin
                        if rServices.Get("Student Service Plan"."Service Code") then begin
                            vAmount := rServices."Unit Price";
                        end else begin
                            if rItem.Get("Student Service Plan"."Service Code") then
                                vAmount := rItem."Unit Price";
                        end;
                    end else
                        vAmount := "Student Service Plan"."Student Unit Price";

                    AmountTotalMonth[1] := AmountTotalMonth[1] + vQuant[1] * vAmount;
                    AmountTotalMonth[2] := AmountTotalMonth[2] + vQuant[2] * vAmount;
                    AmountTotalMonth[3] := AmountTotalMonth[3] + vQuant[3] * vAmount;
                    AmountTotalMonth[4] := AmountTotalMonth[4] + vQuant[4] * vAmount;
                    AmountTotalMonth[5] := AmountTotalMonth[5] + vQuant[5] * vAmount;
                    AmountTotalMonth[6] := AmountTotalMonth[6] + vQuant[6] * vAmount;
                    AmountTotalMonth[7] := AmountTotalMonth[7] + vQuant[7] * vAmount;
                    AmountTotalMonth[8] := AmountTotalMonth[8] + vQuant[8] * vAmount;
                    AmountTotalMonth[9] := AmountTotalMonth[9] + vQuant[9] * vAmount;
                    AmountTotalMonth[10] := AmountTotalMonth[10] + vQuant[10] * vAmount;
                    AmountTotalMonth[11] := AmountTotalMonth[11] + vQuant[11] * vAmount;
                    AmountTotalMonth[12] := AmountTotalMonth[12] + vQuant[12] * vAmount;
                end;

                trigger OnPreDataItem()
                begin
                    Clear(AmountTotalMonth);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                rStudent.Reset;
                if rStudent.Get("Student Code No.") then;
            end;

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    if rRespCenter.Get(cUserEducation.GetEducationFilter(UserId)) then
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
        lblTotalGeral = 'Total Geral:';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        //CompanyInfo.CALCFIELDS(Picture);

        Filtros := Registration.GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rStudent: Record Students;
        rServices: Record "Services ET";
        rItem: Record Item;
        cUserEducation: Codeunit "User Education";
        mes: array[12] of Text[30];
        Filtros: Text[1024];
        nomeEscola: Text[128];
        nome: Text[188];
        vQuant: array[12] of Integer;
        vQuantFinal: Integer;
        vQuantFinalTotal: Integer;
        vAmount: Decimal;
        vAmountTotal: Decimal;
        Alumnes_Serveis_fixosCaptionLbl: Label 'Students Fixed Services';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        Total_Geral_CaptionLbl: Label 'Total';
        vQuantFinalCaptionLbl: Label 'Quantity';
        vAmountCaptionLbl: Label 'Amount';
        AmountTotalMonth: array[12] of Decimal;
}

