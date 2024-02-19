#pragma implicitwith disable
page 31009970 "Calendar Base"
{
    Caption = 'Calendar Base';
    PageType = Card;
    SourceTable = "Base Calendar ChangeEDU";
    SourceTableView = ORDER(Ascending)
                      WHERE(Type = FILTER(Header));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    NotBlank = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(BaseCalendarEntries; "Calendar Base Line")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Maintain Base Calendar Changes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Maintain Base Calendar Changes';
                    Image = CalendarChanged;
                    RunObject = Page "Calendar Changes";
                    RunPageLink = "Base Calendar Code" = FIELD("Base Calendar Code"),
                                  Type = FILTER(Lines);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.BaseCalendarEntries.PAGE.SetCalendarCode(Rec."Base Calendar Code");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Header;
    end;
}

#pragma implicitwith restore

