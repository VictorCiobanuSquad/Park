#pragma implicitwith disable
page 52774 "Reg.Family/Students"
{
    Caption = 'Users Family / Students';
    DelayedInsert = true;
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
                }
                field("Paying Entity"; Rec."Paying Entity")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        PayingEntityOnPush;
                    end;
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

    var
        rSchoolYear: Record "School Year";
        Text001: Label 'Cannot change or eliminate the active fields %1 and %2.\Please remove the marks on those fields and proceed to their change or removal.';
        cStudentServices: Codeunit "Student Services";


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


    procedure DeleteBooleans()
    begin
        if (Rec."Education Head") or (Rec."Paying Entity") then
            Error(Text001, Rec.FieldCaption("Education Head"), Rec.FieldCaption("Paying Entity"));
    end;

    local procedure PayingEntityOnPush()
    begin
        CurrPage.SaveRecord;
        cStudentServices.DistributionByEntity(Rec);
    end;
}

#pragma implicitwith restore

