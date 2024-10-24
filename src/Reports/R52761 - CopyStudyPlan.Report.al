report 52761 "Copy Study Plan"
{
    Caption = 'Copy Study Plan';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Copy Study Plan")
                {
                    Caption = 'Copy Study Plan';
                    field(StudyPlanCode; StudyPlanCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Study Plan';
                        TableRelation = "Study Plan Header";
                    }
                    field(OldStudyPlanCode; OldStudyPlanCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Study Plan Copy';
                        TableRelation = "Study Plan Header";
                    }
                    field(NewSchoolYear; NewSchoolYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New School Year';
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
                    }
                    field(NewSchoolingYear; NewSchoolingYear)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Schooling Year';
                        TableRelation = "Structure Education Country"."Schooling Year";
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

        if StudyPlanCode = '' then
            Error(Text0002);

        if OldStudyPlanCode = '' then
            Error(Text0001);

        if NewSchoolYear = '' then
            Error(Text0005);

        if (StudyPlanCode = OldStudyPlanCode) then
            Error(Text0006);

        Window.Open(text0010 + text0011 + text0012 + text0013);

        InsertStudyPlan;
    end;

    var
        Text0001: Label 'The Field New Plan Study must be completed.';
        Text0002: Label 'The Field Plan study must be completed.';
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'Already exists for the New Plan Study';
        Text0005: Label 'Mandatory New Schoolling Year.';
        Text0006: Label 'The new study plan cannot be the same as the original study plan.';
        text0010: Label 'Copy Subject  \@1@@@@@@@@@@@@@@@@@@@@@\';
        text0011: Label 'Copy Sub-Subject  \@2@@@@@@@@@@@@@@@@@@@@@\';
        text0012: Label 'Copy Aspects  \@3@@@@@@@@@@@@@@@@@@@@@\';
        text0013: Label 'Copy Sub-Aspects  \@4@@@@@@@@@@@@@@@@@@@@@\';
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        StudyPlanCode: Code[20];
        OldStudyPlanCode: Code[20];
        NewSchoolYear: Code[9];
        NewSchoolingYear: Code[10];
        varRespCenter: Code[10];
        Window: Dialog;


    procedure InsertStudyPlan()
    var
        l_rStudyPlanHeader: Record "Study Plan Header";
        l_rStudyPlanLines: Record "Study Plan Lines";
        Nreg: Integer;
        countReg: Integer;
    begin

        rStudyPlanHeader.Reset;
        rStudyPlanHeader.SetRange(Code, OldStudyPlanCode);
        rStudyPlanHeader.SetRange("Responsibility Center", varRespCenter);
        if rStudyPlanHeader.Find('-') then begin
            l_rStudyPlanHeader.Reset;
            l_rStudyPlanHeader.SetRange(Code, StudyPlanCode);
            if l_rStudyPlanHeader.Find('-') then begin
                l_rStudyPlanHeader."School Year" := NewSchoolYear;
                if rStudyPlanHeader."Schooling Year" = NewSchoolingYear then
                    l_rStudyPlanHeader."Schooling Year" := rStudyPlanHeader."Schooling Year"
                else
                    l_rStudyPlanHeader."Schooling Year" := NewSchoolingYear;
                l_rStudyPlanHeader."Country/Region Code" := rStudyPlanHeader."Country/Region Code";
                l_rStudyPlanHeader."Sub-subjects for assess. only" := rStudyPlanHeader."Sub-subjects for assess. only";
                l_rStudyPlanHeader.Modify;
            end;
            rStudyPlanLines.Reset;
            rStudyPlanLines.SetRange(Code, OldStudyPlanCode);
            rStudyPlanLines.SetRange("School Year", rStudyPlanHeader."School Year");
            if rStudyPlanLines.Find('-') then begin
                Nreg := rStudyPlanLines.Count;
                repeat
                    countReg += 1;
                    Window.Update(1, Round(countReg / Nreg * 10000, 1));

                    rStudyPlanLines.CalcFields("Sub-Subject");
                    if rStudyPlanLines."Sub-Subject" then begin
                        CopySubSubject(rStudyPlanLines);
                    end;

                    l_rStudyPlanLines.Init;
                    l_rStudyPlanLines.Code := StudyPlanCode;
                    l_rStudyPlanLines."School Year" := NewSchoolYear;

                    if rStudyPlanHeader."Schooling Year" = NewSchoolingYear then
                        l_rStudyPlanLines."Schooling Year" := rStudyPlanLines."Schooling Year"
                    else
                        l_rStudyPlanLines."Schooling Year" := NewSchoolingYear;

                    l_rStudyPlanLines."Subject Code" := rStudyPlanLines."Subject Code";
                    l_rStudyPlanLines."Report Descripton" := rStudyPlanLines."Report Descripton";
                    l_rStudyPlanLines."Subject Description" := rStudyPlanLines."Subject Description";
                    l_rStudyPlanLines."Mandatory/Optional Type" := rStudyPlanLines."Mandatory/Optional Type";
                    l_rStudyPlanLines."Curriculum Type" := rStudyPlanLines."Curriculum Type";
                    l_rStudyPlanLines."Evaluation Type" := rStudyPlanLines."Evaluation Type";
                    l_rStudyPlanLines.Validate("Legal Code", rStudyPlanLines."Legal Code");
                    l_rStudyPlanLines."Country/Region Code" := rStudyPlanLines."Country/Region Code";
                    l_rStudyPlanLines."Responsibility Center" := varRespCenter;
                    l_rStudyPlanLines."Maximum Unjustified Absences" := rStudyPlanLines."Maximum Unjustified Absences";
                    l_rStudyPlanLines."Maximum Total Absence" := rStudyPlanLines."Maximum Total Absence";
                    l_rStudyPlanLines.Validate("Assessment Code", rStudyPlanLines."Assessment Code");
                    l_rStudyPlanLines."Minimum Classification Level" := rStudyPlanLines."Minimum Classification Level";
                    l_rStudyPlanLines.Observations := rStudyPlanLines.Observations;
                    l_rStudyPlanLines."Subject Excluded From Assess." := rStudyPlanLines."Subject Excluded From Assess.";
                    l_rStudyPlanLines."Sub-subjects for assess. only" := rStudyPlanLines."Sub-subjects for assess. only";
                    l_rStudyPlanLines."Sorting ID" := rStudyPlanLines."Sorting ID";
                    l_rStudyPlanLines.Validate("Disciplinary Area Code", rStudyPlanLines."Disciplinary Area Code");
                    l_rStudyPlanLines.Insert;
                    l_rStudyPlanLines.InsertSettingRatings;

                until rStudyPlanLines.Next = 0;
            end;
            //Aspects
            GetAspects;
            GetAspectsSubSubjects;
            Message(Text0003);
        end;
    end;


    procedure GetStudyPlanNo(pStudyPlanCode: Code[20]; pRespCenter: Code[10])
    begin

        StudyPlanCode := pStudyPlanCode;

        varRespCenter := pRespCenter;
    end;


    procedure CopySubSubject(pStudyPlanLines: Record "Study Plan Lines")
    var
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        NEWStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        Nreg: Integer;
        countReg: Integer;
    begin


        rStudyPlanSubSubjectsLines.Reset;
        rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
        rStudyPlanSubSubjectsLines.SetRange(Code, pStudyPlanLines.Code);
        rStudyPlanSubSubjectsLines.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
        rStudyPlanSubSubjectsLines.SetRange("Subject Code", pStudyPlanLines."Subject Code");
        rStudyPlanSubSubjectsLines.SetRange("School Year", pStudyPlanLines."School Year");
        if rStudyPlanSubSubjectsLines.Find('-') then begin
            Nreg := rStudyPlanSubSubjectsLines.Count;
            repeat
                countReg += 1;
                Window.Update(2, Round(countReg / Nreg * 10000, 1));

                NEWStudyPlanSubSubjectsLines.TransferFields(rStudyPlanSubSubjectsLines);
                NEWStudyPlanSubSubjectsLines.Code := StudyPlanCode;
                NEWStudyPlanSubSubjectsLines."Schooling Year" := NewSchoolingYear;
                NEWStudyPlanSubSubjectsLines."School Year" := NewSchoolYear;
                NEWStudyPlanSubSubjectsLines.Insert(true);
                GetRatingsSubSubjects(rStudyPlanSubSubjectsLines);

            until rStudyPlanSubSubjectsLines.Next = 0;
        end;
    end;


    procedure GetAspects()
    var
        rAspects: Record Aspects;
        rSettingRatings: Record "Setting Ratings";
        Newaspects: Record Aspects;
        l_StudyPlanHeader: Record "Study Plan Header";
        Nreg: Integer;
        countReg: Integer;
    begin
        if l_StudyPlanHeader.Get(OldStudyPlanCode) then;

        rSettingRatings.Reset;
        rSettingRatings.SetRange("Study Plan Code", OldStudyPlanCode);
        rSettingRatings.SetRange("School Year", l_StudyPlanHeader."School Year");
        rSettingRatings.SetRange("Schooling Year", l_StudyPlanHeader."Schooling Year");
        if rSettingRatings.Find('-') then begin
            repeat
                rAspects.Reset;
                rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                rAspects.SetRange("Moment Code", rSettingRatings."Moment Code");
                rAspects.SetRange("School Year", rSettingRatings."School Year");
                rAspects.SetRange("Type No.", rSettingRatings."Study Plan Code");
                rAspects.SetRange("Schooling Year", rSettingRatings."Schooling Year");
                rAspects.SetRange(Subjects, rSettingRatings."Subject Code");
                rAspects.SetRange("Sub Subjects", '');
                if rAspects.Find('-') then begin
                    Nreg := rAspects.Count;
                    repeat
                        countReg += 1;
                        Window.Update(3, Round(countReg / Nreg * 10000, 1));

                        Newaspects.Init;
                        Newaspects.TransferFields(rAspects);
                        Newaspects."Type No." := StudyPlanCode;
                        Newaspects."Schooling Year" := NewSchoolingYear;
                        Newaspects."School Year" := NewSchoolYear;
                        Newaspects.Insert;
                    until rAspects.Next = 0;
                end;
            until rSettingRatings.Next = 0;
        end;
    end;


    procedure GetAspectsSubSubjects()
    var
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rAspects: Record Aspects;
        NEWaspects: Record Aspects;
        l_StudyPlanHeader: Record "Study Plan Header";
        Nreg: Integer;
        countReg: Integer;
    begin
        if l_StudyPlanHeader.Get(OldStudyPlanCode) then;

        rSettingRatingsSubSubjects.Reset;
        rSettingRatingsSubSubjects.SetRange("Study Plan Code", OldStudyPlanCode);
        rSettingRatingsSubSubjects.SetRange("School Year", l_StudyPlanHeader."School Year");
        rSettingRatingsSubSubjects.SetRange("Schooling Year", l_StudyPlanHeader."Schooling Year");
        if rSettingRatingsSubSubjects.Find('-') then begin
            repeat
                rAspects.Reset;
                rAspects.SetRange(Type, rAspects.Type::"Study Plan");
                rAspects.SetRange("Moment Code", rSettingRatingsSubSubjects."Moment Code");
                rAspects.SetRange("School Year", rSettingRatingsSubSubjects."School Year");
                rAspects.SetRange("Type No.", rSettingRatingsSubSubjects."Study Plan Code");
                rAspects.SetRange("Schooling Year", rSettingRatingsSubSubjects."Schooling Year");
                rAspects.SetRange(Subjects, rSettingRatingsSubSubjects."Subject Code");
                rAspects.SetRange("Sub Subjects", rSettingRatingsSubSubjects."Sub-Subject Code");
                if rAspects.Find('-') then begin
                    Nreg := rAspects.Count;
                    repeat
                        countReg += 1;
                        Window.Update(4, Round(countReg / Nreg * 10000, 1));

                        NEWaspects.Init;
                        NEWaspects.TransferFields(rAspects);
                        NEWaspects."Type No." := StudyPlanCode;
                        NEWaspects."Schooling Year" := NewSchoolingYear;
                        NEWaspects."School Year" := NewSchoolYear;
                        NEWaspects.Insert;
                    until rAspects.Next = 0;
                end;
            until rSettingRatingsSubSubjects.Next = 0;
        end;
    end;


    procedure GetRatingsSubSubjects(pStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines")
    var
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        NEWSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin

        rStudyPlanSubSubjectsLines.Reset;
        rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::"Study Plan");
        rStudyPlanSubSubjectsLines.SetRange(Code, pStudyPlanSubSubjectsLines.Code);
        rStudyPlanSubSubjectsLines.SetRange("Schooling Year", pStudyPlanSubSubjectsLines."Schooling Year");
        rStudyPlanSubSubjectsLines.SetRange("School Year", pStudyPlanSubSubjectsLines."School Year");
        rStudyPlanSubSubjectsLines.SetRange("Subject Code", pStudyPlanSubSubjectsLines."Subject Code");
        rStudyPlanSubSubjectsLines.SetRange("Sub-Subject Code", pStudyPlanSubSubjectsLines."Sub-Subject Code");
        if rStudyPlanSubSubjectsLines.Find('-') then begin
            repeat
                rSettingRatingsSubSubjects.SetRange("School Year", rStudyPlanSubSubjectsLines."School Year");
                rSettingRatingsSubSubjects.SetRange("Schooling Year", rStudyPlanSubSubjectsLines."Schooling Year");
                rSettingRatingsSubSubjects.SetRange("Study Plan Code", rStudyPlanSubSubjectsLines.Code);
                rSettingRatingsSubSubjects.SetRange("Subject Code", rStudyPlanSubSubjectsLines."Subject Code");
                rSettingRatingsSubSubjects.SetRange("Sub-Subject Code", rStudyPlanSubSubjectsLines."Sub-Subject Code");
                if rSettingRatingsSubSubjects.Find('-') then begin
                    repeat
                        NEWSettingRatingsSubSubjects.TransferFields(rSettingRatingsSubSubjects);
                        NEWSettingRatingsSubSubjects."Study Plan Code" := StudyPlanCode;
                        NEWSettingRatingsSubSubjects."Schooling Year" := NewSchoolingYear;
                        NEWSettingRatingsSubSubjects."School Year" := NewSchoolYear;
                        NEWSettingRatingsSubSubjects.Insert(true);
                    until rSettingRatingsSubSubjects.Next = 0;

                end;
            until rStudyPlanSubSubjectsLines.Next = 0;
        end;
    end;
}

