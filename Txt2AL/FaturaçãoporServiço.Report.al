report 31009880 "Faturação por Serviço"
{
    //  Listagem de Faturas registadas
    DefaultLayout = RDLC;
    RDLCLayout = './FaturaçãoporServiço.rdlc';


    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Posting Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(FiltroData; FiltroData)
            {
            }
            column(Sales_Invoice_Line_Description; Description)
            {
            }
            column(Sales_Invoice_Line__No__; "No.")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Amount_Including_VAT_; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Sell_to_Customer_No__; "Sales Invoice Line"."Sell-to Customer No.")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Document_No__; "Sales Invoice Line"."Document No.")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Posting_Date_; "Sales Invoice Line"."Posting Date")
            {
            }
            column(NomeAluno; NomeAluno)
            {
            }
            column(Sales_Invoice_Line__Line_Discount_Amount_; "Line Discount Amount")
            {
            }
            column(Sales_Invoice_Line__Quantity____Sales_Invoice_Line___Unit_Price_; "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price")
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Amount_Including_VAT__Control1101490003; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Sales_Invoice_Line__Line_Discount_Amount__Control1101490019; "Line Discount Amount")
            {
            }
            column(TotalIliq; TotalIliq)
            {
            }
            column(Sales_Invoice_Line__Sales_Invoice_Line___Amount_Including_VAT__Control1101490034; "Sales Invoice Line"."Amount Including VAT")
            {
            }
            column(Sales_Invoice_Line__Line_Discount_Amount__Control1101490035; "Line Discount Amount")
            {
            }
            column(TotalGlobalLiq; TotalGlobalLiq)
            {
            }
            column("Faturação_por_ServiçoCaption"; Faturação_por_ServiçoCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(DescontosCaption; DescontosCaptionLbl)
            {
            }
            column("IlíquidoCaption"; IlíquidoCaptionLbl)
            {
            }
            column(NomeCaption; NomeCaptionLbl)
            {
            }
            column(N__AlunoCaption; N__AlunoCaptionLbl)
            {
            }
            column(N__FaturaCaption; N__FaturaCaptionLbl)
            {
            }
            column(DataCaption; DataCaptionLbl)
            {
            }
            column(TotalCaption_Control1101490022; TotalCaption_Control1101490022Lbl)
            {
            }
            column(DescontosCaption_Control1101490023; DescontosCaption_Control1101490023Lbl)
            {
            }
            column("IlíquidoCaption_Control1101490024"; IlíquidoCaption_Control1101490024Lbl)
            {
            }
            column(NomeCaption_Control1101490025; NomeCaption_Control1101490025Lbl)
            {
            }
            column(N__AlunoCaption_Control1101490027; N__AlunoCaption_Control1101490027Lbl)
            {
            }
            column(N__FaturaCaption_Control1101490028; N__FaturaCaption_Control1101490028Lbl)
            {
            }
            column(DataCaption_Control1101490029; DataCaption_Control1101490029Lbl)
            {
            }
            column("Serviço__Caption"; Serviço__CaptionLbl)
            {
            }
            column("TOTAL_SERVIÇO__Caption"; TOTAL_SERVIÇO__CaptionLbl)
            {
            }
            column(TOTAL_GERAL__Caption; TOTAL_GERAL__CaptionLbl)
            {
            }
            column(Sales_Invoice_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalFac := TotalFac + "Sales Invoice Line"."Amount Including VAT";

                if Aluno.Get("Sales Invoice Line"."Bill-to Customer No.") then
                    NomeAluno := Aluno.Name
                else
                    NomeAluno := '';
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

    trigger OnInitReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);

        rSchool.Reset;
        if rSchool.Find('-') then
            nomeEscola := rSchool."School Name";
    end;

    trigger OnPreReport()
    begin

        if "Sales Invoice Line".GetFilter("Posting Date") <> '' then
            FiltroData := Text0001 + "Sales Invoice Line".GetFilter("Posting Date");
    end;

    var
        rSchool: Record School;
        CompanyInformation: Record "Company Information";
        Servico: Record Item;
        Aluno: Record Customer;
        FiltroData: Text[50];
        FiltroServico: Text[100];
        FiltroTurma: Text[50];
        Text0001: Label 'Faturas registadas: ';
        Text0002: Label 'Turma: ';
        Text0004: Label 'Serviço: ';
        TotalFac: Decimal;
        TotalIliq: Decimal;
        TotalGlobalLiq: Decimal;
        NomeAluno: Text[250];
        nomeEscola: Text[128];
        "Faturação_por_ServiçoCaptionLbl": Label 'Faturação por Serviço';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        TotalCaptionLbl: Label 'Total';
        DescontosCaptionLbl: Label 'Descontos';
        "IlíquidoCaptionLbl": Label 'Ilíquido';
        NomeCaptionLbl: Label 'Nome';
        N__AlunoCaptionLbl: Label 'Nº Aluno';
        N__FaturaCaptionLbl: Label 'Nº Fatura';
        DataCaptionLbl: Label 'Data';
        TotalCaption_Control1101490022Lbl: Label 'Total';
        DescontosCaption_Control1101490023Lbl: Label 'Descontos';
        "IlíquidoCaption_Control1101490024Lbl": Label 'Ilíquido';
        NomeCaption_Control1101490025Lbl: Label 'Nome';
        N__AlunoCaption_Control1101490027Lbl: Label 'Nº Aluno';
        N__FaturaCaption_Control1101490028Lbl: Label 'Nº Fatura';
        DataCaption_Control1101490029Lbl: Label 'Data';
        "Serviço__CaptionLbl": Label 'Serviço: ';
        "TOTAL_SERVIÇO__CaptionLbl": Label 'TOTAL SERVIÇO: ';
        TOTAL_GERAL__CaptionLbl: Label 'TOTAL GERAL: ';
}

