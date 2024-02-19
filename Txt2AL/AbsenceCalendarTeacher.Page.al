#pragma implicitwith disable
page 31009776 "Absence Calendar Teacher"
{
    AutoSplitKey = true;
    Caption = 'Absence Calendar Teacher';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
    SourceTableView = WHERE("Incidence Type" = FILTER(Absence),
                            "Student/Teacher" = FILTER(Teacher));

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field(Subject; Rec.Subject)
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
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

                        fObserAbsence.GetInformation(Rec, rClass."Schooling Year", true);

                        fObserAbsence.GetStatusJustified(Rec."Absence Status");
                        fObserAbsence.SetEditable(true);

                        fObserAbsence.Run;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        text0001: Label 'Student No. is Mandatory.';
        text0002: Label 'Incidence Code is Mandatory.';
    begin
        if Rec."Student/Teacher Code No." = '' then
            Error(text0001);

        if Rec."Incidence Code" = '' then
            Error(text0002);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        l_rSubjects: Record Subjects;
    begin
        //"Absence Type"   := rCalendar."Absence Type";
        Rec."Responsibility Center" := rTimetableTeacher."Responsibility Center";
        Rec."Incidence Type" := Rec."Incidence Type"::Absence;
        Rec."Absence Status" := Rec."Absence Status"::Unjustified;
        Rec."Student/Teacher" := Rec."Student/Teacher"::Teacher;
        Rec.Validate("Student/Teacher Code No.", rTimetableTeacher."Teacher No.");
        if Rec.Class <> '' then
            Rec."Study Plan" := rClass."Study Plan Code";
        Rec.Type := rClass.Type;
        Rec.Category := Rec.Category::Teacher;
        Rec.Subject := rTimetableTeacher.Subject;
        Rec."Type Subject" := rTimetableTeacher."Type Subject";
        Rec."Sub-Subject Code" := rTimetableTeacher."Sub-Subject Code";


        if Rec."Type Subject" = Rec."Type Subject"::"Non scholar component" then begin
            l_rSubjects.Reset;
            l_rSubjects.SetRange(l_rSubjects.Type, l_rSubjects.Type::"Non scholar component");
            l_rSubjects.SetRange(l_rSubjects.Code, Rec.Subject);
            if l_rSubjects.FindFirst then begin
                if l_rSubjects."Absence Period" = l_rSubjects."Absence Period"::Daily then
                    Rec."Absence Type" := Rec."Absence Type"::Daily;
            end;
        end;

        Rec.ValidateStudentNo;
    end;

    var
        rTimetableTeacher: Record "Timetable-Teacher";
        rIncidenceType: Record "Incidence Type";
        rClass: Record Class;

    //[Scope('OnPrem')]
    procedure SendHeader(pTimetableTeacher: Record "Timetable-Teacher")
    begin
        // This saves the header record in a global variable in the subform
        rTimetableTeacher := pTimetableTeacher;

        if rClass.Get(rTimetableTeacher.Class, rTimetableTeacher."School Year") then;
    end;
}

#pragma implicitwith restore

