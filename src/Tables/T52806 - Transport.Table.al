table 52806 Transport
{
    Caption = 'Transport';
    DrillDownPageID = "Vehicle Lines";
    LookupPageID = "Transport List";

    fields
    {
        field(1; "Transport No."; Code[20])
        {
            Caption = 'Transport No.';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "License plate"; Text[10])
        {
            Caption = 'License plate';
        }
        field(4; Driver; Text[30])
        {
            Caption = 'Driver';
        }
        field(5; Vendor; Text[30])
        {
            Caption = 'Vendor';
        }
        field(6; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(7; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; Picture; BLOB)
        {
            Caption = 'Picture';
        }
        field(9; "Responsibility Center"; Code[10])
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
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Lines';
            OptionMembers = Header,Lines;
        }
        field(11; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(12; "Stop Address"; Text[50])
        {
            Caption = 'Stop Address';
        }
        field(13; "Stop Address 2"; Text[50])
        {
            Caption = 'Stop Address 2';
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                tempCounty: Code[20];
            begin
                //PostCode.LookUpPostCode(Location,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(Location,"Post Code");
            end;
        }
        field(15; Location; Text[30])
        {
            Caption = 'Location';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(Location,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(Location,"Post Code");
            end;
        }
        field(16; County; Text[100])
        {
            Caption = 'County';
            Editable = false;
        }
        field(17; "Estimated Hour"; Time)
        {
            Caption = 'Estimated Hour';
        }
        field(18; "Number of Stops"; Integer)
        {
            CalcFormula = Count(Transport WHERE(Type = FILTER(Lines),
                                                 "Responsibility Center" = FIELD("Responsibility Center"),
                                                 "Transport No." = FIELD("Transport No.")));
            Caption = 'Number of Stops';
            FieldClass = FlowField;
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
        key(Key1; Type, "Transport No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Estimated Hour")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Type = Type::Header then begin
            rVehicle.Reset;
            rVehicle.SetRange(Type, rVehicle.Type::Lines);
            rVehicle.SetRange("Transport No.", "Transport No.");
            rVehicle.SetRange("Responsibility Center", "Responsibility Center");
            rVehicle.DeleteAll;
        end;


        /*
        rVehicleEntry.RESET;
        rVehicleEntry.SETRANGE("Vehicle No.","Vehicle No.");
        IF rVehicleEntry.FIND('-') THEN
           ERROR(Text0002);
         */

    end;

    trigger OnInsert()
    begin
        if "Transport No." = '' then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Transport Nos.");
            //NoSeriesMgt.InitSeries(rEduConfiguration."Transport Nos.", xRec."No. Series", 0D, "Transport No.", "No. Series");
            //TODO: to test NoSeries
            if CU_NoSeries.AreRelated(rEduConfiguration."Users Family Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Transport No." := CU_NoSeries.GetNextNo("No. Series");
        end;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0001: Label 'Vehicle already has an attached route. ';
        rUserSetup: Record "User Setup";
        Text0002: Label 'Cannot delete a vehicle which already has an entry.';
        PostCode: Record "Post Code";
        rVehicle: Record Transport;

    //[Scope('OnPrem')]
    procedure AssistEdit(OldStudyPlanHeader: Record Transport): Boolean
    var
        Vehicle: Record Transport;
    begin
        Vehicle := Rec;
        if rEduConfiguration.Get then;
        rEduConfiguration.TestField("Transport Nos.");
        //if NoSeriesMgt.SelectSeries(rEduConfiguration."Transport Nos.", OldStudyPlanHeader."No. Series", "No. Series") then begin
        //NoSeriesMgt.SetSeries("Transport No.");
        if CU_NoSeries.LookupRelatedNoSeries(OldStudyPlanHeader."No. Series", rEduConfiguration."Transport Nos.", "No. Series") then begin
            CU_NoSeries.GetNextNo("Transport No.");
            //TODO: to test NoSeries
            Rec := Vehicle;
            exit(true);
        end;
    end;
}

