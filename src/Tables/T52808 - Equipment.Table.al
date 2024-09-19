table 52808 Equipment
{
    Caption = 'Equipment';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Single,Group';
            OptionMembers = " ",Single,Group;
        }
        field(2; "Equipment No."; Code[20])
        {
            Caption = 'Equipment No.';
        }
        field(3; "Equipment Group"; Code[20])
        {
            Caption = 'Equipment Group';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; Quantity; Integer)
        {
            BlankZero = true;
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Quantity < 0 then
                    Error(text0003);

                if ("Equipment Group" <> '') and (Type = Type::Single) then begin
                    rEquipment.Reset;
                    rEquipment.SetRange("Equipment No.", "Equipment No.");
                    rEquipment.SetRange(Type, Type::Single);
                    rEquipment.SetRange("Equipment Group", '');
                    if rEquipment.FindFirst then begin
                        rEquipmentGroup.Reset;
                        rEquipmentGroup.SetRange("Equipment No.", '');
                        rEquipmentGroup.SetRange(Type, Type::Group);
                        rEquipmentGroup.SetRange("Equipment Group", "Equipment Group");
                        if rEquipmentGroup.FindFirst then begin
                            if Quantity < xRec.Quantity then
                                rEquipment.Quantity := rEquipment.Quantity + ((xRec.Quantity - Quantity) * rEquipmentGroup.Quantity);
                            if Quantity > xRec.Quantity then
                                rEquipment.Quantity := rEquipment.Quantity - ((Quantity - xRec.Quantity) * rEquipmentGroup.Quantity);
                            if rEquipment.Quantity < 0 then
                                Error(text0003);
                            rEquipment.Modify;
                        end;
                    end;
                end;
                if ("Equipment Group" <> '') and (Type = Type::Group) then begin
                    rEquipmentGroup.Reset;
                    rEquipmentGroup.SetRange(Type, Type::Single);
                    rEquipmentGroup.SetRange("Equipment Group", "Equipment Group");
                    if rEquipmentGroup.FindSet then begin
                        repeat
                            rEquipmentLineGroup.Reset;
                            rEquipmentLineGroup.SetRange("Equipment No.", rEquipmentGroup."Equipment No.");
                            rEquipmentLineGroup.SetRange(Type, Type::Single);
                            rEquipmentLineGroup.SetRange("Equipment Group", rEquipmentGroup."Equipment Group");
                            if rEquipmentLineGroup.FindFirst then begin
                                rEquipment.Reset;
                                rEquipment.SetRange("Equipment No.", rEquipmentLineGroup."Equipment No.");
                                rEquipment.SetRange(Type, Type::Single);
                                rEquipment.SetRange("Equipment Group", '');
                                if rEquipment.FindFirst then begin
                                    if Quantity < xRec.Quantity then
                                        rEquipment.Quantity := rEquipment.Quantity + ((rEquipmentLineGroup.Quantity * xRec.Quantity)
                                                               - (rEquipmentLineGroup.Quantity * Quantity));
                                    if Quantity > xRec.Quantity then
                                        rEquipment.Quantity := rEquipment.Quantity - ((rEquipmentLineGroup.Quantity * Quantity)
                                                               - (rEquipmentLineGroup.Quantity * xRec.Quantity));
                                    if rEquipment.Quantity < 0 then
                                        Error(text0003);
                                    rEquipment.Modify;
                                end;
                            end;
                        until rEquipmentGroup.Next = 0;
                    end;
                end;
            end;
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
    }

    keys
    {
        key(Key1; Type, "Equipment No.", "Equipment Group", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ("Equipment Group" = '') and (Type = Type::Single) then begin
            rEquipmentEntry.Reset;
            rEquipmentEntry.SetRange("Equipment Type", Type::Single);
            rEquipmentEntry.SetRange("Equipment Code", "Equipment No.");
            if rEquipmentEntry.FindFirst then
                Error(text0002);
        end;
        if ("Equipment Group" <> '') and (Type = Type::Group) then begin
            rEquipmentEntry.Reset;
            rEquipmentEntry.SetRange("Equipment Type", Type::Group);
            rEquipmentEntry.SetRange("Equipment Code", "Equipment Group");
            if rEquipmentEntry.FindFirst then
                Error(text0002);
        end;

        if ("Equipment Group" = '') and (Type = Type::Single) then begin
            rEquipmentLineGroup.Reset;
            rEquipmentLineGroup.SetRange("Equipment No.", "Equipment No.");
            rEquipmentLineGroup.SetRange(Type, Type::Single);
            rEquipmentLineGroup.SetFilter("Equipment Group", '<>%1', '');
            if rEquipmentLineGroup.FindFirst then
                Error(text0005);
        end;
        if ("Equipment Group" <> '') and (Type = Type::Single) then begin
            rEquipmentLineGroup.Reset;
            rEquipmentLineGroup.SetRange("Equipment No.", "Equipment No.");
            rEquipmentLineGroup.SetRange(Type, Type::Single);
            rEquipmentLineGroup.SetFilter("Equipment Group", '<>%1', '');
            if rEquipmentLineGroup.FindFirst then begin
                rEquipment.Reset;
                rEquipment.SetRange("Equipment No.", "Equipment No.");
                rEquipment.SetRange(Type, Type::Single);
                rEquipment.SetRange("Equipment Group", '');
                if rEquipment.FindFirst then begin
                    rEquipmentGroup.Reset;
                    rEquipmentGroup.SetRange("Equipment Group", rEquipmentLineGroup."Equipment Group");
                    rEquipmentGroup.SetFilter("Equipment No.", '=%1', '');
                    rEquipmentGroup.SetRange(Type, Type::Group);
                    if rEquipmentGroup.FindFirst then begin
                        rEquipment.Quantity := rEquipment.Quantity + (rEquipmentGroup.Quantity * rEquipmentLineGroup.Quantity);
                        rEquipment.Modify;
                    end;
                end;
            end;
        end;
    end;

    trigger OnInsert()
    begin
        if ("Equipment No." = '') and (Type = Type::Single) then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Equipment Nos.");
            //NoSeriesMgt.InitSeries(rEduConfiguration."Equipment Nos.", xRec."No. Series", 0D, "Equipment No.", "No. Series");
            //TODO: to test NoSeries
            if CU_NoSeries.AreRelated(rEduConfiguration."Equipment Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Equipment No." := CU_NoSeries.GetNextNo("No. Series");
        end;

        if ("Equipment No." = '') and (Type = Type::Group) then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Group Equipment Nos.");
            //NoSeriesMgt.InitSeries(rEduConfiguration."Group Equipment Nos.", xRec."No. Series", 0D, "Equipment Group", "No. Series");
            //TODO: to test NoSeries
            if CU_NoSeries.AreRelated(rEduConfiguration."Equipment Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Equipment No." := CU_NoSeries.GetNextNo("No. Series");
        end;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    trigger OnModify()
    begin
        if Quantity < 0 then
            Error(text0003);
        if xRec.Quantity <> Quantity then begin
            if xRec.Quantity < Quantity then begin
                rEquipmentEntry.Reset;
                rEquipmentEntry.SetRange(Type, Type);
                if Type = Type::Single then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment No.");
                if Type = Type::Group then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment Group");
                rEquipmentEntry.SetRange(Open, true);
                if rEquipmentEntry.FindLast then begin
                    rEquipmentEntry."Available Quantity" := (Quantity - xRec.Quantity) + rEquipmentEntry."Available Quantity";
                    rEquipmentEntry.Modify;
                end;
                rEquipmentEntry.Reset;
                rEquipmentEntry.SetRange(Type, Type);
                if Type = Type::Single then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment No.");
                if Type = Type::Group then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment Group");
                rEquipmentEntry.SetRange(Open, false);
                if rEquipmentEntry.FindLast then begin
                    rEquipmentEntry."Available Quantity" := (Quantity - xRec.Quantity) + rEquipmentEntry."Available Quantity";
                    rEquipmentEntry.Modify;
                end;
            end;
            if xRec.Quantity > Quantity then begin
                rEquipmentEntry.Reset;
                rEquipmentEntry.SetRange(Type, Type);
                if Type = Type::Single then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment No.");
                if Type = Type::Group then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment Group");
                rEquipmentEntry.SetRange(Open, true);
                if rEquipmentEntry.FindLast then begin
                    rEquipmentEntry."Available Quantity" := (Quantity - xRec.Quantity) + rEquipmentEntry."Available Quantity";
                    if rEquipmentEntry."Available Quantity" < 0 then
                        Error(text0006, rEquipmentEntry."Available Quantity");
                    rEquipmentEntry.Modify;
                end;

                rEquipmentEntry.Reset;
                rEquipmentEntry.SetRange(Type, Type);
                if Type = Type::Single then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment No.");
                if Type = Type::Group then
                    rEquipmentEntry.SetRange("Equipment Code", "Equipment Group");
                rEquipmentEntry.SetRange(Open, false);
                if rEquipmentEntry.FindLast then begin
                    rEquipmentEntry."Available Quantity" := (Quantity - xRec.Quantity) + rEquipmentEntry."Available Quantity";
                    if rEquipmentEntry."Available Quantity" < 0 then
                        Error(text0006, rEquipmentEntry."Available Quantity");
                    rEquipmentEntry.Modify;
                end;
            end;
        end;
    end;

    trigger OnRename()
    begin
        if (xRec."Equipment No." <> "Equipment No.") or (xRec."Equipment Group" <> "Equipment Group") then
            Error(text0001);
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        rEquipmentEntry: Record "Equipment Entry";
        rEquipment: Record Equipment;
        rEquipmentGroup: Record Equipment;
        rEquipmentLineGroup: Record Equipment;
        text0001: Label 'It is not allowed to change the Equipment Code or Group.';
        text0002: Label 'This equipment cannot be eliminated since it has a pending order.';
        text0003: Label 'The inserted value cannot be negative.';
        text0005: Label 'This equipment cannot be eliminated since it belongs to an equipment group.';
        text0006: Label 'There already exists an order for a quantity higher than %1.';

    //[Scope('OnPrem')]
    procedure AssistEdit(pEquipment: Record Equipment): Boolean
    var
        Equipment: Record Equipment;
    begin
        Equipment := pEquipment;
        if Type = Type::Single then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Equipment Nos.");
            //if NoSeriesMgt.SelectSeries(rEduConfiguration."Equipment Nos.", pEquipment."No. Series", "No. Series") then begin
            //NoSeriesMgt.SetSeries("Equipment No.");
            if CU_NoSeries.LookupRelatedNoSeries(pEquipment."No. Series", rEduConfiguration."Equipment Nos.", "No. Series") then begin
                CU_NoSeries.GetNextNo("Equipment No.");
                //TODO: to test NoSeries
                Rec := Equipment;
                exit(true);
            end;
        end else begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Group Equipment Nos.");
            //if NoSeriesMgt.SelectSeries(rEduConfiguration."Group Equipment Nos.", pEquipment."No. Series","No. Series") then begin
            //NoSeriesMgt.SetSeries("Equipment Group");
            if CU_NoSeries.LookupRelatedNoSeries(pEquipment."No. Series", rEduConfiguration."Group Equipment Nos.", "No. Series") then begin
                CU_NoSeries.GetNextNo("Equipment Group");
                //TODO: to test NoSeries
                Rec := Equipment;
                exit(true);
            end;

        end;
    end;
}

