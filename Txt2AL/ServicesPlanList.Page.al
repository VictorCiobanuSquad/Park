#pragma implicitwith disable
page 31009773 "Services Plan List"
{
    Caption = 'Services Plan List';
    CardPageID = "Services Plan Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Services Plan Head";

    layout
    {
        area(content)
        {
            repeater(Control1102059000)
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
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan Code';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Planos ServiçosEnable" := true;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;


        if CurrPage.LookupMode then
            "Planos ServiçosEnable" := false;
    end;

    var
        cUserEducation: Codeunit "User Education";
        [InDataSet]
        "Planos ServiçosEnable": Boolean;
}

#pragma implicitwith restore

