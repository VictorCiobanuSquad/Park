table 52777 "Setting Ratings"
{
    Caption = 'Setting Ratings';
    LookupPageID = "Setting Ratings Subjects List";

    fields
    {
        field(1; "Moment Code"; Code[10])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code" WHERE("Responsibility Center" = FIELD("Responsibility Center"),
                                                                      "School Year" = FIELD("School Year"),
                                                                      "Schooling Year" = FIELD("Schooling Year"));

            trigger OnLookup()
            var
                l_rMomentsAssessment: Record "Moments Assessment";
            begin


                l_rMomentsAssessment.Reset;
                l_rMomentsAssessment.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                if l_rMomentsAssessment.Find('-') then begin
                    if PAGE.RunModal(PAGE::"Setting Moments", l_rMomentsAssessment) = ACTION::LookupOK then begin
                        Validate("Moment Code", l_rMomentsAssessment."Moment Code");
                        "School Year" := l_rMomentsAssessment."School Year";
                        Validate("Schooling Year", l_rMomentsAssessment."Schooling Year");


                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Moment Code" <> '' then begin
                    if Type = Type::Header then begin
                        rMomentsAssessment.Reset;
                        rMomentsAssessment.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                        rMomentsAssessment.SetFilter("Moment Code", "Moment Code");
                        if rMomentsAssessment.Find('-') then begin
                            "Moment Code" := rMomentsAssessment."Moment Code";
                            "School Year" := rMomentsAssessment."School Year";
                            Validate("Schooling Year", rMomentsAssessment."Schooling Year");
                        end;
                    end;
                end else begin
                    "Moment Code" := '';
                    "School Year" := '';
                    Validate("Schooling Year", '');
                end;
            end;
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                if rCompanyInformation.Get then;
                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.FindFirst then
                    "Type Education" := rStruEduCountry.Type
            end;
        }
        field(4; "Subject Code"; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code;
        }
        field(5; Description; Text[64])
        {
            Caption = 'Description';
        }
        field(6; "Criterion 1"; Text[200])
        {
            Caption = 'Criterion 1';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(7; "Criterion 2"; Text[200])
        {
            Caption = 'Criterion 2';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(8; "Criterion 3"; Text[200])
        {
            Caption = 'Criterion 3';
            TableRelation = "Criteria Evaluation".Description;
        }
        field(9; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code;
        }
        field(10; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(11; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Lines';
            OptionMembers = Header,Lines;
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(13; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                                 "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
        }
        field(20; "Type Education"; Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21; "Moment Ponder"; Integer)
        {
            Caption = 'Moment Ponder';
            InitValue = 1;
            MaxValue = 999999999;
            MinValue = 1;
        }
        field(22; "Responsibility Center"; Code[10])
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
    }

    keys
    {
        key(Key1; "Moment Code", "School Year", "Schooling Year", "Study Plan Code", "Subject Code", Type, "Type Education", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Study Plan Code", "Type Education")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_rSettingRatings: Record "Setting Ratings";
        lSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
    begin

        if Type = Type::Header then begin
            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code", "Moment Code");
            l_rSettingRatings.SetRange("School Year", "School Year");
            l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code", "Study Plan Code");
            l_rSettingRatings.SetRange(Type, l_rSettingRatings.Type::Lines);
            l_rSettingRatings.SetRange("Subject Code", "Subject Code");
            l_rSettingRatings.SetRange("Type Education", "Type Education");
            l_rSettingRatings.DeleteAll;

            //Updade General Table
            InsertNAVGeneralTable.DelSubjetsSettingRatings(Rec);

            rAspects.Reset;
            if "Type Education" = "Type Education"::Simple then
                rAspects.SetRange(Type, rAspects.Type::"Study Plan");
            if "Type Education" = "Type Education"::Multi then
                rAspects.SetRange(Type, rAspects.Type::Course);
            rAspects.SetRange("Type No.", "Study Plan Code");
            rAspects.SetRange("School Year", "School Year");
            rAspects.SetRange("Schooling Year", "Schooling Year");
            rAspects.SetRange("Moment Code", "Moment Code");
            rAspects.SetRange(Subjects, "Subject Code");
            rAspects.SetRange("Sub Subjects", '');
            rAspects.SetRange("Responsibility Center", "Responsibility Center");
            rAspects.DeleteAll(true);

            //delete Subsubjects aspects
            lSettingRatingsSubSubjects.Reset;
            lSettingRatingsSubSubjects.SetRange("Moment Code", "Moment Code");
            lSettingRatingsSubSubjects.SetRange("School Year", "School Year");
            lSettingRatingsSubSubjects.SetRange("Schooling Year", "Schooling Year");
            lSettingRatingsSubSubjects.SetRange("Study Plan Code", "Study Plan Code");
            lSettingRatingsSubSubjects.SetRange("Subject Code", "Subject Code");
            lSettingRatingsSubSubjects.SetRange("Type Education", "Type Education");
            lSettingRatingsSubSubjects.SetRange("Line No.", "Line No.");
            lSettingRatingsSubSubjects.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;

        //Insert Aspects
        InsertNAVGeneralTable.InsertSettingRatings(Rec);
    end;

    var
        rMomentsAssessment: Record "Moments Assessment";
        cStudentsRegistration: Codeunit "Students Registration";
        Text0001: Label 'Confirm deleting and copying settings from another Moment?';
        Text0007: Label 'Confirm deleting and copying settings from another Moment?';
        Text0005: Label 'There is no configuration for Moment %1!';
        Text0006: Label 'Copied successfully.';
        rCompanyInformation: Record "Company Information";
        rStruEduCountry: Record "Structure Education Country";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        cUserEducation: Codeunit "User Education";
        rAspects: Record Aspects;
        InsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text0002: Label 'Do you confirm you wish to erase the Aspects line for the %1 Subject and Sub-subjects (if any) for the %2 Moment?';

    //[Scope('OnPrem')]
    procedure CopyAssessmentConf()
    var
        l_rSettingRatings: Record "Setting Ratings";
        l_rSettingRatingsLine: Record "Setting Ratings";
        l_rSettingRatingsLine2: Record "Setting Ratings";
        l_rMoments: Record "Moments Assessment";
        tAssessment: Text[1024];
        int: Integer;
    begin
        if not Confirm(Text0001, false) then
            exit;

        l_rSettingRatings.Reset;
        l_rSettingRatings.SetRange("Moment Code", "Moment Code");
        l_rSettingRatings.SetRange("School Year", "School Year");
        l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
        l_rSettingRatings.SetRange("Study Plan Code", "Study Plan Code");
        l_rSettingRatings.SetRange("Subject Code", "Subject Code");
        l_rSettingRatings.SetRange(Type, l_rSettingRatings.Type::Lines);
        l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        if l_rSettingRatings.Find('-') then
            Error(Text0007);

        l_rSettingRatings.Reset;
        l_rSettingRatings.SetRange("Moment Code", "Moment Code");
        l_rSettingRatings.SetRange("School Year", "School Year");
        l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
        l_rSettingRatings.SetRange("Study Plan Code", "Study Plan Code");
        l_rSettingRatings.SetRange("Subject Code", "Subject Code");
        l_rSettingRatings.SetRange(Type, l_rSettingRatings.Type::Lines);
        l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
        if l_rSettingRatings.Find('-') then
            l_rSettingRatings.DeleteAll;

        l_rMoments.Reset;
        l_rMoments.SetRange("School Year", "School Year");
        l_rMoments.SetRange("Schooling Year", "Schooling Year");
        l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
        if l_rMoments.Find('-') then
            repeat
                tAssessment := tAssessment + l_rMoments."Moment Code" + ','
            until l_rMoments.Next = 0;

        if tAssessment <> '' then begin
            int := StrMenu(tAssessment);
            l_rMoments.Reset;
            l_rMoments.SetRange("School Year", "School Year");
            l_rMoments.SetRange("Schooling Year", "Schooling Year");
            l_rMoments.SetRange("Responsibility Center", "Responsibility Center");
            if l_rMoments.Find('-') and (int <> 0) then
                l_rMoments.Next := int - 1
            else
                exit;

            l_rSettingRatings.Reset;
            l_rSettingRatings.SetRange("Moment Code", l_rMoments."Moment Code");
            l_rSettingRatings.SetRange("School Year", "School Year");
            l_rSettingRatings.SetRange("Schooling Year", "Schooling Year");
            l_rSettingRatings.SetRange("Study Plan Code", "Study Plan Code");
            l_rSettingRatings.SetRange("Subject Code", "Subject Code");
            l_rSettingRatings.SetRange(Type, l_rSettingRatings.Type::Header);
            l_rSettingRatings.SetRange("Responsibility Center", "Responsibility Center");
            if l_rSettingRatings.Find('-') then begin
                l_rSettingRatingsLine.Reset;
                l_rSettingRatingsLine.SetRange("Moment Code", l_rMoments."Moment Code");
                l_rSettingRatingsLine.SetRange("School Year", "School Year");
                l_rSettingRatingsLine.SetRange("Schooling Year", "Schooling Year");
                l_rSettingRatingsLine.SetRange("Study Plan Code", l_rSettingRatings."Study Plan Code");
                l_rSettingRatingsLine.SetRange("Subject Code", "Subject Code");
                l_rSettingRatingsLine.SetRange(Type, l_rSettingRatingsLine.Type::Lines);
                l_rSettingRatingsLine.SetRange("Responsibility Center", l_rSettingRatings."Responsibility Center");
                if l_rSettingRatingsLine.Find('-') then begin
                    repeat
                        l_rSettingRatingsLine2.Init;
                        l_rSettingRatingsLine2.TransferFields(l_rSettingRatingsLine);
                        l_rSettingRatingsLine2."Moment Code" := "Moment Code";
                        l_rSettingRatingsLine2."School Year" := "School Year";
                        l_rSettingRatingsLine2."Schooling Year" := "Schooling Year";
                        l_rSettingRatingsLine2."Study Plan Code" := "Study Plan Code";
                        l_rSettingRatingsLine2."Subject Code" := "Subject Code";
                        l_rSettingRatingsLine2."Responsibility Center" := "Responsibility Center";
                        l_rSettingRatingsLine2.Type := l_rSettingRatings.Type::Lines;
                        l_rSettingRatingsLine2.Insert(true);
                    until l_rSettingRatingsLine.Next = 0;
                    Message(Text0006);
                end
                else
                    Message(Text0005);
            end
            else
                Message(Text0005);
        end;
    end;

    //[Scope('OnPrem')]
    procedure DeleteAspects(var pAspects: Record Aspects; pSettingRatings: Record "Setting Ratings")
    var
        lAspects: Record Aspects;
    begin
        if not Confirm(StrSubstNo(Text0002, pAspects."Sub Subjects", pAspects."Moment Code"), false) then
            exit;

        lAspects.Reset;
        lAspects.SetRange(Type, pAspects.Type);
        lAspects.SetRange("School Year", pAspects."School Year");
        lAspects.SetRange("Type No.", pAspects."Type No.");
        lAspects.SetRange("Moment Code", pAspects."Moment Code");
        lAspects.SetRange(Subjects, pAspects.Subjects);
        //lAspects.SETRANGE("Sub Subjects",pAspects."Sub Subjects");
        lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
        if lAspects.Find('-') then
            lAspects.DeleteAll(true);

        //COMMIT;

        pAspects.Reset;
        pAspects.SetRange(Type, rAspects.Type::Course);
        pAspects.SetRange("School Year", pSettingRatings."School Year");
        pAspects.SetRange(Subjects, pSettingRatings."Subject Code");
        pAspects.SetRange("Sub Subjects", '');
        pAspects.SetRange("Moment Code", pSettingRatings."Moment Code");
        pAspects.SetRange("Responsibility Center", pSettingRatings."Responsibility Center");
    end;
}

