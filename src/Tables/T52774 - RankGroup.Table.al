table 52774 "Rank Group"
{
    Caption = 'Rank Group';
    LookupPageID = "Setting Evaluations List";
    Permissions = TableData MasterTableWEB = rimd;

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";

            trigger OnValidate()
            begin
                rClassificationLevel.Reset;
                rClassificationLevel.SetRange("Classification Group Code", Code);
                if rClassificationLevel.FindFirst then
                    Error(Text0002);
            end;
        }
        field(4; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD(Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                l_TempValue: Decimal;
            begin
            end;
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
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Code <> '' then begin
            rAspects.Reset;
            rAspects.SetRange(rAspects."Assessment Code", Code);
            if rAspects.FindFirst then
                Error(Text0001);
        end;

        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then begin
          r_MasterTableWEB.Reset;
          r_MasterTableWEB.SetRange("Table Type",r_MasterTableWEB."Table Type"::"Classification Level");
          r_MasterTableWEB.SetRange(ClassificationGroupCode,Code);
          if r_MasterTableWEB.FindFirst then
            Error(Text0001);
        end;*/

        rClassificationLevel.Reset;
        rClassificationLevel.SetRange("Classification Group Code", Code);
        rClassificationLevel.DeleteAll;
    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        Date := WorkDate;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
          Error(Text0020,TableCaption);*/
    end;

    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        rAspects: Record Aspects;
        Text0001: Label 'Cannot Be Deleted - Record Code already allocated';
        rClassificationLevel: Record "Classification Level";
        Text0002: Label 'Cannot change the Evaluation Type.';
        r_MasterTableWEB: Record MasterTableWEB;
        rCompanyInformation: Record "Company Information";
        Text0020: Label 'You cannot rename a %1.';
}

