table 52783 "Candidate Entry"
{
    Caption = 'Candidate Entry';

    fields
    {
        field(1; "Candidate No."; Code[20])
        {
            Caption = 'Candidate No.';
            TableRelation = Candidate."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            Editable = true;
            TableRelation = "School Year"."School Year";
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            var
                rCompanyInformation: Record "Company Information";
                rStruEduCountry: Record "Structure Education Country";
                l_last: Integer;
            begin

                rTest.Reset;
                rTest.SetRange(rTest."Test Type", rTest."Test Type"::Candidate);
                rTest.SetRange(rTest."Line Type", rTest."Line Type"::Line);
                rTest.SetRange(rTest."Candidate no.", xRec."Candidate No.");
                rTest.SetRange(rTest."School Year", xRec."School Year");
                rTest.SetRange(rTest."Schooling Year", xRec."Schooling Year");
                if rTest.FindFirst then
                    Error(Text0007, FieldCaption("Schooling Year"));


                if rCompanyInformation.Get then;

                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                if rStruEduCountry.FindLast then
                    l_last := rStruEduCountry."Sorting ID";

                rStruEduCountry.Reset;
                rStruEduCountry.SetRange(Country, rCompanyInformation."Country/Region Code");
                rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStruEduCountry.FindFirst then begin
                    Level := rStruEduCountry.Level;
                    "Sorting ID Schooling Year" := l_last + 1 - rStruEduCountry."Sorting ID";
                end;
            end;
        }
        field(5; Level; Option)
        {
            Caption = 'Level';
            Editable = false;
            OptionCaption = 'Pre school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = "Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;
        }
        field(6; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region".Code;
        }
        field(7; Priority; Code[20])
        {
            Caption = 'Priority';
            TableRelation = Priority.Code;

            trigger OnValidate()
            var
                rPriority: Record Priority;
            begin
                if Priority <> '' then begin
                    rPriority.Reset;
                    rPriority.Get(Priority);
                    Validate("Priority Points", rPriority."Priority Points");
                end else
                    "Priority Points" := 0;
            end;
        }
        field(8; "Priority Points"; Integer)
        {
            Caption = 'Priority Points';
            Editable = false;

            trigger OnValidate()
            begin
                "Total Points" := "Priority Points" + "Other Points" + "Average Test Points";
            end;
        }
        field(9; Comments; Text[250])
        {
            Caption = 'Comments';
        }
        field(10; Accepted; Boolean)
        {
            Caption = 'Accepted';

            trigger OnValidate()
            begin
                TestField(Excluding, false);
            end;
        }
        field(11; Excluding; Boolean)
        {
            Caption = 'Excluded';

            trigger OnValidate()
            begin
                TestField(Accepted, false);
            end;
        }
        field(12; Selection; Boolean)
        {
            Caption = 'Selection';

            trigger OnValidate()
            begin
                if Selection then
                    //VALIDATE("Selection User ID",USERID)
                    "Selection User ID" := UserId
                else
                    Validate("Selection User ID", '');
            end;
        }
        field(13; "Selection User ID"; Code[20])
        {
            Caption = 'Selection User ID';
            TableRelation = User;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("Selection User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Selection";
            begin
                LoginMgt.ValidateUserName("Selection User ID");
            end;
        }
        field(14; "Candidate Name"; Text[191])
        {
            CalcFormula = Lookup(Candidate."Full Name" WHERE("No." = FIELD("Candidate No.")));
            Caption = 'Candidate Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Conversion User ID"; Code[20])
        {
            Caption = 'Conversion User ID';
            Editable = false;
            TableRelation = User;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("Selection User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Selection";
            begin
                LoginMgt.ValidateUserName("Selection User ID");
            end;
        }
        field(16; "Conversion Date"; Date)
        {
            Caption = 'Conversion Date';
            Editable = false;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0003,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(18; "Other Points"; Decimal)
        {
            Caption = 'Other Points';

            trigger OnValidate()
            begin
                "Total Points" := "Priority Points" + "Other Points" + "Average Test Points";
            end;
        }
        field(19; "Average Test Points"; Decimal)
        {
            Caption = 'Average Test Points';
            Editable = false;

            trigger OnValidate()
            begin
                "Total Points" := "Priority Points" + "Other Points" + "Average Test Points";
            end;
        }
        field(20; "Total Points"; Decimal)
        {
            Caption = 'Total Points';
            Editable = false;
            FieldClass = Normal;
        }
        field(30; "Sorting ID Schooling Year"; Integer)
        {
            Caption = 'Sorting ID Schooling Year';
        }
    }

    keys
    {
        key(Key1; "Candidate No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year", "Priority Points")
        {
        }
        key(Key3; "Conversion User ID", "School Year", "Schooling Year", "Priority Points")
        {
        }
        key(Key4; "School Year", "Sorting ID Schooling Year", "Total Points")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if rCandidate.Get("Candidate No.") then
            if rCandidate."Student No." <> '' then
                Error(Text0004);
    end;

    trigger OnInsert()
    var
        l_rCandidateEntry: Record "Candidate Entry";
    begin
        if rCandidate.Get("Candidate No.") then
            "Responsibility Center" := rCandidate."Responsibility Center";


        l_rCandidateEntry.Reset;
        l_rCandidateEntry.SetRange(l_rCandidateEntry."Candidate No.", "Candidate No.");
        l_rCandidateEntry.SetRange(l_rCandidateEntry."School Year", "School Year");
        l_rCandidateEntry.SetRange(l_rCandidateEntry."Schooling Year", "Schooling Year");
        if l_rCandidateEntry.FindFirst then
            Error(Text0006);
    end;

    var
        Text0001: Label 'You must select one or more candidates.';
        Text0002: Label 'Candidates successfully converted!';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0003: Label 'Your identification is set up to process from %1 %2 only.';
        rCandidate: Record Candidate;
        Text0004: Label 'Not allowed to Delete.';
        Text0005: Label 'The candidate %1 must be accepted to be converted to student.';
        Text0006: Label 'The Candidate already has a candidature for this schooling year.';
        rTest: Record Test;
        Text0007: Label 'Não pode alterar o %1, pois já existem provas marcadas para este candidato.';

    //[Scope('OnPrem')]
    procedure CreateTest(pCandidateEntry: Record "Candidate Entry")
    var
        rTestHeader: Record Test;
        rTestLine: Record Test;
        Text0001: Label 'Please insert the %1 for this candidate %2.';
    begin
        if pCandidateEntry."School Year" = '' then
            Error(Text0001, pCandidateEntry.FieldCaption("School Year"), pCandidateEntry."Candidate No.");

        if pCandidateEntry."Schooling Year" = '' then
            Error(Text0001, pCandidateEntry.FieldCaption("Schooling Year"), pCandidateEntry."Candidate No.");

        pCandidateEntry.SetRange("Candidate No.", pCandidateEntry."Candidate No.");
        pCandidateEntry.SetRange("Line No.", pCandidateEntry."Line No.");
        PAGE.Run(PAGE::"Test Wizard", pCandidateEntry);
    end;

    //[Scope('OnPrem')]
    procedure OpenTest(pCandidateEntry: Record "Candidate Entry")
    var
        Text0001: Label 'You must define a %1  for the candidate %2.';
        rTestHeader: Record Test;
        rTestLine: Record Test;
    begin

        pCandidateEntry.SetRange("Candidate No.", pCandidateEntry."Candidate No.");
        rTestLine.Reset;
        rTestLine.SetRange("Line Type", rTestLine."Line Type"::Line);
        rTestLine.SetRange("Candidate no.", pCandidateEntry."Candidate No.");
        if rTestLine.Find('-') then
            rTestHeader.Reset;
        repeat
            rTestHeader.SetRange("Test No.", rTestLine."Test No.");
            rTestHeader.SetRange("Line Type", 0);
            if rTestHeader.Find('-') then
                rTestHeader.Mark(true);

        until rTestLine.Next = 0;

        rTestHeader.SetRange("Test No.");
        rTestHeader.MarkedOnly(true);

        PAGE.Run(PAGE::"Test List", rTestHeader);
    end;

    //[Scope('OnPrem')]
    procedure CreateStudent()
    var
        rCadidateEntry: Record "Candidate Entry";
        rCadidateEntryModify: Record "Candidate Entry";
        rCandidate: Record Candidate;
        TEXT001: Label 'Are you sure You want to create the students?';
    begin
        if not Confirm(TEXT001, false) then
            exit;

        rCadidateEntry.Reset;
        rCadidateEntry.SetRange("Selection User ID", UserId);
        if rCadidateEntry.Find('-') then begin
            repeat
                if Accepted = false then Error(Text0005, "Candidate No.");
                rCandidate.Get(rCadidateEntry."Candidate No.");
                rCandidate.CreateStudent(rCandidate, rCadidateEntry);

                rCadidateEntryModify.Get(rCadidateEntry."Candidate No.", rCadidateEntry."Line No.");
                rCadidateEntryModify."Conversion User ID" := UserId;
                rCadidateEntryModify."Conversion Date" := Today;
                rCadidateEntryModify."Selection User ID" := '';
                rCadidateEntryModify.Selection := false;
                rCadidateEntryModify.Modify;

            until rCadidateEntry.Next = 0;
            Message(Text0002);
        end
        else
            Message(Text0001);
    end;

    //[Scope('OnPrem')]
    procedure OpenCandidate()
    var
        rCandidate: Record Candidate;
    begin
        rCandidate.Reset;
        rCandidate.SetRange("No.", "Candidate No.");
        if rCandidate.FindFirst then
            rCandidate.SetRange("No.");

        PAGE.Run(PAGE::"Candidate Card", rCandidate);
    end;
}

