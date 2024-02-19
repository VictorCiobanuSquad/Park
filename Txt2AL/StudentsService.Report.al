report 31009775 "Students Service"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsService.rdlc';
    Caption = 'Students Service';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Students; Students)
        {
            RequestFilterFields = "No.";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Students__No__; "No.")
            {
            }
            column(Students_Name; Name)
            {
            }
            column(Students__No__Caption; FieldCaption("No."))
            {
            }
            column(Students_NameCaption; FieldCaption(Name))
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Serveis_per_AlumneCaption; Serveis_per_AlumneCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Student_Service_Plan__Service_Code_Caption; SSP.FieldCaption("Service Code"))
            {
            }
            column(Student_Service_Plan_DescriptionCaption; SSP.FieldCaption(Description))
            {
            }
            column(Student_Service_Plan_QuantityCaption; SSP.FieldCaption(Quantity))
            {
            }
            column(Services_ET___Unit_Price_Caption; "Services ET".FieldCaption("Unit Price"))
            {
            }
            column(Sales_PriceCaption; Sales_PriceCaptionLbl)
            {
            }
            column(Sales_Line_Discount_ET___Line_Discount___Caption; "Sales Line Discount ET".FieldCaption("Line Discount %"))
            {
            }
            dataitem(SSP; "Student Service Plan")
            {
                DataItemLink = "Student No." = FIELD("No.");
                column(Student_Service_Plan__Service_Code_; "Service Code")
                {
                }
                column(Student_Service_Plan_Description; Description)
                {
                }
                column(Student_Service_Plan_Quantity; Quantity)
                {
                }
                column(Services_ET___Unit_Price_; "Services ET"."Unit Price")
                {
                }
                column(Student_Service_Plan__Quantity_____Services_ET___Unit_Price_; SSP.Quantity * "Services ET"."Unit Price")
                {
                }
                column(Sales_Line_Discount_ET___Line_Discount___; "Sales Line Discount ET"."Line Discount %")
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
                dataitem("Services ET"; "Services ET")
                {
                    DataItemLink = "No." = FIELD("Service Code");
                    DataItemTableView = SORTING("No.");
                    dataitem("Sales Line Discount ET"; "Sales Line Discount ET")
                    {
                        DataItemLink = Code = FIELD("No.");
                        DataItemTableView = SORTING(Type, Code, "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity") WHERE("Sales Type" = CONST(Customer));
                    }

                    trigger OnPreDataItem()
                    begin
                        //MESSAGE("Services ET"."No.");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    if rRespCenter.Find('-') then
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := Students.GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cUserEducation: Codeunit "User Education";
        Filtros: Text[1024];
        nomeEscola: Text[128];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Serveis_per_AlumneCaptionLbl: Label 'Students Service';
        FiltresCaptionLbl: Label 'Filters';
        Sales_PriceCaptionLbl: Label 'Sales Price';
}

