table 31009763 Class
{
    // //IT001 - Parque 06.10.2016 - preencher o Cod Localização no Cliente

    Caption = 'Class';
    DrillDownPageID = "Class List";
    LookupPageID = "Class List";
    Permissions = TableData MasterTableWEB = rimd;

    fields
    {
        field(1; Class; Code[20])
        {
            Caption = 'Class';

            trigger OnValidate()
            begin
                if Class <> xRec.Class then begin
                    rEduConfiguration.Get;
                    NoSeriesMgt.TestManual(rEduConfiguration."Class Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(4; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(5; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan/Course Code';
            TableRelation = IF (Type = FILTER(Simple),
                                "School Year" = FILTER(<> '')) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                            "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF (Type = FILTER(Multi),
                                                                                                     "School Year" = FILTER(<> '')) "Course Header".Code;

            trigger OnLookup()
            var
                rStudyPlanHeader: Record "Study Plan Header";
                cStudentsRegistration: Codeunit "Students Registration";
                rRegistrationClassTEMP: Record "Registration Class" temporary;
                VarInt: Integer;
                l_TeacherClass: Record "Teacher Class";
            begin
                rRegistrationClassTEMP.DeleteAll;
                VarInt := 0;

                rStudyPlanHeader.Reset;
                rStudyPlanHeader.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                rStudyPlanHeader.SetFilter("Schooling Year", '<>%1', '');
                if cUserEducation.GetEducationFilter(UserId) <> '' then
                    rStudyPlanHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                if rStudyPlanHeader.Find('-') then begin
                    repeat
                        VarInt += 10000;
                        rRegistrationClassTEMP.Init;
                        rRegistrationClassTEMP."School Year" := rStudyPlanHeader."School Year";
                        rRegistrationClassTEMP."Schooling Year" := rStudyPlanHeader."Schooling Year";
                        rRegistrationClassTEMP."Study Plan Code" := rStudyPlanHeader.Code;
                        rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Simple;
                        rRegistrationClassTEMP."Last Name" := rStudyPlanHeader.Description;
                        rRegistrationClassTEMP."Responsibility Center" := rStudyPlanHeader."Responsibility Center";
                        rRegistrationClassTEMP."Line No." := VarInt;
                        rRegistrationClassTEMP.Insert;
                    until rStudyPlanHeader.Next = 0;
                end;


                rCourseHeader.Reset;
                if cUserEducation.GetEducationFilter(UserId) <> '' then
                    rCourseHeader.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
                if rCourseHeader.Find('-') then begin
                    repeat
                        rRegistration.Reset;
                        rRegistration.SetCurrentKey("School Year", "Schooling Year", Course);
                        rRegistration.SetFilter("School Year", cStudentsRegistration.GetShoolYear);
                        rRegistration.SetRange("Responsibility Center", rCourseHeader."Responsibility Center");
                        rRegistration.SetRange(Course, rCourseHeader.Code);
                        if rRegistration.Find('-') then begin
                            repeat

                                rRegistrationClassTEMP.Reset;
                                rRegistrationClassTEMP.SetRange("Study Plan Code", rRegistration.Course);
                                rRegistrationClassTEMP.SetRange("School Year", rRegistration."School Year");
                                rRegistrationClassTEMP.SetRange("Schooling Year", rRegistration."Schooling Year");
                                rRegistrationClassTEMP.SetRange(Type, rRegistrationClassTEMP.Type::Multi);
                                rRegistrationClassTEMP.SetRange("Responsibility Center", rRegistration."Responsibility Center");
                                if not rRegistrationClassTEMP.Find('-') then begin
                                    rRegistrationClassTEMP.Init;
                                    VarInt += 10000;
                                    rRegistrationClassTEMP."School Year" := rRegistration."School Year";
                                    rRegistrationClassTEMP."Schooling Year" := rRegistration."Schooling Year";
                                    rRegistrationClassTEMP."Study Plan Code" := rCourseHeader.Code;
                                    rRegistrationClassTEMP."Last Name" := rCourseHeader.Description;
                                    rRegistrationClassTEMP."Responsibility Center" := rCourseHeader."Responsibility Center";
                                    rRegistrationClassTEMP.Type := rRegistrationClassTEMP.Type::Multi;
                                    rRegistrationClassTEMP."Line No." := VarInt;
                                    rRegistrationClassTEMP.Insert;
                                end;
                            until rRegistration.Next = 0;
                        end;
                    until rCourseHeader.Next = 0;
                end;


                rRegistrationClassTEMP.Reset;
                if PAGE.RunModal(PAGE::"Study Plan List Temp", rRegistrationClassTEMP) = ACTION::LookupOK then begin
                    if not Closed then begin
                        l_TeacherClass.Reset;
                        l_TeacherClass.SetRange(Class, Class);
                        l_TeacherClass.SetRange("School Year", "School Year");
                        l_TeacherClass.SetFilter("Subject Code", '<>%1', '');
                        if not l_TeacherClass.IsEmpty then
                            Error(Text0011);

                        if GetType(rRegistrationClassTEMP."Schooling Year") = 0 then begin
                            if rStudyPlanHeader.Get(rRegistrationClassTEMP."Study Plan Code") then begin
                                "Study Plan Code" := rRegistrationClassTEMP."Study Plan Code";
                                "Schooling Year" := rRegistrationClassTEMP."Schooling Year";
                                "School Year" := rRegistrationClassTEMP."School Year";
                                "Responsibility Center" := rRegistrationClassTEMP."Responsibility Center";
                                Type := Type::Simple;
                            end;
                        end;
                        if GetType(rRegistrationClassTEMP."Schooling Year") = 1 then begin
                            if rCourseHeader.Get(rRegistrationClassTEMP."Study Plan Code") then begin
                                "Study Plan Code" := rRegistrationClassTEMP."Study Plan Code";
                                "Schooling Year" := rRegistrationClassTEMP."Schooling Year";
                                "School Year" := rRegistrationClassTEMP."School Year";
                                "Responsibility Center" := rRegistrationClassTEMP."Responsibility Center";
                                Type := Type::Multi;
                            end;
                        end;


                        Clear(NoSeriesMgt);
                        rEduConfiguration.Get;
                        rEduConfiguration.TestField("Class Nos.");
                        NoSeriesMgt.GetNextNo(rEduConfiguration."Class Nos.", WorkDate, true);
                        if (Class <> '') and ("School Year" <> '') and ("Schooling Year" <> '') then
                            InsertPermission(xRec."Class Director No.", xRec."Class Secretary No.", "Class Director No.", "Class Secretary No.");

                    end;
                end;
            end;

            trigger OnValidate()
            var
                l_TeacherClass: Record "Teacher Class";
            begin
                if "Study Plan Code" <> '' then begin
                    l_TeacherClass.Reset;
                    l_TeacherClass.SetRange(Class, Class);
                    l_TeacherClass.SetRange("School Year", "School Year");
                    l_TeacherClass.SetFilter("Subject Code", '<>%1', '');
                    if not l_TeacherClass.IsEmpty then
                        Error(Text0011);

                    GetStudyPlan;

                end else begin
                    "Schooling Year" := '';
                    "School Year" := '';
                    "Responsibility Center" := '';
                end;

                if (Class <> '') and ("School Year" <> '') and ("Schooling Year" <> '') then
                    InsertPermission(xRec."Class Director No.", xRec."Class Secretary No.", "Class Director No.", "Class Secretary No.");
            end;
        }
        field(6; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(8; "Class Director No."; Code[20])
        {
            Caption = 'Class Director No.';
            TableRelation = Teacher."No.";

            trigger OnValidate()
            var
                rTeacher: Record Teacher;
            begin
                if rTeacher.Get("Class Director No.") then begin
                    if rTeacher."Last Name" <> '' then
                        "Class Director Name" := rTeacher.Name + ' ' + rTeacher."Last Name"
                    else
                        "Class Director Name" := rTeacher.Name;
                end else
                    "Class Director Name" := '';

                if (Class <> '') and ("School Year" <> '') and ("Schooling Year" <> '') then
                    InsertPermission(xRec."Class Director No.", '', "Class Director No.", '');
            end;
        }
        field(9; "Class Director Name"; Text[191])
        {
            Caption = 'Class Director Name.';
        }
        field(10; "Class Secretary No."; Code[20])
        {
            Caption = 'Class Secretary No.';
            TableRelation = Teacher."No.";

            trigger OnValidate()
            var
                rTeacher: Record Teacher;
            begin
                if rTeacher.Get("Class Secretary No.") then begin
                    if rTeacher."Last Name" <> '' then
                        "Secretary Name" := rTeacher.Name + ' ' + rTeacher."Last Name"
                    else
                        "Secretary Name" := rTeacher.Name;
                end else
                    "Secretary Name" := '';

                if (Class <> '') and ("School Year" <> '') and ("Schooling Year" <> '') then
                    InsertPermission('', xRec."Class Secretary No.", '', "Class Secretary No.");
            end;
        }
        field(11; "Secretary Name"; Text[191])
        {
            Caption = 'Secretary Name';
        }
        field(12; Room; Code[20])
        {
            Caption = 'Room';
            TableRelation = Room."Room Code" WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(14; "Responsibility Center"; Code[10])
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
        field(15; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(16; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = IF ("School Year" = FILTER(<> '')) "Template Timetable"."Template Code" WHERE("School Year" = FIELD("School Year"),
                                                                                                        Type = CONST(Header),
                                                                                                        "Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                /*
                rTimetable.RESET;
                rTimetable.SETRANGE(Class,Class);
                rTimetable.SETRANGE("Study Plan","Study Plan Code");
                rTimetable.SETRANGE("School Year","School Year");
                rTimetable.SETRANGE(Type,Type);
                rTimetable.SETRANGE("Timetable Type",rTimetable."Timetable Type"::Class);
                IF rTimetable.FINDFIRST THEN
                  ERROR(Text0010);
                */

            end;
        }
        field(17; "Class Letter"; Code[2])
        {
            Caption = 'Class Letter';

            trigger OnValidate()
            begin
                rRegistration.Reset;
                rRegistration.SetRange(Class, Class);
                rRegistration.SetRange("School Year", "School Year");
                rRegistration.SetRange("Schooling Year", "Schooling Year");
                rRegistration.SetRange("Responsibility Center", "Responsibility Center");
                rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                rRegistration.ModifyAll("Class Letter", "Class Letter");
            end;
        }
        field(18; "Dimension ID"; Integer)
        {
            Caption = 'Dimension ID';
        }
        field(72; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(73; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
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
        field(73100; Stage; Option)
        {
            Caption = 'Stage';
            OptionCaption = ' ,Primary,ESO,Baccalaureate(common),Baccalaureate (artistic),Baccalaureate (natural science and health),Baccalaureate (humanities and social sciences),Baccalaureate (technology),CF Grade means,CF Grade higher,Continuing education and occupational,Teaching special arrangement,Non-Training,Cycle initiation professional,University courses,Course language,Test access,Other,Infant';
            OptionMembers = " ",Primary,ESO,"Baccalaureate(common)","Baccalaureate (artistic)","Baccalaureate (natural science and health)","Baccalaureate (humanities and social sciences)","Baccalaureate (technology)","CF Grade means","CF Grade higher","Continuing education and occupational","Teaching special arrangement","Non-Training","Cycle initiation professional","University courses","Course language","Test access",Other,Infant;
        }
    }

    keys
    {
        key(Key1; Class, "School Year")
        {
            Clustered = true;
        }
        key(Key2; "School Year", "Schooling Year")
        {
        }
        key(Key3; "School Year", "Schooling Year", "Responsibility Center")
        {
        }
        key(Key4; "School Year", "Schooling Year", "Responsibility Center", Type, "Study Plan Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rRegistrationClass: Record "Registration Class";
        l_MasterTableWEB: Record MasterTableWEB;
    begin
        if rCompanyInformation.Get then;

        /*if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then begin
            l_MasterTableWEB.Reset;
            l_MasterTableWEB.SetRange("Table Type", l_MasterTableWEB."Table Type"::Class);
            l_MasterTableWEB.SetRange(StudyPlanCode, "Study Plan Code");
            l_MasterTableWEB.SetFilter(Codew, '<>%1', Class);
            if l_MasterTableWEB.FindFirst then
                Error(Text0013);
        end;*/


        rRegistrationClass.Reset;
        rRegistrationClass.SetRange(Class, Class);
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
        rRegistrationClass.SetRange(Type, Type);
        if rRegistrationClass.Find('-') then begin
            repeat
                if rRegistrationClass.Status <> rRegistrationClass.Status::" " then
                    Error(Text0006);
            until rRegistrationClass.Next = 0;
        end;

        rTimetable.Reset;
        rTimetable.SetRange(Class, Class);
        rTimetable.SetRange("Study Plan", "Study Plan Code");
        if rTimetable.Find('-') then
            Error(Text0007, rTimetable."Timetable Code");

        rRegistrationClass.Reset;
        rRegistrationClass.SetRange(Class, Class);
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
        rRegistrationClass.SetRange("Study Plan Code", "Study Plan Code");
        rRegistrationClass.SetRange(Type, Type);
        rRegistrationClass.DeleteAll;

        recAspects.Reset;
        recAspects.SetRange(Type, recAspects.Type::Class);
        recAspects.SetRange("School Year", "School Year");
        recAspects.SetRange("Type No.", Class);
        recAspects.DeleteAll;

        rRemarks.Reset;
        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::"Observation Class");
        rRemarks.SetRange(Class, Class);
        rRemarks.SetRange("School Year", "School Year");
        rRemarks.SetRange("Schooling Year", "Schooling Year");
        rRemarks.DeleteAll;


        cInsertNAVMasterTable.DeleteClass(Rec, xRec);


        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."School Year", "School Year");
        rTeacherClass.SetRange(rTeacherClass."Schooling Year", "Schooling Year");
        rTeacherClass.SetRange(rTeacherClass.Class, Class);
        rTeacherClass.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if Class = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Class Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Class Nos.", xRec."No. Series", 0D, Class, "No. Series");
        end;

        if rUserSetup.Get(UserId) then
            if rUserSetup."Education Resp. Ctr. Filter" <> '' then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        "Country/Region Code" := cStudentsRegistration.GetCountry;


        "User Id" := UserId;
        Date := WorkDate;

        cInsertNAVMasterTable.InsertClass(Rec, xRec);
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := WorkDate;

        if "Study Plan Code" <> xRec."Study Plan Code" then
            cInsertNAVMasterTable.DeleteClass(Rec, xRec);

        cInsertNAVMasterTable.ModifyClass(Rec, xRec);
    end;

    trigger OnRename()
    begin
        if "Study Plan Code" <> '' then
            cInsertNAVMasterTable.ModifyClass(Rec, xRec);
        if "Study Plan Code" = '' then
            cInsertNAVMasterTable.DeleteClass(Rec, xRec);
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'Automatic Numbering already was processed.';
        rRegistrationClass: Record "Registration Class";
        cStudentsRegistration: Codeunit "Students Registration";
        Text002: Label 'Do you wish to annul?';
        Text003: Label 'Do you wish to correct?';
        Text004: Label 'You want to register the student?';
        Text005: Label 'You cannot enroll students without a number in a class.';
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text006: Label 'The Student cannot register %1 in more than one Class.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rRegistration: Record Registration;
        rRegistrationIns: Record Registration;
        rCourseHeader: Record "Course Header";
        Text0005: Label 'The numeration is not sequential. Please, remake the numeration.';
        Text0006: Label 'Cannot eliminate the class, processing for this class was already performed.';
        rTimetable: Record Timetable;
        Text0007: Label '"Class" cannot be removed, a timetable %1 was already created for same.';
        Text0008: Label 'Enter the date of annulance for the Student.';
        recAspects: Record Aspects;
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text0009: Label 'The student belongs to another level of education / study plan, to access this feature, please use the functions of the student''s study plan.';
        Text0010: Label 'Cannot change the Template Code as there already is a Timetable with the Code in a class.';
        rTeacherClass: Record "Teacher Class";
        DimMgt: Codeunit DimensionManagement;
        rRemarks: Record Remarks;
        cInsertNAVMasterTable: Codeunit InsertNAVMasterTable;
        Text0011: Label 'Cannot change the Study Plan Code as there already Teachers associated in a class, before change you must delete the teachers.';
        Text0012: Label 'This process will delete students of this Class that status is Transfer or Anulled. Do you want to proceed?';
        rCompanyInformation: Record "Company Information";
        Text0013: Label 'The Class cannot be deleted.';
        Text0014: Label 'The student %1, was not subscribed because he does not have a course associated in the registration Form.';

    //[Scope('OnPrem')]
    procedure AssistEdit(OldClass: Record Class): Boolean
    var
        rClass: Record Class;
    begin
        //rClass := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Class Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Class Nos.", OldClass."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries(Class);
            //Rec := rClass;
            // exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure AssignNumbers()
    var
        VarNumber: Integer;
        l_StudentsTEMP: Record Students temporary;
        l_Students: Record Students;
        l_RegistrationClassTEMP: Record "Registration Class" temporary;
    begin
        if rEduConfiguration.Get then;

        if rEduConfiguration."Order Class" <> 3 then begin
            rRegistrationClass.Reset;
            if rEduConfiguration."Order Class" = rEduConfiguration."Order Class"::Name then
                rRegistrationClass.SetCurrentKey(Name);
            if rEduConfiguration."Order Class" = rEduConfiguration."Order Class"::"Last Name" then
                rRegistrationClass.SetCurrentKey("Last Name");
            if rEduConfiguration."Order Class" = rEduConfiguration."Order Class"::"Last Name 2" then
                rRegistrationClass.SetCurrentKey("Last Name 2");

            rRegistrationClass.SetRange(Class, Class);
            rRegistrationClass.SetRange("School Year", "School Year");
            rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            if rRegistrationClass.Find('-') then begin
                VarNumber := 1;
                repeat
                    if (rRegistrationClass.Status = rRegistrationClass.Status::Subscribed) or
                       (rRegistrationClass.Status = rRegistrationClass.Status::" ") then
                        rRegistrationClass."Class No." := VarNumber
                    else
                        rRegistrationClass."Class No." := 0;

                    rRegistrationClass."User Id" := UserId;
                    rRegistrationClass.Date := WorkDate;
                    rRegistrationClass.Modify;
                    //renumber class No
                    cStudentsRegistration.ReNumberClassNo(Rec, rRegistrationClass);
                    //
                    if (rRegistrationClass.Status = rRegistrationClass.Status::Subscribed) or
                       (rRegistrationClass.Status = rRegistrationClass.Status::" ") then
                        VarNumber += 1;
                until rRegistrationClass.Next = 0;
            end;
        end else begin
            rRegistrationClass.Reset;
            rRegistrationClass.SetRange(Class, Class);
            rRegistrationClass.SetRange("School Year", "School Year");
            rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            if rRegistrationClass.Find('-') then begin
                repeat
                    if l_Students.Get(rRegistrationClass."Student Code No.") then begin
                        l_StudentsTEMP.TransferFields(l_Students);
                        l_StudentsTEMP.Insert;
                    end;
                    l_RegistrationClassTEMP.TransferFields(rRegistrationClass);
                    l_RegistrationClassTEMP.Insert;
                    rRegistrationClass.Delete;
                until rRegistrationClass.Next = 0;
            end;
            l_StudentsTEMP.Reset;
            l_StudentsTEMP.SetCurrentKey("Full Name");
            if l_StudentsTEMP.Find('-') then begin
                VarNumber := 1;
                repeat
                    l_RegistrationClassTEMP.Reset;
                    l_RegistrationClassTEMP.SetRange("Student Code No.", l_StudentsTEMP."No.");
                    if l_RegistrationClassTEMP.Find('-') then begin

                        rRegistrationClass.Init;
                        rRegistrationClass.TransferFields(l_RegistrationClassTEMP);
                        if (l_RegistrationClassTEMP.Status = l_RegistrationClassTEMP.Status::Subscribed) or
                           (l_RegistrationClassTEMP.Status = l_RegistrationClassTEMP.Status::" ") then
                            rRegistrationClass."Class No." := VarNumber
                        else
                            rRegistrationClass."Class No." := 0;

                        rRegistrationClass.Insert;
                        //renumber class No
                        cStudentsRegistration.ReNumberClassNo(Rec, rRegistrationClass);
                        //
                        if (l_RegistrationClassTEMP.Status = l_RegistrationClassTEMP.Status::Subscribed) or
                            (l_RegistrationClassTEMP.Status = l_RegistrationClassTEMP.Status::" ") then
                            VarNumber += 1;

                    end;
                until l_StudentsTEMP.Next = 0;
            end;
        end;

        rRegistrationClass.Reset;
        rRegistrationClass.SetRange(Class, Class);
        rRegistrationClass.SetRange("School Year", "School Year");
        rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
        rRegistrationClass.SetRange("Class No.", 0);
        rRegistrationClass.SetFilter(Status, '%1|%2', rRegistrationClass.Status::Transfer, rRegistrationClass.Status::Annuled);
        if rRegistrationClass.FindFirst then begin
            if Confirm(Text0012, false) then begin
                rRegistrationClass.Reset;
                rRegistrationClass.SetRange(Class, Class);
                rRegistrationClass.SetRange("School Year", "School Year");
                rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
                rRegistrationClass.SetRange("Class No.", 0);
                if rRegistrationClass.Find('-') then begin
                    repeat
                        rRegistrationClass.Delete;
                    until rRegistrationClass.Next = 0;
                end;
            end else
                exit;
        end else begin
            rRegistrationClass.Reset;
            rRegistrationClass.SetRange(Class, Class);
            rRegistrationClass.SetRange("School Year", "School Year");
            rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            rRegistrationClass.SetRange("Class No.", 0);
            if rRegistrationClass.Find('-') then begin
                repeat
                    rRegistrationClass.Delete;
                until rRegistrationClass.Next = 0;
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure fWindow() pData: Date
    var
        Window: Dialog;
        VarData: Date;
        EntryNo: Integer;
        NewEntryNo: Integer;
    begin
        Window.Open(Text0008 + ' #1#########\',
                      VarData);
        EntryNo := 0;
        NewEntryNo := 1;
        while (NewEntryNo > 0) and (EntryNo <> NewEntryNo) do begin
            EntryNo := NewEntryNo;
            case EntryNo of
                1:
                    //NewEntryNo := Window.Input(1, VarData);
                    Window.Update(1, VarData);
            end;
        end;
        Window.Close;

        if VarData = 0D then
            exit(WorkDate)
        else
            exit(VarData);
    end;

    //[Scope('OnPrem')]
    procedure CancelRegistrationClass(pRegistrationClass: Record "Registration Class")
    var
        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        rRegistrationSubjects: Record "Registration Subjects";
        rRegistration: Record Registration;
    begin
        if pRegistrationClass.Status = pRegistrationClass.Status::Subscribed then begin
            if rRegistration.Get(pRegistrationClass."Student Code No.", pRegistrationClass."School Year", "Responsibility Center") then;
            if Class = rRegistration.Class then begin
                if Confirm(Text002, false) then begin
                    pRegistrationClass.Status := pRegistrationClass.Status::Annuled;
                    pRegistrationClass."Status Date" := fWindow;
                    pRegistrationClass."User Id" := UserId;
                    pRegistrationClass.Date := WorkDate;
                    pRegistrationClass.Modify;
                    cStudentsRegistration.InsertStudents(pRegistrationClass);
                    cStudentsRegistration.StudentSubjectsCancel(pRegistrationClass);
                    // INSERT CLASS
                    rRegistration.Reset;
                    rRegistration.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
                    rRegistration.SetRange("School Year", pRegistrationClass."School Year");
                    rRegistration.SetRange("Schooling Year", "Schooling Year");
                    if rRegistration.Find('-') then begin
                        rRegistration.Status := rRegistrationClass.Status::Annuled;
                        rRegistration.Validate(rRegistration."Actual Status", 7); //Anulou Matricula
                        rRegistration.Modify;
                    end;
                    //
                    //Apagar as faltas dos alunos cancelados desta turma
                    cTimetableCalendarMgt.ApagarAlunosFaltas("School Year", "Study Plan Code", Class, 0D, 0D, 0D);
                end;
            end else
                Error(Text0009);
        end;
    end;

    //[Scope('OnPrem')]
    procedure CorrectRegistrationClass(pRegistrationClass: Record "Registration Class")
    var
        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        rRegistrationSubjects: Record "Registration Subjects";
        l_rRegistrationClass: Record "Registration Class";
    begin
        if pRegistrationClass.Status <> pRegistrationClass.Status::" " then begin
            if rRegistration.Get(pRegistrationClass."Student Code No.", pRegistrationClass."School Year", "Responsibility Center") then;
            if Class = rRegistration.Class then begin

                if Confirm(Text003, false) then begin

                    // delete the line if the student was before transfer to another class, then will delete this line of this class

                    if (pRegistrationClass.Status = pRegistrationClass.Status::Transfer)
                    or (pRegistrationClass.Status = pRegistrationClass.Status::Annuled) then begin
                        l_rRegistrationClass.Reset;
                        l_rRegistrationClass.SetFilter(Class, '<>%1', pRegistrationClass.Class);
                        l_rRegistrationClass.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
                        l_rRegistrationClass.SetRange("School Year", pRegistrationClass."School Year");
                        l_rRegistrationClass.SetRange("Schooling Year", pRegistrationClass."Schooling Year");
                        l_rRegistrationClass.SetRange("Study Plan Code", pRegistrationClass."Study Plan Code");
                        l_rRegistrationClass.SetRange(Status, l_rRegistrationClass.Status::" ");
                        if l_rRegistrationClass.FindFirst then
                            l_rRegistrationClass.Delete;
                    end;
                    //

                    pRegistrationClass."Class No." := 0;
                    pRegistrationClass.Status := pRegistrationClass.Status::" ";
                    pRegistrationClass."Status Date" := WorkDate;
                    pRegistrationClass."Transfer Class" := '';
                    pRegistrationClass."Transfer Class" := '';
                    pRegistrationClass."School Name Transfer" := '';
                    pRegistrationClass.Destination := pRegistrationClass.Destination::" ";
                    pRegistrationClass."User Id" := UserId;
                    pRegistrationClass.Date := WorkDate;
                    pRegistrationClass.Modify;
                    cStudentsRegistration.InsertStudents(pRegistrationClass);
                    //Clear Student in Subjects
                    cStudentsRegistration.StudentSubjectsCorrect(pRegistrationClass);
                    // INSERT CLASS
                    rRegistration.Reset;
                    rRegistration.SetRange("Student Code No.", pRegistrationClass."Student Code No.");
                    rRegistration.SetRange("School Year", pRegistrationClass."School Year");
                    rRegistration.SetRange("Schooling Year", "Schooling Year");
                    if rRegistration.FindFirst then begin
                        rRegistration.Class := '';
                        rRegistration."Class No." := 0;
                        rRegistration.Status := rRegistrationClass.Status::" ";
                        rRegistration.Validate(rRegistration."Actual Status", 0);
                        rRegistration."School Name Transfer" := '';
                        rRegistration."Class Letter" := '';
                        rRegistration.Destination := rRegistration.Destination::" ";
                        rRegistration.Modify;
                    end;
                    //
                    cTimetableCalendarMgt.ApagarAlunosFaltas("School Year", "Study Plan Code", Class, 0D, 0D, 0D);
                    DeleteStudentSchoolTransfer(pRegistrationClass."Student Code No.");
                end;
            end else
                Error(Text0009);
        end;
    end;

    //[Scope('OnPrem')]
    procedure SubscribedRegistrationClass()
    var
        cTimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        vOldClassNo: Integer;
        rTeacher: Record Teacher;
        lName: Text[512];
        l_rRegistration: Record Registration;
        l_rClass: Record Class;
        l_Location: Record Location;
        l_Customer: Record Customer;
        l_Students: Record Students;
    begin
        if Confirm(Text004, false) then begin
            Clear(vOldClassNo);
            rRegistrationClass.Reset;
            rRegistrationClass.SetCurrentKey("Class No.");
            rRegistrationClass.SetRange(Class, Class);
            rRegistrationClass.SetRange("School Year", "School Year");
            rRegistrationClass.SetRange("Schooling Year", "Schooling Year");
            rRegistrationClass.SetRange(Status, rRegistrationClass.Status::" ");
            if rRegistrationClass.Find('-') then begin
                //Insert Entity on WEB for the class director
                if rTeacher.Get("Class Director No.") then begin
                    if rTeacher."Last Name 2" <> '' then
                        lName := rTeacher."Last Name" + ' ' + rTeacher."Last Name 2" + ', ' + rTeacher.Name
                    else
                        lName := rTeacher."Last Name" + ', ' + rTeacher.Name;

                    cMasterTableWEB.InsertEntity(1, "Class Director No.", lName, rTeacher."User Name",
                    rTeacher.Password, rTeacher."Responsibility Center", 0);
                end;
                repeat
                    l_rRegistration.Reset;
                    l_rRegistration.SetRange("Student Code No.", rRegistrationClass."Student Code No.");
                    l_rRegistration.SetRange("School Year", rRegistrationClass."School Year");
                    l_rRegistration.SetRange("Schooling Year", "Schooling Year");
                    if Type = Type::Simple then
                        l_rRegistration.SetRange("Study Plan Code", "Study Plan Code")
                    else
                        l_rRegistration.SetRange(Course, "Study Plan Code");
                    if l_rRegistration.FindFirst then begin
                        if vOldClassNo <> rRegistrationClass."Class No." then begin
                            if rRegistrationClass."Class No." = 0 then
                                Error(Text005);

                            // Neste momento vou validar se o aluno já se encontra inscrito noutra turma
                            ValidateStudentSubscribed(rRegistrationClass);

                            //2014.01.03 - para preencher o CR
                            l_rClass.Reset;
                            l_rClass.SetRange("School Year", rRegistrationClass."School Year");
                            l_rClass.SetRange(Class, rRegistrationClass.Class);
                            if l_rClass.Find('+') then begin
                                rRegistrationClass."Responsibility Center" := l_rClass."Responsibility Center";
                                //IT001 - Parque 06.10.2016 - preencher o Cod Localização no Cliente
                                l_Location.Reset;
                                l_Location.SetRange(l_Location."Resp. Center", l_rClass."Responsibility Center");
                                if l_Location.FindFirst then begin
                                    l_Students.Reset;
                                    if l_Students.Get(l_rRegistration."Student Code No.") then begin
                                        l_Customer.Reset;
                                        if l_Customer.Get(l_Students."Customer No.") then begin
                                            l_Customer."Location Code" := l_Location.Code;
                                            l_Customer.Modify;
                                        end;
                                    end;
                                end;
                                //IT001 - en
                            end;
                            //fim

                            rRegistrationClass.Status := rRegistrationClass.Status::Subscribed;
                            rRegistrationClass."Status Date" := WorkDate;
                            rRegistrationClass."User Id" := UserId;
                            rRegistrationClass.Date := WorkDate;
                            rRegistrationClass.Modify;
                            cStudentsRegistration.InsertStudents(rRegistrationClass);
                            //Register Student in Subjects
                            cStudentsRegistration.StudentSubjectsRegister(rRegistrationClass);

                            // INSERT CLASS
                            rRegistration.Reset;
                            rRegistration.SetRange("Student Code No.", rRegistrationClass."Student Code No.");
                            rRegistration.SetRange("School Year", rRegistrationClass."School Year");
                            rRegistration.SetRange("Schooling Year", "Schooling Year");
                            if rRegistration.Find('-') then begin
                                rRegistrationIns.Init;
                                rRegistrationIns.TransferFields(rRegistration);
                                rRegistrationIns.Class := rRegistrationClass.Class;
                                rRegistrationIns."Class No." := rRegistrationClass."Class No.";
                                rRegistrationIns.Status := rRegistrationClass.Status::Subscribed;
                                rRegistrationIns.Validate(rRegistrationIns."Actual Status", 1);//Matriculado;
                                rRegistrationIns."Class Letter" := "Class Letter";
                                l_rClass.Reset;
                                l_rClass.SetRange("School Year", rRegistrationClass."School Year");
                                l_rClass.SetRange(Class, rRegistrationClass.Class);
                                if l_rClass.Find('+') then
                                    rRegistrationIns."Responsibility Center" := l_rClass."Responsibility Center";

                                rRegistration.Delete;
                                rRegistrationIns.Insert;
                            end;
                            //
                        end else
                            Error(Text0005);
                        vOldClassNo := rRegistrationClass."Class No.";
                    end else
                        Message(Text0014, rRegistrationClass."Student Code No.");

                    l_rClass.Reset;
                    l_rClass.SetRange("School Year", rRegistrationClass."School Year");
                    l_rClass.SetRange(Class, rRegistrationClass.Class);
                    if l_rClass.Find('+') then
                        rRegistrationClass."Responsibility Center" := l_rClass."Responsibility Center";
                    rRegistrationClass.Modify;
                until rRegistrationClass.Next = 0;
                Closed := true;
                "User Id" := UserId;
                Date := WorkDate;
                Modify;
            end;
            //Inserir as faltas dos alunos inscritos desta turma no calendário
            //cTimetableCalendarMgt.LancarAlunosFaltas("School Year","Study Plan Code",Class,0D,0D,0D);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateStudentSubscribed(pRegClass: Record "Registration Class")
    var
        rRegClass: Record "Registration Class";
    begin
        rRegClass.Reset;
        rRegClass.SetRange("School Year", pRegClass."School Year");
        rRegClass.SetRange("Study Plan Code", pRegClass."Study Plan Code");
        rRegClass.SetRange("Student Code No.", pRegClass."Student Code No.");
        rRegClass.SetRange(Status, rRegClass.Status::Subscribed);
        rRegClass.SetRange("Responsibility Center", "Responsibility Center");
        if rRegClass.Find('-') then
            //IF rRegClass.COUNT > 1 THEN
            Error(Text006, rRegClass."Student Code No.");
    end;

    //[Scope('OnPrem')]
    procedure GetType(pSchoolingYear: Code[10]): Integer
    var
        l_StructureEducationCountry: Record "Structure Education Country";
    begin
        l_StructureEducationCountry.Reset;
        l_StructureEducationCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        l_StructureEducationCountry.SetRange("Schooling Year", pSchoolingYear);
        if l_StructureEducationCountry.FindSet then
            exit(l_StructureEducationCountry.Type);
    end;

    //[Scope('OnPrem')]
    procedure GetStudyPlan()
    var
        l_SchoolYear: Record "School Year";
        tLectiveYear: Text[1024];
        int: Integer;
        l_StrEducationCountry: Record "Structure Education Country";
        tSchoolingYear: Text[1024];
        l_StudyPlanHeader: Record "Study Plan Header";
        l_CourseHeader: Record "Course Header";
        l_text0001: Label 'The Study Plan/Course Code %1 does not exist for the %2.';
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
        if l_SchoolYear.Find('-') then
            repeat
                tLectiveYear := tLectiveYear + l_SchoolYear."School Year" + ',';
            until l_SchoolYear.Next = 0;

        Clear(int);

        if tLectiveYear <> '' then begin
            int := StrMenu(tLectiveYear);
            l_SchoolYear.Reset;
            l_SchoolYear.SetFilter(Status, '%1|%2', l_SchoolYear.Status::Active, l_SchoolYear.Status::Planning);
            if l_SchoolYear.Find('-') and (int <> 0) then
                l_SchoolYear.Next := int - 1
            else
                exit;
        end;

        Clear(int);

        l_StrEducationCountry.Reset;
        l_StrEducationCountry.SetCurrentKey("Sorting ID");
        if l_StrEducationCountry.FindSet then
            repeat
                tSchoolingYear := tSchoolingYear + l_StrEducationCountry."Schooling Year" + ',';
            until l_StrEducationCountry.Next = 0;

        if tSchoolingYear <> '' then begin
            int := StrMenu(tSchoolingYear);
            l_StrEducationCountry.Reset;
            l_StrEducationCountry.SetCurrentKey("Sorting ID");
            if (l_StrEducationCountry.FindSet) and (int <> 0) then
                l_StrEducationCountry.Next := int - 1
            else
                exit;
        end;



        if (tSchoolingYear <> '') and (tLectiveYear <> '') then begin
            if l_StrEducationCountry.Type = l_StrEducationCountry.Type::Simple then begin
                l_StudyPlanHeader.Reset;
                l_StudyPlanHeader.SetRange(Code, "Study Plan Code");
                l_StudyPlanHeader.SetRange("School Year", l_SchoolYear."School Year");
                l_StudyPlanHeader.SetRange("Schooling Year", l_StrEducationCountry."Schooling Year");
                if l_StudyPlanHeader.FindSet then begin
                    "Schooling Year" := l_StudyPlanHeader."Schooling Year";
                    "School Year" := l_StudyPlanHeader."School Year";
                    "Responsibility Center" := l_StudyPlanHeader."Responsibility Center";
                    Type := Type::Simple;
                end else
                    Error(l_text0001, "Study Plan Code", l_SchoolYear."School Year");

            end;
            if l_StrEducationCountry.Type = l_StrEducationCountry.Type::Multi then begin
                l_CourseHeader.SetRange(Code, "Study Plan Code");
                if l_CourseHeader.FindSet then begin
                    "Schooling Year" := l_StrEducationCountry."Schooling Year";
                    "School Year" := l_SchoolYear."School Year";
                    "Responsibility Center" := l_CourseHeader."Responsibility Center";
                    Type := Type::Multi;
                end else
                    Error(l_text0001, "Study Plan Code", l_SchoolYear."School Year");
            end;
            Clear(NoSeriesMgt);
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Class Nos.");
            NoSeriesMgt.GetNextNo(rEduConfiguration."Class Nos.", WorkDate, true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure InsertPermission(pDirectorOld: Code[20]; pSecretaryOld: Code[20]; pDirectorNew: Code[20]; pSecretaryNew: Code[20])
    var
        rTeacherClass: Record "Teacher Class";
    begin
        //Director
        if pDirectorOld <> '' then begin
            rTeacherClass.Reset;
            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
            rTeacherClass.SetRange(rTeacherClass.User, pDirectorOld);
            rTeacherClass.SetRange(rTeacherClass."School Year", "School Year");
            rTeacherClass.SetRange(rTeacherClass.Class, Class);
            //  rTeacherClass.SETRANGE(rTeacherClass."Schooling Year","Schooling Year");
            rTeacherClass.SetRange(rTeacherClass."Subject Code", '');
            if rTeacherClass.FindFirst then
                rTeacherClass.Delete(true);
        end;

        if pDirectorNew <> '' then begin
            rTeacherClass.Reset;
            rTeacherClass.Init;
            rTeacherClass."User Type" := rTeacherClass."User Type"::Teacher;
            rTeacherClass.Validate(rTeacherClass.User, pDirectorNew);
            rTeacherClass."School Year" := "School Year";
            rTeacherClass.Class := Class;
            rTeacherClass."Schooling Year" := "Schooling Year";
            //rTeacherClass.Turn :=
            rTeacherClass."Allow Assign Evaluations" := true;
            rTeacherClass."Allow Calc. Final Assess." := true;
            rTeacherClass."Allow Stu. Global Observations" := true;
            rTeacherClass."Allow Assign Incidence" := true;
            rTeacherClass."Allow Justify Incidence" := true;
            rTeacherClass."Allow Summary" := true;
            rTeacherClass.Insert(true);
        end;

        //Secretary
        if pSecretaryOld <> '' then begin
            rTeacherClass.Reset;
            rTeacherClass.SetRange(rTeacherClass."User Type", rTeacherClass."User Type"::Teacher);
            rTeacherClass.SetRange(rTeacherClass.User, pSecretaryOld);
            rTeacherClass.SetRange(rTeacherClass."School Year", "School Year");
            rTeacherClass.SetRange(rTeacherClass.Class, Class);
            rTeacherClass.SetRange(rTeacherClass."Schooling Year", "Schooling Year");
            rTeacherClass.SetRange(rTeacherClass."Subject Code", '');
            if rTeacherClass.FindFirst then
                rTeacherClass.Delete(true);
        end;
        if pSecretaryNew <> '' then begin
            rTeacherClass.Reset;
            rTeacherClass.Init;
            rTeacherClass."User Type" := rTeacherClass."User Type"::Teacher;
            rTeacherClass.Validate(rTeacherClass.User, pSecretaryNew);
            rTeacherClass."School Year" := "School Year";
            rTeacherClass.Class := Class;
            rTeacherClass."Schooling Year" := "Schooling Year";
            //rTeacherClass.Turn :=
            rTeacherClass."Allow Assign Evaluations" := true;
            rTeacherClass."Allow Calc. Final Assess." := true;
            rTeacherClass."Allow Stu. Global Observations" := true;
            rTeacherClass."Allow Assign Incidence" := true;
            rTeacherClass."Allow Justify Incidence" := true;
            rTeacherClass."Allow Summary" := true;
            rTeacherClass.Insert(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        //DimMgt.SaveDefaultDim(DATABASE::Class,FORMAT("Dimension ID"),FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Class, Class, FieldNumber, ShortcutDimCode);
        Modify;
    end;

    //[Scope('OnPrem')]
    procedure DeleteStudentSchoolTransfer(pStudentCode: Code[20])
    var
        l_StudentsTransfersSchool: Record "Students Transfers School";
    begin
        l_StudentsTransfersSchool.Reset;
        l_StudentsTransfersSchool.SetRange("Student Code", pStudentCode);
        l_StudentsTransfersSchool.SetRange("School Year", "School Year");
        l_StudentsTransfersSchool.SetRange("Schooling Year", "Schooling Year");
        l_StudentsTransfersSchool.SetRange(Transfer, l_StudentsTransfersSchool.Transfer::"To");
        l_StudentsTransfersSchool.DeleteAll;
    end;
    /*
        //[Scope('OnPrem')]
        procedure OpenFile(WindowTitle: Text[50]; DefaultFileName: Text[250]; DefaultFileType: Option " ",Text,Excel,Word,Custom; FilterString: Text[250]; "Action": Option Open,Save; var FileNameImport: Text[250]; var Extension: Code[50]; var Path: Text[250]) returnText: Text[260]
        var
            Text0031: Label '.txt';
            Text0032: Label '.xls';
            Text0033: Label '.doc';
            pos: Integer;
            fileName: Text[250];
            FileMgt: Codeunit "File Management";
        begin

            /*CommonDialogControl.FileName := DefaultFileName;
            CommonDialogControl.DialogTitle := WindowTitle;

            IF DefaultFileType = DefaultFileType::Custom THEN BEGIN
              IF STRPOS(UPPERCASE(FilterString),'.DOC') > 0 THEN
                DefaultFileType := DefaultFileType::Word;
              IF STRPOS(UPPERCASE(FilterString),'.XL') > 0 THEN
                DefaultFileType := DefaultFileType::Excel;
            END;


            CASE DefaultFileType OF
              DefaultFileType::Text:
                CommonDialogControl.Filter := Text0031;
              DefaultFileType::Excel:
                CommonDialogControl.Filter := Text0032;
              DefaultFileType::Word:
                CommonDialogControl.Filter := Text0033;
              DefaultFileType::Custom:
                CommonDialogControl.Filter := FilterString;
            END;

            CommonDialogControl.InitDir := DefaultFileName;*/ /*
            if Action = Action::Open then
                //CommonDialogControl.ShowOpen
                FileNameImport := FileMgt.OpenFileDialog(WindowTitle, DefaultFileName, FilterString)
            else
                //CommonDialogControl.ShowSave;
                FileNameImport := FileMgt.SaveFileDialog(WindowTitle, DefaultFileName, FilterString);

            returnText := FileNameImport;

            //FileNameImport := CommonDialogControl.FileName;
            if FileNameImport <> '' then begin
                Path := FileNameImport;
                fileName := FileNameImport;
                while StrPos(fileName, '.') <> 0 do begin
                    fileName := CopyStr(fileName, StrPos(fileName, '.') + 1);
                end;
                Extension := fileName;
                while StrPos(FileNameImport, '\') <> 0 do begin
                    FileNameImport := CopyStr(FileNameImport, StrPos(FileNameImport, '\') + 1);
                end;
                FileNameImport := CopyStr(FileNameImport, 1, StrPos(FileNameImport, '.') - 1);
            end;

            //EXIT(CommonDialogControl.FileName);

        end;*/
}

