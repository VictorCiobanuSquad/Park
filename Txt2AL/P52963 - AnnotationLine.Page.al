#pragma implicitwith disable
page 52963 "Annotation Line"
{
    AutoSplitKey = true;
    Caption = 'Annotation Line';
    PageType = ListPart;
    SourceTable = Annotation;
    SourceTableView = WHERE("Line Type" = FILTER(Line));

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
            {
                ShowCaption = false;
                field("Annotation Code"; Rec."Annotation Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Annotation Description"; Rec."Annotation Description")
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

