table 52751 "School Year"
{
    Caption = 'School Year';
    LookupPageID = "School Year";

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
        }
        field(2; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Planning,Active,Closing,Closed';
            OptionMembers = " ",Planning,Active,Closing,Closed;

            trigger OnValidate()
            begin
                if (Status = Status::Active) or (Status = Status::Planning) or (Status = Status::Closing) then
                    ValidateStatus(Status);
            end;
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(4; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
    }

    keys
    {
        key(Key1; "School Year")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rSchoolYear: Record "School Year";
        Text001: Label 'The chosen status is not possible. There is a year %1 with the same Status.';
        Text002: Label 'Cannot change to %1.';
        Text003: Label 'Do you want to change state %1 for %2. After the alteration you will not be able to undo this action.';
        Text004: Label 'Cannot Change to the same or to a previous status.';
        varStatusInt: Integer;
        varpStatusInt: Integer;

    //[Scope('OnPrem')]
    procedure ValidateStatus(pStatus: Option " ",Planning,Active,Closing,Closed)
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, pStatus);
        if rSchoolYear.FindFirst then
            Error(Text001, rSchoolYear."School Year");
    end;

    //[Scope('OnPrem')]
    procedure ChangeStatus(pStatus: Option " ",Planning,Active,Closing,Closed)
    var
        TempSchoolYear: Record "School Year" temporary;
    begin

        if Status = Status::Closed then
            Error(Text002, Status);

        varStatusInt := Status;
        varpStatusInt := pStatus;


        if varpStatusInt <= varStatusInt then
            Error(Text004);

        TempSchoolYear.Status := pStatus;

        if Confirm(Text003, false, Status, Format(TempSchoolYear.Status, 0, '<text>')) then begin
            Validate(Status, pStatus);
            Modify;
        end;
    end;
}

