codeunit 52751 Remarks
{
    // //IT001 - Parque - 2016.10.19 - Nova option no parametro pDocType: InvoiceItem.
    // // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
    // 
    // IT002 - Parque - 2014.10.11
    //       - Nova option (Finance Charge Memo) no parametro pDocType da função "EditCommentLineText"


    trigger OnRun()
    begin
    end;

    var
        txtTextLine: Text[250];
        intSeperator: Integer;
        OKText: Label '&Save';
        CancelText: Label '&Cancel';
        ChangedText: Label 'The text has been changed.  Are you sure?';
        ChangedTitleText: Label 'Text changed!';
        Text001: Label 'Observation';
        Text002: Label 'Absence';
        Text003: Label 'Summary';
        //WaldoNavPad: Automation;
        text004: Label 'Irs Statement';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        text005: Label 'Equipment Remarks';
        text006: Label 'Email';

    /*//[Scope('OnPrem')]
    procedure EditContactText(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10]; pClassNumber: Integer)
    begin
        CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);
        WaldoNavPad.FormTitle := STRSUBSTNO('Texts - %1 - %2', pStudentCodeNo, pClass);

        //*** GET THE TEXT FROM THE TABLE ***
        GetContactTexts(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pMomentCode);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        WaldoNavPad.FormTitle := Text001;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        //WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteContactTexts(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pMomentCode);

            SaveContactTexts(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pMomentCode, pClassNumber
          );
        END;


        CLEAR(WaldoNavPad);
    end;

    local procedure GetContactTexts(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10])
    var
        lrecRemarks: Record Remarks;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Student/Teacher Code No.", pStudentCodeNo);
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Assessment);
        lrecRemarks.SETRANGE("Original Line No.", 0);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(lrecRemarks.Textline);
                CASE lrecRemarks.Seperator OF
                    lrecRemarks.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    lrecRemarks.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecRemarks.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    local procedure DeleteContactTexts(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10])
    var
        lrecRemarks: Record Remarks;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Student/Teacher Code No.", pStudentCodeNo);
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE(lrecRemarks."Original Line No.", 0);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Assessment);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        lrecRemarks.DELETEALL(TRUE);
    end;

    local procedure SaveContactTexts(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10]; pClassNumber: Integer)
    var
        lrecRemarks: Record Remarks;
        lintLineNo: Integer;
        rClass: Record Class;
    begin
        WaldoNavPad.TextFieldLength := 240;

        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Student/Teacher Code No.", pStudentCodeNo);
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Assessment);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('+') THEN
            lintLineNo := lrecRemarks."Line No."
        ELSE
            lintLineNo := 0;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            CLEAR(lrecRemarks);
            lrecRemarks.INIT;
            lrecRemarks.Class := pClass;
            lrecRemarks."School Year" := pSchoolYear;
            lrecRemarks."Schooling Year" := pSchoolingYear;
            lrecRemarks.Subject := pSubjects;
            lrecRemarks."Sub-subject" := pSubSubjects;
            lrecRemarks."Study Plan Code" := pStudyPlanCode;
            lrecRemarks."Student/Teacher Code No." := pStudentCodeNo;
            lrecRemarks."Moment Code" := pMomentCode;
            lrecRemarks."Type Remark" := lrecRemarks."Type Remark"::Assessment;
            lrecRemarks."Line No." := lintLineNo;
            lrecRemarks.Textline := txtTextLine;
            lrecRemarks.Seperator := intSeperator;
            IF rClass.GET(pClass, pSchoolYear) THEN
                lrecRemarks."Type Education" := rClass.Type;
            lrecRemarks."Class No." := pClassNumber;
            lrecRemarks."Responsibility Center" := GetRespCenter(pClass, pSchoolYear);
            lrecRemarks."Creation Date" := WORKDATE;
            lrecRemarks."Creation User" := USERID;
            lrecRemarks.INSERT(TRUE);
            cInsertNAVGeneralTable.InsertRemarks(lrecRemarks);

        END;
    end;

    //[Scope('OnPrem')]
    procedure EditContactTextAbsence(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pStatusJustified: Option " ",Unjustified,Justified; "pStudent/Teacher": Option Student,Teacher; pTimeTableCode: Code[20]; pEditable: Boolean; pIncidenceType: Option Default,Absence; pVarLineNo: Integer)
    begin
        CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);
        WaldoNavPad.FormTitle := STRSUBSTNO('Texts - %1 - %2', pStudentCodeNo, pClass);

        //*** GET THE TEXT FROM THE TABLE ***
        GetContactTextsAbsence(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay, pCalendarLine,
                               pStatusJustified, "pStudent/Teacher", pTimeTableCode, pIncidenceType, pVarLineNo);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        WaldoNavPad.FormTitle := Text002;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        IF NOT pEditable THEN
            WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteContactTextsAbsence(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay,
               pCalendarLine, pStatusJustified, "pStudent/Teacher", pTimeTableCode, pIncidenceType, pVarLineNo);

            //Insert the Texts
            SaveContactTextsAbsence(pStudentCodeNo, pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay,
               pCalendarLine, pStatusJustified, "pStudent/Teacher", pTimeTableCode, pIncidenceType, pVarLineNo);
        END;


        CLEAR(WaldoNavPad);
    end;

    local procedure GetContactTextsAbsence(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pStatusJustified: Option " ",Unjustified,Justified; "pStudent/Teacher": Option Student,Teacher; pTimeTableCode: Code[20]; pIncidenceType: Option Default,Absence; pVarLineNo: Integer)
    var
        lrecRemarks: Record Remarks;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Student/Teacher Code No.", pStudentCodeNo);
        lrecRemarks.SETRANGE(Day, pDay);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Absence);
        lrecRemarks.SETRANGE("Original Line No.", 0);
        lrecRemarks.SETRANGE("Calendar Line", pCalendarLine);
        lrecRemarks.SETRANGE("Absence Status", pStatusJustified);
        lrecRemarks.SETRANGE("Student/Teacher", "pStudent/Teacher");
        lrecRemarks.SETRANGE("Incidence Type", pIncidenceType);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        lrecRemarks.SETRANGE("Line No.", pVarLineNo);
        IF lrecRemarks.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(lrecRemarks.Textline);
                CASE lrecRemarks.Seperator OF
                    lrecRemarks.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    lrecRemarks.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecRemarks.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    local procedure DeleteContactTextsAbsence(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pStatusJustified: Option " ",Unjustified,Justified; "pStudent/Teacher": Option Student,Teacher; pTimeTableCode: Code[20]; pIncidenceType: Option Default,Absence; pVarLineNo: Integer)
    var
        lrecRemarks: Record Remarks;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Student/Teacher Code No.", pStudentCodeNo);
        lrecRemarks.SETRANGE(Day, pDay);
        lrecRemarks.SETRANGE(lrecRemarks."Original Line No.", 0);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Absence);
        lrecRemarks.SETRANGE("Calendar Line", pCalendarLine);
        lrecRemarks.SETRANGE("Absence Status", pStatusJustified);
        lrecRemarks.SETRANGE("Student/Teacher", "pStudent/Teacher");
        lrecRemarks.SETRANGE("Incidence Type", pIncidenceType);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        lrecRemarks.SETRANGE("Line No.", pVarLineNo);
        lrecRemarks.DELETEALL(TRUE);
    end;

    local procedure SaveContactTextsAbsence(pStudentCodeNo: Code[20]; pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pStatusJustified: Option " ",Unjustified,Justified; "pStudent/Teacher": Option Student,Teacher; pTimeTableCode: Code[20]; pIncidenceType: Option Default,Absence; pVarLineNo: Integer)
    var
        lrecRemarks: Record Remarks;
        rClass: Record Class;
    begin
        WaldoNavPad.TextFieldLength := 240;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);

            CLEAR(lrecRemarks);
            lrecRemarks.INIT;
            lrecRemarks.Class := pClass;
            lrecRemarks."School Year" := pSchoolYear;
            lrecRemarks."Schooling Year" := pSchoolingYear;
            lrecRemarks.Subject := pSubjects;
            lrecRemarks."Sub-subject" := pSubSubjects;
            lrecRemarks."Study Plan Code" := pStudyPlanCode;
            lrecRemarks."Student/Teacher Code No." := pStudentCodeNo;
            lrecRemarks.Day := pDay;
            lrecRemarks."Type Remark" := lrecRemarks."Type Remark"::Absence;
            lrecRemarks."Line No." := pVarLineNo;
            lrecRemarks.Textline := txtTextLine;
            lrecRemarks.Seperator := intSeperator;
            IF rClass.GET(pClass, pSchoolYear) THEN
                lrecRemarks."Type Education" := rClass.Type;
            lrecRemarks."Calendar Line" := pCalendarLine;
            lrecRemarks."Absence Status" := pStatusJustified;
            lrecRemarks."Student/Teacher" := "pStudent/Teacher";
            lrecRemarks."Timetable Code" := pTimeTableCode;
            lrecRemarks."Incidence Type" := pIncidenceType;
            lrecRemarks."Responsibility Center" := GetRespCenter(pClass, pSchoolYear);
            lrecRemarks."Creation Date" := WORKDATE;
            lrecRemarks."Creation User" := USERID;
            lrecRemarks.INSERT(TRUE);
            cInsertNAVGeneralTable.InsertRemarks(lrecRemarks);

        END;
    end;

    //[Scope('OnPrem')]
    procedure EditContactTextSummary(pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pTimeTableCode: Code[20]; pEditable: Boolean)
    begin
        CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);
        WaldoNavPad.FormTitle := STRSUBSTNO('Texts - %1 - %2', pClass, pSubjects);

        //*** GET THE TEXT FROM THE TABLE ***
        GetContactTextSummary(pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay, pCalendarLine,
                               pTimeTableCode);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        WaldoNavPad.FormTitle := Text003;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        IF pEditable = FALSE THEN
            WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteContactTextSummary(pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay,
               pCalendarLine, pTimeTableCode);

            //Insert the Texts
            SaveContactTextSummary(pSchoolYear, pClass, pSubjects, pSubSubjects, pSchoolingYear, pStudyPlanCode, pDay,
               pCalendarLine, pTimeTableCode);
        END;


        CLEAR(WaldoNavPad);
    end;

    local procedure GetContactTextSummary(pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pTimeTableCode: Code[20])
    var
        lrecRemarks: Record Remarks;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE(Day, pDay);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Summary);
        lrecRemarks.SETRANGE("Original Line No.", 0);
        lrecRemarks.SETRANGE("Calendar Line", pCalendarLine);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(lrecRemarks.Textline);
                CASE lrecRemarks.Seperator OF
                    lrecRemarks.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    lrecRemarks.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecRemarks.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    local procedure DeleteContactTextSummary(pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pTimeTableCode: Code[20])
    var
        lrecRemarks: Record Remarks;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE(Day, pDay);
        lrecRemarks.SETRANGE(lrecRemarks."Original Line No.", 0);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Summary);
        lrecRemarks.SETRANGE("Calendar Line", pCalendarLine);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        lrecRemarks.DELETEALL(TRUE);
    end;

    local procedure SaveContactTextSummary(pSchoolYear: Code[9]; pClass: Code[20]; pSubjects: Code[20]; pSubSubjects: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pDay: Date; pCalendarLine: Integer; pTimeTableCode: Code[20])
    var
        lrecRemarks: Record Remarks;
        lintLineNo: Integer;
        rClass: Record Class;
    begin
        WaldoNavPad.TextFieldLength := 240;

        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE(Subject, pSubjects);
        lrecRemarks.SETRANGE("Sub-subject", pSubSubjects);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE(Day, pDay);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Summary);
        lrecRemarks.SETRANGE("Calendar Line", pCalendarLine);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('+') THEN
            lintLineNo := lrecRemarks."Line No."
        ELSE
            lintLineNo := 0;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            CLEAR(lrecRemarks);
            lrecRemarks.INIT;
            lrecRemarks.Class := pClass;
            lrecRemarks."School Year" := pSchoolYear;
            lrecRemarks."Schooling Year" := pSchoolingYear;
            lrecRemarks.Subject := pSubjects;
            lrecRemarks."Sub-subject" := pSubSubjects;
            lrecRemarks."Study Plan Code" := pStudyPlanCode;
            lrecRemarks.Day := pDay;
            lrecRemarks."Type Remark" := lrecRemarks."Type Remark"::Summary;
            lrecRemarks."Line No." := lintLineNo;
            lrecRemarks.Textline := txtTextLine;
            lrecRemarks.Seperator := intSeperator;
            IF rClass.GET(pClass, pSchoolYear) THEN
                lrecRemarks."Type Education" := rClass.Type;
            lrecRemarks."Calendar Line" := pCalendarLine;
            lrecRemarks."Timetable Code" := pTimeTableCode;
            lrecRemarks."Responsibility Center" := GetRespCenter(pClass, pSchoolYear);
            lrecRemarks."Creation Date" := WORKDATE;
            lrecRemarks."Creation User" := USERID;
            lrecRemarks.INSERT(TRUE);
            cInsertNAVGeneralTable.InsertRemarks(lrecRemarks);

        END;
    end;*/

    //[Scope('OnPrem')]
    procedure GetLastNo(): Integer
    var
        rRemarks: Record Remarks;
    begin
        rRemarks.RESET;
        IF rRemarks.FIND('+') THEN
            EXIT(rRemarks."Entry No." + 1)
        ELSE
            EXIT(1);
    end;

    //[Scope('OnPrem')]
    procedure GetRespCenter(pClass: Code[20]; pSchoolYear: Code[9]): Code[10]
    var
        l_Class: Record Class;
    begin
        l_Class.RESET;
        l_Class.SETRANGE(Class, pClass);
        l_Class.SETRANGE("School Year", pSchoolYear);
        IF l_Class.FINDFIRST THEN
            EXIT(l_Class."Responsibility Center")
        ELSE
            EXIT('');
    end;

    /*//[Scope('OnPrem')]
    procedure EditContactTextGClass(pSchoolYear: Code[9]; pClass: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10]; pEditable: Boolean)
    begin
        CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);
        WaldoNavPad.FormTitle := STRSUBSTNO('Texts - %1 - %2', pClass);

        //*** GET THE TEXT FROM THE TABLE ***
        GetContactTextGClass(pSchoolYear, pClass, pSchoolingYear, pStudyPlanCode, pMomentCode);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        WaldoNavPad.FormTitle := Text001;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        IF pEditable = FALSE THEN
            WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteContactTextGClass(pSchoolYear, pClass, pSchoolingYear, pStudyPlanCode, pMomentCode);

            //Insert the Texts
            SaveContactTextGClass(pSchoolYear, pClass, pSchoolingYear, pStudyPlanCode, pMomentCode);
        END;


        CLEAR(WaldoNavPad);
    end;

    local procedure GetContactTextGClass(pSchoolYear: Code[9]; pClass: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10])
    var
        lrecRemarks: Record Remarks;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::"Observation Class");
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(lrecRemarks.Textline);
                CASE lrecRemarks.Seperator OF
                    lrecRemarks.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    lrecRemarks.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecRemarks.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    local procedure DeleteContactTextGClass(pSchoolYear: Code[9]; pClass: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10])
    var
        lrecRemarks: Record Remarks;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::"Observation Class");
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        lrecRemarks.DELETEALL(TRUE);
    end;

    local procedure SaveContactTextGClass(pSchoolYear: Code[9]; pClass: Code[20]; pSchoolingYear: Code[10]; pStudyPlanCode: Code[20]; pMomentCode: Code[10])
    var
        lrecRemarks: Record Remarks;
        lintLineNo: Integer;
        rClass: Record Class;
    begin
        WaldoNavPad.TextFieldLength := 240;

        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE(Class, pClass);
        lrecRemarks.SETRANGE("School Year", pSchoolYear);
        lrecRemarks.SETRANGE("Schooling Year", pSchoolingYear);
        lrecRemarks.SETRANGE("Study Plan Code", pStudyPlanCode);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::"Observation Class");
        lrecRemarks.SETRANGE("Moment Code", pMomentCode);
        lrecRemarks.SETRANGE("Responsibility Center", GetRespCenter(pClass, pSchoolYear));
        IF lrecRemarks.FIND('+') THEN
            lintLineNo := lrecRemarks."Line No."
        ELSE
            lintLineNo := 0;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            CLEAR(lrecRemarks);
            lrecRemarks.INIT;
            lrecRemarks.Class := pClass;
            lrecRemarks."School Year" := pSchoolYear;
            lrecRemarks."Schooling Year" := pSchoolingYear;
            lrecRemarks."Study Plan Code" := pStudyPlanCode;
            lrecRemarks."Type Remark" := lrecRemarks."Type Remark"::"Observation Class";
            lrecRemarks."Line No." := lintLineNo;
            lrecRemarks.Textline := txtTextLine;
            lrecRemarks.Seperator := intSeperator;
            IF rClass.GET(pClass, pSchoolYear) THEN
                lrecRemarks."Type Education" := rClass.Type;
            lrecRemarks."Moment Code" := pMomentCode;
            lrecRemarks."Responsibility Center" := GetRespCenter(pClass, pSchoolYear);
            lrecRemarks."Creation Date" := WORKDATE;
            lrecRemarks."Creation User" := USERID;
            lrecRemarks.INSERT(TRUE);
            cInsertNAVGeneralTable.InsertRemarks(lrecRemarks);
        END;
    end;*/

    //[Scope('OnPrem')]
    procedure EditCommentLineText(pTableName: Enum "Comment Line Table Name"; pSection: Code[20]; pType: Option IRS,Email; pDocType: Option " ",Invoice,"Issue Reminder","Credit Memo",Receipt,InvoiceItem,"Finance Charge Memo")
    var
        TextInput: Page "Comment Line Edit";
        l_rCommentline: Record "Comment Line";
    begin
        //IT001 - Parque - 2016.10.19 - Nova option no parametro pDocType: InvoiceItem.
        // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
        //IT001 - en

        /*CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);

        //*** GET THE TEXT FROM THE TABLE ***
        GetCommentLineTexts(pTableName, pSection, pDocType);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        IF pType = pType::IRS THEN
            WaldoNavPad.FormTitle := text004
        ELSE
            WaldoNavPad.FormTitle := text006;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        //WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteCommentLineTexts(pTableName, pSection, pDocType);

            SaveCommentLineTexts(pTableName, pSection, pDocType);
        //END;


        CLEAR(WaldoNavPad);*/
        l_rCommentline.RESET;
        l_rCommentline.SETRANGE("No.", pSection);
        l_rCommentline.SETRANGE("Table Name", pTableName);
        l_rCommentline.SETRANGE("Document Type", pDocType);
        TextInput.SetTableView(l_rCommentline);
        TextInput.RunModal();
    end;

    /*//[Scope('OnPrem')]
    procedure GetCommentLineTexts(pTableName: Option; pSection: Code[20]; pDocType: Option " ",Invoice,"Issue Reminder","Credit Memo",Receipt,InvoiceItem)
    var
        l_rCommentline: Record "Comment Line";
        char13: Char;
        char10: Char;
    begin
        //IT001 - Parque - 2016.10.19 - Nova option no parametro pDocType: InvoiceItem.
        // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
        //IT001 - en


        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;
        l_rCommentline.RESET;
        l_rCommentline.SETRANGE("No.", pSection);
        l_rCommentline.SETRANGE("Table Name", pTableName);
        l_rCommentline.SETRANGE("Document Type", pDocType);
        IF l_rCommentline.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(l_rCommentline.Comment);
                CASE l_rCommentline.Seperator OF
                    l_rCommentline.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    l_rCommentline.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL l_rCommentline.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    //[Scope('OnPrem')]
    procedure DeleteCommentLineTexts(pTableName: Option; pSection: Code[20]; pDocType: Option " ",Invoice,"Issue Reminder","Credit Memo",Receipt,InvoiceItem)
    var
        l_rCommentline: Record "Comment Line";
    begin
        //IT001 - Parque - 2016.10.19 - Nova option no parametro pDocType: InvoiceItem.
        // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
        //IT001 - en


        // Before Inserting all lines, the current lines need to be deleted
        l_rCommentline.RESET;
        l_rCommentline.SETRANGE("No.", pSection);
        l_rCommentline.SETRANGE("Table Name", pTableName);
        l_rCommentline.SETRANGE("Document Type", pDocType);
        l_rCommentline.DELETEALL(TRUE);
    end;

    //[Scope('OnPrem')]
    procedure SaveCommentLineTexts(pTableName: Option; pSection: Code[20]; pDocType: Option " ",Invoice,"Issue Reminder","Credit Memo",Receipt,InvoiceItem)
    var
        l_rCommentline: Record "Comment Line";
        lintLineNo: Integer;
    begin
        //IT001 - Parque - 2016.10.19 - Nova option no parametro pDocType: InvoiceItem.
        // Este tipo de doc serve para o texto das faturas das fardas, ser diferente do texto das faturas dos serviços
        //IT001 - en



        WaldoNavPad.TextFieldLength := 80;

        l_rCommentline.RESET;
        ;
        l_rCommentline.SETRANGE("Table Name", pTableName);
        l_rCommentline.SETRANGE("No.", pSection);
        l_rCommentline.SETRANGE("Document Type", pDocType);
        IF l_rCommentline.FIND('+') THEN
            lintLineNo := l_rCommentline."Line No."
        ELSE
            lintLineNo := 0;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            l_rCommentline.INIT;
            l_rCommentline."Table Name" := pTableName;
            l_rCommentline."Line No." := lintLineNo;
            l_rCommentline."No." := pSection;
            l_rCommentline.Comment := txtTextLine;
            l_rCommentline.Seperator := intSeperator;
            l_rCommentline."Document Type" := pDocType;
            l_rCommentline.INSERT(TRUE);

        END;
    end;*/

    /*//[Scope('OnPrem')]
    procedure EditEquipmentLineText(pEquipmentEntryNo: Integer)
    begin
        CLEAR(WaldoNavPad);
        CREATE(WaldoNavPad);

        //*** GET THE TEXT FROM THE TABLE ***
        GetEquipmentLineTexts(pEquipmentEntryNo);


        //*** SET FORM PROPERTIES
        WaldoNavPad.OKButtonText := OKText;
        WaldoNavPad.CancelButtonText := CancelText;
        WaldoNavPad.FormTitle := text005;

        WaldoNavPad.ChangedWarningText := ChangedText;
        WaldoNavPad.ChangedWarningTitleText := ChangedTitleText;

        //*** IF YOU WANT THE PAD TO BE READONLY
        //WaldoNavPad.ReadonlyPane := TRUE;

        //*** SET FONT
        //WaldoNavPad.FontSize := 20;
        //WaldoNavPad.FontName := 'Times New Roman';

        //*** OPEN FORM TO EDIT THE TEXT  ***
        WaldoNavPad.ShowDialog;

        IF WaldoNavPad.DialogResultOK THEN BEGIN
            //*** SAVE THE EDITED TEXT        ***
            //First delete all text-lines in the tabel
            DeleteEquipmentLineTexts(pEquipmentEntryNo);

            SaveEquipmentLineTexts(pEquipmentEntryNo);
        END;


        CLEAR(WaldoNavPad);
    end;

    //[Scope('OnPrem')]
    procedure GetEquipmentLineTexts(pEquipmentEntryNo: Integer)
    var
        lrecRemarks: Record Remarks;
        char13: Char;
        char10: Char;
    begin
        // This function gets the text form te table, and puts it in the text-property of WaldoNavPad
        char13 := 13;
        char10 := 10;

        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE("Equipment Entry No.", pEquipmentEntryNo);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Equipment);
        IF lrecRemarks.FIND('-') THEN BEGIN
            REPEAT
                WaldoNavPad.AppendText(lrecRemarks.Textline);
                CASE lrecRemarks.Seperator OF
                    lrecRemarks.Seperator::Space:
                        WaldoNavPad.AppendText(' ');
                    lrecRemarks.Seperator::"Carriage Return":
                        WaldoNavPad.AppendText(FORMAT(char13) + FORMAT(char10));
                END;
            UNTIL lrecRemarks.NEXT = 0;
        END
        ELSE BEGIN
            WaldoNavPad.Text := '';
        END;
    end;

    //[Scope('OnPrem')]
    procedure DeleteEquipmentLineTexts(pEquipmentEntryNo: Integer)
    var
        lrecRemarks: Record Remarks;
    begin
        // Before Inserting all lines, the current lines need to be deleted
        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE("Equipment Entry No.", pEquipmentEntryNo);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Equipment);
        lrecRemarks.DELETEALL(TRUE);
    end;

    //[Scope('OnPrem')]
    procedure SaveEquipmentLineTexts(pEquipmentEntryNo: Integer)
    var
        lrecRemarks: Record Remarks;
        lintLineNo: Integer;
    begin
        WaldoNavPad.TextFieldLength := 240;

        CLEAR(lrecRemarks);
        lrecRemarks.SETRANGE("Equipment Entry No.", pEquipmentEntryNo);
        lrecRemarks.SETRANGE("Type Remark", lrecRemarks."Type Remark"::Equipment);
        IF lrecRemarks.FIND('+') THEN
            lintLineNo := lrecRemarks."Line No."
        ELSE
            lintLineNo := 0;

        WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            WaldoNavPad.GetNextTextField(txtTextLine, intSeperator);
            lintLineNo += 10000;

            CLEAR(lrecRemarks);
            lrecRemarks.INIT;
            lrecRemarks."Type Remark" := lrecRemarks."Type Remark"::Equipment;
            lrecRemarks."Line No." := lintLineNo;
            lrecRemarks.Textline := txtTextLine;
            lrecRemarks.Seperator := intSeperator;
            lrecRemarks."Equipment Entry No." := pEquipmentEntryNo;
            lrecRemarks."Creation Date" := WORKDATE;
            lrecRemarks."Creation User" := USERID;
            lrecRemarks.INSERT(TRUE);
        END;
    end;*/
}

