table 52766 "Services Plan Head"
{
    Caption = 'Services Plan Header';
    LookupPageID = "Services Plan List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    if rEduConfiguration.Get then;
                    //NoSeriesMgt.TestManual(rEduConfiguration."Service Plan Nos.");
                    //TODO: to test NoSeries
                    CU_NoSeries.TestManual(rEduConfiguration."Service Plan Nos.");
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
                rServicesPlanLine.Reset;
                rServicesPlanLine.SetRange(Code, Code);
                if ((xRec."School Year" <> '') and (xRec."School Year" <> "School Year")) and (rServicesPlanLine.Find('-')) then begin
                    if ((xRec."School Year" <> '') and (xRec."School Year" <> "School Year")) and (not rServicesPlanLine.Find('-')) then
                        Error(Text0005);
                    if (rServicesPlanLine.Find('-')) then
                        Error(Text0003);
                end;
            end;
        }
        field(3; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("School Year" = FILTER(<> ''),
                                "Schooling Year" = FILTER(<> ''),
                                Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                     "Schooling Year" = FIELD("Schooling Year"),
                                                                                     "Responsibility Center" = FIELD("Responsibility Center"))
            ELSE
            IF ("School Year" = FILTER(<> ''),
                                                                                              "Schooling Year" = FILTER(<> ''),
                                                                                              Type = FILTER(Multi)) "Course Header".Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = IF ("School Year" = FILTER(<> '')) "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                rStrEduCountry.Reset;
                rStrEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                rStrEduCountry.SetRange("Schooling Year", "Schooling Year");
                if rStrEduCountry.FindFirst then
                    Type := rStrEduCountry.Type;


                rServicesPlanLine.Reset;
                rServicesPlanLine.SetRange(Code, Code);
                if ((xRec."Schooling Year" <> '') and (xRec."Schooling Year" <> "Schooling Year")) and (rServicesPlanLine.Find('-')) then begin
                    if ((xRec."Schooling Year" <> '') and (xRec."Schooling Year" <> "Schooling Year")) and (not rServicesPlanLine.Find('-')) then
                        Error(Text0001);
                    if rServicesPlanLine.FindFirst then
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
        field(7; Description; Text[30])
        {
            Caption = 'Description';
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
            end;
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(10; "Exist Service Plan"; Boolean)
        {
            CalcFormula = Exist(Registration WHERE("Services Plan Code" = FIELD(Code),
                                                    "School Year" = FIELD("School Year"),
                                                    "Schooling Year" = FIELD("Schooling Year"),
                                                    "Responsibility Center" = FIELD("Responsibility Center")));
            Caption = 'Exist Study Plan';
            FieldClass = FlowField;
        }
        field(1000; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(1001; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "School Year")
        {
        }
        key(Key3; "Study Plan Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Exist Service Plan");
        if "Exist Service Plan" then
            Error(Text0007);

        rServPlanLine.Reset;
        rServPlanLine.SetFilter(Code, Code);
        rServPlanLine.SetFilter("School Year", "School Year");
        rServPlanLine.SetFilter("Schooling Year", "Schooling Year");
        rServPlanLine.SetFilter("Responsibility Center", "Responsibility Center");
        rServPlanLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if Code = '' then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Service Plan Nos.");
            //NoSeriesMgt.InitSeries(rEduConfiguration."Service Plan Nos.", xRec."No. Series", 0D, Code, "No. Series");
            //TODO: to test NoSeries
            if CU_NoSeries.AreRelated(rEduConfiguration."Service Plan Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            Code := CU_NoSeries.GetNextNo("No. Series");
        end;




        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";


        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    var
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        ServicesET: Record "Services ET";
        rServPlanLine: Record "Services Plan Line";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        cStudentsRegistration: Codeunit "Students Registration";
        rUserSetup: Record "User Setup";
        rEduConfiguration: Record "Edu. Configuration";
        rStrEduCountry: Record "Structure Education Country";
        Text0007: Label 'There already are students associated to the Service Plan.';
        rServicesPlanLine: Record "Services Plan Line";
        Text0003: Label 'Cannot modify the School year while lines are not put out manually.';
        Text0005: Label 'Cannot modify the School year.';
        Text0001: Label 'Cannot modify the Schooling Year.';
        Text0002: Label 'Cannot modify the Schooling  Year while lines are not put out manually.';
        CU_NoSeries: Codeunit "No. Series";

    local procedure GetService()
    begin
        TestField("Schooling Year");
        if "Schooling Year" <> ServicesET."No." then
            ServicesET.Get("Schooling Year");
    end;

    //[Scope('OnPrem')]
    procedure AssistEdit(OldServicesPlanHeader: Record "Services Plan Head"): Boolean
    var
        ServicesPlanHead: Record "Services Plan Head";
    begin

        ServicesPlanHead := Rec;
        if rEduConfiguration.Get then;
        rEduConfiguration.TestField("Service Plan Nos.");
        //if NoSeriesMgt.SelectSeries(rEduConfiguration."Service Plan Nos.", OldServicesPlanHeader."No. Series", "No. Series") then begin
        //NoSeriesMgt.SetSeries(Code);
        if CU_NoSeries.LookupRelatedNoSeries(OldServicesPlanHeader."No. Series", rEduConfiguration."Service Plan Nos.", "No. Series") then begin
            CU_NoSeries.GetNextNo(Code);
            //TODO: to test NoSeries

            Rec := ServicesPlanHead;
            exit(true);
        end;

    end;
}

