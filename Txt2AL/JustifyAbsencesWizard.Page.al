page 31009967 "Justify Absences Wizard"
{
    Caption = 'Justify Absences Wizard';
    PageType = NavigatePage;
    Permissions = TableData Absence = rimd;

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
                    CaptionClass = Text19026943;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(vSchoolYear; vSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    Editable = false;
                }
                field(txtClass; rClass.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    Editable = false;
                    Visible = txtClassVisible;
                }
                field(vType; vType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    Editable = false;
                    OptionCaption = 'Student,Teacher,Class';
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
                field(vDateInic; vDateInic)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inicial Absence Date';

                    trigger OnValidate()
                    begin
                        if vDateInic <> 0D then
                            vDateEnd := vDateInic
                        else
                            vDateEnd := 0D;
                    end;
                }
                field(bTeacher; vTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Teacher';
                    TableRelation = Teacher;
                    Visible = bTeacherVisible;

                    trigger OnValidate()
                    begin
                        vTeacherOnAfterValidate;
                    end;
                }
                field(bStudent; vStudent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student';
                    Visible = bStudentVisible;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        rStudent.Reset;
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetRange("School Year", vSchoolYear);
                        rRegistrationClass.SetRange("Schooling Year", rClass."Schooling Year");
                        rRegistrationClass.SetRange("Study Plan Code", rClass."Study Plan Code");
                        rRegistrationClass.SetRange(Class, rClass.Class);
                        if rRegistrationClass.Find('-') then begin
                            repeat
                                rRegistrationClassEntry.Reset;
                                rRegistrationClassEntry.SetCurrentKey("School Year", "Schooling Year", Class, "Class No.", "Status Date");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Class, rClass.Class);
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."School Year", vSchoolYear);
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Schooling Year", rClass."Schooling Year");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Responsibility Center", rClass."Responsibility Center");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Student Code No.", rRegistrationClass."Student Code No.");
                                rRegistrationClassEntry.SetFilter(rRegistrationClassEntry."Status Date", '<=%1', vDateEnd);
                                if (rRegistrationClassEntry.Find('+')) and
                                   (rRegistrationClassEntry.Status = rRegistrationClassEntry.Status::Subscribed) then begin
                                    repeat
                                        rStudent.SetRange(rStudent."No.", rRegistrationClassEntry."Student Code No.");
                                        if rStudent.Find('-') then
                                            rStudent.Mark(true);
                                    until rRegistrationClassEntry.Next = 0;
                                end;

                            until rRegistrationClass.Next = 0;
                        end;

                        rStudent.MarkedOnly(true);
                        rStudent.SetRange(rStudent."No.");
                        if rStudent.Find('-') then
                            if PAGE.RunModal(PAGE::"Students List", rStudent) = ACTION::LookupOK then begin
                                vStudent := rStudent."No.";
                                vStudentName := rStudent.Name;
                            end;
                    end;

                    trigger OnValidate()
                    begin
                        vStudentOnAfterValidate;
                    end;
                }
                field(lName; vStudentName)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = lNameVisible;
                }
                field(vIncidentType; vIncidentType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incidence Type';
                    OptionCaption = 'Default,Absence';

                    trigger OnValidate()
                    begin
                        vIncidentTypeOnAfterValidate;
                    end;
                }
                field(vIncidentCode; vIncidentCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incidence Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        vJustification := '';
                        rIncidenceType.Reset;
                        rIncidenceType.SetRange("School Year", vSchoolYear);
                        if vType <> vType::Teacher then rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
                        rIncidenceType.SetRange("Incidence Type", vIncidentType);
                        rIncidenceType.SetRange("Subcategory Code", vSubType);
                        rIncidenceType.SetFilter("Absence Status", '%1|%2', rIncidenceType."Absence Status"::Unjustified,
                                                 rIncidenceType."Absence Status"::Justified);
                        if rIncidenceType.FindFirst then
                            if PAGE.RunModal(PAGE::"Incidence List", rIncidenceType) = ACTION::LookupOK then begin
                                vIncidentCode := rIncidenceType."Incidence Code";
                                vIncidentStatus := rIncidenceType."Absence Status";
                            end;
                    end;

                    trigger OnValidate()
                    begin
                        vIncidentCodeOnAfterValidate;
                    end;
                }
                field(Justification; vJustification)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Justified Code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_IncidenceType: Record "Incidence Type";
                    begin


                        l_IncidenceType.Reset;
                        l_IncidenceType.SetRange("School Year", vSchoolYear);
                        if (vType = vType::Student) or (vType = vType::Class) then begin
                            l_IncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
                            l_IncidenceType.SetRange(Category, l_IncidenceType.Category::Class);
                        end;
                        l_IncidenceType.SetRange("Absence Status", l_IncidenceType."Absence Status"::Justification);
                        l_IncidenceType.SetRange(l_IncidenceType."Subcategory Code", vSubType);
                        l_IncidenceType.SetRange("Incidence Code", vIncidentCode);
                        if l_IncidenceType.Find('-') then begin
                            if PAGE.RunModal(PAGE::"Incidence List", l_IncidenceType) = ACTION::LookupOK then
                                vJustification := l_IncidenceType."Justification Code";
                        end;
                    end;
                }
                field(vDateEnd; vDateEnd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ending Absence Date';
                }
                field(vSubType; vSubType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'SubType';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        vIncidentCode := '';
                        vJustification := '';
                        rSubType.Reset;
                        rSubType.SetRange(Category, vIncidentCat);
                        if rSubType.Find('-') then
                            if PAGE.RunModal(0, rSubType) = ACTION::LookupOK then begin
                                vSubType := rSubType."Subcategory Code";
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
                var
                    rTimetable: Record Timetable;
                begin



                    SetSubMenu(CurrMenuType, false);
                    CurrMenuType := CurrMenuType + 1;
                    SetSubMenu(CurrMenuType, true);
                end;
            }
            action(Finish)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'F&inish';
                Image = Approve;
                InFooterBar = true;
                //Promoted = true;
                //PromotedCategory = Process;

                trigger OnAction()
                begin

                    if (vStudent = '') and (vType = vType::Student) then
                        Error(Text0001);

                    if (vIncidentCode = '') then
                        Error(Text0002);

                    if (vDateInic = 0D) and (vDateEnd = 0D) then
                        Error(Text0003);

                    if (vDateInic = 0D) and (vDateEnd <> 0D) then
                        Error(Text0004);

                    if (vDateInic <> 0D) and (vDateEnd = 0D) then
                        Error(Text0005);

                    if rTimetable.Get(vTimetableCode) then
                        if not ((vDateInic >= rTimetable."Start Period") and (vDateInic <= rTimetable."End Period")) then
                            Error(Text0009);

                    if (vDateInic = vDateEnd) then begin
                        rData.Reset;
                        rData.SetRange("Period Type", rData."Period Type"::Date);
                        rData.SetRange("Period Start", vDateInic);
                        if rData.Find('-') then;

                        rBaseCalChangeEDU.Reset;
                        rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Annual Recurring");
                        rBaseCalChangeEDU.SetRange(Date, rData."Period Start");
                        rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
                        rBaseCalChangeEDU.SetRange(Nonworking, true);
                        if rBaseCalChangeEDU.FindFirst then
                            Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

                        rBaseCalChangeEDU.Reset;
                        rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
                        rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
                        rBaseCalChangeEDU.SetRange(Nonworking, true);
                        if rBaseCalChangeEDU.FindFirst then
                            if rDate."Period No." = rBaseCalChangeEDU.Day then
                                Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

                    end;

                    if (vDateInic < rTimetable."Start Period") and (vDateInic > rTimetable."End Period") then
                        Error(Text0007, vDateInic, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);
                    if (vDateEnd < rTimetable."Start Period") and (vDateEnd > rTimetable."End Period") then
                        Error(Text0008, vDateEnd, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);

                    if (vType = vType::Teacher) and (vTeacher = '') then
                        Error(Text0015);

                    if (vJustification = '') then
                        Error(Text0016);

                    rDate.Reset;
                    rDate.SetRange("Period Type", rDate."Period Type"::Date);
                    rDate.SetRange("Period Start", vDateInic, vDateEnd);
                    if rDate.Find('-') then
                        repeat
                            rBaseCalChangeEDU.Reset;
                            rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
                            rBaseCalChangeEDU.SetRange(Date, rDate."Period Start");
                            rBaseCalChangeEDU.SetRange(Nonworking, true);
                            if not rBaseCalChangeEDU.Find('-') then

                                //***********ALUNO********************
                                if vType = vType::Student then
                                    JustifyAbsence;

                            //**********TURMA********************
                            if vType = vType::Class then
                                JustifyAbsence;

                            //**********PROFESSOR*******************
                            if vType = vType::Teacher then begin
                                JustifyAbsence;

                            end;

                        until rDate.Next = 0;

                    FinishEnable := true;
                    BackEnable := false;
                    NextEnable := false;


                    CurrPage.Close;
                    Message(Text0010);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        lNameVisible := true;
        NextEnable := true;
        txtClassVisible := true;
        bStudentVisible := true;
        bTeacherVisible := true;
    end;

    trigger OnOpenPage()
    begin

        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := CancelYPos + CancelHeight + 220;
        FrmWidth := FormWidth;

        bTeacherVisible := false;
        bStudentVisible := false;

        if vType = vType::Teacher then
            txtClassVisible := false;


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
        rAbsence: Record Absence;
        rAbsenceJustify: Record Absence;
        rStudent: Record Students;
        rRegistrationClass: Record "Registration Class";
        rRegistrationClassEntry: Record "Registration Class Entry";
        rIncidenceType: Record "Incidence Type";
        rData: Record Date;
        rBaseCalChangeEDU: Record "Base Calendar ChangeEDU";
        rSubType: Record "Sub Type";
        rDate: Record Date;
        rTimetable: Record Timetable;
        rTeacher: Record Teacher;
        rClass: Record Class;
        vSubject: Code[10];
        vType: Option Student,Teacher,Class;
        vSubType: Code[20];
        vIncidentType: Option Default,Absence;
        vIncidentCat: Option Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;
        vIncidentCode: Code[20];
        Text0001: Label 'Student field must not be blank.';
        Text0002: Label 'Incidence Type and Incidence Code fields must not be blank.';
        vIncidentStatus: Option Justified,Unjustified,Justification;
        vStudent: Code[20];
        vStudentName: Text[128];
        vTeacher: Code[20];
        vName: Text[30];
        vTimetableCode: Code[20];
        vDateInic: Date;
        vDateEnd: Date;
        Text0003: Label 'Inicial Absence Date and Ending Absence Date must not be blank.';
        Text0004: Label 'Inicial Absence Date is blank.\ To select a specific day please fill the Inicial Absence Date and Ending Absence Date with the same date.';
        Text0005: Label 'Ending Absence Date is Blank.\ To select a specific day please fill the Inicial Absence Date and Ending Absence Date with the same date.';
        Text0006: Label 'Date %1 having the following description %2 cannot be chosen since it isn''t a working day.';
        Text0007: Label 'Inicial Absence Date %1 isn''t within range of Timetable %4, which starts on %2 and finishes on the %3. ';
        Text0008: Label 'Ending Absence Date %1 isn''t within range of Timetable %4, which starts on %2 and finishes on the %3. ';
        Text0009: Label 'The selected date is out of the range permit.';
        Text0010: Label 'Terminated process';
        vJustification: Code[20];
        Text0015: Label 'Teacher field must not be blank.';
        Text0016: Label 'Justified Code field must not be blank.';
        vSchoolYear: Code[9];
        [InDataSet]
        bTeacherVisible: Boolean;
        [InDataSet]
        bStudentVisible: Boolean;
        [InDataSet]
        txtClassVisible: Boolean;
        CancelXPos: Integer;
        CancelYPos: Integer;
        CancelHeight: Integer;
        CancelWidth: Integer;
        FrmXPos: Integer;
        FrmYPos: Integer;
        FrmHeight: Integer;
        FrmWidth: Integer;
        [InDataSet]
        FinishEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        [InDataSet]
        Step1Visible: Boolean;
        [InDataSet]
        Step2Visible: Boolean;
        [InDataSet]
        lNameVisible: Boolean;
        Text19026943: Label 'Justify Absences Wizard';
        Text19080001: Label 'Justify Absences Wizard';

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

                        case vType of
                            vType::Student:
                                begin
                                    bTeacherVisible := false;
                                    bStudentVisible := true;
                                end;
                            vType::Teacher:
                                begin
                                    bTeacherVisible := true;
                                    bStudentVisible := false;
                                end;
                            vType::Class:
                                begin
                                    bTeacherVisible := false;
                                    bStudentVisible := false;
                                    lNameVisible := false;
                                end;

                            else begin
                                bTeacherVisible := false;
                                bTeacherVisible := false;
                                lNameVisible := false;
                            end;
                        end;
                    end;
                end;
            2:
                begin
                    Step2Visible := Visible;
                    FinishEnable := true;
                    BackEnable := true;
                    NextEnable := false;
                    if Visible then;
                end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure SetFormFilter(pTimetableCode: Code[20]; pStudentTeacher: Integer; pInicialDate: Date; pEndDate: Date; pSchoolYear: Code[9]; pClass: Code[20])
    begin
        vTimetableCode := pTimetableCode;
        vType := pStudentTeacher;
        vDateInic := pInicialDate;
        vDateEnd := pEndDate;
        if pStudentTeacher = 1 then
            vIncidentCat := vIncidentCat::Teacher
        else begin
            vIncidentCat := vIncidentCat::Class;
            rClass.Reset;
            if rClass.Get(pClass, pSchoolYear) then;
        end;
        vSchoolYear := pSchoolYear;
    end;

    //[Scope('OnPrem')]
    procedure JustifyAbsence()
    begin
        rAbsenceJustify.Reset;
        rAbsenceJustify.SetRange(rAbsenceJustify."School Year", vSchoolYear);
        if (vType = vType::Student) or (vType = vType::Class) then begin
            rAbsenceJustify.SetRange(rAbsenceJustify.Class, rClass.Class);
            rAbsenceJustify.SetRange(rAbsenceJustify."Student/Teacher", rAbsenceJustify."Student/Teacher"::Student);
        end;
        if vType = vType::Student then
            rAbsenceJustify.SetRange(rAbsenceJustify."Student/Teacher Code No.", vStudent);

        if vType = vType::Teacher then begin
            rAbsenceJustify.SetRange(rAbsenceJustify."Student/Teacher", rAbsenceJustify."Student/Teacher"::Teacher);
            rAbsenceJustify.SetRange(rAbsenceJustify."Student/Teacher Code No.", vTeacher);
        end;
        rAbsenceJustify.SetRange(rAbsenceJustify.Day, vDateInic, vDateEnd);
        rAbsenceJustify.SetRange(rAbsenceJustify."Incidence Type", vIncidentType);
        rAbsenceJustify.SetRange(rAbsenceJustify."Incidence Code", vIncidentCode);
        rAbsenceJustify.SetRange(rAbsenceJustify.Category, vIncidentCat);
        rAbsenceJustify.SetRange(rAbsenceJustify."Subcategory Code", vSubType);
        rAbsenceJustify.SetRange(rAbsenceJustify."Absence Status", rAbsenceJustify."Absence Status"::Unjustified);
        if rAbsenceJustify.FindSet then begin
            repeat
                rAbsenceJustify.Validate(rAbsenceJustify."Justified Code", vJustification);
                rAbsenceJustify.Modify(true);
            until rAbsenceJustify.Next = 0;
        end;
    end;

    local procedure vStudentOnAfterValidate()
    begin
        rStudent.Reset;
        if rStudent.Get(vStudent) then
            vStudentName := rStudent.Name;
    end;

    local procedure vTeacherOnAfterValidate()
    begin
        rTeacher.Reset;
        if rTeacher.Get(vTeacher) then
            vStudentName := rTeacher.Name;
    end;

    local procedure vIncidentCodeOnAfterValidate()
    begin

        rIncidenceType.Reset;
        rIncidenceType.SetRange("School Year", vSchoolYear);
        if vType <> vType::Teacher then begin
            rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
            rIncidenceType.SetRange(rIncidenceType."Responsibility Center", rClass."Responsibility Center");
        end else
            rIncidenceType.SetRange(rIncidenceType."Responsibility Center", rTeacher."Responsibility Center");
        rIncidenceType.SetRange("Incidence Type", vIncidentType);
        rIncidenceType.SetRange("Subcategory Code", vSubType);
        rIncidenceType.SetFilter("Absence Status", '%1|%2', rIncidenceType."Absence Status"::Unjustified,
                                 rIncidenceType."Absence Status"::Justified);
        rIncidenceType.SetRange(rIncidenceType."Incidence Code", vIncidentCode);
        if rIncidenceType.FindFirst then
            vIncidentStatus := rIncidenceType."Absence Status";
    end;

    local procedure vIncidentTypeOnAfterValidate()
    begin
        vIncidentCode := '';
        vSubType := '';
        vJustification := '';
    end;

    local procedure LookupOKOnPush()
    var
        TestHeader: Record Test;
    begin
        if (vStudent = '') and (vType = vType::Student) then
            Error(Text0001);

        if (vIncidentCode = '') then
            Error(Text0002);

        if (vDateInic = 0D) and (vDateEnd = 0D) then
            Error(Text0003);

        if (vDateInic = 0D) and (vDateEnd <> 0D) then
            Error(Text0004);

        if (vDateInic <> 0D) and (vDateEnd = 0D) then
            Error(Text0005);

        if rTimetable.Get(vTimetableCode) then
            if not ((vDateInic >= rTimetable."Start Period") and (vDateInic <= rTimetable."End Period")) then
                Error(Text0009);

        if (vDateInic = vDateEnd) then begin
            rData.Reset;
            rData.SetRange("Period Type", rData."Period Type"::Date);
            rData.SetRange("Period Start", vDateInic);
            if rData.Find('-') then;

            rBaseCalChangeEDU.Reset;
            rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Annual Recurring");
            rBaseCalChangeEDU.SetRange(Date, rData."Period Start");
            rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
            rBaseCalChangeEDU.SetRange(Nonworking, true);
            if rBaseCalChangeEDU.FindFirst then
                Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

            rBaseCalChangeEDU.Reset;
            rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
            rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
            rBaseCalChangeEDU.SetRange(Nonworking, true);
            if rBaseCalChangeEDU.FindFirst then
                if rDate."Period No." = rBaseCalChangeEDU.Day then
                    Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

        end;

        if (vDateInic < rTimetable."Start Period") and (vDateInic > rTimetable."End Period") then
            Error(Text0007, vDateInic, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);
        if (vDateEnd < rTimetable."Start Period") and (vDateEnd > rTimetable."End Period") then
            Error(Text0008, vDateEnd, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);

        if (vType = vType::Teacher) and (vTeacher = '') then
            Error(Text0015);

        if (vJustification = '') then
            Error(Text0016);

        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Date);
        rDate.SetRange("Period Start", vDateInic, vDateEnd);
        if rDate.Find('-') then
            repeat
                rBaseCalChangeEDU.Reset;
                rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar");
                rBaseCalChangeEDU.SetRange(Date, rDate."Period Start");
                rBaseCalChangeEDU.SetRange(Nonworking, true);
                if not rBaseCalChangeEDU.Find('-') then

                    //***********ALUNO********************
                    if vType = vType::Student then
                        JustifyAbsence;

                //**********TURMA********************
                if vType = vType::Class then
                    JustifyAbsence;

                //**********PROFESSOR*******************
                if vType = vType::Teacher then begin
                    JustifyAbsence;

                end;

            until rDate.Next = 0;

        FinishEnable := true;
        BackEnable := false;
        NextEnable := false;
        /*
        IF VISIBLE THEN BEGIN
          CurrPage.UPDATE(FALSE);
        END;
        */

        CurrPage.Close;
        Message(Text0010);

    end;
}

