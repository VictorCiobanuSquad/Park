#pragma implicitwith disable
page 52953 "Observation Subform"
{
    Caption = 'Observation Subform';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Observation;
    SourceTableView = SORTING(Code, "School Year", "Observation Type", "Line Type", "Line No.")
                      WHERE("Line Type" = FILTER(Line));

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Description Male"; Rec."Description Male")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Description MaleVisible";
                }
                field("Description Female"; Rec."Description Female")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Description FemaleVisible";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Next)
            {
                ApplicationArea = Basic, Suite;
                Image = NextRecord;
                InFooterBar = true;
            }
            action(Back)
            {
                ApplicationArea = Basic, Suite;
                Image = PreviousRecord;
                InFooterBar = true;
            }
        }
    }

    trigger OnInit()
    begin
        "Description MaleVisible" := true;
        "Description FemaleVisible" := true;
    end;

    var
        [InDataSet]
        "Description FemaleVisible": Boolean;
        [InDataSet]
        "Description MaleVisible": Boolean;

    //[Scope('OnPrem')]
    procedure SetSex(IsMale: Boolean)
    begin
        if IsMale then begin
            "Description FemaleVisible" := false;
            "Description MaleVisible" := true;
        end else begin
            "Description FemaleVisible" := true;
            "Description MaleVisible" := false;
        end;
    end;

    //[Scope('OnPrem')]
    procedure SetFormFilters(pCode: Code[20]; pSchoolYear: Code[20]; pObservationType: Integer)
    begin
        Rec.SetRange(Code, pCode);
        Rec.SetRange("School Year", pSchoolYear);
        Rec.SetRange("Observation Type", pObservationType);
    end;

    //[Scope('OnPrem')]
    procedure GetFormRecord(var pObservation: Record Observation)
    var
        lObservation: Record Observation;
    begin
        lObservation.Copy(Rec);
        CurrPage.SetSelectionFilter(Rec);

        pObservation.Copy(Rec);
        Rec.Copy(lObservation);
    end;

    //[Scope('OnPrem')]
    procedure Updateform()
    begin
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

