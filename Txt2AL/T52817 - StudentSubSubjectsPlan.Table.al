table 52817 "Student Sub-Subjects Plan "
{
    Caption = 'Student Sub-Subjects Plan Lines';

    fields
    {
        field(1; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST(Simple)) "Study Plan Header".Code
            ELSE
            IF (Type = CONST(Multi)) "Course Header".Code;
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code WHERE(Type = FILTER(Subject));

            trigger OnValidate()
            begin
                if rSubjects.Get(1, "Subject Code") then
                    "Subject Description" := rSubjects.Description;
            end;
        }
        field(7; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
        }
        field(8; "Mandatory/Optional Type"; Option)
        {
            Caption = 'Mandatory/Optional Type';
            OptionCaption = ' ,Required,Optional';
            OptionMembers = " ",Required,Optional;
        }
        field(9; "Curriculum Type"; Option)
        {
            Caption = 'Curriculum Type';
            OptionCaption = ' ,Disciplinary,Non disciplinary,Curriculum Enrichment,General,Specific';
            OptionMembers = " ",Disciplinary,"Non disciplinary"," Curriculum Enrichment",General,Specific;
        }
        field(10; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if "Evaluation Type" <> xRec."Evaluation Type" then
                    Validate("Assessment Code", '');
            end;
        }
        field(11; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
            TableRelation = IF (Type = CONST(Simple)) "Study Plan Sub-Subjects Lines"."Sub-Subject Code" WHERE(Type = FIELD(Type),
                                                                                                              Code = FIELD(Code),
                                                                                                              "Schooling Year" = FIELD("Schooling Year"),
                                                                                                              "Subject Code" = FIELD("Subject Code"),
                                                                                                              "School Year" = FIELD("School Year"),
                                                                                                              "Sub-Subject Code" = FIELD("Sub-Subject Code"))
            ELSE
            IF (Type = CONST(Multi)) "Study Plan Sub-Subjects Lines"."Sub-Subject Code" WHERE(Type = FIELD(Type),
                                                                                                                                                                                                    Code = FIELD(Code),
                                                                                                                                                                                                    "Schooling Year" = FIELD("Schooling Year"),
                                                                                                                                                                                                    "Subject Code" = FIELD("Subject Code"),
                                                                                                                                                                                                    "Sub-Subject Code" = FIELD("Sub-Subject Code"));
        }
        field(12; "Sub-Subject Description"; Text[64])
        {
            Caption = 'Sub-Subject Description';
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(14; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                        RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(15; "Maximum Injustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';
        }
        field(16; "Assessment Code"; Code[20])
        {
            Caption = 'AssessmentCode';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));

            trigger OnValidate()
            begin
                InsertSettingRatings;
            end;
        }
        field(17; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
                if rRankGroup.Get("Assessment Code") then begin
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Qualitative) or
                       (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::"Mixed-Qualification") then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                        rClassificationLevel.SetRange("Classification Level Code", "Minimum Classification Level");
                        if not rClassificationLevel.Find('-') then
                            Error(Text0001);

                    end;
                    if (rRankGroup."Evaluation Type" = rRankGroup."Evaluation Type"::Quantitative) then begin
                        rClassificationLevel.Reset;
                        rClassificationLevel.SetRange("Classification Group Code", "Assessment Code");
                        if rClassificationLevel.Find('-') then begin
                            Evaluate(l_TempValue, "Minimum Classification Level");
                            if (l_TempValue < rClassificationLevel."Min Value") or
                               (l_TempValue > rClassificationLevel."Max Value") then
                                Error(Text0002, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
                        end;
                    end;

                end;
            end;
        }
        field(18; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial';
            OptionMembers = " ",Annual,Biennial,Triennial;
        }
        field(19; "Maximum Total Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Total Absence';
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                /*
                rRegClassEntry.RESET;
                rRegClassEntry.SETRANGE(Class,Class);
                rRegClassEntry.SETRANGE("School Year","School Year");
                rRegClassEntry.SETRANGE("Schooling Year","Schooling Year");
                rRegClassEntry.SETRANGE("Student Code No.","Student Code No.");
                rRegClassEntry.SETRANGE(Status,Status);
                IF rRegClassEntry.FIND('-') THEN BEGIN
                   REPEAT
                      rRegClassEntry.Turn := Turn;
                      rRegClassEntry.MODIFY;
                   UNTIL rRegClassEntry.NEXT = 0 ;
                END;
                */

            end;
        }
        field(22; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(73101; Observations; Code[20])
        {
            Caption = 'Observations';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab));
        }
        field(73103; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(73104; "Report Description"; Text[250])
        {
            Caption = 'Report Descripton';
        }
    }

    keys
    {
        key(Key1; "Student Code No.", "School Year", "Subject Code", "Sub-Subject Code")
        {
            Clustered = true;
        }
        key(Key2; "Student Code No.", Turn)
        {
        }
        key(Key3; "Subject Code", "Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin

        cInsertNAVGeneralTable.UpdateStudentsSubSubjectsTurn(Rec);
    end;

    var
        rSubjects: Record Subjects;
        cStudentsRegistration: Codeunit "Students Registration";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rClassificationLevel: Record "Classification Level";
        rRankGroup: Record "Rank Group";
        Text0001: Label 'You must specify a valid code.';
        Text0002: Label 'The value must be between %1 and %2.';
        Text0003: Label 'There are no moments for School Year %1 and Schooling Year %2.';
        Text0005: Label 'To use this option please configure the Course Setting Ratings for the subject %1.';
        Text0006: Label 'To use this option please configure the Study Plan Setting Ratings for the subject %1.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;

    //[Scope('OnPrem')]
    procedure OpenCreateAssessmentConf()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
    begin
        /*
        l_rMoments.RESET;
        l_rMoments.SETRANGE("School Year",Code);
        l_rMoments.SETRANGE("Schooling Year","School Year");
        IF l_rMoments.FIND('-') THEN
           REPEAT
             tAssessment := tAssessment + l_rMoments."Moment Code" + ','
           UNTIL l_rMoments.NEXT = 0;
        
        IF tAssessment <> '' THEN BEGIN
           int := STRMENU(tAssessment);
           l_rMoments.RESET;
           l_rMoments.SETRANGE("School Year",Code);
           l_rMoments.SETRANGE("Schooling Year","School Year");
           IF l_rMoments.FIND('-') AND (int <> 0) THEN
              l_rMoments.NEXT := int - 1
           ELSE
              EXIT;
        
           l_rSettingRatings.RESET;
           l_rSettingRatings.SETRANGE("Moment Code",l_rMoments."Moment Code");
           l_rSettingRatings.SETRANGE("School Year",Code);
           l_rSettingRatings.SETRANGE("Schooling Year","School Year");
           l_rSettingRatings.SETRANGE("Study Plan Code",Code);
           l_rSettingRatings.SETRANGE("Subject Code","Subject Code");
           IF NOT l_rSettingRatings.FIND('-') THEN BEGIN
              l_rSettingRatings.INIT;
              l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
              l_rSettingRatings."School Year" := Code;
              l_rSettingRatings."Schooling Year" := "School Year";
              l_rSettingRatings."Study Plan Code" := Code;
              l_rSettingRatings."Subject Code" := "Subject Code";
              l_rSettingRatings."Assessment Code" := "Assessment Code";
              l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
              l_rSettingRatings.INSERT;
        
              l_rSettingRatings.RESET;
              l_rSettingRatings.SETRANGE("Moment Code",l_rMoments."Moment Code");
              l_rSettingRatings.SETRANGE("School Year",Code);
              l_rSettingRatings.SETRANGE("Schooling Year","School Year");
              l_rSettingRatings.SETRANGE("Study Plan Code",Code);
              l_rSettingRatings.SETRANGE("Subject Code","Subject Code");
              IF l_rSettingRatings.FIND('-') THEN;
              //FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings2);
           END;
            //ELSE begin
              l_rSettingRatings.RESET;
              l_rSettingRatings.SETRANGE("Moment Code");
              l_rSettingRatings.SETRANGE("School Year");
              l_rSettingRatings.SETRANGE("Schooling Year");
              l_rSettingRatings.SETRANGE("Study Plan Code");
              l_rSettingRatings.SETRANGE("Subject Code");
        
              FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings);
            //end;
        END;
         */

    end;

    //[Scope('OnPrem')]
    procedure InsertSettingRatings()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        Text0001: Label 'Unable to automatically configure the moments of Evaluation for Discipline.';
    begin
        /*
        l_rMoments.RESET;
        l_rMoments.SETRANGE("School Year",Code);
        l_rMoments.SETRANGE("Schooling Year","School Year");
        IF l_rMoments.FIND('-') THEN BEGIN
             REPEAT
                l_rSettingRatings.RESET;
                l_rSettingRatings.SETRANGE("Moment Code",l_rMoments."Moment Code");
                l_rSettingRatings.SETRANGE("School Year",Code);
                l_rSettingRatings.SETRANGE("Schooling Year","School Year");
                l_rSettingRatings.SETRANGE("Study Plan Code",Code);
                l_rSettingRatings.SETRANGE("Subject Code","Subject Code");
                IF NOT l_rSettingRatings.FIND('-') THEN BEGIN
        
                   l_rSettingRatings.INIT;
                   l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                   l_rSettingRatings."School Year" := Code;
                   l_rSettingRatings."Schooling Year" := "School Year";
                   l_rSettingRatings."Study Plan Code" := Code;
                   l_rSettingRatings."Subject Code" := "Subject Code";
                   l_rSettingRatings."Assessment Code" := "Assessment Code";
                   l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                   l_rSettingRatings.INSERT;
                END ELSE BEGIN
                   l_rSettingRatings."Assessment Code" := "Assessment Code";
                   l_rSettingRatings.MODIFY;
                END;
             UNTIL l_rMoments.NEXT = 0;
        END ELSE
           ERROR(Text0003,Code,"School Year");
        */

    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects2()
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rAspects: Record Aspects;
        l_rMoments: Record "Moments Assessment";
        l_rMomentsTEMP: Record "Moments Assessment" temporary;
        lSettingRatingsSS: Record "Setting Ratings Sub-Subjects";
        int: Integer;
        tAssessment: Text[1024];
    begin
        l_rMomentsTEMP.DeleteAll;

        lSettingRatingsSS.Reset;
        lSettingRatingsSS.SetRange("School Year", "School Year");
        lSettingRatingsSS.SetRange("Schooling Year", "Schooling Year");
        lSettingRatingsSS.SetRange("Responsibility Center", "Responsibility Center");
        lSettingRatingsSS.SetRange("Type Education", Type);
        lSettingRatingsSS.SetRange("Study Plan Code", Code);
        lSettingRatingsSS.SetRange(Type, lSettingRatingsSS.Type::Header);
        lSettingRatingsSS.SetRange("Subject Code", "Subject Code");
        lSettingRatingsSS.SetRange("Sub-Subject Code", "Sub-Subject Code");
        if lSettingRatingsSS.FindSet then begin
            repeat
                l_rMoments.Reset;
                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                l_rMoments.SetRange("School Year", "School Year");
                l_rMoments.SetRange("Schooling Year", "Schooling Year");
                l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
                l_rMoments.SetRange("Moment Code", lSettingRatingsSS."Moment Code");
                if l_rMoments.Find('-') then begin
                    l_rMomentsTEMP.Init;
                    l_rMomentsTEMP.TransferFields(l_rMoments);
                    l_rMomentsTEMP.Insert;
                end;
            until lSettingRatingsSS.Next = 0;
        end else
            if Type = Type::Simple then
                Error(Text0006, "Subject Code")
            else
                Error(Text0005, "Subject Code");

        l_rMomentsTEMP.Reset;
        l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
        l_rMomentsTEMP.SetRange("School Year", "School Year");
        l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
        l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMomentsTEMP.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMomentsTEMP."Moment Code" + ','
            until l_rMomentsTEMP.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMomentsTEMP.Reset;
            l_rMomentsTEMP.SetCurrentKey("Schooling Year", "Sorting ID");
            l_rMomentsTEMP.SetRange("School Year", "School Year");
            l_rMomentsTEMP.SetRange("Schooling Year", "Schooling Year");
            l_rMomentsTEMP.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMomentsTEMP.Find('-') and (int <> 0) then
                l_rMomentsTEMP.Next := int - 1
            else
                exit;
        end;

        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Student);
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Type No.", "Student Code No.");
        rAspects.SetRange("Moment Code", l_rMomentsTEMP."Moment Code");
        rAspects.SetRange(Subjects, "Subject Code");
        rAspects.SetRange("Sub Subjects", "Sub-Subject Code");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects2(rAspects, rAspects.Type::Student, "School Year", "Student Code No.", l_rMomentsTEMP."Moment Code",
                               "Schooling Year", "Subject Code", "Sub-Subject Code", "Evaluation Type", "Assessment Code",
                               "Responsibility Center");

            Commit;
        end;

        PAGE.RunModal(PAGE::Aspects, rAspects);
    end;
}

