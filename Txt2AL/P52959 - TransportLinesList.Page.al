#pragma implicitwith disable
page 52959 "Transport Lines List"
{
    Caption = 'Stop List';
    PageType = List;
    SourceTable = Transport;
    SourceTableView = SORTING(Type, "Transport No.", "Line No.")
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Lines));

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                Editable = false;
                ShowCaption = false;
                field("Estimated Hour"; Rec."Estimated Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Stop Address"; Rec."Stop Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Stop Address 2"; Rec."Stop Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(County; Rec.County)
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

