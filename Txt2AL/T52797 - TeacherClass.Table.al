table 52797 "Teacher Class"
{
    Caption = 'Teacher Class';

    fields
    {
        field(1; "User Type"; Option)
        {
            Caption = 'User Type';
            OptionCaption = 'Teacher,Employee';
            OptionMembers = Teacher,Employee;
        }
        field(2; User; Code[20])
        {
            Caption = 'User';
            NotBlank = true;
            //TableRelation = IF ("User Type" = CONST(Teacher)) Teacher."No."
            //ELSE
            //IF ("User Type" = CONST(Employee)) Table31003035.Field1;
            TableRelation = Teacher."No.";

            trigger OnLookup()
            begin
                if "User Type" = "User Type"::Teacher then begin
                    rSubjects.Reset;
                    rSubjects.SetRange(Type, rSubjects.Type::Subject);
                    rSubjects.SetRange(Code, "Subject Code");
                    if rSubjects.FindSet then begin
                        if rSubjects.Department = '' then begin
                            rTeacher.Reset;
                            if rTeacher.FindSet then
                                if PAGE.RunModal(PAGE::"Teacher List", rTeacher) = ACTION::LookupOK then
                                    Validate(User, rTeacher."No.");
                        end;
                        if rSubjects.Department <> '' then begin
                            rSubjectsGroup.Reset;
                            rSubjectsGroup.SetRange(Type, rSubjectsGroup.Type::Teacher);
                            rSubjectsGroup.SetRange(Code, rSubjects.Department);
                            if rSubjectsGroup.FindSet then begin
                                if PAGE.RunModal(PAGE::"Teacher Subjects Group", rSubjectsGroup) = ACTION::LookupOK then
                                    Validate(User, rSubjectsGroup."Teacher No.");
                                ;
                            end;
                        end;
                    end;
                end;

                /*F "User Type" = "User Type"::Employee THEN BEGIN
                 rEmployee.RESET;
                 IF rEmployee.FINDSET THEN
                   IF FORM.RUNMODAL(FORM::Page31003036,rEmployee) = ACTION::LookupOK THEN
                     VALIDATE(User,rEmployee."No.");
                END;*/

            end;

            trigger OnValidate()
            begin

                if "User Type" = "User Type"::Teacher then begin
                    if rTeacher.Get(User) then begin
                        "Full Name" := rTeacher.Name;
                        "NAV User Id" := rTeacher."NAV User Id";
                        "Responsibility Center" := rTeacher."Responsibility Center";
                        "Last Name" := rTeacher."Last Name";
                        "Last Name 2" := rTeacher."Last Name 2";
                        "User Name" := rTeacher."User Name";
                        Password := rTeacher.Password;
                        "Use GIC" := rTeacher."Use GIC";
                        "Use WEB" := rTeacher."Use WEB";
                        Name := rTeacher.Name;
                        UpdateFullName;
                    end;
                    /*END ELSE BEGIN
                      IF rEmployee.GET(User) THEN BEGIN
                        "Full Name" := rEmployee.Name;
                        "NAV User Id" := rEmployee."NAV User Id";
                        "Responsibility Center" := rEmployee."Responsibility Center";
                        "User Name" := rEmployee."User Name";
                        Password := rEmployee.Password;
                        "Use GIC" := rEmployee."Use GIC";
                        "Use WEB" := rEmployee."Use WEB";
                        Name :=  rEmployee.Name;
                        UpdateFullName;
                      END;*/
                end;

            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Full Name"; Text[191])
        {
            Caption = 'Full Name';
        }
        field(5; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(6; "Responsibility Center"; Code[10])
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
        field(8; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;

            trigger OnLookup()
            begin
                TestField("School Year");
                TestField("Schooling Year");
                rClass.Reset;
                rClass.SetRange(rClass."School Year", "School Year");
                rClass.SetRange(rClass."Schooling Year", "Schooling Year");
                if rClass.FindSet then
                    if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then begin
                        Class := rClass.Class;
                        Type := rClass.Type;
                    end;
            end;

            trigger OnValidate()
            begin
                if Class <> '' then begin
                    TestField("School Year");
                    TestField("Schooling Year");
                    rClass.Reset;
                    if rClass.Get(Class, "School Year") then
                        Type := rClass.Type;
                end;
            end;
        }
        field(9; "Type Subject"; Option)
        {
            Caption = 'Subject Type';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non lective Component","Non scholar hours";

            trigger OnValidate()
            begin
                if ("User Type" = "User Type"::Teacher) and ("Type Subject" = "Type Subject"::"Non lective Component") then
                    Error(Text0007);
            end;
        }
        field(10; "Subject Code"; Code[20])
        {
            Caption = 'Subject Code';
            TableRelation = IF ("Type Subject" = CONST(Subject)) Subjects.Code WHERE(Type = FILTER(Subject))
            ELSE
            IF ("Type Subject" = CONST("Non lective Component")) Subjects.Code WHERE(Type = FILTER("Non scholar component"))
            ELSE
            IF ("Type Subject" = CONST("Non scholar hours")) Subjects.Code WHERE(Type = FILTER("Non scholar hours"));

            trigger OnLookup()
            var
                rSubjects: Record Subjects;
                rStudyPlanLines: Record "Study Plan Lines";
                rCourseLines: Record "Course Lines";
                rCourseLinesTEMP: Record "Course Lines" temporary;
                rClass: Record Class;
                rStruEduCountry: Record "Structure Education Country";
                l_rStruEduCountry: Record "Structure Education Country";
                cStudentsRegistration: Codeunit "Students Registration";
            begin
                if "Subject Code" <> '' then begin
                    TestField("Type Subject");
                    if ("Type Subject" = "Type Subject"::Subject) then begin

                        TestField("School Year");
                        TestField(Class);
                        rClass.Reset;
                        if rClass.Get(Class, "School Year") then
                            varStudyPlan := rClass."Study Plan Code";



                        if (Type = Type::Simple) and ("Type Subject" = "Type Subject"::Subject) then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, varStudyPlan);
                            rStudyPlanLines.SetRange("School Year", "School Year");
                            if rStudyPlanLines.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Study Plan Subjects", rStudyPlanLines) = ACTION::LookupOK then begin
                                    "Subject Code" := rStudyPlanLines."Subject Code";
                                    "Subject Description" := rStudyPlanLines."Subject Description";
                                    "Sub-Subject Code" := '';
                                end;
                            end;
                        end;


                        if (Type = Type::Multi) and ("Type Subject" = "Type Subject"::Subject) then begin

                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.DeleteAll;

                            //Quadriennal
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, varStudyPlan);
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Anual
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, varStudyPlan);
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                            rCourseLines.SetRange("Schooling Year Begin", "Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Bienal E Triennal
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            //rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            rStruEduCountry.SetRange("Schooling Year", "Schooling Year");
                            if rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, varStudyPlan);
                                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", "Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                                //ELSE BEGIN
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Class, "School Year") - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, varStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Class, "School Year") - 2);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, varStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                //l_rStruEduCountry.SETRANGE(Level,rStruEduCountry.Level::Secondary);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Class, "School Year") - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, varStudyPlan);
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                            end;


                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.SetRange(Code, varStudyPlan);
                            if rCourseLinesTEMP.Find('-') then
                                if PAGE.RunModal(PAGE::"Study Course Subjects", rCourseLinesTEMP) = ACTION::LookupOK then begin
                                    "Subject Code" := rCourseLinesTEMP."Subject Code";
                                    "Subject Description" := rCourseLinesTEMP."Subject Description";
                                    "Sub-Subject Code" := '';
                                end;
                        end;


                    end else begin

                        if "Type Subject" = "Type Subject"::"Non lective Component" then begin
                            rSubjects.Reset;
                            rSubjects.SetRange(rSubjects.Type, rSubjects.Type::"Non scholar component");
                            if rSubjects.Find('-') then
                                if PAGE.RunModal(PAGE::"Non lective component List", rSubjects) = ACTION::LookupOK then begin
                                    "Subject Code" := rSubjects.Code;
                                    "Subject Description" := rSubjects.Description;
                                    "Sub-Subject Code" := '';
                                end;
                        end;

                        if "Type Subject" = "Type Subject"::"Non scholar hours" then begin
                            rSubjects.Reset;
                            rSubjects.SetRange(rSubjects.Type, rSubjects.Type::"Non scholar hours");
                            if rSubjects.Find('-') then
                                if PAGE.RunModal(PAGE::"Non Scholar hours", rSubjects) = ACTION::LookupOK then begin
                                    "Subject Code" := rSubjects.Code;
                                    "Subject Description" := rSubjects.Description;
                                    "Sub-Subject Code" := '';
                                end;
                        end;

                    end;
                    if rSubjects.Get("Type Subject", "Subject Code") then
                        "Subject Group" := rSubjects.Department;
                end;
            end;

            trigger OnValidate()
            var
                rStudyPlanLines: Record "Study Plan Lines";
                rCourseLines: Record "Course Lines";
            begin
                if "Subject Code" <> '' then begin
                    TestField("Schooling Year");
                    TestField(Class);

                    TestField("Type Subject");
                    if ("Type Subject" = "Type Subject"::Subject) then begin

                        TestField("School Year");
                        TestField(Class);
                        rClass.Reset;
                        if rClass.Get(Class, "School Year") then
                            varStudyPlan := rClass."Study Plan Code";

                        if (Type = Type::Simple) and ("Type Subject" = "Type Subject"::Subject) then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, varStudyPlan);
                            rStudyPlanLines.SetRange("School Year", "School Year");
                            rStudyPlanLines.SetRange("Schooling Year", "Schooling Year");
                            rStudyPlanLines.SetRange("Subject Code", "Subject Code");
                            if rStudyPlanLines.FindFirst then begin
                                "Subject Description" := rStudyPlanLines."Subject Description";
                                "Sub-Subject Code" := '';
                            end else
                                Error(Text0003);
                        end;

                        if (Type = Type::Multi) and ("Type Subject" = "Type Subject"::Subject) then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, varStudyPlan);
                            rCourseLines.SetRange("Subject Code", "Subject Code");
                            if rCourseLines.FindFirst then begin
                                "Subject Description" := rCourseLines."Subject Description";
                                "Sub-Subject Code" := '';
                            end else
                                Error(Text0003);
                        end;


                    end else begin

                        if "Type Subject" = "Type Subject"::"Non lective Component" then begin
                            rSubjects.Reset;
                            rSubjects.SetRange(rSubjects.Type, rSubjects.Type::"Non scholar component");
                            rSubjects.SetRange(rSubjects.Code, "Subject Code");
                            if rSubjects.FindFirst then begin
                                "Subject Description" := rSubjects.Description;
                                "Sub-Subject Code" := '';
                            end else
                                Error(Text0003);
                        end;

                        if "Type Subject" = "Type Subject"::"Non scholar hours" then begin
                            rSubjects.Reset;
                            rSubjects.SetRange(rSubjects.Type, rSubjects.Type::"Non scholar hours");
                            rSubjects.SetRange(rSubjects.Code, "Subject Code");
                            if rSubjects.FindFirst then begin
                                "Subject Description" := rSubjects.Description;
                                "Sub-Subject Code" := '';
                            end else
                                Error(Text0003);
                        end;
                    end;
                    if rSubjects.Get("Type Subject", "Subject Code") then
                        "Subject Group" := rSubjects.Department;

                end else begin
                    "Type Subject" := 0;
                    "Subject Group" := '';
                    "Subject Description" := '';
                    "Sub-Subject Code" := '';
                    "Sub-Subject Description" := '';
                end;
            end;
        }
        field(11; "Subject Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Subjects Group".Code WHERE(Type = FILTER(Subject));
        }
        field(13; "Subject Description"; Text[64])
        {
            Caption = 'Subject Description';
        }
        field(14; "Sub-Subject Code"; Code[20])
        {
            Caption = 'Sub-Subject Code';

            trigger OnLookup()
            var
                rStudyPlanSubLines: Record "Study Plan Sub-Subjects Lines";
                rStudyPlanHeader: Record "Study Plan Header";
                rCourseHeader: Record "Course Header";
            begin
                rClass.Reset;
                if rClass.Get(Class, "School Year") then
                    varStudyPlan := rClass."Study Plan Code";

                if Type = Type::Simple then begin
                    rStudyPlanHeader.Reset;
                    if (rStudyPlanHeader.Get(varStudyPlan)) and (rStudyPlanHeader."Sub-subjects for assess. only" = true) then
                        Error(Text0006);
                end;

                if Type = Type::Multi then begin
                    rCourseHeader.Reset;
                    if (rCourseHeader.Get(varStudyPlan)) and (rCourseHeader."Sub-subjects for assess. only" = true) then
                        Error(Text0006);
                end;


                TestField("Type Subject", "Type Subject"::Subject);
                TestField("Subject Code");

                rClass.Reset;
                if rClass.Get(Class, "School Year") then
                    varStudyPlan := rClass."Study Plan Code";


                rStudyPlanSubLines.Reset;
                if Type = Type::Simple then rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Type, rStudyPlanSubLines.Type::"Study Plan");
                if Type = Type::Multi then rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Type, rStudyPlanSubLines.Type::Course);
                rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Code, varStudyPlan);
                rStudyPlanSubLines.SetRange(rStudyPlanSubLines."Schooling Year", "Schooling Year");
                rStudyPlanSubLines.SetRange(rStudyPlanSubLines."Subject Code", "Subject Code");
                if PAGE.RunModal(PAGE::"Study Plan Sub-Subjects List", rStudyPlanSubLines) = ACTION::LookupOK then
                    Validate("Sub-Subject Code", rStudyPlanSubLines."Sub-Subject Code");
            end;

            trigger OnValidate()
            var
                rStudyPlanSubLines: Record "Study Plan Sub-Subjects Lines";
                rStudyPlanHeader: Record "Study Plan Header";
                rCourseHeader: Record "Course Header";
            begin
                if "Sub-Subject Code" <> '' then begin
                    TestField("Schooling Year");
                    TestField(Class);
                    TestField("Subject Code");

                    rClass.Reset;
                    if rClass.Get(Class, "School Year") then
                        varStudyPlan := rClass."Study Plan Code";

                    if Type = Type::Simple then begin
                        rStudyPlanHeader.Reset;
                        if (rStudyPlanHeader.Get(varStudyPlan)) and (rStudyPlanHeader."Sub-subjects for assess. only" = true) then
                            Error(Text0006);
                    end;

                    if Type = Type::Multi then begin
                        rCourseHeader.Reset;
                        if (rCourseHeader.Get(varStudyPlan)) and (rCourseHeader."Sub-subjects for assess. only" = true) then
                            Error(Text0006);
                    end;


                    TestField("Type Subject", "Type Subject"::Subject);
                    TestField("Subject Code");

                    rClass.Reset;
                    if rClass.Get(Class, "School Year") then
                        varStudyPlan := rClass."Study Plan Code";


                    rStudyPlanSubLines.Reset;
                    if Type = Type::Simple then rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Type, rStudyPlanSubLines.Type::"Study Plan");
                    if Type = Type::Multi then rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Type, rStudyPlanSubLines.Type::Course);
                    rStudyPlanSubLines.SetRange(rStudyPlanSubLines.Code, varStudyPlan);
                    rStudyPlanSubLines.SetRange(rStudyPlanSubLines."Schooling Year", "Schooling Year");
                    rStudyPlanSubLines.SetRange(rStudyPlanSubLines."Subject Code", "Subject Code");
                    rStudyPlanSubLines.SetRange(rStudyPlanSubLines."Sub-Subject Code", "Sub-Subject Code");
                    if rStudyPlanSubLines.FindSet then
                        "Sub-Subject Description" := rStudyPlanSubLines."Sub-Subject Description"
                    else
                        Error(Text0005);
                end else begin
                    "Sub-Subject Description" := '';
                end;
            end;
        }
        field(15; "Sub-Subject Description"; Text[64])
        {
            Caption = 'Sub-Subject Description';
        }
        field(20; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";

            trigger OnValidate()
            begin
                if "Schooling Year" <> xRec."Schooling Year" then begin
                    Class := '';
                    Clear("Subject Code");
                    Clear("Subject Group");
                end;
            end;
        }
        field(21; "NAV User Id"; Code[20])
        {
            Caption = 'NAV User Id';
            TableRelation = User;

            trigger OnLookup()
            begin
                LoginMgt.DisplayUserInformation("NAV User Id");
            end;

            trigger OnValidate()
            begin
                UserSel.ValidateUserName("NAV User Id");
            end;
        }
        field(22; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code;
        }
        field(23; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(30; "Allow Assign Evaluations"; Boolean)
        {
            Caption = 'Assign Evaluations';

            trigger OnValidate()
            begin
                /*
                IF "Allow Assign Evaluations" THEN BEGIN
                  rTeacherClass.RESET;
                  rTeacherClass.SETRANGE("School Year","School Year");
                  rTeacherClass.SETRANGE(Class,Class);
                  rTeacherClass.SETRANGE("Subject Code","Subject Code");
                  rTeacherClass.SETRANGE("Sub-Subject Code","Sub-Subject Code");
                  rTeacherClass.SETRANGE("Allow Assign Evaluations","Allow Assign Evaluations");
                  IF rTeacherClass.FIND('-') THEN BEGIN
                    IF rTeacherClass.COUNT =1 THEN
                       ERROR(Text0001);
                    END;
                END;
                */

            end;
        }
        field(31; "Allow Calc. Final Assess."; Boolean)
        {
            Caption = 'Final Assess.';
        }
        field(32; "Allow Stu. Global Observations"; Boolean)
        {
            Caption = 'Student Global Observations';
        }
        field(35; "Allow Assign Incidence"; Boolean)
        {
            Caption = 'Assign Incidence';
        }
        field(36; "Allow Justify Incidence"; Boolean)
        {
            Caption = 'Justify Incidences';
        }
        field(37; "Allow Summary"; Boolean)
        {
            Caption = 'Summary';
        }
        field(73100; "Last Name"; Text[30])
        {
            Caption = 'First Family Name';
        }
        field(73101; "Last Name 2"; Text[30])
        {
            Caption = 'Second Family Name';
        }
        field(73103; "User Name"; Text[30])
        {
            Caption = 'User Name';
            Description = 'WEB';

            trigger OnValidate()
            var
                cValidateUserID: Codeunit "Validate User ID";
            begin
            end;
        }
        field(73104; Password; Text[30])
        {
            Caption = 'Password';
            Description = 'WEB';
        }
        field(73106; "Use GIC"; Boolean)
        {
            Caption = 'Use GIC';
            Description = 'WEB';
        }
        field(73107; "Use WEB"; Boolean)
        {
            Caption = 'Use WEB';
            Description = 'WEB';
        }
        field(73108; Name; Text[128])
        {
            Caption = 'Name';
            Description = 'WEB';
        }
    }

    keys
    {
        key(Key1; "User Type", User, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; User, "Subject Code", Class)
        {
        }
        key(Key3; "School Year", Class, "Subject Code", "Sub-Subject Code", "Allow Assign Evaluations")
        {
        }
        key(Key4; "School Year", User, Class)
        {
        }
        key(Key5; "School Year", User, "Subject Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //cMasterTableWEB.DeleteEntityTeacher(1,Rec,xRec);
        cMasterTableWEB.DeleteTeacherClass(Rec, xRec);
    end;

    trigger OnInsert()
    var
        lName: Text[1024];
    begin
        rTeacherClass.Reset;
        rTeacherClass.SetRange(rTeacherClass."User Type", "User Type");
        rTeacherClass.SetRange(rTeacherClass.User, User);
        if rTeacherClass.Find('+') then
            "Line No." := rTeacherClass."Line No." + 10000
        else
            "Line No." := 10000;


        if "Last Name 2" <> '' then
            lName := "Last Name" + ' ' + "Last Name 2" + ', ' + Name
        else
            lName := "Last Name" + ', ' + Name;

        rSubjects.Reset;
        rSubjects.SetRange(Type, rSubjects.Type::Subject);
        rSubjects.SetRange(Code, "Subject Code");
        if rSubjects.FindFirst then
            "Subject Description" := rSubjects.Description;

        rClass.Reset;
        if rClass.Get(Class, "School Year") then
            Type := rClass.Type;

        if "Use WEB" then begin
            cMasterTableWEB.InsertEntity(1, User, lName, "User Name", Password, "Responsibility Center", 0);
            cMasterTableWEB.InsertTeacherClass(Rec, xRec);
        end;
    end;

    trigger OnModify()
    begin
        cMasterTableWEB.ModifyEntityTeacher(1, Rec, xRec);
        if "Use WEB" then begin
            cMasterTableWEB.ModifyTeacherClass(Rec, xRec);
        end;
        if not "Use WEB" and xRec."Use WEB" then begin
            cMasterTableWEB.DeleteTeacherClass(Rec, xRec);
        end;

        TestField("School Year");
        if Class <> '' then
            TestField("Schooling Year");

        if "Subject Code" <> '' then begin
            TestField("Schooling Year");
            TestField(Class);
        end;

        if "Sub-Subject Code" <> '' then begin
            TestField("Schooling Year");
            TestField(Class);
            TestField("Subject Code");
        end;
    end;

    trigger OnRename()
    begin
        /*rCompanyInformation.Get;
        if rCompanyInformation."Connection Type" <> rCompanyInformation."Connection Type"::" " then
            Error(Text0008, TableCaption);*/
    end;

    var
        rClass: Record Class;
        rTeacher: Record Teacher;
        RespCenter: Record "Responsibility Center";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        LoginMgt: Codeunit "User Management";
        UserSel: Codeunit "User Selection";
        rTeacherClass: Record "Teacher Class";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        rSubjects: Record Subjects;
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        Text0001: Label 'Only one Teacher is allowed to insert classification';
        Text0002: Label 'Error selecting the Teacher. Resposibility Centers are not the same.';
        varStudyPlan: Code[20];
        Text0003: Label 'Subject Code is invalid.';
        Text0005: Label 'Sub-Subject Code is invalid.';
        Text0006: Label 'You cannot assign sub-subjects.';
        Text0007: Label 'This option is not available to the User Type Teacher.';
        Text0008: Label 'You cannot rename a %1.';
        rSubjectsGroup: Record "Subjects Group";
        rCompanyInformation: Record "Company Information";

    //[Scope('OnPrem')]
    procedure GetNoStructureCountry(pClass: Code[20]; pSchoolYear: Code[9]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if rClass.Get(pClass, pSchoolYear) then;

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.FindFirst then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetSchoolYear(): Code[9]
    var
        l_SchoolYear: Record "School Year";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetRange(Status, l_SchoolYear.Status::Active);
        if l_SchoolYear.FindSet then
            exit(l_SchoolYear."School Year");
    end;

    //[Scope('OnPrem')]
    procedure UpdateFullName()
    var
        rEduConfiguration: Record "Edu. Configuration";
    begin
        if rEduConfiguration.Get then begin
            if rEduConfiguration."Full Name syntax" = 0 then begin
                if "Last Name 2" <> '' then
                    "Full Name" := "Last Name" + ' ' + "Last Name 2" + ', ' + Name
                else
                    "Full Name" := "Last Name" + ', ' + Name;
            end else begin
                if "Last Name 2" <> '' then
                    "Full Name" := Name + ' ' + "Last Name 2" + ' ' + "Last Name"
                else
                    "Full Name" := Name + ' ' + "Last Name";
            end;

        end;
    end;
}

