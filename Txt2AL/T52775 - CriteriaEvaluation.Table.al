table 52775 "Criteria Evaluation"
{
    Caption = 'Criteria Evaluation';
    LookupPageID = "Criteria evaluation";

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
        }
        field(2; Description; Text[200])
        {
            Caption = 'Description';
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
        key(Key1; "No.", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;
}

