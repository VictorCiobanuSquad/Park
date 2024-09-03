#pragma implicitwith disable
page 50031 "Portal User"
{
    Caption = 'Portal Users';
    AdditionalSearchTerms = 'multilanguage';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Portal User";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("User Id"; Rec.UserID)
                {
                    ApplicationArea = All;
                }
                field("User Type"; Rec.UserType)
                {
                    ApplicationArea = All;
                }

                field("Last Pass Date"; Rec.LastPassDate)
                {
                    ApplicationArea = All;
                }
                field(Salt; Rec.Salt)
                {
                    ApplicationArea = All;
                }
                field(Pass; Rec.Pass)
                {
                    ApplicationArea = All;
                }
                field("Recover GUID"; Rec.RecoverGUID)
                {
                    ApplicationArea = All;
                }
                field("Recover Date"; Rec.RecoverDate)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field(State; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}
#pragma implicitwith restore
