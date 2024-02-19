table 31009794 "Save Filters"
{
    Caption = 'Save Filters';
    DrillDownPageID = "Filter List";
    LookupPageID = "Filter List";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(2; "Filter Code"; Code[20])
        {
            Caption = 'Filter Code';
        }
        field(3; Description; Text[60])
        {
            Caption = 'Description';
        }
        field(4; "Table No."; Integer)
        {
            Caption = 'Table No.';

            trigger OnValidate()
            begin
                if Table.Get(CompanyName, "Table No.") then
                    "Table Name" := Table."Table Name";
            end;
        }
        field(5; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
        }
        field(6; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(7; "Created On"; DateTime)
        {
            Caption = 'Created On';
        }
        field(8; Form; Text[50])
        {
            Caption = 'Form';
        }
        field(9; "Field No."; Integer)
        {
            Caption = 'Field No.';

            trigger OnValidate()
            begin
                FieldInfo.Reset;
                FieldInfo.SetRange(TableNo, "Table No.");
                FieldInfo.SetRange("No.", "Field No.");
                if FieldInfo.Find('-') then
                    "Field Caption" := FieldInfo."Field Caption"
                else
                    "Field Caption" := '';
            end;
        }
        field(10; "Field Caption"; Text[250])
        {
            Caption = 'Field Caption';
        }
        field(11; "Field Filter"; Text[250])
        {
            Caption = 'Field Filter';
        }
        field(12; "Global Filter"; Boolean)
        {
            Caption = 'Global Filter';
        }
        field(13; "Responsibility Center"; Code[10])
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
    }

    keys
    {
        key(Key1; Type, "Filter Code", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        FilterLines.SetRange("Filter Code", "Filter Code");
        FilterLines.SetRange(Type, FilterLines.Type::Line);
        FilterLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    var
        "Table": Record "Table Information";
        FilterLines: Record "Save Filters";
        FieldInfo: Record "Field";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center";
}

