table 31009764 "Registration Class"
{
    Caption = 'Registration Class';
    DrillDownPageID = "Registration Class List";
    LookupPageID = "Registration Class List";

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
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";

            trigger OnLookup()
            var
                TempStudents: Record Students temporary;
            begin
                rRegistration.Reset;
                rRegistration.SetRange("School Year", "School Year");
                rRegistration.SetRange("Schooling Year", "Schooling Year");
                if Type = Type::Simple then
                    rRegistration.SetRange("Study Plan Code", "Study Plan Code");
                if Type = Type::Multi then
                    rRegistration.SetRange(Course, "Study Plan Code");
                rRegistration.SetFilter(Status, '%1', rRegistration.Status::" ");
                rRegistration.SetFilter("School Name Transfer", '%1', '');
                if rRegistration.Find('-') then begin
                    repeat
                        if rStudents.Get(rRegistration."Student Code No.") then begin
                            TempStudents.TransferFields(rStudents);
                            TempStudents.Insert;
                        end;
                    until rRegistration.Next = 0;
                    if PAGE.RunModal(PAGE::"Students List", TempStudents) = ACTION::LookupOK then begin
                        Validate("Student Code No.", TempStudents."No.");
                        "Responsibility Center" := TempStudents."Responsibility Center";
                    end;
                end;
            end;

            trigger OnValidate()
            begin
                rRegistrationClass.Reset;
                rRegistrationClass.SetRange(Class, Class);
                rRegistrationClass.SetRange("School Year", "School Year");
                rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
                rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
                rRegistrationClass.SetRange("Student Code No.", "Student Code No.");
                if rRegistrationClass.FindFirst then
                    Error(Text003);

                rRegistration.Reset;
                rRegistration.SetRange("School Year", "School Year");
                rRegistration.SetRange("Schooling Year", "Schooling Year");
                if Type = Type::Simple then
                    rRegistration.SetRange("Study Plan Code", "Study Plan Code");
                if Type = Type::Multi then
                    rRegistration.SetRange(Course, "Study Plan Code");
                rRegistration.SetRange("Student Code No.", "Student Code No.");
                if rRegistration.Find('-') then begin
                    if rRegistration."School Name Transfer" <> '' then
                        Error(Text009);
                    if rStudents.Get("Student Code No.") then begin
                        Name := rStudents.Name;
                        "Responsibility Center" := rStudents."Responsibility Center";
                        "Last Name" := rStudents."Last Name";
                        "Last Name 2" := rStudents."Last Name 2";
                        "Full Name" := rStudents."Full Name";
                    end else begin
                        Name := '';
                        "Last Name" := '';
                        "Last Name 2" := '';
                        "Full Name" := '';
                    end;
                end;

                rRegSubServ.Reset;
                rRegSubServ.SetRange("Student Code No.", "Student Code No.");
                rRegSubServ.SetRange("School Year", "School Year");
                rRegSubServ.SetRange(Enroled, true);
                if not rRegSubServ.FindFirst then
                    Error(Text004, "Student Code No.", Name, "Study Plan Code");
            end;
        }
        field(6; Name; Text[128])
        {
            Caption = 'Name';
        }
        field(7; "Class No."; Integer)
        {
            Caption = 'Class No.';

            trigger OnValidate()
            begin
                if "Class No." <> 0 then
                    if Status = Status::" " then
                        ValidateClassNo
                    else
                        Error(Text008);
            end;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Subscribed,Transfer,Annulled';
            OptionMembers = " ",Subscribed,Transfer,Annuled;
        }
        field(9; "Status Date"; Date)
        {
            Caption = 'Status Date';
        }
        field(13; "School Name Transfer"; Text[128])
        {
            Caption = 'School Name Transfer';
        }
        field(14; "Transfer Class"; Code[20])
        {
            Caption = 'Transfer Class';
        }
        field(15; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                     "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(18; "Responsibility Center"; Code[10])
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
        field(19; Selection; Boolean)
        {
            Caption = 'Selection';

            trigger OnValidate()
            begin
                "User Session" := UpperCase(UserId);
            end;
        }
        field(20; "User Session"; Code[20])
        {
            Caption = 'User Session';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(21; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(22; "Absence Option"; Option)
        {
            Caption = 'Absence Option';
            OptionCaption = ' ,Half Absence,Unjustified Total,Total,Half Unjustified';
            OptionMembers = " ","Half Absence","Unjustified Total",Total,"Half Unjustified";
        }
        field(23; "Education Head Alert"; Boolean)
        {
            Caption = 'Education Head Alert';

            trigger OnValidate()
            begin
                if (xRec."Education Head Alert") and (not "Education Head Alert") then
                    if Confirm(Text005, false, "Student Code No.") then begin
                        "Absence Option" := "Absence Option"::" ";
                        //"Education Head Alert" := FALSE;
                        "Recover Test" := false;
                        Observations := '';
                    end else
                        "Education Head Alert" := xRec."Education Head Alert";
            end;
        }
        field(24; "Recover Test"; Boolean)
        {
            Caption = 'Recover Test';

            trigger OnValidate()
            begin
                if (xRec."Recover Test") and (not "Recover Test") then
                    if Confirm(Text005, false, "Student Code No.") then begin
                        "Absence Option" := "Absence Option"::" ";
                        "Education Head Alert" := false;
                        //"Recover Test"         := FALSE;
                        Observations := '';
                    end else
                        "Recover Test" := xRec."Recover Test";
            end;
        }
        field(25; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(1000; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User Id");
            end;
        }
        field(1001; Date; Date)
        {
            Caption = 'Date';
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';
        }
        field(73102; "Full Name"; Text[191])
        {
            Caption = 'Full Name';
        }
        field(75000; Destination; Option)
        {
            Caption = 'Destination';
            Description = 'MISI';
            OptionCaption = ' ,Public School,Private School,Foreign';
            OptionMembers = " ","Public School","Private School",Foreign;
        }
    }

    keys
    {
        key(Key1; Class, "School Year", "Schooling Year", "Study Plan Code", "Student Code No.", Type, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
        key(Key3; "Class No.")
        {
        }
        key(Key4; "School Year", "Study Plan Code", Class, Status)
        {
        }
        key(Key5; "Last Name")
        {
        }
        key(Key6; "Last Name 2")
        {
        }
        key(Key7; "Student Code No.", "Schooling Year", "School Year")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status <> Status::" " then
            Error(Text001, "Student Code No.", Name);
    end;

    trigger OnInsert()
    begin
        TestField(Class);
        TestField("School Year");
        TestField("Schooling Year");
        TestField("Study Plan Code");

        if rClass.Get(Class, "School Year") then
            "Schooling Year" := rClass."Schooling Year";

        "Country/Region Code" := cStudentsRegistration.GetCountry;


        "User Id" := UserId;
        Date := Today;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := Today;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0020, TableCaption);*/
    end;

    var
        rStudents: Record Students;
        Text001: Label 'You cannot eliminate lines for the student %1 %2.';
        rRegistration: Record Registration;
        Text002: Label 'Unknown';
        rClass: Record Class;
        rRegistrationClass: Record "Registration Class";
        Text003: Label 'There already is a pupil in the class.';
        cStudentsRegistration: Codeunit "Students Registration";
        rRegSubServ: Record "Registration Subjects";
        Text004: Label 'The Student %1 -%2 has to select subjects in the Study Plan %3';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text005: Label 'Do you want remove the Student %1 from the list of Limit of Absence?';
        Text006: Label 'The only %1 available is %2.';
        Text007: Label 'The %1 %2 is bigger than the last %1 %3.\The available %1 is %4.';
        Text008: Label 'The student is already subscribed in class. Cannot change his or her class no.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text009: Label 'The student has been transfered from another school.';
        Text0010: Label 'The student belongs to another level of education / study plan, to access this feature, please use the functions of the student''s study plan.';
        rCompanyInformation: Record "Company Information";
        Text0020: Label 'You cannot rename a %1.';

    //[Scope('OnPrem')]
    procedure TransferStudent(pTransferDate: Date; pTransferClass: Code[20]; pSchoolName: Text[128]; pStudyPlanCode: Code[20]; pDestination: Option " ","Public School","Private School",Foreign)
    var
        rRegistrationSubjects: Record "Registration Subjects";
    begin
        rRegistration.Reset;
        rRegistration.SetRange("Student Code No.", "Student Code No.");
        rRegistration.SetRange("School Year", "School Year");
        rRegistration.SetRange("Schooling Year", "Schooling Year");
        if rRegistration.Find('-') then;

        //IF rRegistration.GET(Rec."Student Code No.",Rec."School Year",Rec."Responsibility Center") THEN;

        if Class = rRegistration.Class then begin
            if pSchoolName = '' then
                ValidateStudentClass(pTransferClass);
            "Status Date" := pTransferDate;
            "Transfer Class" := pTransferClass;
            "School Name Transfer" := pSchoolName;
            Destination := pDestination;
            Status := Status::Transfer;
            "User Id" := UserId;
            Date := WorkDate;
            Modify;
            cStudentsRegistration.InsertStudents(Rec);

            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Student Code No.");
            rRegistration.SetRange("School Year", "School Year");
            rRegistration.SetRange("Schooling Year", "Schooling Year");
            if rRegistration.Find('-') then begin
                rRegistration.Class := Class;
                rRegistration."Class No." := "Class No.";
                rRegistration.Status := rRegistrationClass.Status::Transfer;
                rRegistration.Validate(rRegistration."Actual Status", 8);//Transferido
                rRegistration."School Name Transfer" := pSchoolName;
                rRegistration.Destination := pDestination;
                rRegistration.Modify;

                rRegistrationSubjects.Reset;
                rRegistrationSubjects.SetRange("Student Code No.", "Student Code No.");
                rRegistrationSubjects.SetRange("School Year", "School Year");
                rRegistrationSubjects.SetRange(Class, Class);
                rRegistrationSubjects.SetRange("Schooling Year", "Schooling Year");
                rRegistrationSubjects.SetRange(Status, rRegistrationSubjects.Status::Subscribed);
                if rRegistrationSubjects.Find('-') then begin
                    repeat
                        rRegistrationSubjects.Status := rRegistrationSubjects.Status::Transfer;
                        rRegistrationSubjects."Status Date" := pTransferDate;
                        rRegistrationSubjects.Modify;

                        //WEB
                        cInsertNAVGeneralTable.AnunulGTStudent(rRegistrationSubjects);
                        //
                        cStudentsRegistration.StudentsSubjectsEntry(rRegistrationSubjects);
                    until rRegistrationSubjects.Next = 0;
                end;
            end;
            if pTransferClass <> '' then
                NewClass(pTransferClass, pStudyPlanCode, rRegistration."Responsibility Center");
        end else
            Error(Text0010);
    end;

    //[Scope('OnPrem')]
    procedure NewClass(pNewClass: Code[20]; pStudyPlanCode: Code[20]; pRespCenter: Code[10])
    var
        LastNoClass: Integer;
    begin
        rRegistrationClass.Reset;
        rRegistrationClass.SetCurrentKey(rRegistrationClass."Class No.");
        rRegistrationClass.SetRange(Class, pNewClass);
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", pStudyPlanCode);
        rRegistrationClass.SetRange(Status, rRegistrationClass.Status::Subscribed);
        if rRegistrationClass.Find('+') then
            LastNoClass := rRegistrationClass."Class No." + 1;



        rRegistrationClass.Reset;
        rRegistrationClass.Init;
        rRegistrationClass.Class := pNewClass;
        rRegistrationClass."School Year" := "School Year";
        rRegistrationClass."Schooling Year" := "Schooling Year";
        rRegistrationClass."Study Plan Code" := "Study Plan Code";
        rRegistrationClass."Student Code No." := "Student Code No.";
        rRegistrationClass.Name := Name;
        rRegistrationClass."Last Name" := "Last Name";
        rRegistrationClass."Last Name 2" := "Last Name 2";
        rRegistrationClass."Full Name" := "Full Name";
        rRegistrationClass.Status := rRegistrationClass.Status::" ";
        rRegistrationClass."Study Plan Code" := pStudyPlanCode;
        rRegistrationClass."Responsibility Center" := pRespCenter;
        rRegistrationClass.Type := Type;
        rRegistrationClass."Country/Region Code" := rRegistrationClass."Country/Region Code";
        rRegistrationClass."Class No." := LastNoClass;
        rRegistrationClass."User Id" := UserId;
        rRegistrationClass.Date := WorkDate;
        rRegistrationClass.Insert;
    end;

    //[Scope('OnPrem')]
    procedure SubjectsAspects()
    var
        rRegistrationSubjects: Record "Registration Subjects";
        rSchoolYear: Record "School Year";
        rAspects: Record Aspects;
    begin
        rAspects.Reset;
        rAspects.SetRange(Type, rAspects.Type::Class);
        rAspects.SetRange("School Year", "School Year");
        rAspects.SetRange("Type No.", Class);
        rAspects.SetRange("Responsibility Center", "Responsibility Center");
        if not rAspects.Find('-') then begin
            rAspects.InsertDefaultAspects(rAspects, rAspects.Type::Class, "School Year", Class, "Responsibility Center");
            Commit;
        end;

        //fAspects.SETTABLEVIEW(rAspects);
        PAGE.RunModal(PAGE::Aspects, rAspects);
    end;

    //[Scope('OnPrem')]
    procedure ValidateClassNo()
    var
        l_rRegistrationClass: Record "Registration Class";
        l_rRegistrationClass2: Record "Registration Class";
    begin
        rRegistrationClass.Reset;
        rRegistrationClass.SetCurrentKey("Class No.");
        rRegistrationClass.SetRange(Class, Class);
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
        rRegistrationClass.SetRange("Class No.", "Class No.");
        if rRegistrationClass.Find('-') then begin
            l_rRegistrationClass.Reset;
            l_rRegistrationClass.SetCurrentKey("Class No.");
            l_rRegistrationClass.SetRange(Class, Class);
            l_rRegistrationClass.SetRange("School Year", "School Year");
            l_rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            l_rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
            l_rRegistrationClass.SetFilter("Class No.", '<>%1', 0);
            if l_rRegistrationClass.Find('-') then
                repeat
                    l_rRegistrationClass2.Reset;
                    l_rRegistrationClass2.SetCurrentKey("Class No.");
                    l_rRegistrationClass2.SetRange(Class, l_rRegistrationClass.Class);
                    l_rRegistrationClass2.SetRange("Class No.", l_rRegistrationClass."Class No.");
                    if l_rRegistrationClass2.Find('-') then begin
                        l_rRegistrationClass2.SetRange("Class No.");

                        l_rRegistrationClass2.Next;

                        if (1 <> (l_rRegistrationClass2."Class No." - l_rRegistrationClass."Class No.")) then
                            Error(Text006, l_rRegistrationClass.FieldCaption("Class No."), l_rRegistrationClass."Class No." + 1);
                    end;
                until l_rRegistrationClass.Next = 0;
        end else begin
            rRegistrationClass.Reset;
            rRegistrationClass.SetCurrentKey("Class No.");
            rRegistrationClass.SetRange(Class, Class);
            rRegistrationClass.SetRange("School Year", "School Year");
            rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
            if rRegistrationClass.Find('+') then begin
                if ("Class No." > (rRegistrationClass."Class No." + 1)) then
                    Error(Text007, rRegistrationClass.FieldCaption("Class No."), "Class No.", rRegistrationClass."Class No.",
                          rRegistrationClass."Class No." + 1);
            end else begin
                rRegistrationClass.Reset;
                rRegistrationClass.SetCurrentKey("Class No.");
                rRegistrationClass.SetRange(Class, Class);
                rRegistrationClass.SetRange("School Year", "School Year");
                rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
                rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
                rRegistrationClass.SetFilter("Class No.", '<>%1', 0);
                if rRegistrationClass.Find('-') then
                    repeat
                        l_rRegistrationClass2.Reset;
                        l_rRegistrationClass2.SetCurrentKey("Class No.");
                        l_rRegistrationClass2.SetRange(Class, rRegistrationClass.Class);
                        l_rRegistrationClass2.SetRange("Class No.", rRegistrationClass."Class No.");
                        if l_rRegistrationClass2.Find('-') then begin
                            l_rRegistrationClass2.SetRange("Class No.");

                            l_rRegistrationClass2.Next;

                            if ((l_rRegistrationClass2."Class No." - rRegistrationClass."Class No.") > 1) then begin
                                Error(Text006, rRegistrationClass.FieldCaption("Class No."), rRegistrationClass."Class No.");
                            end;
                        end;
                    until rRegistrationClass.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateStudentClass(pTransferClass: Code[20])
    var
        l_RegistrationClass: Record "Registration Class";
        l_Text0001: Label 'The Student is in the class.';
    begin
        l_RegistrationClass.Reset;
        l_RegistrationClass.SetRange(Class, pTransferClass);
        l_RegistrationClass.SetRange("School Year", "School Year");
        l_RegistrationClass.SetRange("Schooling Year", "Schooling Year");
        l_RegistrationClass.SetRange("Student Code No.", "Student Code No.");
        l_RegistrationClass.SetRange("Responsibility Center", "Responsibility Center");
        if l_RegistrationClass.FindSet then
            Error(l_Text0001);
    end;

    //[Scope('OnPrem')]
    procedure InsertStudentSchoolName(pSchoolCode: Code[10])
    var
        l_StudentsTransfersSchool: Record "Students Transfers School";
        varLineNo: Integer;
    begin

        l_StudentsTransfersSchool.Init;
        l_StudentsTransfersSchool.SetRange("Student Code", "Student Code No.");
        if l_StudentsTransfersSchool.FindLast then
            varLineNo := l_StudentsTransfersSchool."Line No";


        l_StudentsTransfersSchool.Reset;
        l_StudentsTransfersSchool.Init;
        l_StudentsTransfersSchool."Student Code" := "Student Code No.";
        l_StudentsTransfersSchool."School Year" := "School Year";
        l_StudentsTransfersSchool."Schooling Year" := "Schooling Year";
        l_StudentsTransfersSchool."Line No" := varLineNo + 10000;
        l_StudentsTransfersSchool.Transfer := l_StudentsTransfersSchool.Transfer::"To";
        l_StudentsTransfersSchool.Validate("School Code", pSchoolCode);
        l_StudentsTransfersSchool.Insert;
    end;
}

