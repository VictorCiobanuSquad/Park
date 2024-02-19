#pragma implicitwith disable
page 31009859 "Timetable Template List"
{
    Caption = 'Timetable Template List';
    CardPageID = "TimeTable Template Card";
    PageType = List;
    SourceTable = "Template Timetable";
    SourceTableView = WHERE(Type = CONST(Header));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Template Description"; Rec."Template Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
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
            group("Ti&metable Template")
            {
                Caption = 'Ti&metable Template';
                Image = WorkCenterCalendar;
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"TimeTable Template Card", Rec);
                    end;
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

