table 52852 "WEB Absence"
{
    Caption = 'WEB Absences ';
    Permissions = TableData Absence = rimd,
                  TableData "Transport & Lunch Entry " = rimd;

    fields
    {
        field(1; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            TableRelation = Timetable."Timetable Code";
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Study Plan"; Code[20])
        {
            Caption = 'Study Plan';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(4; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Subject; Code[10])
        {
            Caption = 'Subject';
            TableRelation = IF ("Type Subject" = FILTER(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE IF ("Type Subject" = FILTER("Non scholar component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE IF ("Type Subject" = FILTER("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));
        }
        field(8; "Student/Teacher Code No."; Code[20])
        {
            Caption = 'Student/Teacher Code No.';
            TableRelation = IF ("Student/Teacher" = FILTER(Student)) Students."No."
            ELSE IF ("Student/Teacher" = FILTER(Teacher)) Teacher."No.";

            trigger OnLookup()
            var
                rRegistrationClass: Record "Registration Class";
                rStudents: Record Students;
                rStudentsTEMP: Record Students temporary;
                rRegistrationSubjects: Record "Registration Subjects";
                rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                rStudentsNLHours: Record "Students Non Lective Hours";
                rDate: Record Date;
                rRegistration: Record Registration;
            begin
            end;
        }
        field(9; "Class No."; Integer)
        {
            BlankZero = true;
            Caption = 'Class No.';
        }
        field(10; "Student Name"; Text[128])
        {
            Caption = 'Student Name';
            Editable = false;
        }
        field(13; "Absence Status"; Option)
        {
            Caption = 'Absence Status';
            OptionCaption = 'Justified,Unjustified,Justification';
            OptionMembers = Justified,Unjustified,Justification;
        }
        field(15; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(16; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(17; "Creation User"; Code[20])
        {
            Caption = 'Creation User';
        }
        field(18; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
        }
        field(19; "Modified User"; Code[20])
        {
            Caption = 'Modified User';
        }
        field(20; "Incidence Type"; Option)
        {
            Caption = 'Incidence Type';
            OptionCaption = 'Default,Absence';
            OptionMembers = Default,Absence;
        }
        field(21; "Incidence Code"; Code[20])
        {
            Caption = 'Incidence Code';
            TableRelation = "Incidence Type"."Incidence Code" WHERE(Category = FIELD(Category),
                                                                     "Incidence Type" = FIELD("Incidence Type"),
                                                                     "Absence Status" = FIELD("Absence Status"));
        }
        field(22; "Absence Type"; Option)
        {
            Caption = 'Absence Type';
            OptionCaption = 'Lecture,Daily';
            OptionMembers = Lecture,Daily;
        }
        field(23; Day; Date)
        {
            Caption = 'Day';
        }
        field(24; "Line No. Timetable"; Integer)
        {
            Caption = 'Line No. Timetable';
        }
        field(25; "Incidence Description"; Text[50])
        {
            Caption = 'Incidence Description';
        }
        field(26; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(27; "Justified Code"; Code[20])
        {
            Caption = 'Justified Code';
            TableRelation = "Incidence Type"."Justification Code" WHERE(Category = FIELD(Category),
                                                                         "Incidence Type" = FIELD("Incidence Type"));
        }
        field(28; "Justified Description"; Text[50])
        {
            Caption = 'Justified Description';
            Editable = false;
        }
        field(29; "Subcategory Code"; Code[20])
        {
            Caption = 'Subcategory Code';
            TableRelation = "Sub Type"."Subcategory Code" WHERE(Category = FIELD("Incidence Type"));
        }
        field(30; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';
        }
        field(31; "Absence Hours"; Time)
        {
            Caption = 'Absence Hours';
        }
        field(32; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(34; "Student/Teacher"; Option)
        {
            Caption = 'Student/Teacher';
            OptionCaption = 'Student,Teacher';
            OptionMembers = Student,Teacher;
        }
        field(35; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = 'Class,Cantine,BUS,Schoolyard,Extra-scholar,Teacher';
            OptionMembers = Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;
        }
        field(36; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(37; Delay; Boolean)
        {
            Caption = 'Delay';
        }
        field(40; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(41; "Type Subject"; Option)
        {
            Caption = 'Type Subject';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non scholar component","Non scholar hours";
        }
        field(100; "Action Type"; Option)
        {
            Caption = 'Action Type';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
        field(101; "Action Type 2"; Option)
        {
            Caption = 'Action Type 2';
            OptionCaption = ' ,Insert,Update,Delete';
            OptionMembers = " ",Insert,Update,Delete;
        }
    }

    keys
    {
        key(Key1; "Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Timetable Code", "School Year", "Study Plan", Class, "Absence Type", "Student/Teacher Code No.")
        {
        }
        key(Key3; "School Year", "Student/Teacher Code No.", Subject, "Subcategory Code")
        {
        }
        key(Key4; "Timetable Code", Day, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        l_text00001: Label 'Active';
        l_text00002: Label 'Closing';
    begin
    end;

    var
        rStudent: Record Students;
        rAbsence: Record Absence;
        rIncidenceType: Record "Incidence Type";
        rSchoolYear: Record "School Year";
        rClass: Record Class;
        Text00001: Label 'Student %1 already has an absence type %2 scheduled for the day %3.';
        Text00002: Label 'You can only assign absences for the School Year status %1 and %2.';
        Text00003: Label 'Student %1 already has an absence scheduled for day %2.';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text00005: Label 'Teacher %1 already has an absence scheduled for the day %2.';
        rRemarks: Record Remarks;
        Text0006: Label 'Do you wish to delete the absence for the %1 %2 %3?';
        Text0007: Label 'This absence is already justified for the %1 %2 %3! Do you wish to delete?';
        Text0008: Label 'Operation interrupted by the user.';
        Text0009: Label 'The student does not belong to this class %1 or subject %2.';
        rCalendar: Record Calendar;
        Text0010: Label 'Could not delete, the lecture status is %1.';
        Text0011: Label 'There is no Incidence Type within the filter.';
        Text00006: Label 'Teacher %1 already has an absence type %2 scheduled for the day %3.';
        rVehicleEntry: Record "Transport & Lunch Entry ";
        Text00007: Label 'The student is defined as absent for this non teaching hour.';
}

