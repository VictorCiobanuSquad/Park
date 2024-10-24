#pragma implicitwith disable
page 52917 "Select Previous Years"
{
    Caption = 'Select previous years';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Assessing Students" = rimd;
    SourceTable = "Registration Subjects";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Select previous years")
            {
                Caption = 'Select previous years';
                field(VarStudentCode; VarStudentCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student Code No.';
                    Editable = false;
                }
                field(VarSchoolYear; VarSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    Editable = false;
                    TableRelation = "School Year"."School Year";
                }
                field(VarStudyPlanCode; VarStudyPlanCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Course';
                    TableRelation = "Course Header".Code;
                }
                field(varSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Multi));

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_StruEduCountryTEMP: Record "Structure Education Country" temporary;
                    begin
                        rStruEduCountry.Reset;
                        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                        if rStruEduCountry.FindFirst then;

                        rStruEduCountry2.Reset;
                        rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                        if rStruEduCountry2.FindSet then begin
                            repeat
                                l_StruEduCountryTEMP.Init;
                                l_StruEduCountryTEMP.TransferFields(rStruEduCountry2);
                                l_StruEduCountryTEMP.Insert;
                            until rStruEduCountry2.Next = 0;
                        end;


                        if PAGE.RunModal(PAGE::"Structure Education country", l_StruEduCountryTEMP) = ACTION::LookupOK then
                            varSchoolingYear := l_StruEduCountryTEMP."Schooling Year";

                        GetSubjects;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        rStruEduCountry.Reset;
                        rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                        if rStruEduCountry.FindFirst then;

                        rStruEduCountry2.Reset;
                        rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                        rStruEduCountry2.SetRange("Schooling Year", varSchoolingYear);
                        if not rStruEduCountry2.FindSet then
                            Error(Text0014);

                        if VarStudyPlanCode <> '' then
                            GetSubjects;
                        varSchoolingYearOnAfterValidat;
                    end;
                }
                field(varMixedClassification; varMixedClassification)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Filter Mixed Ratings';

                    trigger OnValidate()
                    begin
                        varMixedClassificationOnPush;
                    end;
                }
            }
            repeater(TableBoxMoments)
            {
                field(Enroled; Rec.Enroled)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Select';

                    trigger OnValidate()
                    var
                        l_RegSubjects: Record "Registration Subjects";
                    begin
                        l_RegSubjects.Reset;
                        l_RegSubjects.SetRange("Student Code No.", VarStudentCode);
                        l_RegSubjects.SetRange("School Year", VarSchoolYear);
                        l_RegSubjects.SetRange("Schooling Year", varSchoolingYear);
                        l_RegSubjects.SetRange("Subjects Code", Rec."Subjects Code");
                        l_RegSubjects.SetRange("Responsibility Center", Rec."Responsibility Center");
                        if l_RegSubjects.Find('-') then
                            Error(text008);
                    end;
                }
                field("Subjects Code"; Rec."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Txt1; vText[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(1);
                    Editable = false;
                    Visible = Txt1Visible;
                }
                field(Txt2; vText[2])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(2);
                    Editable = false;
                    Visible = Txt2Visible;
                }
                field(Txt3; vText[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(3);
                    Editable = false;
                    Visible = Txt3Visible;
                }
                field(Txt4; vText[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(4);
                    Editable = false;
                    Visible = Txt4Visible;
                }
                field(Txt5; vText[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(5);
                    Editable = false;
                    Visible = Txt5Visible;
                }
                field(Txt6; vText[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(6);
                    Editable = false;
                    Visible = Txt6Visible;
                }
                field(Txt7; vText[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(7);
                    Editable = false;
                    Visible = Txt7Visible;
                }
                field(Txt8; vText[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(8);
                    Editable = false;
                    Visible = Txt8Visible;
                }
                field(Txt9; vText[9])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(9);
                    Editable = false;
                    Visible = Txt9Visible;
                }
                field(Txt10; vText[10])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(10);
                    Editable = false;
                    Visible = Txt10Visible;
                }
                field(Txt11; vText[11])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(11);
                    Editable = false;
                    Visible = Txt11Visible;
                }
                field(Txt12; vText[12])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(12);
                    Editable = false;
                    Visible = Txt12Visible;
                }
                field(Txt13; vText[13])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(13);
                    Editable = false;
                    Visible = Txt13Visible;
                }
                field(Txt14; vText[14])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(14);
                    Editable = false;
                    Visible = Txt14Visible;
                }
                field(Txt15; vText[15])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(15);
                    Editable = false;
                    Visible = Txt15Visible;
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field("rStudents.Name"; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(VarOriginalStudyPlanCode; VarOriginalStudyPlanCode)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin

                        GetSubjects;
                        VarOriginalStudyPlanCodeOnAfte;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post")
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Register;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        Rec.Reset;
        Rec.SetRange("Student Code No.", VarStudentCode);
        Rec.SetFilter("School Year", VarSchoolYear);

        UpdateForm;
        InsertColunm;
        VisibleFuction;
    end;

    trigger OnInit()
    begin
        Txt15Visible := true;
        Txt14Visible := true;
        Txt13Visible := true;
        Txt12Visible := true;
        Txt11Visible := true;
        Txt10Visible := true;
        Txt9Visible := true;
        Txt8Visible := true;
        Txt7Visible := true;
        Txt6Visible := true;
        Txt5Visible := true;
        Txt4Visible := true;
        Txt3Visible := true;
        Txt2Visible := true;
        Txt1Visible := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        if VarStudyPlanCode <> '' then
            GetSubjects;

        UpdateForm;
    end;

    var
        VarSchoolYear: Code[9];
        varSchoolingYear: Code[10];
        VarStudentCode: Code[20];
        VarStudyPlanCode: Code[20];
        VarOriginalStudyPlanCode: Code[20];
        vText: array[15] of Text[250];
        varName: Text[100];
        vArraySchoolYear: array[15] of Text[30];
        vArrayMomentCode: array[15] of Text[30];
        indx: Integer;
        rStudents: Record Students;
        cStudentsRegistration: Codeunit "Students Registration";
        rStudyPlanLines: Record "Study Plan Lines";
        rAssessementStudents: Record "Assessement Students";
        cUserEducation: Codeunit "User Education";
        VarType: Option Simple,Multi;
        rCourseLines: Record "Course Lines";
        varLineNo: Integer;
        rStruEduCountry: Record "Structure Education Country";
        text008: Label 'The Subjects is already in the Student Study Plan';
        text009: Label 'Operation finished';
        VarTempSchoolYear: Code[9];
        varMixedClassification: Boolean;
        text010: Label 'There is Nothing to Post.';
        rStruEduCountry2: Record "Structure Education Country";
        Text0014: Label 'Wrong Schooling Year.';
        text011: Label 'The Student must have a Study Plan/Course Code on his Registration Card before being subscribed.';
        [InDataSet]
        Txt1Visible: Boolean;
        [InDataSet]
        Txt2Visible: Boolean;
        [InDataSet]
        Txt3Visible: Boolean;
        [InDataSet]
        Txt4Visible: Boolean;
        [InDataSet]
        Txt5Visible: Boolean;
        [InDataSet]
        Txt6Visible: Boolean;
        [InDataSet]
        Txt7Visible: Boolean;
        [InDataSet]
        Txt8Visible: Boolean;
        [InDataSet]
        Txt9Visible: Boolean;
        [InDataSet]
        Txt10Visible: Boolean;
        [InDataSet]
        Txt11Visible: Boolean;
        [InDataSet]
        Txt12Visible: Boolean;
        [InDataSet]
        Txt13Visible: Boolean;
        [InDataSet]
        Txt14Visible: Boolean;
        [InDataSet]
        Txt15Visible: Boolean;


    procedure getCaptionLabel(label: Integer) out: Text[30]
    begin

        exit(vArraySchoolYear[label]);
    end;


    procedure BuildMoments()
    var
        rAssessingStudents: Record "Assessing Students";
    begin


        Clear(vArraySchoolYear);
        Clear(vArrayMomentCode);
        Clear(VarTempSchoolYear);
        indx := 0;


        rAssessingStudents.Reset;
        rAssessingStudents.SetCurrentKey("School Year", "Schooling Year", "Evaluation Moment");
        rAssessingStudents.SetRange("Student Code No.", VarStudentCode);
        rAssessingStudents.SetRange("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
        if rAssessingStudents.Find('-') then begin
            indx := 1;
            repeat
                if rAssessingStudents."School Year" <> VarTempSchoolYear then begin
                    VarTempSchoolYear := rAssessingStudents."School Year";
                    vArraySchoolYear[indx] := rAssessingStudents."School Year";
                    vArrayMomentCode[indx] := rAssessingStudents."Moment Code";
                    indx += 1;
                end;
            until rAssessingStudents.Next = 0;
        end;
    end;


    procedure GetAssessment(inStudentCode: Code[20]; inIndex: Integer; inText: Text[250]) Out: Text[100]
    var
        rAssessingStudents: Record "Assessing Students";
    begin


        rAssessingStudents.Reset;
        rAssessingStudents.SetFilter("School Year", vArraySchoolYear[inIndex]);
        rAssessingStudents.SetFilter("Schooling Year", varSchoolingYear);
        rAssessingStudents.SetFilter(Subject, Rec."Subjects Code");
        rAssessingStudents.SetFilter("Sub-Subject Code", '');
        rAssessingStudents.SetFilter("Study Plan Code", VarStudyPlanCode);
        rAssessingStudents.SetFilter("Student Code No.", VarStudentCode);
        rAssessingStudents.SetRange("Evaluation Moment", rAssessingStudents."Evaluation Moment"::"Final Year");
        rAssessingStudents.SetFilter("Moment Code", vArrayMomentCode[inIndex]);
        if rAssessingStudents.Find('-') then begin
            if (rAssessingStudents."Qualitative Grade" <> '') and (rAssessingStudents.Grade <> 0) then begin
                if varMixedClassification then
                    if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                        exit(Format(rAssessingStudents."Recuperation Grade"))
                    else
                        exit(Format(rAssessingStudents.Grade))
                else
                    if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                        exit(rAssessingStudents."Recuperation Qualitative Grade")
                    else
                        exit(rAssessingStudents."Qualitative Grade");
            end;
            if (rAssessingStudents."Qualitative Grade" <> '') and (rAssessingStudents.Grade = 0) then begin
                if (rAssessingStudents."Recuperation Qualitative Grade" <> '') and (rAssessingStudents."Recuperation Grade" = 0) then
                    exit(rAssessingStudents."Recuperation Qualitative Grade")
                else
                    exit(rAssessingStudents."Qualitative Grade");
            end;
            if (rAssessingStudents."Qualitative Grade" = '') and (rAssessingStudents.Grade <> 0) then begin
                if (rAssessingStudents."Recuperation Qualitative Grade" = '') and (rAssessingStudents."Recuperation Grade" <> 0) then
                    exit(Format(rAssessingStudents."Recuperation Grade"))
                else
                    exit(Format(rAssessingStudents.Grade));
            end;
        end else
            exit('');
    end;


    procedure InsertColunm()
    var
        i: Integer;
    begin
        i := 0;

        repeat
            i += 1;
            if vArraySchoolYear[i] <> '' then
                vText[i] := GetAssessment(VarStudentCode, i, vText[i]);
        until i = 15
    end;


    procedure UpdateForm()
    begin
        BuildMoments;
    end;


    procedure GetInfo(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pStudentCode: Code[20]; pStudyPlanCode: Code[20])
    begin
        VarSchoolYear := pSchoolYear;
        varSchoolingYear := pSchoolingYear;
        VarStudentCode := pStudentCode;
        VarStudyPlanCode := pStudyPlanCode;

        VarOriginalStudyPlanCode := pStudyPlanCode;


        if rStudents.Get(VarStudentCode) then;
    end;


    procedure GetSubjects()
    var
        l_rStruEduCountry: Record "Structure Education Country";
    begin
        Rec.Reset;
        Rec.SetRange("User Session ID", UserId);
        if Rec.Find('-') then
            Rec.DeleteAll;

        if varSchoolingYear <> '' then begin
            // Quadriennal
            varLineNo := 10000;
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, VarStudyPlanCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
            if rCourseLines.Find('-') then begin
                repeat
                    InsertSubjects(rCourseLines);
                    varLineNo += 10000;
                until rCourseLines.Next = 0;
            end;

            //Annual
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, VarStudyPlanCode);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
            rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
            if rCourseLines.Find('-') then begin
                repeat
                    InsertSubjects(rCourseLines);
                    varLineNo += 10000;
                until rCourseLines.Next = 0;
            end;


            //Biennial

            rStruEduCountry.Reset;
            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
            if rStruEduCountry.Find('-') then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, VarStudyPlanCode);
                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                        rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear);
                if rCourseLines.Find('-') then begin
                    repeat
                        InsertSubjects(rCourseLines);
                        varLineNo += 10000;
                    until rCourseLines.Next = 0;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            InsertSubjects(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 2);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            InsertSubjects(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry - 1);
                if l_rStruEduCountry.Find('-') then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlanCode);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.Find('-') then begin
                        repeat
                            InsertSubjects(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
            end;

        end;
    end;


    procedure InsertSubjects(pCourseLines: Record "Course Lines")
    var
        l_recRegSubServ: Record "Registration Subjects";
        l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
    begin


        Rec.Init;
        Rec."Student Code No." := VarStudentCode;
        Rec."School Year" := VarSchoolYear;
        Rec."Line No." := varLineNo;
        Rec."Schooling Year" := varSchoolingYear;
        Rec."Study Plan Code" := pCourseLines.Code;
        Rec."Subjects Code" := pCourseLines."Subject Code";
        Rec.Description := pCourseLines."Subject Description";
        Rec."Country/Region Code" := cStudentsRegistration.GetCountry;
        Rec."Responsibility Center" := pCourseLines."Responsibility Center";
        Rec."Mandatory/Optional Type" := pCourseLines."Mandatory/Optional Type";
        Rec."Curriculum Type" := pCourseLines."Curriculum Type";
        Rec."Evaluation Type" := pCourseLines."Evaluation Type";
        Rec."Country/Region Code" := cStudentsRegistration.GetCountry;
        Rec."Responsibility Center" := pCourseLines."Responsibility Center";
        Rec."Maximum Injustified Absence" := pCourseLines."Maximum Unjustified Absences";
        Rec."Assessment Code" := pCourseLines."Assessment Code";
        Rec."Option Group" := pCourseLines."Option Group";
        Rec."Formation Component" := pCourseLines."Formation Component";
        Rec."Characterise Subjects" := pCourseLines."Characterise Subjects";
        Rec."Country/Region Code" := pCourseLines."Country/Region Code";
        Rec."Maximum Justified Absence" := pCourseLines."Maximum Justified Absence";
        Rec.Type := Rec.Type::Multi;
        Rec."User Session ID" := UserId;
        Rec."Original Line No." := pCourseLines."Line No.";
        Rec."Minimum Classification Level" := pCourseLines."Minimum Classification Level";
        Rec."Continuous Assessment" := pCourseLines."Continuous Assessment";
        Rec.Insert;
    end;


    procedure GetNoStructureCountry(): Integer
    begin

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if varSchoolingYear = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;


    procedure Register()
    var
        rRegSubjects: Record "Registration Subjects";
        SPSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        StudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        l_rRegistration: Record Registration;
    begin
        l_rRegistration.Reset;
        l_rRegistration.SetRange("Student Code No.", Rec."Student Code No.");
        if Rec.Type = Rec.Type::Simple then
            l_rRegistration.SetRange("Study Plan Code", VarStudyPlanCode)
        else
            l_rRegistration.SetRange(Course, VarStudyPlanCode);
        if l_rRegistration.FindFirst then begin
            Rec.Reset;
            Rec.SetRange(Enroled, true);
            Rec.SetRange("User Session ID", UserId);
            if Rec.Find('-') then begin
                repeat
                    rRegSubjects.TransferFields(Rec);
                    rRegSubjects."Line No." := GetLastLineNo;
                    rRegSubjects.Validate(Enroled, true);
                    rRegSubjects.Insert(true);
                    SPSubSubjectsLines.Reset;

                    SPSubSubjectsLines.SetRange("Subject Code", Rec."Subjects Code");
                    SPSubSubjectsLines.SetRange("Responsibility Center", Rec."Responsibility Center");
                    if Rec.Type = Rec.Type::Simple then begin
                        SPSubSubjectsLines.SetRange(Type, SPSubSubjectsLines.Type::"Study Plan");
                        SPSubSubjectsLines.SetRange("School Year", Rec."School Year");
                    end;
                    if Rec.Type = Rec.Type::Multi then
                        SPSubSubjectsLines.SetRange(Type, SPSubSubjectsLines.Type::Course);
                    SPSubSubjectsLines.SetRange(Code, Rec."Study Plan Code");
                    SPSubSubjectsLines.SetRange("Schooling Year", Rec."Schooling Year");
                    if SPSubSubjectsLines.Find('-') then begin
                        repeat
                            StudentSubSubjectsPlan.Init;
                            StudentSubSubjectsPlan."Student Code No." := Rec."Student Code No.";
                            StudentSubSubjectsPlan."School Year" := Rec."School Year";
                            StudentSubSubjectsPlan."Subject Code" := SPSubSubjectsLines."Subject Code";
                            StudentSubSubjectsPlan."Sub-Subject Code" := SPSubSubjectsLines."Sub-Subject Code";
                            StudentSubSubjectsPlan.Code := Rec."Study Plan Code";
                            StudentSubSubjectsPlan."Schooling Year" := SPSubSubjectsLines."Schooling Year";
                            StudentSubSubjectsPlan.Description := SPSubSubjectsLines.Description;
                            StudentSubSubjectsPlan."Subject Description" := SPSubSubjectsLines."Subject Description";
                            StudentSubSubjectsPlan."Mandatory/Optional Type" := SPSubSubjectsLines."Mandatory/Optional Type";
                            StudentSubSubjectsPlan."Curriculum Type" := SPSubSubjectsLines."Curriculum Type";
                            StudentSubSubjectsPlan."Evaluation Type" := SPSubSubjectsLines."Evaluation Type";
                            StudentSubSubjectsPlan."Sub-Subject Description" := SPSubSubjectsLines."Sub-Subject Description";
                            StudentSubSubjectsPlan."Country/Region Code" := SPSubSubjectsLines."Country/Region Code";
                            StudentSubSubjectsPlan."Responsibility Center" := SPSubSubjectsLines."Responsibility Center";
                            StudentSubSubjectsPlan."Maximum Injustified Absence" := SPSubSubjectsLines."Maximum Injustified Absence";
                            StudentSubSubjectsPlan."Assessment Code" := SPSubSubjectsLines."Assessment Code";
                            StudentSubSubjectsPlan."Minimum Classification Level" := SPSubSubjectsLines."Minimum Classification Level";
                            StudentSubSubjectsPlan."Characterise Subjects" := SPSubSubjectsLines."Characterise Subjects";
                            StudentSubSubjectsPlan."Maximum Total Absence" := SPSubSubjectsLines."Maximum Total Absence";
                            StudentSubSubjectsPlan.Type := Rec.Type;
                            StudentSubSubjectsPlan."User Id" := UserId;
                            StudentSubSubjectsPlan.Date := WorkDate;
                            StudentSubSubjectsPlan."Line No." := rRegSubjects."Line No.";
                            StudentSubSubjectsPlan.Insert;
                        until SPSubSubjectsLines.Next = 0;
                    end;
                    Rec.Delete;
                until Rec.Next = 0;
                Message(text009);
                CurrPage.Close;
            end else
                Error(text010);
        end else
            Message(text011);
    end;


    procedure GetLastLineNo(): Integer
    var
        rRegSubjects: Record "Registration Subjects";
    begin


        rRegSubjects.Reset;
        rRegSubjects.SetRange("Student Code No.", VarStudentCode);
        rRegSubjects.SetRange("School Year", VarSchoolYear);
        if rRegSubjects.Find('+') then
            exit(rRegSubjects."Line No." + 10000)
        else
            exit(10000);
    end;


    procedure VisibleFuction()
    begin
        if (vArraySchoolYear[1] = '') and (vArraySchoolYear[2] = '') then
            Txt1Visible := false
        else
            Txt1Visible := true;

        if (vArraySchoolYear[2] = '') and (vArraySchoolYear[3] = '') then
            Txt2Visible := false
        else
            Txt2Visible := true;

        if (vArraySchoolYear[3] = '') and (vArraySchoolYear[4] = '') then
            Txt3Visible := false
        else
            Txt3Visible := true;

        if (vArraySchoolYear[4] = '') and (vArraySchoolYear[5] = '') then
            Txt4Visible := false
        else
            Txt4Visible := true;

        if (vArraySchoolYear[5] = '') and (vArraySchoolYear[6] = '') then
            Txt5Visible := false
        else
            Txt5Visible := true;

        if (vArraySchoolYear[6] = '') and (vArraySchoolYear[7] = '') then
            Txt6Visible := false
        else
            Txt6Visible := true;

        if (vArraySchoolYear[7] = '') and (vArraySchoolYear[8] = '') then
            Txt7Visible := false
        else
            Txt7Visible := true;

        if (vArraySchoolYear[8] = '') and (vArraySchoolYear[9] = '') then
            Txt8Visible := false
        else
            Txt8Visible := true;

        if (vArraySchoolYear[9] = '') and (vArraySchoolYear[10] = '') then
            Txt9Visible := false
        else
            Txt9Visible := true;

        if (vArraySchoolYear[10] = '') and (vArraySchoolYear[11] = '') then
            Txt10Visible := false
        else
            Txt10Visible := true;

        if (vArraySchoolYear[11] = '') and (vArraySchoolYear[12] = '') then
            Txt11Visible := false
        else
            Txt11Visible := true;

        if (vArraySchoolYear[12] = '') and (vArraySchoolYear[13] = '') then
            Txt12Visible := false
        else
            Txt12Visible := true;

        if (vArraySchoolYear[13] = '') and (vArraySchoolYear[14] = '') then
            Txt13Visible := false
        else
            Txt13Visible := true;

        if (vArraySchoolYear[14] = '') and (vArraySchoolYear[15] = '') then
            Txt14Visible := false
        else
            Txt14Visible := true;

        if (vArraySchoolYear[15] = '') then
            Txt15Visible := false
        else
            Txt15Visible := true;
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin
        CurrPage.Update(false);
    end;

    local procedure VarOriginalStudyPlanCodeOnAfte()
    begin
        CurrPage.Update(false);
    end;

    local procedure varMixedClassificationOnPush()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

