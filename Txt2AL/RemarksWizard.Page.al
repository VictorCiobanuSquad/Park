#pragma implicitwith disable
page 31009802 "Remarks Wizard"
{
    AutoSplitKey = true;
    Caption = 'Remarks Wizard';
    DataCaptionExpression = Caption;
    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = NavigatePage;
    SourceTable = Remarks;
    SourceTableView = WHERE("Type Remark" = FILTER(Assessment));

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                group("Remarks Wizard")
                {
                    Caption = 'Remarks Wizard';
                    field(cMoment; varMomentCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Moment Code';
                        Editable = cMomentEditable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if varMomentCode = '' then begin
                                vCoursetemp := '';

                                rRegistration.Reset;
                                rRegistration.SetRange("Student Code No.", varStudentCodeNo);
                                rRegistration.SetRange("School Year", VarSchoolYear);
                                rRegistration.SetRange("Schooling Year", VarSchoolingYear);
                                rRegistration.SetRange("Subjects Code", varSubjects);
                                if rRegistration.Find('-') then
                                    vCoursetemp := rRegistration."Study Plan Code";


                                if varSubjects <> '' then begin
                                    rSettingRatings.Reset;
                                    rSettingRatings.SetRange("School Year", VarSchoolYear);
                                    rSettingRatings.SetRange("Schooling Year", VarSchoolingYear);
                                    rSettingRatings.SetRange("Study Plan Code", vCoursetemp);
                                    rSettingRatings.SetRange("Subject Code", varSubjects);
                                    rSettingRatings.SetRange(Type, rSettingRatings.Type::Header);
                                    if rSettingRatings.Find('-') then
                                        if PAGE.RunModal(PAGE::"Setting Ratings Subjects List", rSettingRatings) = ACTION::LookupOK then
                                            varMomentCode := rSettingRatings."Moment Code";
                                end
                                else begin
                                    rMomentsAssessment.Reset;
                                    rMomentsAssessment.SetRange("School Year", VarSchoolYear);
                                    rMomentsAssessment.SetRange("Schooling Year", VarSchoolingYear);
                                    //rMomentsAssessment.SETRANGE(Active,TRUE);
                                    if rMomentsAssessment.Find('-') then
                                        if PAGE.RunModal(0, rMomentsAssessment) = ACTION::LookupOK then
                                            varMomentCode := rMomentsAssessment."Moment Code";
                                end;
                            end;
                            Rec.SetRange("Moment Code", varMomentCode);
                        end;
                    }
                    field(varSubjects; varSubjects)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Subjects';
                        Editable = false;
                    }
                    field(varSubSubjects; varSubSubjects)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'SubSubjects';
                        Editable = false;
                    }
                    field(varClassNumber; varClassNumber)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Class No./Student No.';
                        Editable = false;
                    }
                    field(varStudentCodeNo; varStudentCodeNo)
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
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control8)
                {
                    CaptionClass = Text19069730;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(varMomentCode; varMomentCode)
                {
                    Caption = 'Moment Code';
                    Editable = false;
                }
                field(varS2; varSubjects)
                {
                    Caption = 'Subjects';
                    Editable = false;
                }
                field(varSS2; varSubSubjects)
                {
                    Caption = 'SubSubjects';
                    Editable = false;
                }
                field(varCN2; varClassNumber)
                {
                    Caption = 'Class No./Student No.';
                    Editable = false;
                }
                field(varSCN2; varStudentCodeNo)
                {
                    Editable = false;
                }
                field(Control1110025; rStudents.Name)
                {
                    Editable = false;
                }
                part(SubFormObservation; "Observation Subform")
                {
                    Visible = SubFormObservationVisible;
                }
                repeater(TextLineObservation)
                {
                    Visible = TextLineObservationVisible;
                    field(Textline; Rec.Textline)
                    {
                        Editable = false;
                    }
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
                    if varMomentCode <> '' then begin
                        SetSubMenu(CurrMenuType, false);
                        CurrMenuType := CurrMenuType + 1;
                        SetSubMenu(CurrMenuType, true);
                    end else
                        Error(text001);
                end;
            }
            action(ADD)
            {
                Caption = '''''';
                Enabled = ADDEnable;
                Image = NextSet;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;
                ToolTip = 'Add';

                trigger OnAction()
                begin
                    InsertLines;
                end;
            }
            action(DEL)
            {
                Caption = '''''';
                Enabled = DELEnable;
                Image = PreviousSet;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;
                ToolTip = 'Delete';

                trigger OnAction()
                var
                    l_Observation: Record Observation;
                begin
                    DeleteLines;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if rStudents.Get(Rec."Student/Teacher Code No.") then;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if not varPeditButton then
            exit(false)
        else
            exit(true);
    end;

    trigger OnInit()
    begin
        NextEnable := true;
        DELEnable := true;
        ADDEnable := true;
        SubFormObservationVisible := true;
        TextLineObservationVisible := true;
        cMomentEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Type Education" := VarTypeEducation;
        Rec."Class No." := varClassNumber;
        Rec.Subject := varSubjects;
        Rec.Seperator := Rec.Seperator::"Carriage Return";
        Rec."Moment Code" := varMomentCode;
    end;

    trigger OnOpenPage()
    begin
        Clear(rStudents);
        if varMomentCode <> '' then begin
            cMomentEditable := false;
        end;

        FormWidth := bExitXPos + bExitWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := bExitYPos + bExitHeight + 220;
        FrmWidth := FormWidth;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);



        Rec.SetRange(Class, VarClass);
        Rec.SetRange("School Year", VarSchoolYear);
        Rec.SetRange("Schooling Year", VarSchoolingYear);
        Rec.SetRange("Type Education", VarTypeEducation);
        Rec.SetRange("Study Plan Code", VarStudyPlanCode);
        Rec.SetRange("Student/Teacher Code No.", varStudentCodeNo);
        Rec.SetRange(Subject, varSubjects);
        Rec.SetRange("Sub-subject", varSubSubjects);

        if varMomentCode <> '' then
            Rec.SetRange("Moment Code", varMomentCode);


        if rStudents.Get(varStudentCodeNo) then;

        if rStudents.Sex = rStudents.Sex::Male then
            CurrPage.SubFormObservation.PAGE.SetSex(true)
        else
            CurrPage.SubFormObservation.PAGE.SetSex(false);

        CurrPage.SubFormObservation.PAGE.SetFormFilters(VarObservationCode, VarSchoolYear, 1);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        CurrMenuType: Integer;
        FormWidth: Integer;
        varStudentCodeNo: Code[20];
        VarSchoolYear: Code[9];
        VarClass: Code[20];
        varSubjects: Code[20];
        varSubSubjects: Code[20];
        VarSchoolingYear: Code[10];
        VarStudyPlanCode: Code[20];
        varMomentCode: Code[10];
        rSettingRatings: Record "Setting Ratings";
        //cuRemarks: Codeunit Codeunit31009751
        rStudents: Record Students;
        text001: Label 'Moment code is mandatory.';
        rMomentsAssessment: Record "Moments Assessment";
        varClassNumber: Integer;
        VarTypeEducation: Option Simple,Multi;
        rRegistration: Record "Registration Subjects";
        vCoursetemp: Code[20];
        varPeditButton: Boolean;
        VarObservationCode: Code[20];
        [InDataSet]
        cMomentEditable: Boolean;
        bExitXPos: Integer;
        bExitYPos: Integer;
        bExitHeight: Integer;
        bExitWidth: Integer;
        FrmXPos: Integer;
        FrmYPos: Integer;
        FrmHeight: Integer;
        FrmWidth: Integer;
        [InDataSet]
        Step1Visible: Boolean;
        [InDataSet]
        Step2Visible: Boolean;
        [InDataSet]
        TextLineObservationVisible: Boolean;
        [InDataSet]
        SubFormObservationVisible: Boolean;
        [InDataSet]
        EditEnable: Boolean;
        [InDataSet]
        ADDEnable: Boolean;
        [InDataSet]
        DELEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        Text19069730: Label 'Are you sure you want Insert Comment?';
        fPreviousOBs: Page "Previous Observations";

    local procedure SetSubMenu(MenuType: Integer; Visible: Boolean)
    begin
        case MenuType of
            1:
                begin
                    Step1Visible := Visible;
                    if Visible then begin
                        TextLineObservationVisible := false;
                        SubFormObservationVisible := false;
                        EditEnable := false;
                        ADDEnable := false;
                        DELEnable := false;
                        BackEnable := false;
                        NextEnable := true;
                    end;
                end;
            2:
                begin
                    Step2Visible := Visible;
                    TextLineObservationVisible := true;
                    CurrPage.SubFormObservation.PAGE.Updateform;
                    SubFormObservationVisible := true;
                    EditEnable := varPeditButton;
                    ADDEnable := varPeditButton;
                    DELEnable := varPeditButton;
                    BackEnable := true;
                    NextEnable := false;
                    CurrPage.SubFormObservation.PAGE.SetFormFilters(VarObservationCode, VarSchoolYear, 1);
                    if Visible then;
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
    procedure GetInformation(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pClassNumber: Integer; pTypeEducation: Option Simple,Multi; pEditButton: Boolean)
    var
        l_StudyPlanLines: Record "Study Plan Lines";
        l_CourseLines: Record "Course Lines";
    begin
        varStudentCodeNo := pStudentCodeNo;
        VarSchoolYear := pSchoolYear;
        VarClass := pClass;
        VarSchoolingYear := pSchoolingYear;
        VarStudyPlanCode := pStudyPlanCode;
        varSubjects := pSubjects;
        varClassNumber := pClassNumber;
        VarTypeEducation := pTypeEducation;
        varPeditButton := pEditButton;
        varSubSubjects := pSubSubjects;

        if (varSubjects <> '') and (varSubSubjects = '') then begin
            if VarTypeEducation = VarTypeEducation::Simple then begin
                l_StudyPlanLines.Reset;
                l_StudyPlanLines.SetRange(Code, VarStudyPlanCode);
                l_StudyPlanLines.SetRange("School Year", VarSchoolYear);
                l_StudyPlanLines.SetRange("Schooling Year", VarSchoolingYear);
                l_StudyPlanLines.SetRange("Subject Code", varSubjects);
                if l_StudyPlanLines.FindFirst then
                    VarObservationCode := l_StudyPlanLines.Observations;
            end;
            if VarTypeEducation = VarTypeEducation::Multi then begin
                l_CourseLines.Reset;
                l_CourseLines.SetRange(Code, pStudyPlanCode);
                l_CourseLines.SetRange("Subject Code", varSubjects);
                if l_CourseLines.FindFirst then
                    VarObservationCode := l_CourseLines.Observations;


            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetMomentInformation(pMomentCode: Code[10])
    begin
        varMomentCode := pMomentCode;
    end;

    //[Scope('OnPrem')]
    procedure GetObservationCode(pObservationCode: Code[20])
    begin
        VarObservationCode := pObservationCode;
    end;

    //[Scope('OnPrem')]
    procedure InsertLines()
    var
        l_Observation: Record Observation;
        l_Remarks: Record Remarks;
        Lineno: Integer;
    begin
        CurrPage.SubFormObservation.PAGE.GetFormRecord(l_Observation);
        l_Remarks.Reset;
        l_Remarks.SetRange(Class, VarClass);
        l_Remarks.SetRange("School Year", VarSchoolYear);
        l_Remarks.SetRange("Schooling Year", VarSchoolingYear);
        l_Remarks.SetRange("Study Plan Code", VarStudyPlanCode);
        l_Remarks.SetRange("Student/Teacher Code No.", varStudentCodeNo);
        l_Remarks.SetRange("Moment Code", varMomentCode);
        l_Remarks.SetRange(Subject, varSubjects);
        l_Remarks.SetRange("Sub-subject", varSubSubjects);
        if l_Remarks.Find('+') then
            Lineno := l_Remarks."Line No."
        else
            Lineno := 0;

        if l_Observation.Find('-') then
            repeat
                l_Remarks.Reset;
                l_Remarks.SetRange(Class, VarClass);
                l_Remarks.SetRange("School Year", VarSchoolYear);
                l_Remarks.SetRange("Schooling Year", VarSchoolingYear);
                l_Remarks.SetRange("Study Plan Code", VarStudyPlanCode);
                l_Remarks.SetRange("Student/Teacher Code No.", varStudentCodeNo);
                l_Remarks.SetRange("Moment Code", varMomentCode);
                l_Remarks.SetRange(Subject, varSubjects);
                l_Remarks.SetRange("Sub-subject", varSubSubjects);
                l_Remarks.SetRange("Original Line No.", l_Observation."Line No.");
                if not l_Remarks.Find('-') then begin
                    Lineno += 10000;
                    Clear(l_Remarks);
                    l_Remarks.Init;
                    //l_Remarks."Entry No." := GetLastNo;
                    l_Remarks.Class := VarClass;
                    l_Remarks."School Year" := VarSchoolYear;
                    l_Remarks."Schooling Year" := VarSchoolingYear;
                    l_Remarks."Study Plan Code" := VarStudyPlanCode;
                    l_Remarks."Student/Teacher Code No." := varStudentCodeNo;
                    l_Remarks."Moment Code" := varMomentCode;
                    l_Remarks.Subject := varSubjects;
                    l_Remarks."Sub-subject" := varSubSubjects;
                    l_Remarks."Line No." := Lineno;
                    l_Remarks."Class No." := varClassNumber;
                    if rStudents.Sex = rStudents.Sex::Male then
                        l_Remarks.Textline := l_Observation."Description Male"
                    else
                        l_Remarks.Textline := l_Observation."Description Female";
                    l_Remarks.Seperator := l_Remarks.Seperator::"Carriage Return";
                    l_Remarks."Responsibility Center" := rStudents."Responsibility Center";
                    l_Remarks."Type Education" := VarTypeEducation;
                    l_Remarks."Original Line No." := l_Observation."Line No.";
                    l_Remarks."Mother Language" :=
                                        l_Remarks.GetMotherLanguage(VarObservationCode, VarSchoolYear, rStudents.Sex, l_Observation."Line No.",
                                        rStudents.Language);
                    l_Remarks."Creation User" := UserId;
                    l_Remarks."Creation Date" := Today;
                    l_Remarks.Insert;
                    l_Remarks.Modify(true);
                end;


            until l_Observation.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure DeleteLines()
    var
        lRemarks: Record Remarks;
    begin
        CurrPage.SetSelectionFilter(lRemarks);

        if lRemarks.Find('-') then
            lRemarks.DeleteAll(true);

        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure GetLastNo(): Integer
    var
        l_Remarks: Record Remarks;
    begin
        l_Remarks.Reset;
        if l_Remarks.Find('+') then
            exit(l_Remarks."Entry No." + 1)
        else
            exit(1);
    end;

    local procedure LookupOKOnPush()
    begin
        //2011.11.24
        fPreviousOBs.MostraObs(varStudentCodeNo, VarSchoolYear, VarClass, varSubjects,
                                  varSubSubjects, VarSchoolingYear, VarStudyPlanCode, varMomentCode, varClassNumber);
        fPreviousOBs.Run;
        //2011.11.24


        //cuRemarks.EditContactText(varStudentCodeNo, VarSchoolYear, VarClass, varSubjects,
        //varSubSubjects, VarSchoolingYear, VarStudyPlanCode, varMomentCode, varClassNumber);
    end;
}

#pragma implicitwith restore

