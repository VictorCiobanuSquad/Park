report 52870 "Subjects statistics Upper Sec"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SubjectsstatisticsUpperSec.rdlc';
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
            column(StatisticsCaption; StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                rCourseHeader.Reset;
                rCourseHeader.SetRange(Code, vCourse);
                if rCourseHeader.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, rCourseHeader.Code);
                    //Formation Component=FILTER(<>' '),Evaluation Type=FILTER(<>Qualitative&<>None Qualification)
                    rCourseLines.SetFilter("Formation Component", '<>%1', rCourseLines."Formation Component"::" ");
                    rCourseLines.SetFilter("Evaluation Type", '<>%1&<>%2', rCourseLines."Evaluation Type"::Qualitative,
                                                                        rCourseLines."Evaluation Type"::"None Qualification");
                    if rCourseLines.Find('-') then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetCurrentKey("Id Ordination");
                        rClassificationLevel.Ascending(false);
                        rClassificationLevel.SetRange("Classification Group Code", rCourseLines."Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            i := rClassificationLevel.Count;
                            i := i - 1;
                            repeat
                                if rClassificationLevel."Classification Level Code" <> Format(0) then begin
                                    vAvalTEXT[i] := rClassificationLevel."Description Level";
                                end else begin
                                    vAvalTEXT[21] := rClassificationLevel."Description Level";
                                end;
                                i := i - 1;
                            until rClassificationLevel.Next = 0;
                        end;
                        vAvalTEXT[22] := 'Total';
                    end;
                end;
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

                if ((vSchoolYear = '') or (vCourse = '')) and (vClass <> '') then begin
                    rClass.Reset;
                    rClass.SetRange(Class, vClass);
                    if rClass.Find('-') then begin
                        vSchoolYear := rClass."School Year";
                        vSchoolingYear := rClass."Schooling Year";
                        vCourse := rClass."Study Plan Code";
                    end;
                end;

                if ((vSchoolYear = '') and (vCourse = '') and (vClass = '')) then
                    Error(Text001);
                /*
                IF ((vSchoolYear = '') AND (vCourse <> '')) THEN
                  ERROR(Text001);
                
                IF ((vSchoolYear <> '') AND (vCourse = '')) THEN
                  ERROR(Text001);
                */

            end;
        }
        dataitem("Course Lines"; "Course Lines")
        {
            DataItemTableView = SORTING("Sorting ID") WHERE("Formation Component" = FILTER(<> " "), "Evaluation Type" = FILTER(<> Qualitative & <> "None Qualification"));
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
            column(vAvalTEXT_22_; vAvalTEXT[22])
            {
            }
            column(vAvalTEXT_6_; vAvalTEXT[6])
            {
            }
            column(vAvalTEXT_7s_; vAvalTEXT[7])
            {
            }
            column(vAvalTEXT_8_; vAvalTEXT[8])
            {
            }
            column(vAvalTEXT_9_; vAvalTEXT[9])
            {
            }
            column(vAvalTEXT_10_; vAvalTEXT[10])
            {
            }
            column(vAvalTEXT_11_; vAvalTEXT[11])
            {
            }
            column(vAvalTEXT_12_; vAvalTEXT[12])
            {
            }
            column(vAvalTEXT_13_; vAvalTEXT[13])
            {
            }
            column(vAvalTEXT_14_; vAvalTEXT[14])
            {
            }
            column(vAvalTEXT_15_; vAvalTEXT[15])
            {
            }
            column(vAvalTEXT_16_; vAvalTEXT[16])
            {
            }
            column(vAvalTEXT_17_; vAvalTEXT[17])
            {
            }
            column(vAvalTEXT_18_; vAvalTEXT[18])
            {
            }
            column(vAvalTEXT_19_; vAvalTEXT[19])
            {
            }
            column(vAvalTEXT_20_; vAvalTEXT[20])
            {
            }
            column(vAvalTEXT_21_; vAvalTEXT[21])
            {
            }
            column(Course_Lines__Course_Lines___Subject_Description_; "Course Lines"."Subject Description")
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
            column(vAvalCount_22_; vAvalCount[22])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_6_; vAvalCount[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_7_; vAvalCount[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_8_; vAvalCount[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_9_; vAvalCount[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_10_; vAvalCount[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_11_; vAvalCount[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_12_; vAvalCount[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_13_; vAvalCount[13])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_14_; vAvalCount[14])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_15_; vAvalCount[15])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_16_; vAvalCount[16])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_17_; vAvalCount[17])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_18_; vAvalCount[18])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_19_; vAvalCount[19])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_20_; vAvalCount[20])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_21_; vAvalCount[21])
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
            column(vAvalCountTotal_22_; vAvalCountTotal[22])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_7_; vAvalCountTotal[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_8_; vAvalCountTotal[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_9_; vAvalCountTotal[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_10_; vAvalCountTotal[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_11_; vAvalCountTotal[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_12_; vAvalCountTotal[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_13_; vAvalCountTotal[13])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_14_; vAvalCountTotal[14])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_15_; vAvalCountTotal[15])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_16_; vAvalCountTotal[16])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_17_; vAvalCountTotal[17])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_19_; vAvalCountTotal[19])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_19__Control1102058072; vAvalCountTotal[19])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_20_; vAvalCountTotal[20])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_1_; vAvalCountTotal[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_21_; vAvalCountTotal[21])
            {
                DecimalPlaces = 0 : 0;
            }
            column("Disciplinas_NívelCaption"; Disciplinas_NívelCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Course_Lines_Code; Code)
            {
            }
            column(Course_Lines_Line_No_; "Line No.")
            {
            }
            column(CourseLines_SortingID; "Sorting ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Course Lines"."Subject Code" <> vOldDisc then begin
                    Clear(vAvalCount);

                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", "Course Lines"."Assessment Code");
                    if rClassificationLevel.Find('-') then begin
                        repeat
                            if rClassificationLevel."Classification Level Code" <> Format(0) then begin
                                rAssessingStudents.Reset;
                                rAssessingStudents.SetFilter(Class, vClass);
                                rAssessingStudents.SetRange("School Year", vSchoolYear);
                                //rAssessingStudents.SETRANGE("Schooling Year",vSchoolingYear);
                                rAssessingStudents.SetRange(Subject, "Course Lines"."Subject Code");
                                rAssessingStudents.SetRange("Sub-Subject Code", '');
                                rAssessingStudents.SetRange("Study Plan Code", "Course Lines".Code);
                                rAssessingStudents.SetFilter("Moment Code", vMoment);
                                rAssessingStudents.SetRange("Type Education", rAssessingStudents."Type Education"::Multi);
                                Clear(vGrade);
                                Evaluate(vGrade, rClassificationLevel."Classification Level Code");
                                rAssessingStudents.SetRange(Grade, vGrade);
                                if rAssessingStudents.Find('-') then begin
                                    vAvalCount[rAssessingStudents.Grade] := rAssessingStudents.Count;
                                end;
                            end else begin
                                rAssessingStudents.Reset;
                                rAssessingStudents.SetFilter(Class, vClass);
                                rAssessingStudents.SetRange("School Year", vSchoolYear);
                                //rAssessingStudents.SETRANGE("Schooling Year",vSchoolingYear);
                                rAssessingStudents.SetRange(Subject, "Course Lines"."Subject Code");
                                rAssessingStudents.SetRange("Sub-Subject Code", '');
                                rAssessingStudents.SetRange("Study Plan Code", "Course Lines".Code);
                                rAssessingStudents.SetFilter("Moment Code", vMoment);
                                rAssessingStudents.SetRange("Type Education", rAssessingStudents."Type Education"::Multi);
                                rAssessingStudents.SetRange(Grade, 0);
                                if rAssessingStudents.Find('-') then begin
                                    vAvalCount[21] := rAssessingStudents.Count;
                                end;
                            end;
                        until rClassificationLevel.Next = 0;
                    end;

                    vAvalCount[22] := vAvalCount[1] +
                                      vAvalCount[2] +
                                      vAvalCount[3] +
                                      vAvalCount[4] +
                                      vAvalCount[5] +
                                      vAvalCount[6] +
                                      vAvalCount[7] +
                                      vAvalCount[8] +
                                      vAvalCount[9] +
                                      vAvalCount[10] +
                                      vAvalCount[11] +
                                      vAvalCount[12] +
                                      vAvalCount[13] +
                                      vAvalCount[14] +
                                      vAvalCount[15] +
                                      vAvalCount[16] +
                                      vAvalCount[17] +
                                      vAvalCount[18] +
                                      vAvalCount[19] +
                                      vAvalCount[20] +
                                      vAvalCount[21];
                end;

                vOldDisc := "Course Lines"."Subject Code";
                // Body Sections, starttest
                vAvalCountTotal[1] := vAvalCountTotal[1] + vAvalCount[1];
                vAvalCountTotal[2] := vAvalCountTotal[2] + vAvalCount[2];
                vAvalCountTotal[3] := vAvalCountTotal[3] + vAvalCount[3];
                vAvalCountTotal[4] := vAvalCountTotal[4] + vAvalCount[4];
                vAvalCountTotal[5] := vAvalCountTotal[5] + vAvalCount[5];
                vAvalCountTotal[6] := vAvalCountTotal[6] + vAvalCount[6];
                vAvalCountTotal[7] := vAvalCountTotal[7] + vAvalCount[7];
                vAvalCountTotal[8] := vAvalCountTotal[8] + vAvalCount[8];
                vAvalCountTotal[9] := vAvalCountTotal[9] + vAvalCount[9];
                vAvalCountTotal[10] := vAvalCountTotal[10] + vAvalCount[10];
                vAvalCountTotal[11] := vAvalCountTotal[11] + vAvalCount[11];
                vAvalCountTotal[12] := vAvalCountTotal[12] + vAvalCount[12];
                vAvalCountTotal[13] := vAvalCountTotal[13] + vAvalCount[13];
                vAvalCountTotal[14] := vAvalCountTotal[14] + vAvalCount[14];
                vAvalCountTotal[15] := vAvalCountTotal[15] + vAvalCount[15];
                vAvalCountTotal[16] := vAvalCountTotal[16] + vAvalCount[16];
                vAvalCountTotal[17] := vAvalCountTotal[17] + vAvalCount[17];
                vAvalCountTotal[18] := vAvalCountTotal[18] + vAvalCount[18];
                vAvalCountTotal[19] := vAvalCountTotal[19] + vAvalCount[19];
                vAvalCountTotal[20] := vAvalCountTotal[20] + vAvalCount[20];
                vAvalCountTotal[21] := vAvalCountTotal[21] + vAvalCount[21];
                vAvalCountTotal[22] := vAvalCountTotal[22] + vAvalCount[22];
                // Body Sections, endtest
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Code, vCourse);
            end;
        }
        dataitem(CourseLines2; "Course Lines")
        {
            DataItemTableView = SORTING("Sorting ID") WHERE("Curriculum Type" = FILTER("Non disciplinary"));
            column(vAvalTEXT_1__Control1102058081; vAvalTEXT[1])
            {
            }
            column(vAvalTEXT_2__Control1102058082; vAvalTEXT[2])
            {
            }
            column(vAvalTEXT_3__Control1102058083; vAvalTEXT[3])
            {
            }
            column(vAvalTEXT_22__Control1102058086; vAvalTEXT[22])
            {
            }
            column(CourseLines2_CourseLines2__Subject_Description_; CourseLines2."Subject Description")
            {
            }
            column(vAvalCount_1__Control1102058105; vAvalCount[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_2__Control1102058106; vAvalCount[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_3__Control1102058107; vAvalCount[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCount_22__Control1102058110; vAvalCount[22])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_2__Control1102058127; vAvalCountTotal[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_3__Control1102058128; vAvalCountTotal[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_22__Control1102058132; vAvalCountTotal[22])
            {
                DecimalPlaces = 0 : 0;
            }
            column(vAvalCountTotal_1__Control1102058148; vAvalCountTotal[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column("Disciplinas_NívelCaption_Control1102058080"; Disciplinas_NívelCaption_Control1102058080Lbl)
            {
            }
            column(TotalCaption_Control1102058133; TotalCaption_Control1102058133Lbl)
            {
            }
            column(CourseLines2_Code; Code)
            {
            }
            column(CourseLines2_Line_No_; "Line No.")
            {
            }
            column(CourseLines2_SortingID; "Sorting ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if CourseLines2."Subject Code" <> vOldDisc then begin
                    Clear(vAvalCount);

                    rClassificationLevel.Reset;
                    rClassificationLevel.Ascending(false);
                    rClassificationLevel.SetRange("Classification Group Code", CourseLines2."Assessment Code");
                    if rClassificationLevel.Find('-') then begin
                        i := rClassificationLevel.Count;
                        repeat
                            rAssessingStudents.Reset;
                            rAssessingStudents.SetFilter(Class, vClass);
                            rAssessingStudents.SetRange("School Year", vSchoolYear);
                            rAssessingStudents.SetRange(Subject, CourseLines2."Subject Code");
                            rAssessingStudents.SetRange("Sub-Subject Code", '');
                            rAssessingStudents.SetRange("Study Plan Code", CourseLines2.Code);
                            rAssessingStudents.SetFilter("Moment Code", vMoment);
                            rAssessingStudents.SetRange("Type Education", rAssessingStudents."Type Education"::Multi);
                            rAssessingStudents.SetRange("Qualitative Grade", rClassificationLevel."Classification Level Code");
                            if rAssessingStudents.Find('-') then begin
                                vAvalCount[i] := rAssessingStudents.Count;
                            end;
                            i := i - 1
                       until rClassificationLevel.Next = 0;
                    end;

                    vAvalCount[22] := vAvalCount[1] +
                                      vAvalCount[2] +
                                      vAvalCount[3] +
                                      vAvalCount[4];
                    //vAvalCount[5] +
                    //vAvalCount[6] +
                    //vAvalCount[7] +
                    //vAvalCount[8] +
                    //vAvalCount[9] +
                    //vAvalCount[10] +
                    //vAvalCount[11] +
                    //vAvalCount[12] +
                    //vAvalCount[13] +
                    //vAvalCount[14] +
                    //vAvalCount[15] +
                    //vAvalCount[16] +
                    //vAvalCount[17] +
                    //vAvalCount[18] +
                    //vAvalCount[19] +
                    //vAvalCount[20] +
                    //vAvalCount[21];
                end;

                vOldDisc := CourseLines2."Subject Code";
                // Body Sections, starttest
                vAvalCountTotal[1] := vAvalCountTotal[1] + vAvalCount[1];
                vAvalCountTotal[2] := vAvalCountTotal[2] + vAvalCount[2];
                vAvalCountTotal[3] := vAvalCountTotal[3] + vAvalCount[3];
                vAvalCountTotal[4] := vAvalCountTotal[4] + vAvalCount[4];
                vAvalCountTotal[5] := vAvalCountTotal[5] + vAvalCount[5];
                vAvalCountTotal[6] := vAvalCountTotal[6] + vAvalCount[6];
                vAvalCountTotal[7] := vAvalCountTotal[7] + vAvalCount[7];
                vAvalCountTotal[8] := vAvalCountTotal[8] + vAvalCount[8];
                vAvalCountTotal[9] := vAvalCountTotal[9] + vAvalCount[9];
                vAvalCountTotal[10] := vAvalCountTotal[10] + vAvalCount[10];
                vAvalCountTotal[11] := vAvalCountTotal[11] + vAvalCount[11];
                vAvalCountTotal[12] := vAvalCountTotal[12] + vAvalCount[12];
                vAvalCountTotal[13] := vAvalCountTotal[13] + vAvalCount[13];
                vAvalCountTotal[14] := vAvalCountTotal[14] + vAvalCount[14];
                vAvalCountTotal[15] := vAvalCountTotal[15] + vAvalCount[15];
                vAvalCountTotal[16] := vAvalCountTotal[16] + vAvalCount[16];
                vAvalCountTotal[17] := vAvalCountTotal[17] + vAvalCount[17];
                vAvalCountTotal[18] := vAvalCountTotal[18] + vAvalCount[18];
                vAvalCountTotal[19] := vAvalCountTotal[19] + vAvalCount[19];
                vAvalCountTotal[20] := vAvalCountTotal[20] + vAvalCount[20];
                vAvalCountTotal[21] := vAvalCountTotal[21] + vAvalCount[21];
                vAvalCountTotal[22] := vAvalCountTotal[22] + vAvalCount[22];
                // Body Sections, endtest
            end;

            trigger OnPreDataItem()
            begin
                Clear(vAvalTEXT);
                Clear(vAvalCount);
                Clear(vAvalCountTotal);

                rCourseHeader.Reset;
                rCourseHeader.SetRange(Code, vCourse);
                if rCourseHeader.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, rCourseHeader.Code);
                    rCourseLines.SetRange("Curriculum Type", rCourseLines."Curriculum Type"::"Non disciplinary");
                    if rCourseLines.Find('-') then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetCurrentKey("Id Ordination");
                        rClassificationLevel.Ascending(false);
                        rClassificationLevel.SetRange("Classification Group Code", rCourseLines."Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            i := rClassificationLevel.Count;
                            repeat
                                vAvalTEXT[i] := rClassificationLevel."Description Level";
                                i := i - 1;
                            until rClassificationLevel.Next = 0;
                        end;
                        vAvalTEXT[22] := 'Total';
                    end;
                end;


                SetRange(Code, vCourse);
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
                            Caption = 'School Year';
                            TableRelation = "School Year"."School Year";
                        }
                        field(vCourse; vCourse)
                        {
                            ApplicationArea = All;
                            Caption = 'Course';
                            TableRelation = "Course Header".Code;
                        }
                        field(vClass; vClass)
                        {
                            ApplicationArea = All;
                            Caption = 'Class';
                            TableRelation = Class.Class;

                            trigger OnValidate()
                            begin
                                vClassOnAfterValidate;
                            end;
                        }
                        field(vMoment; vMoment)
                        {
                            ApplicationArea = All;
                            Caption = 'Moment';
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

        if vCourse <> '' then begin
            if vSchoolYear <> '' then
                Filtros := Filtros + ',' + vCourse
            else
                Filtros := vCourse;
        end;

        if vClass <> '' then begin
            if vCourse <> '' then begin
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
                if vCourse <> '' then begin
                    if vSchoolYear <> '' then
                        Filtros := Filtros + ',' + vMoment
                    else
                        Filtros := vMoment;
                end;
            end else begin
                if vCourse <> '' then begin
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
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rClassificationLevel: Record "Classification Level";
        rAssessingStudents: Record "Assessing Students";
        rClass: Record Class;
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        i: Integer;
        vAvalTEXT: array[23] of Text[30];
        vAvalCount: array[23] of Decimal;
        vAvalCountTotal: array[23] of Decimal;
        vOldDisc: Code[20];
        vGrade: Decimal;
        vSchoolYear: Code[9];
        vSchoolingYear: Code[10];
        vCourse: Code[20];
        vClass: Code[20];
        vMoment: Code[10];
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        cUserEducation: Codeunit "User Education";
        Text001: Label 'Tem de escolher o ano letivo e ano escolaridade ou então escolher a turma.';
        StatisticsCaptionLbl: Label 'Statistics';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        "Disciplinas_NívelCaptionLbl": Label 'Disciplinas/Nível';
        TotalCaptionLbl: Label 'Total';
        "Disciplinas_NívelCaption_Control1102058080Lbl": Label 'Disciplinas/Nível';
        TotalCaption_Control1102058133Lbl: Label 'Total';

    local procedure vClassOnAfterValidate()
    begin
        if ((vSchoolYear = '') or (vSchoolingYear = '')) and (vClass <> '') then begin
            rClass.Reset;
            rClass.SetRange(Class, vClass);
            if rClass.Find('-') then begin
                vSchoolYear := rClass."School Year";
                vCourse := rClass."Study Plan Code";
            end;
        end;
    end;
}

