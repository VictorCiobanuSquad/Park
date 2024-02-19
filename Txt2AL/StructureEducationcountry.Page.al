#pragma implicitwith disable
page 31009764 "Structure Education country"
{
    Caption = 'Structure Education country';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Structure Education Country";
    SourceTableView = SORTING("Sorting ID");

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Edu. Level"; Rec."Edu. Level")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Education Level"; Rec."Education Level")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                }
                field("Sorting ID"; Rec."Sorting ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Type"; Rec."Absence Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Granule; Rec.Granule)
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

#pragma implicitwith restore

