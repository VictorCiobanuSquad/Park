#pragma implicitwith disable
page 31009811 "Room List"
{
    Caption = 'Room List';
    CardPageID = "Room Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Room;

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Room Code"; Rec."Room Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Room Type"; Rec."Room Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Room Description"; Rec."Room Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Operational; Rec.Operational)
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
            group("&Room")
            {
                Caption = '&Room';
                Image = Home;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Room Card";
                    RunPageLink = "Room Code" = FIELD("Room Code");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
}

#pragma implicitwith restore

