#pragma implicitwith disable
page 31009888 "Non lective component List"
{
    Caption = 'Non lective component';
    Editable = false;
    PageType = List;
    SourceTable = Subjects;
    SourceTableView = WHERE(Type = FILTER("Non scholar component"));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Abbreviation Description"; Rec."Abbreviation Description")
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

