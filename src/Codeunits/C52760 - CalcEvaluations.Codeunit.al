codeunit 52760 "Calc. Evaluations"
{
    Permissions = TableData "Assessing Students" = rimd;

    trigger OnRun()
    begin
        Message('%1', cParser.CalcDecimalExpr('(((15+15)/2)) '));

        if cParser.CalcDecimalExpr('(((15+15)/2)) ') >= 10 then;
    end;

    var
        cParser: Codeunit Parser;
        Formula: Text[1024];
        TEMPrAsStudents: Record "Assessing Students" temporary;
        VarDecValor1: Decimal;
        VarDecValor2: Decimal;
        VarDecValor3: Decimal;
        VarDecValor4: Decimal;
        VarDecValor5: Decimal;
        VarDecValor6: Decimal;
        VarNOTDecValor1: Decimal;
        VarNOTDecValor2: Decimal;
        Text0001: Label 'There is no %1 moment type configured.';
        Text0002: Label 'On table %1 there are no configurations for the %2 moment, regarding subject %3 of %4.';
        Text0003: Label 'There is no %1 code on table %2';


    procedure Calc(pAssessingStudents: Record "Assessing Students")
    var
        rCourseLines: Record "Course Lines";
        rRulesEvaluations: Record "Rules of Evaluations";
        Value: Decimal;
        varCExam: Decimal;
        varCIF: Decimal;
    begin


        rCourseLines.Reset;
        rCourseLines.SetRange(Code, pAssessingStudents."Study Plan Code");
        rCourseLines.SetRange("Subject Code", pAssessingStudents.Subject);
        if rCourseLines.FindFirst then begin
            rRulesEvaluations.Reset;
            rRulesEvaluations.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects");
            rRulesEvaluations.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            if rCourseLines."Exam Last Year" then begin
                rRulesEvaluations.SetRange("Line Type", ValidateExam(pAssessingStudents));
            end else
                rRulesEvaluations.SetRange("Line Type", 1);
            if rRulesEvaluations.Find('-') then begin
                repeat
                    Clear(Formula);
                    if rRulesEvaluations.Formula = '%1' then begin
                        Formula := StrSubstNo(rRulesEvaluations.Formula, pAssessingStudents.Grade);

                        case rRulesEvaluations."Operation 1" of
                            1:
                                if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin

                                    if rRulesEvaluations."Operation 2" <> 0 then begin
                                        case rRulesEvaluations."Operation 2" of
                                            1:
                                                if GetLastYearGrade(pAssessingStudents) < rRulesEvaluations."Rule 2" then begin


                                                end;
                                            2:
                                                if GetLastYearGrade(pAssessingStudents) > rRulesEvaluations."Rule 2" then begin

                                                end;
                                            3:
                                                if GetLastYearGrade(pAssessingStudents) >= rRulesEvaluations."Rule 2" then begin

                                                end;
                                        end;
                                    end;

                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");

                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");
                                    InsertValor(rRulesEvaluations, pAssessingStudents);
                                end;
                            2:
                                if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin

                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");

                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");
                                    InsertValor(rRulesEvaluations, pAssessingStudents);
                                end;
                            3:
                                if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin
                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");
                                    if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD then
                                        InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                          rRulesEvaluations."Classifications Calculations");
                                    InsertValor(rRulesEvaluations, pAssessingStudents);
                                end;
                        end;
                    end else begin
                        if rRulesEvaluations."Line Type" = rRulesEvaluations."Line Type"::"Sem Exame" then begin
                            if rRulesEvaluations."Characterise Subjects" = rRulesEvaluations."Characterise Subjects"::Biennial then begin

                                Formula := StrSubstNo(rRulesEvaluations.Formula, GetLastYearGrade(pAssessingStudents),
                                  pAssessingStudents.Grade);

                                case rRulesEvaluations."Operation 1" of
                                    1:
                                        if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    2:
                                        if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    3:
                                        if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                end;
                            end;
                            if rRulesEvaluations."Characterise Subjects" = rRulesEvaluations."Characterise Subjects"::Triennial then begin
                                Formula := StrSubstNo(rRulesEvaluations.Formula, GetLast2YearGrade(pAssessingStudents),
                                  GetLastYearGrade(pAssessingStudents), pAssessingStudents.Grade);

                                case rRulesEvaluations."Operation 1" of
                                    1:
                                        if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    2:
                                        if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    3:
                                        if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                end;

                            end;
                        end;
                        if rRulesEvaluations."Line Type" = rRulesEvaluations."Line Type"::"Com Exame(antes exame)" then begin
                            if rRulesEvaluations."Characterise Subjects" = rRulesEvaluations."Characterise Subjects"::Biennial then begin
                                Formula := StrSubstNo(rRulesEvaluations.Formula, GetLastYearGrade(pAssessingStudents),
                                  pAssessingStudents.Grade);
                                case rRulesEvaluations."Operation 1" of
                                    1:
                                        if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                        end;
                                    2:
                                        if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                        end;
                                    3:
                                        if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                        end;
                                end;
                            end;
                            if rRulesEvaluations."Characterise Subjects" = rRulesEvaluations."Characterise Subjects"::Triennial then begin
                                Formula := StrSubstNo(rRulesEvaluations.Formula, GetLast2YearGrade(pAssessingStudents),
                                  GetLastYearGrade(pAssessingStudents), pAssessingStudents.Grade);

                                case rRulesEvaluations."Operation 1" of
                                    1:
                                        if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    2:
                                        if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                    3:
                                        if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin

                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                              then
                                                InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                                  rRulesEvaluations."Classifications Calculations");
                                            InsertValor(rRulesEvaluations, pAssessingStudents);
                                        end;
                                end;
                            end;

                        end;
                        if rRulesEvaluations."Line Type" = rRulesEvaluations."Line Type"::"Com Exame(Após Exame)" then begin
                            if (rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Moment code") or
                              (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Moment code") or
                                (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Moment code") or
                                  (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Moment code") or
                                    (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Moment code") or
                                      (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"Moment code") then
                                varCExam := GetGradeExam(pAssessingStudents);
                            if (rRulesEvaluations."Value 1" = rRulesEvaluations."Value 1"::"Moment code") or
                              (rRulesEvaluations."Value 2" = rRulesEvaluations."Value 2"::"Moment code") or
                                (rRulesEvaluations."Value 3" = rRulesEvaluations."Value 3"::"Moment code") or
                                  (rRulesEvaluations."Value 4" = rRulesEvaluations."Value 4"::"Moment code") or
                                    (rRulesEvaluations."Value 5" = rRulesEvaluations."Value 5"::"Moment code") or
                                      (rRulesEvaluations."Value 6" = rRulesEvaluations."Value 6"::"Moment code") then
                                varCIF := GetGradeCIF(pAssessingStudents);

                            Formula := StrSubstNo(rRulesEvaluations.Formula, varCIF, varCExam);
                            case rRulesEvaluations."Operation 1" of
                                1:
                                    if cParser.CalcDecimalExpr(Formula) < rRulesEvaluations."Rule 1" then begin
                                        InsertValor(rRulesEvaluations, pAssessingStudents);
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                    end;
                                2:
                                    if cParser.CalcDecimalExpr(Formula) > rRulesEvaluations."Rule 1" then begin
                                        InsertValor(rRulesEvaluations, pAssessingStudents);
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                    end;
                                3:
                                    if cParser.CalcDecimalExpr(Formula) >= rRulesEvaluations."Rule 1" then begin
                                        InsertValor(rRulesEvaluations, pAssessingStudents);
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CIF
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                        if rRulesEvaluations."Classifications Calculations" = rRulesEvaluations."Classifications Calculations"::CFD
                                          then
                                            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula),
                                              rRulesEvaluations."Classifications Calculations");
                                    end;
                            end;

                        end;
                    end;
                until rRulesEvaluations.Next = 0;
            end;
        end;

        InsertGrade;
    end;


    procedure InsertGradeTemp(pAssessingStudents: Record "Assessing Students"; pValor: Decimal; pOptValor: Option " ",CIF,CFD,C10,C11,C12,CE)
    var
        rMomentsAssessment: Record "Moments Assessment";
        varMomentCode: Code[20];
        varMomentOption: Option " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD;
        rSettingRatings: Record "Setting Ratings";
        rRankGroup: Record "Rank Group";
    begin


        if pOptValor = pOptValor::CIF then begin

            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange("School Year", pAssessingStudents."School Year");
            rMomentsAssessment.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::CIF);
            if rMomentsAssessment.FindFirst then begin
                varMomentCode := rMomentsAssessment."Moment Code";
                varMomentOption := varMomentOption::CIF;
            end else
                Error(Text0001, 'CIF'); //HG
        end;
        if pOptValor = pOptValor::CFD then begin
            rMomentsAssessment.Reset;
            rMomentsAssessment.SetRange("School Year", pAssessingStudents."School Year");
            rMomentsAssessment.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            rMomentsAssessment.SetRange("Evaluation Moment", rMomentsAssessment."Evaluation Moment"::CFD);
            if rMomentsAssessment.FindFirst then begin
                varMomentCode := rMomentsAssessment."Moment Code";
                varMomentOption := varMomentOption::CFD;
            end else
                Error(Text0001, 'CFD'); //HG
        end;

        TEMPrAsStudents.Reset;
        TEMPrAsStudents.SetRange(Class, pAssessingStudents.Class);
        TEMPrAsStudents.SetRange("School Year", pAssessingStudents."School Year");
        TEMPrAsStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        TEMPrAsStudents.SetRange(Subject, pAssessingStudents.Subject);
        TEMPrAsStudents.SetRange("Moment Code", varMomentCode);
        if not TEMPrAsStudents.Find('-') then begin
            TEMPrAsStudents.Init;
            TEMPrAsStudents.TransferFields(pAssessingStudents);
            TEMPrAsStudents."Evaluation Moment" := varMomentOption;

            //TEMPrAsStudents.Grade := ROUND(pValor,1);

            //HG inicio

            rSettingRatings.Reset;
            rSettingRatings.SetRange("Moment Code", varMomentCode);
            rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
            rSettingRatings.SetRange("School Year", pAssessingStudents."School Year");
            rSettingRatings.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            rSettingRatings.SetRange("Subject Code", pAssessingStudents.Subject);
            rSettingRatings.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
            if rSettingRatings.FindFirst then begin
                if rRankGroup.Get(rSettingRatings."Assessment Code") then begin

                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative then
                        TEMPrAsStudents.Grade := Round(pValor, 1);

                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative then
                        TEMPrAsStudents."Qualitative Grade" := Format(Round(pValor, 1));

                    if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification" then begin
                        TEMPrAsStudents.Grade := Round(pValor, 1);
                        TEMPrAsStudents."Qualitative Grade" := ValidateAssessmentMixed(rSettingRatings."Assessment Code", Round(pValor, 1))
                    end;

                end else
                    Error(Text0002, rSettingRatings.TableCaption, rSettingRatings."Moment Code", rSettingRatings."Subject Code",
                    rSettingRatings."Schooling Year");
            end else
                Error(Text0003, rSettingRatings."Assessment Code", rRankGroup.TableCaption);

            //HG Fim



            TEMPrAsStudents."Moment Code" := varMomentCode;
            TEMPrAsStudents.Insert;
        end;
    end;


    procedure InsertValor(pRulesEvaluations: Record "Rules of Evaluations"; pAssessingStudents: Record "Assessing Students")
    begin
        if (pRulesEvaluations."Value 1" = pRulesEvaluations."Value 1"::"Moment code") or
           (pRulesEvaluations."Value 1" = pRulesEvaluations."Value 1"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 1");


        if (pRulesEvaluations."Value 2" = pRulesEvaluations."Value 2"::"Moment code") or
           (pRulesEvaluations."Value 2" = pRulesEvaluations."Value 2"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 2");

        if (pRulesEvaluations."Value 3" = pRulesEvaluations."Value 3"::"Moment code") or
           (pRulesEvaluations."Value 3" = pRulesEvaluations."Value 3"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 3");

        if (pRulesEvaluations."Value 4" = pRulesEvaluations."Value 4"::"Moment code") or
           (pRulesEvaluations."Value 4" = pRulesEvaluations."Value 4"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 4");

        if (pRulesEvaluations."Value 5" = pRulesEvaluations."Value 5"::"Moment code") or
           (pRulesEvaluations."Value 5" = pRulesEvaluations."Value 5"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 5");


        if (pRulesEvaluations."Value 6" = pRulesEvaluations."Value 6"::"Moment code") or
           (pRulesEvaluations."Value 6" = pRulesEvaluations."Value 6"::"Moment code") then
            InsertGradeTemp(pAssessingStudents, cParser.CalcDecimalExpr(Formula), pRulesEvaluations."Value 6");
    end;


    procedure InsertGrade()
    var
        rAssessingStudents: Record "Assessing Students";
    begin
        TEMPrAsStudents.Reset;
        if TEMPrAsStudents.Find('-') then begin
            repeat
                rAssessingStudents.Reset;
                rAssessingStudents.SetRange(Class, TEMPrAsStudents.Class);
                rAssessingStudents.SetRange("School Year", TEMPrAsStudents."School Year");
                rAssessingStudents.SetRange("Schooling Year", TEMPrAsStudents."Schooling Year");
                rAssessingStudents.SetRange(Subject, TEMPrAsStudents.Subject);
                rAssessingStudents.SetRange("Student Code No.", TEMPrAsStudents."Student Code No.");
                rAssessingStudents.SetRange("Moment Code", TEMPrAsStudents."Moment Code");
                if rAssessingStudents.Find('-') then begin
                    rAssessingStudents.Grade := TEMPrAsStudents.Grade;
                    rAssessingStudents."Qualitative Grade" := TEMPrAsStudents."Qualitative Grade";//HG
                    rAssessingStudents.Modify;
                end else begin
                    rAssessingStudents.Init;
                    rAssessingStudents.TransferFields(TEMPrAsStudents);
                    rAssessingStudents.Insert;
                end;

            until TEMPrAsStudents.Next = 0;
        end;
    end;


    procedure ValidateExam(pAssessingStudents: Record "Assessing Students"): Integer
    var
        rAssessingStudents: Record "Assessing Students";
    begin

        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, pAssessingStudents.Class);
        rAssessingStudents.SetRange("School Year", pAssessingStudents."School Year");
        rAssessingStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        rAssessingStudents.SetFilter("Evaluation Moment", '%1|%2', rAssessingStudents."Evaluation Moment"::EXN1,
        rAssessingStudents."Evaluation Moment"::EXN2);
        if rAssessingStudents.Find('-') then
            exit(3)
        else
            exit(2);
    end;


    procedure GetGradeExam(pAssessingStudents: Record "Assessing Students"): Decimal
    var
        rAssessingStudents: Record "Assessing Students";
        Exam1: Decimal;
        Exam2: Decimal;
    begin

        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, pAssessingStudents.Class);
        rAssessingStudents.SetRange("School Year", pAssessingStudents."School Year");
        rAssessingStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        rAssessingStudents.SetFilter("Evaluation Moment", '%1|%2', rAssessingStudents."Evaluation Moment"::EXN1,
        rAssessingStudents."Evaluation Moment"::EXN2);
        if rAssessingStudents.Find('-') then begin
            repeat
                if rAssessingStudents."Evaluation Moment" = rAssessingStudents."Evaluation Moment"::EXN1 then
                    Exam1 := rAssessingStudents.Grade;

                if rAssessingStudents."Evaluation Moment" = rAssessingStudents."Evaluation Moment"::EXN2 then
                    Exam2 := rAssessingStudents.Grade;

            until rAssessingStudents.Next = 0;
        end;

        if Exam1 >= Exam2 then
            exit(Exam1);

        if Exam2 >= Exam1 then
            exit(Exam2);
    end;


    procedure GetGradeCIF(pAssessingStudents: Record "Assessing Students"): Decimal
    var
        rAssessingStudents: Record "Assessing Students";
    begin

        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, pAssessingStudents.Class);
        rAssessingStudents.SetRange("School Year", pAssessingStudents."School Year");
        rAssessingStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::CIF);
        if rAssessingStudents.FindFirst then
            exit(rAssessingStudents.Grade)
    end;


    procedure GetLastYearGrade(pAssessingStudents: Record "Assessing Students"): Decimal
    var
        rAssessingStudents: Record "Assessing Students";
        rStEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        varId: Integer;
        VarGrade: Decimal;
    begin
        VarGrade := 0;

        rStEducationCountry.Reset;
        rStEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStEducationCountry.SetRange(Level, rStEducationCountry.Level::Secondary);
        rStEducationCountry.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        if rStEducationCountry.FindFirst then
            varId := rStEducationCountry."Sorting ID";

        rStEducationCountry.Reset;
        rStEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStEducationCountry.SetRange(Level, rStEducationCountry.Level::Secondary);
        rStEducationCountry.SetRange("Sorting ID", varId - 1);
        if rStEducationCountry.FindFirst then;


        rAssessingStudents.Reset;
        rAssessingStudents.SetRange("Schooling Year", rStEducationCountry."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
        if rAssessingStudents.Find('-') then begin
            repeat
                if rAssessingStudents.Grade > VarGrade then
                    VarGrade := rAssessingStudents.Grade;

            until rAssessingStudents.Next = 0;
        end;

        exit(VarGrade);
    end;


    procedure GetLast2YearGrade(pAssessingStudents: Record "Assessing Students"): Decimal
    var
        rAssessingStudents: Record "Assessing Students";
        rStEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        varId: Integer;
        VarGrade: Decimal;
    begin
        VarGrade := 0;

        rStEducationCountry.Reset;
        rStEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStEducationCountry.SetRange(Level, rStEducationCountry.Level::Secondary);
        rStEducationCountry.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        if rStEducationCountry.FindFirst then
            varId := rStEducationCountry."Sorting ID";

        rStEducationCountry.Reset;
        rStEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStEducationCountry.SetRange(Level, rStEducationCountry.Level::Secondary);
        rStEducationCountry.SetRange("Sorting ID", varId - 2);
        if rStEducationCountry.FindFirst then;


        rAssessingStudents.Reset;
        rAssessingStudents.SetRange("Schooling Year", rStEducationCountry."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
        if rAssessingStudents.Find('-') then begin
            repeat
                if rAssessingStudents.Grade > VarGrade then
                    VarGrade := rAssessingStudents.Grade;

            until rAssessingStudents.Next = 0;
        end;

        exit(VarGrade);
    end;


    procedure CalcAprove(pRulesEvaluations: Record "Rules of Evaluations"; pAssessingStudents: Record "Assessing Students")
    var
        rStruEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        rAssessingStudents: Record "Assessing Students";
    begin


        Clear(VarDecValor1);
        if SchoolingYearOption(pRulesEvaluations."Value 1") = pAssessingStudents."Schooling Year" then
            VarDecValor1 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 1"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor1 then
                        VarDecValor1 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarDecValor2);
        if SchoolingYearOption(pRulesEvaluations."Value 2") = pAssessingStudents."Schooling Year" then
            VarDecValor2 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 2"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor2 then
                        VarDecValor2 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarDecValor3);
        if SchoolingYearOption(pRulesEvaluations."Value 3") = pAssessingStudents."Schooling Year" then
            VarDecValor3 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 3"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor3 then
                        VarDecValor3 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarDecValor4);
        if SchoolingYearOption(pRulesEvaluations."Value 4") = pAssessingStudents."Schooling Year" then
            VarDecValor4 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 4"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor4 then
                        VarDecValor4 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarDecValor5);
        if SchoolingYearOption(pRulesEvaluations."Value 5") = pAssessingStudents."Schooling Year" then
            VarDecValor5 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 5"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor5 then
                        VarDecValor5 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarDecValor6);
        if SchoolingYearOption(pRulesEvaluations."Value 6") = pAssessingStudents."Schooling Year" then
            VarDecValor6 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."Value 6"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarDecValor6 then
                        VarDecValor6 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;

        Clear(VarNOTDecValor1);
        if SchoolingYearOption(pRulesEvaluations."And Value 1") = pAssessingStudents."Schooling Year" then
            VarNOTDecValor1 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."And Value 1"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarNOTDecValor1 then
                        VarNOTDecValor1 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;


        Clear(VarNOTDecValor2);
        if SchoolingYearOption(pRulesEvaluations."And Value 2") = pAssessingStudents."Schooling Year" then
            VarNOTDecValor2 := pAssessingStudents.Grade
        else begin
            rAssessingStudents.Reset;
            rAssessingStudents.SetRange("Schooling Year", SchoolingYearOption(pRulesEvaluations."And Value 2"));
            rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
            if rAssessingStudents.Find('-') then begin
                repeat
                    if pAssessingStudents.Grade > VarNOTDecValor2 then
                        VarNOTDecValor2 := pAssessingStudents.Grade;
                until rAssessingStudents.Next = 0;
            end;
        end;
    end;


    procedure SchoolingYearOption(pOption: Option " ",CIF,CFD,C10,C11,C12,CE): Code[10]
    var
        rStruEducationCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
    begin

        if pOption = pOption::C10 then begin
            rStruEducationCountry.Reset;
            rStruEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEducationCountry.SetRange(Level, rStruEducationCountry.Level::Secondary);
            if rStruEducationCountry.FindFirst then
                exit(rStruEducationCountry."Schooling Year");
        end;

        if pOption = pOption::C11 then begin
            rStruEducationCountry.Reset;
            rStruEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEducationCountry.SetRange(Level, rStruEducationCountry.Level::Secondary);
            if rStruEducationCountry.Find('-') then begin
                rStruEducationCountry.Next;
                exit(rStruEducationCountry."Schooling Year");
            end;
        end;

        if pOption = pOption::C12 then begin
            rStruEducationCountry.Reset;
            rStruEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEducationCountry.SetRange(Level, rStruEducationCountry.Level::Secondary);
            if rStruEducationCountry.FindLast then
                exit(rStruEducationCountry."Schooling Year");
        end;
    end;


    procedure "*******SPAIN****************"()
    begin
    end;


    procedure CalcSubSubject(pAssessingStudents: Record "Assessing Students"; pClassificationGroupCode: Code[20])
    var
        rAssessingStudents: Record "Assessing Students";
        VarTotalPonder: Decimal;
        VarTotalGrade: Decimal;
        rAssStudents: Record "Assessing Students";
        rSPSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        rAssessementConfiguration: Record "Assessment Configuration";
        varPonderSettingRatting: Integer;
    begin



        VarTotalPonder := 0;
        VarTotalGrade := 0;


        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, pAssessingStudents.Class);
        rAssessingStudents.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rAssessingStudents.SetRange("Type Education", pAssessingStudents."Type Education");
        rAssessingStudents.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rAssessingStudents.SetRange("School Year", pAssessingStudents."School Year");
        rAssessingStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetFilter(Grade, '<>%1', 0);
        rAssessingStudents.SetFilter("Sub-Subject Code", '<>%1', '');
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        if rAssessingStudents.Find('-') then begin
            repeat
                if rAssessingStudents."Recuperation Grade" = 0 then begin
                    VarTotalGrade += GetSubSettingRattingPonder(rAssessingStudents) * rAssessingStudents.Grade;
                    VarTotalPonder += GetSubSettingRattingPonder(rAssessingStudents);
                end else begin
                    VarTotalGrade += GetSubSettingRattingPonder(rAssessingStudents) * rAssessingStudents."Recuperation Grade";
                    VarTotalPonder += GetSubSettingRattingPonder(rAssessingStudents);
                end;
            until rAssessingStudents.Next = 0;

            rAssessementConfiguration.Reset;
            rAssessementConfiguration.SetRange("School Year", pAssessingStudents."School Year");
            rAssessementConfiguration.SetRange(Type, pAssessingStudents."Type Education");
            rAssessementConfiguration.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
            if rAssessementConfiguration.FindFirst then;


            rAssStudents.Reset;
            rAssStudents.SetRange("School Year", pAssessingStudents."School Year");
            rAssStudents.SetRange(Class, pAssessingStudents.Class);
            rAssStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            rAssStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssStudents.SetRange("Sub-Subject Code", '');
            rAssStudents.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
            rAssStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssStudents.SetRange("Moment Code", pAssessingStudents."Moment Code");
            rAssStudents.SetRange("Type Education", pAssessingStudents."Type Education");
            if rAssStudents.FindFirst then begin
                rAssStudents.Grade := Round(VarTotalGrade / VarTotalPonder, rAssessementConfiguration."PA Subject Round Method");
                rAssStudents."Qualitative Grade" := ValidateAssessmentMixed(pClassificationGroupCode, rAssStudents.Grade);


                rAssStudents.Modify(true);
            end else begin
                rAssStudents.Init;
                rAssStudents.TransferFields(pAssessingStudents);
                rAssStudents."Sub-Subject Code" := '';
                rAssStudents.Grade := Round(VarTotalGrade / VarTotalPonder, rAssessementConfiguration."PA Subject Round Method");
                rAssStudents."Qualitative Grade" := ValidateAssessmentMixed(pClassificationGroupCode, rAssStudents.Grade);
                rAssStudents.Insert(true);
            end;
            exit;
        end;


        rAssessingStudents.Reset;
        rAssessingStudents.SetRange(Class, pAssessingStudents.Class);
        rAssessingStudents.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rAssessingStudents.SetRange("Type Education", pAssessingStudents."Type Education");
        rAssessingStudents.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rAssessingStudents.SetRange("School Year", pAssessingStudents."School Year");
        rAssessingStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rAssessingStudents.SetRange(Subject, pAssessingStudents.Subject);
        rAssessingStudents.SetFilter("Sub-Subject Code", '<>%1', '');
        rAssessingStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
        if rAssessingStudents.Find('-') then begin
            repeat
                if rAssessingStudents.Grade <> 0 then
                    exit

            until rAssessingStudents.Next = 0;
            rAssStudents.Reset;
            rAssStudents.SetRange("School Year", pAssessingStudents."School Year");
            rAssStudents.SetRange(Class, pAssessingStudents.Class);
            rAssStudents.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
            rAssStudents.SetRange(Subject, pAssessingStudents.Subject);
            rAssStudents.SetRange("Sub-Subject Code", '');
            rAssStudents.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
            rAssStudents.SetRange("Student Code No.", pAssessingStudents."Student Code No.");
            rAssStudents.SetRange("Moment Code", pAssessingStudents."Moment Code");
            rAssStudents.SetRange("Type Education", pAssessingStudents."Type Education");
            if rAssStudents.FindFirst then begin
                rAssStudents.Grade := 0;
                rAssStudents."Qualitative Grade" := '';
                rAssStudents.Modify(true);
            end;
        end;
    end;


    procedure ValidateSubSettingRatting(pAssessingStudents: Record "Assessing Students")
    var
        rSRSubSubjects: Record "Setting Ratings Sub-Subjects";
        Text001: Label 'There are no Setting Ratings for the selected moment';
    begin



        rSRSubSubjects.Reset;
        rSRSubSubjects.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rSRSubSubjects.SetRange("School Year", pAssessingStudents."School Year");
        rSRSubSubjects.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rSRSubSubjects.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rSRSubSubjects.SetRange("Subject Code", pAssessingStudents.Subject);
        rSRSubSubjects.SetRange("Sub-Subject Code", pAssessingStudents."Sub-Subject Code");
        rSRSubSubjects.SetRange(Type, rSRSubSubjects.Type::Header);
        rSRSubSubjects.SetRange("Type Education", pAssessingStudents."Type Education");
        if not rSRSubSubjects.FindFirst then
            Error(Text001);
    end;


    procedure ValidateSettingRatting(pAssessingStudents: Record "Assessing Students")
    var
        rSettingRatings: Record "Setting Ratings";
        Text001: Label 'There are no Setting Ratings for the selected moment';
    begin



        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rSettingRatings.SetRange("School Year", pAssessingStudents."School Year");
        rSettingRatings.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rSettingRatings.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rSettingRatings.SetRange("Subject Code", pAssessingStudents.Subject);
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        rSettingRatings.SetRange("Type Education", pAssessingStudents."Type Education");
        if not rSettingRatings.FindFirst then
            Error(Text001);
    end;


    procedure ValidateAssessmentMixed(pClassificationGroupCode: Code[20]; pGrade: Decimal) out: Code[20]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
    begin
        if rRankGroup.Get(pClassificationGroupCode) then;


        if rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification" then begin

            if pGrade <> 0 then begin
                rClassificationLevelMin.Reset;
                rClassificationLevelMin.SetCurrentKey("Id Ordination");
                rClassificationLevelMin.Ascending(true);
                rClassificationLevelMin.SetRange("Classification Group Code", pClassificationGroupCode);
                if rClassificationLevelMin.FindFirst then
                    VarMinValue := rClassificationLevelMin."Min Value";

                rClassificationLevelMax.Reset;
                rClassificationLevelMax.SetCurrentKey("Id Ordination");
                rClassificationLevelMax.Ascending(false);
                rClassificationLevelMax.SetRange("Classification Group Code", pClassificationGroupCode);
                if rClassificationLevelMax.FindFirst then
                    VarMaxValue := rClassificationLevelMax."Max Value";

                if (VarMinValue <= pGrade) and
                    (VarMaxValue >= pGrade) then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", pClassificationGroupCode);
                    rClassificationLevel.SetRange(Value, pGrade);
                    if rClassificationLevel.FindSet(false, false) then begin
                        exit(rClassificationLevel."Classification Level Code");
                    end;

                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", pClassificationGroupCode);
                    if rClassificationLevel.FindSet then begin
                        repeat
                            if (rClassificationLevel."Min Value" <= pGrade) and
                               (rClassificationLevel."Max Value" >= pGrade) then begin
                                exit(rClassificationLevel."Classification Level Code");
                            end;
                        until rClassificationLevel.Next = 0
                    end;

                end;
            end;
        end;
    end;


    procedure GetSubSettingRattingPonder(pAssessingStudents: Record "Assessing Students") Mponder: Integer
    var
        rSRSubSubjects: Record "Setting Ratings Sub-Subjects";
        Text001: Label 'There are no Setting Ratings for the selected moment';
    begin
        rSRSubSubjects.Reset;
        rSRSubSubjects.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rSRSubSubjects.SetRange("School Year", pAssessingStudents."School Year");
        rSRSubSubjects.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rSRSubSubjects.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rSRSubSubjects.SetRange("Subject Code", pAssessingStudents.Subject);
        rSRSubSubjects.SetRange("Sub-Subject Code", pAssessingStudents."Sub-Subject Code");
        rSRSubSubjects.SetRange(Type, rSRSubSubjects.Type::Header);
        rSRSubSubjects.SetRange("Type Education", pAssessingStudents."Type Education");
        if rSRSubSubjects.FindFirst then
            exit(rSRSubSubjects."Moment Ponder");
    end;


    procedure GetSettingRatting(pAssessingStudents: Record "Assessing Students"): Integer
    var
        rSettingRatings: Record "Setting Ratings";
        Text001: Label 'There are no Setting Ratings for the selected moment';
    begin
        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", pAssessingStudents."Moment Code");
        rSettingRatings.SetRange("School Year", pAssessingStudents."School Year");
        rSettingRatings.SetRange("Schooling Year", pAssessingStudents."Schooling Year");
        rSettingRatings.SetRange("Study Plan Code", pAssessingStudents."Study Plan Code");
        rSettingRatings.SetRange("Subject Code", pAssessingStudents.Subject);
        rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
        rSettingRatings.SetRange("Type Education", pAssessingStudents."Type Education");
        if rSettingRatings.FindFirst then
            exit(rSettingRatings."Moment Ponder");
    end;
}

