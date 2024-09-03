report 52869 "Subjects statistics Lower Sec"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SubjectsstatisticsLowerSec.rdlc';
    Caption = 'Subjects statistics Lower Secundary';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(rCompanyInfo_Picture; rCompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(EstatisticasCaption; EstatisticasCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltresCaption; FiltresCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Cálculo do Código de Avaliação de forma a preencher o cabeçalho das avaliações
                rStudyPlanHead.Reset;
                rStudyPlanHead.SetRange("School Year", vSchoolYear);
                rStudyPlanHead.SetRange("Schooling Year", vSchoolingYear);
                if rStudyPlanHead.Find('-') then begin
                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetCurrentKey(Code, "School Year", "Schooling Year", "Sorting ID");
                    rStudyPlanLines.SetRange(Code, rStudyPlanHead.Code);
                    rStudyPlanLines.SetRange("School Year", rStudyPlanHead."School Year");
                    rStudyPlanLines.SetRange("Mandatory/Optional Type", rStudyPlanLines."Mandatory/Optional Type"::Required);
                    if rStudyPlanLines.FindFirst then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.Ascending(false);
                        rClassificationLevel.SetRange("Classification Group Code", rStudyPlanLines."Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            i := rClassificationLevel.Count;
                            repeat
                                vAvalTEXT[i] := rClassificationLevel."Description Level";
                                i := i - 1;
                            until rClassificationLevel.Next = 0;
                        end;
                        vAvalTEXT[6] := 'Total';
                    end;
                end;
                //
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);

                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                if ((vSchoolYear = '') or (vSchoolingYear = '')) and (vClass <> '') then begin
                    rClass.Reset;
                    rClass.SetRange(Class, vClass);
                    if rClass.Find('-') then begin
                        vSchoolYear := rClass."School Year";
                        vSchoolingYear := rClass."Schooling Year";
                    end;
                end;

                if ((vSchoolYear = '') and (vSchoolingYear = '') and (vClass = '')) then
                    Error(Text001);

                if ((vSchoolYear = '') and (vSchoolingYear <> '')) then
                    Error(Text001);

                if ((vSchoolYear <> '') and (vSchoolingYear = '')) then
                    Error(Text001);
            end;
        }
        dataitem("Study Plan Lines"; "Study Plan Lines")
        {
            DataItemTableView = SORTING(Code, "School Year", "Schooling Year", "Sorting ID") WHERE("Evaluation Type" = FILTER(<> Qualitative & <> "None Qualification"));
            column(vAvalTEXT_1_; vAvalTEXT[1])
            {
            }
            column(vAvalTEXT_2_; vAvalTEXT[2])
            {
            }
            column(vAvalTEXT_3_; vAvalTEXT[3])
            {
            }
            column(vAvalTEXT_4_; vAvalTEXT[4])
            {
            }
            column(vAvalTEXT_5_; vAvalTEXT[5])
            {
            }
            column(vAvalTEXT_6_; vAvalTEXT[6])
            {
            }
            column(Study_Plan_Lines__Study_Plan_Lines___Subject_Description_; "Study Plan Lines"."Subject Description")
            {
            }
            column(vAvalCount_1_; vAvalCount[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_2_; vAvalCount[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_3_; vAvalCount[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_4_; vAvalCount[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_5_; vAvalCount[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_6_; vAvalCount[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_1_; vAvalCountTotal[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_2_; vAvalCountTotal[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_3_; vAvalCountTotal[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_4_; vAvalCountTotal[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_5_; vAvalCountTotal[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_6_; vAvalCountTotal[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column("Disciplinas_NívelCaption"; Disciplinas_NívelCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Study_Plan_Lines_Code; Code)
            {
            }
            column(Study_Plan_Lines_School_Year; "School Year")
            {
            }
            column(Study_Plan_Lines_Schooling_Year; "Schooling Year")
            {
            }
            column(Study_Plan_Lines_Subject_Code; "Subject Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Study Plan Lines"."Subject Code" <> vOldDisc then begin
                    Clear(vAvalCount);

                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", rStudyPlanLines."Assessment Code");
                    if rClassificationLevel.Find('-') then begin
                        repeat
                            rAssessingStudents.Reset;
                            rAssessingStudents.SetFilter(Class, vClass);
                            rAssessingStudents.SetRange("School Year", rStudyPlanHead."School Year");
                            rAssessingStudents.SetRange("Schooling Year", rStudyPlanHead."Schooling Year");
                            rAssessingStudents.SetRange(Subject, "Study Plan Lines"."Subject Code");
                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                            rAssessingStudents.SetRange("Study Plan Code", "Study Plan Lines".Code);
                            rAssessingStudents.SetFilter("Moment Code", vMoment);
                            Clear(vGrade);
                            Evaluate(vGrade, rClassificationLevel."Classification Level Code");
                            rAssessingStudents.SetRange(Grade, vGrade);
                            if rAssessingStudents.Find('-') then begin
                                vAvalCount[rAssessingStudents.Grade] := rAssessingStudents.Count;
                            end;
                        until rClassificationLevel.Next = 0;
                    end;

                    vAvalCount[6] := vAvalCount[5] +
                                     vAvalCount[4] +
                                     vAvalCount[3] +
                                     vAvalCount[2] +
                                     vAvalCount[1];
                end;

                vOldDisc := "Study Plan Lines"."Subject Code";
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Code, rStudyPlanHead.Code);
                SetRange("School Year", rStudyPlanHead."School Year");
                SetRange("Schooling Year", rStudyPlanHead."Schooling Year");
            end;
        }
        dataitem(StudyPlanLines2; "Study Plan Lines")
        {
            DataItemTableView = SORTING("Option Group", "Sorting ID") WHERE("Curriculum Type" = FILTER("Non disciplinary"));
            column(vAvalTEXT_1__Control1102058033; vAvalTEXT[1])
            {
            }
            column(vAvalTEXT_2__Control1102058034; vAvalTEXT[2])
            {
            }
            column(vAvalTEXT_3__Control1102058035; vAvalTEXT[3])
            {
            }
            column(vAvalTEXT_6__Control1102058038; vAvalTEXT[6])
            {
            }
            column(StudyPlanLines2_StudyPlanLines2__Subject_Description_; StudyPlanLines2."Subject Description")
            {
            }
            column(vAvalCount_1__Control1102058041; vAvalCount[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_2__Control1102058042; vAvalCount[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_3__Control1102058043; vAvalCount[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_6__Control1102058046; vAvalCount[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_1__Control1102058047; vAvalCountTotal[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_2__Control1102058048; vAvalCountTotal[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_3__Control1102058049; vAvalCountTotal[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_6__Control1102058052; vAvalCountTotal[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column("Disciplinas_NívelCaption_Control1102058032"; Disciplinas_NívelCaption_Control1102058032Lbl)
            {
            }
            column(TotalCaption_Control1102058053; TotalCaption_Control1102058053Lbl)
            {
            }
            column(StudyPlanLines2_Code; Code)
            {
            }
            column(StudyPlanLines2_School_Year; "School Year")
            {
            }
            column(StudyPlanLines2_Schooling_Year; "Schooling Year")
            {
            }
            column(StudyPlanLines2_Subject_Code; "Subject Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if StudyPlanLines2."Subject Code" <> vOldDisc then begin
                    Clear(vAvalCount);

                    rClassificationLevel.Reset;
                    rClassificationLevel.Ascending(false);
                    rClassificationLevel.SetRange("Classification Group Code", StudyPlanLines2."Assessment Code");
                    if rClassificationLevel.Find('-') then begin
                        i := rClassificationLevel.Count;
                        repeat
                            rAssessingStudents.Reset;
                            rAssessingStudents.SetFilter(Class, vClass);
                            rAssessingStudents.SetRange("School Year", rStudyPlanHead."School Year");
                            rAssessingStudents.SetRange("Schooling Year", rStudyPlanHead."Schooling Year");
                            rAssessingStudents.SetRange(Subject, StudyPlanLines2."Subject Code");
                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                            rAssessingStudents.SetRange("Study Plan Code", StudyPlanLines2.Code);
                            rAssessingStudents.SetFilter("Moment Code", vMoment);
                            rAssessingStudents.SetRange("Qualitative Grade", rClassificationLevel."Classification Level Code");
                            if rAssessingStudents.Find('-') then begin
                                vAvalCount[i] := rAssessingStudents.Count;
                            end;
                            i := i - 1;
                        until rClassificationLevel.Next = 0;
                    end;

                    vAvalCount[6] := vAvalCount[5] +
                                     vAvalCount[4] +
                                     vAvalCount[3] +
                                     vAvalCount[2] +
                                     vAvalCount[1];
                end;

                vOldDisc := StudyPlanLines2."Subject Code";
            end;

            trigger OnPreDataItem()
            begin
                Clear(vAvalTEXT);
                Clear(vAvalCount);
                Clear(vAvalCountTotal);

                //Cálculo do Código de Avaliação de forma a preencher o cabeçalho das avaliações
                rStudyPlanHead.Reset;
                rStudyPlanHead.SetRange("School Year", vSchoolYear);
                rStudyPlanHead.SetRange("Schooling Year", vSchoolingYear);
                if rStudyPlanHead.Find('-') then begin
                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetCurrentKey(Code, "School Year", "Schooling Year", "Sorting ID");
                    rStudyPlanLines.SetRange(Code, rStudyPlanHead.Code);
                    rStudyPlanLines.SetRange("School Year", rStudyPlanHead."School Year");
                    rStudyPlanLines.SetRange("Curriculum Type", rStudyPlanLines."Curriculum Type"::"Non disciplinary");
                    if rStudyPlanLines.FindFirst then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.Ascending(false);
                        rClassificationLevel.SetRange("Classification Group Code", rStudyPlanLines."Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            i := rClassificationLevel.Count;
                            repeat
                                vAvalTEXT[i] := rClassificationLevel."Description Level";
                                i := i - 1;
                            until rClassificationLevel.Next = 0;
                        end;
                        vAvalTEXT[6] := 'Total';
                    end;
                end;
                //


                SetRange(Code, rStudyPlanHead.Code);
                SetRange("School Year", rStudyPlanHead."School Year");
                SetRange("Schooling Year", rStudyPlanHead."Schooling Year");
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
                    group("Filtros:")
                    {
                        Caption = 'Filtros:';
                        field(vSchoolYear; vSchoolYear)
                        {
                            ApplicationArea = All;
                            Caption = 'Ano Letivo';
                            TableRelation = "School Year"."School Year";
                        }
                        field(vSchoolingYear; vSchoolingYear)
                        {
                            ApplicationArea = All;
                            Caption = 'Ano Escolaridade';
                            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Level = FILTER("2º Cycle" | "3º Cycle"));
                        }
                        field(vClass; vClass)
                        {
                            ApplicationArea = All;
                            Caption = 'Turma';
                            TableRelation = Class.Class;

                            trigger OnValidate()
                            begin
                                vClassOnAfterValidate;
                            end;
                        }
                        field(vMoment; vMoment)
                        {
                            ApplicationArea = All;
                            Caption = 'Momento';
                            TableRelation = "Moments Assessment"."Moment Code";
                        }
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
        rCompanyInfo.Get;
        rCompanyInfo.CalcFields(Picture);

        if vSchoolYear <> '' then
            Filtros := vSchoolYear;

        if vSchoolingYear <> '' then begin
            if vSchoolYear <> '' then
                Filtros := Filtros + ',' + vSchoolingYear
            else
                Filtros := vSchoolingYear;
        end;

        if vClass <> '' then begin
            if vSchoolingYear <> '' then begin
                if vSchoolYear <> '' then
                    Filtros := Filtros + ',' + vClass
                else
                    Filtros := vClass;
            end else begin
                if vSchoolYear <> '' then
                    Filtros := Filtros + ',' + vClass
                else
                    Filtros := vClass;
            end;
        end;

        if vMoment <> '' then begin
            if vClass <> '' then begin
                if vSchoolingYear <> '' then begin
                    if vSchoolYear <> '' then
                        Filtros := Filtros + ',' + vMoment
                    else
                        Filtros := vMoment;
                end;
            end else begin
                if vSchoolingYear <> '' then begin
                    if vSchoolYear <> '' then
                        Filtros := Filtros + ',' + vMoment
                    else
                        Filtros := vMoment;
                end;
            end;
        end;
    end;

    var
        rCompanyInfo: Record "Company Information";
        rStudyPlanHead: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rClassificationLevel: Record "Classification Level";
        rAssessingStudents: Record "Assessing Students";
        rClass: Record Class;
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        i: Integer;
        vAvalTEXT: array[6] of Text[30];
        vAvalCount: array[6] of Decimal;
        vAvalCountTotal: array[6] of Decimal;
        vOldDisc: Code[20];
        vGrade: Decimal;
        vSchoolYear: Code[9];
        vSchoolingYear: Code[10];
        vClass: Code[20];
        vMoment: Code[10];
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cUserEducation: Codeunit "User Education";
        Text001: Label 'Tem de escolher o ano letivo e ano escolaridade ou então escolher a turma.';
        EstatisticasCaptionLbl: Label 'Statistics';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltresCaptionLbl: Label 'Filters';
        "Disciplinas_NívelCaptionLbl": Label 'Disciplinas/Nível';
        TotalCaptionLbl: Label 'Total';
        "Disciplinas_NívelCaption_Control1102058032Lbl": Label 'Disciplinas/Nível';
        TotalCaption_Control1102058053Lbl: Label 'Total';

    local procedure vClassOnAfterValidate()
    begin
        if ((vSchoolYear = '') or (vSchoolingYear = '')) and (vClass <> '') then begin
            rClass.Reset;
            rClass.SetRange(Class, vClass);
            if rClass.Find('-') then begin
                vSchoolYear := rClass."School Year";
                vSchoolingYear := rClass."Schooling Year";
            end;
        end;
    end;
}

