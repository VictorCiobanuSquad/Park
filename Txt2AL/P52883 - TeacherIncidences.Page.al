#pragma implicitwith disable
page 52883 "Teacher Incidences"
{
    Caption = 'Teacher Incidences';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Absence;
    SourceTableView = WHERE("Student/Teacher" = CONST(Teacher));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Study Plan"; Rec."Study Plan")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject Code';
                    Editable = false;
                }
                field("Incidence Type"; Rec."Incidence Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Incidence Description"; Rec."Incidence Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Absence Status"; Rec."Absence Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        fObserAbsence: Page "Observations Absence Wizard";
                    begin

                        fObserAbsence.GetInformation(Rec, '', false);

                        fObserAbsence.Run;
                    end;
                }
                field("Justified Code"; Rec."Justified Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Justified Description"; Rec."Justified Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

#pragma implicitwith restore

