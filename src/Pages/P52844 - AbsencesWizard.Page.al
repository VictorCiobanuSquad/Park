#pragma implicitwith disable
page 52844 "Absences Wizard"
{
    Caption = 'Absences Wizard';
    DataCaptionFields = "School Year";
    PageType = NavigatePage;
    Permissions = TableData Absence = rimd;
    SourceTable = Class;

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
                    CaptionClass = Text19015602;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = false;
                    Visible = "Study Plan CodeVisible";
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = ClassVisible;
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
                    Caption = 'Initial Absence Date';

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
                    var
                        rStudentsTemp: Record Students temporary;
                    begin

                        rStudent.Reset;
                        rRegistrationClass.Reset;
                        rRegistrationClass.SetRange("School Year", Rec."School Year");
                        rRegistrationClass.SetRange("Schooling Year", Rec."Schooling Year");
                        rRegistrationClass.SetRange("Study Plan Code", Rec."Study Plan Code");
                        rRegistrationClass.SetRange(Class, Rec.Class);
                        if rRegistrationClass.Find('-') then begin
                            repeat
                                rRegistrationClassEntry.Reset;
                                rRegistrationClassEntry.SetCurrentKey("School Year", "Schooling Year", Class, "Class No.", "Status Date");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry.Class, Rec.Class);
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."School Year", Rec."School Year");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Schooling Year", Rec."Schooling Year");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Responsibility Center", Rec."Responsibility Center");
                                rRegistrationClassEntry.SetRange(rRegistrationClassEntry."Student Code No.", rRegistrationClass."Student Code No.");
                                rRegistrationClassEntry.SetFilter(rRegistrationClassEntry."Status Date", '<=%1', vDateEnd);
                                if (rRegistrationClassEntry.Find('+')) and
                                   (rRegistrationClassEntry.Status = rRegistrationClassEntry.Status::Subscribed) then begin
                                    repeat
                                        rStudent.SetRange(rStudent."No.", rRegistrationClassEntry."Student Code No.");
                                        if rStudent.Find('-') then begin
                                            rStudent.CalcFields(rStudent.Class, rStudent."Class No.");
                                            rStudentsTemp.Init;
                                            rStudentsTemp.TransferFields(rStudent);
                                            rStudentsTemp."Temp Class No." := rStudentsTemp."Class No.";
                                            rStudentsTemp.Insert;

                                        end;
                                    until rRegistrationClassEntry.Next = 0;
                                end;

                            until rRegistrationClass.Next = 0;
                        end;

                        rStudentsTemp.SetCurrentKey("Temp Class No.");
                        if PAGE.RunModal(0, rStudentsTemp) = ACTION::LookupOK then begin
                            vStudent := rStudentsTemp."No.";
                            vStudentName := rStudentsTemp.Name;
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
                field(vSubType; vSubType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Subtype';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        vIncidentCode := '';
                        vCompNoLect := '';
                        vQtd := 0;

                        rSubType.Reset;
                        rSubType.SetRange(Category, vIncidentCat);
                        if rSubType.Find('-') then
                            if PAGE.RunModal(0, rSubType) = ACTION::LookupOK then begin
                                vSubType := rSubType."Subcategory Code";
                            end;
                    end;
                }
                field(vIncidentCode; vIncidentCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incidence Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rIncidenceType.Reset;
                        rIncidenceType.SetRange("School Year", Rec."School Year");
                        if vType <> vType::Teacher then rIncidenceType.SetRange("Schooling Year", Rec."Schooling Year");
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
                field(vDateEnd; vDateEnd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ending Absence Date';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec.Count > 0 then
                            CurrPage.Update(false);
                    end;
                }
                field(Nonscholarcomponent; vCompNoLect)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Non scholar component';
                    Visible = NonscholarcomponentVisible;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rSubjects: Record Subjects;
                    begin
                        rSubjects.Reset;
                        rSubjects.SetRange(rSubjects.Type, rSubjects.Type::"Non scholar component");
                        if rSubjects.FindSet then
                            if PAGE.RunModal(52887, rSubjects) = ACTION::LookupOK then begin
                                vCompNoLect := rSubjects.Code;

                                l_rSubjects.Reset;
                                l_rSubjects.SetRange(l_rSubjects.Type, l_rSubjects.Type::"Non scholar component");
                                l_rSubjects.SetRange(l_rSubjects.Code, vCompNoLect);
                                if l_rSubjects.FindFirst then begin
                                    if l_rSubjects."Absence Period" = l_rSubjects."Absence Period"::Daily then begin
                                        vLectureDaily := vLectureDaily::Daily;
                                        vQtd := 1;
                                        QtdEditable := false;
                                    end else
                                        QtdEditable := true;
                                end;

                            end;
                    end;

                    trigger OnValidate()
                    begin
                        vCompNoLectOnAfterValidate;
                    end;
                }
                field(Qtd; vQtd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty.';
                    Editable = QtdEditable;
                    Visible = QtdVisible;
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
                    bFinishEnable := false;
                end;
            }
            action(Next)
            {
                ApplicationArea = Basic, Suite;
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
                var
                    rTimetable: Record Timetable;
                begin
                    SetSubMenu(CurrMenuType, false);
                    CurrMenuType := CurrMenuType + 1;
                    SetSubMenu(CurrMenuType, true);
                    bFinishEnable := true;
                end;
            }
            action(Finish)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'F&inish';
                Enabled = bFinishEnable;
                Image = Approve;
                InFooterBar = true;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

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
                        rBaseCalChangeEDU.SetRange(Date, rData."Period Start");
                        if rTimetable."School Calendar" <> '' then
                            rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                        else begin
                            if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                                rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                        end;
                        rBaseCalChangeEDU.SetRange(Nonworking, true);
                        if rBaseCalChangeEDU.FindFirst then
                            Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

                        rBaseCalChangeEDU.Reset;
                        rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
                        if rTimetable."School Calendar" <> '' then
                            rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                        else begin
                            if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                                rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                        end;
                        rBaseCalChangeEDU.SetRange(Nonworking, true);
                        rBaseCalChangeEDU.SetRange(rBaseCalChangeEDU.Day, rData."Period No.");
                        if rBaseCalChangeEDU.FindFirst then
                            Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

                    end;

                    if (vDateInic < rTimetable."Start Period") and (vDateInic > rTimetable."End Period") then
                        Error(Text0007, vDateInic, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);
                    if (vDateEnd < rTimetable."Start Period") and (vDateEnd > rTimetable."End Period") then
                        Error(Text0008, vDateEnd, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);

                    if (vType = vType::Teacher) and (vTeacher = '') then
                        Error(Text0015);


                    if (vType = vType::Teacher) and (vTeacherNonSchedule = true) and (vCompNoLect = '') then
                        Error(Text0016);

                    if (vType = vType::Teacher) and (vTeacherNonSchedule = true) and (vQtd = 0) then
                        Error(Text0017);


                    rDate.Reset;
                    rDate.SetRange("Period Type", rDate."Period Type"::Date);
                    rDate.SetRange("Period Start", vDateInic, vDateEnd);
                    if rDate.Find('-') then
                        repeat
                            rBaseCalChangeEDU.Reset;
                            if rTimetable."School Calendar" <> '' then
                                rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                            else begin
                                if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                                    rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                            end;
                            rBaseCalChangeEDU.SetRange(Date, rDate."Period Start");
                            rBaseCalChangeEDU.SetRange(Nonworking, true);
                            if not rBaseCalChangeEDU.Find('-') then begin

                                rBaseCalChangeEDU.Reset;
                                rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
                                if rTimetable."School Calendar" <> '' then
                                    rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                                else begin
                                    if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                                        rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                                end;
                                rBaseCalChangeEDU.SetRange(Nonworking, true);
                                rBaseCalChangeEDU.SetRange(rBaseCalChangeEDU.Day, rDate."Period No.");
                                if not rBaseCalChangeEDU.Find('-') then begin

                                    //***********ALUNO********************
                                    if vType = vType::Student then
                                        InsertAbsence1;


                                    //**********TURMA********************
                                    if vType = vType::Class then begin

                                        rRegistrationClass.Reset;
                                        rRegistrationClass.SetRange("School Year", Rec."School Year");
                                        rRegistrationClass.SetRange("Study Plan Code", Rec."Study Plan Code");
                                        rRegistrationClass.SetRange(Class, Rec.Class);
                                        rRegistrationClass.SetRange(rRegistrationClass.Status, rRegistrationClass.Status::Subscribed);
                                        if rRegistrationClass.Find('-') then begin
                                            repeat
                                                vStudent := rRegistrationClass."Student Code No.";
                                                InsertAbsence1;
                                            until rRegistrationClass.Next = 0;
                                        end;
                                    end;


                                    //**********PROFESSOR*******************
                                    if vType = vType::Teacher then begin
                                        if vTeacherNonSchedule = true then
                                            InsertAbsenceTeacher //Faltas a componentes não lectivas não calendarizadas
                                        else
                                            InsertAbsenceTeacherValidation; //Faltas de dia inteiro
                                    end;
                                end;
                            end;
                        until rDate.Next = 0;

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
        ClassVisible := true;
        "Study Plan CodeVisible" := true;
        bStudentVisible := true;
        bTeacherVisible := true;
        QtdEditable := true;
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

        if vType = vType::Teacher then begin
            "Study Plan CodeVisible" := false;
            ClassVisible := false;
        end;

        if vTeacherNonSchedule = true then begin
            NonscholarcomponentVisible := true;
            QtdVisible := true;
        end;

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
        rAbsenceInsert: Record Absence;
        rStudent: Record Students;
        rRegistrationClass: Record "Registration Class";
        rRegistrationClass1: Record "Registration Class";
        rStudyPlanLines: Record "Study Plan Lines";
        rIncidenceType: Record "Incidence Type";
        rData: Record Date;
        rBaseCalChangeEDU: Record "Base Calendar ChangeEDU";
        rHorario: Record Timetable;
        rSubType: Record "Sub Type";
        rRegistrationSubject: Record "Registration Subjects";
        rDate: Record Date;
        rTimetable: Record Timetable;
        rCalendar: Record Calendar;
        rProfessorHorarioInsert: Record "Timetable-Teacher";
        rRegistrationClassEntry: Record "Registration Class Entry";
        rStudentSubjectEntry: Record "Student Subjects Entry";
        tempStudent: Record Students;
        rTeacher: Record Teacher;
        rSubjects: Record Subjects;
        rEduConfi: Record "Edu. Configuration";
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
        vNLinha: Integer;
        vTimetableCode: Code[20];
        vDateInic: Date;
        vDateEnd: Date;
        Text0003: Label 'Inicial Absence Date and Ending Absence Date must not be blank.';
        Text0004: Label 'Inicial Absence Date is blank.\ To select a specific day please fill the Inicial Absence Date and Ending Absence Date with the same date.';
        Text0005: Label 'Ending Absence Date is Blank.\ To select a specific day please fill the Inicial Absence Date and Ending Absence Date with the same date.';
        Text0006: Label 'Date %1 having the following description %2 cannot be chosen since it isn''t a working day.';
        Text0007: Label 'Inicial Absence Date %1 isn''t within range of Timetable %4, which starts on %2 and finishes on the %3. ';
        Text0008: Label 'Ending Absence Date %1 isn''t within range of Timetable %4, which starts on %2 and finishes on the %3. ';
        rStructureEducationCountry: Record "Structure Education Country";
        rCourseLines: Record "Course Lines";
        vHours: Time;
        Text0009: Label 'The selected date is out of the range permit.';
        Text0010: Label 'Terminated process';
        rClass: Record Class;
        Text0011: Label 'There already is an absence the select dates %1.';
        Text0012: Label 'This Incidence Code %1 already exists for the selected date %2.';
        Text0013: Label 'Warning: there is nothing scheduled for the day %1 to the teacher %2. Do you wish to continue?';
        vCompNoLect: Code[10];
        vQtd: Integer;
        vTeacherNonSchedule: Boolean;
        Text0014: Label 'This Incidence %1 already exists for the selected date %2.';
        Text0015: Label 'Teacher field must not be blank.';
        Text0016: Label 'Non scholar component field must not be blank.';
        Text0017: Label 'Qtd. field must not be blank.';
        vLectureDaily: Option Lecture,Daily;
        [InDataSet]
        QtdEditable: Boolean;
        [InDataSet]
        bTeacherVisible: Boolean;
        [InDataSet]
        bStudentVisible: Boolean;
        [InDataSet]
        "Study Plan CodeVisible": Boolean;
        [InDataSet]
        ClassVisible: Boolean;
        [InDataSet]
        NonscholarcomponentVisible: Boolean;
        [InDataSet]
        QtdVisible: Boolean;
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
        Text19015602: Label 'Absences Assistant';
        Text19080001: Label 'Absences Assistant';
        bFinishEnable: Boolean;

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
    procedure SetFormFilter(pTimetableCode: Code[20]; pStudentTeacher: Integer; pInicialDate: Date; pEndDate: Date; pTeacherNonSchedule: Boolean; pSchoolYear: Code[9])
    begin

        vTimetableCode := pTimetableCode;
        vType := pStudentTeacher;
        vDateInic := pInicialDate;
        vDateEnd := pEndDate;
        if pStudentTeacher = 1 then
            vIncidentCat := vIncidentCat::Teacher
        else
            vIncidentCat := vIncidentCat::Class;

        vTeacherNonSchedule := pTeacherNonSchedule;

        Rec.SetRange("School Year", pSchoolYear);
    end;

    //[Scope('OnPrem')]
    procedure InsertAbsence1()
    begin
        rStructureEducationCountry.Reset;
        rStructureEducationCountry.SetRange("Schooling Year", Rec."Schooling Year");
        rStructureEducationCountry.SetRange(Country, Rec."Country/Region Code");
        if rStructureEducationCountry.Find('-') and
          (rStructureEducationCountry."Absence Type" = rStructureEducationCountry."Absence Type"::Daily) then begin
            rCalendar.Reset;
            rCalendar.SetRange("Timetable Code", vTimetableCode);
            rCalendar.SetRange("School Year", Rec."School Year");
            rCalendar.SetRange("Study Plan", Rec."Study Plan Code");
            rCalendar.SetRange(Class, Rec.Class);
            rCalendar.SetRange(rCalendar."Filter Period", rDate."Period Start");
            if rCalendar.Find('-') then
                InsertAbsence2(rStructureEducationCountry."Absence Type"::Daily);

        end else begin

            rCalendar.Reset;
            rCalendar.SetRange("Timetable Code", vTimetableCode);
            rCalendar.SetRange("School Year", Rec."School Year");
            rCalendar.SetRange("Study Plan", Rec."Study Plan Code");
            rCalendar.SetRange(Class, Rec.Class);
            rCalendar.SetRange(rCalendar."Filter Period", rDate."Period Start");
            if rCalendar.Find('-') then begin
                repeat
                    //Temos de ir à Entry para saber se à data da falta ele estava matriculado a essa disciplina
                    rStudentSubjectEntry.Reset;
                    rStudentSubjectEntry.SetCurrentKey("Student Code No.", "School Year", "Schooling Year", "Study Plan Code",
                    "Subjects Code", "Status Date");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Student Code No.", vStudent);
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."School Year", Rec."School Year");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Schooling Year", Rec."Schooling Year");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Study Plan Code", Rec."Study Plan Code");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Subjects Code", rCalendar.Subject);
                    rStudentSubjectEntry.SetFilter(rStudentSubjectEntry."Status Date", '<=%1', rCalendar."Filter Period");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry.Turn, rCalendar.Turn);
                    if (rStudentSubjectEntry.Find('+')) and (rStudentSubjectEntry.Enroled = true) then
                        InsertAbsence2(rStructureEducationCountry."Absence Type"::Lecture);
                until rCalendar.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAbsence2(pAbsenceType: Option Lecture,Daily)
    var
        l_Students: Record Students;
    begin
        if (pAbsenceType = pAbsenceType::Daily) and (vIncidentType = vIncidentType::Absence) then begin
            rAbsence.Reset;
            rAbsence.SetCurrentKey("Timetable Code", Day, "Line No.");
            rAbsence.SetRange("Timetable Code", vTimetableCode);
            rAbsence.SetRange(Day, rDate."Period Start");
            rAbsence.SetRange(rAbsence."Incidence Type", vIncidentType);
            rAbsence.SetRange("Absence Type", pAbsenceType);
            rAbsence.SetRange("Student/Teacher Code No.", vStudent);
            if rAbsence.FindFirst then
                Error(Text0011, rDate."Period Start");
        end;

        rAbsence.Reset;
        rAbsence.SetCurrentKey("Timetable Code", Day, "Line No.");
        rAbsence.SetRange("Timetable Code", vTimetableCode);
        rAbsence.SetRange(Day, rDate."Period Start");
        rAbsence.SetRange(rAbsence."Incidence Type", vIncidentType);
        if rAbsence.Find('+') then
            vNLinha := rAbsence."Line No." + 10000
        else
            vNLinha := 10000;

        rAbsence.Reset;
        rAbsence.SetRange("Timetable Code", vTimetableCode);
        rAbsence.SetRange("School Year", Rec."School Year");
        rAbsence.SetRange("Study Plan", Rec."Study Plan Code");
        rAbsence.SetRange(Class, Rec.Class);
        rAbsence.SetRange(Day, rDate."Period Start");
        rAbsence.SetRange(Type, rTimetable.Type);
        rAbsence.SetRange("Absence Type", pAbsenceType);
        rAbsence.SetRange(rAbsence.Category, vIncidentCat);
        rAbsence.SetRange(rAbsence."Subcategory Code", vSubType);
        rAbsence.SetRange(rAbsence."Incidence Code", vIncidentCode);
        if pAbsenceType = pAbsenceType::Lecture then
            rAbsence.SetRange(rAbsence.Subject, rCalendar.Subject);
        rAbsence.SetRange(rAbsence."Student/Teacher Code No.", vStudent);
        rAbsence.SetRange(rAbsence."Responsibility Center", rCalendar."Responsibility Center");
        rAbsence.SetRange(rAbsence."Line No. Timetable", rCalendar."Line No.");
        if not rAbsence.Find('-') then begin
            rAbsenceInsert.Init;
            rAbsenceInsert."Timetable Code" := vTimetableCode;
            rAbsenceInsert."School Year" := Rec."School Year";
            rAbsenceInsert."Schooling Year" := Rec."Schooling Year";
            rAbsenceInsert."Study Plan" := Rec."Study Plan Code";
            rAbsenceInsert.Class := Rec.Class;
            rAbsenceInsert.Day := rDate."Period Start";
            rAbsenceInsert.Type := rTimetable.Type;
            rAbsenceInsert."Line No. Timetable" := rCalendar."Line No.";
            rAbsenceInsert."Incidence Type" := vIncidentType;
            rAbsenceInsert.Category := vIncidentCat;
            rAbsenceInsert."Subcategory Code" := vSubType;
            rAbsenceInsert."Student/Teacher" := rAbsenceInsert."Student/Teacher"::Student;
            rAbsenceInsert."Student/Teacher Code No." := vStudent;
            if l_Students.Get(vStudent) then begin
                rAbsenceInsert."Student Name" := l_Students.Name;
                rAbsenceInsert."Full Name" := l_Students.Name;
                rAbsenceInsert."Responsibility Center" := l_Students."Responsibility Center";
            end;
            rRegistrationClass1.Reset;
            rRegistrationClass1.SetRange("School Year", Rec."School Year");
            rRegistrationClass1.SetRange("Schooling Year", Rec."Schooling Year");
            rRegistrationClass1.SetRange("Study Plan Code", Rec."Study Plan Code");
            rRegistrationClass1.SetRange(Class, Rec.Class);
            rRegistrationClass1.SetRange(rRegistrationClass1."Student Code No.", vStudent);
            if rRegistrationClass1.FindFirst then
                rAbsenceInsert."Class No." := rRegistrationClass1."Class No.";

            rAbsenceInsert."Line No." := vNLinha;
            if pAbsenceType = pAbsenceType::Lecture then begin
                rAbsenceInsert.Subject := rCalendar.Subject;
                rAbsenceInsert.Turn := rRegistrationSubject.Turn;
            end;
            // Faltava o Código da Sub-Disciplina nas Faltas Diárias
            rAbsenceInsert."Sub-Subject Code" := rCalendar."Sub-Subject Code";
            //
            rAbsenceInsert."Absence Type" := pAbsenceType;
            rAbsenceInsert."Absence Status" := vIncidentStatus;
            rAbsenceInsert."Incidence Code" := vIncidentCode;
            rAbsenceInsert."Type Subject" := rAbsenceInsert."Type Subject"::Subject;
            //GET Descripton
            rIncidenceType.Reset;
            rIncidenceType.SetRange("School Year", Rec."School Year");
            if rClass.Get(Rec.Class, Rec."School Year") then
                rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
            rIncidenceType.SetRange("Incidence Code", vIncidentCode);
            rIncidenceType.SetRange("Incidence Type", vIncidentType);
            rIncidenceType.SetRange(Category, vIncidentCat);
            if rIncidenceType.FindFirst then
                rAbsenceInsert."Incidence Description" := rIncidenceType.Description;

            rAbsenceInsert."Creation Date" := Today;
            rAbsenceInsert."Creation User" := UserId;
            rAbsenceInsert.Insert(true);
        end else begin
            if vType = vType::Student then
                Error(Text0012, rAbsence."Incidence Code", rDate."Period Start");
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertAbsenceTeacherValidation()
    var
        l_Teacher: Record Teacher;
        l_Timetable_Teacher: Record "Timetable-Teacher";
    begin

        l_Timetable_Teacher.Reset;
        l_Timetable_Teacher.SetRange(l_Timetable_Teacher."Teacher No.", vTeacher);
        l_Timetable_Teacher.SetRange(l_Timetable_Teacher."Filter Period", rDate."Period Start");
        if not l_Timetable_Teacher.FindFirst then begin
            if Confirm(StrSubstNo(Text0013, rDate."Period Start", vTeacher)) then
                InsertAbsenceTeacher;
        end else
            InsertAbsenceTeacher;
    end;

    //[Scope('OnPrem')]
    procedure InsertAbsenceTeacher()
    var
        l_Teacher: Record Teacher;
        l_Timetable_Teacher: Record "Timetable-Teacher";
        l_Absence: Record Absence;
    begin
        //Não posso marcar faltas a dia inteiro se já existir uma falta para esse dia, ainda que seja uma falta a aula
        //Não posso marcar faltas a componentes não lectivas do tipo Daily, se já existir uma falta para esse dia,
        //ainda que seja uma falta a aula
        //Não posso marcar faltas a componentes não lectivas do tipo Lecture, se já existir uma falta para esse dia do tipo Daily
        l_Absence.Reset;
        l_Absence.SetRange(l_Absence."School Year", Rec."School Year");
        l_Absence.SetRange(l_Absence."Student/Teacher", l_Absence."Student/Teacher"::Teacher);
        l_Absence.SetRange(l_Absence."Student/Teacher Code No.", vTeacher);
        l_Absence.SetRange(l_Absence."Incidence Type", l_Absence."Incidence Type"::Absence);
        l_Absence.SetRange(l_Absence.Day, rDate."Period Start");
        if (vTeacherNonSchedule = true) and (vLectureDaily = vLectureDaily::Lecture) then
            l_Absence.SetRange(l_Absence."Absence Type", l_Absence."Absence Type"::Daily);
        if l_Absence.FindFirst then
            Error(Text0011, rDate."Period Start");

        //Não posso marcar faltas a componetes n lectivas do tipo aula se já existir uma falta do mesmo tipo para esse dia
        if (vTeacherNonSchedule = true) and (vLectureDaily = vLectureDaily::Lecture) then begin
            l_Absence.Reset;
            l_Absence.SetRange(l_Absence."School Year", Rec."School Year");
            l_Absence.SetRange(l_Absence."Student/Teacher", l_Absence."Student/Teacher"::Teacher);
            l_Absence.SetRange(l_Absence."Student/Teacher Code No.", vTeacher);
            l_Absence.SetRange(l_Absence."Incidence Type", l_Absence."Incidence Type"::Absence);
            l_Absence.SetRange(l_Absence.Day, rDate."Period Start");
            l_Absence.SetRange(l_Absence.Subject, vCompNoLect);
            if l_Absence.FindFirst then
                Error(Text0014, l_Absence.Subject, rDate."Period Start")
        end;



        rAbsence.Reset;
        rAbsence.SetRange("School Year", Rec."School Year");
        rAbsence.SetRange(Day, rDate."Period Start");
        rAbsence.SetRange("Incidence Type", vIncidentType);
        rAbsence.SetRange(rAbsence."Student/Teacher Code No.", vTeacher);
        if rAbsence.FindLast then
            vNLinha := rAbsence."Line No." + 10000
        else
            vNLinha := 10000;


        rAbsenceInsert.Init;
        rAbsenceInsert."School Year" := Rec."School Year";
        rAbsenceInsert.Day := rDate."Period Start";
        rAbsenceInsert."Incidence Type" := vIncidentType;
        rAbsenceInsert.Category := vIncidentCat;
        rAbsenceInsert."Subcategory Code" := vSubType;
        rAbsenceInsert."Student/Teacher" := rAbsenceInsert."Student/Teacher"::Teacher;
        rAbsenceInsert."Student/Teacher Code No." := vTeacher;
        if l_Teacher.Get(vTeacher) then begin
            rAbsenceInsert."Student Name" := l_Teacher.Name;
            rAbsenceInsert."Responsibility Center" := l_Teacher."Responsibility Center";
        end;
        if vTeacherNonSchedule = true then begin
            rAbsenceInsert.Subject := vCompNoLect;
            rAbsenceInsert."Type Subject" := rAbsenceInsert."Type Subject"::"Non scholar component";
        end;

        if (vTeacherNonSchedule = true) and (vLectureDaily = vLectureDaily::Lecture) then
            rAbsenceInsert."Absence Type" := rAbsenceInsert."Absence Type"::Lecture
        else
            rAbsenceInsert."Absence Type" := rAbsenceInsert."Absence Type"::Daily;

        rAbsenceInsert."Line No." := vNLinha;
        rAbsenceInsert."Absence Status" := vIncidentStatus;
        rAbsenceInsert."Incidence Code" := vIncidentCode;


        //GET Descripton
        rIncidenceType.Reset;
        rIncidenceType.SetRange("School Year", Rec."School Year");
        rIncidenceType.SetRange("Incidence Code", vIncidentCode);
        rIncidenceType.SetRange("Incidence Type", vIncidentType);
        rIncidenceType.SetRange(Category, vIncidentCat);
        if rIncidenceType.FindFirst then
            rAbsenceInsert."Incidence Description" := rIncidenceType.Description;

        rAbsenceInsert.Qtd := vQtd;

        rAbsenceInsert."Creation Date" := Today;
        rAbsenceInsert."Creation User" := UserId;
        rAbsenceInsert.Insert(true);
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
        rIncidenceType.SetRange("School Year", Rec."School Year");
        if vType <> vType::Teacher then rIncidenceType.SetRange("Schooling Year", Rec."Schooling Year");
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
        vCompNoLect := '';
        vQtd := 0;
    end;

    local procedure vCompNoLectOnAfterValidate()
    var
        l_rSubjects: Record Subjects;
    begin
        l_rSubjects.Reset;
        l_rSubjects.SetRange(l_rSubjects.Type, l_rSubjects.Type::"Non scholar component");
        l_rSubjects.SetRange(l_rSubjects.Code, vCompNoLect);
        if l_rSubjects.FindFirst then begin
            if l_rSubjects."Absence Period" = l_rSubjects."Absence Period"::Daily then begin
                vLectureDaily := vLectureDaily::Daily;
                vQtd := 1;
                QtdEditable := false;
            end else
                QtdEditable := true;
        end;
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
            rBaseCalChangeEDU.SetRange(Date, rData."Period Start");
            if rTimetable."School Calendar" <> '' then
                rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
            else begin
                if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                    rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
            end;
            rBaseCalChangeEDU.SetRange(Nonworking, true);
            if rBaseCalChangeEDU.FindFirst then
                Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

            rBaseCalChangeEDU.Reset;
            rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
            if rTimetable."School Calendar" <> '' then
                rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
            else begin
                if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                    rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
            end;
            rBaseCalChangeEDU.SetRange(Nonworking, true);
            rBaseCalChangeEDU.SetRange(rBaseCalChangeEDU.Day, rData."Period No.");
            if rBaseCalChangeEDU.FindFirst then
                Error(Text0006, vDateInic, rBaseCalChangeEDU.Description);

        end;

        if (vDateInic < rTimetable."Start Period") and (vDateInic > rTimetable."End Period") then
            Error(Text0007, vDateInic, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);
        if (vDateEnd < rTimetable."Start Period") and (vDateEnd > rTimetable."End Period") then
            Error(Text0008, vDateEnd, rTimetable."Start Period", rTimetable."End Period", vTimetableCode);

        if (vType = vType::Teacher) and (vTeacher = '') then
            Error(Text0015);


        if (vType = vType::Teacher) and (vTeacherNonSchedule = true) and (vCompNoLect = '') then
            Error(Text0016);

        if (vType = vType::Teacher) and (vTeacherNonSchedule = true) and (vQtd = 0) then
            Error(Text0017);


        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Date);
        rDate.SetRange("Period Start", vDateInic, vDateEnd);
        if rDate.Find('-') then
            repeat
                rBaseCalChangeEDU.Reset;
                if rTimetable."School Calendar" <> '' then
                    rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                else begin
                    if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                        rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                end;
                rBaseCalChangeEDU.SetRange(Date, rDate."Period Start");
                rBaseCalChangeEDU.SetRange(Nonworking, true);
                if not rBaseCalChangeEDU.Find('-') then begin

                    rBaseCalChangeEDU.Reset;
                    rBaseCalChangeEDU.SetRange("Recurring System", rBaseCalChangeEDU."Recurring System"::"Weekly Recurring");
                    if rTimetable."School Calendar" <> '' then
                        rBaseCalChangeEDU.SetRange("Base Calendar Code", rTimetable."School Calendar")
                    else begin
                        if (rEduConfi.Get) and (rEduConfi."School Calendar" <> '') then
                            rBaseCalChangeEDU.SetRange("Base Calendar Code", rEduConfi."School Calendar")
                    end;
                    rBaseCalChangeEDU.SetRange(Nonworking, true);
                    rBaseCalChangeEDU.SetRange(rBaseCalChangeEDU.Day, rDate."Period No.");
                    if not rBaseCalChangeEDU.Find('-') then begin

                        //***********ALUNO********************
                        if vType = vType::Student then
                            InsertAbsence1;


                        //**********TURMA********************
                        if vType = vType::Class then begin

                            rRegistrationClass.Reset;
                            rRegistrationClass.SetRange("School Year", Rec."School Year");
                            rRegistrationClass.SetRange("Study Plan Code", Rec."Study Plan Code");
                            rRegistrationClass.SetRange(Class, Rec.Class);
                            rRegistrationClass.SetRange(rRegistrationClass.Status, rRegistrationClass.Status::Subscribed);
                            if rRegistrationClass.Find('-') then begin
                                repeat
                                    vStudent := rRegistrationClass."Student Code No.";
                                    InsertAbsence1;
                                until rRegistrationClass.Next = 0;
                            end;
                        end;


                        //**********PROFESSOR*******************
                        if vType = vType::Teacher then begin
                            if vTeacherNonSchedule = true then
                                InsertAbsenceTeacher //Faltas a componentes não lectivas não calendarizadas
                            else
                                InsertAbsenceTeacherValidation; //Faltas de dia inteiro
                        end;
                    end;
                end;
            until rDate.Next = 0;
        FinishEnable := true;
        BackEnable := false;
        NextEnable := false;
        //IF VISIBLE THEN BEGIN
        //  CurrPage.UPDATE(FALSE);
        //END;


        CurrPage.Close;
        Message(Text0010);
    end;
}

#pragma implicitwith restore

