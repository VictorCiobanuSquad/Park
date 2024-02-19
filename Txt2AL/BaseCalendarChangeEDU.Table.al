table 31009800 "Base Calendar ChangeEDU"
{
    Caption = 'Base Calendar Change';
    LookupPageID = "Calendar Base List";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Lines';
            OptionMembers = Header,Lines;
        }
        field(2; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            NotBlank = true;
        }
        field(4; "Recurring System"; Option)
        {
            Caption = 'Recurring System';
            OptionCaption = ' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";

            trigger OnValidate()
            begin
                if Type = Type::Lines then begin
                    if "Recurring System" <> xRec."Recurring System" then
                        case "Recurring System" of
                            "Recurring System"::"Annual Recurring":
                                Day := Day::" ";
                            "Recurring System"::"Weekly Recurring":
                                Date := 0D;
                        end;

                end;
            end;
        }
        field(5; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            begin
                if Type = Type::Lines then begin
                    if ("Recurring System" = "Recurring System"::" ") or
                       ("Recurring System" = "Recurring System"::"Annual Recurring")
                    then
                        TestField(Date)
                    else
                        TestField(Date, 0D);
                    UpdateDayName;
                end;
            end;
        }
        field(6; Day; Option)
        {
            Caption = 'Day';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate()
            begin
                if Type = Type::Lines then begin
                    if "Recurring System" = "Recurring System"::"Weekly Recurring" then
                        TestField(Day);
                    UpdateDayName;
                end;
            end;
        }
        field(7; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(8; Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Base Calendar Code", "Recurring System", Date, Day, Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CheckEntryLine;
    end;

    trigger OnModify()
    begin
        CheckEntryLine;
    end;

    trigger OnRename()
    begin
        CheckEntryLine;
    end;

    //[Scope('OnPrem')]
    procedure UpdateDayName()
    var
        DateTable: Record Date;
    begin
        if (Date > 0D) and
           ("Recurring System" = "Recurring System"::"Annual Recurring") then
            Day := Day::" "
        else begin
            DateTable.SetRange("Period Type", DateTable."Period Type"::Date);
            DateTable.SetRange("Period Start", Date);
            if DateTable.Find('-') then
                Day := DateTable."Period No.";
        end;
        if (Date = 0D) and (Day = Day::" ") then begin
            Day := xRec.Day;
            Date := xRec.Date;
        end;
        if "Recurring System" = "Recurring System"::"Annual Recurring" then
            TestField(Day, Day::" ");
    end;

    //[Scope('OnPrem')]
    procedure CheckEntryLine()
    begin
        if Type = Type::Lines then begin
            case "Recurring System" of
                "Recurring System"::" ":
                    begin
                        TestField(Date);
                        TestField(Day);
                    end;
                "Recurring System"::"Annual Recurring":
                    begin
                        TestField(Date);
                        TestField(Day, Day::" ");
                    end;

                "Recurring System"::"Weekly Recurring":
                    begin
                        TestField(Date, 0D);
                        TestField(Day);
                    end;
            end;
        end;
    end;
}

