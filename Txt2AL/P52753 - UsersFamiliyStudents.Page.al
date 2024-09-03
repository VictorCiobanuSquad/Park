#pragma implicitwith disable
page 52753 "Users Family / Students"
{
    Caption = 'Users Family / Students';
    PageType = ListPart;
    SourceTable = "Users Family / Students";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Kinship; Rec.Kinship)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mobile Phone"; Rec."Mobile Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Education Head"; Rec."Education Head")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        EducationHeadOnPush;
                    end;
                }
                field("Paying Entity"; Rec."Paying Entity")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        PayingEntityOnPush;
                    end;
                }
                field("User Family Address"; Rec."User Family Address")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        UserFamilyAddressOnPush;
                    end;
                }
                field("Send By Email"; Rec."Send By Email")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteBooleans;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ModifyBooleans;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then
            Rec."School Year" := rSchoolYear."School Year";

        //"Student Code No." := varStudentCode; //2016.08.24 - Comentei porque não estava a deixar escolher o associado
    end;

    var
        rSchoolYear: Record "School Year";
        cStudentServices: Codeunit "Student Services";
        Text001: Label 'Cannot change or delete while the fields %1 and %2 are marked.\Please remove all marks on those fields and then proceed to their change or removal.';
        VarSchoolYear: Code[9];
        varStudentCode: Code[20];

    //[Scope('OnPrem')]
    procedure ModifyBooleans()
    begin
        if ((xRec.Kinship <> Rec.Kinship) or (Rec."No." <> xRec."No.")) then
            if ((not Rec."Education Head") and (not Rec."Paying Entity")) then begin
                if (xRec.Kinship <> Rec.Kinship) then begin
                    Rec."No." := '';
                    Rec.Name := '';
                    Rec.Address := '';
                    Rec."Phone No." := '';
                    Rec."Mobile Phone" := '';
                end;
            end else
                Error(Text001, Rec.FieldCaption("Education Head"), Rec.FieldCaption("Paying Entity"));
    end;

    //[Scope('OnPrem')]
    procedure DeleteBooleans()
    begin
        if (Rec."Education Head") or (Rec."Paying Entity") then
            Error(Text001, Rec.FieldCaption("Education Head"), Rec.FieldCaption("Paying Entity"));
    end;

    //[Scope('OnPrem')]
    procedure FormUpdate()
    begin
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetOldSchoolYear(pSchoolYear: Code[9])
    begin
        VarSchoolYear := pSchoolYear
    end;

    //[Scope('OnPrem')]
    procedure GetStudentCode(pStudentCode: Code[20])
    begin
        varStudentCode := pStudentCode;
    end;

    local procedure EducationHeadOnPush()
    begin
        CurrPage.SaveRecord;
    end;

    local procedure PayingEntityOnPush()
    begin
        CurrPage.SaveRecord;
        cStudentServices.DistributionByEntity(Rec);
    end;

    local procedure UserFamilyAddressOnPush()
    begin
        CurrPage.SaveRecord;
    end;
}

#pragma implicitwith restore

