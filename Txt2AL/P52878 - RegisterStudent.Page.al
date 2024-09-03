#pragma implicitwith disable
page 52878 "Register Student"
{
    Caption = 'Register Student';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = NavigatePage;
    SourceTable = Registration;

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                label(Control1110020)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19012232;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(SY1; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(RSY1; rRegSubjects."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field(SCN1; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Codi matèries';
                    Editable = false;
                }
                field(rSN1; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(sRSSC1; rRegSubjects."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects Code';
                    Editable = false;
                }
                field(RRSD1; rRegSubjects.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control1110009)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19080001;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(SY2; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(RSY2; rRegSubjects."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field(SCN2; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Codi matèries';
                    Editable = false;
                }
                field(rSN2; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(sRSSC2; rRegSubjects."Subjects Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects Code';
                    Editable = false;
                }
                field(RRSD2; rRegSubjects.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                }
                field(NewClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class';
                    Editable = NewClassEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rCourseLines: Record "Course Lines";
                        l_rStudyPlanLines: Record "Study Plan Lines";
                        l_RegistrationClass: Record "Registration Class";
                        l_RegSubjects: Record "Registration Subjects";
                    begin

                        rClassTemp.DeleteAll;


                        if rRegSubjects.Type = rRegSubjects.Type::Simple then begin
                            l_rStudyPlanLines.Reset;
                            l_rStudyPlanLines.SetRange("School Year", rRegSubjects."School Year");
                            l_rStudyPlanLines.SetRange("Schooling Year", rRegSubjects."Schooling Year");
                            l_rStudyPlanLines.SetRange("Subject Code", rRegSubjects."Subjects Code");
                            l_rStudyPlanLines.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                            if l_rStudyPlanLines.Find('-') then begin
                                repeat
                                    rClass.Reset;
                                    rClass.SetRange("School Year", Rec."School Year");
                                    rClass.SetRange("Study Plan Code", l_rStudyPlanLines.Code);
                                    rClass.SetRange(Type, rClass.Type::Simple);
                                    rClass.SetRange("Schooling Year", l_rStudyPlanLines."Schooling Year");
                                    rClass.SetRange("Responsibility Center", l_rStudyPlanLines."Responsibility Center");
                                    rClass.SetRange(Class, l_RegSubjects.Class);
                                    if rClass.Find('-') then begin
                                        repeat
                                            rClassTemp.Reset;
                                            rClassTemp.SetRange(Class, rClass.Class);

                                            if not rClassTemp.Find('-') then begin
                                                rClassTemp.Init;
                                                rClassTemp.TransferFields(rClass);
                                                rClassTemp.Insert;
                                            end;
                                        until rClass.Next = 0;
                                    end;
                                until l_rStudyPlanLines.Next = 0;
                            end;
                        end;

                        if rRegSubjects.Type = rRegSubjects.Type::Multi then begin
                            l_rCourseLines.Reset;
                            l_rCourseLines.SetRange("Subject Code", rRegSubjects."Subjects Code");
                            l_rCourseLines.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                            if l_rCourseLines.Find('-') then begin
                                repeat
                                    rClass.Reset;
                                    rClass.SetRange("School Year", Rec."School Year");
                                    rClass.SetRange("Study Plan Code", l_rCourseLines.Code);
                                    rClass.SetRange(Type, rClass.Type::Multi);
                                    rClass.SetRange("Schooling Year", rRegSubjects."Schooling Year");
                                    rClass.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                                    if rClass.Find('-') then begin
                                        repeat
                                            rClassTemp.Reset;
                                            rClassTemp.SetRange(Class, rClass.Class);

                                            if not rClassTemp.Find('-') then begin
                                                rClassTemp.Init;
                                                rClassTemp.TransferFields(rClass);
                                                rClassTemp.Insert;
                                            end;
                                        until rClass.Next = 0;
                                    end;
                                until l_rCourseLines.Next = 0;
                            end;
                        end;

                        rClassTemp.Reset;
                        if PAGE.RunModal(PAGE::"Class List", rClassTemp) = ACTION::LookupOK then begin
                            varClass := rClassTemp.Class;
                            GetClassStudents;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        l_RegSubjects: Record "Registration Subjects";
                        l_rCourseLines: Record "Course Lines";
                        l_rStudyPlanLines: Record "Study Plan Lines";
                    begin
                        if rRegSubjects.Type = rRegSubjects.Type::Simple then begin
                            l_rStudyPlanLines.Reset;
                            l_rStudyPlanLines.SetRange("School Year", rRegSubjects."School Year");
                            l_rStudyPlanLines.SetRange("Schooling Year", rRegSubjects."Schooling Year");
                            l_rStudyPlanLines.SetRange("Subject Code", rRegSubjects."Subjects Code");
                            l_rStudyPlanLines.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                            if l_rStudyPlanLines.Find('-') then begin
                                repeat
                                    rClass.Reset;
                                    rClass.SetRange("School Year", Rec."School Year");
                                    rClass.SetRange("Study Plan Code", l_rStudyPlanLines.Code);
                                    rClass.SetRange(Type, rClass.Type::Simple);
                                    rClass.SetRange("Schooling Year", l_rStudyPlanLines."Schooling Year");
                                    rClass.SetRange("Responsibility Center", l_rStudyPlanLines."Responsibility Center");
                                    rClass.SetRange(Class, l_RegSubjects.Class);
                                    if rClass.Find('-') then begin
                                        repeat
                                            rClassTemp.Reset;
                                            rClassTemp.SetRange(Class, rClass.Class);

                                            if not rClassTemp.Find('-') then begin
                                                rClassTemp.Init;
                                                rClassTemp.TransferFields(rClass);
                                                rClassTemp.Insert;
                                            end;
                                        until rClass.Next = 0;
                                    end;
                                until l_rStudyPlanLines.Next = 0;
                            end;
                        end;

                        if rRegSubjects.Type = rRegSubjects.Type::Multi then begin
                            l_rCourseLines.Reset;
                            l_rCourseLines.SetRange("Subject Code", rRegSubjects."Subjects Code");
                            l_rCourseLines.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                            if l_rCourseLines.Find('-') then begin
                                repeat
                                    rClass.Reset;
                                    rClass.SetRange("School Year", Rec."School Year");
                                    rClass.SetRange("Study Plan Code", l_rCourseLines.Code);
                                    rClass.SetRange(Type, rClass.Type::Multi);
                                    rClass.SetRange("Schooling Year", rRegSubjects."Schooling Year");
                                    rClass.SetRange("Responsibility Center", rRegSubjects."Responsibility Center");
                                    if rClass.Find('-') then begin
                                        repeat
                                            rClassTemp.Reset;
                                            rClassTemp.SetRange(Class, rClass.Class);

                                            if not rClassTemp.Find('-') then begin
                                                rClassTemp.Init;
                                                rClassTemp.TransferFields(rClass);
                                                rClassTemp.Insert;
                                            end;
                                        until rClass.Next = 0;
                                    end;
                                until l_rCourseLines.Next = 0;
                            end;
                        end;

                        if rClassTemp.Get(varClass, rRegSubjects."School Year") then
                            GetClassStudents
                        else
                            Error(Text0004);

                        /*
                        l_RegSubjects.RESET;
                        l_RegSubjects.SETRANGE("School Year","School Year");
                        l_RegSubjects.SETRANGE("Subjects Code",rRegSubjects."Subjects Code");
                        l_RegSubjects.SETRANGE("Schooling Year",rRegSubjects."Schooling Year");
                        l_RegSubjects.SETFILTER(Class,varClass);
                        l_RegSubjects.SETRANGE("Responsibility Center",rRegSubjects."Responsibility Center");
                        IF l_RegSubjects.FIND('-') THEN
                          GetClassStudents
                        ELSE
                          ERROR(Text0004);
                        */

                    end;
                }
                field(VarTotalClassStudents; VarTotalClassStudents)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'No. Students';
                    Editable = false;
                }
                field(varData; varData)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = All;
                Caption = '&Back';
                Enabled = BackEnable;
                Image = PreviousRecord;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetSubMenu(CurrMenuType, false);
                    CurrMenuType := CurrMenuType - 1;
                    SetSubMenu(CurrMenuType, true);
                end;
            }
            action(Next)
            {
                ApplicationArea = All;
                Caption = '&Next';
                Enabled = NextEnable;
                Image = NextRecord;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetSubMenu(CurrMenuType, false);
                    CurrMenuType := CurrMenuType + 1;
                    SetSubMenu(CurrMenuType, true);
                    GetClassStudents;
                    CurrPage.Update;
                end;
            }
            action(Terminar)
            {
                ApplicationArea = All;
                Caption = '&Terminar';
                Enabled = EndEnabled;
                Image = Save;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedIsBig = true;

                trigger OnAction()
                begin

                    if varData = 0D then
                        Error(Text0001);

                    cStudentsRegistration.StudentRegSubject(rRegSubjects, Rec, varClass, varData);

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if rStudents.Get(Rec."Student Code No.") then;

        if Rec.Type = Rec.Type::Simple then begin
            rRegistration.Get(Rec."Student Code No.", Rec."School Year", rStudents."Responsibility Center");
            rClass.Reset;
            rClass.SetRange("School Year", Rec."School Year");
            rClass.SetRange("Schooling Year", Rec."Schooling Year");
            rClass.SetRange(Class, rRegistration.Class);
            if rClass.Find('-') then
                varClass := rClass.Class;
            NewClassEditable := false;
        end;
    end;

    trigger OnInit()
    begin
        NextEnable := true;
        NewClassEditable := true;
    end;

    trigger OnOpenPage()
    begin
        //CurrForm.Subform1.XPOS := 4850;
        //CurrForm.Subform1.YPOS := 3150;
        //CurrForm.Step4.XPOS := 4400;
        //CurrForm.Step4.YPOS := 0;

        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := CancelYPos + CancelHeight + 220;
        FrmWidth := FormWidth;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);



        Rec.SetRange("Student Code No.", rRegSubjects."Student Code No.");
        Rec.SetRange("School Year", rRegSubjects."School Year");
        Rec.SetRange("Schooling Year", rRegSubjects."Schooling Year");

        if rStudents.Get(Rec."Student Code No.") then;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        CurrMenuType: Integer;
        FormWidth: Integer;
        Text0001: Label 'Insert Date';
        rRegSubjects: Record "Registration Subjects";
        rStudents: Record Students;
        varData: Date;
        cStudentsRegistration: Codeunit "Students Registration";
        Text0002: Label 'Cancel subject %1-%2 for student %3-%4. Are you sure?';
        Text0003: Label 'Operation interrupted by the user.';
        varClass: Code[20];
        rClass: Record Class;
        rRegistration: Record Registration;
        VarTotalClassStudents: Integer;
        cUserEducation: Codeunit "User Education";
        rClassTemp: Record Class temporary;
        Text0004: Label 'The class does not have the selected subject.';
        [InDataSet]
        NewClassEditable: Boolean;
        CancelXPos: Integer;
        CancelYPos: Integer;
        CancelHeight: Integer;
        CancelWidth: Integer;
        FrmXPos: Integer;
        FrmYPos: Integer;
        FrmHeight: Integer;
        FrmWidth: Integer;
        [InDataSet]
        Step1Visible: Boolean;
        [InDataSet]
        Step2Visible: Boolean;
        [InDataSet]
        FinishEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        Text19012232: Label 'Assistant';
        Text19080001: Label 'Assistant';
        EndEnabled: Boolean;

    local procedure SetSubMenu(MenuType: Integer; Visible: Boolean)
    begin
        case MenuType of
            1:
                begin
                    Step1Visible := Visible;
                    if Visible then begin
                        FinishEnable := false;
                        BackEnable := false;
                        NextEnable := true;
                        EndEnabled := false;
                    end;
                end;
            2:
                begin
                    Step2Visible := Visible;
                    FinishEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                    EndEnabled := true;
                    if Visible then;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetStudentSubjects(pRegSubjects: Record "Registration Subjects")
    begin
        rRegSubjects := pRegSubjects;

        if rStudents.Get(Rec."Student Code No.") then;
    end;

    //[Scope('OnPrem')]
    procedure GetClassStudents()
    var
        rRegistrationClass: Record "Registration Class";
    begin
        rRegistrationClass.Reset;
        rRegistrationClass.SetRange(Class, varClass);
        rRegistrationClass.SetRange("School Year", rRegSubjects."School Year");
        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
        if rRegistrationClass.Find('-') then
            VarTotalClassStudents := rRegistrationClass.Count
        else
            VarTotalClassStudents := 0;
    end;

    local procedure LookupOKOnPush()
    var
        TestHeader: Record Test;
    begin
        if varData = 0D then
            Error(Text0001);

        cStudentsRegistration.StudentRegSubject(rRegSubjects, Rec, varClass, varData);

        CurrPage.Close;
    end;
}

#pragma implicitwith restore

