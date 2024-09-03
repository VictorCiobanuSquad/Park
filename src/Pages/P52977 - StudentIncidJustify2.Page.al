#pragma implicitwith disable
page 52977 "Student Incid. Justify2"
{
    Caption = 'Student Incid. Justify';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
    SourceTableTemporary = true;
    SourceTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.")
                      ORDER(Ascending)
                      WHERE("Student/Teacher" = FILTER(Student),
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
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Closing));

                    trigger OnValidate()
                    begin
                        vSchoolYearOnAfterValidate;
                    end;
                }
                field(txtClass; vClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        Clear(TempClass);
                        cPermissions.ClassFilter(TempClass, 3);
                        if vSchoolYear <> '' then
                            TempClass.SetRange("School Year", vSchoolYear);
                        if TempClass.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Class List", TempClass) = ACTION::LookupOK then begin
                                vClass := TempClass.Class;
                                vSchoolYear := TempClass."School Year";
                                vSchoolingYear := TempClass."Schooling Year";
                                vType := TempClass.Type;
                                vStudyPlan := TempClass."Study Plan Code";
                            end;
                        end else
                            Error(Text0005);

                        SetFormFilters;
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        vClassOnAfterValidate;
                    end;
                }
                field(txtSubject; vSubject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rStruEduCountry: Record "Structure Education Country";
                        TempStudyPlanLines: Record "Study Plan Lines" temporary;
                        TempCourseLines: Record "Course Lines" temporary;
                    begin
                        if vClass <> '' then begin
                            if vType = vType::Simple then begin
                                Clear(TempStudyPlanLines);
                                cPermissions.SubjectFilter(vType, vSchoolYear, vClass, vStudyPlan, vSchoolingYear,
                                                           TempStudyPlanLines, TempCourseLines, 3);
                                if TempStudyPlanLines.FindSet then begin
                                    if PAGE.RunModal(PAGE::"List Subjects", TempStudyPlanLines) = ACTION::LookupOK then begin
                                        vSubject := TempStudyPlanLines."Subject Code";
                                        SetFormFilters;

                                    end;
                                end;
                            end else begin
                                //multi
                                Clear(TempCourseLines);
                                cPermissions.SubjectFilter(vType, vSchoolYear, vClass, vStudyPlan, vSchoolingYear,
                                                           TempStudyPlanLines, TempCourseLines, 3);
                                if TempCourseLines.FindSet then begin
                                    if PAGE.RunModal(PAGE::"List Course Lines", TempCourseLines) = ACTION::LookupOK then begin
                                        vSubject := TempCourseLines."Subject Code";
                                        SetFormFilters;

                                    end;
                                end;
                            end;
                            CurrPage.Update(false);
                        end else
                            Error(Text0004);
                    end;

                    trigger OnValidate()
                    begin
                        vSubjectOnAfterValidate;
                    end;
                }
                field(txtStudent; vStudent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if vClass <> '' then begin
                            rRegistrationClass.Reset;
                            if vSchoolYear <> '' then
                                rRegistrationClass.SetRange("School Year", vSchoolYear);
                            rRegistrationClass.SetRange("Study Plan Code", vStudyPlan);
                            rRegistrationClass.SetRange(Class, vClass);
                            if rRegistrationClass.Find('-') then
                                if PAGE.RunModal(PAGE::"Registration Class List", rRegistrationClass) = ACTION::LookupOK then begin
                                    vStudent := rRegistrationClass."Student Code No.";
                                    SetFormFilters;
                                end;
                        end else
                            Error(Text0004);
                    end;

                    trigger OnValidate()
                    begin
                        vStudentOnAfterValidate;
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
                    Editable = SubjectEditable;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Student/Teacher Code No."; Rec."Student/Teacher Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student Code No.';
                    Editable = false;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Type"; Rec."Absence Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        AbsenceTypeOnAfterValidate;
                    end;
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

                    trigger OnValidate()
                    begin
                        AbsenceStatusOnAfterValidate;
                    end;
                }
                field("Justified Code"; Rec."Justified Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Justified Description"; Rec."Justified Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Absence Hours"; Rec."Absence Hours")
                {
                    ApplicationArea = Basic, Suite;
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Justify Absences")
            {
                Caption = 'Justify Absences';
                Visible = true;
                action("Justify &Student Absences - All Day(s)")
                {
                    ApplicationArea = All;
                    Caption = 'Justify &Student Absences - All Day(s)';

                    trigger OnAction()
                    begin
                        if (vClass <> '') then begin
                            fJustAbsencesWizard.SetFormFilter(Rec."Timetable Code", 0, vStartDate, vEndDate, Rec."School Year", Rec.Class);
                            //0 - Aluno  1-Professor   2-Turma
                            fJustAbsencesWizard.Run;
                        end else
                            Message(Text0005);
                    end;
                }
                action("Insert Absences &Class - All Day(s)")
                {
                    ApplicationArea = All;
                    Caption = 'Insert Absences &Class - All Day(s)';

                    trigger OnAction()
                    begin

                        if (vClass <> '') then begin
                            fJustAbsencesWizard.SetFormFilter(Rec."Timetable Code", 2, vStartDate, vEndDate, Rec."School Year", Rec.Class);
                            //0 - Aluno  1-Professor   2-Turma
                            fJustAbsencesWizard.Run;
                        end else
                            Message(Text0005);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditSubject;
        OnAfterGetCurrRecord2;
        ObservationsOnFormat;
    end;

    trigger OnModifyRecord(): Boolean
    begin

        rAbsence.Reset;
        if rAbsence.Get(Rec."Timetable Code", Rec."School Year", Rec."Study Plan", Rec.Class, Rec.Day, Rec.Type, Rec."Line No. Timetable",
          Rec."Incidence Type", Rec."Incidence Code", Rec.Category, Rec."Subcategory Code", Rec."Student/Teacher",
          Rec."Student/Teacher Code No.", Rec."Responsibility Center", Rec."Line No.") then begin

            rAbsence."Absence Status" := Rec."Absence Status";
            rAbsence.Observations := Rec.Observations;
            rAbsence."Creation Date" := Rec."Creation Date";
            rAbsence."Creation User" := Rec."Creation User";
            rAbsence."Modified Date" := Rec."Modified Date";
            rAbsence."Modified User" := Rec."Modified User";
            rAbsence."Absence Type" := Rec."Absence Type";
            rAbsence."Incidence Description" := Rec."Incidence Description";
            rAbsence."Justified Code" := Rec."Justified Code";
            rAbsence."Justified Description" := Rec."Justified Description";
            rAbsence."Absence Hours" := Rec."Absence Hours";
            rAbsence.Modify(true);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    var
        rAbsence: Record Absence;
        rTeacherClass: Record "Teacher Class";
    begin
        Clear(Rec);
        Clear(vSchoolYear);
        Clear(vStudyPlan);
        Clear(vClass);
        Clear(vSubject);
        Clear(vStartDate);
        Clear(vEndDate);
        Clear(vStudent);

        Rec.Reset;
        //********PERMISSOES***************
        rAbsence.Reset;
        rAbsence.SetRange(rAbsence."Incidence Type", rAbsence."Incidence Type"::Absence);
        rAbsence.SetRange(rAbsence."Student/Teacher", rAbsence."Student/Teacher"::Student);
        rAbsence.SetFilter(rAbsence."Absence Status", '<>%1', rAbsence."Absence Status"::Justified);
        if rAbsence.Find('-') then begin
            repeat
                rTeacherClass.Reset;
                rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                rTeacherClass.SetRange(rTeacherClass."School Year", rAbsence."School Year");
                rTeacherClass.SetRange(rTeacherClass."Schooling Year", '');
                if rTeacherClass.FindFirst then begin
                    Rec.Init;
                    Rec.TransferFields(rAbsence);
                    Rec.Insert;
                end else begin
                    rTeacherClass.Reset;
                    rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                    rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                    rTeacherClass.SetRange(rTeacherClass."School Year", rAbsence."School Year");
                    rTeacherClass.SetRange(rTeacherClass."Schooling Year", rAbsence."Schooling Year");
                    rTeacherClass.SetRange(rTeacherClass.Class, '');
                    if rTeacherClass.FindFirst then begin
                        Rec.Init;
                        Rec.TransferFields(rAbsence);
                        Rec.Insert;
                    end else begin
                        rTeacherClass.Reset;
                        rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                        rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                        rTeacherClass.SetRange(rTeacherClass."School Year", rAbsence."School Year");
                        rTeacherClass.SetRange(rTeacherClass."Schooling Year", rAbsence."Schooling Year");
                        rTeacherClass.SetRange(rTeacherClass.Class, rAbsence.Class);
                        rTeacherClass.SetRange(rTeacherClass."Subject Code", '');
                        if rTeacherClass.FindFirst then begin
                            Rec.Init;
                            Rec.TransferFields(rAbsence);
                            Rec.Insert;
                        end else begin
                            rTeacherClass.Reset;
                            rTeacherClass.SetRange(rTeacherClass."Allow Justify Incidence", true);
                            rTeacherClass.SetRange(rTeacherClass."NAV User Id", UserId);
                            rTeacherClass.SetRange(rTeacherClass."School Year", rAbsence."School Year");
                            rTeacherClass.SetRange(rTeacherClass."Schooling Year", rAbsence."Schooling Year");
                            rTeacherClass.SetRange(rTeacherClass.Class, rAbsence.Class);
                            rTeacherClass.SetRange(rTeacherClass."Subject Code", rAbsence.Subject);
                            if rTeacherClass.FindFirst then begin
                                Rec.Init;
                                Rec.TransferFields(rAbsence);
                                Rec.Insert;
                            end;
                        end;
                    end;
                end;
            until rAbsence.Next = 0;
        end;


        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        Rec.SetRange(Day, 0D);
    end;

    var
        rStudyPlanHeader: Record "Study Plan Header";
        rStructureEducCountry: Record "Structure Education Country";
        rClass: Record Class;
        rStudyPlanLines: Record "Study Plan Lines";
        rRegistrationClass: Record "Registration Class";
        rRegistrationSubjects: Record "Registration Subjects";
        rCalendar: Record Calendar;
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rRegistration: Record Registration;
        vClass: Code[20];
        vSchoolYear: Code[10];
        vSchoolingYear: Code[10];
        vSubject: Code[10];
        vStartDate: Date;
        vEndDate: Date;
        vStudent: Code[20];
        vStudyPlan: Code[20];
        Text0001: Label 'School Year must not be blank.';
        Text0002: Label 'Study Plan must not be blank.';
        vType: Option Simple,Multi;
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rStruEduCountry: Record "Structure Education Country";
        TempClass: Record Class temporary;
        cPermissions: Codeunit Permissions;
        Text0004: Label 'Class must not be blank.';
        Text0005: Label 'You don''t have permissions.';
        rAbsence: Record Absence;
        [InDataSet]
        SubjectEditable: Boolean;
        fJustAbsencesWizard: Page "Justify Absences Wizard";

    //[Scope('OnPrem')]
    procedure SetFormFilters()
    begin

        if vSchoolYear <> '' then
            Rec.SetRange("School Year", vSchoolYear)
        else
            Rec.SetRange("School Year");

        if vStudyPlan <> '' then begin
            Rec.SetRange(Type, vType);
            Rec.SetRange("Study Plan", vStudyPlan);
        end else begin
            Rec.SetRange(Type);
            Rec.SetRange("Study Plan");
        end;

        if vClass <> '' then
            Rec.SetRange(Class, vClass)
        else
            Rec.SetRange(Class);

        if vSubject <> '' then
            Rec.SetRange(Subject, vSubject)
        else
            Rec.SetRange(Subject);

        if vStudent <> '' then
            Rec.SetRange("Student/Teacher Code No.", vStudent)
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

        if (vSchoolYear <> '') and (vStudyPlan <> '') and (vClass <> '') and (vStudent <> '') then
            Rec.SetRange("Timetable Code");

        CurrPage.Update;
    end;

    //[Scope('OnPrem')]
    procedure EditSubject()
    begin
        rStudyPlanHeader.Reset;
        rStudyPlanHeader.SetRange(Code, vStudyPlan);
        if rStudyPlanHeader.Find('-') then begin
            rStructureEducCountry.Reset;
            rStructureEducCountry.SetRange(Country, rStudyPlanHeader."Country/Region Code");
            rStructureEducCountry.SetRange("Schooling Year", rStudyPlanHeader."Schooling Year");
            rStructureEducCountry.SetRange(Level, rStructureEducCountry.Level::"1º Cycle");
            if rStructureEducCountry.Find('-') then begin
                SubjectEditable := false;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetType(pSchoolingYear: Code[10]): Integer
    var
        l_StructureEducationCountry: Record "Structure Education Country";
    begin
        l_StructureEducationCountry.Reset;
        l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        l_StructureEducationCountry.SetRange("Schooling Year", pSchoolingYear);
        if l_StructureEducationCountry.FindSet then
            exit(l_StructureEducationCountry.Type);
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(pClass: Code[20]; pSchoolYear: Code[9]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if rClass.Get(pClass, pSchoolYear) then;

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    local procedure vClassOnAfterValidate()
    begin
        if vClass <> '' then begin
            Clear(TempClass);
            cPermissions.ClassFilter(TempClass, 2);

            TempClass.SetFilter(TempClass."School Year", cStudentsRegistration.GetShoolYearActiveClosing);
            TempClass.SetRange(TempClass.Class, vClass);
            if TempClass.FindFirst then begin
                vClass := TempClass.Class;
                vSchoolYear := TempClass."School Year";
                vSchoolingYear := TempClass."Schooling Year";
                vType := TempClass.Type;
                vStudyPlan := TempClass."Study Plan Code";
            end else
                Error(Text0005);

        end else begin
            vStudyPlan := '';
            vSubject := '';
            vStudent := '';
        end;

        SetFormFilters;
        CurrPage.Update;
    end;

    local procedure vSchoolYearOnAfterValidate()
    begin
        if vSchoolYear = '' then begin
            vClass := '';
            vStudyPlan := '';
            vSubject := '';
            vStudent := '';
        end;

        SetFormFilters;
    end;

    local procedure vStartDateOnAfterValidate()
    begin
        SetFormFilters;
        CurrPage.Update(false);
    end;

    local procedure vSubjectOnAfterValidate()
    var
        TempStudyPlanLines: Record "Study Plan Lines" temporary;
        TempCourseLines: Record "Course Lines" temporary;
    begin
        if vSubject <> '' then begin
            if vClass <> '' then begin
                if vType = vType::Simple then begin
                    Clear(TempStudyPlanLines);
                    cPermissions.SubjectFilter(vType, vSchoolYear, vClass, vStudyPlan, vSchoolingYear,
                                               TempStudyPlanLines, TempCourseLines, 3);

                    TempStudyPlanLines.SetRange(TempStudyPlanLines.Code, vStudyPlan);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."School Year", vSchoolYear);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."Schooling Year", vSchoolingYear);
                    TempStudyPlanLines.SetRange(TempStudyPlanLines."Subject Code", vSubject);
                    if TempStudyPlanLines.FindFirst then begin
                        vSubject := TempStudyPlanLines."Subject Code";
                        SetFormFilters;
                    end else
                        Error(Text0005);

                end else begin
                    Clear(TempCourseLines);
                    cPermissions.SubjectFilter(vType, vSchoolYear, vClass, vStudyPlan, vSchoolingYear,
                                               TempStudyPlanLines, TempCourseLines, 3);

                    TempCourseLines.SetRange(TempCourseLines.Code, vStudyPlan);
                    TempCourseLines.SetRange(TempCourseLines."Temp School Year", vSchoolYear);
                    TempCourseLines.SetRange(TempCourseLines."Schooling Year Begin", vSchoolingYear);
                    TempCourseLines.SetRange(TempCourseLines."Subject Code", vSubject);
                    if TempCourseLines.FindFirst then begin
                        vSubject := TempCourseLines."Subject Code";
                        SetFormFilters;
                    end else
                        Error(Text0005);
                end;

            end else
                Error(Text0004);
        end;

        //SetFormFilters;
        CurrPage.Update(false);
    end;

    local procedure vEndDateOnAfterValidate()
    begin
        SetFormFilters;

        CurrPage.Update(false);
    end;

    local procedure vStudentOnAfterValidate()
    begin
        if vStudent <> '' then begin
            if vClass = '' then
                Error(Text0004);

        end;
        SetFormFilters;
        CurrPage.Update;
    end;

    local procedure AbsenceTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure AbsenceStatusOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        EditSubject;
    end;

    local procedure ObservationsOnFormat()
    begin
        rAbsence.Reset;
        if rAbsence.Get(Rec."Timetable Code", Rec."School Year", Rec."Study Plan", Rec.Class, Rec.Day, Rec.Type, Rec."Line No. Timetable",
          Rec."Incidence Type", Rec."Incidence Code", Rec.Category, Rec."Subcategory Code", Rec."Student/Teacher",
          Rec."Student/Teacher Code No.", Rec."Responsibility Center", Rec."Line No.") then begin

            Rec.Observations := rAbsence.Observations;
            Rec.Modify;
        end;
    end;
}

#pragma implicitwith restore

