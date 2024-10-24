table 52849 Absence
{
    Caption = 'Absences';
    Permissions = TableData Absence = rimd,
                  TableData "Student Subjects Entry" = rimd,
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
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
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
            ELSE
            IF ("Type Subject" = FILTER("Non scholar component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF ("Type Subject" = FILTER("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));
        }
        field(8; "Student/Teacher Code No."; Code[20])
        {
            Caption = 'Student/Teacher Code No.';
            TableRelation = IF ("Student/Teacher" = FILTER(Student)) Students."No."
            ELSE
            IF ("Student/Teacher" = FILTER(Teacher)) Teacher."No.";

            trigger OnLookup()
            var
                rRegistrationClass: Record "Registration Class";
                rStudents: Record Students;
                rStudentsTEMP: Record Students temporary;
                rRegistrationSubjects: Record "Registration Subjects";
                rStudentSubjectsEntry: Record "Student Subjects Entry";
                rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
                rStudentsNLHours: Record "Students Non Lective Hours";
                rDate: Record Date;
                rRegistration: Record Registration;
            begin
                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    if Category = Category::Class then begin
                        Clear(rStudentsTEMP);
                        rRegistrationSubjects.Reset;
                        rRegistrationSubjects.SetRange("School Year", "School Year");
                        rRegistrationSubjects.SetRange("Study Plan Code", "Study Plan");
                        rRegistrationSubjects.SetRange("Subjects Code", Subject);
                        rRegistrationSubjects.SetRange(Class, Class);
                        rRegistrationSubjects.SetFilter(Status, '<>0');
                        rRegistrationSubjects.SetRange("Sub-subject", false);
                        rRegistrationSubjects.SetRange(Turn, Turn);
                        rRegistrationSubjects.CalcFields("Sub-subject");
                        if rRegistrationSubjects.Find('-') then begin
                            repeat
                                rStudentSubjectsEntry.Reset;
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."School Year", "School Year");
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Study Plan Code", "Study Plan");
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Subjects Code", Subject);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Class, Class);
                                rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry.Status, '<>%1', 0);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Turn, Turn);
                                rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry."Status Date", '<=%1', Day);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Student Code No.", rRegistrationSubjects."Student Code No.");
                                if (rStudentSubjectsEntry.FindLast) and (rStudentSubjectsEntry.Status = rStudentSubjectsEntry.Status::Subscribed) then begin
                                    if rStudents.Get(rRegistrationSubjects."Student Code No.") then begin
                                        rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                        rStudentsTEMP.Init;
                                        rStudentsTEMP.TransferFields(rStudents);
                                        rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                        rStudentsTEMP.Insert;
                                    end;
                                end;
                            until rRegistrationSubjects.Next = 0;
                        end;
                        rRegistrationSubjects.Reset;
                        rRegistrationSubjects.SetRange("School Year", "School Year");
                        rRegistrationSubjects.SetRange("Study Plan Code", "Study Plan");
                        rRegistrationSubjects.SetRange("Subjects Code", Subject);
                        rRegistrationSubjects.SetRange(Class, Class);
                        rRegistrationSubjects.SetFilter(Status, '<>0');
                        rRegistrationSubjects.SetRange("Sub-subject", true);
                        rRegistrationSubjects.SetRange(Turn, Turn);
                        rRegistrationSubjects.CalcFields("Sub-subject");
                        if rRegistrationSubjects.Find('-') then begin
                            repeat
                                rStudentSubjectsEntry.Reset;
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."School Year", "School Year");
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Study Plan Code", "Study Plan");
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Subjects Code", Subject);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Class, Class);
                                rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry.Status, '<>%1', 0);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Turn, Turn);
                                rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry."Status Date", '<=%1', Day);
                                rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Student Code No.", rRegistrationSubjects."Student Code No.");
                                if (rStudentSubjectsEntry.FindLast) and (rStudentSubjectsEntry.Status = rStudentSubjectsEntry.Status::Subscribed) then begin
                                    if rRegistrationSubjects."Sub-subjects for assess. only" then begin
                                        if rStudents.Get(rRegistrationSubjects."Student Code No.") then begin
                                            rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                            rStudentsTEMP.Init;
                                            rStudentsTEMP.TransferFields(rStudents);
                                            rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                            rStudentsTEMP.Insert;
                                        end;
                                    end else begin
                                        rStudentSubSubjectsPlan.Reset;
                                        rStudentSubSubjectsPlan.SetRange("School Year", "School Year");
                                        rStudentSubSubjectsPlan.SetRange("Subject Code", Subject);
                                        rStudentSubSubjectsPlan.SetRange("Student Code No.", rRegistrationSubjects."Student Code No.");
                                        rStudentSubSubjectsPlan.SetRange("Sub-Subject Code", "Sub-Subject Code");
                                        rStudentSubSubjectsPlan.SetRange(Turn, Turn);
                                        if rStudentSubSubjectsPlan.Find('-') then begin
                                            if rStudents.Get(rStudentSubSubjectsPlan."Student Code No.") then begin
                                                rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                                rStudentsTEMP.Init;
                                                rStudentsTEMP.TransferFields(rStudents);
                                                rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                                rStudentsTEMP.Insert;
                                            end;
                                        end;
                                    end;
                                end;
                            until rRegistrationSubjects.Next = 0;
                        end;

                        rStudentsTEMP.SetCurrentKey("Temp Class No.");
                        if PAGE.RunModal(0, rStudentsTEMP) = ACTION::LookupOK then begin
                            "Student/Teacher Code No." := rStudentsTEMP."No.";
                            ValidateStudentNo;
                        end;
                    end;
                    if Category = Category::Schoolyard then begin
                        rRegistration.Reset;
                        rRegistration.SetRange("School Year", "School Year");
                        rRegistration.SetRange(Class, Class);
                        rRegistration.SetRange(Type, Type);
                        if Type = Type::Simple then
                            rRegistration.SetRange("Study Plan Code", "Study Plan");
                        if Type = Type::Multi then
                            rRegistration.SetRange(Course, "Study Plan");
                        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                        rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                        if rRegistration.Find('-') then begin
                            repeat
                                if rStudents.Get(rRegistration."Student Code No.") then begin
                                    rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                    rStudentsTEMP.Init;
                                    rStudentsTEMP.TransferFields(rStudents);
                                    rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                    rStudentsTEMP.Insert;
                                end;
                            until rRegistration.Next = 0;
                        end;
                        rStudentsTEMP.SetCurrentKey("Temp Class No.");
                        if PAGE.RunModal(0, rStudentsTEMP) = ACTION::LookupOK then begin
                            "Student/Teacher Code No." := rStudentsTEMP."No.";
                            ValidateStudentNo;
                        end;
                    end;
                    if Category = Category::Cantine then begin
                        rDate.Reset;
                        rDate.SetRange("Period Type", rDate."Period Type"::Date);
                        rDate.SetRange("Period Start", Day);
                        if rDate.FindFirst then;

                        rRegistration.Reset;
                        rRegistration.SetRange("School Year", "School Year");
                        rRegistration.SetRange(Class, Class);
                        rRegistration.SetRange(Type, Type);
                        if Type = Type::Simple then
                            rRegistration.SetRange("Study Plan Code", "Study Plan");
                        if Type = Type::Multi then
                            rRegistration.SetRange(Course, "Study Plan");
                        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                        rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                        if rRegistration.Find('-') then begin
                            repeat
                                rStudentsNLHours.Reset;
                                rStudentsNLHours.SetRange("School Year", "School Year");
                                rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                                rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                                rStudentsNLHours.SetRange(Lunch, true);
                                if rStudentsNLHours.FindFirst then begin
                                    if rStudentsNLHours.FindFirst then begin
                                        rVehicleEntry.Reset;
                                        rVehicleEntry.SetRange("School Year", "School Year");
                                        rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                                        rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Lunch");
                                        rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                                        rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                                        rVehicleEntry.SetRange("Lunch Cancelled", false);
                                        if not rVehicleEntry.FindFirst then begin
                                            if rStudents.Get(rRegistration."Student Code No.") then begin
                                                rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                                rStudentsTEMP.Init;
                                                rStudentsTEMP.TransferFields(rStudents);
                                                rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                                rStudentsTEMP.Insert;
                                            end;
                                        end;
                                    end;
                                end;
                            until rRegistration.Next = 0;
                        end;
                        rStudentsTEMP.SetCurrentKey("Temp Class No.");
                        if PAGE.RunModal(0, rStudentsTEMP) = ACTION::LookupOK then begin
                            "Student/Teacher Code No." := rStudentsTEMP."No.";
                            "Student Name" := rStudentsTEMP.Name;
                            ValidateStudentNo;
                        end;
                    end;
                    if Category = Category::BUS then begin
                        rDate.Reset;
                        rDate.SetRange("Period Type", rDate."Period Type"::Date);
                        rDate.SetRange("Period Start", Day);
                        if rDate.FindFirst then;

                        if rCalendar.Get("Timetable Code", "School Year", "Study Plan", Class, "Line No. Timetable") then;
                        rRegistration.Reset;
                        rRegistration.SetRange("School Year", "School Year");
                        rRegistration.SetRange(Class, Class);
                        rRegistration.SetRange(Type, Type);
                        if Type = Type::Simple then
                            rRegistration.SetRange("Study Plan Code", "Study Plan");
                        if Type = Type::Multi then
                            rRegistration.SetRange(Course, "Study Plan");
                        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                        rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                        if rRegistration.Find('-') then begin
                            repeat
                                rStudentsNLHours.Reset;
                                rStudentsNLHours.SetRange("School Year", "School Year");
                                rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                                rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                                rStudentsNLHours.SetRange("Estimated Colect Hour", rCalendar."Start Hour", rCalendar."End Hour");
                                if rStudentsNLHours.FindFirst then begin
                                    rVehicleEntry.Reset;
                                    rVehicleEntry.SetRange("School Year", "School Year");
                                    rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                                    rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
                                    rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                                    rVehicleEntry.SetRange("Collect Time", rCalendar."Start Hour", rCalendar."End Hour");
                                    rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                                    rVehicleEntry.SetRange("Transport Collect Cancelled", false);
                                    rVehicleEntry.SetFilter("Transport No.", '<>%1', '');
                                    if not rVehicleEntry.FindFirst then begin
                                        if rStudents.Get(rRegistration."Student Code No.") then begin
                                            rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                            rStudentsTEMP.Init;
                                            rStudentsTEMP.TransferFields(rStudents);
                                            rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                            rStudentsTEMP.Insert;
                                        end;
                                    end;
                                end;
                                rStudentsNLHours.Reset;
                                rStudentsNLHours.SetRange("School Year", "School Year");
                                rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                                rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                                rStudentsNLHours.SetRange("Estimated Deliver Hour", rCalendar."Start Hour", rCalendar."End Hour");
                                if rStudentsNLHours.FindFirst then begin
                                    rVehicleEntry.Reset;
                                    rVehicleEntry.SetRange("School Year", "School Year");
                                    rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                                    rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
                                    rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                                    rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                                    rVehicleEntry.SetRange("Deliver Time", rCalendar."Start Hour", rCalendar."End Hour");
                                    rVehicleEntry.SetRange("Transport Deliver Cancelled", false);
                                    rVehicleEntry.SetFilter(rVehicleEntry."Deliver Transport", '<>%1', '');
                                    if not rVehicleEntry.FindFirst then begin
                                        if rStudents.Get(rRegistration."Student Code No.") then begin
                                            rStudents.CalcFields(rStudents.Class, rStudents."Class No.");
                                            rStudentsTEMP.Init;
                                            rStudentsTEMP.TransferFields(rStudents);
                                            rStudentsTEMP."Temp Class No." := rStudentsTEMP."Class No.";
                                            rStudentsTEMP.Insert;
                                        end;
                                    end;
                                end;


                            until rRegistration.Next = 0;
                        end;
                        rStudentsTEMP.SetCurrentKey("Temp Class No.");
                        if PAGE.RunModal(0, rStudentsTEMP) = ACTION::LookupOK then begin
                            "Student/Teacher Code No." := rStudentsTEMP."No.";
                            ValidateStudentNo;
                        end;

                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    if rStudent.Get("Student/Teacher Code No.") then begin
                        "Student Name" := rStudent.Name;
                        "Full Name" := rStudent."Full Name";
                    end;
                end;
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

            trigger OnValidate()
            begin

                if (xRec."Absence Status" <> "Absence Status") and ("Absence Status" = "Absence Status"::Unjustified) then
                    Validate("Justified Code", '');

                // Limpar a descrição.
                if "Justified Code" = '' then
                    "Justified Description" := '';
            end;
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

            trigger OnLookup()
            begin
                if rCalendar.Get("Timetable Code", "School Year", "Study Plan", Class, "Line No. Timetable") then;

                rIncidenceType.Reset;
                rIncidenceType.SetRange("School Year", "School Year");
                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    if rClass.Get(Class, "School Year") then
                        rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
                end;
                rIncidenceType.SetRange("Incidence Type", "Incidence Type");
                rIncidenceType.SetRange("Absence Status", 0, 1);
                rIncidenceType.SetRange(rIncidenceType.Category, Category);
                if rIncidenceType.Find('-') then begin
                    if PAGE.RunModal(PAGE::"Incidence List", rIncidenceType) = ACTION::LookupOK then begin
                        if rCalendar."Lecture Status" <> rCalendar."Lecture Status"::Summary then begin
                            validateIncidenceCode;
                            "Incidence Code" := rIncidenceType."Incidence Code";
                            "Incidence Description" := rIncidenceType.Description;
                            "Absence Status" := rIncidenceType."Absence Status";
                            "Subcategory Code" := rIncidenceType."Subcategory Code";
                            Delay := rIncidenceType.Delay;

                        end;
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                if "Incidence Code" <> '' then begin
                    rIncidenceType.Reset;
                    rIncidenceType.SetRange("School Year", "School Year");
                    if "Student/Teacher" = "Student/Teacher"::Student then
                        if rClass.Get(Class, "School Year") then
                            rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");

                    rIncidenceType.SetRange("Incidence Code", "Incidence Code");
                    rIncidenceType.SetRange("Incidence Type", "Incidence Type");
                    rIncidenceType.SetRange(Category, Category);
                    rIncidenceType.SetRange(rIncidenceType."Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                    if rIncidenceType.FindFirst then begin
                        "Incidence Description" := rIncidenceType.Description;
                        "Absence Status" := rIncidenceType."Absence Status";
                        "Subcategory Code" := rIncidenceType."Subcategory Code";
                        Delay := rIncidenceType.Delay;
                    end else
                        Error(Text0011);
                end else begin
                    "Incidence Description" := '';
                    Observations := '';
                    "Absence Status" := "Absence Status"::Unjustified;
                    "Subcategory Code" := '';
                end;

                validateIncidenceCode;
            end;
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

            trigger OnLookup()
            begin

                if rClass.Get(Class, "School Year") then;
                rIncidenceType.Reset;
                rIncidenceType.SetRange("School Year", "School Year");
                if "Student/Teacher" = "Student/Teacher"::Student then
                    rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");
                rIncidenceType.SetRange("Absence Status", "Absence Status"::Justification);
                rIncidenceType.SetRange(Category, Category);
                rIncidenceType.SetRange("Responsibility Center", "Responsibility Center");
                rIncidenceType.SetRange("Incidence Code", "Incidence Code");

                if rIncidenceType.Find('-') then begin
                    if PAGE.RunModal(PAGE::"Incidence List", rIncidenceType) = ACTION::LookupOK then
                        Validate("Justified Code", rIncidenceType."Justification Code");
                end;
            end;

            trigger OnValidate()
            begin
                if ("Justified Code" <> '') then begin
                    if rClass.Get(Class, "School Year") then;
                    rIncidenceType.Reset;
                    rIncidenceType.SetRange("School Year", "School Year");

                    if "Student/Teacher" = "Student/Teacher"::Student then
                        rIncidenceType.SetRange("Schooling Year", rClass."Schooling Year");

                    rIncidenceType.SetRange("Justification Code", "Justified Code");
                    rIncidenceType.SetRange("Absence Status", rIncidenceType."Absence Status"::Justification);
                    rIncidenceType.SetRange(Category, Category);
                    rIncidenceType.SetRange("Responsibility Center", "Responsibility Center");
                    rIncidenceType.SetRange("Incidence Code", "Incidence Code");
                    if rIncidenceType.Find('-') then begin
                        "Justified Description" := rIncidenceType.Description;
                        "Absence Status" := rIncidenceType."Absence Status"::Justification;
                    end else
                        "Justified Code" := '';
                end else begin
                    "Justified Description" := '';
                    if "Incidence Code" <> '' then
                        "Absence Status" := "Absence Status"::Unjustified;
                end;
            end;
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

            trigger OnValidate()
            begin

                if not cUserEducation.CheckRespCenterEducation("Responsibility Center") then
                    Error(
                      Text0004,
                      RespCenter.TableCaption, cUserEducation.GetEducationFilter(UserId));
            end;
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
        field(49; "Results in loss of pay"; Boolean)
        {
            Caption = 'Results in loss of pay';
            Description = 'Ligação com o RH';

            trigger OnValidate()
            begin
                if "Absence Status" = "Absence Status"::Unjustified then
                    Error(Text0013);
            end;
        }
        field(50; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'Significa que esta falta já passou para o RH';
        }
        field(51; Qtd; Integer)
        {
            Caption = 'Qty.';
            Description = 'Qtd de tempos de falta';
        }
        field(60; "Full Name"; Text[191])
        {
            Caption = 'Full Name';
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
        key(Key5; "School Year", "Student/Teacher Code No.", "Absence Type", "Absence Status")
        {
        }
        key(Key6; "School Year", "Student/Teacher Code No.", "Absence Type", Day)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Student/Teacher" = "Student/Teacher"::Student then begin

            if rCalendar.Get("Timetable Code", "School Year", "Study Plan", Class, "Line No. Timetable") then begin
                if rCalendar."Lecture Status" = rCalendar."Lecture Status"::Summary then
                    Error(Text0010, Format(rCalendar."Lecture Status"));
            end;


        end;

        if "Absence Status" = "Absence Status"::Unjustified then begin
            if Confirm(Text0006, false, Format("Student/Teacher"), "Student/Teacher Code No.", "Student Name") then begin
                rRemarks.Reset;
                rRemarks.SetRange("School Year", "School Year");
                rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                rRemarks.SetRange("Student/Teacher", "Student/Teacher");
                rRemarks.SetFilter(Subject, Subject);
                rRemarks.SetFilter("Sub-subject", "Sub-Subject Code");
                rRemarks.SetRange("Absence Status", rRemarks."Absence Status"::Unjustified);
                rRemarks.SetRange(Day, Day);
                rRemarks.SetRange("Student/Teacher Code No.", "Student/Teacher Code No.");
                rRemarks.SetRange("Calendar Line", "Line No.");
                rRemarks.SetRange("Responsibility Center", "Responsibility Center");
                rRemarks.DeleteAll;

            end else
                Error(Text0008);
        end else begin
            if Confirm(Text0007, false, Format("Student/Teacher"), "Student/Teacher Code No.", "Student Name") then begin
                rRemarks.Reset;
                rRemarks.SetRange("School Year", "School Year");
                rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Absence);
                rRemarks.SetRange("Student/Teacher", "Student/Teacher");
                rRemarks.SetFilter(Subject, Subject);
                rRemarks.SetFilter("Sub-subject", "Sub-Subject Code");
                rRemarks.SetRange("Absence Status", rRemarks."Absence Status"::Unjustified);
                rRemarks.SetRange(Day, Day);
                rRemarks.SetRange("Student/Teacher Code No.", "Student/Teacher Code No.");
                rRemarks.SetRange("Calendar Line", "Line No.");
                rRemarks.SetRange("Responsibility Center", "Responsibility Center");
                rRemarks.DeleteAll;
            end else
                Error(Text0008);
        end;

        ValidateStudentAbsences(3);

        //Delete Incidences in WEB
        if Category <> Category::Teacher then
            CInsertNAVWebCalendar.DeleteAbsence(Rec, xRec);
    end;

    trigger OnInsert()
    var
        l_text00001: Label 'Active';
        l_text00002: Label 'Closing';
        l_Absence: Record Absence;
    begin
        "Creation Date" := Today;
        "Creation User" := UserId;

        if ("Absence Type" = "Absence Type"::Daily) and ("Incidence Type" = "Incidence Type"::Absence)
          and (Category = Category::Class) then
            Subject := '';

        rSchoolYear.Reset;
        rSchoolYear.SetRange("School Year", "School Year");
        rSchoolYear.SetRange(Status, rSchoolYear.Status::Closed);
        if rSchoolYear.FindFirst then
            Error(Text00002, l_text00001, l_text00002);

        validateIncidenceCode;

        rClass.Reset;
        rClass.SetRange(rClass."School Year", "School Year");
        rClass.SetRange(rClass.Class, Class);
        if rClass.FindFirst then
            "Schooling Year" := rClass."Schooling Year";

        ValidateStudentAbsences(1);

        //Insert Incidences in WEB
        if Category <> Category::Teacher then
            CInsertNAVWebCalendar.InsertModAbsence(Rec, xRec);


        if Category = Category::Teacher then begin
            if Qtd = 0 then Qtd := 1;
            if "Absence Status" = "Absence Status"::Unjustified then
                "Results in loss of pay" := true;
            if "Absence Status" = "Absence Status"::Justified then
                "Results in loss of pay" := false;

            l_Absence.Reset;
            l_Absence.SetRange(l_Absence."School Year", "School Year");
            l_Absence.SetRange(l_Absence."Student/Teacher", l_Absence."Student/Teacher"::Teacher);
            l_Absence.SetRange(l_Absence."Student/Teacher Code No.", "Student/Teacher Code No.");
            l_Absence.SetRange(l_Absence."Incidence Type", "Incidence Type");
            l_Absence.SetRange(l_Absence.Day, Day);
            l_Absence.SetRange(l_Absence."Absence Type", l_Absence."Absence Type"::Daily);
            if l_Absence.FindFirst then
                Error(Text00005, "Student/Teacher Code No.", Day);

        end;
    end;

    trigger OnModify()
    begin
        "Modified Date" := Today;
        "Modified User" := UserId;
        ValidateStudentAbsences(2);

        //Update Incidences in WEB
        if Category <> Category::Teacher then
            CInsertNAVWebCalendar.InsertModAbsence(Rec, xRec);
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
        CInsertNAVWebCalendar: Codeunit InsertNAVWebCalendar;
        Text0012: Label 'The student does not belong to this class %1 or any sub-subject of the subject %2.';
        Text0013: Label 'This field cannot be removed because the absence type is Unjustified.';


    procedure CreateAbsences(pSchoolYear: Code[10]; pStudyPlan: Code[20]; pClass: Code[20])
    var
        rClass: Record Class;
    begin
        rClass.Reset;
        rClass.SetRange("School Year", pSchoolYear);
        rClass.SetRange("Study Plan Code", pStudyPlan);
        rClass.SetRange(Class, pClass);

        /*
        fAbsencesWizard.SETTABLEVIEW(rClass);
        fAbsencesWizard.SetFormFilter("Timetable Code");
        fAbsencesWizard.RUN;
        */

    end;


    procedure ValidateStudentAbsences(pInsertModifyDelete: Integer)
    var
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rRegistrationClass: Record "Registration Class";
        rRegisSubjects: Record "Registration Subjects";
        Text90001: Label 'Warning Education heads and advise students to evidence of recovery.';
        rTest: Record Test;
        vCounterInjus: Integer;
        vCounterTot: Integer;
        Text90002: Label 'Advise students to recovery Test.';
    begin

        rRegistrationClass.Reset;
        rRegistrationClass.SetRange("Student Code No.", "Student/Teacher Code No.");
        rRegistrationClass.SetRange(rRegistrationClass."School Year", "School Year");
        rRegistrationClass.SetRange(rRegistrationClass.Class, Class);
        if rRegistrationClass.Find('-') then begin

            Clear(vCounterInjus);
            Clear(vCounterTot);
            vCounterInjus := CalFaltas("School Year", rRegistrationClass."Schooling Year", Class,
                                  "Student/Teacher Code No.", Subject, Today, 1, 0D, Rec, pInsertModifyDelete);

            vCounterTot := CalFaltas("School Year", "Schooling Year", Class,
                                  "Student/Teacher Code No.", Subject, Today, 0, 0D, Rec, pInsertModifyDelete);

            if "Absence Type" = "Absence Type"::Daily then begin
                //1º Ciclo
                //----------------------
                rStudyPlanHeader.Reset;
                if rStudyPlanHeader.Get("Study Plan") then begin
                    rRegistrationClass."Absence Option" := 0;
                    rRegistrationClass."Education Head Alert" := false;
                    rRegistrationClass."Recover Test" := false;

                    if (vCounterInjus >= (Round((rStudyPlanHeader."Maximum Unjustified Absence" / 2), 1, '='))) then begin
                        rRegistrationClass."Absence Option" := rRegistrationClass."Absence Option"::"Half Absence";
                        rRegistrationClass."Education Head Alert" := true;
                    end;
                    if (vCounterTot >= (Round((rStudyPlanHeader."Maximum Total Absence" / 2), 1, '='))) then begin
                        rRegistrationClass."Absence Option" := rRegistrationClass."Absence Option"::"Half Unjustified";
                        rRegistrationClass."Education Head Alert" := true;
                    end;

                    if vCounterInjus = rStudyPlanHeader."Maximum Unjustified Absence" then begin
                        rRegistrationClass."Absence Option" := rRegistrationClass."Absence Option"::"Unjustified Total";
                        rRegistrationClass."Recover Test" := true;
                    end;
                    if vCounterTot = rStudyPlanHeader."Maximum Total Absence" then begin
                        rRegistrationClass."Absence Option" := rRegistrationClass."Absence Option"::Total;
                        rRegistrationClass."Recover Test" := true;

                    end;

                    rTest.Reset;
                    rTest.SetRange(rTest."Test Type", rTest."Test Type"::"Recover Test");
                    rTest.SetRange(rTest."Line Type", rTest."Line Type"::Line);
                    rTest.SetRange(rTest."Student No.", "Student/Teacher Code No.");
                    rTest.SetRange(rTest."School Year", "School Year");
                    rTest.SetRange(rTest."Schooling Year", "Schooling Year");
                    rTest.SetRange(rTest."Subjects Code", Subject);
                    rTest.SetRange(rTest."Absence Option", rRegistrationClass."Absence Option");
                    rTest.SetFilter(rTest."Recover Classif.", '<>%1', '');
                    if not rTest.FindSet then
                        rRegistrationClass.Modify;
                end;

            end else begin
                //Restantes Ciclos
                //-----------------------

                if rRegistrationClass.Type = rRegistrationClass.Type::Simple then begin

                    rStudyPlanLines.Reset;
                    rStudyPlanLines.SetRange(rStudyPlanLines.Code, "Study Plan");
                    rStudyPlanLines.SetRange(rStudyPlanLines."School Year", "School Year");
                    rStudyPlanLines.SetRange(rStudyPlanLines."Subject Code", Subject);
                    if rStudyPlanLines.FindSet then begin
                        Clear(rRegisSubjects);
                        rRegisSubjects.Reset;
                        rRegisSubjects.SetRange(rRegisSubjects."Student Code No.", rRegistrationClass."Student Code No.");
                        rRegisSubjects.SetRange(rRegisSubjects."School Year", rRegistrationClass."School Year");
                        rRegisSubjects.SetRange(rRegisSubjects."Schooling Year", rRegistrationClass."Schooling Year");
                        rRegisSubjects.SetRange(rRegisSubjects."Subjects Code", Subject);
                        if rRegisSubjects.FindSet then begin
                            rRegisSubjects."Absence Option" := 0;
                            rRegisSubjects."Education Head Alert" := false;
                            rRegisSubjects."Recover Test" := false;
                            if (vCounterInjus >= (Round((rStudyPlanLines."Maximum Unjustified Absences" / 2), 1, '='))) then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Half Absence";
                                rRegisSubjects."Education Head Alert" := true;
                            end;
                            if (vCounterTot >= (Round((rStudyPlanLines."Maximum Total Absence" / 2), 1, '='))) then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Half Unjustified";
                                rRegisSubjects."Education Head Alert" := true;
                            end;

                            if vCounterInjus = rStudyPlanLines."Maximum Unjustified Absences" then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Unjustified Total";
                                rRegisSubjects."Recover Test" := true;
                            end;
                            if vCounterTot = rStudyPlanLines."Maximum Total Absence" then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::Total;
                                rRegisSubjects."Recover Test" := true;
                            end;

                            rTest.Reset;
                            rTest.SetRange(rTest."Test Type", rTest."Test Type"::"Recover Test");
                            rTest.SetRange(rTest."Line Type", rTest."Line Type"::Line);
                            rTest.SetRange(rTest."Student No.", "Student/Teacher Code No.");
                            rTest.SetRange(rTest."School Year", "School Year");
                            rTest.SetRange(rTest."Schooling Year", "Schooling Year");
                            rTest.SetRange(rTest."Subjects Code", Subject);
                            rTest.SetRange(rTest."Absence Option", rRegisSubjects."Absence Option");
                            rTest.SetFilter(rTest."Recover Classif.", '<>%1', '');
                            if not rTest.FindSet then
                                rRegisSubjects.Modify;
                        end;
                    end;

                end else begin

                    rCourseLines.Reset;
                    rCourseLines.SetRange(rCourseLines.Code, "Study Plan");
                    rCourseLines.SetRange(rCourseLines."Subject Code", Subject);
                    if rCourseLines.FindSet then begin
                        Clear(rRegisSubjects);
                        rRegisSubjects.Reset;
                        rRegisSubjects.SetRange(rRegisSubjects."Student Code No.", rRegistrationClass."Student Code No.");
                        rRegisSubjects.SetRange(rRegisSubjects."School Year", rRegistrationClass."School Year");
                        rRegisSubjects.SetRange(rRegisSubjects."Schooling Year", rRegistrationClass."Schooling Year");
                        rRegisSubjects.SetRange(rRegisSubjects."Subjects Code", Subject);
                        if rRegisSubjects.FindSet then begin
                            rRegisSubjects."Absence Option" := 0;
                            rRegisSubjects."Education Head Alert" := false;
                            rRegisSubjects."Recover Test" := false;
                            if (vCounterInjus >= (Round((rCourseLines."Maximum Unjustified Absences" / 2), 1, '='))) then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Half Absence";
                                rRegisSubjects."Education Head Alert" := true;
                            end;
                            if (vCounterTot >= (Round((rCourseLines."Maximum Total Absences" / 2), 1, '='))) then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Half Unjustified";
                                rRegisSubjects."Education Head Alert" := true;
                            end;

                            if vCounterInjus = rCourseLines."Maximum Unjustified Absences" then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::"Unjustified Total";
                                rRegisSubjects."Recover Test" := true;
                            end;
                            if vCounterTot = rCourseLines."Maximum Total Absences" then begin
                                rRegisSubjects."Absence Option" := rRegisSubjects."Absence Option"::Total;
                                rRegisSubjects."Recover Test" := true;
                            end;

                            rTest.Reset;
                            rTest.SetRange(rTest."Test Type", rTest."Test Type"::"Recover Test");
                            rTest.SetRange(rTest."Line Type", rTest."Line Type"::Line);
                            rTest.SetRange(rTest."Student No.", "Student/Teacher Code No.");
                            rTest.SetRange(rTest."School Year", "School Year");
                            rTest.SetRange(rTest."Schooling Year", "Schooling Year");
                            rTest.SetRange(rTest."Subjects Code", Subject);
                            rTest.SetRange(rTest."Absence Option", rRegisSubjects."Absence Option");
                            rTest.SetFilter(rTest."Recover Classif.", '<>%1', '');
                            if not rTest.FindSet then
                                rRegisSubjects.Modify;
                        end;
                    end;

                end;
            end;
        end;
    end;


    procedure ValidateStudentNo()
    var
        l_text00001: Label 'Active';
        l_text00002: Label 'Closing';
        rRegistrationSubjects: Record "Registration Subjects";
        cStudentsRegistration: Codeunit "Students Registration";
        rDate: Record Date;
        rStudentsNLHours: Record "Students Non Lective Hours";
        rTeacher: Record Teacher;
        rRegistration: Record Registration;
        l_rStudentSubSubjectsPlan: Record "Student Sub-Subjects Plan ";
        rStudentSubjectsEntry: Record "Student Subjects Entry";
    begin
        if "Student/Teacher" = "Student/Teacher"::Student then begin
            rSchoolYear.Reset;
            rSchoolYear.SetRange("School Year", "School Year");
            rSchoolYear.SetRange(Status, rSchoolYear.Status::Active, rSchoolYear.Status::Closing);
            if not rSchoolYear.FindSet then
                Error(Text00002, l_text00001, l_text00002);
            if Category = Category::Class then begin
                if "Student/Teacher Code No." <> '' then begin
                    rRegistrationSubjects.Reset;
                    rRegistrationSubjects.SetRange("School Year", "School Year");
                    rRegistrationSubjects.SetRange("Study Plan Code", "Study Plan");
                    rRegistrationSubjects.SetRange("Subjects Code", Subject);
                    rRegistrationSubjects.SetRange(Class, Class);
                    rRegistrationSubjects.SetFilter(Status, '<>0');
                    rRegistrationSubjects.SetRange("Student Code No.", "Student/Teacher Code No.");
                    rRegistrationSubjects.SetRange(Turn, Turn);
                    if rRegistrationSubjects.FindFirst then begin
                        rStudentSubjectsEntry.Reset;
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."School Year", "School Year");
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Study Plan Code", "Study Plan");
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Subjects Code", Subject);
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Class, Class);
                        rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry.Status, '<>%1', 0);
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Turn, Turn);
                        rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry."Status Date", '<=%1', Day);
                        rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Student Code No.", rRegistrationSubjects."Student Code No.");
                        if (rStudentSubjectsEntry.FindLast) and (rStudentSubjectsEntry.Status = rStudentSubjectsEntry.Status::Subscribed) then begin
                            if rStudent.Get("Student/Teacher Code No.") then begin
                                "Student Name" := rStudent.Name;
                                "Full Name" := rStudent."Full Name";
                                "Class No." := rRegistrationSubjects."Class No.";
                            end;
                        end;
                    end else begin
                        rRegistrationSubjects.Reset;
                        rRegistrationSubjects.SetRange("School Year", "School Year");
                        rRegistrationSubjects.SetRange("Study Plan Code", "Study Plan");
                        rRegistrationSubjects.SetRange("Subjects Code", Subject);
                        rRegistrationSubjects.SetRange(Class, Class);
                        rRegistrationSubjects.SetFilter(Status, '<>0');
                        rRegistrationSubjects.SetRange("Student Code No.", "Student/Teacher Code No.");
                        rRegistrationSubjects.SetRange("Sub-subjects for assess. only", false);
                        rRegistrationSubjects.CalcFields("Sub-subject");
                        rRegistrationSubjects.SetRange("Sub-subject", true);
                        if rRegistrationSubjects.FindFirst then begin
                            rStudentSubjectsEntry.Reset;
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."School Year", "School Year");
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Study Plan Code", "Study Plan");
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Subjects Code", Subject);
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Class, Class);
                            rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry.Status, '<>%1', 0);
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry.Turn, Turn);
                            rStudentSubjectsEntry.SetFilter(rStudentSubjectsEntry."Status Date", '<=%1', Day);
                            rStudentSubjectsEntry.SetRange(rStudentSubjectsEntry."Student Code No.", rRegistrationSubjects."Student Code No.");
                            if (rStudentSubjectsEntry.FindLast) and (rStudentSubjectsEntry.Status = rStudentSubjectsEntry.Status::Subscribed) then begin
                                l_rStudentSubSubjectsPlan.Reset;
                                l_rStudentSubSubjectsPlan.SetRange("Student Code No.", "Student/Teacher Code No.");
                                l_rStudentSubSubjectsPlan.SetRange("School Year", "School Year");
                                l_rStudentSubSubjectsPlan.SetRange("Subject Code", Subject);
                                l_rStudentSubSubjectsPlan.SetRange(Turn, Turn);
                                l_rStudentSubSubjectsPlan.SetRange(Code, "Study Plan");
                                if l_rStudentSubSubjectsPlan.FindFirst then begin
                                    if rStudent.Get("Student/Teacher Code No.") then begin
                                        "Student Name" := rStudent.Name;
                                        "Full Name" := rStudent."Full Name";
                                        "Class No." := rRegistrationSubjects."Class No.";
                                    end;
                                end else
                                    Error(Text0012, Class, Subject);
                            end;
                        end else
                            Error(Text0009, Class, Subject);
                    end;
                end else begin
                    "Student Name" := '';
                    "Full Name" := '';
                    "Class No." := 0;
                end;
            end;
            if Category = Category::Schoolyard then begin
                if "Student/Teacher Code No." <> '' then begin
                    rRegistration.Reset;
                    rRegistration.SetRange("Student Code No.", "Student/Teacher Code No.");
                    rRegistration.SetRange("School Year", "School Year");
                    rRegistration.SetRange(Class, Class);
                    rRegistration.SetRange(Type, Type);
                    if Type = Type::Simple then
                        rRegistration.SetRange("Study Plan Code", "Study Plan");
                    if Type = Type::Multi then
                        rRegistration.SetRange(Course, "Study Plan");
                    rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                    rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                    if rRegistration.Find('-') then begin
                        if rStudent.Get(rRegistration."Student Code No.") then begin
                            "Student Name" := rStudent.Name;
                            "Full Name" := rStudent."Full Name";
                            "Class No." := rRegistrationSubjects."Class No.";
                        end;
                    end else
                        Error(Text0009, Class, Subject);
                end else begin
                    "Student Name" := '';
                    "Class No." := 0;
                end;
            end;

            if Category = Category::Cantine then begin
                if "Student/Teacher Code No." <> '' then begin
                    rDate.Reset;
                    rDate.SetRange("Period Type", rDate."Period Type"::Date);
                    rDate.SetRange("Period Start", Day);
                    if rDate.FindSet then;

                    rRegistration.Reset;
                    rRegistration.SetRange("Student Code No.", "Student/Teacher Code No.");
                    rRegistration.SetRange("School Year", "School Year");
                    rRegistration.SetRange(Class, Class);
                    rRegistration.SetRange(Type, Type);
                    if Type = Type::Simple then
                        rRegistration.SetRange("Study Plan Code", "Study Plan");
                    if Type = Type::Multi then
                        rRegistration.SetRange(Course, "Study Plan");
                    rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                    rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                    if rRegistration.Find('-') then begin
                        rStudentsNLHours.Reset;
                        rStudentsNLHours.SetRange("School Year", "School Year");
                        rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                        rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                        rStudentsNLHours.SetRange(Lunch, true);
                        if rStudentsNLHours.FindFirst then begin
                            rVehicleEntry.Reset;
                            rVehicleEntry.SetRange("School Year", "School Year");
                            rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Lunch");
                            rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                            rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                            rVehicleEntry.SetRange("Lunch Cancelled", false);
                            if not rVehicleEntry.FindFirst then begin
                                if rStudent.Get("Student/Teacher Code No.") then begin
                                    "Student Name" := rStudent.Name;
                                    "Full Name" := rStudent."Full Name";
                                    "Class No." := rRegistrationSubjects."Class No.";
                                end
                            end;
                        end;
                    end else
                        Error(Text0009, Class, Subject);

                end else begin
                    "Student Name" := '';
                    "Class No." := 0;
                end;
            end;
            if Category = Category::BUS then begin
                if "Student/Teacher Code No." <> '' then begin
                    rDate.Reset;
                    rDate.SetRange("Period Type", rDate."Period Type"::Date);
                    rDate.SetRange("Period Start", Day);
                    if rDate.FindFirst then;

                    if rCalendar.Get("Timetable Code", "School Year", "Study Plan", Class, "Line No. Timetable") then;

                    rRegistration.Reset;
                    rRegistration.SetRange("Student Code No.", "Student/Teacher Code No.");
                    rRegistration.SetRange("School Year", "School Year");
                    rRegistration.SetRange(Class, Class);
                    rRegistration.SetRange(Type, Type);
                    if Type = Type::Simple then
                        rRegistration.SetRange("Study Plan Code", "Study Plan");
                    if Type = Type::Multi then
                        rRegistration.SetRange(Course, "Study Plan");
                    rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                    rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                    if rRegistration.Find('-') then begin
                        rStudentsNLHours.Reset;
                        rStudentsNLHours.SetRange("School Year", "School Year");
                        rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                        rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                        rStudentsNLHours.SetRange("Estimated Colect Hour", rCalendar."Start Hour", rCalendar."End Hour");
                        if rStudentsNLHours.FindFirst then begin
                            rVehicleEntry.Reset;
                            rVehicleEntry.SetRange("School Year", "School Year");
                            rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
                            rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                            rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                            rVehicleEntry.SetRange("Collect Time", rCalendar."Start Hour", rCalendar."End Hour");
                            rVehicleEntry.SetRange("Transport Collect Cancelled", false);
                            rVehicleEntry.SetFilter("Transport No.", '<>%1', '');
                            if not rVehicleEntry.FindFirst then begin
                                if rStudent.Get(rRegistration."Student Code No.") then begin
                                    "Student Name" := rStudent.Name;
                                    "Full Name" := rStudent."Full Name";
                                    "Class No." := rRegistrationSubjects."Class No.";
                                end;
                            end else
                                Error(Text00007);
                        end;
                        rStudentsNLHours.Reset;
                        rStudentsNLHours.SetRange("School Year", "School Year");
                        rStudentsNLHours.SetRange("Student Code No.", rRegistration."Student Code No.");
                        rStudentsNLHours.SetRange("Week Day", rDate."Period No." - 1);
                        rStudentsNLHours.SetRange("Estimated Deliver Hour", rCalendar."Start Hour", rCalendar."End Hour");
                        if rStudentsNLHours.FindFirst then begin
                            rVehicleEntry.Reset;
                            rVehicleEntry.SetRange("School Year", "School Year");
                            rVehicleEntry.SetRange("Responsibility Center", "Responsibility Center");
                            rVehicleEntry.SetRange("Entry Type", rVehicleEntry."Entry Type"::"Student Transport");
                            rVehicleEntry.SetRange("Student No.", rRegistration."Student Code No.");
                            rVehicleEntry.SetRange("Absence Day", rDate."Period Start");
                            rVehicleEntry.SetRange("Transport Deliver Cancelled", false);
                            rVehicleEntry.SetRange("Deliver Time", rCalendar."Start Hour", rCalendar."End Hour");
                            rVehicleEntry.SetFilter("Transport No.", '<>%1', '');
                            if not rVehicleEntry.FindFirst then begin
                                if rStudent.Get(rRegistration."Student Code No.") then begin
                                    "Student Name" := rStudent.Name;
                                    "Full Name" := rStudent."Full Name";
                                    "Class No." := rRegistrationSubjects."Class No.";
                                end;
                            end else
                                Error(Text00007);
                        end;

                    end else
                        Error(Text0009, Class, Subject);
                end;
            end;

            //ValidateStudentAbsences;

            if ("Absence Type" = "Absence Type"::Daily) and ("Incidence Type" = "Incidence Type"::Absence) and
             (Category = Category::Class) then begin
                rAbsence.Reset;
                rAbsence.SetRange("Timetable Code", "Timetable Code");
                rAbsence.SetRange("School Year", "School Year");
                rAbsence.SetRange(Class, Class);
                rAbsence.SetRange("Absence Type", "Absence Type"::Daily);
                rAbsence.SetRange("Student/Teacher Code No.", "Student/Teacher Code No.");
                rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
                rAbsence.SetRange("Incidence Type", "Incidence Type"::Absence);
                rAbsence.SetRange(Category, rAbsence.Category::Class);
                rAbsence.SetRange(Delay, false);
                rAbsence.SetRange(Day, Day);
                if rAbsence.FindFirst then begin
                    Error(Text00003, "Student/Teacher Code No.", Day);
                end;
            end;


        end;
        if "Student/Teacher" = "Student/Teacher"::Teacher then begin
            if "Student/Teacher Code No." <> '' then begin
                if rTeacher.Get("Student/Teacher Code No.") then begin
                    "Student Name" := rTeacher.Name;
                    if rTeacher."Last Name" <> '' then
                        "Full Name" := rTeacher.Name + ' ' + rTeacher."Last Name"
                    else
                        "Full Name" := rTeacher.Name;
                end;
            end else begin
                "Student Name" := '';
                "Full Name" := '';
            end;
        end;
    end;


    procedure validateIncidenceCode()
    begin
        rAbsence.Reset;
        rAbsence.SetRange("Timetable Code", "Timetable Code");
        rAbsence.SetRange("School Year", "School Year");
        if "Absence Type" <> "Absence Type"::Daily then begin
            rAbsence.SetRange("Line No. Timetable", "Line No. Timetable");
            rAbsence.SetRange("Incidence Code", "Incidence Code");
        end else begin
            rAbsence.SetRange(Category, Category::Class);
            if "Incidence Type" = "Incidence Type"::Default then
                rAbsence.SetRange("Incidence Code", "Incidence Code");
        end;
        rAbsence.SetRange(Day, Day);
        rAbsence.SetRange("Student/Teacher Code No.", "Student/Teacher Code No.");
        rAbsence.SetRange("Incidence Type", "Incidence Type");

        rAbsence.SetRange("Subcategory Code", "Subcategory Code");
        if "Student/Teacher" = "Student/Teacher"::Student then begin
            rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
            rAbsence.SetRange("Study Plan", "Study Plan");
            rAbsence.SetRange(Type, Type);
            rAbsence.SetRange(Class, Class);
            rAbsence.SetRange("Absence Type", "Absence Type");
        end;
        if "Student/Teacher" = "Student/Teacher"::Teacher then begin
            rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Teacher);
            //Para não poder marcar 2 faltas ao mesmo Non Scholar Component, no mesmo dia, quando estas forem marcadas a partir do wizard
            //As faltas marcadas a partir deste wizard vem com o campo "Line No. Timetable" a zero
            if ("Line No. Timetable" = 0) and ("Type Subject" = "Type Subject"::"Non scholar component") then
                rAbsence.SetRange(rAbsence.Subject, Subject);

        end;
        if rAbsence.FindFirst then begin
            if "Student/Teacher" = "Student/Teacher"::Student then begin
                if "Incidence Type" = "Incidence Type"::Default then
                    Error(Text00001, "Student/Teacher Code No.", "Incidence Code", Day)
                else
                    Error(Text00003, "Student/Teacher Code No.", Day);

            end;
            if "Student/Teacher" = "Student/Teacher"::Teacher then
                Error(Text00006, "Student/Teacher Code No.", "Incidence Code", Day);
        end;
    end;


    procedure CalFaltas(pSchoolYear: Code[9]; pSchoolingYear: Code[10]; pClass: Code[20]; pStudent: Code[20]; pSubject: Code[10]; pDataEnd: Date; pTotInj: Option Totais,Injustificadas; pDataIni: Date; pAbsence: Record Absence; pInsModDel: Integer) TotalFaltas: Integer
    var
        l_rIncidenceType: Record "Incidence Type";
        l_rAbsence: Record Absence;
        l_rAbsenceTemp: Record Absence temporary;
    begin
        //Devolve as faltas totais ou injustificadas, para um aluno, para uma disciplina, até uma determinada data
        //Em portugal os mapas legais só contabilizam as faltas do tipo Absence / Class e que tenham o pisco no campo Legal Report
        //As faltas do tipo Absence / Class que n tenham o pisco no campo Legal Report temos de fazer os cálculos da correspondencia

        l_rAbsence.Reset;
        l_rAbsence.SetRange(l_rAbsence."Student/Teacher Code No.", pStudent);
        l_rAbsence.SetRange(l_rAbsence."School Year", pSchoolYear);
        if l_rAbsence.Find('-') then begin
            repeat
                l_rAbsenceTemp.Init;
                l_rAbsenceTemp.TransferFields(l_rAbsence);
                l_rAbsenceTemp.Insert;
            until l_rAbsence.Next = 0;
        end;


        if (pInsModDel = 2) or (pInsModDel = 3) then begin
            l_rAbsenceTemp.Reset;
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Timetable Code", pAbsence."Timetable Code");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."School Year", pAbsence."School Year");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Study Plan", pAbsence."Study Plan");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Class, pAbsence.Class);
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Day, pAbsence.Day);
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Type, pAbsence.Type);
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Line No. Timetable", pAbsence."Line No. Timetable");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Type", pAbsence."Incidence Type");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Code", pAbsence."Incidence Code");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Category, pAbsence.Category);
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Subcategory Code", pAbsence."Subcategory Code");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher", pAbsence."Student/Teacher");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher Code No.", pAbsence."Student/Teacher Code No.");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Responsibility Center", pAbsence."Responsibility Center");
            l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Line No.", pAbsence."Line No.");
            if l_rAbsenceTemp.FindSet then
                l_rAbsenceTemp.Delete;
        end;

        if (pInsModDel = 1) or (pInsModDel = 2) then begin
            l_rAbsenceTemp.Init;
            l_rAbsenceTemp.TransferFields(pAbsence);
            l_rAbsenceTemp.Insert;
        end;



        l_rIncidenceType.Reset;
        l_rIncidenceType.SetRange(l_rIncidenceType.Category, l_rIncidenceType.Category::Class);
        l_rIncidenceType.SetRange(l_rIncidenceType."Incidence Type", l_rIncidenceType."Incidence Type"::Absence);
        l_rIncidenceType.SetFilter(l_rIncidenceType."Absence Status", '<>%1', l_rIncidenceType."Absence Status"::Justification);
        l_rIncidenceType.SetRange(l_rIncidenceType."Legal/Attendance", false);
        l_rIncidenceType.SetRange(l_rIncidenceType."School Year", pSchoolYear);
        l_rIncidenceType.SetRange(l_rIncidenceType."Schooling Year", pSchoolingYear);
        l_rIncidenceType.SetFilter(l_rIncidenceType."Corresponding Code", '<>%1', '');
        if l_rIncidenceType.FindSet then begin
            repeat
                l_rAbsenceTemp.Reset;
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Category, l_rAbsenceTemp.Category::Class);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Type", l_rAbsenceTemp."Incidence Type"::Absence);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."School Year", pSchoolYear);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Class, pClass);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher", l_rAbsenceTemp."Student/Teacher"::Student);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher Code No.", pStudent);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Subject, pSubject);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Absence Status", l_rAbsenceTemp."Absence Status"::Unjustified);
                if (pDataIni <> 0D) and (pDataEnd <> 0D) then
                    l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Day, pDataIni, pDataEnd);
                if (pDataIni = 0D) and (pDataEnd <> 0D) then
                    l_rAbsenceTemp.SetFilter(l_rAbsenceTemp.Day, '<=%1', pDataEnd);
                if (pDataIni <> 0D) and (pDataEnd = 0D) then
                    l_rAbsenceTemp.SetFilter(l_rAbsenceTemp.Day, '>=%1', pDataIni);

                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Code", l_rIncidenceType."Incidence Code");
                if l_rAbsenceTemp.Find('+') then begin
                    TotalFaltas := TotalFaltas + (Round(l_rAbsenceTemp.Count / l_rIncidenceType.Quantity, 1, '<'));
                end;
            until l_rIncidenceType.Next = 0;
        end;


        l_rIncidenceType.Reset;
        l_rIncidenceType.SetRange(l_rIncidenceType.Category, l_rIncidenceType.Category::Class);
        l_rIncidenceType.SetRange(l_rIncidenceType."Incidence Type", l_rIncidenceType."Incidence Type"::Absence);
        l_rIncidenceType.SetFilter(l_rIncidenceType."Absence Status", '<>%1', l_rIncidenceType."Absence Status"::Justification);
        l_rIncidenceType.SetRange(l_rIncidenceType."Legal/Attendance", true);
        l_rIncidenceType.SetRange(l_rIncidenceType."School Year", pSchoolYear);
        l_rIncidenceType.SetRange(l_rIncidenceType."Schooling Year", pSchoolingYear);
        if l_rIncidenceType.FindSet then begin
            repeat
                l_rAbsenceTemp.Reset;
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Category, l_rAbsenceTemp.Category::Class);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Type", l_rAbsenceTemp."Incidence Type"::Absence);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."School Year", pSchoolYear);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Class, pClass);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher", l_rAbsenceTemp."Student/Teacher"::Student);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Student/Teacher Code No.", pStudent);
                l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Subject, pSubject);

                if (pDataIni <> 0D) and (pDataEnd <> 0D) then
                    l_rAbsenceTemp.SetRange(l_rAbsenceTemp.Day, pDataIni, pDataEnd);
                if (pDataIni = 0D) and (pDataEnd <> 0D) then
                    l_rAbsenceTemp.SetFilter(l_rAbsenceTemp.Day, '<=%1', pDataEnd);
                if (pDataIni <> 0D) and (pDataEnd = 0D) then
                    l_rAbsenceTemp.SetFilter(l_rAbsenceTemp.Day, '>=%1', pDataIni);

                l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Incidence Code", l_rIncidenceType."Incidence Code");
                if pTotInj = pTotInj::Injustificadas then
                    l_rAbsenceTemp.SetRange(l_rAbsenceTemp."Absence Status", l_rAbsenceTemp."Absence Status"::Unjustified);
                if l_rAbsenceTemp.Find('+') then
                    TotalFaltas := TotalFaltas + l_rAbsenceTemp.Count;
            until l_rIncidenceType.Next = 0;
        end;

        exit(TotalFaltas);
    end;


    procedure ValidateWEB()
    var
        l_Students: Record Students;
        l_StruEdu: Record "Structure Education Country";
        l_Registration: Record Registration;
        l_RegistrationSubjects: Record "Registration Subjects";
        l_IncidenceType: Record "Incidence Type";
        l_Remarks: Record Remarks;
    begin
        if l_Students.Get("Student/Teacher Code No.") then
            "Student Name" := l_Students.Name;

        l_StruEdu.Reset;
        l_StruEdu.SetRange("Schooling Year", "Schooling Year");
        if l_StruEdu.FindFirst then begin
            if l_StruEdu."Absence Type" = l_StruEdu."Absence Type"::Daily then begin
                l_Registration.Reset;
                l_Registration.SetRange("Student Code No.", "Student/Teacher Code No.");
                l_Registration.SetRange("School Year", "School Year");
                l_Registration.SetRange(Class, Class);
                l_Registration.SetRange("Schooling Year", "Schooling Year");
                if l_Registration.FindFirst then
                    "Class No." := l_Registration."Class No.";
            end;
            if l_StruEdu."Absence Type" = l_StruEdu."Absence Type"::Lecture then begin
                l_RegistrationSubjects.Reset;
                l_RegistrationSubjects.SetRange("Student Code No.", "Student/Teacher Code No.");
                l_RegistrationSubjects.SetRange("School Year", "School Year");
                l_RegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
                l_RegistrationSubjects.SetRange(Class, Class);
                if l_RegistrationSubjects.FindFirst then
                    "Class No." := l_RegistrationSubjects."Class No.";
            end;
        end;


        if ("Absence Status" = "Absence Status"::Unjustified) or ("Absence Status" = "Absence Status"::Justified) then begin
            l_IncidenceType.Reset;
            l_IncidenceType.SetRange("School Year", "School Year");
            l_IncidenceType.SetRange("Schooling Year", "Schooling Year");
            l_IncidenceType.SetRange(Category, Category);
            l_IncidenceType.SetRange("Subcategory Code", "Subcategory Code");
            l_IncidenceType.SetRange("Incidence Type", "Incidence Type");
            l_IncidenceType.SetRange("Incidence Code", "Incidence Code");
            l_IncidenceType.SetRange("Justification Code", '');
            if l_IncidenceType.FindFirst then begin
                "Incidence Description" := l_IncidenceType.Description;
                Delay := l_IncidenceType.Delay;
            end;
        end;

        if ("Absence Status" = "Absence Status"::Justification) then begin
            l_IncidenceType.Reset;
            l_IncidenceType.SetRange("School Year", "School Year");
            l_IncidenceType.SetRange("Schooling Year", "Schooling Year");
            l_IncidenceType.SetRange(Category, Category);
            l_IncidenceType.SetRange("Subcategory Code", "Subcategory Code");
            l_IncidenceType.SetRange("Incidence Type", "Incidence Type");
            l_IncidenceType.SetRange("Incidence Code", "Incidence Code");
            l_IncidenceType.SetRange("Justification Code", "Justified Code");
            if l_IncidenceType.FindFirst then begin
                "Justified Description" := l_IncidenceType.Description;
            end;
        end;


        l_Remarks.Reset;
        l_Remarks.SetRange(Class, Class);
        l_Remarks.SetRange("School Year", "School Year");
        l_Remarks.SetRange("Schooling Year", "Schooling Year");
        l_Remarks.SetRange("Study Plan Code", "Study Plan");
        l_Remarks.SetRange("Student/Teacher Code No.", "Student/Teacher Code No.");
        l_Remarks.SetRange("Type Remark", l_Remarks."Type Remark"::Absence);
        l_Remarks.SetRange(Day, Day);
        l_Remarks.SetRange("Calendar Line", "Line No. Timetable");
        l_Remarks.SetRange("Student/Teacher", "Student/Teacher"::Student);
        l_Remarks.SetRange("Incidence Type", "Incidence Type");
        l_Remarks.SetRange("Line No.", "Line No.");
        if l_Remarks.FindFirst then
            Observations := l_Remarks.Textline;
    end;


    procedure ValidateLastLineNoWEB(): Integer
    var
        l_StruEdu: Record "Structure Education Country";
        l_Absence: Record Absence;
    begin

        l_Absence.Reset;
        l_Absence.SetRange("Timetable Code", "Timetable Code");
        l_Absence.SetRange("Schooling Year", "Schooling Year");
        l_Absence.SetRange("School Year", "School Year");
        l_Absence.SetRange("Study Plan", "Study Plan");
        l_Absence.SetRange(Class, Class);
        l_Absence.SetRange(Day, Day);
        l_Absence.SetRange(Type, Type);
        l_Absence.SetRange("Line No. Timetable", "Line No. Timetable");
        l_Absence.SetRange("Incidence Type", "Incidence Type");
        if l_Absence.FindLast then begin
            if "Absence Status" = "Absence Status"::Justification then
                exit(l_Absence."Line No.")
            else
                exit(l_Absence."Line No." + 10000);

        end else
            exit(10000);
    end;
}

