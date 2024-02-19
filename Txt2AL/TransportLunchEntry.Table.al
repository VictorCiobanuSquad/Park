table 31009851 "Transport & Lunch Entry "
{
    Caption = 'Transport & Lunch Entry ';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Driver Absence,Student Transport,Transport Alteration,Student Lunch';
            OptionMembers = " ","Driver Absence","Student Transport","Transport Alteration","Student Lunch";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Transport No."; Code[20])
        {
            Caption = 'Transport No.';
            TableRelation = Transport."Transport No.";
        }
        field(5; "License Plate"; Text[10])
        {
            Caption = 'License Plate';
        }
        field(6; Driver; Text[30])
        {
            Caption = 'Driver';
        }
        field(8; "Collect Time"; Time)
        {
            Caption = 'Collect Time';
        }
        field(9; "Deliver Transport"; Code[20])
        {
            Caption = 'Deliver Transport';
            TableRelation = Transport."Transport No.";
        }
        field(10; "Collect Transport"; Code[20])
        {
            Caption = 'Collect Transport';
            TableRelation = Transport."Transport No." WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(11; "Deliver Time"; Time)
        {
            Caption = 'Deliver Time';
        }
        field(12; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            TableRelation = Students."No.";

            trigger OnValidate()
            begin
                if rStudents.Get("Student No.") then
                    "Student Name" := rStudents."Short Name";
            end;
        }
        field(13; "Student Name"; Text[50])
        {
            Caption = 'Student Name';
        }
        field(14; "New Driver"; Text[30])
        {
            Caption = 'New Driver';
        }
        field(15; "New Transport"; Code[20])
        {
            Caption = 'New Transport';
            TableRelation = Transport."Transport No.";
        }
        field(18; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(19; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(20; "Absence Day"; Date)
        {
            Caption = 'Absence Day';
        }
        field(21; "Lunch Cancelled"; Boolean)
        {
            Caption = 'Lunch Cancelled';
        }
        field(22; "Transports Absence"; Option)
        {
            Caption = 'Transports Absence';
            OptionCaption = 'Both,Collect,Deliver';
            OptionMembers = Both,Collect,Deliver;
        }
        field(23; "Transport Collect Cancelled"; Boolean)
        {
            Caption = 'Collect Transport Cancelled';
        }
        field(24; "Transport Deliver Cancelled"; Boolean)
        {
            Caption = 'Deliver Transport Cancelled';
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
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Collect Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    var
        rStudents: Record Students;
        rUserSetup: Record "User Setup";
}

