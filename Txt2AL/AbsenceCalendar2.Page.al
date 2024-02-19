#pragma implicitwith disable
page 31009847 "Absence Calendar 2"
{
    AutoSplitKey = true;
    Caption = 'Absence Calendar 2';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
    SourceTableView = WHERE("Absence Type" = FILTER(Daily),
                            "Incidence Type" = FILTER(Absence),
                            "Student/Teacher" = FILTER(Student));

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field(Subject; Rec.Subject)
                {
                    Visible = SubjectVisible;
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    Caption = 'Sub-Subject Code';
                    ApplicationArea = Basic, Suite;
                    Visible = "Sub-Subject CodeVisible";
                }
                field("Student/Teacher Code No."; Rec."Student/Teacher Code No.")
                {
                    Caption = 'Student Code No.';
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec.ValidateStudentNo;
                    end;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class No."; Rec."Class No.")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Status"; Rec."Absence Status")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        IncidenceCodeOnAfterValidate;
                    end;
                }
                field("Incidence Description"; Rec."Incidence Description")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    var
                        rClass: Record Class;
                        fObserAbsence: Page "Observations Absence Wizard";
                    begin
                        CurrPage.SaveRecord;
                        if rClass.Get(Rec.Class, Rec."School Year") then;

                        if Rec."Student/Teacher Code No." <> '' then begin
                            fObserAbsence.GetInformation(Rec, rClass."Schooling Year", true);
                            fObserAbsence.GetStatusJustified(Rec."Absence Status");
                            if rCalendar."Lecture Status" = rCalendar."Lecture Status"::Summary then
                                fObserAbsence.SetEditable(false)
                            else
                                fObserAbsence.SetEditable(true);

                            fObserAbsence.Run;
                        end;
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
        OnAfterGetCurrRecord2();
    end;

    trigger OnInit()
    begin
        "Sub-Subject CodeVisible" := true;
        SubjectVisible := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        text0001: Label 'Student No. is Mandatory.';
        text0002: Label 'Incidence Code is Mandatory.';
    begin
        //ValidateStudentAbsences;

        if Rec."Student/Teacher Code No." = '' then
            Error(text0001);

        if Rec."Incidence Code" = '' then
            Error(text0002);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        l_Subjects: Record Subjects;
    begin
        Rec."Absence Type" := rCalendar."Absence Type";
        Rec."Responsibility Center" := rCalendar."Responsibility Center";
        Rec."Incidence Type" := Rec."Incidence Type"::Absence;
        Rec."Absence Status" := Rec."Absence Status"::Unjustified;
        Rec."Student/Teacher" := Rec."Student/Teacher"::Student;
        Rec.Subject := rCalendar.Subject;
        Rec."Sub-Subject Code" := rCalendar."Sub-Subject Code";
        Rec.Turn := rCalendar.Turn;
        Rec."Line No. Timetable" := rCalendar."Line No.";
        Rec."Type Subject" := rCalendar."Type Subject";

        if rCalendar."Type Subject" = rCalendar."Type Subject"::"Non scholar hours" then begin
            l_Subjects.Reset;
            l_Subjects.SetRange(Type, l_Subjects.Type::"Non scholar hours");
            l_Subjects.SetRange(Code, rCalendar.Subject);
            if l_Subjects.FindSet then
                Rec.Category := l_Subjects.Category;
        end;

        if rCalendar."Type Subject" = rCalendar."Type Subject"::Subject then
            Rec.Category := Rec.Category::Class;
        OnAfterGetCurrRecord2();
    end;

    var
        rCalendar: Record Calendar;
        rIncidenceType: Record "Incidence Type";
        rClass: Record Class;
        [InDataSet]
        SubjectVisible: Boolean;
        [InDataSet]
        "Sub-Subject CodeVisible": Boolean;

    //[Scope('OnPrem')]
    procedure SendHeader(pCalendar: Record Calendar)
    begin
        // This saves the header record in a global variable in the subform
        rCalendar := pCalendar;
    end;

    local procedure IncidenceCodeOnAfterValidate()
    begin
        CurrPage.SaveRecord;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        if Rec."Absence Type" = Rec."Absence Type"::Daily then begin
            SubjectVisible := false;
            "Sub-Subject CodeVisible" := false;
        end else begin
            SubjectVisible := true;
            "Sub-Subject CodeVisible" := true;

        end;
    end;
}

#pragma implicitwith restore

