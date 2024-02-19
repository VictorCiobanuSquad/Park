table 31009773 "Classification Level"
{
    Caption = 'Classification Level';
    DrillDownPageID = "Classification Level List";
    LookupPageID = "Classification Level List";
    Permissions = TableData MasterTableWEB = rimd;

    fields
    {
        field(1; "Classification Group Code"; Code[20])
        {
            Caption = 'Classification Group Code';
            TableRelation = "Rank Group".Code;
        }
        field(2; "Classification Level Code"; Code[20])
        {
            Caption = 'Classification Level Code';

            trigger OnValidate()
            var
                l_rMasterTableWEB: Record MasterTableWEB;
            begin
                exit;
                if ("Classification Level Code" <> '') and (xRec."Classification Level Code" <> '') then begin
                    l_rMasterTableWEB.Reset;
                    l_rMasterTableWEB.SetRange("Table Type", l_rMasterTableWEB."Table Type"::"Classification Level");
                    l_rMasterTableWEB.SetRange(ClassificationGroupCode, "Classification Group Code");
                    l_rMasterTableWEB.SetRange(ClassificationLevelCode, xRec."Classification Level Code");
                    if FindFirst then
                        Error(Text0020, TableCaption);
                end;
            end;
        }
        field(3; "Description Level"; Text[250])
        {
            Caption = 'Description Level';
        }
        field(4; "Id Ordination"; Integer)
        {
            Caption = 'Id Ordination';
        }
        field(5; "Min Value"; Decimal)
        {
            Caption = 'Min Value';
        }
        field(6; "Max Value"; Decimal)
        {
            Caption = 'Max Value';
        }
        field(7; Value; Decimal)
        {
            Caption = 'Value';
        }
        field(8; "Short Level Description"; Text[5])
        {
            Caption = 'Short Level Description';
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
        key(Key1; "Classification Group Code", "Classification Level Code")
        {
            Clustered = true;
        }
        key(Key2; "Id Ordination")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cMasterTableWEB.DeleteClassificationLevel(Rec, xRec);
    end;

    trigger OnInsert()
    begin
        exit;
        cMasterTableWEB.InsertClassificationLevel(Rec, xRec);

        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnModify()
    begin
        exit;
        cMasterTableWEB.ModifyClassificationLevel(Rec, xRec);
    end;

    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        Text0020: Label 'You cannot rename a %1.';
}

