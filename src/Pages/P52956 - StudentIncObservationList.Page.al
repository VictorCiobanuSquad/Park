#pragma implicitwith disable
page 52956 "Student Inc. Observation List"
{
    Caption = 'Observation List';
    CardPageID = "Observation Header";
    PageType = List;
    SourceTable = Observation;
    SourceTableView = WHERE("Line Type" = FILTER(Cab),
                            "Observation Type" = CONST("Incidence Student"));

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
                action("Card")
                {
                    ApplicationArea = All;
                    Caption = 'Card';
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

    trigger OnInit()
    begin
        ObservationFuncionEnable := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then
            FilterText := rSchoolYear."School Year";

        rSchoolYear.SetRange(Status, rSchoolYear.Status::Planning);
        if rSchoolYear.Find('-') then
            if FilterText = '' then
                FilterText := rSchoolYear."School Year"
            else
                FilterText := FilterText + '|' + rSchoolYear."School Year";

        Rec.SetFilter("School Year", FilterText);

        Rec.FilterGroup(0);

        if CurrPage.LookupMode then
            ObservationFuncionEnable := false;
    end;

    var
        rSchoolYear: Record "School Year";
        FilterText: Text[100];
        [InDataSet]
        ObservationFuncionEnable: Boolean;
}

#pragma implicitwith restore

