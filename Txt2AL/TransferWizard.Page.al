#pragma implicitwith disable
page 31009788 "Transfer Wizard"
{
    Caption = 'Transfer Wizard';
    DataCaptionExpression = Caption;
    PageType = NavigatePage;
    SourceTable = "Registration Class";

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                label(Control2)
                {
                    CaptionClass = Text19069539;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Class No."; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(TransferOption; TransferOption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Type';
                    OptionCaption = 'Class,School';

                    trigger OnValidate()
                    begin
                        Clear(TransferSchoolName);
                        Clear(VarNewClass);
                    end;
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control8)
                {
                    CaptionClass = Text19020813;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(SY2; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(ScY2; Rec."Schooling Year")
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
                field(Name2; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class2; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CN2; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(NewClass; VarNewClass)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New Class';
                    Editable = NewClassEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rClass.Reset;
                        rClass.SetRange("School Year", Rec."School Year");
                        rClass.SetRange("Schooling Year", Rec."Schooling Year");
                        rClass.SetRange("Study Plan Code", VarStudyPlanCode);
                        rClass.SetFilter(Class, '<>%1', Rec.Class);
                        if rClass.Find('-') then;

                        if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                            VarNewClass := rClass.Class;
                            VarNewStudyPlanCode := rClass."Study Plan Code";
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        rClass.Reset;
                        rClass.SetRange("School Year", Rec."School Year");
                        rClass.SetRange("Schooling Year", Rec."Schooling Year");
                        rClass.SetRange("Study Plan Code", VarStudyPlanCode);
                        rClass.SetRange(Class, VarNewClass);
                        if rClass.Find('-') then begin
                            if Rec.Class = VarNewClass then
                                Error(Text007);
                        end else
                            Error(Text007)
                    end;
                }
                field(TransferDate; TransferDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Date';
                }
            }
            group(Step3)
            {
                Visible = Step3Visible;
                label(Control1102065003)
                {
                    CaptionClass = Text19080001;
                    MultiLine = true;
                    ShowCaption = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field(SY3; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(ScY3; Rec."Schooling Year")
                {
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field(SCN3; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name3; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Class3; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CN3; Rec."Class No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varSchoolCode; varSchoolCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Code';
                    TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE("Legal Code Type" = FILTER(" "),
                                                                                        Type = FILTER(School));

                    trigger OnValidate()
                    begin
                        rLegalCodes.Reset;
                        rLegalCodes.SetRange(Type, rLegalCodes.Type::School);
                        rLegalCodes.SetRange("Parish/Council/District Code", varSchoolCode);
                        rLegalCodes.SetRange("Legal Code Type", rLegalCodes."Legal Code Type"::" ");
                        if rLegalCodes.FindSet then
                            TransferSchoolName := rLegalCodes."School Name"
                        else
                            TransferSchoolName := '';
                    end;
                }
                field(TD; TransferDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer Date';
                }
                field(NewSchool; TransferSchoolName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transfer School Name';
                    Editable = NewSchoolEditable;
                }
                field(txtDestination; Rec.Destination)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Destination';
                    Editable = txtDestinationEditable;
                    OptionCaption = ' ,Public School,Private School,Foreign';
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
                    if TransferOption = TransferOption::Class then
                        CurrMenuType := CurrMenuType - 1
                    else
                        CurrMenuType := CurrMenuType - 2;

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
                    if TransferOption = TransferOption::Class then
                        CurrMenuType := CurrMenuType + 1
                    else
                        CurrMenuType := CurrMenuType + 2;
                    SetSubMenu(CurrMenuType, true);
                end;
            }
            action(Terminar)
            {
                Caption = '&Terminar';
                Image = Approve;
                InFooterBar = true;
                //Promoted = true;
                //PromotedIsBig = false;

                trigger OnAction()
                begin

                    if TransferDate = 0D then
                        Error(Text002);
                    if Confirm(Text001, true) then begin
                        if TransferOption = TransferOption::Class then begin
                            if VarNewClass = '' then
                                Error(Text003);
                            if VarNewClass = Rec.Class then
                                Error(Text006, Rec."Student Code No.", Rec.Class, VarNewClass);
                            Rec.TransferStudent(TransferDate, VarNewClass, '', VarNewStudyPlanCode, 0);
                        end else begin
                            if TransferSchoolName = '' then
                                Error(Text004);
                            if Rec.Destination = 0 then Error(Text008);
                            Rec.TransferStudent(TransferDate, '', TransferSchoolName, '', Rec.Destination);
                            Rec.InsertStudentSchoolName(varSchoolCode);
                        end;
                    end;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        VarNewClassOnFormat;
        TransferSchoolNameOnFormat;
        DestinationOnFormat;
    end;

    trigger OnInit()
    begin
        NextEnable := true;
        txtDestinationEditable := true;
        NewClassEditable := true;
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

        Rec.SetRange(Class, VarClass);
        Rec.SetRange("School Year", VarSchoolYear);
        Rec.SetRange("Schooling Year", VarSchoolingYear);
        Rec.SetRange("Study Plan Code", VarStudyPlanCode);
        Rec.SetRange("Student Code No.", VarNo);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        Text001: Label 'Are you sure? Transfer the Student?';
        CurrMenuType: Integer;
        FormWidth: Integer;
        VarNo: Code[20];
        VarSchoolYear: Code[9];
        VarClass: Code[20];
        VarSchoolingYear: Code[10];
        VarStudyPlanCode: Code[20];
        VarNewClass: Code[20];
        VarNewStudyPlanCode: Code[20];
        TransferDate: Date;
        TransferSchoolName: Text[128];
        TransferOption: Option Class,School;
        Text002: Label 'Inserting date of transfer is mandatory.';
        Text003: Label 'Inserting a new class is mandatory.';
        Text004: Label 'Inserting a new school is mandatory.';
        rClass: Record Class;
        Text005: Label 'There is no Class Inserted.';
        Text006: Label 'You cannot transfer students from Class %1 to Class %2.';
        Text007: Label 'Wrong Class Selected.';
        Destination: Option " ","Public School","Private School",Foreign;
        varSchoolCode: Code[10];
        rLegalCodes: Record "Legal Codes";
        Text008: Label 'Inserting the destination is mandatory.';
        CancelXPos: Integer;
        CancelYPos: Integer;
        CancelHeight: Integer;
        CancelWidth: Integer;
        FrmXPos: Integer;
        FrmYPos: Integer;
        FrmHeight: Integer;
        FrmWidth: Integer;
        [InDataSet]
        NewClassEditable: Boolean;
        [InDataSet]
        NewSchoolEditable: Boolean;
        [InDataSet]
        txtDestinationEditable: Boolean;
        [InDataSet]
        Step1Visible: Boolean;
        [InDataSet]
        Step2Visible: Boolean;
        [InDataSet]
        Step3Visible: Boolean;
        [InDataSet]
        FinishEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        Text19069539: Label 'Transfer Assistant';
        Text19020813: Label 'Are you sure you want to transfer the Student?';
        Text19080001: Label 'Are you sure you want to transfer the Student?';

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
                    Step2Visible := Visible;
                    FinishEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                end;
            3:
                begin
                    Step3Visible := Visible;
                    FinishEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                end;

        end;
    end;

    //[Scope('OnPrem')]
    procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
    end;

    //[Scope('OnPrem')]
    procedure GetRegistrationClass(pRegistrationClass: Record "Registration Class")
    begin
        VarSchoolYear := pRegistrationClass."School Year";
        VarClass := pRegistrationClass.Class;
        VarSchoolingYear := pRegistrationClass."Schooling Year";
        VarStudyPlanCode := pRegistrationClass."Study Plan Code";
        VarNo := pRegistrationClass."Student Code No.";
    end;

    local procedure LookupOKOnPush()
    begin
        if TransferDate = 0D then
            Error(Text002);
        if Confirm(Text001, true) then begin
            if TransferOption = TransferOption::Class then begin
                if VarNewClass = '' then
                    Error(Text003);
                if VarNewClass = Rec.Class then
                    Error(Text006, Rec."Student Code No.", Rec.Class, VarNewClass);
                Rec.TransferStudent(TransferDate, VarNewClass, '', VarNewStudyPlanCode, 0);
            end else begin
                if TransferSchoolName = '' then
                    Error(Text004);
                if Rec.Destination = 0 then Error(Text008);
                Rec.TransferStudent(TransferDate, '', TransferSchoolName, '', Rec.Destination);
                Rec.InsertStudentSchoolName(varSchoolCode);
            end;
        end;
        CurrPage.Close;
    end;

    local procedure VarNewClassOnFormat()
    begin
        if TransferOption = TransferOption::Class then
            NewClassEditable := true
        else
            NewClassEditable := false
    end;

    local procedure TransferSchoolNameOnFormat()
    begin

        if TransferOption = TransferOption::Class then
            NewSchoolEditable := false
        else
            NewSchoolEditable := true
    end;

    local procedure DestinationOnFormat()
    begin

        if TransferOption = TransferOption::Class then
            txtDestinationEditable := false
        else
            txtDestinationEditable := true
    end;
}

#pragma implicitwith restore

