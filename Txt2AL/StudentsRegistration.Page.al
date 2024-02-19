#pragma implicitwith disable
page 31009860 "Students Registration"
{
    Caption = 'Students Registration';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Registration;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SchoolYear; SchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.Reset;
                        rSchoolYear.Reset;
                        rSchoolYear.SetFilter(Status, '%1|%2', rSchoolYear.Status::Active, rSchoolYear.Status::Planning);
                        if PAGE.RunModal(0, rSchoolYear) = ACTION::LookupOK then begin
                            SchoolYear := rSchoolYear."School Year";
                            SchoolingYear := '';
                            CourseCode := '';
                            ClassCode := '';
                            ServicePlanCode := '';

                            Rec.DeleteAll;
                            CurrPage.Update(false);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SchoolYearOnAfterValidate;
                    end;
                }
                field(SchoolingYear; SchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rCompanyInfo.Get;
                        rStructureEducationCountry.Reset;
                        rStructureEducationCountry.SetRange(Country, rCompanyInfo."Country/Region Code");

                        if PAGE.RunModal(0, rStructureEducationCountry) = ACTION::LookupOK then begin
                            SchoolingYear := rStructureEducationCountry."Schooling Year";
                            CourseCode := '';
                            ClassCode := '';
                            ServicePlanCode := '';
                        end;
                        UpdateFilters;
                    end;

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field(tCourse; CourseCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan / Course Code ';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_CourseHeaderTEMP: Record "Course Header" temporary;
                    begin
                        rSchoolYear.Reset;
                        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                        if rSchoolYear.FindFirst then begin

                            rStructureEducationCountry.Reset;
                            rStructureEducationCountry.SetRange("Schooling Year", SchoolingYear);
                            if rStructureEducationCountry.FindFirst then;
                            if rStructureEducationCountry.Type = rStructureEducationCountry.Type::Multi then begin
                                rScoolingYear1.Reset;
                                rScoolingYear1.SetRange("Edu. Level", rStructureEducationCountry."Edu. Level");
                                rScoolingYear1.SetRange(Level, rStructureEducationCountry.Level);
                                if rScoolingYear1.FindFirst then begin
                                    rCourseHeader.Reset;
                                    rCourseHeader.SetRange("Schooling Year Begin", rScoolingYear1."Schooling Year");
                                    if rCourseHeader.FindSet then begin
                                        repeat
                                            l_CourseHeaderTEMP.Reset;
                                            l_CourseHeaderTEMP.SetRange(Code, rCourseHeader.Code);
                                            if not l_CourseHeaderTEMP.FindSet then begin
                                                l_CourseHeaderTEMP.Init;
                                                l_CourseHeaderTEMP.TransferFields(rCourseHeader);
                                                l_CourseHeaderTEMP.Insert;

                                            end;
                                        until rCourseHeader.Next = 0;
                                    end;
                                end;

                                l_CourseHeaderTEMP.Reset;
                                if l_CourseHeaderTEMP.FindSet then;

                                if PAGE.RunModal(0, l_CourseHeaderTEMP) = ACTION::LookupOK then begin
                                    CourseCode := l_CourseHeaderTEMP.Code;
                                    ClassCode := '';
                                    ServicePlanCode := '';
                                end;
                            end else begin
                                rStudyPlanHeader.Reset;
                                rStudyPlanHeader.SetRange("School Year", SchoolYear);
                                rStudyPlanHeader.SetRange("Schooling Year", SchoolingYear);
                                if PAGE.RunModal(0, rStudyPlanHeader) = ACTION::LookupOK then begin
                                    CourseCode := rStudyPlanHeader.Code;
                                    ClassCode := '';
                                    ServicePlanCode := '';
                                end;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CourseCodeOnAfterValidate;
                    end;
                }
                field(ClassCode; ClassCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rClass.Reset;
                        rClass.SetRange("School Year", SchoolYear);
                        rClass.SetRange("Schooling Year", SchoolingYear);
                        rClass.SetRange("Study Plan Code", CourseCode);
                        if PAGE.RunModal(0, rClass) = ACTION::LookupOK then
                            ClassCode := rClass.Class;
                    end;
                }
                field(ServicePlanCode; ServicePlanCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Services Plan Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rServicesPlanHead.Reset;
                        rServicesPlanHead.SetRange("School Year", SchoolYear);
                        rServicesPlanHead.SetRange("Schooling Year", SchoolingYear);
                        if CourseCode <> '' then
                            rServicesPlanHead.SetRange("Study Plan Code", CourseCode);
                        if PAGE.RunModal(0, rServicesPlanHead) = ACTION::LookupOK then
                            ServicePlanCode := rServicesPlanHead.Code;

                        if ServicePlanCode <> '' then
                            "Services Plan CodeVisible" := false
                        else
                            "Services Plan CodeVisible" := true;
                    end;

                    trigger OnValidate()
                    begin
                        ServicePlanCodeOnAfterValidate;
                    end;
                }
                repeater(TableBox)
                {
                    field(Selection; Rec.Selection)
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SelectionOnAfterValidate;
                        end;
                    }
                    field("Student Code No."; Rec."Student Code No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field(StudentName; GetStudentName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Name';
                        Editable = false;
                    }
                    field("Services Plan Code"; Rec."Services Plan Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = "Services Plan CodeVisible";
                    }
                    field(Class; Rec.Class)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field(Course; Rec.Course)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Study Plan Code"; Rec."Study Plan Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Apply All Entries")
            {
                Caption = '&Apply All Entries';
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    l_rRegistration: Record Registration;
                begin
                    Rec.Reset;
                    Rec.SetRange(Selection, true);
                    if Rec.FindSet then begin
                        repeat
                            Rec.InsertStudents(Rec);
                        until Rec.Next = 0;
                        Message(Text003);
                    end;

                    Rec.Reset;
                    Rec.DeleteAll;
                    UpdateFilters;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        "Services Plan CodeVisible" := true;
    end;

    trigger OnOpenPage()
    begin
        if ServicePlanCode <> '' then
            "Services Plan CodeVisible" := false
        else
            "Services Plan CodeVisible" := true;
    end;

    var
        rSchoolYear: Record "School Year";
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rRegistration: Record Registration;
        rCompanyInfo: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";
        rScoolingYear1: Record "Structure Education Country";
        rScoolingYear2: Record "Structure Education Country";
        rEduConfiguration: Record "Edu. Configuration";
        rClass: Record Class;
        rRegistrationClass: Record "Registration Class";
        rServicesPlanHead: Record "Services Plan Head";
        SchoolYear: Code[20];
        SchoolingYear: Code[20];
        StudyPlanCode: Code[20];
        CourseCode: Code[20];
        ClassCode: Code[20];
        ServicePlanCode: Code[20];
        CaptionCode: array[30] of Text[30];
        CaptionText: array[30] of Text[100];
        TextORCode: Boolean;
        Text001: Label 'The Subject %1 is %2. In this status can not be modified.';
        Text002: Label 'Do you wish to enroll the student %1 in the class %2?';
        cStudentsRegistration: Codeunit "Students Registration";
        Text003: Label 'Process Finished';
        [InDataSet]
        "Services Plan CodeVisible": Boolean;

    //[Scope('OnPrem')]
    procedure GetStudentName(): Text[250]
    var
        rStudents: Record Students;
    begin
        if rStudents.Get(Rec."Student Code No.") then
            exit(rStudents.Name)
        else
            exit('');
    end;

    //[Scope('OnPrem')]
    procedure UpdateFilters()
    var
        l_rSchoolYear: Record "School Year";
        i: Integer;
        k: Integer;
    begin
        if SchoolingYear <> '' then begin
            Rec.Reset;
            Rec.DeleteAll;

            rRegistration.Reset;
            rRegistration.SetRange(Status, rRegistration.Status::" ");
            rRegistration.SetRange("Schooling Year", SchoolingYear);
            rRegistration.SetRange("School Year", SchoolYear);
            if rRegistration.Find('-') then
                repeat
                    Rec.TransferFields(rRegistration);
                    Rec.Selection := false;
                    Rec.Insert;
                until rRegistration.Next = 0;


            CurrPage.Update(false);
        end;
    end;

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer; IsTextOrCode: Boolean) out: Text[100]
    begin
        if IsTextOrCode then
            exit(CaptionText[label])
        else
            exit(CaptionCode[label]);
    end;

    //[Scope('OnPrem')]
    procedure InsertColunm()
    var
        i: Integer;
    begin
    end;

    //[Scope('OnPrem')]
    procedure GetStudentRegister(p_StudentCode: Code[20]; p_SubjectCode: Code[20]): Boolean
    var
        rRegistrationSubjects: Record "Registration Subjects";
    begin
        if (p_StudentCode <> '') and (p_SubjectCode <> '') then begin
            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange("Student Code No.", p_StudentCode);
            rRegistrationSubjects.SetRange("School Year", SchoolYear);
            if StudyPlanCode <> '' then
                rRegistrationSubjects.SetRange("Study Plan Code", StudyPlanCode);
            if CourseCode <> '' then
                rRegistrationSubjects.SetRange("Study Plan Code", CourseCode);
            rRegistrationSubjects.SetRange("Subjects Code", p_SubjectCode);
            if rRegistrationSubjects.Find('-') then
                exit(rRegistrationSubjects.Enroled)
            else
                exit(false);
        end
        else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure ModifyStudentRegister(p_StudentCode: Code[20]; p_SubjectCode: Code[20]; p_Status: Boolean): Boolean
    var
        rRegistrationSubjects: Record "Registration Subjects";
    begin
        if (p_StudentCode <> '') and (p_SubjectCode <> '') then begin
            rRegistrationSubjects.Reset;
            rRegistrationSubjects.SetRange("Student Code No.", p_StudentCode);
            rRegistrationSubjects.SetRange("School Year", SchoolYear);
            if StudyPlanCode <> '' then
                rRegistrationSubjects.SetRange("Study Plan Code", StudyPlanCode);
            if CourseCode <> '' then
                rRegistrationSubjects.SetRange("Study Plan Code", CourseCode);
            rRegistrationSubjects.SetRange("Subjects Code", p_SubjectCode);
            if rRegistrationSubjects.Find('-') then begin
                if rRegistrationSubjects.Status <> rRegistrationSubjects.Status::" " then
                    Error(Text001, p_SubjectCode, rRegistrationSubjects.Status);
                if p_Status and (Rec.Class <> '') then
                    if Confirm(Text002, true, Rec."Student Code No.", Rec.Class) then
                        cStudentsRegistration.StudentRegSubject(rRegistrationSubjects, Rec, Rec.Class, WorkDate)
                    else begin
                        rRegistrationSubjects.Validate(Enroled, p_Status);
                        rRegistrationSubjects.Modify;
                    end
                else begin
                    rRegistrationSubjects.Validate(Enroled, p_Status);
                    rRegistrationSubjects.Modify;
                end;
                exit(true);
            end else
                exit(false);
        end else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure EditableFuction()
    begin
    end;

    local procedure SelectionOnAfterValidate()
    begin
        if Rec.Selection then begin
            Rec.Class := ClassCode;
            if Rec.Type = Rec.Type::Multi then begin
                if Rec.Course = '' then
                    Rec.Course := CourseCode
            end else begin
                if Rec."Study Plan Code" = '' then
                    Rec."Study Plan Code" := CourseCode;
            end;
            if ServicePlanCode <> '' then
                Rec."Services Plan Code" := ServicePlanCode;
            Rec.Modify;
        end;
    end;

    local procedure CourseCodeOnAfterValidate()
    begin
        if CourseCode <> '' then begin
            rStructureEducationCountry.Reset;
            rStructureEducationCountry.SetRange("Schooling Year", SchoolingYear);
            if rStructureEducationCountry.FindFirst then begin
                if rStructureEducationCountry.Type = rStructureEducationCountry.Type::Multi then begin
                    rScoolingYear1.Reset;
                    rScoolingYear1.SetRange("Edu. Level", rStructureEducationCountry."Edu. Level");
                    rScoolingYear1.SetRange(Level, rStructureEducationCountry.Level);
                    if rScoolingYear1.FindFirst then begin
                        rCourseHeader.Reset;
                        rCourseHeader.SetRange(Code, CourseCode);
                        rCourseHeader.SetRange("Schooling Year Begin", rScoolingYear1."Schooling Year");
                        if not rCourseHeader.FindFirst then
                            CourseCode := '';
                    end;
                end else begin
                    rStudyPlanHeader.Reset;
                    rStudyPlanHeader.SetRange("School Year", SchoolYear);
                    rStudyPlanHeader.SetRange("Schooling Year", SchoolingYear);
                    rStudyPlanHeader.SetRange(Code, CourseCode);
                    if not rStudyPlanHeader.FindFirst then begin
                        CourseCode := '';
                        ClassCode := '';
                        ServicePlanCode := '';
                    end;
                end;
            end;
            ClassCode := '';
            ServicePlanCode := '';
        end else begin
            ClassCode := '';
            ServicePlanCode := '';
        end;
    end;

    local procedure SchoolingYearOnAfterValidate()
    begin
        CourseCode := '';
        ClassCode := '';
        ServicePlanCode := '';

        UpdateFilters;
    end;

    local procedure SchoolYearOnAfterValidate()
    begin
        UpdateFilters;
        SchoolingYear := '';
        CourseCode := '';
        ClassCode := '';
        ServicePlanCode := '';

        Rec.DeleteAll;
        CurrPage.Update(false);
    end;

    local procedure ServicePlanCodeOnAfterValidate()
    begin
        if ServicePlanCode <> '' then
            "Services Plan CodeVisible" := false
        else
            "Services Plan CodeVisible" := true;
    end;
}

#pragma implicitwith restore

