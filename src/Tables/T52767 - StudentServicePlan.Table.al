table 52767 "Student Service Plan"
{
    Caption = 'Student Services Plan';

    fields
    {
        field(1; "Student No."; Code[20])
        {
            Caption = 'Student No.';
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
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Service Code"; Code[20])
        {
            Caption = 'Service Code';
            TableRelation = IF (Type = FILTER(Service)) "Services ET"."No."
            ELSE
            IF (Type = FILTER(Item)) Item."No.";

            trigger OnValidate()
            begin
                if ServicesET.Get("Service Code") then begin
                    ServicesET.TestField(Blocked, false);
                    Description := ServicesET.Description;
                    "Description 2" := ServicesET."Description 2";
                end else begin
                    if recItem.Get("Service Code") then begin
                        recItem.TestField(Blocked, false);
                        Description := CopyStr(recItem.Description, 1, 30);
                        "Description 2" := CopyStr(recItem."Description 2", 1, 30);
                    end else begin
                        Description := '';
                        "Description 2" := '';
                    end;
                end;
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
            OptionCaption = ' ,Required,Optional,Depending,Ocasional';
            OptionMembers = " ",Required,Optional,Depending,Ocasional;

            trigger OnValidate()
            begin
                if "Service Type" = "Service Type"::Required then
                    Selected := true;
            end;
        }
        field(9; "Complete Name"; Text[60])
        {
            Caption = 'Complete Name';
            Editable = false;
        }
        field(10; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(11; Selection; Boolean)
        {
            Caption = 'Selection';
            Description = 'Usado para a atribuição dos Serviços';
            Enabled = false;
        }
        field(12; Heading; Code[50])
        {
            Caption = 'Heading';
        }
        field(13; Class; Code[20])
        {
            Caption = 'Class';
        }
        field(14; Project; Code[20])
        {
            Caption = 'Project';
        }
        field(15; "Services Plan Code"; Code[20])
        {
            Caption = 'Services Plan Code';
            TableRelation = "Services Plan Head".Code;

            trigger OnValidate()
            begin
                /*
                rStudentServicePlan.reset;
                rStudentServicePlan."Student No."
                rStudentServicePlan."School Year"
                rStudentServicePlan."Schooling Year"
                 */

            end;
        }
        field(30; January; Boolean)
        {
            Caption = 'January';
        }
        field(31; February; Boolean)
        {
            Caption = 'Februay';
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
            Caption = 'Setember';
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
            Caption = 'Dezember';
        }
        field(42; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(43; Selected; Boolean)
        {
            Caption = 'Selected';

            trigger OnValidate()
            var
                cStudentServices: Codeunit "Student Services";
            begin
                if Selected then begin
                    cStudentServices.DistributionByEntityRegis(Rec);
                    UpdateDist;
                end else
                    cStudentServices.DelDistributionByEntity(Rec);
            end;
        }
        field(44; "Student Unit Price"; Decimal)
        {
            Caption = 'Student Unit Price';
        }
        field(48; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = 'Service,Item';
            OptionMembers = Service,Item;
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
        field(50000; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                if ServicesET.Get("Service Code") then begin
                    ServicesET.TestField(Blocked, false);
                    "Unit Price" := ServicesET."Unit Price";
                end else begin
                    "Unit Price" := 0;
                end;
            end;
        }
        field(50001; "Variant Code"; Code[50])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code;

            trigger OnValidate()
            begin
                //Normatica 2012.10.24 - para atualizar o cod variante na tabela distribute by entity
                if ("Variant Code" <> '') and ("Variant Code" <> xRec."Variant Code") then
                    Validate(Selected, Selected);
            end;
        }
    }

    keys
    {
        key(Key1; "Student No.", "School Year", "Schooling Year", "Service Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Student No.", Selected)
        {
        }
        key(Key3; "Student No.", Selected, "Service Code")
        {
        }
        key(Key4; "Service Code", "Student No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rStudentLedgerEntry: Record "Student Ledger Entry";
    begin
        //Normatica - 2012.10.24 - só pode apagar se não estiver selecionado, pois não estado selecionado não existe na tabela
        //Distribute by entity

        if Selected = true then
            Error(Text0005);

        rStudentLedgerEntry.Reset;
        rStudentLedgerEntry.SetRange(rStudentLedgerEntry."Student No.", "Student No.");
        rStudentLedgerEntry.SetRange(rStudentLedgerEntry."School Year", "School Year");
        rStudentLedgerEntry.SetRange(rStudentLedgerEntry."Service Code", "Service Code");
        if rStudentLedgerEntry.FindFirst then
            Error(Text0006);
    end;

    trigger OnInsert()
    begin
        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", "Student No.");
        rRegistration.SetRange("School Year", "School Year");
        rRegistration.SetRange("Schooling Year", "Schooling Year");
        if rRegistration.FindFirst then
            "Services Plan Code" := rRegistration."Services Plan Code";


        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "User ID" := UserId;
    end;

    var
        ServicesET: Record "Services ET";
        rRegistration: Record Registration;
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        RespCenter: Record "Responsibility Center";
        recItem: Record Item;
        Text0005: Label 'Não pode apagar. Primeiro retire o selecionado.';
        Text0006: Label 'Não pode apagar, pois este Serviço/Produto já foi processado e/ou faturado anteriormente.';

    local procedure GetService()
    begin
        TestField("Service Code");
        if "Service Code" <> ServicesET."No." then;
    end;

    //[Scope('OnPrem')]
    procedure UpdateDist()
    var
        varTotal: Decimal;
        varLast: Decimal;
        ServDistribEntity: Record "Services Distributed by Entity";
    begin
        Clear(varTotal);
        ServDistribEntity.Reset;
        ServDistribEntity.SetRange("School Year", "School Year");
        ServDistribEntity.SetRange("Student No.", "Student No.");
        ServDistribEntity.SetRange("Service Code", "Service Code");
        if ServDistribEntity.Find('-') then begin
            repeat
                varTotal += ServDistribEntity."Percent %";
            until ServDistribEntity.Next = 0;
            if varTotal <> 100 then begin
                varLast := 100 - varTotal;
                ServDistribEntity."Percent %" := ServDistribEntity."Percent %" + varLast;
                ServDistribEntity.Modify;
            end;
        end;
    end;
}

