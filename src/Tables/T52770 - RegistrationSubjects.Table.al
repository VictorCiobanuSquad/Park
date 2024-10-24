table 52770 "Registration Subjects"
{
    Caption = 'Registration Subjects';
    Permissions = TableData "Student Subjects Entry" = rimd;

    fields
    {
        field(1; "Student Code No."; Code[20])
        {
            Caption = 'Student Code No.';
            TableRelation = Students."No.";
        }
        field(2; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year";
        }
        field(3; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Country = FIELD("Country/Region Code"));
        }
        field(4; "Study Plan Code"; Code[20])
        {
            Caption = 'Study Plan Code';
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"),
                                                                                     "Schooling Year" = FIELD("Schooling Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;
        }
        field(5; "Subjects Code"; Code[10])
        {
            Caption = 'Subjects Code';
            TableRelation = Subjects.Code;

            trigger OnValidate()
            begin
                // Validação para inserir os Serviços Obrigatórios
                if (xRec."Subjects Code" <> "Subjects Code") and (Enroled) then
                    ValidateServicePlan(Rec)
                else
                    DeleteServicePlan(Rec);
            end;
        }
        field(6; Description; Text[64])
        {
            Caption = 'Description';
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; Enroled; Boolean)
        {
            Caption = 'Enroled';

            trigger OnValidate()
            begin

                if Status = Status::Subscribed then
                    Error(Text002);


                if Enroled then
                    ValidateServicePlan(Rec)
                else
                    DeleteServicePlan(Rec);
            end;
        }
        field(9; "Mandatory/Optional Type"; Option)
        {
            Caption = 'Mandatory/Optional Type';
            OptionCaption = ' ,Required,Optional,Free Choice';
            OptionMembers = " ",Required,Optional,"Free Choice";
        }
        field(10; "Curriculum Type"; Option)
        {
            Caption = 'Curriculum Type';
            OptionCaption = ' ,Disciplinary,Non disciplinary,Curriculum Enrichment,General,Specific';
            OptionMembers = " ",Disciplinary,"Non disciplinary","Curriculum Enrichment",General,Specific;
        }
        field(11; "Evaluation Type"; Option)
        {
            Caption = 'Evaluation Type';
            OptionCaption = ' ,Qualitative,Quantitative,None Qualification,Mixed-Qualification';
            OptionMembers = " ",Qualitative,Quantitative,"None Qualification","Mixed-Qualification";
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
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(21; "Maximum Injustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';
        }
        field(22; "Assessment Code"; Code[20])
        {
            Caption = 'Assessment Code';
            TableRelation = "Rank Group".Code WHERE("Evaluation Type" = FIELD("Evaluation Type"));
        }
        field(23; "Minimum Classification Level"; Code[20])
        {
            Caption = 'Minimum Classification Level';
            TableRelation = "Classification Level"."Classification Level Code" WHERE("Classification Group Code" = FIELD("Assessment Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(24; "Characterise Subjects"; Option)
        {
            Caption = 'Characterise Subjects';
            OptionCaption = ' ,Annual,Biennial,Triennial,Quadriennal';
            OptionMembers = " ",Annual,Biennial,Triennial,Quadriennal;
        }
        field(25; "Maximum Justified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Justified Absence';
        }
        field(26; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class;
        }
        field(27; "Class No."; Integer)
        {
            Caption = 'Class No.';
        }
        field(28; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Subscribed,Transfer,Annulled,Excluded by Incidences';
            OptionMembers = " ",Subscribed,Transfer,Cancelled,"Excluded by Incidences";
        }
        field(29; "Attendance Situation"; Option)
        {
            Caption = 'Attendance Situation';
            Description = 'ENES';
            Editable = false;
            OptionCaption = ' ,Approved,Admitted to Exam,Registration cancellation,Excluded by Incidences,Test Failure,Excluded before 3rd period,Failed before 3rd period,Annulled after deadline';
            OptionMembers = " ",AP,AE,AM,EF,RF,E0,R0,A1;
        }
        field(32; "Status Date"; Date)
        {
            Caption = 'Status Date';
        }
        field(34; "Continuous Assessment"; Boolean)
        {
            Caption = 'Continuous Assessment';
        }
        field(35; "Option Group"; Code[10])
        {
            Caption = 'Subject Group';
            TableRelation = "Group Subjects".Code;
        }
        field(36; "Formation Component"; Option)
        {
            Caption = 'Formation Component';
            OptionCaption = ' ,Specific,General,Technical';
            OptionMembers = " ",Specific,General,Technical;
        }
        field(37; "Absence Option"; Option)
        {
            Caption = 'Absence Option';
            OptionCaption = ' ,Half Absence,Unjustified Total,Total,Half Unjustified';
            OptionMembers = " ","Half Absence","Unjustified Total",Total,"Half Unjustified";
        }
        field(38; "Education Head Alert"; Boolean)
        {
            Caption = 'Education Head Alert';

            trigger OnValidate()
            begin
                if (xRec."Education Head Alert") and (not "Education Head Alert") then
                    if Confirm(Text001, false, "Student Code No.") then begin
                        "Absence Option" := "Absence Option"::" ";
                        //"Education Head Alert" := FALSE;
                        "Recover Test" := false;
                        Observations := '';
                    end else
                        "Education Head Alert" := xRec."Education Head Alert";
            end;
        }
        field(39; "Recover Test"; Boolean)
        {
            Caption = 'Recover Test';

            trigger OnValidate()
            begin
                if (xRec."Recover Test") and (not "Recover Test") then
                    if Confirm(Text001, false, "Student Code No.") then begin
                        "Absence Option" := "Absence Option"::" ";
                        "Education Head Alert" := false;
                        //"Recover Test"         := FALSE;
                        Observations := '';
                    end else
                        "Recover Test" := xRec."Recover Test";
            end;
        }
        field(40; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(41; Turn; Code[20])
        {
            Caption = 'Turn';
            TableRelation = Turn.Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                /*
                rRegClassEntry.RESET;
                rRegClassEntry.SETRANGE(Class,Class);
                rRegClassEntry.SETRANGE("School Year","School Year");
                rRegClassEntry.SETRANGE("Schooling Year","Schooling Year");
                rRegClassEntry.SETRANGE("Student Code No.","Student Code No.");
                rRegClassEntry.SETRANGE(Status,Status);
                IF rRegClassEntry.FIND('-') THEN BEGIN
                   REPEAT
                      rRegClassEntry.Turn := Turn;
                      rRegClassEntry.MODIFY;
                   UNTIL rRegClassEntry.NEXT = 0 ;
                END;
                */

                if Turn <> xRec.Turn then begin
                    rStudentSubjectEntry.Reset;
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Student Code No.", "Student Code No.");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."School Year", "School Year");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Schooling Year", "Schooling Year");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Study Plan Code", "Study Plan Code");
                    rStudentSubjectEntry.SetRange(rStudentSubjectEntry."Subjects Code", "Subjects Code");
                    if rStudentSubjectEntry.FindFirst then
                        cStudentsRegistration.StudentsSubjectsEntry(Rec);
                end;

            end;
        }
        field(42; "Sorting ID"; Integer)
        {
            Caption = 'Sorting ID';
        }
        field(43; "Original Line No."; Integer)
        {
            Caption = 'Original Line No.';
        }
        field(50; "Sub-subjects for assess. only"; Boolean)
        {
            Caption = 'Sub-subjects for assessments only';
        }
        field(51; "Legal Reports Sorting ID"; Integer)
        {
            Caption = 'Legal Reports Sorting ID';
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
        field(73100; "Sub-subject"; Boolean)
        {
            CalcFormula = Exist("Student Sub-Subjects Plan " WHERE("Student Code No." = FIELD("Student Code No."),
                                                                    "School Year" = FIELD("School Year"),
                                                                    "Schooling Year" = FIELD("Schooling Year"),
                                                                    Code = FIELD("Study Plan Code"),
                                                                    "Subject Code" = FIELD("Subjects Code"),
                                                                    "Line No." = FIELD("Line No.")));
            Caption = 'Sub-Subject';
            FieldClass = FlowField;
        }
        field(73101; "User Session ID"; Code[20])
        {
            Caption = 'User Session ID';
        }
        field(73102; "No. Students"; Integer)
        {
            CalcFormula = Count("Registration Subjects" WHERE("School Year" = FIELD("School Year"),
                                                               "Schooling Year" = FIELD("Schooling Year"),
                                                               "Study Plan Code" = FIELD("Study Plan Code"),
                                                               "Subjects Code" = FIELD("Subjects Code"),
                                                               Enroled = FILTER(true)));
            Caption = 'No. Students';
            Editable = false;
            FieldClass = FlowField;
        }
        field(73103; "Subject Excluded From Assess."; Boolean)
        {
            Caption = 'Subject Excluded From Assessment';
        }
        field(73104; "Report Description"; Text[250])
        {
            Caption = 'Report description';
        }
        field(75500; "Legal Code"; Text[10])
        {
            Caption = 'Legal Code';
            Description = 'ENES';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Subject),
                                                                                "Legal Code Type" = FILTER(Multi));
        }
    }

    keys
    {
        key(Key1; "Student Code No.", "School Year", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Student Code No.", Enroled, "Formation Component")
        {
        }
        key(Key3; "Subjects Code", "Student Code No.")
        {
        }
        key(Key4; "Student Code No.", Turn)
        {
        }
        key(Key5; "Student Code No.", "Option Group")
        {
        }
        key(Key6; "Student Code No.", "Subjects Code", "Option Group")
        {
        }
        key(Key7; "Option Group", "Student Code No.")
        {
        }
        key(Key8; "School Year", "Schooling Year", Class, Status, "Responsibility Center")
        {
        }
        key(Key9; "School Year", "Schooling Year", Class, Status, "Responsibility Center", "Study Plan Code", "Subjects Code")
        {
        }
        key(Key10; "Class No.")
        {
        }
        key(Key11; "Student Code No.", "School Year", "Sorting ID")
        {
        }
        key(Key12; "Student Code No.", "School Year", "Legal Reports Sorting ID")
        {
        }
        key(Key13; "Student Code No.", "Option Group", "Sorting ID")
        {
        }
        key(Key14; "Student Code No.", "Option Group", "Legal Reports Sorting ID")
        {
        }
        key(Key15; "School Year", "Schooling Year", "Option Group")
        {
        }
        key(Key16; "Legal Reports Sorting ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        DeleteServicePlan(Rec);
    end;

    trigger OnInsert()
    begin
        "Country/Region Code" := cStudentsRegistration.GetCountry;

        "User Id" := UserId;
        Date := Today;
    end;

    trigger OnModify()
    begin
        "User Id" := UserId;
        Date := Today;

        cInsertNAVGeneralTable.UpdateStudentsSubjectsTurn(Rec);
    end;

    var
        cStudentsRegistration: Codeunit "Students Registration";
        Text001: Label 'Do you want to remove student %1 from the limit of Absence list?';
        Text002: Label 'Cannot change this field, the student is already admitted.';
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        cInsertNAVGeneralTable: Codeunit InsertNAVGeneralTable;
        rStudentSubjectEntry: Record "Student Subjects Entry";


    procedure ValidateServicePlan(pRegisSubjectsServices: Record "Registration Subjects")
    var
        rServicesET: Record "Services ET";
        rStudentServicePlan: Record "Student Service Plan";
        rStudentServicePlanINSERT: Record "Student Service Plan";
        rRegistration: Record Registration;
        varLineNo: Integer;
        cStudentServices: Codeunit "Student Services";
    begin
        varLineNo := 0;

        rStudentServicePlan.Reset;
        rStudentServicePlan.SetRange("School Year", pRegisSubjectsServices."School Year");
        rRegistration.Reset;
        rRegistration.SetRange("School Year", pRegisSubjectsServices."School Year");
        rRegistration.SetRange("Student Code No.", pRegisSubjectsServices."Student Code No.");
        if rRegistration.Find('-') then;
        rStudentServicePlan.SetRange("Schooling Year", rRegistration."Schooling Year");
        rStudentServicePlan.SetRange("Student No.", pRegisSubjectsServices."Student Code No.");
        if rStudentServicePlan.Find('+') then
            varLineNo := rStudentServicePlan."Line No."
        else
            varLineNo := 10000;

        rServicesET.Reset;
        rServicesET.SetRange("Subject Code", pRegisSubjectsServices."Subjects Code");
        rServicesET.SetRange("Responsibility Center", "Responsibility Center");
        if rServicesET.Find('-') then
            repeat
                rStudentServicePlan.Reset;
                rStudentServicePlan.SetRange("School Year", pRegisSubjectsServices."School Year");
                rStudentServicePlan.SetRange("Schooling Year", rRegistration."Schooling Year");
                rStudentServicePlan.SetRange("Student No.", pRegisSubjectsServices."Student Code No.");
                rStudentServicePlan.SetRange("Service Code", rServicesET."No.");
                if rStudentServicePlan.Find('-') then begin
                    if rStudentServicePlan.Quantity <> 0 then begin
                        rStudentServicePlan.Quantity := 1;
                        rStudentServicePlan.Selected := true;
                        rStudentServicePlan.Modify;
                        cStudentServices.DistributionByEntityRegis(rStudentServicePlan);
                    end;
                    if rStudentServicePlan."Service Type" <> rStudentServicePlan."Service Type"::Required then begin
                        rStudentServicePlan."Service Type" := rStudentServicePlan."Service Type"::Required;
                        rStudentServicePlan.Modify;
                        cStudentServices.DistributionByEntityRegis(rStudentServicePlan);
                    end;
                end else begin
                    rStudentServicePlanINSERT.Init;
                    rStudentServicePlanINSERT.Validate("Student No.", pRegisSubjectsServices."Student Code No.");
                    rStudentServicePlanINSERT."School Year" := pRegisSubjectsServices."School Year";
                    rStudentServicePlanINSERT."Schooling Year" := rRegistration."Schooling Year";
                    rStudentServicePlanINSERT.Validate("Service Code", rServicesET."No.");
                    rStudentServicePlanINSERT."Line No." := varLineNo + 10000;
                    rStudentServicePlanINSERT."Service Type" := rStudentServicePlanINSERT."Service Type"::Required;
                    rStudentServicePlanINSERT.Selected := true;
                    rStudentServicePlanINSERT.Quantity := 1;
                    rStudentServicePlanINSERT."User ID" := UserId;
                    rStudentServicePlanINSERT."Last Date Modified" := Today;
                    rStudentServicePlanINSERT.January := rServicesET.January;
                    rStudentServicePlanINSERT.February := rServicesET.February;
                    rStudentServicePlanINSERT.March := rServicesET.March;
                    rStudentServicePlanINSERT.April := rServicesET.April;
                    rStudentServicePlanINSERT.May := rServicesET.May;
                    rStudentServicePlanINSERT.June := rServicesET.June;
                    rStudentServicePlanINSERT.July := rServicesET.July;
                    rStudentServicePlanINSERT.August := rServicesET.August;
                    rStudentServicePlanINSERT.Setember := rServicesET.Setember;
                    rStudentServicePlanINSERT.October := rServicesET.October;
                    rStudentServicePlanINSERT.November := rServicesET.November;
                    rStudentServicePlanINSERT.Dezember := rServicesET.December;
                    rStudentServicePlanINSERT."Responsibility Center" := rRegistration."Responsibility Center";
                    rStudentServicePlanINSERT.Insert(true);
                    cStudentServices.DistributionByEntityRegis(rStudentServicePlanINSERT);
                end;
            until rServicesET.Next = 0;
    end;


    procedure DeleteServicePlan(pRegisSubjectsServices: Record "Registration Subjects")
    var
        rServicesET: Record "Services ET";
        rStudentServicePlan: Record "Student Service Plan";
        rStudentServicePlanINSERT: Record "Student Service Plan";
        rRegistration: Record Registration;
        varLineNo: Integer;
        cStudentServices: Codeunit "Student Services";
        rServicesPlanLine: Record "Services Plan Line";
    begin
        rServicesET.Reset;
        rServicesET.SetRange("Subject Code", pRegisSubjectsServices."Subjects Code");
        rServicesET.SetRange("Responsibility Center", "Responsibility Center");
        if rServicesET.Find('-') then begin
            rRegistration.Reset;
            rRegistration.SetRange("School Year", pRegisSubjectsServices."School Year");
            rRegistration.SetRange("Student Code No.", pRegisSubjectsServices."Student Code No.");
            if rRegistration.Find('-') then;
            repeat
                rServicesPlanLine.Reset;
                rServicesPlanLine.SetRange(Code, rRegistration."Services Plan Code");
                rServicesPlanLine.SetRange("School Year", "School Year");
                rServicesPlanLine.SetRange("Service Code", rServicesET."No.");
                if not rServicesPlanLine.Find('-') then begin
                    rStudentServicePlan.Reset;
                    rStudentServicePlan.SetRange("School Year", pRegisSubjectsServices."School Year");
                    rStudentServicePlan.SetRange("Schooling Year", rRegistration."Schooling Year");
                    rStudentServicePlan.SetRange("Student No.", pRegisSubjectsServices."Student Code No.");
                    rStudentServicePlan.SetRange("Service Code", rServicesET."No.");
                    if rStudentServicePlan.Find('-') then begin
                        cStudentServices.DelDistributionByEntity(rStudentServicePlan);
                        rStudentServicePlan.DeleteAll;
                    end;
                end else begin
                    rStudentServicePlan.Reset;
                    rStudentServicePlan.SetRange("School Year", pRegisSubjectsServices."School Year");
                    rStudentServicePlan.SetRange("Schooling Year", rRegistration."Schooling Year");
                    rStudentServicePlan.SetRange("Student No.", pRegisSubjectsServices."Student Code No.");
                    rStudentServicePlan.SetRange("Service Code", rServicesET."No.");
                    if rStudentServicePlan.Find('-') then begin
                        if rServicesPlanLine."Service Type" <> rServicesPlanLine."Service Type"::Required then begin
                            rStudentServicePlan."Service Type" := rServicesPlanLine."Service Type";
                            rStudentServicePlan.Selected := false;
                            rStudentServicePlan.Modify;
                        end;
                    end;
                end;
            until rServicesET.Next = 0;
        end;
    end;
}

