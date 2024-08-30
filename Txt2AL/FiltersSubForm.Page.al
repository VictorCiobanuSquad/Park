#pragma implicitwith disable
page 31009863 "Filters SubForm"
{
    Caption = 'Filters SubForm';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Save Filters";
    SourceTableView = SORTING(Type, "Filter Code", "Field No.")
                      WHERE(Type = CONST(Line));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field Filter"; Rec."Field Filter")
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

