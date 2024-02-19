#pragma implicitwith disable
page 31009958 "Vehicle Lines"
{
    Caption = 'Linhas Transporte';
    PageType = ListPart;
    SourceTable = Transport;
    SourceTableView = SORTING("Estimated Hour")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rTransport.Reset;
        rTransport.SetRange(Type, rTransport.Type::Lines);
        rTransport.SetRange("Transport No.", Rec."Transport No.");
        //rTransport.SETRANGE("Responsibility Center","Responsibility Center");
        if rTransport.FindLast then
            Rec."Line No." := rTransport."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

    var
        rTransport: Record Transport;
}

#pragma implicitwith restore

