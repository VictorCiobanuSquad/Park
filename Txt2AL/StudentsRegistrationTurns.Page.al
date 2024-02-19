#pragma implicitwith disable
page 31009832 "Students Registration Turns"
{
    Caption = 'Students Registration Turns';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    Permissions = TableData "Assessing Students" = rimd,
                  TableData "Assessing Students Final" = rimd;
    SourceTable = "Assign Assessments Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rCompanyInfo.Get;
                        rStruEduCountry.Reset;
                        rStruEduCountry.SetRange(Country, rCompanyInfo."Country/Region Code");
                        //rStructureEducationCountry.SETRANGE(Type,rStruEduCountry.Type::Multi);

                        if PAGE.RunModal(0, rStruEduCountry) = ACTION::LookupOK then begin
                            varSchoolingYear := rStruEduCountry."Schooling Year";

                            if rStruEduCountry.Type = rStruEduCountry.Type::Simple then begin
                                tStudyPlanCodeEditable := true;
                                tCourseEditable := false;
                            end;
                            if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                                tStudyPlanCodeEditable := false;
                                tCourseEditable := true;
                            end;

                            varStudyPlanCode := '';
                            varCourseCode := '';

                        end;
                    end;

                    trigger OnValidate()
                    begin
                        varSchoolingYearOnAfterValidat;
                    end;
                }
                field(tStudyPlanCode; StudyPlanCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan Code';
                    Editable = tStudyPlanCodeEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rSchoolYear.Reset;
                        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                        if rSchoolYear.Find('-') then begin
                            CourseCode := '';
                            Rec.Reset;
                            Rec.DeleteAll;


                            rStudyPlanHeader.Reset;
                            rStudyPlanHeader.SetRange("School Year", rSchoolYear."School Year");
                            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear);
                            if PAGE.RunModal(0, rStudyPlanHeader) = ACTION::LookupOK then begin
                                StudyPlanCode := rStudyPlanHeader.Code;
                                varStudyPlanCode := StudyPlanCode;
                                varSchoolYear := rStudyPlanHeader."School Year";
                            end;
                            FillFunction;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        StudyPlanCodeOnAfterValidate;
                    end;
                }
                field(tCourse; CourseCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Course Code';
                    Editable = tCourseEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_CourseHeaderTEMP: Record "Course Header" temporary;
                    begin
                        rSchoolYear.Reset;
                        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
                        if rSchoolYear.FindFirst then begin
                            varSchoolYear := rSchoolYear."School Year";
                            StudyPlanCode := '';

                            Rec.Reset;
                            Rec.DeleteAll;

                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindFirst then;

                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                            l_rStruEduCountry.SetRange(Level, rStruEduCountry.Level);
                            if l_rStruEduCountry.FindSet then begin
                                rCourseHeader.Reset;
                                rCourseHeader.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
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
                                varStudyPlanCode := CourseCode;
                                FillFunction;
                            end;

                        end;
                    end;

                    trigger OnValidate()
                    begin
                        CourseCodeOnAfterValidate;
                    end;
                }
                repeater(Tablebox1)
                {
                    IndentationColumn = TextIndent;
                    IndentationControls = Text;
                    ShowAsTree = true;
                    field("Student Code No."; Rec."Student Code No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Option Type"; Rec."Option Type")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Subject Code"; Rec."Subject Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Sub-Subject Code"; Rec."Sub-Subject Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field(Text; Rec.Text)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field(varTurn; varTurn)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Turn';
                        TableRelation = Turn;

                        trigger OnValidate()
                        begin
                            GetTurn(true);
                            varTurnOnAfterValidate;
                        end;
                    }
                }
                field(SCN2; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("rStudents.Name"; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = ServiceSetup;
                action("E&xpand/Collapse")
                {
                    Caption = 'E&xpand/Collapse';
                    Image = ExpandDepositLine;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ToggleExpandCollapse;
                    end;
                }
                action("Expand &All")
                {
                    Caption = 'Expand &All';
                    Image = ExpandAll;

                    trigger OnAction()
                    begin
                        ExpandAll;
                    end;
                }
                action("&Collapse All")
                {
                    Caption = '&Collapse All';
                    Image = Close;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        InitTempTable;
                    end;
                }
                separator(Action1102065061)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TextIndent := 0;
        if rStudents.Get(Rec."Student Code No.") then;

        if IsExpanded(Rec) then
            ActualExpansionStatus := 1
        else
            if HasChildren(Rec) then
                ActualExpansionStatus := 2
            else
                ActualExpansionStatus := 0;

        GetTurn(false);
        StudentCodeNoC1102065003OnForm;
        OptionTypeOnFormat;
        SubjectCodeOnFormat;
        SubSubjectCodeOnFormat;
        TextOnFormat;
    end;

    trigger OnInit()
    begin
        tCourseEditable := true;
        tStudyPlanCodeEditable := true;
    end;

    var
        BufferAssignAssessments: Record "Assign Assessments Buffer" temporary;
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rSettingRatings: Record "Setting Ratings";
        rSettingRatingsSubSubjects: Record "Setting Ratings Sub-Subjects";
        rRankGroup: Record "Rank Group";
        cStudentsRegistration: Codeunit "Students Registration";
        rMomentsAssessment: Record "Moments Assessment";
        rCourseHeader: Record "Course Header";
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rCourseLines: Record "Course Lines";
        rStruEduCountry: Record "Structure Education Country";
        l_rStruEduCountry: Record "Structure Education Country";
        cUserEducation: Codeunit "User Education";
        rAssessmentConfig: Record "Assessment Configuration";
        rCompanyInfo: Record "Company Information";
        cPermissions: Codeunit Permissions;
        ActualExpansionStatus: Integer;
        varClass: Code[20];
        varSubjects: Code[20];
        varSchoolYear: Code[9];
        varSchoolingYear: Code[20];
        varStudyPlanCode: Code[20];
        varCourseCode: Code[20];
        varRespCenter: Code[20];
        CourseCode: Code[20];
        StudyPlanCode: Code[20];
        varTurn: Code[20];
        vText: array[15] of Text[250];
        indx: Integer;
        VarType: Option Simple,Multi;
        varTypeButtonEdit: Boolean;
        rRegistration: Record Registration;
        rClass: Record Class;
        rStudents: Record Students;
        rSchoolYear: Record "School Year";
        Text001: Label 'Turns only for sub-subjects.';
        Text002: Label 'Turns only for subjects.';
        Text003: Label 'Turns only for subjects and sub-subjects.';
        [InDataSet]
        tStudyPlanCodeEditable: Boolean;
        [InDataSet]
        tCourseEditable: Boolean;
        [InDataSet]
        "Student Code No.Emphasize": Boolean;
        [InDataSet]
        "Option TypeEmphasize": Boolean;
        [InDataSet]
        "Subject CodeEmphasize": Boolean;
        [InDataSet]
        "Sub-Subject CodeEmphasize": Boolean;
        [InDataSet]
        TextEmphasize: Boolean;
        [InDataSet]
        TextIndent: Integer;

    local procedure InitTempTable()
    begin
        CopyAssessToTemp(true);
    end;

    local procedure ExpandAll()
    begin
        CopyAssessToTemp(false);
    end;

    local procedure CopyAssessToTemp(OnlyRoot: Boolean)
    begin

        Rec.Reset;
        Rec.DeleteAll;

        BufferAssignAssessments.Reset;
        if OnlyRoot then
            BufferAssignAssessments.SetRange(Level, 1);
        if BufferAssignAssessments.Find('-') then
            repeat
                Rec := BufferAssignAssessments;
                Rec.Insert;
            until BufferAssignAssessments.Next = 0;

        Rec.SetCurrentKey("Class No.");
        if Rec.FindFirst then;
    end;

    local procedure HasChildren(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        Assess2: Record "Assign Assessments Buffer" temporary;
    begin

        BufferAssignAssessments.Reset;
        BufferAssignAssessments.SetRange(BufferAssignAssessments."Student Code No.", ActualAssess."Student Code No.");
        if (ActualAssess."Option Type" = ActualAssess."Option Type"::Subjects) then
            BufferAssignAssessments.SetRange(BufferAssignAssessments."Subject Code", ActualAssess."Subject Code");
        if (ActualAssess."Option Type" = ActualAssess."Option Type"::"Sub-Subjects") then
            BufferAssignAssessments.SetRange(BufferAssignAssessments."Sub-Subject Code", ActualAssess."Sub-Subject Code");
        if BufferAssignAssessments.FindLast then begin
            exit(BufferAssignAssessments.Level <= ActualAssess.Level);
        end;
    end;

    local procedure IsExpanded(ActualAssess: Record "Assign Assessments Buffer" temporary): Boolean
    var
        xAssess: Record "Assign Assessments Buffer" temporary;
        Found: Boolean;
    begin

        xAssess := Rec;
        Rec := ActualAssess;
        Found := (Rec.Next <> 0);
        if Found then
            Found := (Rec.Level > ActualAssess.Level);
        Rec := xAssess;
        exit(Found);
    end;

    local procedure ToggleExpandCollapse()
    var
        Assess: Record "Assign Assessments Buffer" temporary;
        xAssess: Record "Assign Assessments Buffer" temporary;
    begin

        BufferAssignAssessments.Reset;
        if BufferAssignAssessments.Find('-') then
            repeat
                Assess.Init;
                Assess.TransferFields(BufferAssignAssessments);
                Assess.Insert;
            until BufferAssignAssessments.Next = 0;

        xAssess := Rec;
        if (ActualExpansionStatus = 0) then begin // Has children, but not expanded
            Assess.SetRange(Level, Rec.Level, Rec.Level + 1);
            Assess := Rec;
            if Assess.Next <> 0 then
                repeat
                    if Assess.Level > xAssess.Level then begin
                        Rec := Assess;
                        if Rec.Insert then;
                    end;
                until (Assess.Next = 0) or (Assess.Level = xAssess.Level);
        end else
            if ActualExpansionStatus = 1 then begin // Has children and is already expanded
                while (Rec.Next <> 0) and (Rec.Level > xAssess.Level) do
                    Rec.Delete;
            end;
        Rec := xAssess;
        CurrPage.Update;
    end;

    //[Scope('OnPrem')]
    procedure UpdateForm()
    begin
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

    //[Scope('OnPrem')]
    procedure DeleteBuffer()
    begin
        BufferAssignAssessments.Reset;
        BufferAssignAssessments.DeleteAll;
        Clear(rStudents);
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure InsertStudents()
    var
        l_Students: Record Students;
        l_RegistrationSubjects: Record "Registration Subjects";
        l_StudentSubSubjects: Record "Student Sub-Subjects Plan ";
        l_RegistrationSubjects2: Record "Registration Subjects";
        l_GroupSubjects: Record "Group Subjects";
        VarlineNo: Integer;
        flag: Boolean;
    begin
        DeleteBuffer;

        VarlineNo := 0;

        rRegistration.Reset;
        if varClass <> '' then
            rRegistration.SetRange(Class, varClass);
        if CourseCode <> '' then
            rRegistration.SetRange(Course, CourseCode);
        if StudyPlanCode <> '' then
            rRegistration.SetRange("Study Plan Code", StudyPlanCode);
        rRegistration.SetRange("Responsibility Center", varRespCenter);
        rRegistration.SetRange("Schooling Year", varSchoolingYear);
        rRegistration.SetRange("School Year", varSchoolYear);
        if rRegistration.FindSet then begin
            repeat
                BufferAssignAssessments.Reset;
                BufferAssignAssessments.Init;
                BufferAssignAssessments."User ID" := UserId;
                VarlineNo += 10000;
                BufferAssignAssessments."Line No." := VarlineNo;
                BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                if l_Students.Get(rRegistration."Student Code No.") then begin
                    BufferAssignAssessments.Text := l_Students.Name;
                end;
                BufferAssignAssessments."Subject Code" := '';
                BufferAssignAssessments.Level := 1;
                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Student;
                BufferAssignAssessments.Insert;

                l_RegistrationSubjects.Reset;
                l_RegistrationSubjects.SetCurrentKey("Student Code No.", "Option Group", "Sorting ID");
                l_RegistrationSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                l_RegistrationSubjects.SetRange("School Year", rRegistration."School Year");
                l_RegistrationSubjects.SetRange("Schooling Year", rRegistration."Schooling Year");
                l_RegistrationSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                if l_RegistrationSubjects.FindSet then begin
                    repeat
                        BufferAssignAssessments.Reset;
                        BufferAssignAssessments.Init;
                        BufferAssignAssessments."User ID" := UserId;
                        VarlineNo += 10000;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects."Student Code No.";
                        BufferAssignAssessments."Subject Code" := l_RegistrationSubjects."Subjects Code";
                        BufferAssignAssessments.Text := l_RegistrationSubjects.Description;
                        BufferAssignAssessments.Level := 2;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                        BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                        BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                        BufferAssignAssessments.Insert;
                        l_RegistrationSubjects.CalcFields("Sub-subject");

                        if l_RegistrationSubjects."Sub-subject" then begin
                            l_StudentSubSubjects.Reset;
                            l_StudentSubSubjects.SetRange("Student Code No.", rRegistration."Student Code No.");
                            l_StudentSubSubjects.SetRange("School Year", rRegistration."School Year");
                            l_StudentSubSubjects.SetRange("Subject Code", l_RegistrationSubjects."Subjects Code");
                            l_StudentSubSubjects.SetRange(Code, l_RegistrationSubjects."Study Plan Code");
                            l_StudentSubSubjects.SetRange("Schooling Year", rRegistration."Schooling Year");
                            l_StudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                            l_StudentSubSubjects.SetRange(Type, l_RegistrationSubjects.Type);
                            if l_StudentSubSubjects.FindSet then begin
                                repeat
                                    BufferAssignAssessments.Reset;
                                    BufferAssignAssessments.Init;
                                    BufferAssignAssessments."User ID" := UserId;
                                    VarlineNo += 10000;
                                    BufferAssignAssessments."Line No." := VarlineNo;
                                    BufferAssignAssessments."Student Code No." := rRegistration."Student Code No.";
                                    BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                                    BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                                    BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                                    BufferAssignAssessments.Level := 3;
                                    BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                                    BufferAssignAssessments.Class := l_RegistrationSubjects.Class;
                                    BufferAssignAssessments."Schooling Year" := l_RegistrationSubjects."Schooling Year";
                                    BufferAssignAssessments.Insert;

                                until l_StudentSubSubjects.Next = 0;
                            end;
                        end;
                    until l_RegistrationSubjects.Next = 0;
                end;
            until rRegistration.Next = 0;
        end;

        /*
        //for students with subjects of past years
        l_RegistrationSubjects.RESET;
        l_RegistrationSubjects.SETCURRENTKEY("Student Code No.","Option Group","Sorting ID");
        l_RegistrationSubjects.SETRANGE("School Year",varSchoolYear);
        l_RegistrationSubjects.SETRANGE("Study Plan Code",varStudyPlanCode);
        l_RegistrationSubjects.SETRANGE("Schooling Year",varSchoolingYear);
        IF varClass <> '' THEN
          l_RegistrationSubjects.SETRANGE(Class,varClass);
        l_RegistrationSubjects.SETRANGE("Responsibility Center",varRespCenter);
        IF l_RegistrationSubjects.FINDSET THEN BEGIN
          REPEAT
            BufferAssignAssessments.RESET;
            BufferAssignAssessments.SETRANGE("Student Code No.",l_RegistrationSubjects."Student Code No.");
            IF NOT BufferAssignAssessments.FINDFIRST THEN BEGIN
              l_RegistrationSubjects2.RESET;
              l_RegistrationSubjects2.SETRANGE("Student Code No.",l_RegistrationSubjects."Student Code No.");
              l_RegistrationSubjects2.SETRANGE("School Year",varSchoolYear);
              l_RegistrationSubjects2.SETRANGE(Class,varClass);
              IF l_RegistrationSubjects2.FINDSET THEN BEGIN
                BufferAssignAssessments.RESET;
                BufferAssignAssessments.INIT;
                BufferAssignAssessments.Class := rRegistration.Class;
                BufferAssignAssessments."User ID" := USERID;
                VarlineNo += 10000;
                BufferAssignAssessments."Line No." := VarlineNo ;
                BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                IF l_Students.GET(l_RegistrationSubjects2."Student Code No.") THEN BEGIN
                  BufferAssignAssessments.Text := l_Students."Full Name";
                END;
                BufferAssignAssessments."Subject Code" := '';
                BufferAssignAssessments.Level := 1;
                BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Student;
                BufferAssignAssessments.INSERT;
                REPEAT
                  BufferAssignAssessments.RESET;
                  BufferAssignAssessments.INIT;
                  BufferAssignAssessments."User ID" := USERID;
                  VarlineNo += 10000;
                  BufferAssignAssessments.Class := rRegistration.Class;
                  BufferAssignAssessments."Line No." := VarlineNo;
                  BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                  BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                  BufferAssignAssessments."Subject Code" := l_RegistrationSubjects2."Subjects Code";
                  BufferAssignAssessments.Text := l_RegistrationSubjects2.Description;
                  BufferAssignAssessments.Level := 2;
                  BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::Subjects;
                  BufferAssignAssessments.INSERT;
        
        
                  l_RegistrationSubjects2.CALCFIELDS("Sub-subject");
        
                  IF l_RegistrationSubjects2."Sub-subject" THEN BEGIN
                    l_StudentSubSubjects.RESET;
                    l_StudentSubSubjects.SETRANGE("Student Code No.",l_RegistrationSubjects2."Student Code No.");
                    l_StudentSubSubjects.SETRANGE("School Year",l_RegistrationSubjects2."School Year");
                    l_StudentSubSubjects.SETRANGE("Subject Code",l_RegistrationSubjects2."Subjects Code");
                    l_StudentSubSubjects.SETRANGE(Code,l_RegistrationSubjects2."Study Plan Code");
                    l_StudentSubSubjects.SETRANGE("Schooling Year",l_RegistrationSubjects2."Schooling Year");
                    l_StudentSubSubjects.SETRANGE("Responsibility Center",l_RegistrationSubjects2."Responsibility Center");
                    l_StudentSubSubjects.SETRANGE(Type,l_RegistrationSubjects2.Type);
                    IF l_StudentSubSubjects.FINDSET THEN BEGIN
                      REPEAT
                        BufferAssignAssessments.RESET;
                        BufferAssignAssessments.INIT;
                        BufferAssignAssessments."User ID" := USERID;
                        VarlineNo += 10000;
                        BufferAssignAssessments.Class := rRegistration.Class;
                        BufferAssignAssessments."Line No." := VarlineNo;
                        BufferAssignAssessments."Student Code No." := l_RegistrationSubjects2."Student Code No.";
                        BufferAssignAssessments."Class No." := l_RegistrationSubjects2."Class No.";
                        BufferAssignAssessments."Subject Code" := l_StudentSubSubjects."Subject Code";
                        BufferAssignAssessments."Sub-Subject Code" := l_StudentSubSubjects."Sub-Subject Code";
                        BufferAssignAssessments.Text := l_StudentSubSubjects."Sub-Subject Description";
                        BufferAssignAssessments.Level := 3;
                        BufferAssignAssessments."Option Type" := BufferAssignAssessments."Option Type"::"Sub-Subjects";
                        BufferAssignAssessments.INSERT;
        
                      UNTIL l_StudentSubSubjects.NEXT =0;
                    END;
                  END;
        
                UNTIL l_RegistrationSubjects2.NEXT=0;
              END;
            END;
          UNTIL l_RegistrationSubjects.NEXT =0;
        
        END;
        */

    end;

    //[Scope('OnPrem')]
    procedure GetTurn(pInsert: Boolean)
    var
        l_rRegistrationSubjects: Record "Registration Subjects";
        l_rStudentSubSubjects: Record "Student Sub-Subjects Plan ";
        SubSubjectAssessementONLY: Boolean;
    begin
        //pInsert = True  insert in the registration
        //pInsert = False get the field
        if StudyPlanCode <> '' then begin
            rStudyPlanHeader.Reset;
            rStudyPlanHeader.SetRange(Code, StudyPlanCode);
            rStudyPlanHeader.SetRange("School Year", varSchoolYear);
            rStudyPlanHeader.SetRange("Responsibility Center", varRespCenter);
            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear);
            if rStudyPlanHeader.FindFirst then
                SubSubjectAssessementONLY := rStudyPlanHeader."Sub-subjects for assess. only";
        end;
        if CourseCode <> '' then begin
            rCourseHeader.Reset;
            rCourseHeader.SetRange(Code, CourseCode);
            rCourseHeader.SetRange("Responsibility Center", varRespCenter);
            if rCourseHeader.FindFirst then
                SubSubjectAssessementONLY := rCourseHeader."Sub-subjects for assess. only";
        end;

        if pInsert then begin
            if Rec."Option Type" = Rec."Option Type"::Student then
                Message(Text003);
            if Rec."Option Type" = Rec."Option Type"::Subjects then begin
                l_rRegistrationSubjects.Reset;
                l_rRegistrationSubjects.SetRange("School Year", varSchoolYear);
                l_rRegistrationSubjects.SetRange("Student Code No.", Rec."Student Code No.");
                l_rRegistrationSubjects.SetRange(Class, Rec.Class);
                l_rRegistrationSubjects.SetRange("Subjects Code", Rec."Subject Code");
                l_rRegistrationSubjects.SetRange("Responsibility Center", varRespCenter);
                if l_rRegistrationSubjects.FindFirst then begin
                    l_rRegistrationSubjects.CalcFields("Sub-subject");
                    if (not l_rRegistrationSubjects."Sub-subject") and (not SubSubjectAssessementONLY) then begin
                        l_rRegistrationSubjects.Validate(l_rRegistrationSubjects.Turn, varTurn);
                        l_rRegistrationSubjects.Modify(true);
                    end else
                        Message(Text001);
                end;
            end;
            if Rec."Option Type" = Rec."Option Type"::"Sub-Subjects" then begin
                l_rStudentSubSubjects.Reset;
                l_rStudentSubSubjects.SetRange("Student Code No.", Rec."Student Code No.");
                l_rStudentSubSubjects.SetRange("School Year", varSchoolYear);
                l_rStudentSubSubjects.SetRange("Subject Code", Rec."Subject Code");
                l_rStudentSubSubjects.SetRange(Code, varStudyPlanCode);
                l_rStudentSubSubjects.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                l_rStudentSubSubjects.SetRange("Schooling Year", varSchoolingYear);
                l_rStudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                if l_rStudentSubSubjects.FindFirst then
                    if not SubSubjectAssessementONLY then begin
                        l_rStudentSubSubjects.Validate(l_rStudentSubSubjects.Turn, varTurn);
                        l_rStudentSubSubjects.Modify(true);
                    end else
                        Message(Text002);
            end;
        end;
        if pInsert = false then begin
            if Rec."Option Type" = Rec."Option Type"::Subjects then begin
                l_rRegistrationSubjects.Reset;
                l_rRegistrationSubjects.SetRange("School Year", varSchoolYear);
                l_rRegistrationSubjects.SetRange("Student Code No.", Rec."Student Code No.");
                l_rRegistrationSubjects.SetRange("Subjects Code", Rec."Subject Code");
                l_rRegistrationSubjects.SetRange("Responsibility Center", varRespCenter);
                l_rRegistrationSubjects.SetRange(Class, Rec.Class);
                if l_rRegistrationSubjects.FindFirst then
                    varTurn := l_rRegistrationSubjects.Turn;
            end;
            if Rec."Option Type" = Rec."Option Type"::"Sub-Subjects" then begin
                l_rStudentSubSubjects.Reset;
                l_rStudentSubSubjects.SetRange("Student Code No.", Rec."Student Code No.");
                l_rStudentSubSubjects.SetRange("School Year", varSchoolYear);
                l_rStudentSubSubjects.SetRange("Subject Code", Rec."Subject Code");
                l_rStudentSubSubjects.SetRange(Code, varStudyPlanCode);
                l_rStudentSubSubjects.SetRange("Sub-Subject Code", Rec."Sub-Subject Code");
                l_rStudentSubSubjects.SetRange("Schooling Year", varSchoolingYear);
                l_rStudentSubSubjects.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                if l_rStudentSubSubjects.FindSet then
                    varTurn := l_rStudentSubSubjects.Turn;
            end;
            if (Rec."Option Type" <> Rec."Option Type"::"Sub-Subjects") and (Rec."Option Type" <> Rec."Option Type"::Subjects) then
                varTurn := '';
        end;
    end;

    //[Scope('OnPrem')]
    procedure FillFunction()
    begin
        DeleteBuffer;
        UpdateForm;

        InsertStudents;
        InitTempTable;
        CurrPage.Update(false);
    end;

    local procedure varTurnOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure CourseCodeOnAfterValidate()
    begin
        if CourseCode = '' then begin
            Rec.Reset;
            Rec.DeleteAll;
            DeleteBuffer;
        end else
            FillFunction;
    end;

    local procedure StudyPlanCodeOnAfterValidate()
    begin
        if StudyPlanCode = '' then begin
            Rec.Reset;
            Rec.DeleteAll;
            DeleteBuffer;
        end;
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin
        if varSchoolingYear = '' then begin
            Rec.Reset;
            Rec.DeleteAll;
            DeleteBuffer;
        end;



        if varSchoolingYear <> '' then begin
            tStudyPlanCodeEditable := true;
            tCourseEditable := true;
        end;


        rCompanyInfo.Get;
        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, rCompanyInfo."Country/Region Code");
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.Find('-') then begin
            if rStruEduCountry.Type = rStruEduCountry.Type::Simple then begin
                tStudyPlanCodeEditable := true;
                tCourseEditable := false;
            end;
            if rStruEduCountry.Type = rStruEduCountry.Type::Multi then begin
                tStudyPlanCodeEditable := false;
                tCourseEditable := true;
            end;
        end;
    end;

    local procedure varSchoolingYearOnInputChange(var Text: Text[1024])
    begin
        varStudyPlanCode := '';
        varCourseCode := '';
        CourseCode := '';
        StudyPlanCode := '';

        if (StudyPlanCode = '') and (CourseCode = '') then begin
            Rec.Reset;
            Rec.DeleteAll;
            DeleteBuffer;
            CurrPage.Update(false);
            exit;
        end;
    end;

    local procedure ActualExpansionStatusOnPush()
    begin
        ToggleExpandCollapse;
    end;

    local procedure StudentCodeNoC1102065003OnForm()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Student Code No.Emphasize" := true;
    end;

    local procedure OptionTypeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Option TypeEmphasize" := true;
    end;

    local procedure SubjectCodeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Subject CodeEmphasize" := true;
    end;

    local procedure SubSubjectCodeOnFormat()
    begin
        if Rec."Option Type" = Rec."Option Type"::Student then
            "Sub-Subject CodeEmphasize" := true;
    end;

    local procedure TextOnFormat()
    begin
        TextIndent := Rec.Level;

        if Rec."Option Type" = Rec."Option Type"::Student then
            TextEmphasize := true;
    end;
}

#pragma implicitwith restore

