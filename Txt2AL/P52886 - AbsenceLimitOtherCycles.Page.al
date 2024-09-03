#pragma implicitwith disable
page 52886 "Absence Limit Other Cycles"
{
    Caption = 'Absence Limit Other Cycles';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Registration Subjects";
    SourceTableView = SORTING("Student Code No.", "School Year", "Line No.")
                      WHERE(Status = CONST(Subscribed),
                            "Absence Option" = FILTER(<> " "));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("School Year"; Rec."School Year")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field(vStudentName; vStudentName)
                {
                    Caption = 'Full Name';
                    ApplicationArea = Basic, Suite;
                }
                field("Subjects Code"; Rec."Subjects Code")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Status Date"; Rec."Status Date")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Option"; Rec."Absence Option")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Education Head Alert"; Rec."Education Head Alert")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        EducationHeadAlertOnAfterValid;
                    end;
                }
                field("Recover Test"; Rec."Recover Test")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        RecoverTestOnAfterValidate;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if rStudents.Get(Rec."Student Code No.") then
            vStudentName := rStudents.Name;
    end;

    trigger OnOpenPage()
    begin
        //Filter;

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        Rec.SetRange("School Year", cStudentsRegis.GetShoolYearActive);
    end;

    var
        rStudents: Record Students;
        rRegisSubjects: Record "Registration Subjects";
        cStudentsRegis: Codeunit "Students Registration";
        Text0001: Label 'Would you like to create a recovery test for the following students?';
        Text0002: Label 'There are students with active recovery tests.';
        cUserEducation: Codeunit "User Education";
        vStudentName: Text[191];

    //[Scope('OnPrem')]
    procedure "Filter"()
    var
        Absence: Record Absence;
        RegistrationSubjects: Record "Registration Subjects";
        CourseLines: Record "Course Lines";
        FirstClass: Code[30];
        LastClass: Code[30];
        SelectionFilter: Code[250];
        ClassCount: Integer;
        More: Boolean;
    begin
        /*
        RegistrationSubjects.RESET;
        IF RegistrationSubjects.FIND('-') THEN
          REPEAT
            CourseLines.RESET;
            CourseLines.SETRANGE(Code,RegistrationSubjects."Study Plan Code");
            CourseLines.SETRANGE("Subject Code",RegistrationSubjects."Subjects Code");
            IF CourseLines.FIND('-') THEN BEGIN
               Absence.RESET;
               Absence.SETRANGE("Study Plan",CourseLines.Code);
               Absence.SETRANGE(Subject,CourseLines."Subject Code");
               Absence.SETRANGE(Class,RegistrationSubjects.Class);
               Absence.SETRANGE("Incidence Type",Absence."Incidence Type"::Absence);
               Absence.SETRANGE(Delay,TRUE);
               Absence.SETRANGE("Student/Teacher",Absence."Student/Teacher"::Student);
               Absence.SETRANGE("Student/Teacher Code No.",RegistrationSubjects."Student Code No.");
               IF Absence.FIND('-') THEN   BEGIN
                  IF Absence.COUNT > CourseLines."Maximum Unjustified Absences" THEN BEGIN
                    INIT;
                    Rec := RegistrationSubjects;
                    INSERT;
                     END;
               END;
        
               Absence.RESET;
               Absence.SETRANGE("Study Plan",CourseLines.Code);
               Absence.SETRANGE(Subject,CourseLines."Subject Code");
               Absence.SETRANGE(Class,RegistrationSubjects.Class);
               Absence.SETRANGE("Incidence Type",Absence."Incidence Type"::Absence);
               Absence.SETRANGE(Delay,TRUE);
               Absence.SETRANGE("Student/Teacher",Absence."Student/Teacher"::Student);
               Absence.SETRANGE("Student/Teacher Code No.",RegistrationSubjects."Student Code No.");
               IF Absence.FIND('-') THEN   BEGIN
                  IF Absence.COUNT > CourseLines."Maximum Total Absences" THEN BEGIN
                     RESET;
                     SETRANGE("Study Plan Code",CourseLines.Code);
                     SETRANGE("Subjects Code",CourseLines."Subject Code");
                     IF NOT FIND('-') THEN BEGIN
                        INIT;
                        Rec := RegistrationSubjects;
                        INSERT;
                     END;
                     END;
               END;
            END;
          UNTIL RegistrationSubjects.NEXT = 0;
        
        RESET;
         */

    end;

    local procedure EducationHeadAlertOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure RecoverTestOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

