#pragma implicitwith disable
page 31009965 "Annotation Subform"
{
    Caption = 'Annotation Subform';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Annotation;
    SourceTableView = SORTING("School Year", Code, "Line Type", "Line No.")
                      WHERE("Line Type" = CONST(Line));

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Annotation Description"; Rec."Annotation Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }

    //[Scope('OnPrem')]
    procedure SetFormFilters(pCode: Code[20]; pSchoolYear: Code[20]; pObservationType: Integer)
    begin
        Rec.SetRange(Code, pCode);
        Rec.SetRange("School Year", pSchoolYear);
    end;

    //[Scope('OnPrem')]
    procedure GetFormRecord(var pAnnotation: Record Annotation)
    var
        lAnnotation: Record Annotation;
    begin
        lAnnotation.Copy(Rec);
        CurrPage.SetSelectionFilter(Rec);

        pAnnotation.Copy(Rec);
        Rec.Copy(lAnnotation);
    end;

    //[Scope('OnPrem')]
    procedure Updateform()
    begin
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

