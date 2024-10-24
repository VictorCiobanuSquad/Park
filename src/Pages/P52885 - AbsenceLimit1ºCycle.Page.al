#pragma implicitwith disable
page 52885 "Absence Limit 1º Cycle"
{
    Caption = 'Absence Limit 1º Cycle';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Registration Class";
    SourceTableView = SORTING(Class, "School Year", "Schooling Year", "Study Plan Code", "Student Code No.", Type, "Line No.")
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
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
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
        Text0001: Label 'Would you like to create a recovery test for the following students?';
        rRegisClass: Record "Registration Class";
        cStudentsRegis: Codeunit "Students Registration";
        Text0002: Label 'There are students with active recovery tests.';
        cUserEducation: Codeunit "User Education";


    procedure "Filter"()
    var
        Absence: Record Absence;
        RegistrationClass: Record "Registration Class";
        StudyPlanHeader: Record "Study Plan Header";
        FirstClass: Code[30];
        LastClass: Code[30];
        SelectionFilter: Code[250];
        ClassCount: Integer;
        More: Boolean;
    begin
        /*
        RegistrationClass.RESET;
        IF RegistrationClass.FIND('-') THEN
          REPEAT
            StudyPlanHeader.RESET;
            StudyPlanHeader.SETRANGE(Code,RegistrationClass."Study Plan Code");
            StudyPlanHeader.SETRANGE("School Year",RegistrationClass."School Year");
            StudyPlanHeader.SETRANGE("Schooling Year",RegistrationClass."Schooling Year");
            IF StudyPlanHeader.FIND('-') THEN BEGIN
               Absence.RESET;
               Absence.SETRANGE("Absence Status",Absence."Absence Status"::Unjustified);
               Absence.SETRANGE("Study Plan",StudyPlanHeader.Code);
               Absence.SETRANGE("School Year",StudyPlanHeader."School Year");
               Absence.SETRANGE("Schooling Year",StudyPlanHeader."Schooling Year");
               Absence.SETRANGE(Class,RegistrationClass.Class);
               Absence.SETRANGE("Incidence Type",Absence."Incidence Type"::Absence);
               Absence.SETRANGE(Delay,TRUE);
               Absence.SETRANGE("Student/Teacher",Absence."Student/Teacher"::Student);
               Absence.SETRANGE("Student/Teacher Code No.",RegistrationClass."Student Code No.");
               IF Absence.FIND('-') THEN   BEGIN
                  IF Absence.COUNT > StudyPlanHeader."Maximum Unjustified Absence" THEN BEGIN
                    INIT;
                    Rec := RegistrationClass;
                    INSERT;
                     END;
               END;
        
               Absence.RESET;
               Absence.SETRANGE("Study Plan",StudyPlanHeader.Code);
               Absence.SETRANGE("School Year",StudyPlanHeader."School Year");
               Absence.SETRANGE("Schooling Year",StudyPlanHeader."Schooling Year");
               Absence.SETRANGE(Class,RegistrationClass.Class);
               Absence.SETRANGE("Incidence Type",Absence."Incidence Type"::Absence);
               Absence.SETRANGE(Delay,TRUE);
               Absence.SETRANGE("Student/Teacher",Absence."Student/Teacher"::Student);
               Absence.SETRANGE("Student/Teacher Code No.",RegistrationClass."Student Code No.");
               IF Absence.FIND('-') THEN   BEGIN
                  IF Absence.COUNT > StudyPlanHeader."Maximum Total Absence" THEN BEGIN
                    RESET;
                    SETRANGE("Study Plan Code",StudyPlanHeader.Code);
                    SETRANGE("School Year",StudyPlanHeader."School Year");
                    SETRANGE("Schooling Year",StudyPlanHeader."Schooling Year");
                    IF NOT FIND THEN BEGIN
                       INIT;
                          Rec := RegistrationClass;
                       INSERT;
                    END;
                  END;
               END;
            END;
          UNTIL RegistrationClass.NEXT = 0;
        
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

