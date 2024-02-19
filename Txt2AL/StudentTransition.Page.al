#pragma implicitwith disable
page 31009874 "Student Transition"
{
    //  //IT001 - 2017.09.05 - tive de comentar porque alguns alunos já aparacem com este campo a processado.
    //   Acho que é porque eles começaram a preparar o ano letivo em março

    Caption = 'Student Transition';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = Registration;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varTransitionStatus; varTransitionStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Actual Status';
                    OptionCaption = ' ,Registered,Transited,Not Transited,Concluded,Not Concluded,Abandonned,Registration Annulled,Tranfered,Exclusion by Incidences,Ongoing evaluation,Retained from Absences';

                    trigger OnValidate()
                    begin
                        varTransitionStatusOnAfterVali;
                    end;
                }
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Closing | Active));

                    trigger OnValidate()
                    begin
                        varSchoolYearOnAfterValidate;
                    end;
                }
                field(varSchoolingYear; varSchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin


                        if varSchoolingYear = '' then begin
                            VarStudyPlan := '';
                            varSchoolingYear2 := '';
                            varClass := '';
                            VarClassLetter := '';
                        end;
                        //varSchoolingYearOnAfterValidat;
                    end;
                }
                field(VarStudyPlan; VarStudyPlan)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course Code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_CourseHeaderTEMP: Record "Course Header" temporary;
                    begin
                        if VarType = VarType::Simple then begin
                            rStudyPlanHeader.Reset;
                            rStudyPlanHeader.SetRange("School Year", varSchoolYear);
                            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear);
                            if rStudyPlanHeader.FindSet then;

                            if PAGE.RunModal(PAGE::"Study Plan List", rStudyPlanHeader) = ACTION::LookupOK then
                                VarStudyPlan := rStudyPlanHeader.Code;
                        end;
                        if VarType = VarType::Multi then begin

                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
                            if rStruEduCountry.FindFirst then;

                            rStruEduCountry2.Reset;
                            rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                            rStruEduCountry2.SetRange(Level, rStruEduCountry.Level);
                            if rStruEduCountry2.FindSet then begin
                                repeat

                                    rCourseHeader.Reset;
                                    rCourseHeader.SetRange("Schooling Year Begin", rStruEduCountry2."Schooling Year");
                                    if rCourseHeader.FindSet then begin
                                        repeat
                                            l_CourseHeaderTEMP.Reset;
                                            l_CourseHeaderTEMP.SetRange(Code, rCourseHeader.Code);
                                            if not l_CourseHeaderTEMP.FindSet then begin
                                                l_CourseHeaderTEMP.Reset;
                                                l_CourseHeaderTEMP.Init;
                                                l_CourseHeaderTEMP.TransferFields(rCourseHeader);
                                                l_CourseHeaderTEMP.Insert;
                                            end;
                                        until rCourseHeader.Next = 0;
                                    end;
                                until rStruEduCountry2.Next = 0;
                            end;


                            if PAGE.RunModal(PAGE::"Course List", l_CourseHeaderTEMP) = ACTION::LookupOK then
                                VarStudyPlan := l_CourseHeaderTEMP.Code;


                        end;
                        GetLines;
                        if VarType = VarType::Multi then
                            VarStudyPlan2 := GetSubjects;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        if VarStudyPlan <> '' then
                            GetStudyPlan
                        else begin
                            varClass := '';
                            varSchoolingYear := '';
                            VarClassLetter := '';
                        end;
                        VarStudyPlanOnAfterValidate;
                    end;
                }
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_Class: Record Class;
                    begin
                        l_Class.Reset;
                        l_Class.SetFilter("School Year", cStudentsRegistration.GetShoolYearActiveClosing);
                        l_Class.SetFilter("Study Plan Code", VarStudyPlan);
                        if l_Class.FindSet then;

                        if PAGE.RunModal(PAGE::"Class List", l_Class) = ACTION::LookupOK then begin
                            varClass := l_Class.Class;
                            varSchoolYear := l_Class."School Year";
                            GetNextSchoolYear;
                            VarStudyPlan := l_Class."Study Plan Code";
                            varSchoolingYear := l_Class."Schooling Year";
                            GetType;
                            /*rTransitionRules2.RESET;
                            rTransitionRules2.SETRANGE("Schooling Year",varSchoolingYear);
                            rTransitionRules2.SETRANGE("School Year",'');
                            rTransitionRules2.SETRANGE("Study Plan Code",'');
                            rTransitionRules2.SETRANGE("Validation Type",rTransitionRules2."Validation Type"::Classification);
                            rTransitionRules2.SETRANGE("Rule Type",rTransitionRules2."Rule Type"::"2");
                            rTransitionRules2.SETRANGE("Not Approved",TRUE);
                            IF rTransitionRules2.FINDFIRST THEN
                              IF varTransitionStatus <> rTransitionRules2."Actual Status" THEN*/
                            GetNextSchoolingYear;
                            /*ELSE BEGIN
                            varSchoolingYear2 := varSchoolingYear;
                            rStruEduCountry.RESET;
                            rStruEduCountry.SETRANGE("Schooling Year",varSchoolingYear2);
                            IF rStruEduCountry.FINDFIRST THEN
                              VarType2 := rStruEduCountry.Type;
                          END;*/

                            VarClassLetter := l_Class."Class Letter";
                            VarType := l_Class.Type;
                            if VarType = VarType::Multi then
                                VarStudyPlan2 := GetSubjects;
                        end;
                        GetLines;
                        CurrPage.Update(false);

                    end;

                    trigger OnValidate()
                    var
                        l_Class: Record Class;
                    begin
                        l_Class.Reset;
                        l_Class.SetRange(Class, varClass);
                        if l_Class.FindFirst then begin
                            varSchoolYear := l_Class."School Year";
                            GetNextSchoolYear;
                            VarStudyPlan := l_Class."Study Plan Code";
                            varSchoolingYear := l_Class."Schooling Year";
                            GetType;
                            /*rTransitionRules2.RESET;
                            rTransitionRules2.SETRANGE("Schooling Year",varSchoolingYear);
                            rTransitionRules2.SETRANGE("School Year",'');
                            rTransitionRules2.SETRANGE("Study Plan Code",'');
                            rTransitionRules2.SETRANGE("Validation Type",rTransitionRules2."Validation Type"::Classification);
                            rTransitionRules2.SETRANGE("Rule Type",rTransitionRules2."Rule Type"::"2");
                            rTransitionRules2.SETRANGE("Not Approved",TRUE);
                            IF rTransitionRules2.FINDFIRST THEN
                              IF varTransitionStatus <> rTransitionRules2."Actual Status" THEN*/
                            GetNextSchoolingYear;
                            /*ELSE BEGIN
                              varSchoolingYear2 := varSchoolingYear;
                            rStruEduCountry.RESET;
                            rStruEduCountry.SETRANGE("Schooling Year",varSchoolingYear2);
                            IF rStruEduCountry.FINDFIRST THEN
                              VarType2 := rStruEduCountry.Type;
                          END;*/


                            VarClassLetter := l_Class."Class Letter";
                            VarType := l_Class.Type;
                            if VarType = VarType::Multi then
                                VarStudyPlan2 := GetSubjects;
                        end;

                        if varClass = '' then begin
                            Clear(Rec);
                            varSchoolYear := '';
                            varSchoolYear2 := '';
                            varSchoolingYear := '';
                            varSchoolingYear2 := '';
                            VarStudyPlan := '';
                            VarStudyPlan2 := '';
                            VarClassLetter := '';
                        end;
                        varClassOnAfterValidate;

                    end;
                }
                field(VarClassLetter; VarClassLetter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class Letter';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        VarClassLetterOnAfterValidate;
                    end;
                }
                field(varSchoolYear2; varSchoolYear2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Next School Year';
                    Editable = false;
                    TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));

                    trigger OnValidate()
                    begin
                        varSchoolYear2OnAfterValidate;
                    end;
                }
                field(varSchoolingYear2; varSchoolingYear2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Next Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnValidate()
                    begin
                        if varSchoolingYear2 = '' then begin
                            varSchoolingYear2 := '';
                            VarStudyPlan2 := '';
                            VarClassLetter2 := '';
                        end else begin
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear2);
                            if rStruEduCountry.FindFirst then
                                VarType2 := rStruEduCountry.Type;
                        end;
                    end;
                }
                field(VarStudyPlan2; VarStudyPlan2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Study Plan/Course Code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_CourseHeaderTEMP: Record "Course Header" temporary;
                    begin
                        if VarType2 = VarType2::Simple then begin
                            rStudyPlanHeader.Reset;
                            rStudyPlanHeader.SetRange("School Year", varSchoolYear2);
                            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear2);
                            if rStudyPlanHeader.FindSet then;

                            if PAGE.RunModal(PAGE::"Study Plan List", rStudyPlanHeader) = ACTION::LookupOK then
                                VarStudyPlan2 := rStudyPlanHeader.Code;
                        end;
                        if VarType2 = VarType2::Multi then begin

                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear2);
                            if rStruEduCountry.FindFirst then;

                            rStruEduCountry2.Reset;
                            rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                            rStruEduCountry2.SetRange(Level, rStruEduCountry.Level);
                            if rStruEduCountry2.FindSet then begin
                                repeat

                                    rCourseHeader.Reset;
                                    rCourseHeader.SetRange("Schooling Year Begin", rStruEduCountry2."Schooling Year");
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
                                until rStruEduCountry2.Next = 0;
                            end;

                            l_CourseHeaderTEMP.Reset;
                            if PAGE.RunModal(PAGE::"Course List", l_CourseHeaderTEMP) = ACTION::LookupOK then
                                VarStudyPlan2 := l_CourseHeaderTEMP.Code;


                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if VarType2 = VarType2::Simple then begin
                            rStudyPlanHeader.Reset;
                            rStudyPlanHeader.SetRange(Code, VarStudyPlan2);
                            rStudyPlanHeader.SetRange("School Year", varSchoolYear2);
                            rStudyPlanHeader.SetRange("Schooling Year", varSchoolingYear2);
                            if not rStudyPlanHeader.FindFirst then
                                Error(Text0011, VarStudyPlan2);

                        end;
                        if VarType2 = VarType2::Multi then begin
                            flag := true;
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear2);
                            if rStruEduCountry.FindFirst then;

                            rStruEduCountry2.Reset;
                            rStruEduCountry2.SetRange("Edu. Level", rStruEduCountry."Edu. Level");
                            if rStruEduCountry2.FindSet then begin
                                repeat

                                    rCourseHeader.Reset;
                                    rCourseHeader.SetRange(Code, VarStudyPlan2);
                                    rCourseHeader.SetRange("Schooling Year Begin", rStruEduCountry2."Schooling Year");
                                    if rCourseHeader.FindFirst then
                                        flag := false;
                                until rStruEduCountry2.Next = 0;
                            end;
                            if flag then
                                Error(Text0011, VarStudyPlan2);

                        end;
                    end;
                }
                field(varClass2; varClass2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class';
                    TableRelation = Class.Class;
                    Visible = false;

                    trigger OnValidate()
                    var
                        l_Class: Record Class;
                    begin
                        l_Class.Reset;
                        l_Class.SetRange(Class, varClass);
                        if l_Class.FindFirst then begin
                            varSchoolYear := l_Class."School Year";
                            GetNextSchoolYear;
                            VarStudyPlan := l_Class."Study Plan Code";
                            varSchoolingYear := l_Class."Schooling Year";
                            GetType;
                            GetNextSchoolingYear;
                            VarClassLetter := l_Class."Class Letter";
                            VarType := l_Class.Type;
                        end;

                        if varClass = '' then begin
                            Clear(Rec);
                            varSchoolYear := '';
                            varSchoolYear2 := '';
                            varSchoolingYear2 := '';
                            VarStudyPlan := '';
                            VarClassLetter := '';
                        end;
                        varClass2OnAfterValidate;
                    end;
                }
                field(VarClassLetter2; VarClassLetter2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class Letter';

                    trigger OnValidate()
                    begin
                        VarClassLetter2OnAfterValidate;
                    end;
                }
            }
            repeater(Control1102065007)
            {
                ShowCaption = false;
                field(Selection; Rec.Selection)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        SelectionOnPush;
                    end;
                }
                field("Next School Year"; Rec."Next School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("New Class Letter"; Rec."New Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varStudentName; varStudentName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("P&ost")
            {
                Caption = 'P&ost';
                Image = Post;
                action(Action1102065040)
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Process;
                    end;
                }
                separator(Action1102065048)
                {
                }
                action("&Mark All")
                {
                    Caption = '&Mark All';
                    Image = EnableAllBreakpoints;

                    trigger OnAction()
                    begin
                        PutSelection(true);
                    end;
                }
                action("&Unmark All")
                {
                    Caption = '&Unmark All';
                    Image = DisableAllBreakpoints;

                    trigger OnAction()
                    begin
                        PutSelection(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        varStudentName := GetStudentName;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        Rec.DeleteAll;
    end;

    var
        varSchoolYear: Code[9];
        varClass: Code[20];
        varSchoolingYear: Code[10];
        varTransitionStatus: Option " ",Registered,Transited,"Not Transited",Concluded,"Not Concluded",Abandonned,"Registration Annulled",Transfered,"Exclusion by Incidences","Ongoing evaluation","Retained from Absences","School Certificate","Legal Transition",Admited,"Not Admited","A aguardar Provas Finais 2ºCEB","Admitido às Provas Finais","Não Admitido Provas Finais";
        VarClassLetter: Code[2];
        VarStudyPlan: Code[20];
        VarType: Option Simple,Multi;
        rRegistration: Record Registration;
        varSchoolYear2: Code[9];
        varSchoolingYear2: Code[10];
        VarStudyPlan2: Code[20];
        varClass2: Code[20];
        VarClassLetter2: Code[2];
        VarType2: Option Simple,Multi;
        cUserEducation: Codeunit "User Education";
        rStruEduCountry: Record "Structure Education Country";
        rStruEduCountry2: Record "Structure Education Country";
        rStudyPlanHeader: Record "Study Plan Header";
        rCourseHeader: Record "Course Header";
        rClass: Record Class;
        rCourseLinesTEMP: Record "Course Lines" temporary;
        rTransitionRules: Record "Transition Rules";
        rTransitionRules2: Record "Transition Rules";
        rAssessmentConfiguration: Record "Assessment Configuration";
        varLineNo: Integer;
        cStudentsRegistration: Codeunit "Students Registration";
        Text0001: Label 'Process finished.';
        Text0002: Label 'Nothing to process.';
        Text0003: Label 'The Student %1 %2  already has a registration for the next School Year.Do you wish to Delete?';
        Text0004: Label 'The field New Study Plan/Course Code is Mandatory.';
        Text0005: Label 'The student status not allowed to make any changes.';
        Text0010: Label 'Operation cancelled by the user.';
        Text0011: Label 'The Study Plan/Course Code %1 not exist.';
        cCalcEvaluation: Codeunit "Calc. Evaluation";
        flag: Boolean;
        Text0012: Label 'There is a error in the Subjects for the %1 Student %2.';
        varStudentName: Text[200];

    //[Scope('OnPrem')]
    procedure GetLines()
    begin
        Rec.DeleteAll;
        rRegistration.Reset;
        rRegistration.SetCurrentKey(Class, "Class No.");
        rRegistration.SetRange("Actual Status", varTransitionStatus);
        rRegistration.SetRange("School Year", varSchoolYear);
        rRegistration.SetRange("Schooling Year", varSchoolingYear);
        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
        //rRegistration.SETRANGE("Next School Year",rRegistration."Next School Year"::"In School"); //IT001 - 2017.09.05
        if cUserEducation.GetEducationFilter(UserId) <> '' then
            rRegistration.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));

        if VarType = VarType::Simple then begin
            if VarStudyPlan <> '' then
                rRegistration.SetRange("Study Plan Code", VarStudyPlan);
        end;
        if VarType = VarType::Multi then begin
            if VarStudyPlan <> '' then
                rRegistration.SetRange(Course, VarStudyPlan);
        end;


        if varClass <> '' then
            rRegistration.SetRange(Class, varClass)
        else
            rRegistration.SetFilter(Class, '<>%1', '');
        if VarClassLetter <> '' then
            rRegistration.SetRange("Class Letter", VarClassLetter);
        if rRegistration.FindSet then begin
            repeat
                Rec.TransferFields(rRegistration);
                if VarClassLetter2 = '' then
                    Rec."New Class Letter" := Rec."Class Letter"
                else
                    Rec."New Class Letter" := VarClassLetter2;
                Rec.Insert;

            until rRegistration.Next = 0;
        end;

        Rec.SetCurrentKey(Class, "Class No.");
    end;

    //[Scope('OnPrem')]
    procedure GetNextSchoolYear()
    var
        l_SchoolYear: Record "School Year";
        l_StructureEducationCountry: Record "Structure Education Country";
    begin
        if varSchoolYear <> '' then begin
            l_SchoolYear.Reset;
            if l_SchoolYear.FindSet then begin
                repeat
                    if l_SchoolYear."School Year" = varSchoolYear then begin
                        l_SchoolYear.Next;
                        varSchoolYear2 := l_SchoolYear."School Year";
                    end;
                until l_SchoolYear.Next = 0;
            end;
        end else
            varSchoolYear2 := '';
    end;

    //[Scope('OnPrem')]
    procedure GetNextSchoolingYear()
    var
        l_StructureEducationCountry: Record "Structure Education Country";
        l_StructureEducationCountry2: Record "Structure Education Country";
    begin
        if varSchoolingYear <> '' then begin
            l_StructureEducationCountry.Reset;
            l_StructureEducationCountry.SetCurrentKey("Sorting ID");
            l_StructureEducationCountry.SetRange("Schooling Year", varSchoolingYear);
            if l_StructureEducationCountry.FindFirst then;

            l_StructureEducationCountry2.Reset;
            l_StructureEducationCountry2.SetCurrentKey("Sorting ID");
            l_StructureEducationCountry2.SetRange("Sorting ID", l_StructureEducationCountry."Sorting ID" + 1);
            if l_StructureEducationCountry2.FindFirst then begin
                varSchoolingYear2 := l_StructureEducationCountry2."Schooling Year";
                VarType2 := l_StructureEducationCountry2.Type;
            end else
                varSchoolingYear2 := '';
        end else
            varSchoolingYear2 := '';
    end;

    //[Scope('OnPrem')]
    procedure GetStudentName(): Text[200]
    var
        rStudent: Record Students;
    begin
        rStudent.Get(Rec."Student Code No.");
        exit(rStudent.Name);
    end;

    //[Scope('OnPrem')]
    procedure GetType()
    begin
        rStruEduCountry.Reset;
        rStruEduCountry.SetRange("Schooling Year", varSchoolingYear);
        if rStruEduCountry.FindFirst then
            VarType := rStruEduCountry.Type;
    end;

    //[Scope('OnPrem')]
    procedure Process()
    var
        l_Registration: Record Registration;
        l_rRegistrationSubjects: Record "Registration Subjects";
    begin
        if VarStudyPlan2 = '' then
            Error(Text0004);



        Rec.Reset;
        Rec.SetCurrentKey(Class, "Class No.");
        Rec.SetRange(Selection, true);
        if Rec.FindSet then begin
            repeat
                if Rec."Next School Year" = Rec."Next School Year"::"In School" then begin
                    //INSERT
                    l_Registration.Reset;
                    l_Registration.SetRange("Student Code No.", Rec."Student Code No.");
                    l_Registration.SetRange("School Year", varSchoolYear2);
                    l_Registration.SetRange("Responsibility Center", Rec."Responsibility Center");
                    l_Registration.SetRange("Schooling Year", varSchoolingYear2);
                    if VarType2 = VarType2::Simple then
                        l_Registration.SetRange("Study Plan Code", VarStudyPlan2);
                    if VarType2 = VarType2::Multi then
                        l_Registration.SetRange(Course, VarStudyPlan2);
                    if not l_Registration.FindSet then begin
                        l_Registration.Init;
                        l_Registration."Student Code No." := Rec."Student Code No.";
                        l_Registration."School Year" := varSchoolYear2;
                        l_Registration.Validate("Schooling Year", varSchoolingYear2);
                        l_Registration."Responsibility Center" := Rec."Responsibility Center";
                        if VarType2 = VarType2::Simple then
                            l_Registration.Validate("Study Plan Code", VarStudyPlan2);
                        if VarType2 = VarType2::Multi then
                            l_Registration.Validate(Course, VarStudyPlan2);
                        l_Registration.Insert(true);
                    end else begin
                        //MODIFY
                        l_Registration.Reset;
                        l_Registration.SetRange("Student Code No.", Rec."Student Code No.");
                        l_Registration.SetRange("School Year", varSchoolYear2);
                        l_Registration.SetRange("Responsibility Center", Rec."Responsibility Center");
                        if l_Registration.FindSet then begin
                            l_Registration.Validate("Schooling Year", varSchoolingYear2);
                            l_Registration."Responsibility Center" := Rec."Responsibility Center";
                            if VarType2 = VarType2::Simple then
                                l_Registration.Validate("Study Plan Code", VarStudyPlan2);
                            if VarType2 = VarType2::Multi then
                                l_Registration.Validate(Course, VarStudyPlan2);
                            l_Registration.Modify(true);
                        end;
                    end;
                    /*rAssessmentConfiguration.RESET;
                    rAssessmentConfiguration.SETRANGE("School Year",varSchoolYear);
                    rAssessmentConfiguration.SETRANGE("Study Plan Code",VarStudyPlan);
                    rAssessmentConfiguration.SETRANGE(Type,VarType);
                    rAssessmentConfiguration.SETRANGE("Use Transition Rules",TRUE);
                    IF rAssessmentConfiguration.FINDFIRST THEN BEGIN
                      rTransitionRules2.RESET;
                      rTransitionRules2.SETRANGE("Schooling Year",varSchoolingYear);
                      rTransitionRules2.SETRANGE("School Year",varSchoolYear);
                      rTransitionRules2.SETRANGE("Study Plan Code",VarStudyPlan);
                      rTransitionRules2.SETRANGE("Validation Type",rTransitionRules2."Validation Type"::Classification);
                      rTransitionRules2.SETRANGE("Rule Type",rTransitionRules2."Rule Type"::"2");
                      rTransitionRules2.SETRANGE("Not Approved",TRUE);
                      rTransitionRules2.SETRANGE("Level Group",rAssessmentConfiguration."Level Group Transition");
                      IF rTransitionRules2.FINDFIRST THEN BEGIN
                        IF "Actual Status" <> rTransitionRules2."Actual Status" THEN BEGIN
                          rTransitionRules.RESET;
                          rTransitionRules.SETRANGE("Schooling Year",varSchoolingYear);
                          rTransitionRules.SETRANGE("School Year",varSchoolYear);
                          rTransitionRules.SETRANGE("Study Plan Code",VarStudyPlan);
                          rTransitionRules.SETRANGE("Validation Type",rTransitionRules."Validation Type"::Classification);
                          rTransitionRules.SETRANGE("Rule Type",rTransitionRules."Rule Type"::"1");
                          rTransitionRules.SETRANGE("Not Approved",TRUE);
                          rTransitionRules.SETRANGE("Level Group",rAssessmentConfiguration."Level Group Transition");
                          IF rTransitionRules.FINDFIRST AND rTransitionRules."Resume School Process" THEN BEGIN
                            l_rRegistrationSubjects.RESET;
                            l_rRegistrationSubjects.SETRANGE("Student Code No.","Student Code No.");
                            l_rRegistrationSubjects.SETRANGE("School Year",varSchoolYear);
                            l_rRegistrationSubjects.SETRANGE("Schooling Year",varSchoolingYear);
                            l_rRegistrationSubjects.SETRANGE("Attendance Situation",rTransitionRules."Attendance Situation");
                            IF l_rRegistrationSubjects.FINDSET THEN
                              REPEAT
                                cCalcEvaluation.RegisterPreviousYearSubjects(l_rRegistrationSubjects,l_Registration,"Student Code No.");
                              UNTIL l_rRegistrationSubjects.NEXT = 0;
                          END;
                        END;
                      END;
                    END;*/
                    ValidateRegistrationSubject;

                    CreateClass;
                    CreateRegistrationClass;


                end;
                ChangeRec;
            until Rec.Next = 0;
            Message(Text0001);
            Rec.DeleteAll;
        end else begin
            Message(Text0002);
        end;

        Rec.Reset;

    end;

    //[Scope('OnPrem')]
    procedure ChangeRec()
    begin
        rRegistration.Reset;

        rRegistration := Rec;

        if Rec."Next School Year" = Rec."Next School Year"::"In School" then
            rRegistration."Next School Year" := rRegistration."Next School Year"::Processed;
        if Rec."Next School Year" = Rec."Next School Year"::"Not in School" then
            rRegistration."Next School Year" := rRegistration."Next School Year"::"Not in School";
        rRegistration.Selection := false;
        rRegistration.Modify;
    end;

    //[Scope('OnPrem')]
    procedure ValidateClass(): Boolean
    var
        l_Class: Record Class;
    begin
        l_Class.Reset;
        l_Class.SetRange(Class, rClass.Class);
        l_Class.SetRange("School Year", varSchoolYear2);
        l_Class.SetRange("Schooling Year", varSchoolingYear2);
        l_Class.SetRange("Study Plan Code", VarStudyPlan2);
        l_Class.SetRange(Type, VarType2);
        l_Class.SetRange(l_Class."Class Letter", VarClassLetter2);
        if l_Class.FindFirst then
            exit(false)
        else
            exit(true);
    end;

    //[Scope('OnPrem')]
    procedure CreateClass()
    var
        l_Class: Record Class;
    begin

        rClass.Reset;
        rClass.SetRange("School Year", varSchoolYear2);
        rClass.SetRange("Schooling Year", varSchoolingYear2);
        rClass.SetRange("Study Plan Code", VarStudyPlan2);
        rClass.SetRange(Type, VarType2);
        if VarClassLetter2 <> '' then
            rClass.SetRange("Class Letter", VarClassLetter2)
        else
            rClass.SetRange("Class Letter", Rec."New Class Letter");

        if not rClass.Find('-') then begin
            Clear(rClass);
            rClass.Init;
            rClass."School Year" := varSchoolYear2;
            rClass."Schooling Year" := varSchoolingYear2;
            rClass."Study Plan Code" := VarStudyPlan2;
            rClass.Type := VarType2;
            if VarClassLetter2 <> '' then
                rClass."Class Letter" := VarClassLetter2
            else
                rClass."Class Letter" := Rec."New Class Letter";

            rClass.Insert(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure CreateRegistrationClass()
    var
        l_RegistrationClass: Record "Registration Class";
        l_Students: Record Students;
    begin

        l_RegistrationClass.Reset;
        l_RegistrationClass.SetRange(Class, rClass.Class);
        l_RegistrationClass.SetRange("School Year", varSchoolYear2);
        l_RegistrationClass.SetRange("Schooling Year", varSchoolingYear2);
        l_RegistrationClass.SetRange("Study Plan Code", VarStudyPlan2);
        l_RegistrationClass.SetRange("Student Code No.", Rec."Student Code No.");
        l_RegistrationClass.SetRange(Type, VarType2);
        if not l_RegistrationClass.FindSet then begin
            l_RegistrationClass.Init;
            l_RegistrationClass.Class := rClass.Class;
            l_RegistrationClass."School Year" := varSchoolYear2;
            l_RegistrationClass."Schooling Year" := varSchoolingYear2;
            l_RegistrationClass."Study Plan Code" := VarStudyPlan2;
            l_RegistrationClass.Type := VarType2;
            l_RegistrationClass."Student Code No." := Rec."Student Code No.";
            if l_Students.Get(Rec."Student Code No.") then begin
                l_RegistrationClass.Name := l_Students.Name;
                l_RegistrationClass."Responsibility Center" := l_Students."Responsibility Center";
            end;

            l_RegistrationClass."Line No." := GetLastLineNo;
            l_RegistrationClass."Responsibility Center" := Rec."Responsibility Center";
            l_RegistrationClass.Insert(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetLastLineNo(): Integer
    var
        l_RegistrationClass: Record "Registration Class";
    begin
        l_RegistrationClass.Reset;
        l_RegistrationClass.SetRange(Class, rClass.Class);
        l_RegistrationClass.SetRange("School Year", varSchoolYear2);
        l_RegistrationClass.SetRange("Schooling Year", varSchoolingYear2);
        l_RegistrationClass.SetRange("Study Plan Code", VarStudyPlan2);
        l_RegistrationClass.SetRange(Type, VarType2);
        if l_RegistrationClass.FindLast then
            exit(l_RegistrationClass."Line No." + 10000)
        else
            exit(10000);
    end;

    //[Scope('OnPrem')]
    procedure GetSubjects(): Code[20]
    var
        l_rStruEduCountry: Record "Structure Education Country";
        rCourseLines: Record "Course Lines";
        rCourseHeader: Record "Course Header";
    begin
        rCourseLinesTEMP.DeleteAll;

        if varSchoolingYear <> '' then begin
            // Quadriennal
            if rCourseHeader.Get(VarStudyPlan) then;

            varLineNo := 10000;
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, VarStudyPlan);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
            rCourseLines.SetRange("Schooling Year Begin", rCourseHeader."Schooling Year Begin");
            if rCourseLines.FindSet then begin
                repeat
                    InsertTEMPStudyPlan(rCourseLines);
                    varLineNo += 10000;
                until rCourseLines.Next = 0;
            end;

            //Annual
            rCourseLines.Reset;
            rCourseLines.SetRange(Code, VarStudyPlan);
            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
            rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear2);
            if rCourseLines.FindSet then begin
                repeat
                    InsertTEMPStudyPlan(rCourseLines);
                    varLineNo += 10000;
                until rCourseLines.Next = 0;
            end;


            //Biennial

            rStruEduCountry.Reset;
            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
            rStruEduCountry.SetRange("Schooling Year", varSchoolingYear2);
            if rStruEduCountry.FindSet then begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, VarStudyPlan);
                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                        rCourseLines."Characterise Subjects"::Triennial);
                rCourseLines.SetRange("Schooling Year Begin", varSchoolingYear2);
                if rCourseLines.FindSet then begin
                    repeat
                        InsertTEMPStudyPlan(rCourseLines);
                        varLineNo += 10000;
                    until rCourseLines.Next = 0;
                end;

                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountryNext - 1);
                if l_rStruEduCountry.FindSet then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlan);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.FindSet then begin
                        repeat
                            InsertTEMPStudyPlan(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountryNext - 2);
                if l_rStruEduCountry.FindSet then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlan);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.FindSet then begin
                        repeat
                            InsertTEMPStudyPlan(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
                l_rStruEduCountry.Reset;
                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountryNext - 1);
                if l_rStruEduCountry.FindSet then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, VarStudyPlan);
                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                    if rCourseLines.FindSet then begin
                        repeat
                            InsertTEMPStudyPlan(rCourseLines);
                            varLineNo += 10000;
                        until rCourseLines.Next = 0;
                    end;
                end;
            end;
            rCourseLinesTEMP.Reset;
            if rCourseLinesTEMP.FindSet then begin
                if rCourseLinesTEMP.Count > 0 then
                    exit(rCourseLinesTEMP.Code)
                else
                    exit('');
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertTEMPStudyPlan(pCourseLines: Record "Course Lines")
    var
        l_recRegSubServ: Record "Registration Subjects";
        l_SPSubSubsLines: Record "Study Plan Sub-Subjects Lines";
        l_StudentSubSubPlan: Record "Student Sub-Subjects Plan ";
    begin


        rCourseLinesTEMP.Init;
        rCourseLinesTEMP.TransferFields(pCourseLines);
        rCourseLinesTEMP."Line No." := varLineNo;
        rCourseLinesTEMP.Insert;
    end;

    //[Scope('OnPrem')]
    procedure GetNoStructureCountryNext(): Integer
    begin

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if varSchoolingYear2 = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure PutSelection(pMark: Boolean)
    begin
        Rec.Reset;
        if Rec.FindSet then
            repeat
                Rec.Selection := pMark;
                Rec.Modify;
            until Rec.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure GetStudyPlan()
    var
        l_SchoolYear: Record "School Year";
        tLectiveYear: Text[1024];
        int: Integer;
        l_StrEducationCountry: Record "Structure Education Country";
        tSchoolingYear: Text[1024];
        l_StudyPlanHeader: Record "Study Plan Header";
        l_CourseHeader: Record "Course Header";
        l_text0001: Label 'The Study Plan/Course Code %1 does not exist for the %2.';
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetFilter(Status, '%1', l_SchoolYear.Status::Active);
        if l_SchoolYear.Find('-') then
            repeat
                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
            until l_SchoolYear.Next = 0;

        Clear(int);

        if tLectiveYear <> '' then begin
            int := StrMenu(tLectiveYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1', l_SchoolYear.Status::Active);
            if l_SchoolYear.Find('-') and (int <> 0) then
                l_SchoolYear.Next := int - 1
            else
                exit;
        end;

        Clear(int);

        l_StrEducationCountry.Reset;
        l_StrEducationCountry.SetCurrentKey("Sorting ID");
        if l_StrEducationCountry.FindSet then
            repeat
                tSchoolingYear := tSchoolingYear + l_StrEducationCountry."Schooling Year" + ',';
            until l_StrEducationCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StrEducationCountry.Reset;
            l_StrEducationCountry.SetCurrentKey("Sorting ID");
            if (l_StrEducationCountry.FindSet) and (int <> 0) then
                l_StrEducationCountry.Next := int - 1
            else
                exit;
        end;



        if (tSchoolingYear <> '') and (tLectiveYear <> '') then begin
            if l_StrEducationCountry.Type = l_StrEducationCountry.Type::Simple then begin
                l_StudyPlanHeader.Reset;
                l_StudyPlanHeader.SetRange(Code, VarStudyPlan);
                l_StudyPlanHeader.SetRange("School Year", l_SchoolYear."School Year");
                l_StudyPlanHeader.SetRange("Schooling Year", l_StrEducationCountry."Schooling Year");
                if l_StudyPlanHeader.FindSet then begin
                    varSchoolingYear := l_StudyPlanHeader."Schooling Year";
                    varSchoolYear := l_StudyPlanHeader."School Year";
                    VarType := Rec.Type::Simple;
                end else
                    Error(l_text0001, Rec."Study Plan Code", l_SchoolYear."School Year");

            end;
            if l_StrEducationCountry.Type = l_StrEducationCountry.Type::Multi then begin
                l_CourseHeader.SetRange(Code, VarStudyPlan);
                if l_CourseHeader.FindSet then begin
                    varSchoolingYear := l_StrEducationCountry."Schooling Year";
                    varSchoolYear := l_SchoolYear."School Year";
                    VarType := Rec.Type::Multi;
                end else
                    Error(l_text0001, Rec."Study Plan Code", l_SchoolYear."School Year");
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateRegistrationSubject()
    var
        l_RegistrationSubjects: Record "Registration Subjects";
    begin

        l_RegistrationSubjects.Reset;
        l_RegistrationSubjects.SetRange("Student Code No.", Rec."Student Code No.");
        l_RegistrationSubjects.SetRange("School Year", varSchoolYear2);
        l_RegistrationSubjects.SetRange("Schooling Year", varSchoolingYear2);
        l_RegistrationSubjects.SetRange("Study Plan Code", VarStudyPlan2);
        if not l_RegistrationSubjects.FindFirst then
            Error(Text0012, VarStudyPlan2, Rec."Student Code No.");
    end;

    local procedure varSchoolYearOnAfterValidate()
    begin
        GetLines;
        GetNextSchoolYear;
        CurrPage.Update(false);
    end;

    local procedure varSchoolingYearOnAfterValidat()
    begin
        /*GetLines;
        GetType;
        rTransitionRules2.RESET;
        rTransitionRules2.SETRANGE("Schooling Year",varSchoolingYear);
        rTransitionRules2.SETRANGE("School Year",'');
        rTransitionRules2.SETRANGE("Study Plan Code",'');
        rTransitionRules2.SETRANGE("Validation Type",rTransitionRules2."Validation Type"::Classification);
        rTransitionRules2.SETRANGE("Rule Type",rTransitionRules2."Rule Type"::"2");
        rTransitionRules2.SETRANGE("Not Approved",TRUE);
        IF rTransitionRules2.FINDFIRST THEN
          IF varTransitionStatus <> rTransitionRules2."Actual Status" THEN
             GetNextSchoolingYear
          ELSE BEGIN
            varSchoolingYear2 := varSchoolingYear;
            rStruEduCountry.RESET;
            rStruEduCountry.SETRANGE("Schooling Year",varSchoolingYear2);
            IF rStruEduCountry.FINDFIRST THEN
              VarType2 := rStruEduCountry.Type;
          END;
        
        IF VarType = VarType::Multi THEN
          VarStudyPlan2 := GetSubjects;
        
        CurrPage.UPDATE(FALSE);*/

    end;

    local procedure varClassOnAfterValidate()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure varTransitionStatusOnAfterVali()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure varSchoolYear2OnAfterValidate()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure VarClassLetterOnAfterValidate()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure VarStudyPlanOnAfterValidate()
    begin
        GetLines;
        if VarType = VarType::Multi then
            VarStudyPlan2 := GetSubjects;
        CurrPage.Update(false);
    end;

    local procedure varClass2OnAfterValidate()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure VarClassLetter2OnAfterValidate()
    begin
        GetLines;
        CurrPage.Update(false);
    end;

    local procedure SelectionOnPush()
    var
        l_Registration: Record Registration;
    begin
        if Rec.Selection then begin
            if l_Registration.Get(Rec."Student Code No.", varSchoolYear2, Rec."Responsibility Center") then
                if Confirm(Text0003, false, Rec."Student Code No.", GetStudentName) then begin
                    if l_Registration.Status = l_Registration.Status::" " then begin
                        l_Registration.Level := 0;
                        l_Registration.Type := 0;
                        l_Registration.Validate("Study Plan Code", '');
                        l_Registration.Validate("Services Plan Code", '');
                        l_Registration.Validate(Course, '');
                        l_Registration.Delete(true);

                    end else begin
                        Rec.Selection := false;
                        Rec.Modify;
                        Message(Text0005);
                    end;
                end else begin
                    Rec.Selection := false;
                    Rec.Modify;
                end;
        end;
    end;
}

#pragma implicitwith restore

