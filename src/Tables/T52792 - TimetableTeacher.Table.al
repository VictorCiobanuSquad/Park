table 52792 "Timetable-Teacher"
{
    Caption = 'Timetable-Teacher';
    DataCaptionFields = "Filter Period", Subject, Meeting, Target, "Teacher Name";
    //DrillDownPageID = 60187;
    //LookupPageID = 60187;
    Permissions = TableData Absence = rimd;

    fields
    {
        field(1; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(2; "Timetable Line No."; Integer)
        {
            Caption = 'Timetable Line No.';
        }
        field(3; "Teacher No."; Code[20])
        {
            Caption = 'Teacher No.';
            TableRelation = Teacher."No.";

            trigger OnValidate()
            begin
                if rTeacher.Get("Teacher No.") then begin
                    "Teacher Name" := rTeacher.Name;
                    UpdateFullName("Teacher No.");

                end else
                    "Teacher Name" := '';
            end;
        }
        field(4; "Teacher Name"; Text[191])
        {
            Caption = 'Teacher Name';
        }
        field(5; "Week Day"; Option)
        {
            Caption = 'Week Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(6; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code";
        }
        field(7; Lecture; Boolean)
        {
            Caption = 'Lecture';
        }
        field(9; "Start Hour"; Time)
        {
            Caption = 'Start Hour';
        }
        field(10; "End Hour"; Time)
        {
            Caption = 'End Hour';
        }
        field(11; Duration; Decimal)
        {
            Caption = 'Duration';
        }
        field(12; "Lecture Status"; Option)
        {
            Caption = 'Lecture Status';
            OptionCaption = 'Started,Reschudeled,Summary';
            OptionMembers = Started,Reschudeled,Summary;

            trigger OnValidate()
            begin
                if ("Lecture Status" = "Lecture Status"::Started) or ("Lecture Status" = "Lecture Status"::Summary) then
                    Lecture := true
                else
                    Lecture := false;
            end;
        }
        field(13; "Lecture Type"; Option)
        {
            Caption = 'Lecture Type';
            OptionCaption = 'Theoretical,Theoretical and Practical,Simulated Praticals';
            OptionMembers = ,"Teórica","Prática";
        }
        field(14; "Filter Period"; Date)
        {
            Caption = 'Filter Period';
        }
        field(15; "Responsibility Center"; Code[10])
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
        field(16; "Type Subject"; Option)
        {
            Caption = 'Type Subject';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non lective Component",Other;
        }
        field(17; Times; Option)
        {
            Caption = 'Time';
            OptionCaption = '1º Time,2º Time,3º Time,4º Time,5º Time,6º Time,7º Time,8º Time,9º Time,Not Assigned';
            OptionMembers = "1º Time","2º Time","3º Time","4º Time","5º Time","6º Time","7º Time","8º Time","9º Time","Not Assigned";
        }
        field(20; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
        field(60; Meeting; Option)
        {
            Caption = 'Meeting';
            OptionCaption = ' ,Class,Department,Head Department,Level';
            OptionMembers = " ",Class,Department,"Head Department",Level;

            trigger OnValidate()
            var
                rSubjectsGroup: Record "Subjects Group";
                rTeacherTimetableLines: Record "Teacher Timetable Lines";
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
                l_Teacher: Record Teacher;
                varNLinha: Integer;
            begin
            end;
        }
        field(61; Target; Code[20])
        {
            Caption = 'Target';
            TableRelation = IF (Target = CONST('CLASS')) Class.Class
            ELSE
            IF (Target = CONST('DEPARTMENT')) "Subjects Group".Code WHERE(Type = CONST(Subject));
        }
        field(62; Level; Option)
        {
            Caption = 'Levels';
            OptionCaption = ' ,Pre-school,1º Cycle,2º Cycle,3º Cycle,Secondary';
            OptionMembers = " ","Pre school","1º Cycle","2º Cycle","3º Cycle",Secondary;

            trigger OnValidate()
            var
                recTeacherClass: Record "Teacher Class";
                rTeacherTimetableLines: Record "Teacher Timetable Lines";
                rTeacherTimetableLines2: Record "Teacher Timetable Lines";
                rStuctureEduCountry: Record "Structure Education Country";
                varNLinha: Integer;
                l_Teacher: Record Teacher;
            begin
            end;
        }
        field(106; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(108; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(109; Subject; Code[10])
        {
            Caption = 'Subject';
            TableRelation = IF ("Type Subject" = FILTER(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE
            IF ("Type Subject" = FILTER("Non lective Component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF ("Type Subject" = FILTER(Other)) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

            trigger OnLookup()
            var
                recSubject: Record Subjects;
            begin
                recSubject.Reset;
                recSubject.SetRange(Type, "Type Subject");
                if recSubject.Find('-') then begin
                    if "Type Subject" = "Type Subject"::Subject then
                        if PAGE.RunModal(PAGE::Subjects, recSubject) = ACTION::LookupCancel then
                            Validate(Subject, recSubject.Code);
                    if "Type Subject" = "Type Subject"::"Non lective Component" then
                        if PAGE.RunModal(PAGE::"Non lective component List", recSubject) = ACTION::LookupCancel then
                            Validate(Subject, recSubject.Code);
                    if "Type Subject" = "Type Subject"::Other then
                        if PAGE.RunModal(PAGE::"Non Scholar hours", recSubject) = ACTION::LookupCancel then
                            Validate(Subject, recSubject.Code);
                end;
            end;
        }
        field(117; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(120; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
    }

    keys
    {
        key(Key1; "Timetable Code", "Timetable Line No.", "Filter Period", "Teacher No.", Class, Subject)
        {
            Clustered = true;
        }
        key(Key2; "Filter Period", "Start Hour", "End Hour")
        {
        }
        key(Key3; "Week Day")
        {
        }
        key(Key4; "Start Hour")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if "Lecture Status" = "Lecture Status"::Summary then
            Error(Text001);

        if "Type Subject" = "Type Subject"::Subject then
            Error(Text003);

        rAbsence.Reset;
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Teacher);
        rAbsence.SetRange("Timetable Code", "Timetable Code");
        rAbsence.SetRange(Day, "Filter Period");
        if rAbsence.Find('-') then
            Error(Text002, "Filter Period");
    end;

    trigger OnInsert()
    begin
        if rTimetable.Get("Timetable Code") then
            "School Year" := rTimetable."School Year";

        rCalendar.Reset;
        rCalendar.SetRange("Timetable Code", "Timetable Code");
        rCalendar.SetRange("School Year", "School Year");
        rCalendar.SetRange("Line No.", "Timetable Line No.");
        if rCalendar.Find('-') then begin
            "Filter Period" := rCalendar."Filter Period";
            "Start Hour" := rCalendar."Start Hour";
            "End Hour" := rCalendar."End Hour";
        end;
    end;

    var
        rTeacher: Record Teacher;
        rCalendar: Record Calendar;
        Text001: Label 'Lecture is already summarized. Unable to eliminate registration.';
        rTimetable: Record Timetable;
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rAbsence: Record Absence;
        Text002: Label 'Cannot delete the line,there are already teachers with absences for the day %1.';
        Text003: Label 'Cannot delete the line, use the calendar to the class %1.';

    //[Scope('OnPrem')]
    procedure UpdateFullName(pTeacher: Code[20])
    var
        rEduConfiguration: Record "Edu. Configuration";
        l_Teacher: Record Teacher;
    begin
        if l_Teacher.Get(pTeacher) then begin

            if rEduConfiguration.Get then begin
                if rEduConfiguration."Full Name syntax" = 0 then begin
                    if l_Teacher."Last Name 2" <> '' then
                        "Teacher Name" := l_Teacher."Last Name" + ' ' + l_Teacher."Last Name 2" + ', ' + l_Teacher.Name
                    else
                        "Teacher Name" := l_Teacher."Last Name" + ', ' + l_Teacher.Name;
                end else begin
                    if l_Teacher."Last Name 2" <> '' then
                        "Teacher Name" := l_Teacher.Name + ' ' + l_Teacher."Last Name 2" + ' ' + l_Teacher."Last Name"
                    else
                        "Teacher Name" := l_Teacher.Name + ' ' + l_Teacher."Last Name";
                end;
            end;
        end;
    end;
}

