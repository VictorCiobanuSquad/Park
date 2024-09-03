table 52787 Timetable
{
    Caption = 'Timetable';
    DrillDownPageID = "Timetable List";
    LookupPageID = "Timetable List";

    fields
    {
        field(1; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';

            trigger OnValidate()
            begin
                if "Timetable Code" <> xRec."Timetable Code" then begin
                    rEduConfiguration.Get;
                    NoSeriesMgt.TestManual(rEduConfiguration."Timetable Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Start Period"; Date)
        {
            Caption = 'Start Period';
        }
        field(4; "End Period"; Date)
        {
            Caption = 'End Period';
        }
        field(5; Class; Code[20])
        {
            Caption = 'Class';
            TableRelation = Class.Class WHERE("Responsibility Center" = FIELD("Responsibility Center"),
                                               Class = FIELD(Class),
                                               "School Year" = FIELD("School Year"));

            trigger OnValidate()
            begin

                if (Class <> '') then begin
                    if Class <> xRec.Class then begin
                        rTimetableLines.Reset;
                        rTimetableLines.SetRange("Timetable Code", "Timetable Code");
                        if rTimetableLines.Find('-') then begin
                            Class := xRec.Class;
                            Message(Text006);
                            exit;
                        end;
                    end;
                end;


                rClass.Reset;
                rClass.SetRange(Class, Class);
                rClass.SetRange("School Year", "School Year");//Normatica 2012.09.19 - faltava este filtro
                if rClass.Find('-') then begin
                    "Template Timetable" := rClass."Template Code";
                    if xRec."Template Timetable" <> "Template Timetable" then begin
                        rTimetableLines.Reset;
                        rTimetableLines.SetRange("Timetable Code", "Timetable Code");
                        if rTimetableLines.Find('-') then begin
                            Class := xRec.Class;
                            "Template Timetable" := xRec."Template Timetable";
                            Message(Text006);
                            exit;
                        end;
                    end;

                    "Class Description" := rClass.Description;
                    "School Year" := rClass."School Year";
                    Type := rClass.Type;
                    "Study Plan" := rClass."Study Plan Code";
                    "Responsibility Center" := rClass."Responsibility Center";

                    if rClass.Type = rClass.Type::Simple then begin
                        if rStudyPlanHeader.Get(rClass."Study Plan Code") then
                            "Plan Study Description" := rStudyPlanHeader.Description;
                    end else
                        if rCourseHeader.Get(rClass."Study Plan Code") then
                            "Plan Study Description" := rCourseHeader.Description;
                end else begin
                    "Class Description" := '';
                    "Study Plan" := '';
                    "Plan Study Description" := '';
                    "School Year" := '0';
                    "Template Timetable" := '';
                end;
            end;
        }
        field(6; "Study Plan"; Code[20])
        {
            Caption = 'Study Plan';
            Editable = false;
            TableRelation = IF (Type = FILTER(Simple)) "Study Plan Header".Code WHERE("School Year" = FIELD("School Year"))
            ELSE
            IF (Type = FILTER(Multi)) "Course Header".Code;

            trigger OnValidate()
            begin

                if "Study Plan" <> '' then begin
                    if rStudyPlanHeader.Get("Study Plan") then
                        "Plan Study Description" := rStudyPlanHeader.Description;
                end else
                    "Plan Study Description" := '';
            end;
        }
        field(9; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year" WHERE(Status = FILTER(Active | Planning));
        }
        field(10; Blocked; Boolean)
        {
            CalcFormula = Exist(Calendar WHERE("Timetable Code" = FIELD("Timetable Code")));
            Caption = 'Blocked';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "School Calendar"; Code[20])
        {
            Caption = 'School Calendar';
            TableRelation = "Base Calendar ChangeEDU"."Base Calendar Code" WHERE(Type = FILTER(Header));
        }
        field(12; "Plan Study Description"; Text[30])
        {
            Caption = 'Study Plan Description';
            Editable = false;

            trigger OnValidate()
            begin
                if rCourseHeader.Get("Study Plan") then
                    "Plan Study Description" := rCourseHeader.Description;
                if rStudyPlanHeader.Get("Study Plan") then
                    "Plan Study Description" := rStudyPlanHeader.Description;
            end;
        }
        field(13; "Class Description"; Text[30])
        {
            Caption = 'Class Description';
            Editable = false;

            trigger OnValidate()
            begin
                if rClass.Get(Class, "School Year") then
                    "Class Description" := rClass.Description;
            end;
        }
        field(17; "Template Timetable"; Code[20])
        {
            Caption = 'Template Timetable';
            TableRelation = "Template Timetable"."Template Code" WHERE("School Year" = FIELD("School Year"),
                                                                        "Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            begin
                rTimetableLines.Reset;
                rTimetableLines.SetRange("Timetable Code", "Timetable Code");
                if rTimetableLines.Find('-') then
                    Error(Text008, FieldCaption("Template Timetable"));


                /*
                rTimetable.RESET;
                rTimetable.SETFILTER("Timetable Code",'<>%1',"Timetable Code");
                rTimetable.SETRANGE(Class,Class);
                rTimetable.SETRANGE("Study Plan","Study Plan");
                rTimetable.SETRANGE("School Year","School Year");
                rTimetable.SETRANGE(Type,Type);
                IF rTimetable.FINDFIRST THEN
                  ERROR(Text009,FIELDCAPTION("Template Timetable"));
                
                
                rClass.RESET;
                rClass.SETRANGE("School Year","School Year");
                rClass.SETRANGE("Study Plan Code","Study Plan");
                rClass.SETRANGE(Type,Type);
                rClass.SETRANGE(Class,Class);
                IF rClass.FINDFIRST THEN BEGIN
                  rClass."Template Code" := "Template Timetable";
                  rClass.MODIFY;
                END;
                 */

            end;
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

                rTimetableLines.Reset;
                rTimetableLines.SetRange("Timetable Code", "Timetable Code");
                if rTimetableLines.Find('-') then
                    Error(Text008, FieldCaption("Responsibility Center"));
            end;
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
        field(20; "Timetable Type"; Option)
        {
            Caption = 'Timetable Type';
            OptionCaption = 'Class,Teacher';
            OptionMembers = Class,Teacher;
        }
        field(21; "Blocked Teacher"; Boolean)
        {
            CalcFormula = Exist("Timetable-Teacher" WHERE("Timetable Code" = FIELD("Timetable Code")));
            Caption = 'Blocked Teacher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Simple,Multi';
            OptionMembers = Simple,Multi;
        }
        field(23; "PlanIt Import"; Boolean)
        {
            Caption = 'PlanIt Import';
        }
        field(24; "User Id"; Code[20])
        {
            Caption = 'User Id';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(25; DateTime; DateTime)
        {
            Caption = 'DateTime';
        }
    }

    keys
    {
        key(Key1; "Timetable Code")
        {
            Clustered = true;
        }
        key(Key2; "Study Plan", Class)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Timetable Type" = "Timetable Type"::Class then begin
            CalcFields(Blocked);
            TestField(Blocked, false);
        end;

        if "Timetable Type" = "Timetable Type"::Teacher then begin
            CalcFields("Blocked Teacher");
            TestField("Blocked Teacher", false);


        end;
        rTimetableLines.Reset;
        rTimetableLines.SetRange("Timetable Code", "Timetable Code");
        rTimetableLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "Timetable Code" = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Timetable Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Timetable Nos.", xRec."No. Series", 0D, "Timetable Code", "No. Series");
        end;

        if "End Period" < "Start Period" then
            Error(Text007);
    end;

    trigger OnModify()
    begin
        if "End Period" < "Start Period" then
            Error(Text007);
    end;

    var
        rClass: Record Class;
        rStudyPlanHeader: Record "Study Plan Header";
        rTimetableLines: Record "Timetable Lines";
        Text001: Label 'Insert Class.';
        Text002: Label 'Insert Course.';
        Text003: Label 'School Year must be completed.';
        Text004: Label 'Period start and end must be completed.';
        rCourseHeader: Record "Course Header";
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text006: Label 'To change the Class please delete lines first.';
        Text007: Label 'Error in the selected Period.';
        Text008: Label 'You can not change %1 while there are lines.';
        Text009: Label 'You can not change %1 there are other timetables for the class.';

    //[Scope('OnPrem')]
    procedure AssistEdit(OldTimetable: Record Timetable): Boolean
    var
        rTimetable: Record Timetable;
    begin
        rTimetable := Rec;
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Timetable Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Timetable Nos.", OldTimetable."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("Timetable Code");
            Rec := rTimetable;
            exit(true);
        end;
    end;

    //[Scope('OnPrem')]
    procedure Validacoes(): Boolean
    begin


        if Class = '' then begin
            Message(Text001);
            exit(false);
        end;

        if "Study Plan" = '' then begin
            Message(Text002);
            exit(false);
        end;

        if "School Year" = '0' then begin
            Message(Text003);
            exit(false);
        end;

        if ("Start Period" = 0D) or ("End Period" = 0D) then begin
            Message(Text004);
            exit(false);
        end;

        exit(true);
    end;

    //[Scope('OnPrem')]
    procedure OpenCalendar()
    var
        rCalendar: Record Calendar;
        rTimeTeacher: Record "Timetable-Teacher";
        Text90001: Label 'There is no timetable associated with this time %1.';
        fCalendario: Page Calendar;
        fTeacherCalendar: Page "Teacher Calendar";
    begin
        if "Timetable Type" = "Timetable Type"::Class then begin
            rCalendar.Reset;
            rCalendar.SetRange("Timetable Code", "Timetable Code");
            if rCalendar.Find('-') then begin
                fCalendario.SetFormFilters("School Year", "Study Plan", Class, "Timetable Code", Type);
                fCalendario.Run;
            end;
        end;

        if "Timetable Type" = "Timetable Type"::Teacher then begin
            rTimeTeacher.Reset;
            rTimeTeacher.SetRange("Timetable Code", "Timetable Code");
            if rTimeTeacher.Find('-') then begin
                fTeacherCalendar.SetOnOperFormFilters("School Year", "Start Period", "End Period", "Timetable Code");
                fTeacherCalendar.Run;
            end else
                Error(Text90001, "Timetable Code");
        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyTimeTable(var parTimeTable: Record Timetable)
    var
        varHeader: Boolean;
        rTimetable: Record Timetable;
        Text011: Label 'The time code can not be equal to the copy.';
        rTimetableLines2: Record "Timetable Lines";
        Text0001: Label 'You will copy the timetable %1, do you wish to continue?';
        Text012: Label 'The model code has to be identical to the model code of the copy.';
    begin
        varHeader := true;

        rTimetable.Reset;
        rTimetable.SetFilter("Timetable Code", '<>%1', "Timetable Code");
        rTimetable.SetRange("Timetable Type", parTimeTable."Timetable Type");

        if PAGE.RunModal(0, rTimetable) = ACTION::LookupOK then begin

            if rTimetable."Timetable Code" = parTimeTable."Timetable Code" then
                Error(Text011, rTimetable."Timetable Code");

            if parTimeTable."Template Timetable" <> rTimetable."Template Timetable" then
                Error(Text012);


            if not Confirm(StrSubstNo(Text0001, rTimetable."Timetable Code")) then
                exit;

            if varHeader = true then begin
                if parTimeTable."Start Period" = 0D then
                    parTimeTable."Start Period" := rTimetable."Start Period";
                if parTimeTable."End Period" = 0D then
                    parTimeTable."End Period" := rTimetable."End Period";
                parTimeTable."School Calendar" := rTimetable."School Calendar";
                parTimeTable.Modify(true);
            end;


            rTimetableLines.Reset;
            rTimetableLines.SetFilter("Timetable Code", rTimetable."Timetable Code");
            if rTimetableLines.Find('-') then
                repeat
                    rTimetableLines2.Init;
                    rTimetableLines2."Timetable Code" := parTimeTable."Timetable Code";
                    rTimetableLines2."Line No." := rTimetableLines."Line No.";
                    rTimetableLines2.Class := parTimeTable.Class;
                    rTimetableLines2."Template Code" := parTimeTable."Template Timetable";
                    rTimetableLines2.Day := rTimetableLines.Day;
                    rTimetableLines2."Day Description" := rTimetableLines."Day Description";
                    rTimetableLines2."Start Hour" := rTimetableLines."Start Hour";
                    rTimetableLines2."End Hour" := rTimetableLines."End Hour";
                    rTimetableLines2."Break (Hours)" := rTimetableLines."Break (Hours)";
                    rTimetableLines2.Time := rTimetableLines.Time;
                    rTimetableLines2."Part of Day" := rTimetableLines."Part of Day";
                    rTimetableLines2.Teachers := rTimetableLines.Teachers;
                    rTimetableLines2.Type := rTimetableLines.Type;
                    rTimetableLines2.Insert(true);
                until rTimetableLines.Next = 0;

        end;
    end;

    //[Scope('OnPrem')]
    procedure CopyTimeTableTotal(var parTimeTable: Record Timetable)
    var
        varHeader: Boolean;
        rTimetable: Record Timetable;
        Text011: Label 'The time code can not be equal to the copy.';
        rTimetableLines2: Record "Timetable Lines";
        Text0001: Label 'You will copy the timetable %1, do you wish to continue?';
        Text012: Label 'The model code has to be identical to the model code of the copy.';
    begin
        varHeader := true;

        rTimetable.Reset;
        rTimetable.SetFilter("Timetable Code", '<>%1', "Timetable Code");
        rTimetable.SetRange("Timetable Type", parTimeTable."Timetable Type");

        if PAGE.RunModal(0, rTimetable) = ACTION::LookupOK then begin

            if rTimetable."Timetable Code" = parTimeTable."Timetable Code" then
                Error(Text011, rTimetable."Timetable Code");

            if parTimeTable."Template Timetable" <> rTimetable."Template Timetable" then
                Error(Text012);


            if not Confirm(StrSubstNo(Text0001, rTimetable."Timetable Code")) then
                exit;

            if varHeader = true then begin
                if parTimeTable."Start Period" = 0D then
                    parTimeTable."Start Period" := rTimetable."Start Period";
                if parTimeTable."End Period" = 0D then
                    parTimeTable."End Period" := rTimetable."End Period";
                parTimeTable."School Calendar" := rTimetable."School Calendar";
                parTimeTable.Modify(true);
            end;


            rTimetableLines.Reset;
            rTimetableLines.SetFilter("Timetable Code", rTimetable."Timetable Code");
            if rTimetableLines.Find('-') then
                repeat
                    rTimetableLines2.Init;
                    rTimetableLines2."Timetable Code" := parTimeTable."Timetable Code";
                    rTimetableLines2."Line No." := rTimetableLines."Line No.";
                    rTimetableLines2.Class := parTimeTable.Class;
                    rTimetableLines2."Template Code" := parTimeTable."Template Timetable";
                    rTimetableLines2.Day := rTimetableLines.Day;
                    rTimetableLines2."Day Description" := rTimetableLines."Day Description";
                    rTimetableLines2."Start Hour" := rTimetableLines."Start Hour";
                    rTimetableLines2."End Hour" := rTimetableLines."End Hour";
                    rTimetableLines2."Break (Hours)" := rTimetableLines."Break (Hours)";
                    rTimetableLines2.Time := rTimetableLines.Time;
                    rTimetableLines2."Part of Day" := rTimetableLines."Part of Day";
                    rTimetableLines2.Teachers := rTimetableLines.Teachers;
                    rTimetableLines2.Type := rTimetableLines.Type;
                    rTimetableLines2.Room := rTimetableLines.Room;
                    rTimetableLines2.Turn := rTimetableLines.Turn;
                    rTimetableLines2."Join Subjects" := rTimetableLines."Join Subjects";
                    rTimetableLines2.Validate(rTimetableLines2.Subject, rTimetableLines.Subject);
                    rTimetableLines2.Validate(rTimetableLines2."Sub-Subject Code", rTimetableLines."Sub-Subject Code");
                    rTimetableLines2.Insert(true);
                until rTimetableLines.Next = 0;

        end;
    end;
}

