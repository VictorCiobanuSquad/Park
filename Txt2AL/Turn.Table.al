table 31009820 Turn
{
    Caption = 'Turn';
    LookupPageID = "Turn List";
    Permissions = TableData Absence = rimd,
                  TableData "Student Subjects Entry" = rimd,
                  TableData "WEB Absence" = rimd,
                  TableData GeneralTable = rimd,
                  TableData MasterTableWEB = rimd,
                  TableData "Web Calendar" = rimd;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Responsibility Center"; Code[10])
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
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code", "Responsibility Center")
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
            //Tab - Student Sub-Subjects Plan
            rStudentSubSubjectsPlan.Reset;
            rStudentSubSubjectsPlan.SetRange(rStudentSubSubjectsPlan.Turn, Code);
            if rStudentSubSubjectsPlan.FindFirst then
                Error(Text0001);
            //Tab- Registration Subjects
            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange(rRegistrationSubjects.Turn, Code);
            if rRegistrationSubjects.FindFirst then
                Error(Text0001);
        end;

        cInsertNAVMasterTable.DeleteTurn(Rec);
    end;

    trigger OnInsert()
    begin
        if Code = '' then
            TestField(Code);

        if rUserSetup.Get(UserId) then begin
            if "Responsibility Center" = '' then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
        end;

        cInsertNAVMasterTable.InsertTurn(Rec);
    end;

    trigger OnModify()
    begin
        cInsertNAVMasterTable.ModifyTurn(Rec);
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
        Error(Text0002,TableCaption)*/
    end;

    var
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rRegistrationSubjects: Record "Registration Subjects";
        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        Text0001: Label 'The turn is already appointed and therefore cannot be deleted.';
        rUserSetup: Record "User Setup";
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        Text0002: Label 'You cannot rename a %1.';
        rCompanyInformation: Record "Company Information";
}

