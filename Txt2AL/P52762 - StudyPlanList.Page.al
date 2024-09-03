#pragma implicitwith disable
page 52762 "Study Plan List"
{
    Caption = 'Study Plan List';
    CardPageID = "Study Plan Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Study Plan Header";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        PlanoEstudosEnable := true;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        if CurrPage.LookupMode then
            PlanoEstudosEnable := false;

        Rec.SetRange(Blocked, false);
    end;

    var
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";
        [InDataSet]
        PlanoEstudosEnable: Boolean;
}

#pragma implicitwith restore

