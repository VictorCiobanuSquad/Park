page 52769 "Student Registration"
{
    Caption = 'Student Registration';
    InsertAllowed = false;
    PageType = CardPart;
    SourceTable = Students;

    layout
    {
        area(content)
        {
            group(Control1102065008)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Short Name"; Rec."Short Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1102065007)
            {
                ShowCaption = false;
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Nationality Code"; Rec."Nationality Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Local Birth Place"; Rec."Local Birth Place")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1102065006)
            {
                ShowCaption = false;
                field("Doc. Type Id"; Rec."Doc. Type Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Doc. Number Id"; Rec."Doc. Number Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Archive of Identification"; Rec."Archive of Identification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date Validity"; Rec."Date Validity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date of Issuance"; Rec."Date of Issuance")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}



