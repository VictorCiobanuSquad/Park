table 31009769 "Services Plan Line"
{
    // //IT001 - Park- 2018.06.28 - Novo campo qtd usado no carregamento do plano de serviços
    // //IT002 - Park- 2018.06.28 - Aumentei o campo desccription para 80 para ficar igual à ficha do serviço

    Caption = 'Services Plan Line';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
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
        }
        field(5; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            TableRelation = "Services ET"."No." WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                GetService;
                ServicesET.TestField(Blocked, false);
                Description := ServicesET.Description;
                "Description 2" := ServicesET."Description 2";
                January := ServicesET.January;
                February := ServicesET.February;
                March := ServicesET.March;
                April := ServicesET.April;
                May := ServicesET.May;
                June := ServicesET.June;
                July := ServicesET.July;
                August := ServicesET.August;
                Setember := ServicesET.Setember;
                October := ServicesET.October;
                November := ServicesET.November;
                Dezember := ServicesET.December;
            end;
        }
        field(6; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(8; "Service Type"; Option)
        {
            Caption = 'Service Type';
            OptionCaption = ' ,Required,Optional,Depending,Occasional';
            OptionMembers = " ",Required,Optional,Depending,Ocasional;
        }
        field(9; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(30; January; Boolean)
        {
            Caption = 'January';
        }
        field(31; February; Boolean)
        {
            Caption = 'February';
        }
        field(32; March; Boolean)
        {
            Caption = 'March';
        }
        field(33; April; Boolean)
        {
            Caption = 'April';
        }
        field(34; May; Boolean)
        {
            Caption = 'May';
        }
        field(35; June; Boolean)
        {
            Caption = 'June';
        }
        field(36; July; Boolean)
        {
            Caption = 'July';
        }
        field(37; August; Boolean)
        {
            Caption = 'August';
        }
        field(38; Setember; Boolean)
        {
            Caption = 'September';
        }
        field(39; October; Boolean)
        {
            Caption = 'October';
        }
        field(40; November; Boolean)
        {
            Caption = 'November';
        }
        field(41; Dezember; Boolean)
        {
            Caption = 'December';
        }
        field(50; "Responsibility Center"; Code[10])
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
        field(50000; Qtd; Integer)
        {
            Description = 'Park';
        }
    }

    keys
    {
        key(Key1; "Code", "School Year", "Schooling Year", "Service Code")
        {
            Clustered = true;
        }
        key(Key2; "School Year")
        {
        }
        key(Key3; "Schooling Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rStudentServicePlan.Reset;
        rStudentServicePlan.SetRange("Services Plan Code", Code);
        rStudentServicePlan.SetRange("Service Code", "Service Code");
        rStudentServicePlan.SetRange("Responsibility Center", "Responsibility Center");
        if rStudentServicePlan.FindFirst then
            Error(Text0001);
    end;

    trigger OnInsert()
    begin


        if rServicesPlanHead.Get(Code) then
            "Responsibility Center" := rServicesPlanHead."Responsibility Center";


        "Last Date Modified" := Today;
        "User ID" := UserId;


        if "Service Code" = '' then
            Error(Text0006, FieldCaption("Service Code"));
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    var
        ServicesET: Record "Services ET";
        rStudentServicePlan: Record "Student Service Plan";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0001: Label 'Cannot delete the line, there is a Student associated with this service.';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        rServicesPlanHead: Record "Services Plan Head";
        Text0003: Label 'The selected service is not allowed for use.';
        Text0006: Label 'The %1 Field is Mandatory.';

    local procedure GetService()
    begin
        TestField("Service Code");
        if "Service Code" <> ServicesET."No." then
            if ServicesET.Get("Service Code") then;


        if rServicesPlanHead.Get(Code) then
            if ServicesET."Responsibility Center" <> rServicesPlanHead."Responsibility Center" then
                Error(Text0003);
    end;
}

