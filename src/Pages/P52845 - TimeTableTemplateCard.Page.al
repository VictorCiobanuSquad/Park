#pragma implicitwith disable
page 52845 "TimeTable Template Card"
{
    Caption = 'Timetable Template Card';
    PageType = Card;
    SourceTable = "Template Timetable";

    layout
    {
        area(content)
        {
            group(Geral)
            {
                Caption = 'Geral';
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "School YearEditable";

                    trigger OnValidate()
                    begin
                        SchoolYearOnAfterValidate;
                    end;
                }
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Template CodeEditable";
                    Importance = Standard;
                }
                field("Template Description"; Rec."Template Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Template DescriptionEditable";
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Responsibility CenterEditable";
                }
            }
            part(SubFormLines; "Timetable Lines")
            {
                ApplicationArea = All;
                Editable = SubFormLinesEditable;
                SubPageLink = "School Year" = FIELD("School Year"),
                              "Template Code" = FIELD("Template Code"),
                              "Line Header" = FIELD("Line No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("&List")
            {
                ApplicationArea = All;
                Caption = '&List';
                Image = List;
                RunObject = Page "Timetable Template";
                ShortCutKey = 'F5';
            }
        }
        area(processing)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("&Copy")
                {
                    ApplicationArea = All;
                    Caption = '&Copy';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        repCopyTempTimetable.GETTempTimetable(Rec."School Year", Rec."Template Code");
                        repCopyTempTimetable.Run;
                        Clear(repCopyTempTimetable);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditableSchoolYear;
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        SubFormLinesEditable := true;
        "Responsibility CenterEditable" := true;
        "School YearEditable" := true;
        "Template DescriptionEditable" := true;
        "Template CodeEditable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ValidateTimetableCode;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    var
        repCopyTempTimetable: Report "Copy Temp Timetable";
        Text0001: Label 'Field %1 is empty.';
        Text0002: Label 'There is already a template code with the same name.';
        [InDataSet]
        "Template CodeEditable": Boolean;
        [InDataSet]
        "Template DescriptionEditable": Boolean;
        [InDataSet]
        "School YearEditable": Boolean;
        [InDataSet]
        "Responsibility CenterEditable": Boolean;
        [InDataSet]
        SubFormLinesEditable: Boolean;


    procedure ValidateTimetableCode()
    var
        l_TemplateTimetable: Record "Template Timetable";
    begin
        if Rec."Template Code" <> '' then begin
            l_TemplateTimetable.Reset;
            l_TemplateTimetable.SetRange("Template Code", Rec."Template Code");
            l_TemplateTimetable.SetFilter("Line No.", '<>%1', Rec."Line No.");
            l_TemplateTimetable.SetRange("School Year", Rec."School Year");
            if l_TemplateTimetable.FindFirst then
                Error(Text0002);
        end;
    end;


    procedure EditableSchoolYear()
    var
        l_SchoolYear: Record "School Year";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetRange("School Year", Rec."School Year");
        if l_SchoolYear.FindFirst then begin
            if (l_SchoolYear.Status = l_SchoolYear.Status::Closing) or (l_SchoolYear.Status = l_SchoolYear.Status::Closed) then begin
                "Template CodeEditable" := false;
                "Template DescriptionEditable" := false;
                "School YearEditable" := false;
                "Responsibility CenterEditable" := false;
                SubFormLinesEditable := false;
            end else begin
                "Template CodeEditable" := true;
                "Template DescriptionEditable" := true;
                "School YearEditable" := true;
                "Responsibility CenterEditable" := true;
                SubFormLinesEditable := true;
            end;
        end;
    end;

    local procedure SchoolYearOnAfterValidate()
    begin
        //CurrPage.SAVERECORD;
        CurrPage.Update;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        CurrPage.SubFormLines.PAGE.GetLineNo(Rec."Line No.", Rec."Responsibility Center");
    end;
}

#pragma implicitwith restore

