page 52895 "Transports Wizard"
{
    Caption = 'Transport & Lunch Wizard';
    PageType = NavigatePage;
    Permissions = TableData "Transport & Lunch Entry " = rimd;

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                field(vTransType; vTransType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Option';
                    OptionCaption = ' ,Driver Absence,Student Transport,Transport Alteration,Student Lunch';

                    trigger OnValidate()
                    begin
                        vTransTypeOnAfterValidate;
                    end;
                }
                group(frameVehicle)
                {
                    Caption = 'Transport';
                    Visible = frameVehicleVisible;
                    field(vOLDVehicle; vOLDVehicle)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport';
                        TableRelation = Transport."Transport No.";

                        trigger OnValidate()
                        begin
                            if vOLDVehicle <> '' then begin
                                rVehicle.Reset;
                                rVehicle.SetRange(Type, rVehicle.Type::Header);
                                rVehicle.SetRange("Transport No.", vOLDVehicle);
                                if rVehicle.FindFirst then
                                    vOLDVehicleName := rVehicle.Description;
                            end else
                                vOLDVehicleName := '';
                        end;
                    }
                    field(vOLDVehicleName; vOLDVehicleName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport Name';
                        Editable = false;
                    }
                    field(vVehic1; vVehicle)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Transport';
                        TableRelation = Transport."Transport No.";

                        trigger OnValidate()
                        begin
                            if vOLDVehicle <> '' then begin
                                rVehicle.Reset;
                                rVehicle.SetRange(Type, rVehicle.Type::Header);
                                rVehicle.SetRange("Transport No.", vVehicle);
                                if rVehicle.FindFirst then
                                    vVehicleName := rVehicle.Description;
                            end else
                                vVehicleName := '';
                        end;
                    }
                    field(vVehicleName; vVehicleName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport Name';
                        Editable = false;
                    }
                    field(varStartDate1; varStartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            varEndingDate := varStartingDate;
                        end;
                    }
                    field(varEndDate1; varEndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                }
                group(frameAluno)
                {
                    Caption = 'Students Transport';
                    Visible = frameAlunoVisible;
                    field(varOpt1; varOption)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Option';
                        OptionCaption = 'Non-Attendance,Cancel,Correct';

                        trigger OnValidate()
                        begin
                            varOptionC1102065007OnAfterVal;
                        end;
                    }
                    field(varVehicleOption; varVehicleOption)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport';
                        OptionCaption = 'Both,Collect,Deliver';

                        trigger OnValidate()
                        begin
                            varVehicleOptionOnAfterValidat;
                        end;
                    }
                    field(vStudent1; vStudent)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Student No.';
                        TableRelation = Students."No.";

                        trigger OnValidate()
                        begin
                            if vStudent <> '' then begin
                                rStudents.Reset;
                                rStudents.SetRange("No.", vStudent);
                                rStudents.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if rStudents.FindFirst then
                                    vStudName := rStudents."Short Name"
                                else
                                    Error(Text0004);
                            end else
                                vStudName := '';
                        end;
                    }
                    field(vStudName1; vStudName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Student Name';
                        Editable = false;
                    }
                    field(varStartDate2; varStartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            varEndingDate := varStartingDate;
                        end;
                    }
                    field(varEndDate2; varEndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                }
                group(frameStudentLunch)
                {
                    Caption = 'Students Lunch';
                    Visible = frameStudentLunchVisible;
                    field(varOpt2; varOption)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Option';
                        OptionCaption = 'Non-Attendance,Cancel,Correct';

                        trigger OnValidate()
                        begin
                            varOptionC1102065019OnAfterVal;
                        end;
                    }
                    field(vStudent2; vStudent)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Student No.';
                        TableRelation = Students."No.";

                        trigger OnValidate()
                        begin
                            if vStudent <> '' then begin
                                rStudents.Reset;
                                rStudents.SetRange("No.", vStudent);
                                rStudents.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                                if rStudents.FindFirst then
                                    vStudName := rStudents."Short Name"
                                else
                                    Error(Text0004);
                            end else
                                vStudName := '';
                        end;
                    }
                    field(vStudName2; vStudName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Student Name';
                        Editable = false;
                    }
                    field(varStartDate3; varStartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            varEndingDate := varStartingDate;
                        end;
                    }
                    field(varEndDate3; varEndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                    }
                }
                group(frameDriver)
                {
                    Caption = 'Driver';
                    Visible = frameDriverVisible;
                    field(vDriver; vDriver)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Driver';
                    }
                    field(vVehic2; vVehicle)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transport';
                        TableRelation = Transport."Transport No.";
                    }
                    field(varStartDate4; varStartingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            varEndingDate := varStartingDate;
                        end;
                    }
                    field(varEndDate4; varEndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
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
                ApplicationArea = All;
                Caption = '&Back';
                Enabled = BackEnable;
                Image = PreviousRecord;
                //Promoted = true;
                //PromotedCategory = Process;
                Visible = false;

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
                //Promoted = true;
                //PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    if vTransType = vTransType::" " then
                        Error(Text0005);

                    SetSubMenu(CurrMenuType, false);
                    CurrMenuType := CurrMenuType + 1;
                    SetSubMenu(CurrMenuType, true);
                end;
            }
            action(Finish)
            {
                ApplicationArea = All;
                Caption = 'F&inish';
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin

                    case vTransType of
                        vTransType::"Student Transport":
                            AbsenceStudent;
                        vTransType::"Usual Driver Absence":
                            AbsenceDriver;
                        vTransType::"Vehicle Absence":
                            AbsenceVehicle;
                        vTransType::Lunch:
                            AbsenceStudentLunch;
                    end;

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        NextEnable := true;
        frameStudentLunchVisible := true;
        frameVehicleVisible := true;
        frameDriverVisible := true;
        frameAlunoVisible := true;
    end;

    trigger OnOpenPage()
    begin
        //CurrForm.Step2.XPOS := 4400;
        //CurrForm.Step2.YPOS := 0;

        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := Round((FrmWidth - FormWidth) / 2, 1) + FrmXPos;
        FrmYPos := 3000;
        FrmHeight := CancelYPos + CancelHeight + 220;
        FrmWidth := FormWidth;

        CurrMenuType := 1;
        SetSubMenu(CurrMenuType, true);

        frameAlunoVisible := false;
        frameDriverVisible := false;
        frameVehicleVisible := false;
        frameStudentLunchVisible := false;


        Clear(vTransType);
        Clear(vStudent);
        Clear(vStudName);
        Clear(vPostingDate);
        Clear(vDriver);
        Clear(vStudName2);
        Clear(vVehicle);
        Clear(vHour);
        Clear(vVehicleName);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        rStudents: Record Students;
        rVehicle: Record Transport;
        rSchoolYear: Record "School Year";
        rRegistration: Record Registration;
        CurrMenuType: Integer;
        FormWidth: Integer;
        vTransType: Option " ","Usual Driver Absence","Student Transport","Vehicle Absence",Lunch;
        vStudent: Code[20];
        vStudName: Text[50];
        vPostingDate: Date;
        Text0001: Label 'The process was completed successfully.';
        vDriver: Text[60];
        vStudName2: Text[50];
        vVehicle: Code[20];
        vHour: Time;
        vVehicleName: Text[30];
        vOLDVehicle: Code[20];
        vOLDVehicleName: Text[30];
        Text0002: Label 'Please fill the fields Vehicle and Hour.';
        Text0003: Label 'Please fill the students field.';
        varStartingDate: Date;
        varEndingDate: Date;
        varVehicleOption: Option Both,Collect,Deliver;
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Student Not found.';
        rDate: Record Date;
        varOption: Option "Non-Attendance",Cancel,Correct;
        Text0005: Label 'You must select an option.';
        Text0006: Label 'The user must fill the requested fields before proceeding.';
        [InDataSet]
        frameAlunoVisible: Boolean;
        [InDataSet]
        frameDriverVisible: Boolean;
        [InDataSet]
        frameVehicleVisible: Boolean;
        [InDataSet]
        frameStudentLunchVisible: Boolean;
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
        FinishEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        NextEnable: Boolean;

    local procedure SetSubMenu(MenuType: Integer; Visible: Boolean)
    var
        rDate: Record Date;
        rBaseCalendarChange: Record "Base Calendar Change";
        rTimetable: Record Timetable;
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
        end;
    end;

    //[Scope('OnPrem')]
    procedure SetFormFilter(pTimetableCode: Code[20])
    begin
        //vTimetableCode := pTimetableCode;
    end;

    //[Scope('OnPrem')]
    procedure EditFields()
    begin
        case vTransType of
            vTransType::"Student Transport":
                begin
                    frameAlunoVisible := true;
                    frameDriverVisible := false;
                    frameVehicleVisible := false;
                    frameStudentLunchVisible := false;

                    FinishEnable := true;
                    BackEnable := false;
                    NextEnable := false;
                end;

            vTransType::"Usual Driver Absence":
                begin

                    frameDriverVisible := true;
                    frameAlunoVisible := false;
                    frameVehicleVisible := false;
                    frameStudentLunchVisible := false;

                    FinishEnable := true;
                    BackEnable := false;
                    NextEnable := false;
                end;

            vTransType::"Vehicle Absence":
                begin
                    frameAlunoVisible := false;
                    frameDriverVisible := false;
                    frameVehicleVisible := true;
                    frameStudentLunchVisible := false;

                    FinishEnable := true;
                    BackEnable := false;
                    NextEnable := false;
                end;
            vTransType::Lunch:
                begin
                    frameAlunoVisible := false;
                    frameDriverVisible := false;
                    frameVehicleVisible := false;
                    frameStudentLunchVisible := true;

                    FinishEnable := true;
                    BackEnable := false;
                    NextEnable := false;
                end;


            else begin
                frameAlunoVisible := false;
                frameDriverVisible := false;
                frameVehicleVisible := false;
                frameStudentLunchVisible := false;

                FinishEnable := false;
                BackEnable := false;
                NextEnable := true;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure AbsenceStudent()
    var
        rVehicleEntry: Record "Transport & Lunch Entry ";
        rRegistration: Record Registration;
        rVehicle: Record Transport;
        vLastMov: Integer;
        rStudentsNLHours: Record "Students Non Lective Hours";
    begin
        Clear(vLastMov);

        if (vStudent = '') or (varStartingDate = 0D) or (varEndingDate = 0D) then
            Error(Text0006);

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;

        if varOption = varOption::"Non-Attendance" then begin
            rVehicleEntry.Reset;
            if rVehicleEntry.Find('+') then
                vLastMov := rVehicleEntry."Entry No." + 1
            else
                vLastMov := 1;

            rDate.Reset;
            rDate.SetRange("Period Type", rDate."Period Type"::Date);
            rDate.SetRange("Period Start", varStartingDate, varEndingDate);
            if rDate.FindSet then begin
                repeat
                    if rStudentsNLHours.Get(vStudent, rSchoolYear."School Year", rDate."Period No." - 1,
                                            rStudents."Responsibility Center") then
                        if (rStudentsNLHours."Collect Transport" <> '') or
                           (rStudentsNLHours."Deliver Transport" <> '') then begin
                            rVehicleEntry.Reset;
                            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
                            rVehicleEntry.SetRange("School Year", rSchoolYear."School Year");
                            rVehicleEntry.SetRange("Student No.", vStudent);
                            rVehicleEntry.SetRange("Absence Day", varStartingDate, varEndingDate);
                            rVehicleEntry.SetRange("Responsibility Center", rStudents."Responsibility Center");
                            rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                            if varVehicleOption = varVehicleOption::Collect then
                                rVehicleEntry.SetRange(rVehicleEntry."Collect Transport", rStudentsNLHours."Collect Transport");
                            if varVehicleOption = varVehicleOption::Deliver then
                                rVehicleEntry.SetRange(rVehicleEntry."Deliver Transport", rStudentsNLHours."Deliver Transport");
                            if not rVehicleEntry.FindSet then begin
                                rVehicleEntry.Init;
                                rVehicleEntry."Entry No." := vLastMov;
                                rVehicleEntry."Entry Type" := rVehicleEntry."Entry Type"::"Student Transport";
                                rVehicleEntry."School Year" := rSchoolYear."School Year";
                                rVehicleEntry."Posting Date" := WorkDate;
                                rVehicleEntry.Validate("Student No.", vStudent);
                                rVehicleEntry."Transports Absence" := varVehicleOption;
                                rVehicleEntry."Absence Day" := rDate."Period Start";
                                if varVehicleOption = varVehicleOption::Both then begin
                                    rVehicleEntry."Transport No." := rStudentsNLHours."Collect Transport";
                                    rVehicleEntry."Collect Transport" := rStudentsNLHours."Collect Transport";
                                    rVehicleEntry."Collect Time" := rStudentsNLHours."Estimated Colect Hour";
                                    rVehicleEntry."Deliver Transport" := rStudentsNLHours."Deliver Transport";
                                    rVehicleEntry."Deliver Time" := rStudentsNLHours."Estimated Deliver Hour";
                                end;
                                if varVehicleOption = varVehicleOption::Collect then begin
                                    rVehicleEntry."Transport No." := rStudentsNLHours."Collect Transport";
                                    rVehicleEntry."Collect Time" := rStudentsNLHours."Estimated Colect Hour";
                                    rVehicleEntry."Collect Transport" := rStudentsNLHours."Collect Transport";

                                end;
                                if varVehicleOption = varVehicleOption::Deliver then begin
                                    rVehicleEntry."Transport No." := rStudentsNLHours."Deliver Transport";
                                    rVehicleEntry."Deliver Time" := rStudentsNLHours."Estimated Deliver Hour";
                                    rVehicleEntry."Deliver Transport" := rStudentsNLHours."Deliver Transport";
                                end;
                                rVehicleEntry."User Id" := UserId;
                                rVehicleEntry.Date := WorkDate;
                                rVehicleEntry.Insert(true);
                                vLastMov += 1;
                            end;
                        end;
                until rDate.Next = 0;
                Message(Text0001);
            end;
        end;

        if (varOption = varOption::Cancel) or (varOption = varOption::Correct) then begin
            rVehicleEntry.Reset;
            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
            rVehicleEntry.SetRange("School Year", rSchoolYear."School Year");
            rVehicleEntry.SetRange("Student No.", vStudent);
            rVehicleEntry.SetRange("Absence Day", varStartingDate, varEndingDate);
            rVehicleEntry.SetRange("Responsibility Center", rStudents."Responsibility Center");
            if rVehicleEntry.FindSet then begin
                repeat
                    if varOption = varOption::Cancel then begin
                        if varVehicleOption = varVehicleOption::Both then begin
                            rVehicleEntry."Transport Collect Cancelled" := true;
                            rVehicleEntry."Transport Deliver Cancelled" := true;
                        end;
                        if varVehicleOption = varVehicleOption::Collect then
                            rVehicleEntry."Transport Collect Cancelled" := true;
                        if varVehicleOption = varVehicleOption::Deliver then
                            rVehicleEntry."Transport Deliver Cancelled" := true;
                    end;
                    if varOption = varOption::Correct then begin
                        if varVehicleOption = varVehicleOption::Both then begin
                            rVehicleEntry."Transport Collect Cancelled" := false;
                            rVehicleEntry."Transport Deliver Cancelled" := false;
                        end;
                        if varVehicleOption = varVehicleOption::Collect then
                            rVehicleEntry."Transport Collect Cancelled" := false;
                        if varVehicleOption = varVehicleOption::Deliver then
                            rVehicleEntry."Transport Deliver Cancelled" := false;
                    end;


                    rVehicleEntry."User Id" := UserId;
                    rVehicleEntry.Date := WorkDate;
                    rVehicleEntry.Modify;
                until rVehicleEntry.Next = 0;
                Message(Text0001);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure AbsenceDriver()
    var
        rVehicleEntry: Record "Transport & Lunch Entry ";
        rStudent: Record Students;
        rRegistration: Record Registration;
        rVehicle: Record Transport;
        vLastMov: Integer;
    begin
        Clear(vLastMov);

        if (vDriver = '') or (vVehicle = '') or (varStartingDate = 0D) or (varEndingDate = 0D) then
            Error(Text0006);


        rVehicleEntry.Reset;
        if rVehicleEntry.Find('+') then
            vLastMov := rVehicleEntry."Entry No." + 1
        else
            vLastMov := 1;

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;




        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Date);
        rDate.SetRange("Period Start", varStartingDate, varEndingDate);
        if rDate.FindSet then begin
            repeat

                rVehicleEntry.Reset;
                rVehicleEntry.Init;
                rVehicleEntry."Entry No." := vLastMov;
                rVehicleEntry."Entry Type" := rVehicleEntry."Entry Type"::"Driver Absence";
                rVehicleEntry."Posting Date" := vPostingDate;
                if vDriver <> '' then
                    rVehicleEntry."New Driver" := vDriver;
                if rVehicle.Get(rVehicle.Type::Header, vVehicle, 0) then
                    rVehicleEntry.Driver := rVehicle.Driver;
                rVehicleEntry."Absence Day" := rDate."Period Start";
                rVehicleEntry."Transport No." := vVehicle;
                rVehicleEntry."School Year" := rSchoolYear."School Year";
                rVehicleEntry."User Id" := UserId;
                rVehicleEntry.Date := WorkDate;
                rVehicleEntry.Insert(true);
                vLastMov += 1;
            until rDate.Next = 0;
            Message(Text0001);
        end;
    end;

    //[Scope('OnPrem')]
    procedure AbsenceVehicle()
    var
        rVehicleEntry: Record "Transport & Lunch Entry ";
        rStudent: Record Students;
        rRegistration: Record Registration;
        rVehicle: Record Transport;
        vLastMov: Integer;
    begin
        Clear(vLastMov);

        if (vOLDVehicle = '') or (vVehicle = '') or (varStartingDate = 0D) or (varEndingDate = 0D) then
            Error(Text0006);


        rVehicleEntry.Reset;
        if rVehicleEntry.Find('+') then
            vLastMov := rVehicleEntry."Entry No." + 1
        else
            vLastMov := 1;

        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;

        rDate.Reset;
        rDate.SetRange("Period Type", rDate."Period Type"::Date);
        rDate.SetRange("Period Start", varStartingDate, varEndingDate);
        if rDate.FindSet then begin
            repeat
                rVehicleEntry.Reset;
                rVehicleEntry.Init;
                rVehicleEntry."Entry No." := vLastMov;
                rVehicleEntry."Entry Type" := rVehicleEntry."Entry Type"::"Transport Alteration";
                rVehicleEntry."Posting Date" := vPostingDate;
                rVehicleEntry."Absence Day" := rDate."Period Start";
                rVehicleEntry."School Year" := rSchoolYear."School Year";
                rVehicleEntry."Transport No." := vOLDVehicle;
                rVehicleEntry."New Transport" := vVehicle;
                rVehicleEntry."User Id" := UserId;
                rVehicleEntry.Date := WorkDate;
                rVehicleEntry.Insert(true);
                vLastMov += 1;
            until rDate.Next = 0;
            Message(Text0001);

        end;
    end;

    //[Scope('OnPrem')]
    procedure AbsenceStudentLunch()
    var
        rVehicleEntry: Record "Transport & Lunch Entry ";
        rRegistration: Record Registration;
        rVehicle: Record Transport;
        vLastMov: Integer;
        rStudentsNLHours: Record "Students Non Lective Hours";
    begin
        Clear(vLastMov);

        if (vStudent = '') or (varStartingDate = 0D) or (varEndingDate = 0D) then
            Error(Text0006);


        rSchoolYear.Reset;
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Active);
        if rSchoolYear.FindFirst then;

        if varOption = varOption::"Non-Attendance" then begin
            rVehicleEntry.Reset;
            if rVehicleEntry.Find('+') then
                vLastMov := rVehicleEntry."Entry No." + 1
            else
                vLastMov := 1;

            rDate.Reset;
            rDate.SetRange("Period Type", rDate."Period Type"::Date);
            rDate.SetRange("Period Start", varStartingDate, varEndingDate);
            if rDate.FindSet then begin
                repeat
                    if rStudentsNLHours.Get(vStudent, rSchoolYear."School Year", rDate."Period No." - 1,
                                            rStudents."Responsibility Center") then
                        if rStudentsNLHours.Lunch then begin
                            rVehicleEntry.Reset;
                            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Lunch");
                            rVehicleEntry.SetRange("School Year", rSchoolYear."School Year");
                            rVehicleEntry.SetRange("Student No.", vStudent);
                            rVehicleEntry.SetRange("Absence Day", varStartingDate, varEndingDate);
                            rVehicleEntry.SetRange("Responsibility Center", rStudents."Responsibility Center");
                            rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                            if not rVehicleEntry.FindSet then begin
                                rVehicleEntry.Init;
                                rVehicleEntry."Entry No." := vLastMov;
                                rVehicleEntry."Entry Type" := rVehicleEntry."Entry Type"::"Student Lunch";
                                rVehicleEntry."School Year" := rSchoolYear."School Year";
                                rVehicleEntry."Absence Day" := rDate."Period Start";
                                rVehicleEntry."Posting Date" := WorkDate;
                                rVehicleEntry.Validate("Student No.", vStudent);
                                rVehicleEntry."User Id" := UserId;
                                rVehicleEntry.Date := WorkDate;
                                rVehicleEntry.Insert(true);
                                vLastMov += 1;
                            end;
                        end;
                until rDate.Next = 0;
                Message(Text0001);
            end;
        end;

        if (varOption = varOption::Cancel) or (varOption = varOption::Correct) then begin
            rVehicleEntry.Reset;
            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Lunch");
            rVehicleEntry.SetRange("School Year", rSchoolYear."School Year");
            rVehicleEntry.SetRange("Student No.", vStudent);
            rVehicleEntry.SetRange("Absence Day", varStartingDate, varEndingDate);
            rVehicleEntry.SetRange("Responsibility Center", rStudents."Responsibility Center");
            if rVehicleEntry.FindSet then begin
                repeat
                    if varOption = varOption::Cancel then
                        rVehicleEntry."Lunch Cancelled" := true;
                    if varOption = varOption::Correct then
                        rVehicleEntry."Lunch Cancelled" := false;
                    rVehicleEntry."User Id" := UserId;
                    rVehicleEntry.Date := WorkDate;
                    rVehicleEntry.Modify;
                until rVehicleEntry.Next = 0;
                Message(Text0001);
            end;
        end;
    end;

    local procedure vTransTypeOnAfterValidate()
    begin
        EditFields;
    end;

    local procedure varVehicleOptionOnAfterValidat()
    begin
        EditFields;
    end;

    local procedure varOptionC1102065007OnAfterVal()
    begin
        EditFields;
    end;

    local procedure varOptionC1102065019OnAfterVal()
    begin
        EditFields;
    end;

    local procedure LookupOKOnPush()
    var
        TestHeader: Record Test;
    begin
        case vTransType of
            vTransType::"Student Transport":
                AbsenceStudent;
            vTransType::"Usual Driver Absence":
                AbsenceDriver;
            vTransType::"Vehicle Absence":
                AbsenceVehicle;
            vTransType::Lunch:
                AbsenceStudentLunch;
        end;

        CurrPage.Close;
    end;
}

