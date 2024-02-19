#pragma implicitwith disable
page 31009973 "Calendar Base List"
{
    Caption = 'Calendar Base List';
    CardPageID = "Calendar Base";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Base Calendar ChangeEDU";
    SourceTableView = ORDER(Ascending)
                      WHERE(Type = FILTER(Header));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Base Calendar")
            {
                Caption = '&Base Calendar';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Calendar Base", Rec);
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("&Base Calendar Changes")
                {
                    Caption = '&Base Calendar Changes';
                    Image = ChangeDate;
                    RunObject = Page "Calendar Changes";
                    RunPageLink = "Base Calendar Code" = FIELD("Base Calendar Code"),
                                  Type = FILTER(Lines);
                }
            }
        }
    }
}

#pragma implicitwith restore

