#pragma implicitwith disable
page 52877 "Cancel Subjects Wizard"
{
    Caption = 'Subjects Wizard';
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
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text19012232;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(SY1; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(rSY1; rRegSubjects."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field(SCN1; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(RSN1; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(RRSSC1; rRegSubjects."Subjects Code")
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
                field(rS1; Format(rRegSubjects.Status))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Status';
                    Editable = false;
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control1110009)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text19080001;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(SY2; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(rSY2; rRegSubjects."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field(SCN2; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(RSN2; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(RRSSC2; rRegSubjects."Subjects Code")
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
                field(rS2; Format(rRegSubjects.Status))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Status';
                    Editable = false;
                }
                field(varOption; varOption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Status';
                    Editable = false;
                    OptionCaption = 'Correct,Subscribed,Transfer,Annul,Completed';
                }
                field(varData; varData)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                }
                field(NewClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class';
                    Visible = NewClassVisible;

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
                        rClassTemp.SetFilter(Class, '<>%1', Rec.Class);
                        if PAGE.RunModal(PAGE::"Class List", rClassTemp) = ACTION::LookupOK then begin
                            varClass := rClassTemp.Class;
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
                    end;
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
                ApplicationArea = Basic, Suite;
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
                ApplicationArea = Basic, Suite;
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
                end;
            }
            action(Terminar)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Terminar';
                Enabled = EndEnable;
                Image = Save;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;
                //PromotedIsBig = true;

                trigger OnAction()
                var
                    l_TextAnull: Label 'Annul';
                    l_TextTransfer: Label 'Transfer';
                    l_TextCorrect: Label 'Correct';
                begin

                    if varData = 0D then
                        Error(Text0001);

                    if varOption = varOption::Annul then
                        varText := l_TextAnull;

                    if varOption = varOption::Transfer then
                        varText := l_TextTransfer;

                    if varOption = varOption::Correct then
                        varText := l_TextCorrect;


                    if Confirm(Text0002, true, rRegSubjects."Subjects Code", rRegSubjects.Description,
                                             rRegSubjects."Student Code No.", rStudents.Name, Format(varText)) then
                        cStudentsRegistration.CancelStudentSubject(rRegSubjects, varData, varOption, varClass)
                    else
                        Error(Text0003);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if rStudents.Get(Rec."Student Code No.") then;
    end;

    trigger OnInit()
    begin
        NextEnable := true;
        NewClassVisible := true;
        EndEnable := false;
    end;

    trigger OnOpenPage()
    begin
        //CurrPage.Subform1.XPOS := 4850;
        //CurrPage.Subform1.YPOS := 3150;
        //CurrPage.Step4.XPOS := 4400;
        //CurrPage.Step4.YPOS := 0;

        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := CancelYPos + CancelHeight + 220;
        FrmWidth := FormWidth;

        if varOption = varOption::Transfer then
            NewClassVisible := true
        else
            NewClassVisible := false;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);


        Rec.SetRange("Student Code No.", rRegSubjects."Student Code No.");
        Rec.SetRange("School Year", rRegSubjects."School Year");
        //SETRANGE("Schooling Year",rRegSubjects."Schooling Year");


        //IF rStudents.GET("Student Code No.") THEN;
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
        Text0002: Label '%5 the subject %1-%2 for the student %3-%4. Are you sure?';
        Text0003: Label 'Operation interrupted by the user.';
        varOption: Option Correct,,Transfer,Annul,Finished;
        varClass: Code[20];
        rClass: Record Class;
        Text0004: Label 'The selected class doesnt exist.';
        rClassTemp: Record Class temporary;
        varText: Text[30];
        [InDataSet]
        NewClassVisible: Boolean;
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
        EndEnable: Boolean;

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
                        EndEnable := false;
                    end;
                end;
            2:
                begin
                    Step2Visible := Visible;
                    FinishEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                    EndEnable := true;
                    if Visible then;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetStudentSubjects(pRegSubjects: Record "Registration Subjects"; pOption: Option Correct,,Transfer,Annul,Finished)
    begin
        rRegSubjects := pRegSubjects;

        varOption := pOption;
    end;

    local procedure LookupOKOnPush()
    var
        l_TextAnull: Label 'Annul';
        l_TextTransfer: Label 'Transfer';
        l_TextCorrect: Label 'Correct';
    begin
        if varData = 0D then
            Error(Text0001);

        if varOption = varOption::Annul then
            varText := l_TextAnull;

        if varOption = varOption::Transfer then
            varText := l_TextTransfer;

        if varOption = varOption::Correct then
            varText := l_TextCorrect;


        if Confirm(Text0002, true, rRegSubjects."Subjects Code", rRegSubjects.Description,
                                 rRegSubjects."Student Code No.", rStudents.Name, Format(varText)) then
            cStudentsRegistration.CancelStudentSubject(rRegSubjects, varData, varOption, varClass)
        else
            Error(Text0003);

        CurrPage.Close;
    end;
}

#pragma implicitwith restore

