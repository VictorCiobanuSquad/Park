#pragma implicitwith disable
page 52865 "Students Entry"
{
    Caption = 'Students Entry';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Registration Class Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
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
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Status Date"; Rec."Status Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer Class"; Rec."Transfer Class")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
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
        }
        area(processing)
        {
            action(StudentCard)
            {
                ApplicationArea = All;
                Caption = '&Student Card';
                Enabled = StudentCardEnable;
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rStudents.Reset;
                    rStudents.SetRange("No.", Rec."Student Code No.");
                    if rStudents.Find('-') then begin
                        fStudent.SetTableView(rStudents);
                        //Não editavel
                        fStudent.NotEditable;
                        fStudent.SetSchoolYear(Rec."School Year");
                        fStudent.Run;
                    end;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        StudentCardEnable := true;
    end;

    trigger OnOpenPage()
    begin

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        if CurrPage.LookupMode then
            StudentCardEnable := false;
    end;

    var
        rStudents: Record Students;
        cUserEducation: Codeunit "User Education";
        [InDataSet]
        StudentCardEnable: Boolean;
        fStudent: Page "Student Card";
}

#pragma implicitwith restore

