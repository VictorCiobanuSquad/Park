#pragma implicitwith disable
page 52809 "Users Family/Candidate"
{
    Caption = 'Users Family/Candidate';
    PageType = ListPart;
    SourceTable = "Users Family / Candidate";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Candidate Code No."; Rec."Candidate Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Candidate Code No.Visible";
                }
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
                }
                field("User Family Address"; Rec."User Family Address")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        UserFamilyAddressOnPush;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then begin
            "Candidate Code No.Visible" := true;
            CurrPage.Editable(false);
        end else
            "Candidate Code No.Visible" := false;
    end;

    var
        [InDataSet]
        "Candidate Code No.Visible": Boolean;

    local procedure UserFamilyAddressOnPush()
    begin
        CurrPage.SaveRecord;
    end;
}

#pragma implicitwith restore

