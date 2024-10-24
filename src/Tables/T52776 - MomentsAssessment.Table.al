table 52776 "Moments Assessment"
{
    Caption = 'Moments Assessment';
    LookupPageID = "Setting Moments";
    Permissions = TableData "Assessing Students" = rimd;

    fields
    {
        field(1; "Moment Code"; Code[10])
        {
            Caption = 'Moment Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                if rCompanyInformation.Get then;


                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.FindSet then
                    Level := rStruEduCountry.Level;
            end;
        }
        field(5; Level; Option)
        {
            Caption = 'Level';
            OptionCaption = 'Pre school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(8; "Evaluation Moment"; Option)
        {
            Caption = 'Evaluation Moment';
            OptionCaption = ' ,Interim,Final Moment,Test,Others,Final Year,CIF,EXN1,EXN2,CFD';
            OptionMembers = " ",Interim,"Final Moment",Test,Others,"Final Year",CIF,EXN1,EXN2,CFD;
        }
        field(9; Active; Boolean)
        {
            Caption = 'Active';

            trigger OnValidate()
            var
                rMoments: Record "Moments Assessment";
            begin

                if Recuperation and Active then
                    Error(Text004);

                if Active then begin
                    rMoments.Reset;
                    rMoments.SetRange("School Year", "School Year");
                    rMoments.SetRange("Schooling Year", "Schooling Year");
                    rMoments.SetRange("Responsibility Center", "Responsibility Center");
                    rMoments.SetRange(Active, true);
                    if rMoments.Count <> 0 then
                        Error(Text001);
                end;
            end;
        }
        field(10; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(11; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(12; "Responsibility Center"; Code[10])
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
        field(13; Recuperation; Boolean)
        {
            Caption = 'Recuperation';

            trigger OnValidate()
            var
                rMoments: Record "Moments Assessment";
            begin
                //Moment Code,School Year,Schooling Year
                if Recuperation and Active then
                    Error(Text004);

                /*
                IF Recuperation THEN BEGIN
                   rMoments.RESET;
                   rMoments.SETRANGE("School Year","School Year");
                   rMoments.SETRANGE("Schooling Year","Schooling Year");
                   rMoments.SETRANGE("Responsibility Center","Responsibility Center");
                   rMoments.SETRANGE(Recuperation,TRUE);
                   IF rMoments.COUNT <> 0 THEN
                      ERROR(Text003);
                END;
                
                
                rMoments.RESET;
                rMoments.SETRANGE("School Year","School Year");
                rMoments.SETRANGE("Schooling Year","Schooling Year");
                rMoments.SETRANGE("Responsibility Center","Responsibility Center");
                rMoments.SETRANGE(Active,TRUE);
                IF rMoments.FIND('-') THEN;
                
                IF "Sorting ID" > rMoments."Sorting ID" THEN
                  ERROR(Text005)
                 */

            end;
        }
        field(14; Publish; Boolean)
        {
            Caption = 'Publish';
        }
        field(73102; Weighting; Integer)
        {
            Caption = 'Weighting';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;
        }
    }

    keys
    {
        key(Key1; "Moment Code", "School Year", "Schooling Year", "Responsibility Center")
        {
            Clustered = true;
        }
        key(Key2; "Schooling Year", "Sorting ID")
        {
        }
        key(Key3; "School Year", "Schooling Year")
        {
        }
        key(Key4; "School Year", "Schooling Year", "Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rSettingRatings.Reset;
        rSettingRatings.SetRange("Moment Code", "Moment Code");
        rSettingRatings.SetRange("School Year", "School Year");
        rSettingRatings.SetRange("Schooling Year", "Schooling Year");
        rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        if rSettingRatings.FindFirst then
            Error(Text002);

        rSettingRatingsSub.Reset;
        rSettingRatingsSub.SetRange("Moment Code", "Moment Code");
        rSettingRatingsSub.SetRange("School Year", "School Year");
        rSettingRatingsSub.SetRange("Schooling Year", "Schooling Year");
        rSettingRatingsSub.SetRange("Responsibility Center", "Responsibility Center");
        if rSettingRatingsSub.FindFirst then
            Error(Text006);


        cMasterTableWEB.DeleteMoments(Rec, xRec);

        //cInsertNAVGeneralTable.ModDelGTMoment(Rec,TRUE);
    end;

    trigger OnInsert()
    begin

        if "Responsibility Center" = '' then
            if rUserSetup.Get(UserId) then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        cMasterTableWEB.InsertMoments(Rec, xRec);
    end;

    trigger OnModify()
    begin
        cMasterTableWEB.ModifyMoments(Rec, xRec);


        //cInsertNAVGeneralTable.ModDelGTMoment(Rec,FALSE);
    end;

    trigger OnRename()
    begin
        //rCompanyInformation.Get;
        //if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
        //Error(Text007, TableCaption);
    end;

    var
        rStruEduCountry: Record "Structure Education Country";
        rCompanyInformation: Record "Company Information";
        Text001: Label 'It isn''t possible for more than one moment to be active per Schooling Year.';
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        rSettingRatings: Record "Setting Ratings";
        Text002: Label 'Not allowed, there are setting ratings for this moment';
        rSettingRatingsSub: Record "Setting Ratings Sub-Subjects";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        rUserSetup: Record "User Setup";
        Text003: Label 'It is not possible to have more than 1 moment to be defined for Recuperation, for the selected Schoolling Year.';
        Text004: Label 'The moment cannot be set as Active and Recuperation at the same time.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text005: Label 'Option available only for moments before the active moment.';
        Text006: Label 'Not allowed, there are sub-Subjects setting ratings for this moment';
        Text007: Label 'You cannot rename a %1.';


    procedure InsertMoment(pMomentsAssessment: Record "Moments Assessment")
    var
        rStudyPlanLines: Record "Study Plan Lines";
    begin
        rStudyPlanLines.Reset;
        rStudyPlanLines.SetRange("School Year", pMomentsAssessment."School Year");
        rStudyPlanLines.SetRange("Schooling Year", pMomentsAssessment."Schooling Year");
        rStudyPlanLines.SetRange("Responsibility Center", pMomentsAssessment."Responsibility Center");
        if rStudyPlanLines.Find('-') then
            repeat
                OpenCreateAssessmentConf(rStudyPlanLines);
            until rStudyPlanLines.Next = 0;
    end;


    procedure ModifyMoment()
    var
        Text99901: Label 'Change the %1?';
        Text99902: Label 'By modifying the registry %1, warning that it will delete all the movements for this school year %2 \ Are you sure you want to continue?';
        rAssessingStudents: Record "Assessing Students";
        rSettingRatings: Record "Setting Ratings";
        rStudyPlanLines: Record "Study Plan Lines";
        vOption: Integer;
        Text99903: Label 'You can not change %1 because it already has evaluations.';
    begin
        if (xRec."Moment Code" <> "Moment Code") or (xRec."School Year" <> "School Year") or
           (xRec."Schooling Year" <> "Schooling Year") then begin

            if Confirm(Text99901, false, FieldCaption("Moment Code")) then
                if Confirm(Text99902, false, FieldCaption("Moment Code"), FieldCaption("Schooling Year")) then begin
                    rAssessingStudents.Reset;
                    rAssessingStudents.SetRange("School Year", xRec."School Year");
                    rAssessingStudents.SetRange("Schooling Year", xRec."Schooling Year");
                    rAssessingStudents.SetRange("Moment Code", xRec."Moment Code");
                    if rAssessingStudents.Find('-') then
                        Error(Text99903, FieldCaption("Moment Code"));

                    rSettingRatings.Reset;
                    rSettingRatings.SetRange("School Year", xRec."School Year");
                    rSettingRatings.SetRange("Schooling Year", xRec."Schooling Year");
                    rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
                    rSettingRatings.DeleteAll;

                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetRange("School Year", "School Year");
                    rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
                    rStudyPlanLines.SetRange("Responsibility Center", "Responsibility Center");
                    if rStudyPlanLines.Find('-') then
                        repeat
                            OpenCreateAssessmentConf(rStudyPlanLines);
                        until rStudyPlanLines.Next = 0;
                end;
        end;
    end;


    procedure DeleteMoment()
    var
        Text99901: Label 'Want to delete the %1?';
        Text99902: Label 'To delete the record %1, warning that it will delete all the movements for this school year %2 \ Are you sure you want to continue?';
        rAssessingStudents: Record "Assessing Students";
        rSettingRatings: Record "Setting Ratings";
        rStudyPlanLines: Record "Study Plan Lines";
        vOption: Integer;
        Text99903: Label 'You can not delete %1 because it already has evaluations.';
    begin
        if (xRec."Moment Code" <> "Moment Code") or (xRec."School Year" <> "School Year") or
           (xRec."Schooling Year" <> "Schooling Year") then begin

            if Confirm(Text99901, false, FieldCaption("Moment Code")) then
                if Confirm(Text99902, false, FieldCaption("Moment Code"), FieldCaption("Schooling Year")) then begin
                    rAssessingStudents.Reset;
                    rAssessingStudents.SetRange("School Year", xRec."School Year");
                    rAssessingStudents.SetRange("Schooling Year", xRec."Schooling Year");
                    rAssessingStudents.SetRange("Moment Code", xRec."Moment Code");
                    if rAssessingStudents.Find('-') then
                        Error(Text99903, FieldCaption("Moment Code"));

                    rSettingRatings.Reset;
                    rSettingRatings.SetRange("School Year", xRec."School Year");
                    rSettingRatings.SetRange("Schooling Year", "Schooling Year");
                    rSettingRatings.SetRange("Responsibility Center", xRec."Responsibility Center");
                    rSettingRatings.DeleteAll;
                end;
        end;
    end;


    procedure OpenCreateAssessmentConf(pStudyPlanLines: Record "Study Plan Lines")
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatings2: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
    begin
        l_rMoments.Reset;
        l_rMoments.SetRange("School Year", pStudyPlanLines."School Year");
        l_rMoments.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
        l_rMoments.SetRange("Responsibility Center", pStudyPlanLines."Responsibility Center");
        if l_rMoments.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMoments."Moment Code" + ','
            until l_rMoments.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetRange("School Year", pStudyPlanLines."School Year");
            l_rMoments.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 1
            else
                exit;

            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
            l_rSettingRatings.SetRange("School Year", pStudyPlanLines."School Year");
            l_rSettingRatings.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code", pStudyPlanLines.Code);
            l_rSettingRatings.SetRange("Subject Code", pStudyPlanLines."Subject Code");
            l_rSettingRatings.SetRange("Responsibility Center", pStudyPlanLines."Responsibility Center");
            if not l_rSettingRatings.Find('-') then begin
                l_rSettingRatings.Init;
                l_rSettingRatings."Moment Code" := l_rMoments."Moment Code";
                l_rSettingRatings."School Year" := pStudyPlanLines."School Year";
                l_rSettingRatings."Schooling Year" := pStudyPlanLines."Schooling Year";
                l_rSettingRatings."Study Plan Code" := pStudyPlanLines.Code;
                l_rSettingRatings."Subject Code" := pStudyPlanLines."Subject Code";
                l_rSettingRatings."Assessment Code" := pStudyPlanLines."Assessment Code";
                l_rSettingRatings.Type := l_rSettingRatings.Type::Header;
                l_rSettingRatings.Insert;

                l_rSettingRatings.Reset;
                l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatings.SetRange("School Year", pStudyPlanLines."School Year");
                l_rSettingRatings.SetRange("Schooling Year", pStudyPlanLines."Schooling Year");
                l_rSettingRatings.SetRange("Study Plan Code", pStudyPlanLines.Code);
                l_rSettingRatings.SetRange("Subject Code", pStudyPlanLines."Subject Code");
                if l_rSettingRatings.Find('-') then;
                //FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings2);
            end;
            //ELSE begin
            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code");
            l_rSettingRatings.SetRange("School Year");
            l_rSettingRatings.SetRange("Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code");
            l_rSettingRatings.SetRange("Subject Code");

            //FORM.RUN(FORM::"Setting Ratings",l_rSettingRatings);
            //end;
        end;
    end;


    procedure GetMomentDate(pdate: Date; pResponsabilityCenter: Code[20]; pSchoolYear: Code[20]; pSchoolingYear: Code[20]) Out_MomentCode: Code[20]
    var
        l_rMoments: Record "Moments Assessment";
    begin
        l_rMoments.Reset;
        l_rMoments.SetRange("School Year", pSchoolYear);
        l_rMoments.SetRange("Schooling Year", pSchoolingYear);
        l_rMoments.SetRange("Responsibility Center", pResponsabilityCenter);
        if l_rMoments.Find('-') then begin
            repeat
                if (pdate >= l_rMoments."Starting Date") and (pdate <= l_rMoments."End Date") then
                    exit(l_rMoments."Moment Code");
            until l_rMoments.Next = 0;
        end;
    end;
}

