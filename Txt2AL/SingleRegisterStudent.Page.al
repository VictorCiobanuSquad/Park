#pragma implicitwith disable
page 31009903 "Single Register Student"
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
                    CaptionClass = Text19012232;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(schooly1; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(schoolingy1; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(studcodeno1; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(studname1; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(suj1; varSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects Code';
                    TableRelation = Subjects.Code;

                    trigger OnValidate()
                    begin
                        if rSubjects.Get(1, varSubjects) then;
                    end;
                }
                field(subdesc1; rSubjects.Description)
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
                    CaptionClass = Text19080001;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(schooly2; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(schoolingy2; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(studcodeno2; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(studname2; rStudents.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(suj2; varSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects Code';
                    Editable = false;
                    TableRelation = Subjects.Code;
                }
                field(subdesc2; rSubjects.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
                }
                field(varClass; varClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rCourseLines: Record "Course Lines";
                    begin
                        Clear(rClassTEMP);

                        rRegSubjects.Reset;
                        rRegSubjects.SetRange("Subjects Code", varSubjects);
                        rRegSubjects.SetRange(Type, rRegSubjects.Type::Multi);
                        rRegSubjects.SetFilter(Class, '<>%1', '');
                        rRegSubjects.SetRange("Responsibility Center", Rec."Responsibility Center");
                        if rRegSubjects.Find('-') then begin
                            repeat
                                rClass.Reset;
                                rClass.SetRange("School Year", Rec."School Year");
                                rClass.SetRange(Type, rClass.Type::Multi);
                                rClass.SetRange("Responsibility Center", Rec."Responsibility Center");
                                rClass.SetRange(Class, rRegSubjects.Class);
                                if rClass.Find('-') then begin
                                    rClassTEMP.Reset;
                                    rClassTEMP.SetRange(Class, rClass.Class);
                                    if not rClassTEMP.Find('-') then begin
                                        rClassTEMP.Init;
                                        rClassTEMP.TransferFields(rClass);
                                        rClassTEMP.Insert;
                                    end;
                                end;
                            until rRegSubjects.Next = 0;
                        end;


                        rClassTEMP.Reset;
                        if PAGE.RunModal(PAGE::"Class List", rClassTEMP) = ACTION::LookupOK then begin
                            varClass := rClassTEMP.Class;
                            VarStudyPlan := rClassTEMP."Study Plan Code";
                            VarSchoolingYear := rClassTEMP."Schooling Year";
                        end;
                    end;

                    trigger OnValidate()
                    var
                        rCourseLines: Record "Course Lines";
                    begin

                        rClass.Reset;
                        rClass.SetRange("School Year", Rec."School Year");
                        rClass.SetRange(Type, rClass.Type::Multi);
                        rClass.SetRange(Class, varClass);
                        if rClass.FindFirst then begin
                            varClass := rClass.Class;
                            VarStudyPlan := rClass."Study Plan Code";
                            VarSchoolingYear := rClass."Schooling Year";
                        end else
                            Error(Text0005);

                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, VarStudyPlan);
                        rCourseLines.SetRange("Subject Code", varSubjects);
                        if not rCourseLines.FindFirst then
                            Error(Text0004)
                    end;
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
            action(Ending)
            {
                Caption = 'Ending';
                Image = Save;
                InFooterBar = true;

                trigger OnAction()
                begin

                    if varData = 0D then
                        Error(Text0001);


                    cStudentsRegistration.StudentSingleSubReg(varSubjects, Rec, varClass, varData, VarSchoolingYear);


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
        Text0002: Label 'Cancel de subject %1-%2 for the student %3-%4. Are you sure?';
        Text0003: Label 'Operation interrupted by the user';
        varClass: Code[20];
        rClass: Record Class;
        varSubjects: Code[10];
        rSubjects: Record Subjects;
        VarStudyPlan: Code[20];
        Text0004: Label 'The Subject does not exist on the selected Plan of the Class. Choose another Class.';
        Text0005: Label 'The selected Class does not exist.';
        VarSchoolingYear: Code[10];
        rCourseLines: Record "Course Lines";
        rClassTEMP: Record Class temporary;
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
    procedure GetStudentSubjects(pRegSubjects: Record "Registration Subjects")
    begin
        rRegSubjects := pRegSubjects;
    end;

    local procedure LookupOKOnPush()
    var
        TestHeader: Record Test;
    begin
        if varData = 0D then
            Error(Text0001);


        cStudentsRegistration.StudentSingleSubReg(varSubjects, Rec, varClass, varData, VarSchoolingYear);


        CurrPage.Close;
    end;
}

#pragma implicitwith restore

