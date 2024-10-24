#pragma implicitwith disable
page 52884 "Absences Counter"
{
    Caption = 'Absence';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Absence;
    SourceTableView = WHERE("Student/Teacher" = FILTER(Student));

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan"; Rec."Study Plan")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub-Subject Code';
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Status"; Rec."Absence Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnAssistEdit()
                    var
                        fObserAbsence: Page "Observations Absence Wizard";
                        rClass: Record Class;
                    begin
                        if rClass.Get(Rec.Class, Rec."School Year") then;


                        fObserAbsence.GetInformation(Rec, rClass."Schooling Year", false);

                        fObserAbsence.Run;
                    end;
                }
                field("Incidence Type"; Rec."Incidence Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Description"; Rec."Incidence Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Type"; Rec."Absence Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Justified Code"; Rec."Justified Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Absence Hours"; Rec."Absence Hours")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Justified Description"; Rec."Justified Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                field(vSubject; vSubject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unjustified Absences';
                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(vCounterAbsenceInjust; vCounterAbsenceInjust)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unjustified Absences';
                    Editable = false;
                }
                field(vCounterAbsenceTotal; vCounterAbsenceTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Absences';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        Clear(vCounterAbsenceInjust);
        Clear(vCounterAbsenceTotal);
    end;

    var
        rAbsence: Record Absence;
        vCounterAbsenceInjust: Integer;
        vCounterAbsenceTotal: Integer;
        cEvaluationsIncide: Codeunit "Evaluations-Incidences";
        vSubject: Code[22];


    procedure AbsencesCounter()
    var
        rStructureEducCountry: Record "Structure Education Country";
        rClass: Record Class;
        rIncidenceType: Record "Incidence Type";
        rIncidenceType2: Record "Incidence Type";
        recAbsence: Record Absence;
        vCounterQuant: Integer;
    begin
        Clear(vCounterAbsenceInjust);
        Clear(vCounterAbsenceTotal);

        vCounterAbsenceTotal := cEvaluationsIncide.CalFaltasLegalReports(Rec."School Year", Rec."Schooling Year", Rec.Class, Rec."Student/Teacher Code No.",
                                Rec.Subject, 0D, 0, 0D);

        vCounterAbsenceInjust := cEvaluationsIncide.CalFaltasLegalReports(Rec."School Year", Rec."Schooling Year", Rec.Class, Rec."Student/Teacher Code No.",
                                 Rec.Subject, 0D, 1, 0D);



        /*
        CLEAR(vCounterAbsenceInjust);
        CLEAR(vCounterAbsenceTotal);
        
        
        rAbsence.RESET;
        rAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
        rAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
        rAbsence.SETRANGE("School Year","School Year");
        rAbsence.SETRANGE(Subject,Subject);
        rAbsence.SETRANGE(Category,rAbsence.Category::Class);
        rAbsence.SETRANGE("Incidence Type",rAbsence."Incidence Type"::Absence);
        IF rAbsence.FINDSET THEN
          REPEAT
            IF NOT rAbsence.Delay THEN
              vCounterAbsenceTotal := vCounterAbsenceTotal + 1;
          UNTIL rAbsence.NEXT =0;
        
        
        rAbsence.RESET;
        rAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
        rAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
        rAbsence.SETRANGE("School Year","School Year");
        rAbsence.SETRANGE(Subject,Subject);
        rAbsence.SETRANGE(Category,rAbsence.Category::Class);
        rAbsence.SETRANGE("Incidence Type",rAbsence."Incidence Type"::Absence);
        rAbsence.SETRANGE("Absence Status",rAbsence."Absence Status"::Unjustified);
        IF rAbsence.FINDSET THEN
          REPEAT
            vCounterAbsenceInjust := vCounterAbsenceInjust+1;
          UNTIL rAbsence.NEXT =0;
        */
        /*
        rClass.RESET;
        rClass.SETRANGE(Class,Class);
        IF rClass.FIND('-') THEN BEGIN
           rStructureEducCountry.RESET;
           rStructureEducCountry.SETRANGE(Country,rClass."Country/Region Code");
           rStructureEducCountry.SETRANGE("Schooling Year",rClass."Schooling Year");
           IF rStructureEducCountry.FIND('-') THEN
              IF rStructureEducCountry."Absence Type" = rStructureEducCountry."Absence Type"::Daily THEN BEGIN
                 rIncidenceType.RESET;
                 rIncidenceType.SETRANGE("School Year","School Year");
                 rIncidenceType.SETRANGE("Schooling Year",rClass."Schooling Year");
                 //rIncidenceType.SETRANGE(Type,rIncidenceType.Type::Absence);
                 rIncidenceType.SETFILTER(Quantity,'>1');
                 IF rIncidenceType.FIND('-') THEN BEGIN
                    REPEAT
                      CLEAR(vCounterQuant);
        
                      recAbsence.RESET;
                                recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher C
        od
        e
        No
        ."
        );
                      recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                      recAbsence.SETRANGE("School Year","School Year");
                      recAbsence.SETRANGE("Incidence Code",rIncidenceType."Incidence Code");
                      IF recAbsence.FIND('-') THEN
                         REPEAT
                           vCounterQuant := vCounterQuant + 1;
                           IF vCounterQuant = rIncidenceType.Quantity THEN BEGIN
                              rIncidenceType2.RESET;
                              rIncidenceType2.SETRANGE("School Year",rIncidenceType."School Year");
                              rIncidenceType2.SETRANGE("Schooling Year",rIncidenceType."Schooling Year");
                              rIncidenceType2.SETRANGE("Incidence Code",rIncidenceType."Corresponding Code");
                              IF rIncidenceType2.FIND('-') THEN
                                 vCounterAbsenceInjust := vCounterAbsenceInjust + rIncidenceType2.Quantity;
                              vCounterQuant := 0;
                           END;
                         UNTIL recAbsence.NEXT = 0;
                    UNTIL rIncidenceType.NEXT = 0;
                 END;
        
                 rIncidenceType.RESET;
                 rIncidenceType.SETRANGE("School Year","School Year");
                 rIncidenceType.SETRANGE("Schooling Year",rClass."Schooling Year");
                 //rIncidenceType.SETRANGE(Type,rIncidenceType.Type::Absence);
                 rIncidenceType.SETFILTER(Quantity,'1');
                 IF rIncidenceType.FIND('-') THEN
                    REPEAT
                      rAbsence.SETRANGE("Incidence Code",rIncidenceType."Incidence Code");
                      IF rAbsence.FIND('-') THEN
                         REPEAT
                           IF rAbsence."Absence Status" = rAbsence."Absence Status"::Unjustified THEN
                              vCounterAbsenceInjust := vCounterAbsenceInjust + rIncidenceType.Quantity;
                         UNTIL rAbsence.NEXT = 0;
                    UNTIL rIncidenceType.NEXT = 0;
        
                 recAbsence.RESET;
                 recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
                 recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                 recAbsence.SETRANGE("School Year","School Year");
                 recAbsence.SETFILTER("Incidence Code",'%1','');
                 recAbsence.SETRANGE("Absence Status",recAbsence."Absence Status"::Unjustified);
                 IF recAbsence.FIND('-') THEN
                    REPEAT
                      vCounterAbsenceInjust := vCounterAbsenceInjust + 1;
                    UNTIL recAbsence.NEXT = 0;
        
                 recAbsence.RESET;
                 recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
                 recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                 recAbsence.SETRANGE("School Year","School Year");
                 recAbsence.SETRANGE("Absence Status",recAbsence."Absence Status"::Justification);
                 IF recAbsence.FIND('-') THEN
                    REPEAT
                      vCounterAbsenceTotal := vCounterAbsenceTotal + 1;
                    UNTIL recAbsence.NEXT = 0;
        
                 vCounterAbsenceTotal := vCounterAbsenceInjust + vCounterAbsenceTotal;
              END ELSE BEGIN
                 rIncidenceType.RESET;
                 rIncidenceType.SETRANGE("School Year","School Year");
                 rIncidenceType.SETRANGE("Schooling Year",rClass."Schooling Year");
                // rIncidenceType.SETRANGE(Type,rIncidenceType.Type::Absence);
                 rIncidenceType.SETFILTER(Quantity,'>1');
                 IF rIncidenceType.FIND('-') THEN BEGIN
                    REPEAT
                      CLEAR(vCounterQuant);
        
                      recAbsence.RESET;
                                recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher C
        od
        e
        No
        ."
        );
                      recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                      recAbsence.SETRANGE("School Year","School Year");
                      recAbsence.SETRANGE(Subject,Subject);
                      recAbsence.SETRANGE("Incidence Code",rIncidenceType."Incidence Code");
                      IF recAbsence.FIND('-') THEN
                         REPEAT
                           vCounterQuant := vCounterQuant + 1;
                           IF vCounterQuant = rIncidenceType.Quantity THEN BEGIN
                              rIncidenceType2.RESET;
                              rIncidenceType2.SETRANGE("School Year",rIncidenceType."School Year");
                              rIncidenceType2.SETRANGE("Schooling Year",rIncidenceType."Schooling Year");
                              rIncidenceType2.SETRANGE("Incidence Code",rIncidenceType."Corresponding Code");
                              IF rIncidenceType2.FIND('-') THEN
                                 vCounterAbsenceInjust := vCounterAbsenceInjust + rIncidenceType2.Quantity;
                              vCounterQuant := 0;
                           END;
                         UNTIL recAbsence.NEXT = 0;
                    UNTIL rIncidenceType.NEXT = 0;
                 END;
        
                 rIncidenceType.RESET;
                 rIncidenceType.SETRANGE("School Year","School Year");
                 rIncidenceType.SETRANGE("Schooling Year",rClass."Schooling Year");
                // rIncidenceType.SETRANGE(Type,rIncidenceType.Type::Absence);
                 rIncidenceType.SETFILTER(Quantity,'1');
                 IF rIncidenceType.FIND('-') THEN
                    REPEAT
                      rAbsence.SETRANGE("Incidence Code",rIncidenceType."Incidence Code");
                      rAbsence.SETRANGE(Subject,Subject);
                      IF rAbsence.FIND('-') THEN
                         REPEAT
                           IF rAbsence."Absence Status" = rAbsence."Absence Status"::Unjustified THEN
                              vCounterAbsenceInjust := vCounterAbsenceInjust + rIncidenceType.Quantity;
                         UNTIL rAbsence.NEXT = 0;
                    UNTIL rIncidenceType.NEXT = 0;
        
                 recAbsence.RESET;
                 recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
                 recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                 recAbsence.SETRANGE("School Year","School Year");
                 recAbsence.SETRANGE(Subject,Subject);
                 recAbsence.SETFILTER("Incidence Code",'%1','');
                 recAbsence.SETRANGE("Absence Status",recAbsence."Absence Status"::Unjustified);
                 IF recAbsence.FIND('-') THEN
                    REPEAT
                      vCounterAbsenceInjust := vCounterAbsenceInjust + 1;
                    UNTIL recAbsence.NEXT = 0;
        
                 recAbsence.RESET;
                 recAbsence.SETCURRENTKEY("Timetable Code","School Year","Study Plan",Class,"Absence Type","Student/Teacher Code No.");
                 recAbsence.SETRANGE("Student/Teacher Code No.","Student/Teacher Code No.");
                 recAbsence.SETRANGE("School Year","School Year");
                 recAbsence.SETRANGE(Subject,Subject);
                 recAbsence.SETRANGE("Absence Status",recAbsence."Absence Status"::Justification);
                 IF recAbsence.FIND('-') THEN
                    REPEAT
                      vCounterAbsenceTotal := vCounterAbsenceTotal + 1;
                    UNTIL recAbsence.NEXT = 0;
                 vCounterAbsenceTotal := vCounterAbsenceInjust + vCounterAbsenceTotal;
              END;
        END;
        */

    end;


    procedure FormUpdate()
    begin
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        AbsencesCounter;
        if Rec.Subject <> '' then
            vSubject := Rec.Subject + ' :'
        else
            vSubject := '';
    end;
}

#pragma implicitwith restore

