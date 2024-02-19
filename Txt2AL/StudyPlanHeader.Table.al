table 31009761 "Study Plan Header"
{
    Caption = 'Study Plan Header';
    DrillDownPageID = "Study Plan List";
    LookupPageID = "Study Plan List";
    Permissions = TableData Absence = rimd;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    if rEduConfiguration.Get then;
                    NoSeriesMgt.TestManual(rEduConfiguration."Study Plan Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Planning | Active));

            trigger OnValidate()
            begin
                rStudyPlanLines.Reset;
                rStudyPlanLines.SetRange(Code, Code);
                if ((xRec."School Year" <> '') and (xRec."School Year" <> "School Year")) and (rStudyPlanLines.Find('-')) then begin
                    if ((xRec."School Year" <> '') and (xRec."School Year" <> "School Year")) and (not rStudyPlanLines.Find('-')) then
                        Error(Text0005);
                    if (rStudyPlanLines.Find('-')) then
                        Error(Text0003);
                end;
            end;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"),
                                                                                  Type = FILTER(Simple));

            trigger OnValidate()
            begin
                rStudyPlanLines.Reset;
                rStudyPlanLines.SetRange(Code, Code);
                if ((xRec."Schooling Year" <> '') and (xRec."Schooling Year" <> "Schooling Year")) and (rStudyPlanLines.Find('-')) then begin
                    if ((xRec."Schooling Year" <> '') and (xRec."Schooling Year" <> "Schooling Year")) and (not rStudyPlanLines.Find('-')) then
                        Error(Text0001);
                    if (rStudyPlanLines.Find('-')) then
                        Error(Text0002);
                end;
            end;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(8; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));


                rStudyPlanLines.Reset;
                rStudyPlanLines.SetRange(Code, Code);
                rStudyPlanLines.SetRange("School Year", "School Year");
                rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
                if rStudyPlanLines.Find('-') then begin
                    repeat
                        rStudyPlanLines."Responsibility Center" := "Responsibility Center";
                        rStudyPlanLines.Modify(true);
                    until rStudyPlanLines.Next = 0;
                end;
            end;
        }
        field(9; "Assessment Code"; Code[30])
        {
            Caption = 'AssessmentCode';
            TableRelation = "Rank Group".Code;

            trigger OnValidate()
            begin
                //InsertSettingRatings;
            end;
        }
        field(10; "Aprovation Code"; Code[10])
        {
            Caption = 'Approval Code';
            TableRelation = IF ("Assessment Code" = FILTER(<> '')) "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
        }
        field(11; "Transition Code"; Code[10])
        {
            Caption = 'Transition Code';
            TableRelation = IF ("Assessment Code" = FILTER(<> '')) "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
        }
        field(12; "Temp Code"; Code[20])
        {
            Caption = 'Temp Code';
        }
        field(13; "Exist Study Plan"; Boolean)
        {
            CalcFormula = Exist(Registration WHERE("Study Plan Code" = FIELD(Code),
                                                    "School Year" = FIELD("School Year"),
                                                    "Schooling Year" = FIELD("Schooling Year"),
                                                    "Responsibility Center" = FIELD("Responsibility Center")));
            Caption = 'Exist Study Plan';
            FieldClass = FlowField;
        }
        field(14; "Maximum Unjustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" < "Maximum Unjustified Absence") and ("Maximum Total Absence" <> 0) then
                    Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absence"));

                //PT
                VerificarFaltas("Study Plan Code", "School Year");
            end;
        }
        field(15; "Maximum Total Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Total Absence';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" <> 0) then begin
                    if "Maximum Total Absence" < "Maximum Unjustified Absence" then
                        Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absence"));
                end;

                //PT
                VerificarFaltas("Study Plan Code", "School Year");
            end;
        }
        field(16; "Code Text"; Text[30])
        {
            Caption = 'Code';
        }
        field(17; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(20; "Sub-subjects for assess. only"; Boolean)
        {
            Caption = 'Sub-subjects for assessments only';

            trigger OnValidate()
            var
                rStudyPlanLines: Record "Study Plan Lines";
            begin
                CalcFields("Exist Study Plan");
                if "Exist Study Plan" = false then begin
                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetRange(rStudyPlanLines.Code, Code);
                    rStudyPlanLines.SetRange(rStudyPlanLines."School Year", "School Year");
                    rStudyPlanLines.SetRange(rStudyPlanLines."Schooling Year", "Schooling Year");
                    rStudyPlanLines.ModifyAll(rStudyPlanLines."Sub-subjects for assess. only", "Sub-subjects for assess. only");
                end else
                    Error(Text0007);
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
        field(75000; "Study Plan Type"; Option)
        {
            Caption = 'Study Plan Type';
            Description = 'MISI/VERI';
            OptionCaption = ' ,General,Scientific-Human,Technological,Artistic,Professional,CEF,Appellant,EFA';
            OptionMembers = " ",GR,CH,TE,AR,PRO,CEF,REC,EFA;

            trigger OnValidate()
            begin
                if "Study Plan Type" <> xRec."Study Plan Type" then begin
                    "Study Plan Name" := '';
                    "Study Plan Name2" := '';
                    "Study Plan Code" := '';
                    "Study Plan Description" := '';
                end;
            end;
        }
        field(75001; "Study Plan Name"; Code[10])
        {
            Caption = 'Study Plan Name';
            Description = 'MISI/VERI';

            trigger OnLookup()
            var
                i: Integer;
            begin
                i := "Study Plan Type" + 7;
                if "Study Plan Type" <> 0 then begin
                    rTableMISI.Reset;
                    rTableMISI.SetRange(rTableMISI.Type, i);
                    if rTableMISI.FindSet then begin
                        if PAGE.RunModal(PAGE::"MISI List", rTableMISI) = ACTION::LookupOK then begin
                            "Study Plan Name" := rTableMISI.Code;
                            "Study Plan Name2" := rTableMISI.Description;
                        end;
                    end else
                        Error(Text0009);
                end;
            end;

            trigger OnValidate()
            var
                i: Integer;
            begin
                i := "Study Plan Type" + 7;
                rTableMISI.Reset;
                rTableMISI.SetRange(rTableMISI.Type, i);
                rTableMISI.SetRange(rTableMISI.Code, "Study Plan Name");
                if rTableMISI.FindFirst then
                    "Study Plan Name2" := rTableMISI.Description
                else begin
                    "Study Plan Name" := '';
                    "Study Plan Name2" := '';
                end;
            end;
        }
        field(75002; "Study Plan Name2"; Text[250])
        {
            Caption = 'Study Plan Name';
            Description = 'MISI/VERI';
            Editable = false;
        }
        field(75003; "Study Plan Code"; Code[10])
        {
            Caption = 'Study Plan Code';
            Description = 'MISI/VERI';
            TableRelation = "Table MISI".Code WHERE(Type = CONST(CodCurso));

            trigger OnValidate()
            begin
                rTableMISI.Reset;
                rTableMISI.SetRange(rTableMISI.Type, rTableMISI.Type::CodCurso);
                rTableMISI.SetRange(rTableMISI.Code, "Study Plan Code");
                if rTableMISI.FindFirst then
                    "Study Plan Description" := rTableMISI.Description
                else
                    "Study Plan Description" := '';
            end;
        }
        field(75004; "Study Plan Description"; Text[250])
        {
            Caption = 'Study Plan Description';
            Description = 'MISI/VERI';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Exist Study Plan");
        if "Exist Study Plan" then
            Error(Text0007);

        rStudyPlanLines.Reset;
        rStudyPlanLines.SetFilter(Code, Code);
        rStudyPlanLines.SetFilter("School Year", "School Year");
        rStudyPlanLines.SetFilter("Schooling Year", "Schooling Year");
        rStudyPlanLines.SetFilter("Responsibility Center", "Responsibility Center");
        if rStudyPlanLines.Find('-') then
            //rStudyPlanLines.DELETEALL;
            Error(Text0006, Code);

        rClass.Reset;
        rClass.SetRange(Type, rClass.Type::Simple);
        rClass.SetFilter("Study Plan Code", Code);
        rClass.SetFilter("School Year", "School Year");
        rClass.SetFilter("Schooling Year", "Schooling Year");
        rClass.SetFilter("Responsibility Center", "Responsibility Center");
        if rClass.Find('-') then
            Error(Text0008, Code);
    end;

    trigger OnInsert()
    begin

        if Code = '' then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Study Plan Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Study Plan Nos.", xRec."No. Series", 0D, Code, "No. Series");
        end;

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";


        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        rStudyPlanLines: Record "Study Plan Lines";
        cStudentsRegistration: Codeunit "Students Registration";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0001: Label 'Cannot modify Schooling Year.';
        Text0002: Label 'Cannot modify Schooling  Year while lines are not put out manually.';
        Text0003: Label 'Cannot modify School year while lines are not put out manually.';
        Text0005: Label 'Cannot modify School year.';
        Text0006: Label '%1 cannot put the study plan out while lines are not put out manually.';
        Text0007: Label 'There already are students associated to the Study Plan.';
        rClass: Record Class;
        Text0008: Label 'There already is a class with the Study Plan %1';
        Text0013: Label 'The field %1 must be higher than the field %2.';
        Text0009: Label 'There are no settings.';
        rTableMISI: Record "Table MISI";

    //[Scope('OnPrem')]
    procedure AssistEdit(OldStudyPlanHeader: Record "Study Plan Header"): Boolean
    var
        StudyPlanHeader: Record "Study Plan Header";
    begin
        StudyPlanHeader := Rec;
        if rEduConfiguration.Get then;
        rEduConfiguration.TestField("Study Plan Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Study Plan Nos.", OldStudyPlanHeader."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries(Code);
            Rec := StudyPlanHeader;
            exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure VerificarFaltas(StudyPlan: Code[20]; SchoolYear: Code[20])
    var
        Absence: Record Absence;
        TEXT001: Label 'Incidences are already given to Students belonging to this Study Plan, changing this value may affect student eligibility for recovery tests.';
    begin
        //PT
        Absence.Reset;
        Absence.SetRange("Study Plan", StudyPlan);
        Absence.SetRange("School Year", SchoolYear);
        if Absence.Find('-') then
            Message(TEXT001);
    end;
}

