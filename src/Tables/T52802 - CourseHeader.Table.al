table 52802 "Course Header"
{
    Caption = 'Course Header';
    DrillDownPageID = "Course List";
    LookupPageID = "Course List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    if rEduConfiguration.Get then;
                    //NoSeriesMgt.TestManual(rEduConfiguration."Course Nos.");
                    //TODO: to test NoSeries
                    CU_NoSeries.TestManual(rEduConfiguration."Course Nos.");
                    Description := '';
                end;
            end;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(7; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
        }
        field(8; "Responsibility Center"; Code[10])
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
        field(9; "School Year Begin"; Code[9])
        {
            Caption = 'School Year Begin';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
        }
        field(10; "Exist Course"; Boolean)
        {
            CalcFormula = Exist(Registration WHERE(Course = FIELD(Code),
                                                    "Responsibility Center" = FIELD("Responsibility Center")));
            Caption = 'Exist Course';
            FieldClass = FlowField;
        }
        field(11; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(14; "Maximum Unjustified Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Unjustified Absence';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" < "Maximum Unjustified Absence") and ("Maximum Total Absence" <> 0) then
                    Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absence"));
            end;
        }
        field(15; "Maximum Total Absence"; Integer)
        {
            BlankZero = true;
            Caption = 'Maximum Total Absence';

            trigger OnValidate()
            begin
                if ("Maximum Total Absence" <> 0) then begin
                    if "Maximum Total Absence" < "Maximum Unjustified Absence" then
                        Error(Text0013, FieldCaption("Maximum Total Absence"), FieldCaption("Maximum Unjustified Absence"));
                end;
            end;
        }
        field(20; "Sub-subjects for assess. only"; Boolean)
        {
            Caption = 'Sub-subjects for assessments only';

            trigger OnValidate()
            begin

                CalcFields("Exist Course");
                if "Exist Course" = false then begin
                    rCourseLines.Reset;
                    rCourseLines.SetRange(Code, Code);
                    rCourseLines.ModifyAll(rCourseLines."Sub-subjects for assess. only", "Sub-subjects for assess. only");
                end else
                    Error(Text0007);
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
        field(73100; "Schooling Year Begin"; Code[10])
        {
            Caption = 'Schooling Year Begin';
            TableRelation = "Structure Education Country"."Schooling Year" WHERE(Type = FILTER(Multi));

            trigger OnValidate()
            begin
                rCourseLines.Reset;
                rCourseLines.SetRange(Code, Code);
                if ((xRec."Schooling Year Begin" <> '') and (xRec."Schooling Year Begin" <> "Schooling Year Begin")) and
                    (rCourseLines.Find('-')) then begin
                    if ((xRec."Schooling Year Begin" <> '') and (xRec."Schooling Year Begin" <> "Schooling Year Begin")) and
                        (not rCourseLines.Find('-')) then
                        Error(Text0001);
                    if (rCourseLines.Find('-')) then
                        Error(Text0002);
                end;
            end;
        }
        field(75000; "Course Type"; Option)
        {
            Caption = 'Course Type';
            Description = 'MISI/VERI';
            OptionCaption = ' ,General,Scientific-Human,Technological,Artistic,Professional,CEF,Appellant,EFA';
            OptionMembers = " ",GR,CH,TE,AR,PRO,CEF,REC,EFA;

            trigger OnValidate()
            begin
                if "Course Type" <> xRec."Course Type" then begin
                    "Course Name" := '';
                    "Course Name2" := '';
                    "Course Code" := '';
                    "Course Description" := '';
                end;
            end;
        }
        field(75001; "Course Name"; Code[10])
        {
            Caption = 'Course Name';
            Description = 'MISI/VERI';

            trigger OnLookup()
            var
                i: Integer;
            begin
                i := "Course Type" + 7;
                if "Course Type" <> 0 then begin
                    rTableMISI.Reset;
                    rTableMISI.SetRange(rTableMISI.Type, i);
                    if rTableMISI.FindSet then begin
                        if PAGE.RunModal(PAGE::"MISI List", rTableMISI) = ACTION::LookupOK then begin
                            "Course Name" := rTableMISI.Code;
                            "Course Name2" := rTableMISI.Description;
                        end;
                    end else
                        Error(Text0009);
                end;
            end;

            trigger OnValidate()
            var
                i: Integer;
            begin
                i := "Course Type" + 7;
                rTableMISI.Reset;
                rTableMISI.SetRange(rTableMISI.Type, i);
                rTableMISI.SetRange(rTableMISI.Code, "Course Name");
                if rTableMISI.FindFirst then
                    "Course Name2" := rTableMISI.Description
                else begin
                    "Course Name" := '';
                    "Course Name2" := '';
                end;
            end;
        }
        field(75002; "Course Name2"; Text[250])
        {
            Caption = 'Course Name';
            Description = 'MISI/VERI';
            Editable = false;
        }
        field(75003; "Course Code"; Code[10])
        {
            Caption = 'Course Code';
            Description = 'MISI/VERI';
            TableRelation = "Table MISI".Code WHERE(Type = CONST(CodCurso));

            trigger OnValidate()
            begin
                rTableMISI.Reset;
                rTableMISI.SetRange(rTableMISI.Type, rTableMISI.Type::CodCurso);
                rTableMISI.SetRange(rTableMISI.Code, "Course Code");
                if rTableMISI.FindFirst then
                    "Course Description" := rTableMISI.Description
                else
                    "Course Description" := '';
            end;
        }
        field(75004; "Course Description"; Text[250])
        {
            Caption = 'Course Description';
            Description = 'MISI/VERI';
            Editable = false;
        }
        field(75500; "Legal Code"; Text[10])
        {
            Caption = 'Legal Code';
            Description = 'ENES';
            TableRelation = "Legal Codes"."Parish/Council/District Code" WHERE(Type = FILTER(Course),
                                                                                "Legal Code Type" = FILTER(Multi));

            trigger OnValidate()
            begin

                ENESENEBCodes.Reset;
                ENESENEBCodes.SetRange(Type, ENESENEBCodes.Type::Course);
                ENESENEBCodes.SetRange("Legal Code Type", ENESENEBCodes."Legal Code Type"::Multi);
                ENESENEBCodes.SetRange("Parish/Council/District Code", "Legal Code");
                if ENESENEBCodes.Find('-') then
                    "ENES Description" := ENESENEBCodes.Description
                else
                    "ENES Description" := '';
            end;
        }
        field(75501; "ENES Description"; Text[61])
        {
            Caption = 'Legal Code Description';
            Description = 'ENES';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Exist Course");
        if "Exist Course" then
            Error(Text0007);

        rCourseLines.Reset;
        rCourseLines.SetRange(Code, Code);
        rCourseLines.SetRange("Responsibility Center", "Responsibility Center");
        if rCourseLines.Find('-') then
            Error(Text0006, Code);

        rClass.Reset;
        rClass.SetRange(Type, rClass.Type::Multi);
        rClass.SetRange("Study Plan Code", Code);
        rClass.SetRange("Responsibility Center", "Responsibility Center");
        if rClass.Find('-') then
            Error(Text0008, Code);
    end;

    trigger OnInsert()
    begin

        if Code = '' then begin
            if rEduConfiguration.Get then;
            rEduConfiguration.TestField("Course Nos.");
            //NoSeriesMgt.InitSeries(rEduConfiguration."Course Nos.", xRec."No. Series", 0D, Code, "No. Series");
            //TODO: to test NoSeries
            if CU_NoSeries.AreRelated(rEduConfiguration."Users Family Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            Code := CU_NoSeries.GetNextNo("No. Series");
        end;

        "Country/Region Code" := cStudentsRegistration.GetCountry;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";


        "User Id" := UserId;
        Date := WorkDate;
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        rCourseLines: Record "Course Lines";
        cStudentsRegistration: Codeunit "Students Registration";
        rUserSetup: Record "User Setup";
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        Text0007: Label 'There already are students associated to the Course.';
        Text0006: Label '%1 cannot put the Study Plan out while lines are not manually put out.';
        Text0001: Label 'Cannot modify the Schooling Year.';
        Text0002: Label 'Cannot modify the Schooling  Year while lines are not manually put out.';
        rClass: Record Class;
        Text0008: Label 'There already is a class with Course %1.';
        Text0009: Label 'There are no settings.';
        rTableMISI: Record "Table MISI";
        ENESENEBCodes: Record "Legal Codes";
        Text0013: Label 'The field %1 must be higher than the field %2.';

    //[Scope('OnPrem')]
    procedure AssistEdit(OldStudyPlanHeader: Record "Course Header"): Boolean
    var
        CourseHeader: Record "Course Header";
    begin
        CourseHeader := Rec;
        if rEduConfiguration.Get then;
        rEduConfiguration.TestField("Study Plan Nos.");
        //if NoSeriesMgt.SelectSeries(rEduConfiguration."Course Nos.", OldStudyPlanHeader."No. Series", "No. Series") then begin
        //NoSeriesMgt.SetSeries(Code);
        if CU_NoSeries.LookupRelatedNoSeries(OldStudyPlanHeader."No. Series", rEduConfiguration."Course Nos.", "No. Series") then begin
            CU_NoSeries.GetNextNo(Code);
            //TODO: to test NoSeries
            Rec := CourseHeader;
            exit(true);
        end;
    end;
}

