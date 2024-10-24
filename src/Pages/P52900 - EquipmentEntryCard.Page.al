#pragma implicitwith disable
page 52900 "Equipment Entry Card"
{
    Caption = 'Equipment Entry';
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Calendar;
    SourceTableTemporary = true;
    SourceTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class);

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(varName; varName)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(varStudentTeacher; varStudentTeacher)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student/Teacher';
                    OptionCaption = ' ,Student,Teacher';

                    trigger OnValidate()
                    begin
                        varStudentTeacherOnAfterValida;
                    end;
                }
                field(varTeacherStudentCode; varTeacherStudentCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Student/Teacher Code No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rTeacher: Record Teacher;
                    begin
                        if varStudentTeacher = varStudentTeacher::Teacher then begin
                            if PAGE.RunModal(PAGE::"Teacher List", rTeacher) = ACTION::LookupOK then begin
                                varTeacherStudentCode := rTeacher."No.";
                                varName := rTeacher.Name + ' ' + rTeacher."Last Name";
                            end;
                        end;
                        if varStudentTeacher = varStudentTeacher::Student then begin
                            if PAGE.RunModal(PAGE::"Students List", rStudents) = ACTION::LookupOK then begin
                                varTeacherStudentCode := rStudents."No.";
                                varName := rStudents.Name;
                            end;
                        end;
                        Rec.DeleteAll;
                        Clear(varBeginDate);
                        Clear(varEndDate);
                        Clear(varTimetableCode);
                        Clear(varTurn);
                        Clear(Rec);
                        UpdateSubForm;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        if varStudentTeacher = varStudentTeacher::Student then begin
                            if rStudents.Get(varTeacherStudentCode) then
                                varName := rStudents.Name;
                        end;
                        if varStudentTeacher = varStudentTeacher::Teacher then begin
                            if rTeacher.Get(varTeacherStudentCode) then
                                varName := rTeacher.Name + ' ' + rTeacher."Last Name";
                        end;
                        varTeacherStudentCodeOnAfterVa;
                    end;
                }
                field(varTimetableCode; varTimetableCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Timetable Code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        fTimetableList: Page "Timetable List";
                    begin
                        rTimetableTemp.DeleteAll;

                        if varStudentTeacher = varStudentTeacher::Teacher then begin
                            rTimetableTeacher.Reset;
                            rTimetableTeacher.SetRange("School Year", varSchoolYear);
                            rTimetableTeacher.SetRange("Teacher No.", varTeacherStudentCode);
                            if rTimetableTeacher.FindSet then begin
                                repeat
                                    rTimetable.Reset;
                                    rTimetable.SetRange("Timetable Code", rTimetableTeacher."Timetable Code");
                                    if rTimetable.FindFirst then begin
                                        rTimetableTemp.Reset;
                                        rTimetableTemp.SetRange("Timetable Code", rTimetableTeacher."Timetable Code");
                                        if not rTimetableTemp.FindFirst then begin
                                            rTimetableTemp.Init;
                                            rTimetableTemp.TransferFields(rTimetable);
                                            rTimetableTemp.Insert;
                                        end;
                                    end;
                                until rTimetableTeacher.Next = 0;
                            end;
                            rTimetableTemp.Reset;
                            rTimetableTemp.Reset;
                            fTimetableList.SetTableView(rTimetableTemp);
                            fTimetableList.LookupMode(true);
                            fTimetableList.PlanitUnVisible(true);
                            fTimetableList.RunModal;
                            fTimetableList.GetRecord(rTimetableTemp);
                            varTimetableCode := rTimetableTemp."Timetable Code";
                        end;
                        if varStudentTeacher = varStudentTeacher::Student then begin
                            rRegistrationSubjects.Reset;
                            rRegistrationSubjects.SetRange("School Year", varSchoolYear);
                            rRegistrationSubjects.SetRange("Student Code No.", varTeacherStudentCode);
                            rRegistrationSubjects.SetRange(Enroled, true);
                            if rRegistrationSubjects.FindSet then begin
                                repeat
                                    rTimetableLines.Reset;
                                    rTimetableLines.SetRange(Class, rRegistrationSubjects.Class);
                                    if rTimetableLines.FindFirst then begin
                                        repeat
                                            rTimetableTemp.Reset;
                                            rTimetableTemp.SetRange("Timetable Code", rTimetableLines."Timetable Code");
                                            if not rTimetableTemp.FindFirst then begin
                                                rTimetableTemp.Init;
                                                rTimetableTemp."Timetable Code" := rTimetableLines."Timetable Code";
                                                rTimetableTemp.Insert;
                                            end;
                                        until rTimetableLines.Next = 0;
                                    end;
                                until rRegistrationSubjects.Next = 0;
                            end;
                            rTimetableTemp.Reset;
                            fTimetableList.SetTableView(rTimetableTemp);
                            fTimetableList.LookupMode(true);
                            fTimetableList.PlanitUnVisible(true);
                            fTimetableList.RunModal;
                            fTimetableList.GetRecord(rTimetableTemp);
                            varTimetableCode := rTimetableTemp."Timetable Code";
                        end;
                        InsertFormLines;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    begin
                        Clear(VarBeginHour);
                        Clear(varEndHour);
                        Clear(varSubject);
                        Clear(varSubSubject);
                        Clear(varTurn);
                        Clear(varRoom);
                        Clear(varDateSelectBegin);
                        Clear(varDateSelectEnd);
                        UpdateSubForm;
                        InsertFormLines;
                        varTimetableCodeOnAfterValidat;
                    end;
                }
                field(varBeginDate; varBeginDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnValidate()
                    begin

                        varEndDate := varBeginDate;

                        InsertFormLines;
                        varBeginDateOnAfterValidate;
                    end;
                }
                field(varEndDate; varEndDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnValidate()
                    begin
                        InsertFormLines;
                        varEndDateOnAfterValidate;
                    end;
                }
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    Editable = false;
                    TableRelation = "School Year" WHERE(Status = FILTER(Active | Closing));
                }
                field(varTurn; varTurn)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Turn';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        rTurn: Record Turn;
                        rTurnTemp: Record Turn temporary;
                    begin
                        if varStudentTeacher = varStudentTeacher::Student then begin
                            rCalendar.Reset;
                            rCalendar.SetCurrentKey("Filter Period", "Start Hour", "End Hour");
                            rCalendar.SetRange("Timetable Code", varTimetableCode);
                            rCalendar.SetRange("Filter Period", varBeginDate, varEndDate);
                            rCalendar.SetFilter(Turn, '<>%1', '');
                            if rCalendar.FindSet then begin
                                repeat
                                    rTurnTemp.Reset;
                                    rTurnTemp.SetRange(Code, rCalendar.Turn);
                                    if not rTurnTemp.Find('-') then begin
                                        if rTurn.Get(rCalendar.Turn) then begin
                                            rTurnTemp.Init;
                                            rTurnTemp.TransferFields(rTurn);
                                            rTurnTemp.Insert;
                                        end;
                                    end;
                                until rCalendar.Next = 0;
                            end;
                        end;
                        if varStudentTeacher = varStudentTeacher::Teacher then begin
                            rTimetableTeacher.Reset;
                            rTimetableTeacher.SetCurrentKey("Filter Period", "Start Hour", "End Hour");
                            rTimetableTeacher.SetRange("Timetable Code", varTimetableCode);
                            rTimetableTeacher.SetRange("Filter Period", varBeginDate, varEndDate);
                            rTimetableTeacher.SetFilter(Turn, '<>%1', '');
                            if rTimetableTeacher.FindSet then begin
                                repeat
                                    rTurnTemp.Reset;
                                    rTurnTemp.SetRange(Code, rTimetableTeacher.Turn);
                                    if not rTurnTemp.Find('-') then begin
                                        if rTurn.Get(rTimetableTeacher.Turn) then begin
                                            rTurnTemp.Init;
                                            rTurnTemp.TransferFields(rTurn);
                                            rTurnTemp.Insert;
                                        end;
                                    end;
                                until rTimetableTeacher.Next = 0;
                            end;
                        end;
                        rTurnTemp.Reset;
                        if PAGE.RunModal(0, rTurnTemp) = ACTION::LookupOK then
                            varTurn := rTurnTemp.Code;




                        InsertFormLines;
                        CurrPage.Update(false);
                    end;

                    trigger OnValidate()
                    var
                        rShoolYear: Record "School Year";
                    begin
                        InsertFormLines;
                        varTurnOnAfterValidate;
                    end;
                }
                field(varRegistered; varRegistered)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Registered';

                    trigger OnValidate()
                    begin
                        varRegisteredOnPush;
                    end;
                }
            }
            repeater(Control1102056000)
            {
                Editable = false;
                ShowCaption = false;
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Filter Period"; Rec."Filter Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Description"; Rec."Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Times; Rec.Times)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Turn; Rec.Turn)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Equipment Entry")
            {
                Caption = 'Equipment Entry';
                part(EquipmentEntry; "Sub-Equipment-Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = EquipmentEntryEditable;
                    SubPageLink = "Timetable Code" = FIELD("Timetable Code"),
                                  "Timetable Line No." = FIELD("Line No.");
                }
            }
            group("Equipment History")
            {
                Caption = 'Equipment History';
                part(EquipmentEntry2; "Sub-Equipment-Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    SubPageLink = Registered = FILTER(true);
                    SubPageView = SORTING("Student/Teacher", "Student/Teacher Code No.", "Entry Type", "Timetable Code", "Timetable Line No.", "Equipment Type", "Equipment Code");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                action("&Post")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        EquipmentEntry: Record "Equipment Entry";
                        xrecEquipmentEntry: Record "Equipment Entry";
                    begin
                        rEquipmentEntry.Post;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnInit()
    begin
        Clear(varSchoolYear);
        Clear(varStudyPlan);
        Clear(varClass);
        Clear(varTurn);
        Clear(varSchoolingYear);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord2;
    end;

    trigger OnOpenPage()
    begin
        Clear(Rec);
        varSchoolYear := cStudentsRegistration.GetShoolYearActive;
    end;

    var
        rCalendar: Record Calendar;
        rClass: Record Class;
        rStudents: Record Students;
        rSubjects: Record Subjects;
        rTeacher: Record Teacher;
        rTimetableTeacher: Record "Timetable-Teacher";
        rTimetableTemp: Record Timetable temporary;
        rTimetable: Record Timetable;
        rTimetableLines: Record "Timetable Lines";
        rRegistrationSubjects: Record "Registration Subjects";
        rEquipment: Record Equipment;
        rEquipmentEntry: Record "Equipment Entry";
        CTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        cStudentsRegistration: Codeunit "Students Registration";
        cPermissions: Codeunit Permissions;
        varAno: Integer;
        varMes: Option " ",Janeiro,Fevereiro,"Março",Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro;
        varBeginDate: Date;
        varEndDate: Date;
        varSchoolingYear: Code[10];
        varStudyPlan: Code[20];
        varClass: Code[20];
        varTimetable: Code[20];
        varAvailableQuant: Integer;
        vOK: Boolean;
        cUserEducation: Codeunit "User Education";
        Text005: Label 'Inserting Class is Mandatory.';
        varStudentCodeNo: Code[20];
        varSchoolYear: Code[20];
        varEntryNo: Integer;
        varType: Option " ",Subject,"Non scholar component","Non scholar hours";
        varEntrytype: Option " ","Order",Anulled,Returned,Extension;
        varStudentTeacher: Option " ",Student,Teacher;
        varName: Text[250];
        varTimetableCode: Code[20];
        varTeacherStudentCode: Code[20];
        varTeacherCodeNo: Code[20];
        varTimetableLineNo: Integer;
        varTimetableLastLineNo: Integer;
        varAvailableQuantity: Integer;
        varAvailableQuantityOld: Integer;
        varDataBegin: Date;
        varDataEnd: Date;
        varDateSelectBegin: Date;
        varDateSelectEnd: Date;
        VarBeginHour: Time;
        varEndHour: Time;
        varSubject: Code[20];
        varTurn: Code[20];
        varSubSubject: Code[20];
        varRoom: Code[20];
        varEquipmentType: Option " ",Single,Group;
        varTextLine: Text[250];
        varQuantity: Integer;
        varEquipmentCode: Code[20];
        varRegistered: Boolean;
        [InDataSet]
        EquipmentEntryEditable: Boolean;


    procedure SetFormFilters(pSchoolYear: Code[9]; pStudyPlan: Code[20]; pClass: Code[20]; pTimetable: Code[20]; pType: Option Simple,Multi)
    begin
        varSchoolYear := pSchoolYear;
        varStudyPlan := pStudyPlan;
        varClass := pClass;
        varTimetable := pTimetable;
        varType := pType;
    end;


    procedure SetEditableSubform()
    begin
        EquipmentEntryEditable := true;
    end;


    procedure InsertFormLines()
    var
        lRegistrationSubjects: Record "Registration Subjects";
        LineNo: Integer;
        LastStudent: Code[20];
        TempCalendar: Record Calendar temporary;
        rCalendar: Record Calendar;
        rTimetable: Record Timetable;
    begin
        Rec.DeleteAll;
        if varStudentTeacher = varStudentTeacher::Student then begin
            rCalendar.Reset;
            rCalendar.SetCurrentKey("Filter Period", "Start Hour", "End Hour");
            rCalendar.SetRange("Timetable Code", varTimetableCode);
            rCalendar.SetRange("Filter Period", varBeginDate, varEndDate);
            if varTurn <> '' then
                rCalendar.SetRange(Turn, varTurn);
            if rCalendar.FindSet then begin
                repeat
                    Rec.Init;
                    Rec.TransferFields(rCalendar);
                    varAvailableQuant := 0;
                    Rec.Insert;
                until rCalendar.Next = 0;
                SetEditableSubform;
            end;
        end;
        if varStudentTeacher = varStudentTeacher::Teacher then begin
            rTimetableTeacher.Reset;
            rTimetableTeacher.SetCurrentKey("Filter Period", "Start Hour", "End Hour");
            rTimetableTeacher.SetRange("Timetable Code", varTimetableCode);
            rTimetableTeacher.SetRange("Filter Period", varBeginDate, varEndDate);
            rTimetableTeacher.SetRange("Teacher No.", varTeacherStudentCode);
            if varTurn <> '' then
                rTimetableTeacher.SetRange(Turn, varTurn);
            if rTimetableTeacher.FindSet then begin
                repeat
                    Rec.Init;
                    Rec."Timetable Code" := rTimetableTeacher."Timetable Code";
                    Rec."Line No." := rTimetableTeacher."Timetable Line No.";
                    Rec."Filter Period" := rTimetableTeacher."Filter Period";
                    Rec."Week Day" := rTimetableTeacher."Week Day";
                    Rec.Subject := rTimetableTeacher.Subject;
                    if rSubjects.Get(rTimetableTeacher."Type Subject", rTimetableTeacher.Subject) then
                        Rec."Subject Description" := rSubjects.Description;
                    Rec."Start Hour" := rTimetableTeacher."Start Hour";
                    Rec."End Hour" := rTimetableTeacher."End Hour";
                    Rec.Room := rTimetableTeacher.Room;
                    Rec."Sub-Subject Code" := rTimetableTeacher."Sub-Subject Code";
                    Rec.Turn := rTimetableTeacher.Turn;
                    Rec."Type Subject" := rTimetableTeacher."Type Subject";
                    varAvailableQuant := 0;
                    Rec.Insert;
                until rTimetableTeacher.Next = 0;
                SetEditableSubform;
            end;
        end;
    end;


    procedure getCurrentRec(var pTimetableCode: Code[20]; var PTimetableLineNo: Integer)
    begin
        pTimetableCode := Rec."Timetable Code";
        PTimetableLineNo := Rec."Line No.";
    end;


    procedure UpdateSubForm()
    begin

        CurrPage.EquipmentEntry.PAGE.SendHeader(Rec);
        CurrPage.EquipmentEntry.PAGE.SendFilters(varStudentTeacher, varTeacherStudentCode, varRegistered);
        CurrPage.EquipmentEntry2.PAGE.SendFilters(0, '', true);

        if varRegistered then begin
            CurrPage.EquipmentEntry.PAGE.EditableFunc(true);
        end else begin
            CurrPage.EquipmentEntry.PAGE.EditableFunc(false);
        end;
    end;

    local procedure varBeginDateOnAfterValidate()
    begin
        Clear(varTurn);
        UpdateSubForm;
        CurrPage.Update(false);
    end;

    local procedure varEndDateOnAfterValidate()
    begin
        Clear(varTurn);
        UpdateSubForm;
        CurrPage.Update(false);
    end;

    local procedure varTurnOnAfterValidate()
    begin
        UpdateSubForm;
        CurrPage.Update(false);
    end;

    local procedure varTimetableCodeOnAfterValidat()
    begin
        Rec.DeleteAll;
        Clear(varBeginDate);
        Clear(varEndDate);
        CurrPage.Update(false);
    end;

    local procedure varTeacherStudentCodeOnAfterVa()
    begin
        Rec.DeleteAll;
        Clear(varBeginDate);
        Clear(varEndDate);
        Clear(varTimetableCode);
        Clear(varTurn);
        Clear(Rec);
        UpdateSubForm;
        CurrPage.Update(false);
    end;

    local procedure varStudentTeacherOnAfterValida()
    begin
        Rec.DeleteAll;
        Clear(varTeacherStudentCode);
        Clear(varBeginDate);
        Clear(varEndDate);
        Clear(varTimetableCode);
        Clear(varName);
        Clear(varTurn);
        Clear(Rec);
        UpdateSubForm;
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord2()
    begin
        xRec := Rec;
        UpdateSubForm;
    end;

    local procedure EquipmentEntry2OnActivate()
    begin
        CurrPage.EquipmentEntry2.PAGE.SendFilters(0, '', true);
    end;

    local procedure varRegisteredOnPush()
    begin
        UpdateSubForm;
    end;
}

#pragma implicitwith restore

