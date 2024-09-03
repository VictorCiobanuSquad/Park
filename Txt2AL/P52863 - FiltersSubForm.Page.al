page 52863 "Filters SubForm"
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
                field("Field No."; "Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field Caption"; "Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field Filter"; "Field Filter")
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

