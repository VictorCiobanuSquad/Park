#pragma implicitwith disable
page 31009851 "Student Incid. Justify"
{
    Caption = 'Student Incid. Justify';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData Absence = rimd;
    SourceTable = Absence;
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
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));

                    trigger OnValidate()
                    begin
                        vSchoolYearOnAfterValidate;
                    end;
                }
                field(vStudyPlan; vStudyPlan)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rStudyPlanHeader: Record "Study Plan Header";
                        cStudentsRegistration: Codeunit "Students Registration";
                        rRegistrationClassTEMP: Record "Registration Class" temporary;
                        VarInt: Integer;
                    begin
                        rRegistrationClassTEMP.DeleteAll;
                        VarInt := 0;

                        rStudyPlanHeader.Reset;
                        rStudyPlanHeader.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                        rStudyPlanHeader.SetFilter("Schooling Year", '<>%1', '');
                        if cUserEducation.GetEducationFilter(UserId) <> '' then
                            rStudyPlanHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                        if rStudyPlanHeader.Find('-') then begin
                            repeat
                                VarInt += 10000;
                                rRegistrationClassTEMP.Init;
                                rRegistrationClassTEMP."School Year" := rStudyPlanHeader."School Year";
                                rRegistrationClassTEMP."Schooling Year" := rStudyPlanHeader."Schooling Year";
                                rRegistrationClassTEMP."Study Plan Code" := rStudyPlanHeader.Code;
                                rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Simple;
                                rRegistrationClassTEMP."Last Name" := rStudyPlanHeader.Description;
                                rRegistrationClassTEMP."Responsibility Center" := rStudyPlanHeader."Responsibility Center";
                                rRegistrationClassTEMP."Line No." := VarInt;
                                rRegistrationClassTEMP.Insert;
                            until rStudyPlanHeader.Next = 0;
                        end;


                        rCourseHeader.Reset;
                        if cUserEducation.GetEducationFilter(UserId) <> '' then
                            rCourseHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                        if rCourseHeader.Find('-') then begin
                            repeat
                                rRegistration.Reset;
                                rRegistration.SetCurrentKey("School Year", "Schooling Year", Course);
                                rRegistration.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                                rRegistration.SetRange("Responsibility Center", rCourseHeader."Responsibility Center");
                                rRegistration.SetRange(Course, rCourseHeader.Code);
                                if rRegistration.Find('-') then begin
                                    repeat

                                        rRegistrationClassTEMP.Reset;
                                        rRegistrationClassTEMP.SetRange("Study Plan Code", rRegistration.Course);
                                        rRegistrationClassTEMP.SetRange("School Year", rRegistration."School Year");
                                        rRegistrationClassTEMP.SetRange("Schooling Year", rRegistration."Schooling Year");
                                        rRegistrationClassTEMP.SetRange(Type, rRegistrationClassTEMP.Type::Multi);
                                        rRegistrationClassTEMP.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                        if not rRegistrationClassTEMP.Find('-') then begin
                                            rRegistrationClassTEMP.Init;
                                            VarInt += 10000;
                                            rRegistrationClassTEMP."School Year" := rRegistration."School Year";
                                            rRegistrationClassTEMP."Schooling Year" := rRegistration."Schooling Year";
                                            rRegistrationClassTEMP."Study Plan Code" := rCourseHeader.Code;
                                            rRegistrationClassTEMP."Last Name" := rCourseHeader.Description;
                                            rRegistrationClassTEMP."Responsibility Center" := rCourseHeader."Responsibility Center";
                                            rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Multi;
                                            rRegistrationClassTEMP."Line No." := VarInt;
                                            rRegistrationClassTEMP.Insert;
                                        end;
                                    until rRegistration.Next = 0;
                                end;
                            until rCourseHeader.Next = 0;
                        end;


                        rRegistrationClassTEMP.Reset;
                        if PAGE.RunModal(PAGE::"Study Plan List Temp", rRegistrationClassTEMP) = ACTION::LookupOK then begin
                            if GetType(rRegistrationClassTEMP."Schooling Year") = 0 then begin
                                if rStudyPlanHeader.Get(rRegistrationClassTEMP."Study Plan Code") then begin
                                    vStudyPlan := rRegistrationClassTEMP."Study Plan Code";
                                    vType := vType::Simple;
                                    vSchoolYear := rRegistrationClassTEMP."School Year";
                                end;
                            end;
                            if GetType(rRegistrationClassTEMP."Schooling Year") = 1 then begin
                                if rCourseHeader.Get(rRegistrationClassTEMP."Study Plan Code") then begin
                                    vStudyPlan := rRegistrationClassTEMP."Study Plan Code";
                                    vType := vType::Multi;
                                    vSchoolYear := rRegistrationClassTEMP."School Year";
                                end;
                            end;
                        end;




                        SetFormFilters;
                    end;

                    trigger OnValidate()
                    begin
                        if rStudyPlanHeader.Get(vStudyPlan) then begin
                            vStudyPlan := rStudyPlanLines.Code;
                            vType := vType::Simple;
                        end else begin
                            if rCourseHeader.Get(vStudyPlan) then begin
                                vStudyPlan := rCourseHeader.Code;
                                vType := vType::Multi;
                            end;
                        end;
                        vStudyPlanOnAfterValidate;
                    end;
                }
                field(txtClass; vClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        rClass.Reset;
                        if vSchoolYear <> '' then
                            rClass.SetRange("School Year", vSchoolYear);
                        if vStudyPlan <> '' then
                            rClass.SetRange("Study Plan Code", vStudyPlan);
                        if rClass.Find('-') then
                            if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                                vSchoolYear := rClass."School Year";
                                vClass := rClass.Class;
                                vStudyPlan := rClass."Study Plan Code";
                                vType := rClass.Type;
                            end;

                        SetFormFilters;
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        vClassOnAfterValidate;
                    end;
                }
                field(vStudent; vStudent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rRegistrationClass.Reset;
                        if vSchoolYear <> '' then
                            rRegistrationClass.SetRange("School Year", vSchoolYear);
                        if vStudyPlan <> '' then
                            rRegistrationClass.SetRange("Study Plan Code", vStudyPlan);
                        if vClass <> '' then
                            rRegistrationClass.SetRange(Class, vClass);
                        if rRegistrationClass.Find('-') then
                            if PAGE.RunModal(PAGE::"Registration Class List", rRegistrationClass) = ACTION::LookupOK then begin
                                vStudent := rRegistrationClass."Student Code No.";
                                SetFormFilters;
                            end;
                    end;

                    trigger OnValidate()
                    begin
                        vStudentOnAfterValidate;
                    end;
                }
                field(vSubject; vSubject)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subject';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rStruEduCountry: Record "Structure Education Country";
                    begin
                        if vType = vType::Simple then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, vStudyPlan);
                            rStudyPlanLines.SetRange("School Year", vSchoolYear);
                            if rStudyPlanLines.Find('-') then begin
                                if PAGE.RunModal(31009842, rStudyPlanLines) = ACTION::LookupOK then begin
                                    vSubject := rStudyPlanLines."Subject Code";

                                    SetFormFilters;
                                end;
                            end
                        end else begin
                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.DeleteAll;

                            //Quadriennal
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, vStudyPlan);
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Anual
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, vStudyPlan);
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                            if rClass.Get(vClass, vSchoolYear) then
                                rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Bienal E Triennal
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            if rClass.Get(vClass, vSchoolYear) then
                                rStruEduCountry.SetRange("Schooling Year", rClass."Schooling Year");
                            if rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, vStudyPlan);
                                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", rClass."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                                //ELSE BEGIN
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(vClass, vSchoolYear) - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, vStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(vClass, vSchoolYear) - 2);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, vStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(vClass, vSchoolYear) - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, vStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;


                            end;


                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.SetRange(Code, vStudyPlan);
                            if rCourseLinesTEMP.Find('-') then
                                if PAGE.RunModal(PAGE::"Study Course Subjects", rCourseLinesTEMP) = ACTION::LookupOK then begin
                                    vSubject := rCourseLinesTEMP."Subject Code";
                                    SetFormFilters;
                                end;
                        end;



                        CurrPage.Update(false);
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

                        //SetFormFilters;
                        //  vStartDateOnAfterValidate;
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
            group("&Justify Absences")
            {
                Caption = '&Justify Absences';
                Image = Absence;
                Visible = true;
                action("Justify &Student Absences - All Day(s)")
                {
                    Caption = 'Justify &Student Absences - All Day(s)';
                    Image = ImplementRegAbsence;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

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
                    Caption = 'Insert Absences &Class - All Day(s)';
                    Image = WorkCenterAbsence;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

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
    end;

    trigger OnInit()
    begin
        Clear(vSchoolYear);
        Clear(vStudyPlan);
        Clear(vClass);
        Clear(vSubject);
        Clear(vStartDate);
        Clear(vEndDate);
        Clear(vStudent);

        Rec.Reset;
        Rec.SetRange("Timetable Code");
        Rec.SetRange("School Year");
        Rec.SetRange("Study Plan");
        Rec.SetRange(Class);
        Rec.SetRange(Day);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
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
        vSubject: Code[10];
        vStartDate: Date;
        vEndDate: Date;
        vStudent: Code[20];
        vStudyPlan: Code[20];
        Text0001: Label 'School Year must not be blank.';
        Text0002: Label 'Study Plan must not be blank.';
        Text0003: Label 'Class must not be blank.';
        vType: Option Simple,Multi;
        cUserEducation: Codeunit "User Education";
        cStudentsRegistration: Codeunit "Students Registration";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rStruEduCountry: Record "Structure Education Country";
        Text0005: Label 'Inserting Class is Mandatory.';
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
        SetFormFilters;

        CurrPage.Update(false);
    end;

    local procedure vStudentOnAfterValidate()
    begin
        SetFormFilters;
    end;

    local procedure vStudyPlanOnAfterValidate()
    begin
        SetFormFilters;
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
}

#pragma implicitwith restore

