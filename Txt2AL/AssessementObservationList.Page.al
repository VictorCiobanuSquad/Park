#pragma implicitwith disable
page 31009924 "Assessement Observation List"
{
    Caption = 'Observation List';
    CardPageID = "Observation Header";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Observation;
    SourceTableView = WHERE("Line Type" = FILTER(Cab),
                            "Observation Type" = CONST(Assessement));

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
                field(Descripton; Rec.Descripton)
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
            group(ObservationFuncion)
            {
                Caption = '&Observation';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Observation Header", Rec);
                    end;
                }
            }
        }
    }

    var
        FilterText: Text[100];
}

#pragma implicitwith restore

