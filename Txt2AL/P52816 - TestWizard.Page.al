#pragma implicitwith disable
page 52816 "Test Wizard"
{
    Caption = 'Test Wizard';
    DataCaptionExpression = Caption;
    PageType = NavigatePage;
    SourceTable = "Candidate Entry";

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                label(Control2)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19058462;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Candidate No."; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("rCandidate.Name"; rCandidate.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(TestOption; TestOption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Entry Type';
                    OptionCaption = 'New,Existing';

                    trigger OnValidate()
                    begin
                        Clear(cRoom);
                        Clear(cTeacher);
                        Clear(rTeacher.Name);
                        Clear(rTeacher."Last Name");
                        Clear(cTime);
                        Clear(cDate);
                        Clear(cDescription);
                        Clear(cTestNo);
                        Clear(cDuration);
                    end;
                }
                field(cTypeOfTest; cTypeOfTest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Type';
                    OptionCaption = ' ,Interview,Group Interview,Specific test,Aptitude test,Other,Psychologist';
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control8)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19051622;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(CandNo2; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CandFN2; rCandidate.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(cDate; cDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                }
                field(cTime; cTime)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Time';
                }
                field(cRoom; cRoom)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Room';
                    TableRelation = Room."Room Code";

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_room: Record Room;
                    begin
                        l_room.Reset;
                        l_room.SetFilter("Responsibility Center", Rec."Responsibility Center");
                        if PAGE.RunModal(PAGE::"Room List", l_room) = ACTION::LookupOK then
                            cRoom := l_room."Room Code";
                    end;

                    trigger OnValidate()
                    var
                        l_Room: Record Room;
                    begin
                        if cRoom <> '' then begin
                            l_Room.Reset;
                            l_Room.SetRange("Room Code", cRoom);
                            l_Room.SetFilter("Responsibility Center", Rec."Responsibility Center");
                            if not l_Room.Find('-') then
                                Error(Text004);
                        end;
                    end;
                }
                field(cDuration; cDuration)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Duration';
                }
                field(cTeacher; cTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher';
                    TableRelation = Teacher."No.";

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_Teacher: Record Teacher;
                    begin


                        rTeacher.Reset;
                        rTeacher.SetFilter("Responsibility Center", Rec."Responsibility Center");
                        if PAGE.RunModal(PAGE::"Teacher List", rTeacher) = ACTION::LookupOK then
                            cTeacher := rTeacher."No.";
                    end;

                    trigger OnValidate()
                    begin
                        if cTeacher <> '' then begin
                            rTeacher.Reset;
                            rTeacher.SetRange("No.", cTeacher);
                            rTeacher.SetFilter("Responsibility Center", Rec."Responsibility Center");
                            if not rTeacher.Find('-') then
                                Error(Text005);
                        end else
                            Clear(cTeacher);
                    end;
                }
                field("rTeacher.Name + ' ' +  rTeacher.""Last Name"""; rTeacher.Name + ' ' + rTeacher."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher Name';
                    Editable = false;
                }
                field(s; cDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
            }
            group(Step3)
            {
                Visible = Step3Visible;
                label(Control1110061)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19041819;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(CandNo3; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CandFN3; rCandidate."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                part(Subform1; "Test Wizard Subform")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = Subform1Visible;
                }
            }
            group(Step4)
            {
                Visible = Step4Visible;
                label(Control1110026)
                {
                    ApplicationArea = All;
                    CaptionClass = Text19049092;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(CandNo4; Rec."Candidate No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CandFN4; rCandidate."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(cTestNo; cTestNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test No.';
                    Editable = false;
                }
                field(Timer; cTime)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Time';
                    Editable = false;
                }
                field(cDat; cDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                    Editable = false;
                }
                field(Roomer; cRoom)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Room';
                    Editable = false;
                    TableRelation = Room."Room Code";
                }
                field(cTea; cTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher';
                    Editable = false;
                    TableRelation = Teacher."No.";

                    trigger OnValidate()
                    begin
                        if cTeacher <> '' then begin
                            rTeacher.Get(cTeacher);
                        end
                        else begin
                            Clear(cTeacher);
                        end;
                    end;
                }
                field(cDur; cDuration)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Duration';
                    Editable = false;
                }
                field(rTeaN; rTeacher.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher Name';
                    Editable = false;
                }
                field(cDesc; cDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    Editable = false;
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
                //Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

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
                //Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetSubMenu(CurrMenuType, false);

                    CurrMenuType := CurrMenuType + 1;
                    SetSubMenu(CurrMenuType, true);
                end;
            }
            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'F&inish';
                Image = Save;
                InFooterBar = true;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin

                    if TestOption = TestOption::New then
                        TextToConfirm := Text002
                    else
                        TextToConfirm := Text003;

                    if Confirm(StrSubstNo(Text001, TextToConfirm, Rec."Candidate No."), true) then begin
                        if TestOption = TestOption::New then begin
                            cTestNo :=
                            rTest.CreateTest(Rec."Candidate No.", cDescription, cTypeOfTest, cDate, cTime, cDuration, cRoom, cTeacher,
                                             Rec."School Year", Rec."Schooling Year");
                        end
                        else begin
                            cTestNo :=
                            rTest.ChangeTest(Rec."Candidate No.", cTestNo, Rec."School Year", Rec."Schooling Year");
                        end;
                    end;

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        NextEnable := true;
        Subform1Visible := true;
    end;

    trigger OnOpenPage()
    begin

        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := CancelYPos + CancelHeight + 220;
        FrmWidth := FormWidth;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        Clear(rCandidate);
        rCandidate.SetRange("No.", Rec."Candidate No.");
        if rCandidate.FindFirst then;

        Clear(rTest);
        rTest.SetFilter(rTest.Date, '>=%1|%2', WorkDate, 0D);
        rTest.SetRange(rTest."School Year", Rec."School Year");
        rTest.SetRange(rTest."Schooling Year", Rec."Schooling Year");
        CurrPage.Subform1.PAGE.SetTableView(rTest);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        Text001: Label 'Do you want to %1 candidate %2? Are you sure?';
        CurrMenuType: Integer;
        FormWidth: Integer;
        rCandidate: Record Candidate;
        rTeacher: Record Teacher;
        rTest: Record Test;
        TestOption: Option New,Exist;
        cRoom: Code[20];
        cTeacher: Code[20];
        cTime: Time;
        cDate: Date;
        cDescription: Text[30];
        cTestNo: Code[20];
        cTypeOfTest: Option " ",Interview,"Group Interview","Specific test","Aptitude test",Other,Psychologist,"Recover Test";
        cDuration: Decimal;
        TextToConfirm: Text[250];
        Text002: Label 'Create a new test?';
        Text003: Label 'Associate to an existing test?';
        cUserEducation: Codeunit "User Education";
        Text004: Label 'There is no room for the seleted responsibilty center.';
        Text005: Label 'There is no Teacher for the seleted responsibilty center.';
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
        Step3Visible: Boolean;
        [InDataSet]
        Subform1Visible: Boolean;
        [InDataSet]
        Step4Visible: Boolean;
        [InDataSet]
        FinishEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        Text19058462: Label 'Test Assistant';
        Text19051622: Label 'Are you sure you want to create a new Test?';
        Text19041819: Label 'Are you sure you want to associate to an existing Test?';
        Text19049092: Label 'Are you sure you want to associate to selected Test?';

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

                    end;
                end;
            2:
                begin
                    if TestOption = TestOption::New then begin
                        Step2Visible := Visible;
                        FinishEnable := true;
                        BackEnable := true;
                        NextEnable := false;
                        if Visible then;
                    end
                    else begin
                        Step3Visible := Visible;
                        Subform1Visible := Visible;
                        FinishEnable := false;
                        BackEnable := true;
                        NextEnable := true;
                        if Visible then;
                    end
                end;
            3:
                begin
                    if TestOption = TestOption::Exist then begin
                        Clear(rTest);
                        CurrPage.Subform1.PAGE.GetRecord(rTest);
                        if rTest."Test No." <> '' then begin
                            cRoom := rTest.Room;
                            cTeacher := rTest."Teacher No.";
                            cTime := rTest.Hour;
                            cDate := rTest.Date;
                            cDescription := rTest.Description;
                            cTestNo := rTest."Test No.";
                            cDuration := rTest.Duration;
                            if not rTeacher.Get(cTeacher) then
                                Clear(rTeacher);
                        end;
                        Step4Visible := Visible;
                        FinishEnable := true;
                        BackEnable := true;
                        NextEnable := false;
                        if Visible then begin
                            CurrPage.Update(false);
                        end;
                    end
                end;

        end;
    end;

    //[Scope('OnPrem')]
    procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
    end;

    local procedure LookupOKOnPush()
    var
        TestHeader: Record Test;
    begin
        if TestOption = TestOption::New then
            TextToConfirm := Text002
        else
            TextToConfirm := Text003;

        if Confirm(StrSubstNo(Text001, TextToConfirm, Rec."Candidate No."), true) then begin
            if TestOption = TestOption::New then begin
                cTestNo :=
                rTest.CreateTest(Rec."Candidate No.", cDescription, cTypeOfTest, cDate, cTime, cDuration, cRoom, cTeacher,
                                 Rec."School Year", Rec."Schooling Year");
            end
            else begin
                cTestNo :=
                rTest.ChangeTest(Rec."Candidate No.", cTestNo, Rec."School Year", Rec."Schooling Year");
            end;
        end;

        CurrPage.Close;
    end;
}

#pragma implicitwith restore

