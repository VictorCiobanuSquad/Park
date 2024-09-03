table 52845 "Registration Class Entry"
{
    Caption = 'Registration Class Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"));
        }
        field(5; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";

            trigger OnLookup()
            var
                TempStudents: Record Students temporary;
            begin
            end;
        }
        field(6; Name; Text[128])
        {
            Caption = 'Name';
        }
        field(7; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Correct,Subscribed,Transfer,Cancelled';
            OptionMembers = Correct,Subscribed,Transfer,Cancelled;
        }
        field(9; "Status Date"; Date)
        {
            Caption = 'Status Date';
        }
        field(13; "School Name"; Text[128])
        {
            Caption = 'School Name';
        }
        field(14; "Transfer Class"; Code[20])
        {
            Caption = 'Transfer Class';
        }
        field(15; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                     "Schooling Year" = FIELD("Schooling Year"))
            ELSE IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            CalcFormula = Lookup("Company Information"."Country/Region Code");
            Caption = 'Country/Region Code';
            FieldClass = FlowField;
        }
        field(18; "Responsibility Center"; Code[10])
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
        field(19; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(21; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
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
        field(75000; Destination; Option)
        {
            Caption = 'Destination';
            Description = 'MISI';
            OptionCaption = ' ,Public School,Private School,Foreign';
            OptionMembers = " ","Public School","Private School",Foreign;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year", Class, "Class No.", "Status Date")
        {
        }
        key(Key3; "School Year", "Schooling Year", Class, "Student Code No.", "Status Date")
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
        Date := Today;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := Today;
    end;

    var
        Text001: Label 'You cannot eliminate lines.';
        Text002: Label 'Unknown';
        Text003: Label 'There already is a Pupil in the Class.';
        cStudentsRegistration: Codeunit "Students Registration";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
}

