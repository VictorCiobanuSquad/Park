table 52785 Test
{
    Caption = 'Test';
    DrillDownPageID = "Test Lines";
    LookupPageID = "Test List";

    fields
    {
        field(1; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(2; "Test No."; Code[20])
        {
            Caption = 'Test No.';

            trigger OnValidate()
            var
                rEduConfiguration: Record "Edu. Configuration";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "Line Type" = "Line Type"::Header then begin
                    if "Test No." <> xRec."Test No." then begin
                        rEduConfiguration.Get;
                        NoSeriesMgt.TestManual(rEduConfiguration."Test Nos.");
                        "No. Series" := '';
                    end;

                end;
            end;
        }
        field(3; "Candidate no."; Code[20])
        {
            Caption = 'Candidate No.';
            TableRelation = Candidate."No." WHERE("Student No." = FILTER(''));

            trigger OnLookup()
            begin
                rTest.Reset;
                rTest.SetRange(rTest."Test Type", rTest."Test Type"::Candidate);
                rTest.SetRange(rTest."Test No.", "Test No.");
                rTest.SetRange(rTest."Line Type", rTest."Line Type"::Header);
                if rTest.FindFirst then begin

                    rCandidate.Reset;
                    rCandidate.SetRange(rCandidate."Student No.", '');
                    if rCandidate.Find('-') then begin
                        repeat
                            rCandidateEntry.Reset;
                            rCandidateEntry.SetRange(rCandidateEntry."Candidate No.", rCandidate."No.");
                            rCandidateEntry.SetRange(rCandidateEntry."School Year", rTest."School Year");
                            rCandidateEntry.SetRange(rCandidateEntry."Schooling Year", rTest."Schooling Year");
                            rCandidateEntry.SetRange(rCandidateEntry.Excluding, false);
                            if rCandidateEntry.FindFirst then
                                rCandidate.Mark(true);
                        until rCandidate.Next = 0;
                    end;

                    rCandidate.MarkedOnly(true);
                    if PAGE.RunModal(PAGE::"Candidate List", rCandidate) = ACTION::LookupOK then begin
                        Validate("Candidate no.", rCandidate."No.");
                    end;

                end;
            end;

            trigger OnValidate()
            var
                rCandidate: Record Candidate;
            begin
                rTest.Reset;
                rTest.SetRange("Test Type", "Test Type");
                rTest.SetRange("Test No.", "Test No.");
                rTest.SetRange("Candidate no.", "Candidate no.");
                if rTest.Find('-') then
                    Error(Text007, "Candidate no.");

                if "Candidate no." <> '' then begin
                    if rCandidate.Get("Candidate no.") then
                        "Candidate Name" := rCandidate."Full Name";
                end
                else
                    "Candidate Name" := '';


                ValidateSchoolYear(Rec);
            end;
        }
        field(4; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(5; "Type of Test"; Option)
        {
            Caption = 'Type of Test';
            OptionCaption = ' ,Interview,Group Interview,Specific test,Aptitude test,Other,Psychologist,Recover Test';
            OptionMembers = " ",Interview,"Group Interview","Specific test","Aptitude test",Other,Psychologist,"Recover Test";
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Hour; Time)
        {
            Caption = 'Hour';
        }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration';
        }
        field(9; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code" WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(10; "Teacher No."; Code[20])
        {
            Caption = 'Teacher No.';
            TableRelation = Teacher."No." WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(11; "School Year"; Code[9])
        {
            Caption = 'School Year';
            Editable = true;
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));
        }
        field(12; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            var
                rCompanyInformation: Record "Company Information";
                rStruEduCountry: Record "Structure Education Country";
            begin
                if rCompanyInformation.Get then;

                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.FindFirst then
                    Level := rStruEduCountry.Level;
            end;
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region".Code;
        }
        field(14; Level; Option)
        {
            Caption = 'Level';
            Editable = false;
            OptionCaption = 'Pre school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(15; "Candidate Name"; Text[191])
        {
            Caption = 'Candidate Name';
        }
        field(16; Points; Decimal)
        {
            Caption = 'Points';

            trigger OnValidate()
            var
                l_NProvas: Integer;
                l_TotProvas: Decimal;
            begin
                if Points <> 0 then
                    TestField(Absent, false);


                Clear(l_NProvas);
                Clear(l_TotProvas);
                rTest.Reset;
                rTest.SetRange("Line Type", "Line Type"::Line);
                rTest.SetRange(rTest."Candidate no.", "Candidate no.");
                rTest.SetRange(rTest."School Year", "School Year");
                rTest.SetRange(rTest."Schooling Year", "Schooling Year");
                rTest.SetFilter(rTest.Points, '<>%1', 0.0);
                rTest.SetFilter(rTest."Test No.", '<>%1', "Test No.");
                if rTest.Find('-') then begin
                    repeat
                        l_NProvas := l_NProvas + 1;
                        l_TotProvas := l_TotProvas + rTest.Points;
                    until rTest.Next = 0;
                end;

                if Points <> 0 then l_NProvas := l_NProvas + 1;
                l_TotProvas := l_TotProvas + Points;

                rCandidateEntry.Reset;
                rCandidateEntry.SetRange("Candidate No.", "Candidate no.");
                rCandidateEntry.SetRange("School Year", "School Year");
                rCandidateEntry.SetRange("Schooling Year", "Schooling Year");
                if rCandidateEntry.Find('-') then
                    if l_NProvas <> 0 then begin
                        rCandidateEntry.Validate(rCandidateEntry."Average Test Points", Round(l_TotProvas / l_NProvas, 0.01));
                        rCandidateEntry.Modify;
                    end;
            end;
        }
        field(17; Absent; Boolean)
        {
            Caption = 'Absent';

            trigger OnValidate()
            begin

                if (Absent = true) and ("Recover Classif." <> '') then
                    Error(Text009, FieldCaption("Recover Classif."));

                if (Absent = true) and (Points <> 0) then
                    Error(Text009, FieldCaption(Points));
            end;
        }
        field(18; Comments; Text[250])
        {
            Caption = 'Comments';
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text002,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(21; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            TableRelation = Students."No.";

            trigger OnLookup()
            begin
                rTest.Reset;
                rTest.SetRange("Test No.", "Test No.");
                rTest.SetRange("Line Type", rTest."Line Type"::Header);
                if rTest.Find('-') then begin
                    if (rTest."Schooling Year" = '') or (rTest."School Year" = '') then
                        Error(Text006, rTest.FieldCaption("School Year"), rTest.FieldCaption("Schooling Year"));

                    rStructureEducCountry.Reset;
                    rStructureEducCountry.SetRange(Country, rTest."Country/Region Code");
                    rStructureEducCountry.SetRange("Schooling Year", rTest."Schooling Year");
                    if rStructureEducCountry.Find('-') then begin
                        if rStructureEducCountry.Level = rStructureEducCountry.Level::"1º Cycle" then begin
                            rRegisClass.Reset;
                            rRegisClass.SetRange("Schooling Year", rStructureEducCountry."Schooling Year");
                            rRegisClass.SetRange("Recover Test", true);
                            if rRegisClass.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Absence Limit 1º Cycle", rRegisClass) = ACTION::LookupOK then begin
                                    Validate("Student No.", rRegisClass."Student Code No.");
                                    "Absence Option" := rRegisClass."Absence Option";
                                end;
                            end;
                        end else begin
                            rRegisSubjects.Reset;
                            rRegisSubjects.SetRange("Schooling Year", rStructureEducCountry."Schooling Year");
                            rRegisSubjects.SetRange("Recover Test", true);
                            if rRegisSubjects.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Absence Limit Other Cycles", rRegisSubjects) = ACTION::LookupOK then begin
                                    Validate("Student No.", rRegisSubjects."Student Code No.");
                                    "Subjects Code" := rRegisSubjects."Subjects Code";
                                    "Absence Option" := rRegisSubjects."Absence Option";
                                end;
                            end;
                        end;
                        Level := rStructureEducCountry.Level;
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Student No." <> '' then begin
                    if rStudents.Get("Student No.") then
                        "Student Name" := rStudents."Full Name";
                end
                else
                    "Student Name" := '';
            end;
        }
        field(22; "Student Name"; Text[191])
        {
            Caption = 'Student Name';
        }
        field(23; "Test Type"; Option)
        {
            Caption = 'Test Type';
            OptionCaption = ' ,Candidate,Recover Test';
            OptionMembers = " ",Candidate,"Recover Test";
        }
        field(24; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification, Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                if (xRec."Evaluation Type" <> "Evaluation Type") then
                    "Assessment Code" := '';
            end;
        }
        field(25; "Assessment Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(26; "Recover Classif."; Text[30])
        {
            Caption = 'Recover Classif.';

            trigger OnLookup()
            begin
                rTest.Reset;
                rTest.SetRange("Test Type", rTest."Test Type"::"Recover Test");
                rTest.SetRange("Test No.", "Test No.");
                rTest.SetRange("Line Type", rTest."Line Type"::Header);
                if rTest.Find('-') then begin
                    rTest.TestField(rTest."Evaluation Type");
                    if rTest."Evaluation Type" <> rTest."Evaluation Type"::"None Qualification" then
                        rTest.TestField(rTest."Assessment Code");
                    if (rTest."Evaluation Type" = rTest."Evaluation Type"::Qualitative) then begin
                        rClassLevel.Reset;
                        rClassLevel.SetRange("Classification Group Code", rTest."Assessment Code");
                        if rClassLevel.Find('-') then
                            if PAGE.RunModal(PAGE::"List Grades", rClassLevel) = ACTION::LookupOK then
                                "Recover Classif." := rClassLevel."Classification Level Code";
                    end;

                    if (rTest."Evaluation Type" = rTest."Evaluation Type"::"Mixed-Qualification") or
                       (rTest."Evaluation Type" = rTest."Evaluation Type"::Quantitative) then begin
                        rClassLevel.Reset;
                        rClassLevel.SetRange("Classification Group Code", rTest."Assessment Code");
                        if rClassLevel.Find('-') then
                            if PAGE.RunModal(PAGE::"List Grades", rClassLevel) = ACTION::LookupOK then
                                "Recover Classif." := Format(rClassLevel.Value);
                    end;
                end;
            end;

            trigger OnValidate()
            var
                IdOrdenacaoClass: Integer;
                IDOrdenacaoNotaMin: Integer;
            begin

                if "Recover Classif." <> '' then begin
                    TestField(Absent, false);


                    //saber se a nota é positiva para tirar o pisco da prova de recuperação
                    rTest.Reset;
                    rTest.SetRange(rTest."Test Type", rTest."Test Type"::"Recover Test");
                    rTest.SetRange(rTest."Line Type", rTest."Line Type"::Header);
                    rTest.SetRange(rTest."Test No.", "Test No.");
                    if rTest.FindFirst then begin
                        rTest.TestField(rTest."Evaluation Type");
                        if rTest."Evaluation Type" <> rTest."Evaluation Type"::"None Qualification" then
                            rTest.TestField(rTest."Assessment Code");


                        if rTest."Evaluation Type" = rTest."Evaluation Type"::Qualitative then
                            "Recover Classif." := ValidateAssessmentQualitative(rTest."Assessment Code", "Recover Classif.");

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::Quantitative then
                            "Recover Classif." := Format(ValidateAssessmentQuant(rTest."Assessment Code", "Recover Classif."));

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::"Mixed-Qualification" then
                            "Recover Classif." := ValidateAssessmentMixed(rTest."Assessment Code", "Recover Classif.");

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::"None Qualification" then
                            Error(Text0013);

                        if rRankGroup.Get(rTest."Assessment Code") then begin
                            rClassLevel.Reset;
                            rClassLevel.SetCurrentKey(rClassLevel."Id Ordination");
                            rClassLevel.SetRange(rClassLevel."Classification Group Code", rRankGroup.Code);
                            rClassLevel.SetRange(rClassLevel."Classification Level Code", "Recover Classif.");
                            if rClassLevel.FindFirst then
                                IdOrdenacaoClass := rClassLevel."Id Ordination";

                            rClassLevel.Reset;
                            rClassLevel.SetCurrentKey(rClassLevel."Id Ordination");
                            rClassLevel.SetRange(rClassLevel."Classification Group Code", rRankGroup.Code);
                            rClassLevel.SetRange(rClassLevel."Classification Level Code", rRankGroup."Minimum Classification Level");
                            if rClassLevel.FindFirst then
                                IDOrdenacaoNotaMin := rClassLevel."Id Ordination";

                            if IdOrdenacaoClass >= IDOrdenacaoNotaMin then begin
                                if "Subjects Code" <> '' then begin
                                    rRegisSubjects.Reset;
                                    rRegisSubjects.SetRange(rRegisSubjects."Student Code No.", "Student No.");
                                    rRegisSubjects.SetRange(rRegisSubjects."School Year", "School Year");
                                    rRegisSubjects.SetRange(rRegisSubjects."Schooling Year", "Schooling Year");
                                    rRegisSubjects.SetRange(rRegisSubjects."Subjects Code", "Subjects Code");
                                    if rRegisSubjects.FindFirst then
                                        rRegisSubjects."Recover Test" := false;
                                    rRegisSubjects.Modify;

                                end else begin
                                    rRegisClass.Reset;
                                    rRegisClass.SetRange(rRegisClass."Student Code No.", "Student No.");
                                    rRegisClass.SetRange(rRegisClass."School Year", "School Year");
                                    rRegisClass.SetRange(rRegisClass."Schooling Year", "Schooling Year");
                                    if rRegisClass.FindFirst then
                                        rRegisClass."Recover Test" := false;
                                    rRegisClass.Modify;

                                end;
                            end;

                        end;
                    end;
                end;
            end;
        }
        field(27; "Subjects Code"; Code[10])
        {
            Caption = 'Subjects Code';
            TableRelation = Subjects.Code;
        }
        field(28; "Absence Option"; Option)
        {
            Caption = 'Absence Option';
            OptionCaption = ' ,Half Absence,Unjustified Total,Total,Half Unjustified';
            OptionMembers = " ","Half Absence","Unjustified Total",Total,"Half Unjustified";
        }
        field(30; "Excl Ret by Incidences"; Boolean)
        {
            Caption = 'Excluded/Retained by Incidences';

            trigger OnValidate()
            begin
                if xRec."Excl Ret by Incidences" = true then Error(Text0014);

                rStructureEducCountry.Reset;
                rStructureEducCountry.SetRange(rStructureEducCountry.Country, "Country/Region Code");
                rStructureEducCountry.SetRange(rStructureEducCountry.Level, Level);
                rStructureEducCountry.SetRange(rStructureEducCountry."Schooling Year", "Schooling Year");
                if rStructureEducCountry.FindFirst then begin
                    //Ensino Básico
                    if rStructureEducCountry.Granule = rStructureEducCountry.Granule::"Obrigatório" then begin
                        if Confirm(Text0015) then begin
                            rRegistration.Reset;
                            rRegistration.SetRange(rRegistration."Student Code No.", "Student No.");
                            rRegistration.SetRange(rRegistration."School Year", "School Year");
                            rRegistration.SetRange(rRegistration."Responsibility Center", "Responsibility Center");
                            rRegistration.SetRange(rRegistration."Schooling Year", "Schooling Year");
                            if rRegistration.FindFirst then begin
                                rRegistration.Validate(rRegistration."Actual Status", rRegistration."Actual Status"::"Retained from Absences");
                                rRegistration.Modify;
                            end;
                        end else
                            "Excl Ret by Incidences" := false;
                    end;
                    //Ensino Secundário
                    if rStructureEducCountry.Granule = rStructureEducCountry.Granule::"Secundário" then begin
                        if Confirm(Text0015) then begin
                            rRegisSubjects.Reset;
                            rRegisSubjects.SetRange(rRegisSubjects."Student Code No.", "Student No.");
                            rRegisSubjects.SetRange(rRegisSubjects."School Year", "School Year");
                            rRegisSubjects.SetRange(rRegisSubjects."Responsibility Center", "Responsibility Center");
                            rRegisSubjects.SetRange(rRegisSubjects."Schooling Year", "Schooling Year");
                            rRegisSubjects.SetRange(rRegisSubjects."Subjects Code", "Subjects Code");
                            if rRegisSubjects.FindFirst then begin
                                rRegisSubjects."Attendance Situation" := rRegisSubjects."Attendance Situation"::EF;
                                rRegisSubjects.Status := rRegisSubjects.Status::"Excluded by Incidences";
                                rRegisSubjects."Status Date" := WorkDate;
                                rRegisSubjects.Modify(true);
                                cStudentsRegistration.StudentsSubjectsEntry(rRegisSubjects);
                            end;
                        end else
                            "Excl Ret by Incidences" := false;

                    end;

                end;
            end;
        }
        field(31; "Test Classification"; Text[30])
        {
            Caption = 'Classification';

            trigger OnLookup()
            begin
                rTest.Reset;
                rTest.SetRange("Test Type", rTest."Test Type"::Candidate);
                rTest.SetRange("Test No.", "Test No.");
                rTest.SetRange("Line Type", rTest."Line Type"::Header);
                if rTest.Find('-') then begin
                    rTest.TestField(rTest."Evaluation Type");
                    if rTest."Evaluation Type" <> rTest."Evaluation Type"::"None Qualification" then
                        rTest.TestField(rTest."Assessment Code");
                    if (rTest."Evaluation Type" = rTest."Evaluation Type"::Qualitative) then begin
                        rClassLevel.Reset;
                        rClassLevel.SetRange("Classification Group Code", rTest."Assessment Code");
                        if rClassLevel.Find('-') then
                            if PAGE.RunModal(PAGE::"List Grades", rClassLevel) = ACTION::LookupOK then
                                "Test Classification" := rClassLevel."Classification Level Code";
                    end;

                    if (rTest."Evaluation Type" = rTest."Evaluation Type"::"Mixed-Qualification") or
                       (rTest."Evaluation Type" = rTest."Evaluation Type"::Quantitative) then begin
                        rClassLevel.Reset;
                        rClassLevel.SetRange("Classification Group Code", rTest."Assessment Code");
                        if rClassLevel.Find('-') then
                            if PAGE.RunModal(PAGE::"List Grades", rClassLevel) = ACTION::LookupOK then
                                "Test Classification" := Format(rClassLevel.Value);
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Test Classification" <> '' then begin
                    TestField(Absent, false);


                    //saber se a nota é positiva para tirar o pisco da prova de recuperação
                    rTest.Reset;
                    rTest.SetRange(rTest."Test Type", rTest."Test Type"::Candidate);
                    rTest.SetRange(rTest."Line Type", rTest."Line Type"::Header);
                    rTest.SetRange(rTest."Test No.", "Test No.");
                    if rTest.FindFirst then begin
                        rTest.TestField(rTest."Evaluation Type");
                        if rTest."Evaluation Type" <> rTest."Evaluation Type"::"None Qualification" then
                            rTest.TestField(rTest."Assessment Code");


                        if rTest."Evaluation Type" = rTest."Evaluation Type"::Qualitative then
                            "Test Classification" := ValidateAssessmentQualitative(rTest."Assessment Code", "Test Classification");

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::Quantitative then
                            "Test Classification" := Format(ValidateAssessmentQuant(rTest."Assessment Code", "Test Classification"));

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::"Mixed-Qualification" then
                            "Test Classification" := ValidateAssessmentMixed(rTest."Assessment Code", "Test Classification");

                        if rTest."Evaluation Type" = rTest."Evaluation Type"::"None Qualification" then
                            Error(Text0013);

                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Test Type", "Test No.", "Line Type", "Candidate no.", "Student No.")
        {
            Clustered = true;
        }
        key(Key2; "Line Type", "Candidate no.", "School Year", "Schooling Year", Absent)
        {
            SumIndexFields = Points;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        l_NProvas: Integer;
        l_TotProvas: Decimal;
    begin
        if "Line Type" = "Line Type"::Header then begin
            rTest.Reset;
            rTest.SetRange("Test Type", "Test Type"::Candidate);
            rTest.SetRange("Test No.", "Test No.");
            rTest.SetRange("Line Type", rTest."Line Type"::Line);
            if rTest.FindFirst then
                Error(Text008);
        end;

        Clear(l_NProvas);
        Clear(l_TotProvas);
        rTest.Reset;
        rTest.SetRange("Line Type", "Line Type"::Line);
        rTest.SetRange(rTest."Candidate no.", "Candidate no.");
        rTest.SetRange(rTest."School Year", "School Year");
        rTest.SetRange(rTest."Schooling Year", "Schooling Year");
        rTest.SetFilter(rTest.Points, '<>%1', 0.0);
        rTest.SetFilter(rTest."Test No.", '<>%1', "Test No.");
        if rTest.Find('-') then begin
            repeat
                l_NProvas := l_NProvas + 1;
                l_TotProvas := l_TotProvas + rTest.Points;
            until rTest.Next = 0;
        end;


        rCandidateEntry.Reset;
        rCandidateEntry.SetRange("Candidate No.", "Candidate no.");
        rCandidateEntry.SetRange("School Year", "School Year");
        rCandidateEntry.SetRange("Schooling Year", "Schooling Year");
        if rCandidateEntry.Find('-') then
            if l_NProvas <> 0 then begin
                rCandidateEntry.Validate(rCandidateEntry."Average Test Points", Round(l_TotProvas / l_NProvas, 0.01));
                rCandidateEntry.Modify;
            end;
    end;

    trigger OnInsert()
    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if ("Line Type" = "Line Type"::Header) and ("Test Type" = "Test Type"::Candidate) then begin
            if "Test No." = '' then begin
                rEduConfiguration.Get;
                rEduConfiguration.TestField("Test Nos.");
                NoSeriesMgt.InitSeries(rEduConfiguration."Test Nos.", xRec."No. Series", 0D, "Test No.", "No. Series");
            end;
        end;

        if ("Line Type" = "Line Type"::Header) and ("Test Type" = "Test Type"::"Recover Test") then begin
            if "Test No." = '' then begin
                rEduConfiguration.Get;
                rEduConfiguration.TestField("Recover Test Nos.");
                NoSeriesMgt.InitSeries(rEduConfiguration."Recover Test Nos.", xRec."No. Series", 0D, "Test No.", "No. Series");
            end;
        end;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if ("Line Type" = "Line Type"::Line) and ("Test Type" = "Test Type"::"Recover Test") then begin
            rTest.Reset;
            rTest.SetRange(rTest."Test Type", "Test Type");
            rTest.SetRange(rTest."Test No.", "Test No.");
            if rTest.FindSet then begin
                "School Year" := rTest."School Year";
                "Schooling Year" := rTest."Schooling Year";
                Date := rTest.Date;
            end;
        end;
    end;

    var
        Text001: Label 'Candidate %1 cannot be added because a School Year is not defined yet.';
        rTest: Record Test;
        rStudents: Record Students;
        rStructureEducCountry: Record "Structure Education Country";
        rRegisClass: Record "Registration Class";
        rRegisSubjects: Record "Registration Subjects";
        rCandidateEntry: Record "Candidate Entry";
        RespCenter: Record "Responsibility Center";
        rRegistration: Record Registration;
        rCandidate: Record Candidate;
        cUserEducation: Codeunit "User Education";
        Text002: Label 'Your identification is set up to process from %1 %2 only.';
        Text003: Label 'Candidate %1 already has a Test from another School Year.';
        Text004: Label 'Candidate %1 has no candidature for School year %2.';
        cStudentsRegistration: Codeunit "Students Registration";
        Text005: Label 'The candidate schooling year is not equal to Test schooling year.';
        Text006: Label 'Selected Student cannot be inserted while %1 and %2 are not indicated.';
        Text007: Label 'Candidate %1 already is selected for this Test.';
        rUserSetup: Record "User Setup";
        Text008: Label 'Not allowed to delete.';
        Text009: Label 'The field %1 must be blank.';
        rRankGroup: Record "Rank Group";
        rClassLevel: Record "Classification Level";
        Text0010: Label 'There is no code inserted.';
        Text0011: Label 'Grade should be a Number.';
        Text0012: Label 'Grade should be between %1 and %2.';
        varClassification: Text[30];
        Text0013: Label 'You can not insert a grade, the Evaluation Type is None Qualification.';
        Text0014: Label 'You can not change this field.';
        Text0015: Label 'Are you sure you want to Exclud the student 1%?';

    //[Scope('OnPrem')]
    procedure CreateTest(pCandidate: Code[20]; pDescription: Text[30]; pTypeOfTest: Integer; pDate: Date; pTime: Time; pDuration: Decimal; pRoom: Code[20]; pTeacher: Code[20]; pSchoolYear: Code[20]; pSchoolingYear: Code[20]): Code[20]
    var
        rTestLine: Record Test;
        rTestHeader: Record Test;
    begin
        //Insert Header Line
        rTestHeader.Init;
        rTestHeader."Line Type" := 0;
        rTestHeader.Description := pDescription;
        rTestHeader."Type of Test" := pTypeOfTest;
        rTestHeader.Date := pDate;
        rTestHeader.Hour := pTime;
        rTestHeader.Duration := pDuration;
        rTestHeader.Room := pRoom;
        rTestHeader."Teacher No." := pTeacher;
        rTestHeader."School Year" := pSchoolYear;
        rTestHeader."Schooling Year" := pSchoolingYear;
        rTestHeader."Test Type" := rTestHeader."Test Type"::Candidate;
        rTestHeader.Insert(true);

        //Insert Test Line
        rTestLine.Init;
        rTestLine."Line Type" := 1;
        rTestLine."Test No." := rTestHeader."Test No.";
        rTestLine.Validate("Candidate no.", pCandidate);
        rTestLine."School Year" := pSchoolYear;
        rTestLine."Schooling Year" := pSchoolingYear;
        rTestLine."Test Type" := rTestLine."Test Type"::Candidate;
        rTestLine.Insert(true);

        exit(rTestHeader."Test No.");
    end;

    //[Scope('OnPrem')]
    procedure ChangeTest(pCandidate: Code[20]; pTestNo: Code[20]; pSchoolYear: Code[20]; pSchoolingYear: Code[20]): Code[20]
    var
        rTestLine: Record Test;
        rTestHeader: Record Test;
    begin

        //Insert Test Line
        rTestLine.Init;
        rTestLine."Test Type" := rTestLine."Test Type"::Candidate;
        rTestLine."Line Type" := 1;
        rTestLine."Test No." := pTestNo;
        rTestLine.Validate("Candidate no.", pCandidate);
        rTestLine."School Year" := pSchoolYear;
        rTestLine."Schooling Year" := pSchoolingYear;
        rTestLine.Insert(true);

        exit(rTestHeader."Test No.");
    end;

    //[Scope('OnPrem')]
    procedure ValidateSchoolYear(pTest: Record Test)
    var
        rTest: Record Test;
        rCandidateEntry: Record "Candidate Entry";
    begin
        rTest.Reset;
        rTest.SetRange("Line Type", rTest."Line Type"::Header);
        rTest.SetRange("Test No.", pTest."Test No.");
        rTest.SetRange("School Year", '');
        if rTest.Find('-') then
            Error(Text001, pTest."Candidate no.");

        rCandidateEntry.Reset;
        rCandidateEntry.SetRange("Candidate No.", pTest."Candidate no.");

        rTest.Reset;
        rTest.SetRange("Test No.", pTest."Test No.");
        rTest.SetRange("Line Type", "Line Type"::Header);
        if rTest.Find('-') then begin
            rCandidateEntry.SetRange("School Year", rTest."School Year");
            rCandidateEntry.SetRange("Schooling Year", rTest."Schooling Year");
        end;
        if rCandidateEntry.Find('-') then begin
            "School Year" := rCandidateEntry."School Year";
            "Schooling Year" := rCandidateEntry."Schooling Year";
        end else begin
            rCandidateEntry.Reset;
            rCandidateEntry.SetRange("Candidate No.", pTest."Candidate no.");
            rTest.Reset;
            rTest.SetRange("Test No.", pTest."Test No.");
            rTest.SetRange("Line Type", "Line Type"::Header);
            if rTest.Find('-') then
                rCandidateEntry.SetRange("School Year", rTest."School Year");
            if not rCandidateEntry.Find('-') then
                Error(Text004, pTest."Candidate no.", rTest."School Year");

            rCandidateEntry.Reset;
            rCandidateEntry.SetRange("Candidate No.", pTest."Candidate no.");
            rTest.Reset;
            rTest.SetRange("Test No.", pTest."Test No.");
            rTest.SetRange("Line Type", "Line Type"::Header);
            if rTest.Find('-') then
                rCandidateEntry.SetRange("Schooling Year", rTest."Schooling Year");
            if not rCandidateEntry.Find('-') then
                Error(Text005);
        end;
    end;

    //[Scope('OnPrem')]
    procedure AssistEdit(OldTest: Record Test): Boolean
    var
        Test: Record Test;
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        Test := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Test Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Test Nos.", OldTest."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("Test No.");
            Rec := Test;
            exit(true);
        end;
    end;
    //[Scope('OnPrem')]
    procedure ValidateAssessmentQualitative(GroupCode: Code[20]; inText: Text[250]) Out: Code[20]
    var
        rClassificationLevel: Record "Classification Level";
    begin
        rClassificationLevel.Reset;
        rClassificationLevel.SetRange("Classification Group Code", GroupCode);
        rClassificationLevel.SetFilter("Classification Level Code", inText);
        if rClassificationLevel.FindSet(false, false) then
            exit(rClassificationLevel."Classification Level Code")
        else
            Error(Text0010);
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentQuant(GroupCode: Code[20]; InText: Text[250]) Out: Decimal
    var
        varClasification: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin
        if InText <> '' then begin
            if not Evaluate(varClasification, InText) then
                Error(Text0011);
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", GroupCode);
            if rClassificationLevel.FindFirst then begin
                if (rClassificationLevel."Min Value" <= varClasification) and
                    (rClassificationLevel."Max Value" >= varClasification) then
                    exit(varClasification)
                else
                    Error(Text0012, rClassificationLevel."Min Value", rClassificationLevel."Max Value");
            end;
        end else
            exit(0);
    end;

    //[Scope('OnPrem')]
    procedure ValidateAssessmentMixed(GroupCode: Code[20]; InText: Text[250]) Out: Text[30]
    var
        varLocalClasification: Decimal;
        rClassificationLevelMin: Record "Classification Level";
        rClassificationLevelMax: Record "Classification Level";
        VarMinValue: Decimal;
        VarMaxValue: Decimal;
        rClassificationLevel: Record "Classification Level";
    begin

        Clear(varClassification);
        if InText <> '' then begin
            if Evaluate(varLocalClasification, InText) then begin
                rClassificationLevelMin.Reset;
                rClassificationLevelMin.SetCurrentKey("Id Ordination");
                rClassificationLevelMin.Ascending(true);
                rClassificationLevelMin.SetRange("Classification Group Code", GroupCode);
                if rClassificationLevelMin.Find('-') then
                    VarMinValue := rClassificationLevelMin."Min Value";

                rClassificationLevelMax.Reset;
                rClassificationLevelMax.SetCurrentKey("Id Ordination");
                rClassificationLevelMax.Ascending(false);
                rClassificationLevelMax.SetRange("Classification Group Code", GroupCode);
                if rClassificationLevelMax.Find('-') then
                    VarMaxValue := rClassificationLevelMax."Max Value";

                if (VarMinValue <= varLocalClasification) and
                    (VarMaxValue >= varLocalClasification) then begin
                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", GroupCode);
                    rClassificationLevel.SetRange(Value, varLocalClasification);
                    if rClassificationLevel.FindSet(false, false) then begin
                        varClassification := rClassificationLevel."Classification Level Code";
                        exit(Format(varLocalClasification));
                    end;

                    rClassificationLevel.Reset;
                    rClassificationLevel.SetRange("Classification Group Code", GroupCode);
                    if rClassificationLevel.Find('-') then begin
                        repeat
                            if (rClassificationLevel."Min Value" <= varLocalClasification) and
                               (rClassificationLevel."Max Value" >= varLocalClasification) then begin
                                varClassification := rClassificationLevel."Classification Level Code";
                                exit(Format(varLocalClasification));
                            end;
                        until rClassificationLevel.Next = 0
                    end;

                end else
                    Error(Text0012, VarMinValue, VarMaxValue);
            end;
            rClassificationLevel.Reset;
            rClassificationLevel.SetRange("Classification Group Code", GroupCode);
            rClassificationLevel.SetRange("Classification Level Code", InText);
            if rClassificationLevel.FindSet(false, false) then begin
                varClassification := rClassificationLevel."Classification Level Code";
                exit(Format(rClassificationLevel.Value));

            end else
                Error(Text0010);

        end;
    end;
}

