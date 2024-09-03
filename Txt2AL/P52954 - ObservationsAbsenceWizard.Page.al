#pragma implicitwith disable
page 52954 "Observations Absence Wizard"
{
    AutoSplitKey = true;
    Caption = 'Observations Absence Wizard';
    DataCaptionExpression = Caption;
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = NavigatePage;
    Permissions = TableData Absence = rimd;
    SourceTable = Remarks;
    SourceTableView = ORDER(Ascending)
                      WHERE("Type Remark" = FILTER(Absence));

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                label(Control2)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text19033208;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(varDay1; varDay)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Day';
                    Editable = false;
                }
                field(varSubj1; varSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects';
                    Editable = false;
                }
                field(varSubSub1; varSubSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SubSubjects';
                    Editable = false;
                }
                field(varClassN1; varClassNumber)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class No./Student No.';
                    Editable = false;
                }
                field(varName1; varName)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varSCN1; varStudentCodeNo)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Step2)
            {
                Visible = Step2Visible;
                label(Control8)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text19000042;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(varDay2; varDay)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Day';
                    Editable = false;
                }
                field(varSubj2; varSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subjects';
                    Editable = false;
                }
                field(varSubSub2; varSubSubjects)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SubSubjects';
                    Editable = false;
                }
                field(varClassN2; varClassNumber)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class No./Student No.';
                    Editable = false;
                }
                field(varSCN2; varStudentCodeNo)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varName2; varName)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                part(SubFormObservation; "Observation Subform")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = SubFormObservationVisible;
                }
                repeater(TextLineObservation)
                {
                    Visible = TextLineObservationVisible;
                    field(Textline; Rec.Textline)
                    {
                        ApplicationArea = Basic, Suite;
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
            action(Edit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'E&dit';
                Enabled = EditEnable;
                Image = Edit;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;

                trigger OnAction()
                begin
                    //cuRemarks.EditContactTextAbsence(varStudentCodeNo, VarSchoolYear, VarClass, varSubjects,
                    //varSubSubjects, VarSchoolingYear, VarStudyPlanCode, varDay, varCalendarLine, VarStatusJustified,
                    //"varStudent/Teacher", "Timetable Code", varPeditButton, VarIncidenceType, varLineno);
                end;
            }
            action(ADD)
            {
                ApplicationArea = Basic, Suite;
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
                ApplicationArea = Basic, Suite;
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
        GetObservationCode;
        CurrPage.SubFormObservation.PAGE.SetFormFilters(VarObservationCode, VarSchoolYear, 2);
        CurrPage.SubFormObservation.PAGE.Updateform;
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
        EditEnable := true;
        DELEnable := true;
        ADDEnable := true;
        SubFormObservationVisible := true;
        TextLineObservationVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Type Education" := VarTypeEducation;
        Rec."Class No." := varClassNumber;
        Rec.Subject := varSubjects;
        Rec."Type Remark" := Rec."Type Remark"::Absence;
        Rec.Day := varDay;
        Rec.Seperator := Rec.Seperator::"Carriage Return";
    end;

    trigger OnOpenPage()
    begin
        Clear(rStudents);

        FormWidth := bExitXPos + bExitWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := bExitYPos + bExitHeight + 220;
        FrmWidth := FormWidth;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);



        Rec.SetRange(Class, VarClass);
        Rec.SetRange("School Year", VarSchoolYear);
        if Rec."Student/Teacher" = Rec."Student/Teacher"::Student then
            Rec.SetRange("Schooling Year", VarSchoolingYear);
        Rec.SetRange("Type Education", VarTypeEducation);
        Rec.SetFilter("Study Plan Code", VarStudyPlanCode);
        Rec.SetRange("Student/Teacher Code No.", varStudentCodeNo);
        Rec.SetRange(Subject, varSubjects);
        Rec.SetRange("Sub-subject", varSubSubjects);
        Rec.SetRange("Calendar Line", varCalendarLine);
        Rec.SetRange("Student/Teacher", "varStudent/Teacher");
        Rec.SetRange("Incidence Type", VarIncidenceType);
        Rec.SetRange("Line No.", varLineno);

        rStudents.Reset;

        if "varStudent/Teacher" = "varStudent/Teacher"::Student then begin
            if rStudents.Get(varStudentCodeNo) then
                varName := rStudents.Name;
            if rStudents.Sex = rStudents.Sex::Male then
                CurrPage.SubFormObservation.PAGE.SetSex(true)
            else
                CurrPage.SubFormObservation.PAGE.SetSex(false);

        end;

        if "varStudent/Teacher" = "varStudent/Teacher"::Teacher then begin
            if rTeacher.Get(varStudentCodeNo) then
                varName := rTeacher.Name;
            if rTeacher.Sex = rTeacher.Sex::Male then
                CurrPage.SubFormObservation.PAGE.SetSex(true)
            else
                CurrPage.SubFormObservation.PAGE.SetSex(false);
        end;

        GetObservationCode;



        CurrPage.SubFormObservation.PAGE.SetFormFilters(VarObservationCode, VarSchoolYear, 2);

        CurrPage.SubFormObservation.PAGE.Updateform;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [ACTION::Cancel, ACTION::LookupCancel] then
            CancelOnPush;
        if varPeditButton then
            UpdateAbsence;
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
        rSettingRatings: Record "Setting Ratings";
        //cuRemarks: Codeunit Codeunit52751;
        rStudents: Record Students;
        text001: Label 'Moment Code is mandatory.';
        rMomentsAssessment: Record "Moments Assessment";
        varClassNumber: Integer;
        VarTypeEducation: Option Simple,Multi;
        rRegistration: Record "Registration Subjects";
        vCoursetemp: Code[20];
        varPeditButton: Boolean;
        VarObservationCode: Code[20];
        varDay: Date;
        varSubType: Code[40];
        varAbsenceCode: Code[20];
        varCalendarLine: Integer;
        VarIncidenceType: Option Default,Absence;
        VarStatusJustified: Option Justified,Unjustified,Justification;
        "varStudent/Teacher": Option Student,Teacher;
        rTeacher: Record Teacher;
        varName: Text[128];
        varTimeTableCode: Code[20];
        varJustifiedCode: Code[20];
        varLineno: Integer;
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
        ADDEnable: Boolean;
        [InDataSet]
        DELEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        EditEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        Text19033208: Label 'Remarks Assitant';
        Text19000042: Label 'Are you sure you want to Insert a Comment?';

    local procedure SetSubMenu(MenuType: Integer; Visible: Boolean)
    begin
        case MenuType of
            1:
                begin
                    Step1Visible := Visible;
                    if Visible then begin
                        TextLineObservationVisible := false;
                        SubFormObservationVisible := false;
                        ADDEnable := false;
                        DELEnable := false;
                        BackEnable := false;
                        EditEnable := false;
                        NextEnable := true;
                    end;
                end;
            2:
                begin
                    Step2Visible := Visible;
                    TextLineObservationVisible := true;
                    SubFormObservationVisible := true;
                    ADDEnable := varPeditButton;
                    DELEnable := varPeditButton;
                    EditEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                    if Visible then;
                end;

        end;
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
    end;

    //[Scope('OnPrem')]
    procedure GetInformation(pAbsence: Record Absence; pSchoolingYear: Code[10]; pEditButton: Boolean)
    begin
        varStudentCodeNo := pAbsence."Student/Teacher Code No.";
        VarSchoolYear := pAbsence."School Year";
        VarClass := pAbsence.Class;
        VarSchoolingYear := pSchoolingYear;
        VarStudyPlanCode := pAbsence."Study Plan";
        varSubjects := pAbsence.Subject;
        varClassNumber := pAbsence."Class No.";
        VarTypeEducation := pAbsence.Type;
        varPeditButton := pEditButton;
        varSubSubjects := pAbsence."Sub-Subject Code";
        varDay := pAbsence.Day;
        varSubType := pAbsence."Subcategory Code";
        varAbsenceCode := pAbsence."Incidence Code";
        varCalendarLine := pAbsence."Line No. Timetable";
        VarIncidenceType := pAbsence."Incidence Type";
        "varStudent/Teacher" := pAbsence."Student/Teacher";
        varTimeTableCode := pAbsence."Timetable Code";

        varJustifiedCode := pAbsence."Justified Code";
        VarIncidenceType := pAbsence."Incidence Type";
        varLineno := pAbsence."Line No.";
    end;

    //[Scope('OnPrem')]
    procedure GetObservationCode()
    var
        rIncidenceTpe: Record "Incidence Type";
    begin
        rIncidenceTpe.Reset;
        rIncidenceTpe.SetRange("School Year", VarSchoolYear);
        if "varStudent/Teacher" = "varStudent/Teacher"::Student then
            rIncidenceTpe.SetRange("Schooling Year", VarSchoolingYear);
        rIncidenceTpe.SetRange("Incidence Type", VarIncidenceType);
        rIncidenceTpe.SetRange("Subcategory Code", varSubType);
        if (VarStatusJustified = VarStatusJustified::Justified) or (VarStatusJustified = VarStatusJustified::Unjustified) then
            rIncidenceTpe.SetRange("Incidence Code", varAbsenceCode);

        if VarStatusJustified = VarStatusJustified::Justification then begin
            rIncidenceTpe.SetRange("Incidence Code", varAbsenceCode);
            rIncidenceTpe.SetRange("Justification Code", varJustifiedCode);
        end;

        if rIncidenceTpe.Find('-') then
            VarObservationCode := rIncidenceTpe.Observations;
    end;

    //[Scope('OnPrem')]
    procedure InsertLines()
    var
        l_Observation: Record Observation;
        l_Remarks: Record Remarks;
        l_Students: Record Students;
        l_Teacher: Record Teacher;
    begin
        CurrPage.SubFormObservation.PAGE.GetFormRecord(l_Observation);


        if l_Observation.Find('-') then
            repeat
                l_Remarks.Reset;
                l_Remarks.SetRange(Class, VarClass);
                l_Remarks.SetRange("School Year", VarSchoolYear);
                l_Remarks.SetRange("Schooling Year", VarSchoolingYear);
                l_Remarks.SetRange("Study Plan Code", VarStudyPlanCode);
                l_Remarks.SetRange("Student/Teacher Code No.", varStudentCodeNo);
                l_Remarks.SetRange(Subject, varSubjects);
                l_Remarks.SetRange("Original Line No.", l_Observation."Line No.");
                l_Remarks.SetRange("Type Remark", l_Remarks."Type Remark"::Absence);
                l_Remarks.SetRange(Day, varDay);
                l_Remarks.SetRange("Calendar Line", varCalendarLine);
                l_Remarks.SetRange("Student/Teacher", "varStudent/Teacher");
                l_Remarks.SetRange("Absence Status", VarStatusJustified);
                l_Remarks.SetRange("Incidence Type", VarIncidenceType);
                l_Remarks.SetRange("Line No.", varLineno);
                if not l_Remarks.Find('-') then begin
                    Clear(l_Remarks);
                    l_Remarks.Init;
                    //l_Remarks."Entry No." := GetLastNo;
                    l_Remarks.Class := VarClass;
                    l_Remarks."School Year" := VarSchoolYear;
                    l_Remarks."Schooling Year" := VarSchoolingYear;
                    l_Remarks."Study Plan Code" := VarStudyPlanCode;
                    l_Remarks."Student/Teacher Code No." := varStudentCodeNo;
                    l_Remarks.Subject := varSubjects;
                    l_Remarks."Sub-subject" := varSubSubjects;
                    l_Remarks."Line No." := varLineno;
                    l_Remarks."Type Remark" := l_Remarks."Type Remark"::Absence;
                    l_Remarks.Day := varDay;

                    //l_Remarks."Class No." := 0
                    //
                    if (rStudents.Sex = rStudents.Sex::Male) or (rTeacher.Sex = rTeacher.Sex::Male) then
                        l_Remarks.Textline := l_Observation."Description Male"
                    else
                        l_Remarks.Textline := l_Observation."Description Female";
                    l_Remarks.Seperator := l_Remarks.Seperator::"Carriage Return";
                    l_Remarks."Responsibility Center" := rStudents."Responsibility Center";
                    l_Remarks."Type Education" := VarTypeEducation;
                    l_Remarks."Original Line No." := l_Observation."Line No.";
                    l_Remarks."Calendar Line" := varCalendarLine;
                    l_Remarks."Student/Teacher" := "varStudent/Teacher";
                    l_Remarks."Absence Status" := VarStatusJustified;
                    l_Remarks."Timetable Code" := varTimeTableCode;
                    l_Remarks."Incidence Type" := VarIncidenceType;
                    if "varStudent/Teacher" = "varStudent/Teacher"::Student then begin
                        if l_Students.Get(varStudentCodeNo) then begin
                            l_Remarks."Responsibility Center" := l_Students."Responsibility Center";
                            l_Remarks."Mother Language" :=
                                            l_Remarks.GetMotherLanguage(VarObservationCode, VarSchoolYear, l_Students.Sex, l_Observation."Line No.",
                                            l_Students.Language);
                        end;

                    end;
                    if "varStudent/Teacher" = "varStudent/Teacher"::Teacher then begin
                        if l_Teacher.Get(varStudentCodeNo) then begin
                            l_Remarks."Responsibility Center" := l_Teacher."Responsibility Center";
                            l_Remarks."Mother Language" :=
                                            l_Remarks.GetMotherLanguage(VarObservationCode, VarSchoolYear, l_Teacher.Sex, l_Observation."Line No.",
                                            l_Teacher.Language);
                        end;


                    end;



                    l_Remarks.Insert;
                    l_Remarks.Modify(true);
                end


            until l_Observation.Next = 0;
    end;

    //[Scope('OnPrem')]
    procedure DeleteLines()
    var
        lRemarks: Record Remarks;
    begin
        CurrPage.SetSelectionFilter(lRemarks);

        lRemarks.SetFilter("Original Line No.", '<>%1', 0);
        lRemarks.SetRange("Absence Status", VarStatusJustified);
        lRemarks.DeleteAll(true);

        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure UpdateAbsence()
    var
        rAbsence: Record Absence;
        l_Remarks: Record Remarks;
    begin
        l_Remarks.Reset;
        l_Remarks.SetRange(Class, VarClass);
        l_Remarks.SetRange("School Year", VarSchoolYear);
        l_Remarks.SetRange("Schooling Year", VarSchoolingYear);
        l_Remarks.SetRange("Study Plan Code", VarStudyPlanCode);
        l_Remarks.SetRange("Student/Teacher Code No.", varStudentCodeNo);
        l_Remarks.SetRange(Subject, varSubjects);
        l_Remarks.SetRange("Type Remark", l_Remarks."Type Remark"::Absence);
        l_Remarks.SetRange(Day, varDay);
        l_Remarks.SetRange("Calendar Line", varCalendarLine);
        l_Remarks.SetRange("Student/Teacher", "varStudent/Teacher");
        l_Remarks.SetRange("Incidence Type", VarIncidenceType);
        l_Remarks.SetRange("Line No.", varLineno);
        if l_Remarks.FindFirst then;




        rAbsence.Reset;
        rAbsence.SetRange("School Year", VarSchoolYear);
        rAbsence.SetRange("Study Plan", VarStudyPlanCode);
        rAbsence.SetRange("Student/Teacher Code No.", varStudentCodeNo);
        rAbsence.SetRange(Class, VarClass);
        rAbsence.SetRange(Subject, varSubjects);
        rAbsence.SetRange("Sub-Subject Code", varSubSubjects);
        rAbsence.SetRange(Day, varDay);
        rAbsence.SetRange(Type, Rec."Type Education");
        rAbsence.SetRange("Line No. Timetable", varCalendarLine);
        rAbsence.SetRange("Student/Teacher", "varStudent/Teacher");
        rAbsence.SetRange("Incidence Type", VarIncidenceType);
        rAbsence.SetRange("Line No.", varLineno);
        if rAbsence.Find('-') then begin
            rAbsence.Observations := l_Remarks.Textline;
            rAbsence.Modify(true);
        end;
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

    //[Scope('OnPrem')]
    procedure GetStatusJustified(pStatusJustified: Option " ",Unjustified,Justified)
    begin
        varPeditButton := true;
        VarStatusJustified := pStatusJustified;
        if VarStatusJustified = VarStatusJustified::Justified then
            varPeditButton := false;
    end;

    //[Scope('OnPrem')]
    procedure SetEditable(pEditButton: Boolean)
    begin
        varPeditButton := pEditButton;
    end;

    local procedure CancelOnPush()
    begin
        UpdateAbsence;
    end;
}

#pragma implicitwith restore

