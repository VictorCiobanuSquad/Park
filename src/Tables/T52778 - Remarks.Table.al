table 52778 Remarks
{
    Caption = 'Remarks';
    Permissions = TableData Absence = rimd;

    fields
    {
        field(1; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(4; Subject; Code[20])
        {
            Caption = 'Subject';
            TableRelation = Subjects.Code;
        }
        field(5; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF ("Type Education" = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                                 "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF ("Type Education" = FILTER(Multi)) "Course Header".Code;
            ValidateTableRelation = false;
        }
        field(6; "Student/Teacher Code No."; Code[20])
        {
            Caption = 'Student/Teacher Code No.';
            TableRelation = IF ("Student/Teacher" = FILTER(Student)) Students."No."
            ELSE
            IF ("Student/Teacher" = FILTER(Teacher)) Teacher."No.";
        }
        field(7; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(9; "Moment Code"; Code[20])
        {
            Caption = 'Moment Code';
            TableRelation = "Moments Assessment"."Moment Code" WHERE("School Year" = FIELD("School Year"),
                                                                      "Schooling Year" = FIELD("Schooling Year"));
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; Textline; Text[250])
        {
            Caption = 'Textline';
        }
        field(12; Seperator; Option)
        {
            Caption = 'Seperator';
            OptionCaption = ' ,Space,Carriage Return';
            OptionMembers = " ",Space,"Carriage Return";
        }
        field(13; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
        }
        field(14; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(15; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(20; "Type Education"; Option)
        {
            Caption = 'Type Education';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21; "Original Line No."; Integer)
        {
            Caption = 'Original Line No.';
        }
        field(22; "Sub-subject"; Code[20])
        {
            Caption = 'Sub-Subject';
        }
        field(23; "Type Remark"; Option)
        {
            Caption = 'Type Remark';
            OptionCaption = 'Assessment,Absence,Summary,Annotation,Observation Class,Equipment';
            OptionMembers = Assessment,Absence,Summary,Annotation,"Observation Class",Equipment;
        }
        field(24; Day; Date)
        {
            Caption = 'Day';
        }
        field(25; "Calendar Line"; Integer)
        {
            Caption = 'Calendar Line';
        }
        field(26; "Absence Status"; Option)
        {
            Caption = 'Absence Status';
            OptionCaption = 'Justified,Unjustified,Justification';
            OptionMembers = Justified,Unjustified,Justification;
        }
        field(27; "Student/Teacher"; Option)
        {
            Caption = 'Student/Teacher';
            OptionCaption = 'Student,Teacher';
            OptionMembers = Student,Teacher;
        }
        field(28; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(29; "Creation User"; Code[20])
        {
            Caption = 'Creation User';
        }
        field(30; "Annotation Code"; Code[10])
        {
            Caption = 'Annotation Cod.';
            Description = 'Averbamentos';
        }
        field(31; "Incidence Type"; Option)
        {
            Caption = 'Incidence Type';
            OptionCaption = 'Default,Absence';
            OptionMembers = Default,Absence;
        }
        field(32; "Mother Language"; Text[250])
        {
            Caption = 'Mother Language';
        }
        field(33; "Equipment Entry No."; Integer)
        {
            Caption = 'Equipment Entry No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Class, "Student/Teacher Code No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Type Remark" = "Type Remark"::Summary then begin
            rCalendar.Reset;
            rCalendar.SetRange("Timetable Code", "Timetable Code");
            rCalendar.SetRange("Filter Period", Day);
            rCalendar.SetRange("Responsibility Center", "Responsibility Center");
            rCalendar.SetRange("School Year", "School Year");
            rCalendar.SetRange(Subject, Subject);
            rCalendar.SetRange("Sub-Subject Code", "Sub-subject");
            rCalendar.SetRange("Lecture Status", rCalendar."Lecture Status"::Summary);
            if rCalendar.Find('-') then
                Error(Text0005);
        end;

        cInsertNAVGeneralTable.DeleteRemarks(Rec);
    end;

    trigger OnInsert()
    begin
        cInsertNAVGeneralTable.InsertRemarks(Rec);
    end;

    trigger OnModify()
    begin
        cInsertNAVGeneralTable.InsertRemarks(Rec);
    end;

    var
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rCalendar: Record Calendar;
        Text0005: Label 'Could not delete, the lecture status is Summary.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;


    procedure GetMotherLanguage(pObservationCode: Code[20]; pSchoolYear: Code[9]; pSex: Option " ",Male,Female; pLineNo: Integer; pLanguage: Option " ",Castilian,English,Euskara,Galego,Deutsch,"Français",Italian,"Portuguese (BR)"): Text[250]
    var
        l_MultiLanguageObservation: Record "Multi language observation";
    begin

        l_MultiLanguageObservation.Reset;
        l_MultiLanguageObservation.SetRange("School Year", pSchoolYear);
        l_MultiLanguageObservation.SetRange("Observation Code", pObservationCode);
        l_MultiLanguageObservation.SetRange("Line No.", pLineNo);
        l_MultiLanguageObservation.SetRange(Language, pLanguage);
        if l_MultiLanguageObservation.FindFirst then begin
            if pSex = pSex::Male then
                exit(l_MultiLanguageObservation."Male Text");
            if pSex = pSex::Female then
                exit(l_MultiLanguageObservation."Female Text");
        end;
    end;


    procedure GetTickText()
    var
        l_rIncidenceType: Record "Incidence Type";
        l_rAbsence: Record Absence;
        l_rObservation: Record Observation;
        l_rStudent: Record Students;
    begin
        if (Textline = '') and ("Student/Teacher" = "Student/Teacher"::Student) then begin
            l_rAbsence.Reset;
            l_rAbsence.SetRange("Timetable Code", "Timetable Code");
            l_rAbsence.SetRange("School Year", "School Year");
            l_rAbsence.SetRange("Schooling Year", "Schooling Year");
            l_rAbsence.SetRange("Line No.", "Original Line No.");
            if l_rAbsence.FindSet then begin
                repeat
                    l_rIncidenceType.Reset;
                    l_rIncidenceType.SetRange("School Year", l_rAbsence."School Year");
                    l_rIncidenceType.SetRange("Schooling Year", l_rAbsence."Schooling Year");
                    l_rIncidenceType.SetRange("Incidence Code", l_rAbsence."Incidence Code");
                    l_rIncidenceType.SetRange("Incidence Type", l_rAbsence."Incidence Type");
                    if l_rIncidenceType.FindFirst then begin
                        l_rObservation.Reset;
                        l_rObservation.SetRange(Code, l_rIncidenceType.Observations);
                        l_rObservation.SetRange("School Year", l_rAbsence."School Year");
                        l_rObservation.SetRange("Observation Type", l_rObservation."Observation Type"::"Incidence Student");
                        l_rObservation.SetRange("Line No.", "Line No.");
                        if l_rObservation.FindFirst then begin
                            if l_rStudent.Get("Student/Teacher Code No.") then begin
                                if l_rStudent.Sex = l_rStudent.Sex::Male then
                                    Textline := l_rObservation."Description Male";
                                if l_rStudent.Sex = l_rStudent.Sex::Female then
                                    Textline := l_rObservation."Description Female";
                            end;
                        end;
                    end;
                until l_rAbsence.Next = 0;
            end;
        end;
    end;
}

