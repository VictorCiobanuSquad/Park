table 52812 Aspects
{
    Caption = 'Aspects';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Overall,Course,Class,Study Plan,Student';
            OptionMembers = " ",Overall,Course,Class,"Study Plan",Student;
        }
        field(2; "Type No."; Code[20])
        {
            Caption = 'Type No.';
            TableRelation = IF (Type = FILTER(Class)) Class.Class
            ELSE
            IF (Type = FILTER(Student)) Students."No."
            ELSE
            IF (Type = FILTER(Course)) "Course Header".Code
            ELSE
            IF (Type = FILTER("Study Plan")) "Study Plan Header".Code;
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            var
                lAspects: Record Aspects;
            begin
                if Type = Type::Overall then begin
                    lAspects.Reset;
                    lAspects.SetRange(Type, Type);
                    lAspects.SetRange("School Year", "School Year");
                    lAspects.SetRange(Code, Code);
                    if lAspects.FindFirst then
                        Error(Text003, Code);
                end;
            end;
        }
        field(6; "% Evaluation"; Decimal)
        {
            Caption = '% Evaluation';

            trigger OnValidate()
            var
                lAspects: Record Aspects;
            begin
                if Type = Type::Overall then begin
                    lAspects.Reset;
                    lAspects.SetRange("School Year", "School Year");
                    lAspects.SetRange("Responsibility Center", "Responsibility Center");
                    lAspects.SetRange(Code, Code);
                    lAspects.SetFilter(Type, '<>%1', Type);
                    if lAspects.FindFirst then
                        Error(Text0007);
                end;

                "Count%";

                if (Type <> Type::" ") or (Type <> Type::Overall) then begin
                    Modified := true;
                    lAspects.Reset;
                    lAspects.SetRange(Type, Type);
                    lAspects.SetRange("Type No.", "Type No.");
                    lAspects.SetRange("School Year", "School Year");
                    lAspects.SetRange("Responsibility Center", "Responsibility Center");
                    if Type <> Type::Overall then begin
                        lAspects.SetRange("Moment Code", "Moment Code");
                        lAspects.SetRange(Subjects, Subjects);
                        lAspects.SetRange("Sub Subjects", "Sub Subjects");
                    end;
                    lAspects.SetFilter("Line No.", '<>%1', "Line No.");
                    if lAspects.Find('-') then
                        repeat
                            lAspects.Modified := true;
                            lAspects.Modify;
                        until lAspects.Next = 0;
                end;
            end;
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(9; "Moment Code"; Code[10])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code";
        }
        field(10; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));

            trigger OnValidate()
            var
                lAspects: Record Aspects;
            begin
                if Type = Type::Overall then begin
                    lAspects.Reset;
                    lAspects.SetRange("School Year", "School Year");
                    lAspects.SetRange("Responsibility Center", "Responsibility Center");
                    lAspects.SetRange(Code, Code);
                    lAspects.SetFilter(Type, '<>%1', Type);
                    if lAspects.FindFirst then
                        Error(Text0006);
                end;
            end;
        }
        field(11; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            var
                lAspects: Record Aspects;
            begin
                if Type = Type::Overall then begin
                    lAspects.Reset;
                    lAspects.SetRange("School Year", "School Year");
                    lAspects.SetRange("Responsibility Center", "Responsibility Center");
                    lAspects.SetRange(Code, Code);
                    lAspects.SetFilter(Type, '<>%1', Type);
                    if lAspects.FindFirst then
                        Error(Text0008);
                end;


                if "Evaluation Type" <> xRec."Evaluation Type" then
                    Validate("Assessment Code", '');
            end;
        }
        field(12; Subjects; Code[10])
        {
            Caption = 'Subject Code';
            TableRelation = Subjects.Code;
        }
        field(13; "Sub Subjects"; Code[20])
        {
            Caption = 'Sub-Subject Code';
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
        field(15; "Not to WEB"; Boolean)
        {
            Caption = 'Not to Web';
        }
        field(16; Modified; Boolean)
        {
            Caption = 'Modified';
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
                LoginMgt.DisplayUserInformation("User ID");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; Type, "School Year", "Type No.", "Schooling Year", "Moment Code", Subjects, "Sub Subjects", "Responsibility Center", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center", "Code", Modified, "Moment Code", Subjects, "Sub Subjects")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_Aspects: Record Aspects;
    begin
        DeleteAspects;
        //Test if the line is the last for the current study plan to delete in the master table
        if (Type = Type::Course) or (Type = Type::"Study Plan") then begin
            l_Aspects.Reset;
            l_Aspects.SetRange(Type, Type);
            l_Aspects.SetRange("Type No.", "Type No.");
            l_Aspects.SetRange("School Year", "School Year");
            l_Aspects.SetRange(Code, Code);
            if l_Aspects.Count - 1 = 0 then
                cInsertNAVMasterTable.DeleteAspects(Rec, xRec);
        end;

        cInsertNAVGeneralTable.ModDelAspects(Rec, xRec, true);
    end;

    trigger OnInsert()
    begin
        if Type = Type::Overall then begin
            if Code = '' then
                Error(Text005);

            rEduConfiguration.Get;
            rSchoolYear.Reset;
            rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
            if rSchoolYear.Find('-') then;

            if rUserSetup.Get(UserId) then begin
                if "Responsibility Center" = '' then
                    "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
            end;

            if RespCenter.Get("Responsibility Center") then;
            rAspects.Reset;
            rAspects.SetRange(Type, rAspects.Type::Overall);
            rAspects.SetRange("School Year", rSchoolYear."School Year");
            if "Responsibility Center" <> '' then begin
                rAspects.SetRange("Responsibility Center", "Responsibility Center");
                if rAspects.Count + 1 > RespCenter."Aspects Max" then
                    Error(Text002, RespCenter."Aspects Max");
            end
            else begin
                rAspects.SetFilter("Responsibility Center", '%1', '');

                if rAspects.Count + 1 > rEduConfiguration."Aspects Max" then
                    Error(Text002, rEduConfiguration."Aspects Max");
            end;
            "Not to WEB" := true;
        end;

        "User Id" := UserId;
        Date := WorkDate;
        Modified := false;

        if (Type = Type::Course) or (Type = Type::"Study Plan") then begin
            cInsertNAVMasterTable.InsertAspects(Rec, xRec);
            if not "Not to WEB" then begin
                InsertStudyPlanAspects;
            end;
        end;
    end;

    trigger OnModify()
    var
        lClass: Record Class;
        lRegistrationClass: Record "Registration Class";
        lRegistrationSubjects: Record "Registration Subjects";
    begin
        //If the aspect goes to WEB must change all lines for the students and class
        if ((Type = Type::Course) or (Type = Type::"Study Plan")) and ("Not to WEB" <> xRec."Not to WEB") then begin

            //Insert or delete Aspects From WEB
            cInsertNAVGeneralTable.DelInsCourseSubjects(Rec);

            //Change All Lines For this Course/Study Plan
            rAspects.Reset;
            rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            rAspects.SetRange(Type, Type);
            rAspects.SetRange("School Year", "School Year");
            rAspects.SetRange("Type No.", "Type No.");
            rAspects.SetRange("Schooling Year", "Schooling Year");
            rAspects.SetRange("Responsibility Center", "Responsibility Center");
            rAspects.SetRange(Code, Code);
            if rAspects.Find('-') then
                repeat
                    if (Subjects <> rAspects.Subjects) or ("Sub Subjects" <> rAspects."Sub Subjects") or
                       ("Moment Code" <> rAspects."Moment Code") then begin

                        rAspects."Not to WEB" := "Not to WEB";
                        rAspects.Modify(true);

                        //Insert or delete Aspects From WEB
                        cInsertNAVGeneralTable.DelInsCourseSubjects(rAspects);

                    end;
                until rAspects.Next = 0;

            //Change All Lines For the classes and Students
            lClass.Reset;
            lClass.SetRange("School Year", "School Year");
            lClass.SetRange("Schooling Year", "Schooling Year");
            lClass.SetRange("Study Plan Code", "Type No.");
            if (Type = Type::Course) then
                lClass.SetRange(Type, lClass.Type::Multi)
            else
                lClass.SetRange(Type, lClass.Type::Simple);
            if lClass.FindSet then begin
                repeat
                    rAspects.Reset;
                    rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                     Code, Modified, "Moment Code", Subjects, "Sub Subjects");

                    rAspects.SetRange(Type, Type::Class);
                    rAspects.SetRange("School Year", "School Year");
                    rAspects.SetFilter("Type No.", lClass.Class);
                    rAspects.SetRange("Schooling Year", "Schooling Year");
                    rAspects.SetRange("Responsibility Center", "Responsibility Center");
                    rAspects.SetRange(Code, Code);
                    rAspects.ModifyAll("Not to WEB", "Not to WEB", true);

                    lRegistrationClass.Reset;
                    lRegistrationClass.SetCurrentKey("School Year", "Study Plan Code", Class, Status);
                    lRegistrationClass.SetRange(Class, lClass.Class);
                    lRegistrationClass.SetRange("School Year", "School Year");
                    lRegistrationClass.SetRange("Schooling Year", "Schooling Year");
                    lRegistrationClass.SetRange("Study Plan Code", "Type No.");
                    lRegistrationClass.SetRange(Type, lClass.Type);
                    lRegistrationClass.SetRange(Status, lRegistrationClass.Status::Subscribed);
                    if lRegistrationClass.FindSet then
                        repeat
                            //Insert or delete Aspects From WEB
                            //cInsertNAVGeneralTable.DelInsCourseSubjects(Rec);

                            rAspects.Reset;
                            rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                             Code, Modified, "Moment Code", Subjects, "Sub Subjects");

                            rAspects.SetRange(Type, Type::Student);
                            rAspects.SetRange("School Year", "School Year");
                            rAspects.SetFilter("Type No.", lRegistrationClass."Student Code No.");
                            rAspects.SetRange("Schooling Year", "Schooling Year");
                            rAspects.SetRange("Responsibility Center", "Responsibility Center");
                            rAspects.SetRange(Code, Code);
                            rAspects.ModifyAll("Not to WEB", "Not to WEB", true);

                        until lRegistrationClass.Next = 0;

                until lClass.Next = 0;
            end;
        end;


        ModifyAspects;

        if (Type = Type::Course) or (Type = Type::"Study Plan") then
            cInsertNAVMasterTable.ModifyAspects(Rec, xRec);

        cInsertNAVGeneralTable.ModDelAspects(Rec, xRec, false);
    end;

    trigger OnRename()
    begin
        Error(Text006, TableCaption);
    end;

    var
        rAspects: Record Aspects;
        rEduConfiguration: Record "Edu. Configuration";
        rSchoolYear: Record "School Year";
        varCount: Decimal;
        Text001: Label 'Overall value cannot be higher than 100%.';
        Text002: Label 'Aspect maximum allowance is %1.';
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        rUserSetup: Record "User Setup";
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text003: Label 'The Aspcect %1 already exist.';
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        Text005: Label 'The Code field is mandatory.';
        Text006: Label 'You cannot rename a %1.';
        Text0005: Label 'Not allowed to change the code.';
        Text0006: Label 'Not allowed to change the Assessment Code.';
        Text0007: Label 'Not allowed to change the % Evaluation.';
        Text0008: Label 'Not allowed to change the Evaluation Type.';


    procedure "Count%"()
    begin
        Clear(varCount);
        varCount := "% Evaluation";

        rAspects.Reset;
        rAspects.SetRange(Type, Type);
        rAspects.SetRange("Type No.", "Type No.");
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Schooling Year", "Schooling Year");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if Type <> Type::Overall then begin
            rAspects.SetRange("Moment Code", "Moment Code");
            rAspects.SetRange(Subjects, Subjects);
            rAspects.SetRange("Sub Subjects", "Sub Subjects");
        end;

        rAspects.SetFilter("Line No.", '<>%1', "Line No.");
        if rAspects.Find('-') then begin
            repeat
                varCount += rAspects."% Evaluation";
            until rAspects.Next = 0;
        end;

        if varCount > 100 then
            Error(Text001);
    end;


    procedure InsertDefaultAspects(var pAspects: Record Aspects; pType: Integer; pSchoolYear: Code[9]; pTypeNo: Code[20]; pRespCenter: Code[10])
    var
        l_rAspects: Record Aspects;
        l_rAspectsINSERT: Record Aspects;
    begin
        l_rAspectsINSERT.Copy(pAspects);

        l_rAspects.Reset;
        l_rAspects.SetRange(Type, Type::Overall);
        l_rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if l_rAspects.Find('-') then
            repeat
                l_rAspectsINSERT.Init;
                l_rAspectsINSERT.TransferFields(l_rAspects);
                l_rAspectsINSERT.Type := pType;
                l_rAspectsINSERT."School Year" := pSchoolYear;
                l_rAspectsINSERT."Type No." := pTypeNo;
                l_rAspectsINSERT."User Id" := UserId;
                l_rAspectsINSERT.Date := WorkDate;
                l_rAspectsINSERT."Responsibility Center" := pRespCenter;
                l_rAspectsINSERT.Insert(true);
            until l_rAspects.Next = 0;

        //l_rAspectsINSERT.COPY(pAspects);

        pAspects.Copy(l_rAspectsINSERT);
    end;


    procedure InsertDefaultAspects2(var pAspects: Record Aspects; pType: Integer; pSchoolYear: Code[9]; pTypeNo: Code[20]; pMomentCode: Code[10]; pSchoolingYear: Code[10]; pSubjectCode: Code[10]; pSubSubjectCode: Code[20]; pEvaluationType: Option; pAssessmentCode: Code[20]; pRespCenter: Code[10])
    var
        l_rAspects: Record Aspects;
        l_rAspectsINSERT: Record Aspects;
        rClass: Record Class;
        rRegistrationSubjects: Record "Registration Subjects";
    begin
        l_rAspectsINSERT.Copy(pAspects);

        // Course and study plan
        if ((pType = 2) or (pType = 4)) and (pSubSubjectCode = '') then begin
            //Get the global aspects
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, Type::Overall);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if l_rAspects.Find('-') then
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                             pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;

            pAspects.Copy(l_rAspectsINSERT);
            exit;
        end;

        // Course and study plan
        if ((pType = 2) or (pType = 4)) and (pSubSubjectCode <> '') then begin
            //Get subject aspect of the course or study plan
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, pType);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Type No.", pTypeNo);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
            //Get Global aspects if not find the last group
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, Type::Overall);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
        end;

        //Class
        if (pType = 3) and (pSubSubjectCode = '') then begin
            if rClass.Get(pTypeNo, pSchoolYear) then begin
                //Get the course/study plan subject aspect
                l_rAspects.Reset;
                l_rAspects.SetRange("School Year", pSchoolYear);
                l_rAspects.SetRange("Schooling Year", pSchoolingYear);
                l_rAspects.SetRange("Type No.", rClass."Study Plan Code");
                l_rAspects.SetRange("Responsibility Center", pRespCenter);
                l_rAspects.SetRange(Subjects, pSubjectCode);
                l_rAspects.SetRange("Moment Code", pMomentCode);
                l_rAspects.SetRange("Sub Subjects", '');
                l_rAspects.SetRange(Modified, true);
                if rClass.Type = rClass.Type::Simple then
                    l_rAspects.SetRange(Type, 4);
                if rClass.Type = rClass.Type::Multi then
                    l_rAspects.SetRange(Type, 2);
                if l_rAspects.Find('-') then begin
                    repeat
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                             pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                    until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end else begin
                    //Get Global aspects if not find the last group
                    l_rAspects.Reset;
                    l_rAspects.SetRange(Type, Type::Overall);
                    l_rAspects.SetRange("Responsibility Center", pRespCenter);
                    if l_rAspects.Find('-') then
                        repeat
                            fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                    pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                        until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end;
            end;
        end;

        // Class
        if (pType = 3) and (pSubSubjectCode <> '') then begin
            //Get the subject class aspects
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, pType);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Type No.", pTypeNo);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    if l_rAspects."Sub Subjects" = '' then
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;

            //Get the sub-subject Course/Study plan aspects
            if rClass.Get(pTypeNo, pSchoolYear) then begin
                l_rAspects.Reset;
                if rClass.Type = rClass.Type::Simple then
                    l_rAspects.SetRange(Type, 4);
                if rClass.Type = rClass.Type::Multi then
                    l_rAspects.SetRange(Type, 2);
                l_rAspects.SetRange("School Year", pSchoolYear);
                l_rAspects.SetRange("Schooling Year", pSchoolingYear);
                l_rAspects.SetRange("Type No.", rClass."Study Plan Code");
                l_rAspects.SetRange(Subjects, pSubjectCode);
                l_rAspects.SetRange("Sub Subjects", pSubSubjectCode);
                l_rAspects.SetRange("Responsibility Center", pRespCenter);
                l_rAspects.SetRange("Sub Subjects", pSubSubjectCode);
                l_rAspects.SetRange("Moment Code", pMomentCode);
                l_rAspects.SetRange(Modified, true);
                if l_rAspects.Find('-') then begin
                    repeat
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                    until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end;

                //Get the subject Course/Study plan aspects
                l_rAspects.Reset;
                if rClass.Type = rClass.Type::Simple then
                    l_rAspects.SetRange(Type, 4);
                if rClass.Type = rClass.Type::Multi then
                    l_rAspects.SetRange(Type, 2);
                l_rAspects.SetRange("School Year", pSchoolYear);
                l_rAspects.SetRange("Schooling Year", pSchoolingYear);
                l_rAspects.SetRange("Type No.", rClass."Study Plan Code");
                l_rAspects.SetRange(Subjects, pSubjectCode);
                l_rAspects.SetRange("Sub Subjects", pSubSubjectCode);
                l_rAspects.SetRange("Responsibility Center", pRespCenter);
                l_rAspects.SetRange("Sub Subjects", '');
                l_rAspects.SetRange("Moment Code", pMomentCode);
                l_rAspects.SetRange(Modified, true);
                if l_rAspects.Find('-') then begin
                    repeat
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                    until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end;
            end;
            //
            //Get Global aspects if not find the last group
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, Type::Overall);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;

                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
        end;

        //Student
        if (pType = 5) and (pSubSubjectCode = '') then begin

            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange("Student Code No.", pTypeNo);
            rRegistrationSubjects.SetRange("School Year", pSchoolYear);
            rRegistrationSubjects.SetRange("Subjects Code", pSubjectCode);
            rRegistrationSubjects.SetRange("Responsibility Center", pRespCenter);
            rRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
            if rRegistrationSubjects.Find('-') then;

            //Get the class subject
            l_rAspects.Reset;
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange(Type, 3);
            l_rAspects.SetRange("Type No.", rRegistrationSubjects.Class);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
            //Get the course/Study plan Subject
            l_rAspects.Reset;
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Simple then
                l_rAspects.SetRange(Type, 4);
            if rRegistrationSubjects.Type = rRegistrationSubjects.Type::Multi then
                l_rAspects.SetRange(Type, 2);
            l_rAspects.SetRange("Type No.", rRegistrationSubjects."Study Plan Code");
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;

            //Overall
            //Get Global aspects if not find the last group
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, Type::Overall);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
        end;

        //Student
        if (pType = 5) and (pSubSubjectCode <> '') then begin
            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange("Student Code No.", pTypeNo);
            rRegistrationSubjects.SetRange("School Year", pSchoolYear);
            rRegistrationSubjects.SetRange("Subjects Code", pSubjectCode);
            rRegistrationSubjects.SetRange("Responsibility Center", pRespCenter);
            rRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
            if rRegistrationSubjects.Find('-') then;

            //Get the student Subject aspects
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, pType);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Type No.", pTypeNo);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    if l_rAspects."Sub Subjects" = '' then
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                             pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;

            //Get the class sub-subject
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, 3);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Type No.", rRegistrationSubjects.Class);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange("Sub Subjects", pSubSubjectCode);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                exit;
            end;

            //Get the class subject
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, 3);
            l_rAspects.SetRange("School Year", pSchoolYear);
            l_rAspects.SetRange("Schooling Year", pSchoolingYear);
            l_rAspects.SetRange("Type No.", rRegistrationSubjects.Class);
            l_rAspects.SetRange(Subjects, pSubjectCode);
            l_rAspects.SetRange("Moment Code", pMomentCode);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            l_rAspects.SetRange("Sub Subjects", '');
            l_rAspects.SetRange(Modified, true);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                exit;
            end;

            //Get the Course/Study plan sub-subject
            if rClass.Get(rRegistrationSubjects.Class, pSchoolYear) then begin
                l_rAspects.Reset;
                if rClass.Type = rClass.Type::Simple then
                    l_rAspects.SetRange(Type, 4);
                if rClass.Type = rClass.Type::Multi then
                    l_rAspects.SetRange(Type, 2);
                l_rAspects.SetRange("School Year", pSchoolYear);
                l_rAspects.SetRange("Schooling Year", pSchoolingYear);
                l_rAspects.SetRange("Type No.", rClass."Study Plan Code");
                l_rAspects.SetRange(Subjects, pSubjectCode);
                l_rAspects.SetRange("Sub Subjects", pSubSubjectCode);
                l_rAspects.SetRange("Moment Code", pMomentCode);
                l_rAspects.SetRange("Responsibility Center", pRespCenter);
                l_rAspects.SetRange(Modified, true);
                if l_rAspects.Find('-') then begin
                    repeat
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                    until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end;

                //Get the Course/Study plan subject
                l_rAspects.Reset;
                if rClass.Type = rClass.Type::Simple then
                    l_rAspects.SetRange(Type, 4);
                if rClass.Type = rClass.Type::Multi then
                    l_rAspects.SetRange(Type, 2);
                l_rAspects.SetRange("School Year", pSchoolYear);
                l_rAspects.SetRange("Schooling Year", pSchoolingYear);
                l_rAspects.SetRange("Type No.", rClass."Study Plan Code");
                l_rAspects.SetRange(Subjects, pSubjectCode);
                l_rAspects.SetRange("Sub Subjects", '');
                l_rAspects.SetRange("Moment Code", pMomentCode);
                l_rAspects.SetRange("Responsibility Center", pRespCenter);
                l_rAspects.SetRange(Modified, true);
                if l_rAspects.Find('-') then begin
                    repeat
                        fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                                pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                    until l_rAspects.Next = 0;
                    pAspects.Copy(l_rAspectsINSERT);
                    exit;
                end;
            end;
            //Overall
            //Get Global aspects if not find the last group
            l_rAspects.Reset;
            l_rAspects.SetRange(Type, Type::Overall);
            l_rAspects.SetRange("Responsibility Center", pRespCenter);
            if l_rAspects.Find('-') then begin
                repeat
                    fInsert(l_rAspects, pType, pSchoolYear, pTypeNo, pMomentCode, pSchoolingYear,
                            pSubjectCode, pSubSubjectCode, l_rAspects."Evaluation Type", l_rAspects."Assessment Code", pRespCenter);
                until l_rAspects.Next = 0;
                pAspects.Copy(l_rAspectsINSERT);
                exit;
            end;
            //
        end;
    end;


    procedure fInsert(var pAspects: Record Aspects; pType: Integer; pSchoolYear: Code[9]; pTypeNo: Code[20]; pMomentCode: Code[10]; pSchoolingYear: Code[10]; pSubjectCode: Code[10]; pSubSubjectCode: Code[20]; pEvaluationType: Option; pAssessmentCode: Code[20]; pRespCenter: Code[10])
    var
        l_rAspectsINSERT: Record Aspects;
        l_InsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        lClass: Record Class;
        lRegistrationSubjects: Record "Registration Subjects";
    begin
        l_rAspectsINSERT.Init;
        l_rAspectsINSERT.TransferFields(pAspects);
        l_rAspectsINSERT.Type := pType;
        l_rAspectsINSERT."School Year" := pSchoolYear;
        l_rAspectsINSERT."Type No." := pTypeNo;
        l_rAspectsINSERT."Schooling Year" := pSchoolingYear;
        l_rAspectsINSERT."Moment Code" := pMomentCode;
        l_rAspectsINSERT.Subjects := pSubjectCode;
        l_rAspectsINSERT."Sub Subjects" := pSubSubjectCode;
        if (l_rAspectsINSERT.Type = l_rAspectsINSERT.Type::"Study Plan") or
           (l_rAspectsINSERT.Type = l_rAspectsINSERT.Type::Course) then begin
            l_rAspectsINSERT."Evaluation Type" := pAspects."Evaluation Type";
            l_rAspectsINSERT."Assessment Code" := pAspects."Assessment Code";
        end else begin
            l_rAspectsINSERT."Evaluation Type" := pEvaluationType;
            l_rAspectsINSERT."Assessment Code" := pAssessmentCode;
        end;

        if (l_rAspectsINSERT.Type = l_rAspectsINSERT.Type::"Study Plan") or
           (l_rAspectsINSERT.Type = l_rAspectsINSERT.Type::Course) then begin
            l_rAspectsINSERT."Not to WEB" := GetCourseNotWeb(pType, pSchoolYear, pSchoolingYear, pTypeNo, pRespCenter, pAspects.Code);
        end else begin
            //IF Class
            if (pType = 3) then begin
                if lClass.Get(pTypeNo, pSchoolYear) then
                    if lClass.Type = lClass.Type::Multi then
                        l_rAspectsINSERT."Not to WEB" := GetCourseNotWeb(2, pSchoolYear, pSchoolingYear,
                          lClass."Study Plan Code", pRespCenter, pAspects.Code)
                    else
                        l_rAspectsINSERT."Not to WEB" := GetCourseNotWeb(4, pSchoolYear, pSchoolingYear,
                          lClass."Study Plan Code", pRespCenter, pAspects.Code)
            end;

            //IF student
            if (pType = 5) then begin
                lRegistrationSubjects.Reset;
                lRegistrationSubjects.SetRange("Student Code No.", pTypeNo);
                lRegistrationSubjects.SetRange("School Year", pSchoolYear);
                lRegistrationSubjects.SetRange("Schooling Year", pSchoolingYear);
                lRegistrationSubjects.SetRange("Subjects Code", pSubjectCode);
                if lRegistrationSubjects.FindSet then begin
                    if lRegistrationSubjects.Type = lRegistrationSubjects.Type::Multi then
                        l_rAspectsINSERT."Not to WEB" := GetCourseNotWeb(2, pSchoolYear, pSchoolingYear,
                        lRegistrationSubjects."Study Plan Code", pRespCenter, pAspects.Code)
                    else
                        l_rAspectsINSERT."Not to WEB" := GetCourseNotWeb(4, pSchoolYear, pSchoolingYear,
                        lRegistrationSubjects."Study Plan Code", pRespCenter, pAspects.Code)
                end;
            end;
        end;

        l_rAspectsINSERT."User Id" := UserId;
        l_rAspectsINSERT.Date := WorkDate;
        if not l_rAspectsINSERT.Insert(true) then
            l_rAspectsINSERT.Modify(true);

        //IF (pType = 5) THEN
        //   l_InsertNAVGeneralTable.InsertAspectsStudent(pSubSubjectCode,pSubjectCode,pTypeNo,l_rAspectsINSERT);
    end;


    procedure ModifyAspects()
    var
        Text000001: Label 'Update table #1##################';
        Text000002: Label 'Web Aplication';
        Text000003: Label 'Aspects';
    begin
        //
        case Type of
            Type::Overall:
                ModifyOverallAspects(Rec);
            Type::Course:
                ModifyCourseAspects(Rec, "Type No.", 1, Subjects, "Sub Subjects", false);
            Type::"Study Plan":
                ModifyCourseAspects(Rec, "Type No.", 0, Subjects, "Sub Subjects", false);
            Type::Class:
                ModifyClassAspects(Rec, "Type No.", Subjects, "Sub Subjects", false);
            Type::Student:
                ModifyStudentAspects(Rec, "Type No.", Subjects, "Sub Subjects", false);
        end;
    end;


    procedure ModifyStudentAspects(pAspects: Record Aspects; pStudentCode: Code[20]; pSubject: Code[20]; pSubSubject: Code[20]; IsModify: Boolean)
    var
        lAspects: Record Aspects;
        lAspects2: Record Aspects;
        lAspects3: Record Aspects;
        lRegistrationSubjects: Record "Registration Subjects";
    begin
        //Indirect
        if (pSubSubject <> '') and IsModify then begin
            lAspects.Reset;
            lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects.SetRange(Type, lAspects.Type::Student);
            lAspects.SetRange("Type No.", pStudentCode);
            lAspects.SetRange("School Year", pAspects."School Year");
            lAspects.SetFilter(Subjects, pSubject);
            lAspects.SetRange("Sub Subjects", pSubSubject);
            lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects.SetRange("Moment Code", pAspects."Moment Code");
            lAspects.SetRange(Code, pAspects.Code);
            if lAspects.Find('-') then begin
                repeat
                    lAspects.Description := pAspects.Description;
                    lAspects."% Evaluation" := pAspects."% Evaluation";
                    lAspects."Assessment Code" := pAspects."Assessment Code";
                    lAspects."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects."Not to WEB" := pAspects."Not to WEB";
                    lAspects.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects, lAspects, false);

                until lAspects.Next = 0;
            end;
        end;

        if (pSubSubject = '') and IsModify then begin
            lAspects.Reset;
            lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects.SetRange(Type, lAspects.Type::Student);
            lAspects.SetRange("Type No.", pStudentCode);
            lAspects.SetRange("School Year", pAspects."School Year");
            lAspects.SetRange(Subjects, pSubject);
            lAspects.SetRange("Sub Subjects", '');
            lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects.SetRange("Moment Code", pAspects."Moment Code");
            lAspects.SetRange(Code, pAspects.Code);
            if lAspects.Find('-') then begin
                repeat
                    lAspects.Description := pAspects.Description;
                    lAspects."% Evaluation" := pAspects."% Evaluation";
                    lAspects."Assessment Code" := pAspects."Assessment Code";
                    lAspects."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects."Not to WEB" := pAspects."Not to WEB";
                    lAspects.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects, lAspects, false);

                until lAspects.Next = 0;
            end;

            lRegistrationSubjects.Reset;
            lRegistrationSubjects.SetRange("Student Code No.", pStudentCode);
            lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
            lRegistrationSubjects.SetRange("Schooling Year", pAspects."Schooling Year");
            lRegistrationSubjects.SetRange("Subjects Code", pAspects.Subjects);
            if lRegistrationSubjects.FindSet then begin
                lAspects.Reset;
                lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                 Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                lAspects.SetRange(Type, lAspects.Type::Student);
                lAspects.SetRange("Type No.", pStudentCode);
                lAspects.SetRange("School Year", pAspects."School Year");
                lAspects.SetRange(Subjects, pSubject);
                lAspects.SetRange("Sub Subjects", '<>%1', '');
                lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                lAspects.SetRange(Modified, false);
                if pAspects.Type <> pAspects.Type::Overall then
                    lAspects.SetRange("Moment Code", pAspects."Moment Code");
                lAspects.SetRange(Code, pAspects.Code);
                if lAspects.Find('-') then begin
                    repeat
                        lAspects2.Reset;
                        lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                         Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        lAspects2.SetRange(Type, lAspects.Type::Class);
                        lAspects2.SetRange("Type No.", lRegistrationSubjects.Class);
                        lAspects2.SetRange("School Year", pAspects."School Year");
                        lAspects2.SetRange(Subjects, pSubject);
                        lAspects2.SetRange("Sub Subjects", lAspects."Sub Subjects");
                        lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                        lAspects2.SetRange(Modified, false);
                        if pAspects.Type <> pAspects.Type::Overall then
                            lAspects2.SetRange("Moment Code", pAspects."Moment Code");
                        lAspects2.SetRange(Code, pAspects.Code);
                        if not lAspects2.Find('-') then begin
                            repeat
                                lAspects3.Reset;
                                lAspects3.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                 Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                if lRegistrationSubjects.Type = lRegistrationSubjects.Type::Simple then
                                    lAspects3.SetRange(Type, lAspects.Type::"Study Plan")
                                else
                                    lAspects3.SetRange(Type, lAspects.Type::Course);
                                lAspects3.SetRange("Type No.", lRegistrationSubjects."Study Plan Code");
                                lAspects3.SetRange("School Year", pAspects."School Year");
                                lAspects3.SetRange(Subjects, pSubject);
                                lAspects3.SetFilter("Sub Subjects", lAspects."Sub Subjects");
                                lAspects3.SetRange("Responsibility Center", pAspects."Responsibility Center");
                                lAspects3.SetRange(Modified, false);
                                if pAspects.Type <> pAspects.Type::Overall then
                                    lAspects3.SetRange("Moment Code", pAspects."Moment Code");
                                lAspects3.SetRange(Code, pAspects.Code);
                                if not lAspects3.Find('-') then begin
                                    lAspects.Description := pAspects.Description;
                                    lAspects."% Evaluation" := pAspects."% Evaluation";
                                    lAspects."Assessment Code" := pAspects."Assessment Code";
                                    lAspects."Evaluation Type" := pAspects."Evaluation Type";
                                    //12-03
                                    if pAspects.Type = pAspects.Type::Overall then
                                        lAspects."Not to WEB" := pAspects."Not to WEB";
                                    lAspects.Modify;
                                end;
                            until lAspects2.Next = 0;
                        end else begin
                            lAspects3.Reset;
                            lAspects3.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            if lRegistrationSubjects.Type = lRegistrationSubjects.Type::Simple then
                                lAspects3.SetRange(Type, lAspects.Type::"Study Plan")
                            else
                                lAspects3.SetRange(Type, lAspects.Type::Course);
                            lAspects3.SetRange("Type No.", lRegistrationSubjects."Study Plan Code");
                            lAspects3.SetRange("School Year", pAspects."School Year");
                            lAspects3.SetRange(Subjects, pSubject);
                            lAspects3.SetFilter("Sub Subjects", lAspects."Sub Subjects");
                            lAspects3.SetRange("Responsibility Center", pAspects."Responsibility Center");
                            lAspects3.SetRange(Modified, false);
                            if pAspects.Type <> pAspects.Type::Overall then
                                lAspects3.SetRange("Moment Code", pAspects."Moment Code");
                            lAspects3.SetRange(Code, pAspects.Code);
                            if not lAspects3.Find('-') then begin
                                lAspects.Description := pAspects.Description;
                                lAspects."% Evaluation" := pAspects."% Evaluation";
                                lAspects."Assessment Code" := pAspects."Assessment Code";
                                lAspects."Evaluation Type" := pAspects."Evaluation Type";
                                //12-03
                                if pAspects.Type = pAspects.Type::Overall then
                                    lAspects."Not to WEB" := pAspects."Not to WEB";
                                lAspects.Modify;
                            end;
                        end;
                    until lAspects.Next = 0;
                end;
            end;
        end;

        //Direct
        if (pSubSubject = '') and not IsModify then begin
            lAspects.Reset;
            lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects.SetRange(Type, lAspects.Type::Student);
            lAspects.SetRange("Type No.", pStudentCode);
            lAspects.SetRange("School Year", pAspects."School Year");
            lAspects.SetFilter(Subjects, pSubject);
            lAspects.SetFilter("Sub Subjects", '<>%1', '');
            lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects.SetRange(Modified, false);
            lAspects.SetRange("Moment Code", pAspects."Moment Code");
            lAspects.SetRange(Code, pAspects.Code);
            if lAspects.Find('-') then begin
                repeat
                    lAspects.Description := pAspects.Description;
                    lAspects."% Evaluation" := pAspects."% Evaluation";
                    lAspects."Assessment Code" := pAspects."Assessment Code";
                    lAspects."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects."Not to WEB" := pAspects."Not to WEB";
                    lAspects.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects, lAspects, false);

                until lAspects.Next = 0;
            end;
        end;
    end;


    procedure ModifyClassAspects(pAspects: Record Aspects; pClass: Code[20]; pSubject: Code[20]; pSubSubject: Code[20]; IsModify: Boolean)
    var
        lAspects: Record Aspects;
        lAspects2: Record Aspects;
        lRegistrationSubjects: Record "Registration Subjects";
    begin
        //Direct
        if (pSubSubject <> '') and not IsModify then begin
            //Modify Students Aspect
            lRegistrationSubjects.Reset;
            lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
            lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
            lRegistrationSubjects.SetRange(Class, pClass);
            lRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
            lRegistrationSubjects.SetRange("Subjects Code", pSubject);
            if lRegistrationSubjects.FindSet then begin
                repeat
                    ModifyStudentAspects(pAspects, lRegistrationSubjects."Student Code No.", pSubject, pSubSubject, true);
                until lRegistrationSubjects.Next = 0;
            end;
        end;

        //Direct
        if (pSubSubject = '') and not IsModify then begin
            lRegistrationSubjects.Reset;
            lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
            lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
            lRegistrationSubjects.SetRange(Class, pClass);
            lRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
            lRegistrationSubjects.SetRange("Subjects Code", pSubject);
            if lRegistrationSubjects.FindSet then begin
                repeat
                    ModifyStudentAspects(pAspects, lRegistrationSubjects."Student Code No.", pSubject, '', true);
                until lRegistrationSubjects.Next = 0;
            end;

            lAspects2.Reset;
            lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects2.SetRange(Type, lAspects.Type::Class);
            lAspects2.SetRange("Type No.", pClass);
            lAspects2.SetRange("School Year", pAspects."School Year");
            lAspects2.SetFilter(Subjects, pSubject);
            lAspects2.SetFilter("Sub Subjects", '<>%1', '');
            lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects2.SetRange(Modified, false);
            lAspects2.SetRange("Moment Code", pAspects."Moment Code");
            lAspects2.SetRange(Code, pAspects.Code);
            if lAspects2.Find('-') then begin
                repeat
                    lAspects2.Description := pAspects.Description;
                    lAspects2."% Evaluation" := pAspects."% Evaluation";
                    lAspects2."Assessment Code" := pAspects."Assessment Code";
                    lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects2."Not to WEB" := pAspects."Not to WEB";
                    lAspects2.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                    //Modify sub subjects - Students - Aspect
                    lRegistrationSubjects.Reset;
                    lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
                    lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                    lRegistrationSubjects.SetRange(Class, pClass);
                    lRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                    lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
                    lRegistrationSubjects.SetRange("Subjects Code", pSubject);
                    if lRegistrationSubjects.FindSet then begin
                        repeat
                            ModifyStudentAspects(lAspects2, lRegistrationSubjects."Student Code No.", pSubject, lAspects2."Sub Subjects", true);
                        until lRegistrationSubjects.Next = 0;
                    end;
                until lAspects2.Next = 0;
            end;
        end;

        //indirect
        if (pSubSubject = '') and IsModify then begin
            lAspects2.Reset;
            lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects2.SetRange(Type, lAspects.Type::Class);
            lAspects2.SetRange("Type No.", pClass);
            lAspects2.SetRange("School Year", pAspects."School Year");
            lAspects2.SetRange(Subjects, pSubject);
            lAspects2.SetRange("Sub Subjects", '');
            lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects2.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects2.SetRange("Moment Code", pAspects."Moment Code");
            lAspects2.SetRange(Code, pAspects.Code);
            if lAspects2.Find('-') then begin
                repeat
                    lAspects2.Description := pAspects.Description;
                    lAspects2."% Evaluation" := pAspects."% Evaluation";
                    lAspects2."Assessment Code" := pAspects."Assessment Code";
                    lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects2."Not to WEB" := pAspects."Not to WEB";
                    lAspects2.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                    lRegistrationSubjects.Reset;
                    lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
                    lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                    lRegistrationSubjects.SetRange(Class, pClass);
                    lRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                    lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
                    lRegistrationSubjects.SetRange("Subjects Code", pSubject);
                    if lRegistrationSubjects.FindSet then begin
                        repeat
                            ModifyStudentAspects(lAspects2, lRegistrationSubjects."Student Code No.", pSubject, '', true)
                        until lRegistrationSubjects.Next = 0;
                    end;
                until lAspects2.Next = 0;
            end else begin
                //Bloqueado a 6-03 as 12:25 para corrigir as linhas de aluno que era alteradas e que nao deviam.

                lAspects2.Reset;
                lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                 Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                lAspects2.SetRange(Type, lAspects.Type::Class);
                lAspects2.SetRange("Type No.", pClass);
                lAspects2.SetRange("School Year", pAspects."School Year");
                lAspects2.SetRange(Subjects, pSubject);
                lAspects2.SetRange("Sub Subjects", '');
                lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                if pAspects.Type <> pAspects.Type::Overall then
                    lAspects2.SetRange("Moment Code", pAspects."Moment Code");
                lAspects2.SetRange(Code, pAspects.Code);
                if not lAspects2.Find('-') then begin

                    lRegistrationSubjects.Reset;
                    lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
                    lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                    lRegistrationSubjects.SetRange(Class, pClass);
                    lRegistrationSubjects.SetRange("Responsibility Center", pAspects."Responsibility Center");
                    lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
                    lRegistrationSubjects.SetRange("Subjects Code", pSubject);
                    if lRegistrationSubjects.FindSet then begin
                        repeat
                            ModifyStudentAspects(pAspects, lRegistrationSubjects."Student Code No.", pSubject, '', true)
                        until lRegistrationSubjects.Next = 0;
                    end;
                end;
            end;


            lAspects.Reset;
            lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects.SetRange(Type, lAspects.Type::Class);
            lAspects.SetRange("Type No.", pClass);
            lAspects.SetRange("School Year", pAspects."School Year");
            lAspects.SetRange(Subjects, pSubject);
            lAspects.SetFilter("Sub Subjects", '<>%1', '');
            lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects.SetRange("Moment Code", pAspects."Moment Code");
            lAspects.SetRange(Code, pAspects.Code);
            if lAspects.Find('-') then begin
                repeat
                    lAspects2.Reset;
                    lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                     Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                    if lRegistrationSubjects.Type = lRegistrationSubjects.Type::Simple then
                        lAspects2.SetRange(Type, lAspects.Type::"Study Plan")
                    else
                        lAspects2.SetRange(Type, lAspects.Type::Course);
                    lAspects2.SetRange("Type No.", lRegistrationSubjects."Study Plan Code");
                    lAspects2.SetRange("School Year", pAspects."School Year");
                    lAspects2.SetRange(Subjects, pSubject);
                    lAspects2.SetFilter("Sub Subjects", lAspects."Sub Subjects");
                    lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                    lAspects2.SetRange(Modified, false);
                    if pAspects.Type <> pAspects.Type::Overall then
                        lAspects2.SetRange("Moment Code", pAspects."Moment Code");
                    lAspects2.SetRange(Code, pAspects.Code);
                    if not lAspects2.Find('-') then begin
                        lAspects.Description := pAspects.Description;
                        lAspects."% Evaluation" := pAspects."% Evaluation";
                        lAspects."Assessment Code" := pAspects."Assessment Code";
                        lAspects."Evaluation Type" := pAspects."Evaluation Type";
                        //12-03
                        if pAspects.Type = pAspects.Type::Overall then
                            lAspects."Not to WEB" := pAspects."Not to WEB";
                        lAspects.Modify;
                    end;
                until lAspects.Next = 0;
            end;
        end;

        //indirect
        if (pSubSubject <> '') and IsModify then begin
            lAspects2.Reset;
            lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            lAspects2.SetRange(Type, lAspects.Type::Class);
            lAspects2.SetRange("Type No.", pClass);
            lAspects2.SetRange("School Year", pAspects."School Year");
            lAspects2.SetRange(Subjects, pSubject);
            lAspects2.SetRange("Sub Subjects", pSubSubject);
            lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects2.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects2.SetRange("Moment Code", pAspects."Moment Code");
            lAspects2.SetRange(Code, pAspects.Code);
            if lAspects2.Find('-') then begin
                repeat
                    lAspects2.Description := pAspects.Description;
                    lAspects2."% Evaluation" := pAspects."% Evaluation";
                    lAspects2."Assessment Code" := pAspects."Assessment Code";
                    lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects2."Not to WEB" := pAspects."Not to WEB";
                    lAspects2.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                    //Modify sub subjects - Students - Aspect
                    lRegistrationSubjects.Reset;
                    lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
                    lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                    lRegistrationSubjects.SetRange(Class, pClass);
                    lRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
                    lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
                    lRegistrationSubjects.SetRange("Subjects Code", pSubject);
                    if lRegistrationSubjects.FindSet then begin
                        repeat
                            ModifyStudentAspects(lAspects2, lRegistrationSubjects."Student Code No.", pSubject, lAspects2."Sub Subjects", true);
                        until lRegistrationSubjects.Next = 0;
                    end;
                until lAspects2.Next = 0;
            end else begin
                lRegistrationSubjects.Reset;
                lRegistrationSubjects.SetCurrentKey("School Year", "Schooling Year", Class, Status, "Responsibility Center");
                lRegistrationSubjects.SetRange("School Year", pAspects."School Year");
                lRegistrationSubjects.SetRange(Class, pClass);
                lRegistrationSubjects.SetRange("Responsibility Center", "Responsibility Center");
                lRegistrationSubjects.SetRange(Status, lRegistrationSubjects.Status::Subscribed);
                lRegistrationSubjects.SetRange("Subjects Code", pSubject);
                if lRegistrationSubjects.FindSet then begin
                    repeat
                        ModifyStudentAspects(pAspects, lRegistrationSubjects."Student Code No.", pSubject, pSubSubject, true);
                    until lRegistrationSubjects.Next = 0;
                end;
            end;
        end;
    end;


    procedure ModifyCourseAspects(pAspects: Record Aspects; pStudyPlanCode: Code[20]; pEducationType: Integer; pSubject: Code[20]; pSubSubject: Code[20]; IsModify: Boolean)
    var
        lAspects: Record Aspects;
        lAspects2: Record Aspects;
        lClass: Record Class;
    begin
        //Direct
        if (pSubSubject <> '') and not IsModify then begin
            lClass.Reset;
            lClass.SetRange("Study Plan Code", pStudyPlanCode);
            lClass.SetRange(Type, pEducationType);
            lClass.SetRange("School Year", pAspects."School Year");
            if lClass.FindSet then begin
                repeat
                    ModifyClassAspects(pAspects, lClass.Class, pSubject, pSubSubject, true);
                until lClass.Next = 0;
            end;
        end;

        if (pSubSubject = '') and not IsModify then begin

            lAspects2.Reset;
            lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            if pEducationType = 0 then
                lAspects2.SetRange(Type, lAspects2.Type::"Study Plan")
            else
                lAspects2.SetRange(Type, lAspects2.Type::Course);
            lAspects2.SetRange("Type No.", pStudyPlanCode);
            lAspects2.SetRange("School Year", pAspects."School Year");
            lAspects2.SetFilter(Subjects, pSubject);
            lAspects2.SetFilter("Sub Subjects", '<>%1', '');
            lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects2.SetRange(Modified, false);
            lAspects2.SetRange("Moment Code", pAspects."Moment Code");
            lAspects2.SetRange(Code, pAspects.Code);
            if lAspects2.Find('-') then begin
                repeat
                    lAspects2.Description := pAspects.Description;
                    lAspects2."% Evaluation" := pAspects."% Evaluation";
                    lAspects2."Assessment Code" := pAspects."Assessment Code";
                    lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type <> pAspects.Type::Overall then
                        lAspects2."Not to WEB" := pAspects."Not to WEB";
                    lAspects2.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                    lClass.Reset;
                    lClass.SetRange("Study Plan Code", pStudyPlanCode);
                    lClass.SetRange(Type, pEducationType);
                    lClass.SetRange("School Year", pAspects."School Year");
                    if lClass.FindSet then begin
                        repeat
                            ModifyClassAspects(lAspects2, lClass.Class, pSubject, lAspects2."Sub Subjects", true);
                        until lClass.Next = 0;
                    end;
                until lAspects2.Next = 0;
            end;

            lClass.Reset;
            lClass.SetRange("Study Plan Code", pStudyPlanCode);
            lClass.SetRange(Type, pEducationType);
            lClass.SetRange("School Year", pAspects."School Year");
            if lClass.FindSet then begin
                repeat
                    ModifyClassAspects(pAspects, lClass.Class, pSubject, '', true);
                until lClass.Next = 0;
            end;
        end;

        //Indirect
        if (pSubSubject <> '') and IsModify then begin
            lAspects.Reset;
            lAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            if pEducationType = 0 then
                lAspects.SetRange(Type, lAspects2.Type::"Study Plan")
            else
                lAspects.SetRange(Type, lAspects2.Type::Course);
            lAspects.SetRange("Type No.", pStudyPlanCode);
            lAspects.SetRange("School Year", pAspects."School Year");
            lAspects.SetRange(Subjects, pSubject);
            lAspects.SetRange("Sub Subjects", '');
            lAspects.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects.SetRange("Moment Code", pAspects."Moment Code");
            lAspects.SetRange(Code, pAspects.Code);
            if lAspects.Find('-') then begin
                repeat
                    lAspects2.Reset;
                    lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                     Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                    if pEducationType = 0 then
                        lAspects2.SetRange(Type, lAspects2.Type::"Study Plan")
                    else
                        lAspects2.SetRange(Type, lAspects2.Type::Course);
                    lAspects2.SetRange("Type No.", pStudyPlanCode);
                    lAspects2.SetRange("School Year", pAspects."School Year");
                    lAspects2.SetRange(Subjects, pSubject);
                    lAspects2.SetRange("Sub Subjects", pSubSubject);
                    lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
                    lAspects2.SetRange(Modified, false);
                    lAspects2.SetRange("Moment Code", lAspects."Moment Code");
                    lAspects2.SetRange(Code, pAspects.Code);
                    if lAspects2.Find('-') then begin
                        repeat
                            lAspects2.Description := pAspects.Description;
                            lAspects2."% Evaluation" := pAspects."% Evaluation";
                            lAspects2."Assessment Code" := pAspects."Assessment Code";
                            lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                            //12-03
                            if pAspects.Type = pAspects.Type::Overall then
                                lAspects2."Not to WEB" := pAspects."Not to WEB";
                            lAspects2.Modify;

                            cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                            lClass.Reset;
                            lClass.SetRange("Study Plan Code", pStudyPlanCode);
                            lClass.SetRange(Type, pEducationType);
                            lClass.SetRange("School Year", pAspects."School Year");
                            if lClass.FindSet then begin
                                repeat
                                    ModifyClassAspects(lAspects2, lClass.Class, pSubject, pSubject, true);
                                until lClass.Next = 0;
                            end;
                        until lAspects2.Next = 0;
                    end;

                until lAspects.Next = 0;
            end else begin
                lClass.Reset;
                lClass.SetRange("Study Plan Code", pStudyPlanCode);
                lClass.SetRange(Type, pEducationType);
                lClass.SetRange("School Year", pAspects."School Year");
                if lClass.FindSet then begin
                    repeat
                        ModifyClassAspects(pAspects, lClass.Class, pSubject, pSubSubject, true);
                    until lClass.Next = 0;
                end;
            end;
        end;

        if (pSubSubject = '') and IsModify then begin
            lAspects2.Reset;
            lAspects2.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
             Code, Modified, "Moment Code", Subjects, "Sub Subjects");
            if pEducationType = 0 then
                lAspects2.SetRange(Type, lAspects2.Type::"Study Plan")
            else
                lAspects2.SetRange(Type, lAspects2.Type::Course);
            lAspects2.SetRange("Type No.", pStudyPlanCode);
            lAspects2.SetRange("School Year", pAspects."School Year");
            lAspects2.SetRange(Subjects, pSubject);
            lAspects2.SetRange("Sub Subjects", '');
            lAspects2.SetRange("Responsibility Center", pAspects."Responsibility Center");
            lAspects2.SetRange(Modified, false);
            if pAspects.Type <> pAspects.Type::Overall then
                lAspects2.SetRange("Moment Code", pAspects."Moment Code");
            lAspects2.SetRange(Code, pAspects.Code);
            if lAspects2.Find('-') then begin
                repeat
                    lAspects2.Description := pAspects.Description;
                    lAspects2."% Evaluation" := pAspects."% Evaluation";
                    lAspects2."Assessment Code" := pAspects."Assessment Code";
                    lAspects2."Evaluation Type" := pAspects."Evaluation Type";
                    //12-03
                    if pAspects.Type = pAspects.Type::Overall then
                        lAspects2."Not to WEB" := pAspects."Not to WEB";
                    lAspects2.Modify;

                    cInsertNAVGeneralTable.ModDelAspects(lAspects2, lAspects2, false);

                    lClass.Reset;
                    lClass.SetRange("Study Plan Code", pStudyPlanCode);
                    lClass.SetRange(Type, pEducationType);
                    lClass.SetRange("School Year", pAspects."School Year");
                    if lClass.FindSet then begin
                        repeat
                            ModifyClassAspects(lAspects2, lClass.Class, pSubject, '', true);
                        until lClass.Next = 0;
                    end;

                until lAspects2.Next = 0;
            end else begin
                lClass.Reset;
                lClass.SetRange("Study Plan Code", pStudyPlanCode);
                lClass.SetRange(Type, pEducationType);
                lClass.SetRange("School Year", pAspects."School Year");
                if lClass.FindSet then begin
                    repeat
                        ModifyClassAspects(pAspects, lClass.Class, pSubject, '', true);
                    until lClass.Next = 0;
                end;
            end;
        end;
    end;


    procedure ModifyOverallAspects(pAspects: Record Aspects)
    var
        lStudyPlanLines: Record "Study Plan Lines";
        lCourseLines: Record "Course Lines";
        lStudyPlanSubSubjectsLines: Record "Study Plan Sub-Subjects Lines";
        l_Aspects: Record Aspects;
    begin
        if (xRec.Code <> '') and (xRec.Code <> Code) then begin
            l_Aspects.Reset;
            l_Aspects.SetRange("School Year", "School Year");
            l_Aspects.SetFilter(Type, '<>%1', l_Aspects.Type::Overall);
            l_Aspects.SetRange(Code, xRec.Code);
            if l_Aspects.FindFirst then
                Error(Text0005);
        end;

        lStudyPlanLines.Reset;
        lStudyPlanLines.SetRange("School Year", pAspects."School Year");
        if lStudyPlanLines.Find('-') then begin
            repeat
                ModifyCourseAspects(pAspects, lStudyPlanLines.Code, 0, lStudyPlanLines."Subject Code", '', true);

                lStudyPlanLines.CalcFields("Sub-Subject");
                if lStudyPlanLines."Sub-Subject" then begin
                    lStudyPlanSubSubjectsLines.Reset;
                    lStudyPlanSubSubjectsLines.SetRange(Type, lStudyPlanSubSubjectsLines.Type::"Study Plan");
                    lStudyPlanSubSubjectsLines.SetRange(Code, lStudyPlanLines.Code);
                    lStudyPlanSubSubjectsLines.SetRange("School Year", pAspects."School Year");
                    lStudyPlanSubSubjectsLines.SetRange("Subject Code", lStudyPlanLines."Subject Code");
                    if lStudyPlanSubSubjectsLines.Find('-') then begin
                        repeat
                            ModifyCourseAspects(pAspects, lStudyPlanLines.Code,
                              0, lStudyPlanLines."Subject Code", lStudyPlanSubSubjectsLines."Sub-Subject Code", true);
                        until lStudyPlanSubSubjectsLines.Next = 0;
                    end;
                end;
            until lStudyPlanLines.Next = 0;
        end;

        lCourseLines.Reset;
        //lCourseLines.SETRANGE("School Year Begin",'>=%1',pAspects."School Year");
        if lCourseLines.Find('-') then begin
            repeat
                ModifyCourseAspects(pAspects, lCourseLines.Code, 1, lCourseLines."Subject Code", '', true);

                lCourseLines.CalcFields("Sub-Subject");
                if lCourseLines."Sub-Subject" then begin
                    lStudyPlanSubSubjectsLines.Reset;
                    lStudyPlanSubSubjectsLines.SetRange(Type, lStudyPlanSubSubjectsLines.Type::Course);
                    lStudyPlanSubSubjectsLines.SetRange(Code, lCourseLines.Code);
                    lStudyPlanSubSubjectsLines.SetRange("Subject Code", lCourseLines."Subject Code");
                    if lStudyPlanSubSubjectsLines.Find('-') then begin
                        repeat
                            ModifyCourseAspects(pAspects, lCourseLines.Code,
                              1, lCourseLines."Subject Code", lStudyPlanSubSubjectsLines."Sub-Subject Code", true);
                        until lStudyPlanSubSubjectsLines.Next = 0;
                    end;
                end;

            until lCourseLines.Next = 0;
        end;
    end;


    procedure DeleteAspects()
    var
        Text000001: Label 'Update table #1##################';
        Text000002: Label 'Web Aplication';
        Text000003: Label 'Aspects';
    begin
        //
        case Type of
            Type::Overall:
                DeleteOverAll;
            Type::Course:
                begin
                    GetAspects(Type, "Type No.", "School Year", "Moment Code",
                      Subjects, "Sub Subjects", Code, "Responsibility Center", rAspects, true);

                    ModifyCourseAspects(rAspects, "Type No.", 1, Subjects, "Sub Subjects", false);
                end;
            Type::"Study Plan":
                begin
                    GetAspects(Type, "Type No.", "School Year", "Moment Code",
                      Subjects, "Sub Subjects", Code, "Responsibility Center", rAspects, true);

                    ModifyCourseAspects(rAspects, "Type No.", 0, Subjects, "Sub Subjects", false);
                end;
            Type::Class:
                begin
                    GetAspects(Type, "Type No.", "School Year", "Moment Code",
                      Subjects, "Sub Subjects", Code, "Responsibility Center", rAspects, true);

                    ModifyClassAspects(rAspects, "Type No.", Subjects, "Sub Subjects", false);
                end;
            Type::Student:
                begin
                    GetAspects(Type, "Type No.", "School Year", "Moment Code",
                      Subjects, "Sub Subjects", Code, "Responsibility Center", rAspects, true);

                    ModifyStudentAspects(rAspects, "Type No.", Subjects, "Sub Subjects", false);
                end;
        end;
    end;


    procedure GetAspects(pType: Integer; pTypeNo: Code[20]; pSchoolYear: Code[10]; pMomentCode: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pAspectCode: Code[20]; pResponsibilityCenter: Code[20]; var pAspects: Record Aspects; pDelete: Boolean) NextLevel: Boolean
    var
        RegistrationClass: Record "Registration Class";
    begin
        //pType options
        //1 = Overall
        //2 = Course
        //3 = Class
        //4 = Study Plan
        //5 = Student

        //Filter the aspects for the level of ptype
        case pType of
            5:
                begin
                    //find the aspect of the Student
                    pAspects.Reset;
                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                    pAspects.SetRange(Type, 5);
                    pAspects.SetRange("School Year", pSchoolYear);
                    pAspects.SetRange("Type No.", pTypeNo);
                    pAspects.SetRange(Subjects, pSubjects);
                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                    pAspects.SetRange("Moment Code", pMomentCode);
                    pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                    if pAspectCode <> '' then
                        pAspects.SetRange(Code, pAspectCode);
                    if not pAspects.Find('-') or pDelete then begin

                        //If Subsubject try find aspects of the Subject
                        if pSubSubjects <> '' then begin
                            pAspects.Reset;
                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            pAspects.SetRange(Type, 5);
                            pAspects.SetRange("School Year", pSchoolYear);
                            pAspects.SetRange("Type No.", pTypeNo);
                            pAspects.SetRange(Subjects, pSubjects);
                            pAspects.SetRange("Sub Subjects", '');
                            pAspects.SetRange("Moment Code", pMomentCode);
                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                            if pAspectCode <> '' then
                                pAspects.SetRange(Code, pAspectCode);
                            if not pAspects.Find('-') or pDelete then begin

                                //find the subject aspect of the class
                                RegistrationClass.Reset;
                                RegistrationClass.SetRange("School Year", pSchoolYear);
                                RegistrationClass.SetRange("Student Code No.", pTypeNo);
                                //RegistrationClass.SETRANGE(Class,pGeneralTableAspects.Class);
                                RegistrationClass.SetRange("Responsibility Center", pResponsibilityCenter);
                                if RegistrationClass.FindSet then begin
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    pAspects.SetRange(Type, 3);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Type No.", RegistrationClass.Class);
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    if not pAspects.Find('-') then begin
                                        //
                                        //If Subsubject try find aspects of Subject
                                        if pSubSubjects <> '' then begin
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            pAspects.SetRange(Type, 3);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Type No.", RegistrationClass.Class);
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            if not pAspects.Find('-') then begin

                                                //find the aspect of the Course/Study plan
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                    pAspects.SetRange(Type, 4)
                                                else
                                                    pAspects.SetRange(Type, 2);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                                pAspects.SetRange(Subjects, pSubjects);
                                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                                pAspects.SetRange("Moment Code", pMomentCode);
                                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                if not pAspects.Find('-') then begin

                                                    //If Subsubject try find aspects of Subject
                                                    if pSubSubjects <> '' then begin
                                                        pAspects.Reset;
                                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                        if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                            pAspects.SetRange(Type, 4)
                                                        else
                                                            pAspects.SetRange(Type, 2);
                                                        pAspects.SetRange("School Year", pSchoolYear);
                                                        pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                                        pAspects.SetRange(Subjects, pSubjects);
                                                        pAspects.SetRange("Sub Subjects", '');
                                                        pAspects.SetRange("Moment Code", pMomentCode);
                                                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                        if pAspectCode <> '' then
                                                            pAspects.SetRange(Code, pAspectCode);
                                                        if not pAspects.Find('-') then begin

                                                            //Find Global aspect
                                                            pAspects.Reset;
                                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                            pAspects.SetRange(Type, 1);
                                                            pAspects.SetRange("School Year", pSchoolYear);
                                                            pAspects.SetRange("Type No.", '');
                                                            pAspects.SetRange(Subjects, '');
                                                            pAspects.SetRange("Sub Subjects", '');
                                                            pAspects.SetRange("Moment Code", '');
                                                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                            if pAspectCode <> '' then
                                                                pAspects.SetRange(Code, pAspectCode);
                                                            if not pAspects.Find('-') then begin
                                                            end;
                                                        end;
                                                    end else begin
                                                        //Find Global aspect
                                                        pAspects.Reset;
                                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                        pAspects.SetRange(Type, 1);
                                                        pAspects.SetRange("School Year", pSchoolYear);
                                                        pAspects.SetRange("Type No.", '');
                                                        pAspects.SetRange(Subjects, '');
                                                        pAspects.SetRange("Sub Subjects", '');
                                                        pAspects.SetRange("Moment Code", '');
                                                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                        if pAspectCode <> '' then
                                                            pAspects.SetRange(Code, pAspectCode);
                                                        if not pAspects.Find('-') then begin
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end else begin
                                            //find the aspect of the Course/Study plan
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                pAspects.SetRange(Type, 4)
                                            else
                                                pAspects.SetRange(Type, 2);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", pSubSubjects);
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            if not pAspects.Find('-') then begin
                                                //Find Global aspect
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                pAspects.SetRange(Type, 1);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Type No.", '');
                                                pAspects.SetRange(Subjects, '');
                                                pAspects.SetRange("Sub Subjects", '');
                                                pAspects.SetRange("Moment Code", '');
                                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                if not pAspects.Find('-') then begin
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end else begin
                            //find the subject aspect of the class
                            RegistrationClass.Reset;
                            RegistrationClass.SetRange("School Year", pSchoolYear);
                            RegistrationClass.SetRange("Student Code No.", pTypeNo);
                            //RegistrationClass.SETRANGE(Class,pGeneralTableAspects.Class);
                            RegistrationClass.SetRange("Responsibility Center", pResponsibilityCenter);
                            if RegistrationClass.FindSet then begin
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                pAspects.SetRange(Type, 3);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Type No.", RegistrationClass.Class);
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                pAspects.SetRange("Moment Code", pMomentCode);
                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                if not pAspects.Find('-') then begin
                                    //find the aspect of the Course/Study plan
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                        pAspects.SetRange(Type, 4)
                                    else
                                        pAspects.SetRange(Type, 2);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    if not pAspects.Find('-') then begin
                                        //Find Global aspect
                                        pAspects.Reset;
                                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                        pAspects.SetRange(Type, 1);
                                        pAspects.SetRange("School Year", pSchoolYear);
                                        pAspects.SetRange("Type No.", '');
                                        pAspects.SetRange(Subjects, '');
                                        pAspects.SetRange("Sub Subjects", '');
                                        pAspects.SetRange("Moment Code", '');
                                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                        if pAspectCode <> '' then
                                            pAspects.SetRange(Code, pAspectCode);
                                        if not pAspects.Find('-') then begin
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            3:
                begin
                    //find the subject aspect of the class
                    RegistrationClass.Reset;
                    RegistrationClass.SetRange("School Year", pSchoolYear);
                    //RegistrationClass.SETRANGE("Student Code No.",pGeneralTableAspects.Student);
                    RegistrationClass.SetRange(Class, pTypeNo);
                    RegistrationClass.SetRange("Responsibility Center", pResponsibilityCenter);
                    if RegistrationClass.FindSet then begin
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        pAspects.SetRange(Type, 3);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Type No.", RegistrationClass.Class);
                        pAspects.SetRange(Subjects, pSubjects);
                        pAspects.SetRange("Sub Subjects", pSubSubjects);
                        pAspects.SetRange("Moment Code", pMomentCode);
                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        if not pAspects.Find('-') or pDelete then begin
                            //
                            //If Subsubject try find aspects of Subject
                            if pSubSubjects <> '' then begin
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                pAspects.SetRange(Type, 3);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Type No.", RegistrationClass.Class);
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", '');
                                pAspects.SetRange("Moment Code", pMomentCode);
                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                if not pAspects.Find('-') then begin

                                    //find the aspect of the Course/Study plan
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                        pAspects.SetRange(Type, 4)
                                    else
                                        pAspects.SetRange(Type, 2);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                    pAspects.SetRange(Subjects, pSubjects);
                                    pAspects.SetRange("Sub Subjects", pSubSubjects);
                                    pAspects.SetRange("Moment Code", pMomentCode);
                                    pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    if not pAspects.Find('-') then begin

                                        //If Subsubject try find aspects of Subject
                                        if pSubSubjects <> '' then begin
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                                pAspects.SetRange(Type, 4)
                                            else
                                                pAspects.SetRange(Type, 2);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                            pAspects.SetRange(Subjects, pSubjects);
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", pMomentCode);
                                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            if not pAspects.Find('-') then begin

                                                //Find Global aspect
                                                pAspects.Reset;
                                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                                pAspects.SetRange(Type, 1);
                                                pAspects.SetRange("School Year", pSchoolYear);
                                                pAspects.SetRange("Type No.", '');
                                                pAspects.SetRange(Subjects, '');
                                                pAspects.SetRange("Sub Subjects", '');
                                                pAspects.SetRange("Moment Code", '');
                                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                                if pAspectCode <> '' then
                                                    pAspects.SetRange(Code, pAspectCode);
                                                if not pAspects.Find('-') then begin
                                                end;
                                            end;
                                        end else begin
                                            //Find Global aspect
                                            pAspects.Reset;
                                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                            pAspects.SetRange(Type, 1);
                                            pAspects.SetRange("School Year", pSchoolYear);
                                            pAspects.SetRange("Type No.", '');
                                            pAspects.SetRange(Subjects, '');
                                            pAspects.SetRange("Sub Subjects", '');
                                            pAspects.SetRange("Moment Code", '');
                                            if pAspectCode <> '' then
                                                pAspects.SetRange(Code, pAspectCode);
                                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                            if not pAspects.Find('-') then begin
                                            end;
                                        end;
                                    end;
                                end;
                            end else begin
                                //find the aspect of the Course/Study plan
                                pAspects.Reset;
                                pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                if RegistrationClass.Type = RegistrationClass.Type::Simple then
                                    pAspects.SetRange(Type, 4)
                                else
                                    pAspects.SetRange(Type, 2);
                                pAspects.SetRange("School Year", pSchoolYear);
                                pAspects.SetRange("Type No.", RegistrationClass."Study Plan Code");
                                pAspects.SetRange(Subjects, pSubjects);
                                pAspects.SetRange("Sub Subjects", pSubSubjects);
                                pAspects.SetRange("Moment Code", pMomentCode);
                                pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                if pAspectCode <> '' then
                                    pAspects.SetRange(Code, pAspectCode);
                                if not pAspects.Find('-') then begin
                                    //Find Global aspect
                                    pAspects.Reset;
                                    pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                                    Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                                    pAspects.SetRange(Type, 1);
                                    pAspects.SetRange("School Year", pSchoolYear);
                                    pAspects.SetRange("Type No.", '');
                                    pAspects.SetRange(Subjects, '');
                                    pAspects.SetRange("Sub Subjects", '');
                                    pAspects.SetRange("Moment Code", '');
                                    pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                                    if pAspectCode <> '' then
                                        pAspects.SetRange(Code, pAspectCode);
                                    if not pAspects.Find('-') then begin
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            4, 2:
                begin
                    //If Subsubject try find aspects of Subject

                    if pSubSubjects <> '' then begin
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        if RegistrationClass.Type = RegistrationClass.Type::Simple then
                            pAspects.SetRange(Type, 4)
                        else
                            pAspects.SetRange(Type, 2);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Type No.", pTypeNo);
                        pAspects.SetRange(Subjects, pSubjects);
                        pAspects.SetRange("Sub Subjects", '');
                        pAspects.SetRange("Moment Code", pMomentCode);
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                        if not pAspects.Find('-') or pDelete then begin

                            //Find Global aspect
                            pAspects.Reset;
                            pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                            Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                            pAspects.SetRange(Type, 1);
                            pAspects.SetRange("School Year", pSchoolYear);
                            pAspects.SetRange("Type No.", '');
                            pAspects.SetRange(Subjects, '');
                            pAspects.SetRange("Sub Subjects", '');
                            pAspects.SetRange("Moment Code", '');
                            pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                            if pAspectCode <> '' then
                                pAspects.SetRange(Code, pAspectCode);
                            if not pAspects.Find('-') then begin
                            end;
                        end;
                    end else begin
                        //Find Global aspect
                        pAspects.Reset;
                        pAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                        Code, Modified, "Moment Code", Subjects, "Sub Subjects");
                        pAspects.SetRange(Type, 1);
                        pAspects.SetRange("School Year", pSchoolYear);
                        pAspects.SetRange("Type No.", '');
                        pAspects.SetRange(Subjects, '');
                        pAspects.SetRange("Sub Subjects", '');
                        pAspects.SetRange("Moment Code", '');
                        pAspects.SetRange("Responsibility Center", pResponsibilityCenter);
                        if pAspectCode <> '' then
                            pAspects.SetRange(Code, pAspectCode);
                        if not pAspects.Find('-') then begin
                        end;
                    end;
                end;
        end;
    end;


    procedure DeleteOverAll()
    var
        lAspects: Record Aspects;
    begin
        lAspects.Reset;
        lAspects.SetFilter(Type, '<>%1', Type);
        lAspects.SetRange("School Year", "School Year");
        lAspects.SetRange("Responsibility Center", "Responsibility Center");
        lAspects.SetRange(Code, Code);
        if lAspects.Find('-') then
            lAspects.DeleteAll(true);
    end;


    procedure InsOverallAsp()
    var
        lClass: Record Class;
        lRegistrationClass: Record "Registration Class";
    begin


        //Change All Lines For this Course/Study Plan
        rAspects.Reset;
        rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
         Code, Modified, "Moment Code", Subjects, "Sub Subjects");
        rAspects.SetRange(Type, Type);
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetFilter("Type No.", '<>%1', "Type No.");
        rAspects.SetRange("Schooling Year", "Schooling Year");
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if rAspects.Find('-') then
            rAspects.ModifyAll("Not to WEB", "Not to WEB", true);

        //Change All Lines For the classes and Students
        lClass.Reset;
        lClass.SetRange("School Year", "School Year");
        lClass.SetRange("Schooling Year", "Schooling Year");
        lClass.SetRange("Study Plan Code", "Type No.");
        if (Type = Type::Course) then
            lClass.SetRange(Type, lClass.Type::Multi)
        else
            lClass.SetRange(Type, lClass.Type::Simple);
        if lClass.FindSet then begin
            repeat
                rAspects.Reset;
                rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                 Code, Modified, "Moment Code", Subjects, "Sub Subjects");

                rAspects.SetRange(Type, Type::Class);
                rAspects.SetRange("School Year", "School Year");
                rAspects.SetFilter("Type No.", lClass.Class);
                rAspects.SetRange("Schooling Year", "Schooling Year");
                rAspects.SetRange("Responsibility Center", "Responsibility Center");
                if rAspects.Find('-') then
                    rAspects.ModifyAll("Not to WEB", "Not to WEB", true);

                lRegistrationClass.Reset;
                lRegistrationClass.SetCurrentKey("School Year", "Study Plan Code", Class, Status);
                lRegistrationClass.SetRange(Class, lClass.Class);
                lRegistrationClass.SetRange("School Year", "School Year");
                lRegistrationClass.SetRange("Schooling Year", "Schooling Year");
                lRegistrationClass.SetRange("Study Plan Code", "Type No.");
                lRegistrationClass.SetRange(Type, lClass.Type);
                lRegistrationClass.SetRange(Status, lRegistrationClass.Status::Subscribed);
                if lRegistrationClass.FindSet then
                    repeat
                        rAspects.Reset;
                        rAspects.SetCurrentKey(Type, "Type No.", "School Year", "Schooling Year", "Responsibility Center",
                         Code, Modified, "Moment Code", Subjects, "Sub Subjects");

                        rAspects.SetRange(Type, Type::Student);
                        rAspects.SetRange("School Year", "School Year");
                        rAspects.SetFilter("Type No.", lRegistrationClass."Student Code No.");
                        rAspects.SetRange("Schooling Year", "Schooling Year");
                        rAspects.SetRange("Responsibility Center", "Responsibility Center");
                        if rAspects.Find('-') then
                            rAspects.ModifyAll("Not to WEB", "Not to WEB", true);

                    until lRegistrationClass.Next = 0;

            until lClass.Next = 0;
        end;
    end;


    procedure GetCourseNotWeb(pType: Integer; pSchoolYear: Code[9]; pSchoolingYear: Code[20]; pTypeNo: Code[20]; pRespCenter: Code[10]; pCode: Code[20]): Boolean
    var
        lAspects: Record Aspects;
    begin
        lAspects.Reset;
        lAspects.SetRange(Type, pType);
        lAspects.SetRange("School Year", pSchoolYear);
        lAspects.SetRange("Schooling Year", pSchoolingYear);
        lAspects.SetRange("Type No.", pTypeNo);
        lAspects.SetRange("Responsibility Center", pRespCenter);
        lAspects.SetRange(Code, pCode);
        if lAspects.FindSet then
            exit(lAspects."Not to WEB")
        else
            exit(true);
    end;


    procedure InsertStudyPlanAspects()
    var
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
    begin
        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetRange("School Year", "School Year");
        l_RegistrationSubjects.SetRange("Study Plan Code", "Type No.");
        l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
        if Type = Type::Course then
            l_RegistrationSubjects.SetRange(Type, l_RegistrationSubjects.Type::Multi)
        else
            l_RegistrationSubjects.SetRange(Type, l_RegistrationSubjects.Type::Simple);
        l_RegistrationSubjects.SetRange(Status, l_RegistrationSubjects.Status::Subscribed);
        if l_RegistrationSubjects.FindSet then
            repeat
                cInsertNAVGeneralTable.InsertAspectsStudent('', l_RegistrationSubjects."Subjects Code",
                  l_RegistrationSubjects."Student Code No.", Rec);
                l_RegistrationSubjects.CalcFields("Sub-subject");
                if l_RegistrationSubjects."Sub-subject" then begin
                    l_StudentSubSubjectsPlan.Reset;
                    l_StudentSubSubjectsPlan.SetRange("Student Code No.", l_RegistrationSubjects."Student Code No.");
                    l_StudentSubSubjectsPlan.SetRange("School Year", l_RegistrationSubjects."School Year");
                    l_StudentSubSubjectsPlan.SetRange("Subject Code", l_RegistrationSubjects."Subjects Code");
                    l_StudentSubSubjectsPlan.SetRange("Line No.", l_RegistrationSubjects."Original Line No.");
                    l_StudentSubSubjectsPlan.SetRange("Schooling Year", l_RegistrationSubjects."Schooling Year");
                    if l_StudentSubSubjectsPlan.FindSet then
                        repeat
                            cInsertNAVGeneralTable.InsertAspectsStudent(
                              l_StudentSubSubjectsPlan."Sub-Subject Code", l_RegistrationSubjects."Subjects Code",
                               l_RegistrationSubjects."Student Code No.", Rec);
                        until l_StudentSubSubjectsPlan.Next = 0;
                end;
            until l_RegistrationSubjects.Next = 0;
    end;
}

