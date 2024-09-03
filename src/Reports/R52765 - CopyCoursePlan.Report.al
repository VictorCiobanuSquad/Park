report 52765 "Copy Course Plan"
{
    Caption = 'Copy Course Plan';
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
                group(Options)
                {
                    Caption = 'Options';
                    field(varCopyCoursePlan; varCopyCoursePlan)
                    {
                        Caption = 'Copy Plan Course';
                        TableRelation = "Course Header";
                        ApplicationArea = Basic, Suite;
                    }
                    field(varNewCoursePlan; varNewCoursePlan)
                    {
                        Caption = 'New Plan Course';
                        Editable = false;
                        ApplicationArea = Basic, Suite;
                    }
                    field(varNewSchoolYear; varNewSchoolYear)
                    {
                        Caption = 'New School Year';
                        ApplicationArea = Basic, Suite;
                        TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
                    }
                    field(varNewSchoolingYear; varNewSchoolingYear)
                    {
                        Caption = 'New Schooling Year';
                        ApplicationArea = Basic, Suite;
                        Visible = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rCourseHeader: Record "Course Header";
                            rStructureEducationCountry: Record "Structure Education Country";
                        begin
                            l_rCourseHeader.Reset;
                            l_rCourseHeader.SetRange(Code, varNewCoursePlan);
                            if l_rCourseHeader.Find('-') then begin
                                rStructureEducationCountry.Reset;
                                rStructureEducationCountry.SetRange(Country, l_rCourseHeader."Country/Region Code");
                                if PAGE.RunModal(0, rStructureEducationCountry) = ACTION::LookupOK then begin
                                    varNewSchoolingYear := rStructureEducationCountry."Schooling Year";
                                end;
                            end;
                        end;
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
        if varNewCoursePlan = '' then
            Error(Text0001);

        if varCopyCoursePlan = '' then
            Error(Text0002);

        //IF varNewSchoolingYear = '' THEN
        //   ERROR(Text0005);

        if (varNewCoursePlan = varCopyCoursePlan) then
            Error(Text0006);

        Window.Open(text0010 + text0011 + text0012 + text0013);


        InsertCoursePlan;
    end;

    var
        rCourseHeader: Record "Course Header";
        rCourseLine: Record "Course Lines";
        varCopyCoursePlan: Code[20];
        varNewCoursePlan: Code[20];
        varNewSchoolYear: Code[9];
        varNewSchoolingYear: Code[10];
        Text0001: Label 'The Field New Plan Study must be completed.';
        Text0002: Label 'The Field Plan study must be completed.';
        Text0003: Label 'Copies conducted successfully.';
        Text0004: Label 'Already exists for the New Plan Study';
        Text0005: Label 'Mandatory New Schoolling Year.';
        Text0006: Label 'The new plan of course can not be equal to the current plan of copy';
        rSchoolYear: Record "School Year";
        text0010: Label 'Copy Subject  \@1@@@@@@@@@@@@@@@@@@@@@\';
        Window: Dialog;
        text0011: Label 'Copy Sub-Subject  \@2@@@@@@@@@@@@@@@@@@@@@\';
        text0012: Label 'Copy Aspects  \@3@@@@@@@@@@@@@@@@@@@@@\';
        text0013: Label 'Copy Sub-Aspects  \@4@@@@@@@@@@@@@@@@@@@@@\';

    //[Scope('OnPrem')]
    procedure InsertCoursePlan()
    var
        l_rCourseHeader: Record "Course Header";
        l_rCourseLine: Record "Course Lines";
        Nreg: Integer;
        countReg: Integer;
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then;

        rCourseHeader.Reset;
        rCourseHeader.SetRange(Code, varCopyCoursePlan);
        if rCourseHeader.Find('-') then begin
            l_rCourseHeader.Reset;
            l_rCourseHeader.SetRange(Code, varNewCoursePlan);
            if l_rCourseHeader.Find('-') then begin
                l_rCourseHeader."School Year Begin" := varNewSchoolYear;
                l_rCourseHeader."Schooling Year Begin" := rCourseHeader."Schooling Year Begin";
                l_rCourseHeader."Sub-subjects for assess. only" := rCourseHeader."Sub-subjects for assess. only";
                l_rCourseHeader.Modify;
            end;

            rCourseLine.Reset;
            rCourseLine.SetRange(Code, varCopyCoursePlan);
            //rCourseLine.SETRANGE("School Year Begin",rCourseHeader."School Year Begin");
            if rCourseLine.Find('-') then
                Nreg := rCourseLine.Count;
            repeat
                countReg += 1;
                Window.Update(1, Round(countReg / Nreg * 10000, 1));

                if rCourseLine.CalcFields("Sub-Subject") then
                    CopySubSubject(rCourseLine);

                l_rCourseLine.Init;
                l_rCourseLine.TransferFields(rCourseLine);
                l_rCourseLine.Code := varNewCoursePlan;
                l_rCourseLine."School Year Begin" := varNewSchoolYear;
                l_rCourseLine.Insert;

            until rCourseLine.Next = 0;
            //seTTING Rattings
            CopySettingRattings;
            // SUB SETTING Rattings
            CopySubSubjectsSettingRattings;
            GetAspects;
            GetAspectsSubSubjects;
            Window.Close;

            Message(Text0003);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetCoursePlanNo(pCoursePlanCode: Code[20])
    begin
        varNewCoursePlan := pCoursePlanCode;
    end;

    //[Scope('OnPrem')]
    procedure CopySubSubject(pCourseLines: Record "Course Lines")
    var
        rStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        NEWStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        Nreg: Integer;
        countReg: Integer;
    begin


        rStudyPlanSubSubjectsLines.Reset;
        rStudyPlanSubSubjectsLines.SetCurrentKey(rStudyPlanSubSubjectsLines.Type, rStudyPlanSubSubjectsLines.Code,
                                                 rStudyPlanSubSubjectsLines."Subject Code");
        rStudyPlanSubSubjectsLines.SetRange(Type, rStudyPlanSubSubjectsLines.Type::Course);
        rStudyPlanSubSubjectsLines.SetRange(Code, pCourseLines.Code);
        rStudyPlanSubSubjectsLines.SetRange("Subject Code", pCourseLines."Subject Code");
        if rStudyPlanSubSubjectsLines.Find('-') then begin
            Nreg := rCourseLine.Count;
            repeat
                countReg += 1;
                Window.Update(2, Round(countReg / Nreg * 10000, 1));

                NEWStudyPlanSubSubjectsLines.TransferFields(rStudyPlanSubSubjectsLines);
                NEWStudyPlanSubSubjectsLines.Code := varNewCoursePlan;
                NEWStudyPlanSubSubjectsLines.Insert;
            until rStudyPlanSubSubjectsLines.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopySettingRattings()
    var
        OldSettingRatings: Record "Setting Ratings";
        NewSettingRatings: Record "Setting Ratings";
    begin

        OldSettingRatings.Reset;
        OldSettingRatings.SetCurrentKey("School Year", "Study Plan Code", "Type Education");
        OldSettingRatings.SetRange("Study Plan Code", varCopyCoursePlan);
        OldSettingRatings.SetRange(Type, OldSettingRatings.Type::Header);
        OldSettingRatings.SetRange("School Year", rSchoolYear."School Year");
        OldSettingRatings.SetRange("Type Education", OldSettingRatings."Type Education"::Multi);
        if OldSettingRatings.Find('-') then begin
            //Nreg := OldSettingRatings.COUNT;
            repeat
                //countReg += 1;
                //Window.UPDATE(2,ROUND(countReg/Nreg*10000,1));

                NewSettingRatings.Init;
                NewSettingRatings.TransferFields(OldSettingRatings);
                NewSettingRatings."School Year" := varNewSchoolYear;
                NewSettingRatings."Study Plan Code" := varNewCoursePlan;
                NewSettingRatings.Insert;
            until OldSettingRatings.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopySubSubjectsSettingRattings()
    var
        OldSRSubSubjects: Record "Setting Ratings Sub-Subjects";
        NewSRSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin

        OldSRSubSubjects.Reset;
        OldSRSubSubjects.SetCurrentKey("School Year", "Study Plan Code", "Type Education");
        OldSRSubSubjects.SetRange("Study Plan Code", varCopyCoursePlan);
        OldSRSubSubjects.SetRange("School Year", rSchoolYear."School Year");
        OldSRSubSubjects.SetRange(Type, OldSRSubSubjects.Type::Header);
        OldSRSubSubjects.SetRange("Type Education", OldSRSubSubjects."Type Education"::Multi);
        if OldSRSubSubjects.Find('-') then begin
            //Nreg := OldSRSubSubjects.COUNT;
            repeat
                NewSRSubSubjects.Init;
                NewSRSubSubjects.TransferFields(OldSRSubSubjects);
                NewSRSubSubjects."School Year" := varNewSchoolYear;
                NewSRSubSubjects."Study Plan Code" := varNewCoursePlan;
                NewSRSubSubjects.Insert;
            until OldSRSubSubjects.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAspects()
    var
        rAspects: Record Aspects;
        rSettingRatings: Record "Setting Ratings";
        Newaspects: Record Aspects;
        l_CourseHeader: Record "Course Header";
        Nreg: Integer;
        countReg: Integer;
    begin
        if l_CourseHeader.Get(varCopyCoursePlan) then;

        rSettingRatings.Reset;
        rSettingRatings.SetRange("Study Plan Code", varCopyCoursePlan);
        if rSettingRatings.Find('-') then begin
            repeat
                rAspects.Reset;
                rAspects.SetRange(Type, rAspects.Type::Course);
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
                        Newaspects."Type No." := varNewCoursePlan;
                        Newaspects."Schooling Year" := rSettingRatings."Schooling Year";
                        Newaspects."School Year" := varNewSchoolYear;
                        if Newaspects.Insert then;
                    until rAspects.Next = 0;
                end;
            until rSettingRatings.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetAspectsSubSubjects()
    var
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rAspects: Record Aspects;
        NEWaspects: Record Aspects;
        l_CourseHeader: Record "Course Header";
        Nreg: Integer;
        countReg: Integer;
    begin
        if l_CourseHeader.Get(varCopyCoursePlan) then;

        rSettingRatingsSubSubjects.Reset;
        rSettingRatingsSubSubjects.SetRange("Study Plan Code", varCopyCoursePlan);
        if rSettingRatingsSubSubjects.Find('-') then begin
            repeat
                rAspects.Reset;
                rAspects.SetRange(Type, rAspects.Type::Course);
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
                        NEWaspects."Type No." := varNewCoursePlan;
                        NEWaspects."Schooling Year" := rSettingRatingsSubSubjects."Schooling Year";
                        NEWaspects."School Year" := varNewSchoolYear;
                        NEWaspects.Insert;
                    until rAspects.Next = 0;
                end;
            until rSettingRatingsSubSubjects.Next = 0;
        end;
    end;
}

