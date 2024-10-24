report 52841 "Course Validation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CourseValidation.rdlc';
    Caption = 'Course Validation';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Course Header"; "Course Header")
        {
            DataItemTableView = SORTING(Code);
            column(Course_Header_Code; Code)
            {
            }
            column(Course_Header_Description; Description)
            {
            }
            column(varSchoolingYear; varSchoolingYear)
            {
            }
            column(Course_Header_CodeCaption; FieldCaption(Code))
            {
            }
            column(Course_Header_DescriptionCaption; FieldCaption(Description))
            {
            }
            dataitem(integer1; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(rCourseLinesTEMP__Subject_Code_; rCourseLinesTEMP."Subject Code")
                {
                }
                column(varSettingRatings; varSettingRatings)
                {
                }
                column(rCourseLinesTEMP__Legal_Code_; rCourseLinesTEMP."Legal Code")
                {
                }
                column(FORMAT_rCourseLinesTEMP__Evaluation_Type__; Format(rCourseLinesTEMP."Evaluation Type"))
                {
                }
                column(rCourseLinesTEMP__Assessment_Code_; rCourseLinesTEMP."Assessment Code")
                {
                }
                column(rCourseLinesTEMP__Option_Group_; rCourseLinesTEMP."Option Group")
                {
                }
                column(varAspects; varAspects)
                {
                }
                column("Codi_matèriaCaption"; Codi_matèriaCaptionLbl)
                {
                }
                column(Codi_legalCaption; Codi_legalCaptionLbl)
                {
                }
                column(Grup_assignaturesCaption; Grup_assignaturesCaptionLbl)
                {
                }
                column(Codi_de_notesCaption; Codi_de_notesCaptionLbl)
                {
                }
                column("Tipus_avaluacióCaption"; Tipus_avaluacióCaptionLbl)
                {
                }
                column(varAspectsCaption; varAspectsCaptionLbl)
                {
                }
                column(varSettingRatingsCaption; varSettingRatingsCaptionLbl)
                {
                }
                column(integer1_Number; Number)
                {
                }
                dataitem(StudyPlanSubSubjectsLines; "Study Plan Sub-Subjects Lines")
                {
                    DataItemTableView = SORTING(Type, Code, "Schooling Year", "Subject Code", "Sub-Subject Code");
                    column(StudyPlanSubSubjectsLines__Sub_Subject_Code_; "Sub-Subject Code")
                    {
                    }
                    column(StudyPlanSubSubjectsLines__Evaluation_Type_; "Evaluation Type")
                    {
                    }
                    column(StudyPlanSubSubjectsLines__Assessment_Code_; "Assessment Code")
                    {
                    }
                    column(varSettingRatings_Control1102065044; varSettingRatings)
                    {
                    }
                    column(varAspects_Control1102065045; varAspects)
                    {
                    }
                    column(StudyPlanSubSubjectsLines__Sub_Subject_Code_Caption; FieldCaption("Sub-Subject Code"))
                    {
                    }
                    column(StudyPlanSubSubjectsLines__Evaluation_Type_Caption; FieldCaption("Evaluation Type"))
                    {
                    }
                    column(StudyPlanSubSubjectsLines__Assessment_Code_Caption; FieldCaption("Assessment Code"))
                    {
                    }
                    column(varAspects_Control1102065045Caption; varAspects_Control1102065045CaptionLbl)
                    {
                    }
                    column(varSettingRatings_Control1102065044Caption; varSettingRatings_Control1102065044CaptionLbl)
                    {
                    }
                    column(StudyPlanSubSubjectsLines_Type; Type)
                    {
                    }
                    column(StudyPlanSubSubjectsLines_Code; Code)
                    {
                    }
                    column(StudyPlanSubSubjectsLines_Schooling_Year; "Schooling Year")
                    {
                    }
                    column(StudyPlanSubSubjectsLines_Subject_Code; "Subject Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        getSettingRatings(rCourseLinesTEMP."Subject Code", StudyPlanSubSubjectsLines."Sub-Subject Code");
                        GetAspects(rCourseLinesTEMP."Subject Code", StudyPlanSubSubjectsLines."Sub-Subject Code");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type, Type::Course);
                        SetRange(Code, rCourseLinesTEMP.Code);
                        SetRange("Schooling Year", varSchoolingYear);
                        SetRange("Subject Code", rCourseLinesTEMP."Subject Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if integer1.Number = 1 then
                        rCourseLinesTEMP.Find('-')
                    else
                        rCourseLinesTEMP.Next(1);
                    getSettingRatings(rCourseLinesTEMP."Subject Code", '');
                    GetAspects(rCourseLinesTEMP."Subject Code", '');
                end;

                trigger OnPreDataItem()
                begin
                    rCourseLinesTEMP.Reset;
                    VarNumber := rCourseLinesTEMP.Count;
                    integer1.SetRange(Number, 1, VarNumber);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                getSubjectsCourse;
            end;

            trigger OnPreDataItem()
            begin
                if (varCode <> '') and (vOption = vOption::Courses) then
                    SetRange(Code, varCode);
                if not (vOption = vOption::Courses) then
                    CurrReport.Break;
            end;
        }
        dataitem("Study Plan Header"; "Study Plan Header")
        {
            DataItemTableView = SORTING(Code);
            column(Study_Plan_Header_Description; Description)
            {
            }
            column(Study_Plan_Header_Code; Code)
            {
            }
            column(varSchoolingYear_Control1102065036; varSchoolingYear)
            {
            }
            column(Study_Plan_Header_CodeCaption; FieldCaption(Code))
            {
            }
            column(Study_Plan_Header_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Study_Plan_Header_Schooling_Year; "Schooling Year")
            {
            }
            dataitem("Study Plan Lines"; "Study Plan Lines")
            {
                DataItemLink = Code = FIELD(Code), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING(Code, "School Year", "Schooling Year", "Sorting ID");
                column(varSettingRatings_Control1102065032; varSettingRatings)
                {
                }
                column(varAspects_Control1102065034; varAspects)
                {
                }
                column(Study_Plan_Lines__Subject_Code_; "Subject Code")
                {
                }
                column(Study_Plan_Lines__Legal_Code_; "Legal Code")
                {
                }
                column(Study_Plan_Lines__Evaluation_Type_; "Evaluation Type")
                {
                }
                column(Study_Plan_Lines__Assessment_Code_; "Assessment Code")
                {
                }
                column(Study_Plan_Lines__Option_Group_; "Option Group")
                {
                }
                column(Study_Plan_Lines__Subject_Code_Caption; FieldCaption("Subject Code"))
                {
                }
                column(Study_Plan_Lines__Legal_Code_Caption; FieldCaption("Legal Code"))
                {
                }
                column(Study_Plan_Lines__Evaluation_Type_Caption; FieldCaption("Evaluation Type"))
                {
                }
                column(Study_Plan_Lines__Assessment_Code_Caption; FieldCaption("Assessment Code"))
                {
                }
                column(Study_Plan_Lines__Option_Group_Caption; FieldCaption("Option Group"))
                {
                }
                column(varSettingRatings_Control1102065032Caption; varSettingRatings_Control1102065032CaptionLbl)
                {
                }
                column(varAspects_Control1102065034Caption; varAspects_Control1102065034CaptionLbl)
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
                dataitem(StudyPlanSubSubjectsLines1; "Study Plan Sub-Subjects Lines")
                {
                    DataItemTableView = SORTING(Type, Code, "Schooling Year", "Subject Code", "Sub-Subject Code");
                    column(varSettingRatings_Control1102065050; varSettingRatings)
                    {
                    }
                    column(varAspects_Control1102065051; varAspects)
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Sub_Subject_Code_; "Sub-Subject Code")
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Evaluation_Type_; "Evaluation Type")
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Assessment_Code_; "Assessment Code")
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Sub_Subject_Code_Caption; FieldCaption("Sub-Subject Code"))
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Evaluation_Type_Caption; FieldCaption("Evaluation Type"))
                    {
                    }
                    column(StudyPlanSubSubjectsLines1__Assessment_Code_Caption; FieldCaption("Assessment Code"))
                    {
                    }
                    column(varAspects_Control1102065051Caption; varAspects_Control1102065051CaptionLbl)
                    {
                    }
                    column(varSettingRatings_Control1102065050Caption; varSettingRatings_Control1102065050CaptionLbl)
                    {
                    }
                    column(StudyPlanSubSubjectsLines1_Type; Type)
                    {
                    }
                    column(StudyPlanSubSubjectsLines1_Code; Code)
                    {
                    }
                    column(StudyPlanSubSubjectsLines1_Schooling_Year; "Schooling Year")
                    {
                    }
                    column(StudyPlanSubSubjectsLines1_Subject_Code; "Subject Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        getSettingRatings("Study Plan Lines"."Subject Code", StudyPlanSubSubjectsLines1."Sub-Subject Code");
                        GetAspects("Study Plan Lines"."Subject Code", StudyPlanSubSubjectsLines1."Sub-Subject Code");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type, Type::"Study Plan");
                        SetRange(Code, "Study Plan Lines".Code);
                        SetRange("Schooling Year", varSchoolingYear);
                        SetRange("Subject Code", "Study Plan Lines"."Subject Code");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    getSettingRatings("Study Plan Lines"."Subject Code", '');
                    GetAspects("Study Plan Lines"."Subject Code", '');
                end;
            }

            trigger OnPreDataItem()
            begin
                if (varCode <> '') and (vOption = vOption::"Study Plans") then
                    SetRange(Code, varCode);
                if not (vOption = vOption::"Study Plans") then
                    CurrReport.Break;
                SetRange("Schooling Year", varSchoolingYear);
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
                    field(vOption; vOption)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Type';
                        OptionCaption = 'Course,Study Plan';
                    }
                    field(varCode; varCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rStudyPlans: Record "Study Plan Header";
                            l_rCourses: Record "Course Header";
                        begin
                            varSchoolingYear := '';
                            SchoolingYearEditable := true;
                            if vOption = vOption::"Study Plans" then begin
                                l_rStudyPlans.Reset;
                                if l_rStudyPlans.FindSet then begin
                                    if PAGE.RunModal(PAGE::"Study Plan List", l_rStudyPlans) = ACTION::LookupOK then begin
                                        varCode := l_rStudyPlans.Code;
                                        varSchoolingYear := l_rStudyPlans."Schooling Year";
                                        SchoolingYearEditable := false;
                                    end;
                                end;
                            end else
                                if vOption = vOption::Courses then begin
                                    l_rCourses.Reset;
                                    if l_rCourses.FindSet then begin
                                        if PAGE.RunModal(PAGE::"Course List", l_rCourses) = ACTION::LookupOK then
                                            varCode := l_rCourses.Code;
                                    end;
                                end;
                        end;
                    }
                    field(SchoolingYear; varSchoolingYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Schooling Year';
                        Editable = SchoolingYearEditable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if SchoolingYearEditable then
                                if PAGE.RunModal(PAGE::"Structure Education country", rStruEduCountry) = ACTION::LookupOK then begin
                                    varSchoolingYear := rStruEduCountry."Schooling Year";
                                end;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SchoolingYearEditable := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (varCode = '') or (varSchoolingYear = '') then
            Error(text001);
    end;

    var
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rCourseLines: Record "Course Lines";
        rStruEduCountry: Record "Structure Education Country";
        rSettingRatings: Record "Setting Ratings";
        rAspects: Record Aspects;
        cStudentsRegistration: Codeunit "Students Registration";
        varSchoolingYear: Code[20];
        varCode: Code[20];
        VarNumber: Integer;
        vOption: Option Courses,"Study Plans";
        text001: Label 'All fields must be filled.';
        varSettingRatings: Text[250];
        varAspects: Text[250];
        [InDataSet]
        SchoolingYearEditable: Boolean;
        Text19071249: Label 'Report Type';
        "Codi_matèriaCaptionLbl": Label 'Subject Code';
        Codi_legalCaptionLbl: Label 'Legal Code';
        Grup_assignaturesCaptionLbl: Label 'Subject Group';
        Codi_de_notesCaptionLbl: Label 'Assessment Code';
        "Tipus_avaluacióCaptionLbl": Label 'Evaluation Type';
        varAspectsCaptionLbl: Label 'Aspects';
        varSettingRatingsCaptionLbl: Label 'Setting Ratings';
        varAspects_Control1102065045CaptionLbl: Label 'Aspects';
        varSettingRatings_Control1102065044CaptionLbl: Label 'Setting Ratings';
        varSettingRatings_Control1102065032CaptionLbl: Label 'Setting Ratings';
        varAspects_Control1102065034CaptionLbl: Label 'Aspects';
        varAspects_Control1102065051CaptionLbl: Label 'Aspects';
        varSettingRatings_Control1102065050CaptionLbl: Label 'Setting Ratings';


    procedure getSubjectsCourse()
    var
        l_rStruEduCountry: Record "Structure Education Country";
    begin
        rCourseLinesTEMP.Reset;
        rCourseLinesTEMP.DeleteAll;

        //Quadriennal
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, "Course Header".Code);
        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
        if rCourseLines.Find('-') then begin
            repeat
                rCourseLinesTEMP.Init;
                rCourseLinesTEMP.TransferFields(rCourseLines);
                rCourseLinesTEMP.Insert;
            until rCourseLines.Next = 0;
        end;

        //Anual
        rCourseLines.Reset;
        rCourseLines.SetRange(Code, "Course Header".Code);
        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
        rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
        if rCourseLines.Find('-') then begin
            repeat
                rCourseLinesTEMP.Init;
                rCourseLinesTEMP.TransferFields(rCourseLines);
                rCourseLinesTEMP.Insert;
            until rCourseLines.Next = 0;
        end;

        //Bienal E Triennal
        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.Find('-') then begin
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, "Course Header".Code);
            rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
            rCourseLines."Characterise Subjects"::Triennial);
            rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
            if rCourseLines.Find('-') then begin
                repeat
                    rCourseLinesTEMP.Init;
                    rCourseLinesTEMP.TransferFields(rCourseLines);
                    rCourseLinesTEMP.Insert;
                until rCourseLines.Next = 0;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", rStruEduCountry."Sorting ID" - 1);
            if l_rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, "Course Header".Code);
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", rStruEduCountry."Sorting ID" - 2);
            if l_rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, "Course Header".Code);
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;
            end;
            l_rStruEduCountry.Reset;
            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            l_rStruEduCountry.SetRange("Sorting ID", rStruEduCountry."Sorting ID" - 1);
            if l_rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, "Course Header".Code);
                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                if rCourseLines.Find('-') then begin
                    repeat
                        rCourseLinesTEMP.Init;
                        rCourseLinesTEMP.TransferFields(rCourseLines);
                        rCourseLinesTEMP.Insert;
                    until rCourseLines.Next = 0;
                end;
            end;
        end;
    end;


    procedure getSettingRatings(varSubject: Code[20]; varSubSubject: Code[20])
    begin
        Clear(varSettingRatings);
        rSettingRatings.Reset;
        rSettingRatings.SetCurrentKey("Moment Code",
                                      "School Year",
                                      "Schooling Year",
                                      "Study Plan Code",
                                      "Subject Code",
                                      Type,
                                      "Type Education",
                                      "Line No.");
        rSettingRatings.SetRange("Schooling Year", varSchoolingYear);
        rSettingRatings.SetRange("Study Plan Code", varCode);
        rSettingRatings.SetRange("Subject Code", varSubject);
        rSettingRatings.SetRange("School Year", cStudentsRegistration.GetShoolYearActive);
        if rSettingRatings.FindSet then begin
            repeat
                if varSettingRatings = '' then
                    varSettingRatings := rSettingRatings."Moment Code"
                else
                    varSettingRatings += (',' + rSettingRatings."Moment Code");
            until rSettingRatings.Next = 0;
        end;
    end;


    procedure GetAspects(varSubject: Code[20]; varSubSubject: Code[20])
    var
        LastMoment: Code[20];
    begin
        Clear(varAspects);

        rAspects.Reset;
        if vOption = vOption::Courses then
            rAspects.SetRange(Type, rAspects.Type::Course)
        else
            rAspects.SetRange(Type, rAspects.Type::"Study Plan");
        rAspects.SetRange("Schooling Year", varSchoolingYear);
        rAspects.SetRange(Subjects, varSubject);
        rAspects.SetRange("Type No.", varCode);
        rAspects.SetRange("Sub Subjects", varSubSubject);
        rAspects.SetRange("School Year", cStudentsRegistration.GetShoolYearActive);
        if rAspects.FindSet then begin
            repeat
                if LastMoment <> rAspects."Moment Code" then begin
                    varAspects += (' ' + rAspects."Moment Code" + '-' + rAspects.Code)
                end else begin
                    if varAspects = '' then
                        varAspects := (rAspects."Moment Code" + '-' + rAspects.Code)
                    else
                        varAspects += (',' + rAspects."Moment Code" + '-' + rAspects.Code)
                end;
                LastMoment := rAspects."Moment Code";
            until rAspects.Next = 0;
        end;
    end;
}

