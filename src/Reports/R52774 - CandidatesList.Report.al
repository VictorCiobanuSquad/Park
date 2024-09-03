report 52774 "Candidates List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CandidatesList.rdlc';
    Caption = 'Candidates List';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Candidate Entry"; "Candidate Entry")
        {
            DataItemTableView = SORTING("School Year", "Sorting ID Schooling Year", "Total Points") ORDER(Descending);
            RequestFilterFields = "School Year", "Schooling Year", "Candidate No.", Accepted, Excluding, Priority;
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Candidate_Entry__School_Year_; "School Year")
            {
            }
            column(Candidate_Entry__Candidate_No__; "Candidate No.")
            {
            }
            column(Candidate_Entry__Candidate_Entry___Total_Points_; "Candidate Entry"."Total Points")
            {
            }
            column(Candidate_Entry__Candidate_Name_; "Candidate Name")
            {
            }
            column(vSituation; vSituation)
            {
            }
            column(Candidate_Entry__Schooling_Year_; "Schooling Year")
            {
            }
            column(Candidate_Entry_Priority; Priority)
            {
            }
            column(vOtherPoints; vOtherPoints)
            {
            }
            column(vTestPoints; vTestPoints)
            {
            }
            column(Candidate_ListCaption; Candidate_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(Candidate_Entry__Candidate_No__Caption; FieldCaption("Candidate No."))
            {
            }
            column(Candidate_Entry__Candidate_Name_Caption; FieldCaption("Candidate Name"))
            {
            }
            column(vSituationCaption; vSituationCaptionLbl)
            {
            }
            column(Candidate_Entry__Schooling_Year_Caption; FieldCaption("Schooling Year"))
            {
            }
            column(Candidate_Entry_PriorityCaption; FieldCaption(Priority))
            {
            }
            column(Candidate_Entry__Candidate_Entry___Total_Points_Caption; FieldCaption("Total Points"))
            {
            }
            column(vOtherPointsCaption; vOtherPointsCaptionLbl)
            {
            }
            column(vTestPointsCaption; vTestPointsCaptionLbl)
            {
            }
            column(Candidate_Entry_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if ("Responsibility Center" <> cUserEducation.GetEducationFilter(UserId)) and
                  (cUserEducation.GetEducationFilter(UserId) <> '') then
                    CurrReport.Skip;

                Clear(vSituation);
                if "Candidate Entry".Accepted = true then vSituation := "Candidate Entry".FieldCaption("Candidate Entry".Accepted);
                if "Candidate Entry".Excluding = true then vSituation := "Candidate Entry".FieldCaption("Candidate Entry".Excluding);

                if varShowPoints = false then begin
                    vOtherPoints := '-';
                    vTestPoints := '-';
                end else begin
                    vOtherPoints := Format("Candidate Entry"."Other Points");
                    vTestPoints := Format("Candidate Entry"."Average Test Points");
                end;
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

                if varShowOnlyCandidates then
                    "Candidate Entry".SetFilter("Candidate Entry"."Conversion Date", '=%1', 0D);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Opções")
                {
                    Caption = 'Opções';
                    field(varShowOnlyCandidates; varShowOnlyCandidates)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Only show candidates who are not yet students';
                    }
                    field(varShowPoints; varShowPoints)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Test points and Other points';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            varShowOnlyCandidates := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        Filtros := "Candidate Entry".GetFilters;
    end;

    var
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        Filtros: Text[1024];
        varShowOnlyCandidates: Boolean;
        vSituation: Text[30];
        varShowPoints: Boolean;
        vOtherPoints: Text[30];
        vTestPoints: Text[30];
        Candidate_ListCaptionLbl: Label 'Candidate List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        vSituationCaptionLbl: Label 'Situation';
        vOtherPointsCaptionLbl: Label 'Other Points';
        vTestPointsCaptionLbl: Label 'Average Test';
}

