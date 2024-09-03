#pragma implicitwith disable
page 52777 "General Calendar Teacher"
{
    AutoSplitKey = true;
    Caption = 'Absence Calendar Teacher';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
    SourceTableView = WHERE("Incidence Type" = FILTER(Default),
                            "Student/Teacher" = FILTER(Teacher));

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field("Absence Status"; Rec."Absence Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Incidence Code"; Rec."Incidence Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Incidence Description"; Rec."Incidence Description")
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
    begin
        //"Absence Type"   := rCalendar."Absence Type";
        Rec."Responsibility Center" := rTimetableTeacher."Responsibility Center";
        Rec."Incidence Type" := Rec."Incidence Type"::Default;
        Rec."Absence Status" := Rec."Absence Status"::Unjustified;
        Rec."Student/Teacher" := Rec."Student/Teacher"::Teacher;
        Rec.Validate("Student/Teacher Code No.", rTimetableTeacher."Teacher No.");
        Rec."Study Plan" := rClass."Study Plan Code";
        Rec.Type := rClass.Type;
        Rec.Category := Rec.Category::Teacher;
        Rec.Subject := rTimetableTeacher.Subject;
        Rec."Sub-Subject Code" := rTimetableTeacher."Sub-Subject Code";

        Rec.ValidateStudentNo;
    end;

    var
        rIncidenceType: Record "Incidence Type";
        rClass: Record Class;
        rTimetableTeacher: Record "Timetable-Teacher";

    //[Scope('OnPrem')]
    procedure SendHeader(pTimetableTeacher: Record "Timetable-Teacher")
    begin
        // This saves the header record in a global variable in the subform
        rTimetableTeacher := pTimetableTeacher;

        if rClass.Get(rTimetableTeacher.Class, rTimetableTeacher."School Year") then;
    end;
}

#pragma implicitwith restore

