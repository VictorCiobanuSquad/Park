#pragma implicitwith disable
page 52854 "Teacher Calendar"
{
    Caption = 'Teacher Calendar';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Timetable-Teacher";
    SourceTableView = SORTING("Filter Period", "Start Hour", "End Hour");

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(vStartDate; vStartDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnValidate()
                    begin
                        vEndDate := vStartDate;
                        FilterDate;
                        vStartDateOnAfterValidate;
                    end;
                }
                field(vEndDate; vEndDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnValidate()
                    begin
                        FilterDate;
                        vEndDateOnAfterValidate;
                    end;
                }
                field(vTeacher; vTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTeacherClass: Record "Timetable-Teacher";
                        rTeacherClassTEMP: Record "Timetable-Teacher" temporary;
                        rteacher: Record Teacher;
                    begin
                        if vClass = '' then begin
                            rteacher.Reset;
                            rteacher.SetRange("No.");
                            if rteacher.Find('-') then
                                if PAGE.RunModal(PAGE::"Teacher List", rteacher) = ACTION::LookupOK then begin
                                    vTeacher := rteacher."No.";
                                    SetFormFilters;
                                end;
                        end;


                        if vClass <> '' then begin
                            rTeacherClassTEMP.DeleteAll;

                            rTeacherClass.Reset;
                            rTeacherClass.SetRange(Class, vClass);
                            if rTeacherClass.Find('-') then begin
                                repeat
                                    rTeacherClassTEMP.Reset;
                                    rTeacherClassTEMP.SetRange(Class, vClass);
                                    rTeacherClassTEMP.SetRange("Teacher No.", rTeacherClass."Teacher No.");
                                    if not rTeacherClassTEMP.Find('-') then begin
                                        rTeacherClassTEMP.Init;
                                        rTeacherClassTEMP.TransferFields(rTeacherClass);
                                        rTeacherClassTEMP.Insert;
                                    end;
                                until rTeacherClass.Next = 0;
                            end;

                            rTeacherClassTEMP.Reset;
                            if PAGE.RunModal(PAGE::TeacherTimetable, rTeacherClassTEMP) = ACTION::LookupOK then begin
                                vTeacher := rTeacherClassTEMP."Teacher No.";
                                SetFormFilters;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        vTeacherOnAfterValidate;
                    end;
                }
                field(vClass; vClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rClassTemp: Record Class temporary;
                    begin
                        if vTeacher = '' then begin
                            rClass.Reset;
                            rClass.SetRange("School Year", vSchoolYear);
                            if rClass.Find('-') then
                                if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                    vClass := rClass.Class
                                end;
                            SetFormFilters;
                        end;


                        if vTeacher <> '' then begin
                            rClassTemp.DeleteAll;

                            rTeacherClasslist.Reset;
                            rTeacherClasslist.SetRange(rTeacherClasslist.User, vTeacher);
                            if rTeacherClasslist.Find('-') then begin
                                repeat
                                    rClassTemp.Reset;
                                    rClassTemp.SetRange(Class, rTeacherClasslist.Class);

                                    if not rClassTemp.Find('-') then begin
                                        if rClass.Get(rTeacherClasslist.Class, rTeacherClasslist."School Year") then begin
                                            rClassTemp.Init;
                                            rClassTemp.TransferFields(rClass);
                                            rClassTemp.Insert;
                                        end;
                                    end;
                                until rTeacherClasslist.Next = 0;
                            end;

                            rClassTemp.Reset;
                            if PAGE.RunModal(PAGE::"Class List", rClassTemp) = ACTION::LookupOK then begin
                                vClass := rClassTemp.Class;
                                SetFormFilters;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        vClassOnAfterValidate;
                    end;
                }
                field(vSubject; vSubject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject';

                    trigger OnLookup(var Text: Text): Boolean
                    begin


                        if (vTeacher <> '') and (vClass = '') then begin
                            rTeacherClasslist.Reset;
                            rTeacherClasslist.SetRange(rTeacherClasslist."User Type", rTeacherClasslist."User Type"::Teacher);
                            rTeacherClasslist.SetRange(User, vTeacher);
                            rTeacherClasslist.SetRange(rTeacherClasslist."Type Subject", rTeacherClasslist."Type Subject"::Subject);
                            if rTeacherClasslist.Find('-') then
                                if PAGE.RunModal(PAGE::"Teacher Class List", rTeacherClasslist) = ACTION::LookupOK then begin
                                    vSubject := rTeacherClasslist."Subject Code";
                                    SetFormFilters;
                                end;
                        end;

                        if (vTeacher <> '') then begin
                            rTeacherClasslist.Reset;
                            rTeacherClasslist.SetRange(rTeacherClasslist."User Type", rTeacherClasslist."User Type"::Teacher);
                            rTeacherClasslist.SetRange(User, vClass);
                            rTeacherClasslist.SetRange(User, vTeacher);
                            rTeacherClasslist.SetRange(rTeacherClasslist."Type Subject", rTeacherClasslist."Type Subject"::Subject);
                            if rTeacherClasslist.Find('-') then
                                if PAGE.RunModal(PAGE::"Teacher Class List", rTeacherClasslist) = ACTION::LookupOK then begin
                                    vSubject := rTeacherClasslist."Subject Code";
                                    SetFormFilters;
                                end;
                        end;


                        if vTeacher = '' then begin
                            rTeacherClasslist.Reset;
                            rTeacherClasslist.SetRange(rTeacherClasslist."User Type", rTeacherClasslist."User Type"::Teacher);
                            rTeacherClasslist.SetRange(Class, vClass);
                            rTeacherClasslist.SetRange("School Year", vSchoolYear);
                            rTeacherClasslist.SetRange(rTeacherClasslist."Type Subject", rTeacherClasslist."Type Subject"::Subject);
                            if rTeacherClasslist.Find('-') then
                                if PAGE.RunModal(PAGE::"Teacher Class List", rTeacherClasslist) = ACTION::LookupOK then begin
                                    vSubject := rTeacherClasslist."Subject Code";
                                    SetFormFilters;
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        vSubjectOnAfterValidate;
                    end;
                }
                field(VarTurn; VarTurn)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Turn';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTurn: Record Turn;
                        rTurnTemp: Record Turn temporary;
                        rRegistrationSubjects: Record "Registration Subjects";
                        rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                        rShoolYear: Record "School Year";
                    begin
                        if vClass <> '' then begin
                            rRegistrationSubjects.Reset;
                            rRegistrationSubjects.SetRange(Class, vClass);
                            rRegistrationSubjects.SetRange("School Year", vSchoolYear);
                            if rRegistrationSubjects.Find('-') then
                                repeat
                                    rRegistrationSubjects.CalcFields("Sub-subject");
                                    if rRegistrationSubjects."Sub-subject" then begin
                                        rStudentSubSubjectsPlan.Reset;
                                        rStudentSubSubjectsPlan.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                                        rStudentSubSubjectsPlan.SetRange("School Year", rRegistrationSubjects."School Year");
                                        rStudentSubSubjectsPlan.SetRange(Code, rRegistrationSubjects."Study Plan Code");
                                        rStudentSubSubjectsPlan.SetRange("Subject Code", rRegistrationSubjects."Subjects Code");
                                        if rStudentSubSubjectsPlan.Find('-') then
                                            repeat
                                                if rStudentSubSubjectsPlan.Turn <> '' then begin
                                                    rTurnTemp.Reset;
                                                    rTurnTemp.SetRange(Code, rStudentSubSubjectsPlan.Turn);
                                                    if not rTurnTemp.Find('-') then begin
                                                        if rTurn.Get(rStudentSubSubjectsPlan.Turn, rRegistrationSubjects."Responsibility Center") then begin
                                                            rTurnTemp.Init;
                                                            rTurnTemp.TransferFields(rTurn);
                                                            rTurnTemp.Insert;
                                                        end;
                                                    end;
                                                end;
                                            until rStudentSubSubjectsPlan.Next = 0;
                                    end;
                                    if rRegistrationSubjects.Turn <> '' then begin
                                        rTurnTemp.Reset;
                                        rTurnTemp.SetRange(Code, rRegistrationSubjects.Turn);
                                        if not rTurnTemp.Find('-') then begin
                                            if rTurn.Get(rRegistrationSubjects.Turn, rRegistrationSubjects."Responsibility Center") then begin
                                                rTurnTemp.Init;
                                                rTurnTemp.TransferFields(rTurn);
                                                rTurnTemp.Insert;
                                            end;
                                        end;
                                    end;
                                until rRegistrationSubjects.Next = 0;

                            rTurnTemp.Reset;
                            if PAGE.RunModal(0, rTurnTemp) = ACTION::LookupOK then
                                VarTurn := rTurnTemp.Code;

                        end else begin
                            if PAGE.RunModal(0, rTurn) = ACTION::LookupOK then
                                VarTurn := rTurn.Code;
                        end;

                        if (vClass = '') and (VarTurn <> '') then begin
                            rShoolYear.Reset;
                            rShoolYear.SetRange(Status, rShoolYear.Status::Active);
                            if rShoolYear.FindSet(false, false) then
                                vSchoolYear := rShoolYear."School Year";
                        end;


                        SetFormFilters;
                    end;

                    trigger OnValidate()
                    var
                        rShoolYear: Record "School Year";
                    begin
                        if vClass = '' then begin
                            rShoolYear.Reset;
                            rShoolYear.SetRange(Status, rShoolYear.Status::Active);
                            if rShoolYear.FindSet(false, false) then
                                vSchoolYear := rShoolYear."School Year";
                        end;
                        if (VarTurn = '') and (vClass = '') then
                            vSchoolYear := '';
                        VarTurnOnAfterValidate;
                    end;
                }
                field(vSchoolYear; vSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));

                    trigger OnValidate()
                    begin
                        vSchoolYearOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110015)
            {
                ShowCaption = false;
                field("Filter Period"; Rec."Filter Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Teacher No."; Rec."Teacher No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Teacher Name"; Rec."Teacher Name")
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
                    Editable = false;
                }
                field(Times; Rec.Times)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Absence)
            {
                Caption = 'Absence';
                part(SubAbsenceLectur1; "Absence Calendar Teacher")
                {
                    ApplicationArea = All;
                    Editable = SubAbsenceLectureEditable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "School Year" = FIELD("School Year"),
                                  Subject = FIELD(Subject),
                                  "Sub-Subject Code" = FIELD("Sub-Subject Code"),
                                  Class = FIELD(Class),
                                  Day = FIELD("Filter Period"),
                                  "Line No. Timetable" = FIELD("Timetable Line No."),
                                  "Student/Teacher Code No." = FIELD("Teacher No.");
                }
            }
            group(Default)
            {
                Caption = 'Default';
                part(SubGeneralAbsence; "General Calendar Teacher")
                {
                    ApplicationArea = All;
                    Editable = SubGeneralAbsenceEditable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "Line No. Timetable" = FIELD("Timetable Line No."),
                                  "School Year" = FIELD("School Year"),
                                  Subject = FIELD(Subject),
                                  "Sub-Subject Code" = FIELD("Sub-Subject Code"),
                                  Class = FIELD(Class),
                                  Day = FIELD("Filter Period"),
                                  "Student/Teacher Code No." = FIELD("Teacher No.");
                }
            }
            group(" All day / Not-Scheduled")
            {
                Caption = ' All day / Not-Scheduled';
                part(SubAbsenceLectur2; "Absence Calendar Teacher2")
                {
                    ApplicationArea = All;
                    SubPageLink = "School Year" = FIELD("School Year"),
                                  Day = FIELD("Filter Period"),
                                  "Student/Teacher Code No." = FIELD("Teacher No.");
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Absences")
            {
                Caption = '&Absences';
                Image = Absence;
                action("Insert Absences All &Day(s)")
                {
                    ApplicationArea = All;
                    Caption = 'Insert Absences All &Day(s)';
                    Image = AbsenceCategories;

                    trigger OnAction()
                    var
                        InsTimeLecture: Record "Insert Timetable Lecture";
                    begin
                        fAbsencesWizard.SetFormFilter('', 1, vStartDate, vEndDate, false, vSchoolYear);  //0 - Aluno  1-Professor   2-Turma
                        fAbsencesWizard.Run;
                    end;
                }
                action("Insert Non-&Scheduled Absences")
                {
                    ApplicationArea = All;
                    Caption = 'Insert Non-&Scheduled Absences';
                    Image = AbsenceCalendar;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        fAbsencesWizard.SetFormFilter('', 1, vStartDate, vEndDate, true, vSchoolYear);  //0 - Aluno  1-Professor   2-Turma
                        fAbsencesWizard.Run;
                    end;
                }
            }
            group("&Lessons")
            {
                Caption = '&Lessons';
                Image = CustomerGroup;
                action("&Insert Lesson")
                {
                    ApplicationArea = All;
                    Caption = '&Insert Lesson';
                    Image = Insert;

                    trigger OnAction()
                    var
                        InsTimeLecture: Record "Insert Timetable Lecture";
                    begin
                        if (Rec."School Year" <> '') and (Rec."Timetable Code" <> '') then begin
                            InsTimeLecture.Reset;
                            InsTimeLecture.SetRange("School Year", Rec."School Year");
                            InsTimeLecture.SetRange("Timetable Code", Rec."Timetable Code");

                            fInsertLessons.FilterType(false);
                            fInsertLessons.SetTableView(InsTimeLecture);
                            fInsertLessons.Run;

                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        SubGeneralAbsenceEditable := true;
        SubAbsenceLectureEditable := true;
        Clear(vSchoolYear);
        Clear(vClass);
        Clear(VarTurn);
        Clear(vTeacher);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.Find('-') then
            vSchoolYear := rSchoolYear."School Year";

        Rec.SetRange("Timetable Code", '');
        SetFormFilters;

        FilterSubform;

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        Text0001: Label 'School Year must not be blank.';
        Text0002: Label 'Study Plan must not be blank.';
        Text0003: Label 'Class must not be blank.';
        rClass: Record Class;
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLine: Record "Course Lines";
        vSchoolYear: Code[9];
        vClass: Code[20];
        vSubject: Code[10];
        vStartDate: Date;
        vEndDate: Date;
        vTeacher: Code[20];
        rTeacherClasslist: Record "Teacher Class";
        cUserEducation: Codeunit "User Education";
        vTimetableCode: Code[20];
        VarTurn: Code[20];
        rSchoolYear: Record "School Year";
        [InDataSet]
        SubAbsenceLectureEditable: Boolean;
        [InDataSet]
        SubGeneralAbsenceEditable: Boolean;
        fAbsencesWizard: Page "Absences Wizard";
        fInsertLessons: Page "Insert Lessons";

    //[Scope('OnPrem')]
    procedure SetFormFilters()
    begin
        if vSchoolYear <> '' then
            Rec.SetRange("School Year", vSchoolYear)
        else
            Rec.SetRange("School Year");

        if vTeacher <> '' then
            Rec.SetRange("Teacher No.", vTeacher)
        else
            Rec.SetRange("Teacher No.");

        if vClass <> '' then
            Rec.SetRange(Class, vClass)
        else
            Rec.SetRange(Class);

        if vSubject <> '' then
            Rec.SetRange(Subject, vSubject)
        else
            Rec.SetRange(Subject);

        if (VarTurn <> '') then
            Rec.SetRange(Turn, VarTurn)
        else
            Rec.SetRange(Turn);



        if vTimetableCode <> '' then
            Rec.SetRange("Timetable Code", vTimetableCode);

        if (vSchoolYear <> '') and (vTeacher <> '') or (vClass <> '') then
            Rec.SetRange("Timetable Code");

        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure SetOnOperFormFilters(pSchoolYear: Code[9]; pStartDate: Date; pEndDate: Date; pTimetableCode: Code[20])
    begin
        vSchoolYear := pSchoolYear;
        vStartDate := pStartDate;
        vEndDate := pEndDate;
        vTimetableCode := pTimetableCode;
    end;

    //[Scope('OnPrem')]
    procedure SetEditableSubform()
    begin
        if Rec."Type Subject" = Rec."Type Subject"::Subject then begin
            SubAbsenceLectureEditable := true;
            SubGeneralAbsenceEditable := true;
        end;
        if (Rec."Type Subject" = Rec."Type Subject"::"Non lective Component") or (Rec."Type Subject" = Rec."Type Subject"::Other) then begin
            SubAbsenceLectureEditable := true;
            SubGeneralAbsenceEditable := true;
        end;
    end;

    //[Scope('OnPrem')]
    procedure FilterSubform()
    begin
        SubAbsenceLectureEditable := false;
        SubGeneralAbsenceEditable := false;
    end;

    //[Scope('OnPrem')]
    procedure FilterDate()
    begin
        if (vStartDate <> 0D) and (vEndDate <> 0D) then
            Rec.SetRange("Filter Period", vStartDate, vEndDate)
        else
            Rec.SetRange("Filter Period");


        if vTimetableCode <> '' then
            Rec.SetRange("Timetable Code", vTimetableCode)
        else
            Rec.SetRange("Timetable Code");
    end;

    local procedure vClassOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure vSchoolYearOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure vStartDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure vSubjectOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure vEndDateOnAfterValidate()
    begin
        //SetFormFilters;
        CurrPage.Update(false);
    end;

    local procedure vTeacherOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure VarTurnOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        SetEditableSubform;
        CurrPage.SubAbsenceLectur1.PAGE.SendHeader(Rec);
        CurrPage.SubAbsenceLectur2.PAGE.SendHeader(Rec);
        CurrPage.SubGeneralAbsence.PAGE.SendHeader(Rec);
    end;
}

#pragma implicitwith restore

