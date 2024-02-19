#pragma implicitwith disable
page 31009892 "Transport List"
{
    Caption = 'Transport List';
    CardPageID = "Transport Card";
    PageType = List;
    SourceTable = Transport;
    SourceTableView = WHERE(Type = FILTER(Header));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Transport No."; Rec."Transport No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("License plate"; Rec."License plate")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
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

