#pragma implicitwith disable
page 52852 "Teacher Incid. Justify"
{
    Caption = 'Teacher Incid. Justify';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
    SourceTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.")
                      ORDER(Ascending)
                      WHERE("Student/Teacher" = FILTER(Teacher),
                            "Absence Status" = FILTER(<> Justified));

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
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
                            if vSchoolYear <> '' then
                                rClass.SetRange("School Year", vSchoolYear);
                            if rClass.Find('-') then
                                if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                    vClass := rClass.Class;
                                    vSchoolYear := rClass."School Year";
                                end;
                            SetFormFilters;
                        end;


                        if vTeacher <> '' then begin
                            rClassTemp.DeleteAll;

                            rTeacherClasslist.Reset;
                            rTeacherClasslist.SetRange("Full Name", vTeacher);
                            if rTeacherClasslist.Find('-') then begin
                                repeat
                                    rClassTemp.Reset;
                                    rClassTemp.SetRange(Class, rTeacherClasslist.User);

                                    if not rClassTemp.Find('-') then begin
                                        if rClass.Get(rTeacherClasslist.User, rTeacherClasslist."User Type") then begin
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
                                vSchoolYear := rClass."School Year";
                                SetFormFilters;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        rClass.Reset;
                        rClass.SetRange(Class, vClass);
                        if rClass.Find('-') then
                            vSchoolYear := rClass."School Year";
                        vClassOnAfterValidate;
                    end;
                }
                field(vTeacher; vTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher';
                    TableRelation = Teacher."No.";

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTeacherClass: Record "Timetable-Teacher";
                        rTeacherClassTEMP: Record "Timetable-Teacher" temporary;
                    begin
                        if vClass = '' then begin
                            rTeacherClasslist.Reset;
                            if vSchoolYear <> '' then
                                rTeacherClasslist.SetRange("School Year", vSchoolYear);
                            rTeacherClasslist.SetRange(rTeacherClasslist."User Type", rTeacherClasslist."User Type"::Teacher);
                            if rTeacherClasslist.Find('-') then
                                if PAGE.RunModal(PAGE::"Teacher Class List", rTeacherClasslist) = ACTION::LookupOK then begin
                                    vTeacher := rTeacherClasslist.User;
                                    vSchoolYear := rTeacherClasslist."School Year";
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
                        rTeacherClasslist.Reset;
                        rTeacherClasslist.SetRange(rTeacherClasslist."User Type", rTeacherClasslist."User Type"::Teacher);
                        rTeacherClasslist.SetRange(User, vTeacher);
                        if rTeacherClasslist.Find('-') then
                            vSchoolYear := rTeacherClasslist."School Year";
                        vTeacherOnAfterValidate;
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
                            rTeacherClasslist.SetRange(Class, vClass);
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
                field(vStartDate; vStartDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnValidate()
                    begin
                        vEndDate := vStartDate;
                        vStartDateOnAfterValidate;
                    end;
                }
                field(vEndDate; vEndDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnValidate()
                    begin
                        vEndDateOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110015)
            {
                ShowCaption = false;
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
                    Editable = false;
                }
                field("Student/Teacher Code No."; Rec."Student/Teacher Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher Code No.';
                    Editable = false;
                }
                field("Student Name"; Rec."Student Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                }
                field("Absence Status"; Rec."Absence Status")
                {
                    ApplicationArea = Basic, Suite;
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
                field("Absence Type"; Rec."Absence Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Incidence Description"; Rec."Incidence Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Justified Code"; Rec."Justified Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Justified Description"; Rec."Justified Description")
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
                        if rClass.Get(Rec.Class, Rec."School Year") then;


                        fObserAbsence.GetInformation(Rec, rClass."Schooling Year", true);

                        fObserAbsence.GetStatusJustified(Rec."Absence Status");
                        fObserAbsence.Run;
                    end;
                }
                field("Results in loss of pay"; Rec."Results in loss of pay")
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
            group("&Justify Absences")
            {
                Caption = '&Justify Absences';
                Image = Absence;
                Visible = true;
                action("Justify Absences All &Day(s)")
                {
                    ApplicationArea = All;
                    Caption = 'Justify Absences All &Day(s)';
                    Image = AbsenceCalendar;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if (vSchoolYear <> '') then begin
                            fJustAbsencesWizard.SetFormFilter('', 1, vStartDate, vEndDate, Rec."School Year", '');  //0 - Aluno  1-Professor   2-Turma
                            fJustAbsencesWizard.Run;
                        end else
                            Message(Text0001);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Clear(vClass);
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        Rec.SetRange(Day, 0D);
    end;

    var
        rClass: Record Class;
        rStudyPlanLines: Record "Study Plan Lines";
        vSchoolYear: Code[9];
        vClass: Code[20];
        vSubject: Code[10];
        vStartDate: Date;
        vEndDate: Date;
        vTeacher: Code[20];
        Text0001: Label 'School Year must not be blank.';
        Text0002: Label 'Study Plan must not be blank.';
        Text0003: Label 'Class must not be blank.';
        rSubjects: Record Subjects;
        rTeacher: Record Teacher;
        rTeacherClasslist: Record "Teacher Class";
        cUserEducation: Codeunit "User Education";
        fJustAbsencesWizard: Page "Justify Absences Wizard";


    procedure SetFormFilters()
    begin
        if vSchoolYear <> '' then
            Rec.SetRange("School Year", vSchoolYear)
        else
            Rec.SetRange("School Year");

        if vClass <> '' then
            Rec.SetRange(Class, vClass)
        else
            Rec.SetRange(Class);

        if vSubject <> '' then
            Rec.SetRange(Subject, vSubject)
        else
            Rec.SetRange(Subject);

        if vTeacher <> '' then
            Rec.SetRange("Student/Teacher Code No.", vTeacher)
        else
            Rec.SetRange("Student/Teacher Code No.");

        if (vStartDate <> 0D) and (vEndDate <> 0D) then
            Rec.SetRange(Day, vStartDate, vEndDate)
        else begin
            if (vStartDate <> 0D) then
                Rec.SetRange(Day, vStartDate)
            else
                Rec.SetRange(Day);

            if (vEndDate <> 0D) then
                Rec.SetRange(Day, vEndDate)
            else
                Rec.SetRange(Day);
        end;

        if (vSchoolYear <> '') and (vClass <> '') and (vTeacher <> '') then
            Rec.SetRange("Timetable Code");

        CurrPage.Update(false);
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
        SetFormFilters;

        CurrPage.Update(false);
    end;

    local procedure vSubjectOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure vEndDateOnAfterValidate()
    begin
        SetFormFilters;
        CurrPage.Update(false);
    end;

    local procedure vTeacherOnAfterValidate()
    begin
        SetFormFilters;
    end;
}

#pragma implicitwith restore

