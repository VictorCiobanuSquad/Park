table 52799 "Incidence Type"
{
    Caption = 'Incidence Type';
    DrillDownPageID = "Incidence List";
    LookupPageID = "Incidence List";
    Permissions = TableData Absence = rimd;

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            TableRelation = "School Year"."School Year" WHERE(Status = FILTER(Active | Planning));
        }
        field(2; "Schooling Year"; Code[10])
        {
            Caption = 'Schooling Year';
            TableRelation = "Structure Education Country"."Schooling Year";
        }
        field(3; "Incidence Type"; Option)
        {
            Caption = 'Incidence Type';
            OptionCaption = 'Default,Absence';
            OptionMembers = Default,Absence;

            trigger OnValidate()
            begin
                if "Incidence Code" <> '' then
                    if "Incidence Type" <> xRec."Incidence Type" then Error(Text0003, TableCaption);

                if "Incidence Type" = "Incidence Type"::Absence then begin
                    if (Category = Category::BUS) or (Category = Category::Cantine) or (Category = Category::Schoolyard) or
                      (Category = Category::"Extra-scholar") then
                        Error(Text0008, Format(Category));
                end;


                if "Incidence Type" = "Incidence Type"::Default then
                    "Absence Status" := "Absence Status"::Justified;

                if Category = Category::Class then
                    if "Incidence Type" = "Incidence Type"::Absence then
                        "Absence Status" := "Absence Status"::Unjustified;
            end;
        }
        field(4; "Subcategory Code"; Code[20])
        {
            Caption = 'Subcategory Code';
            TableRelation = "Sub Type"."Subcategory Code" WHERE(Category = FIELD(Category));

            trigger OnValidate()
            var
                l_SubType: Record "Sub Type";
            begin
                if "Subcategory Code" <> '' then begin
                    l_SubType.Reset;
                    l_SubType.SetRange(Category, Category);
                    l_SubType.SetRange("Subcategory Code", "Subcategory Code");
                    if l_SubType.FindSet then
                        "Subcategory Description" := l_SubType.Description;
                end else
                    "Subcategory Description" := '';
            end;
        }
        field(5; "Incidence Code"; Code[20])
        {
            Caption = 'Incidence Code';

            trigger OnValidate()
            var
                l_IncidenceType: Record "Incidence Type";
                l_IncidenceType2: Record "Incidence Type";
            begin
                if (("Incidence Code" = '') and (xRec."Incidence Code" <> '')) and ("Justification Code" <> '') then
                    Error(Text0011);
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            BlankZero = true;
            Caption = 'Quantity';
        }
        field(8; "Corresponding Code"; Code[20])
        {
            Caption = 'Corresponding Code';

            trigger OnLookup()
            var
                l_IncidenceType: Record "Incidence Type";
            begin
                l_IncidenceType.Reset;
                l_IncidenceType.SetRange("School Year", "School Year");
                l_IncidenceType.SetRange("Schooling Year", "Schooling Year");
                l_IncidenceType.SetRange(Category, Category);
                l_IncidenceType.SetRange("Subcategory Code", "Subcategory Code");
                l_IncidenceType.SetRange("Responsibility Center", "Responsibility Center");
                l_IncidenceType.SetRange("Absence Status", 0, 1);
                if l_IncidenceType.FindSet then
                    if PAGE.RunModal(PAGE::"Incidence List", l_IncidenceType) = ACTION::LookupOK then
                        Validate("Corresponding Code", l_IncidenceType."Incidence Code");
            end;

            trigger OnValidate()
            var
                l_IncidenceType: Record "Incidence Type";
            begin
                if "Corresponding Code" <> '' then begin
                    if (Category = Category::Class) or (Category = Category::Teacher) then begin
                        if "Incidence Type" = "Incidence Type"::Default then begin
                            Error(Text0012);
                        end;
                    end;
                    l_IncidenceType.Reset;
                    l_IncidenceType.SetRange("School Year", "School Year");
                    l_IncidenceType.SetRange("Schooling Year", "Schooling Year");
                    l_IncidenceType.SetRange(Category, Category);
                    l_IncidenceType.SetRange("Subcategory Code", "Subcategory Code");
                    l_IncidenceType.SetRange("Incidence Code", "Corresponding Code");
                    l_IncidenceType.SetRange("Responsibility Center", "Responsibility Center");
                    l_IncidenceType.SetRange("Absence Status", 0, 1);
                    if l_IncidenceType.FindSet then begin
                        "Corresponding Code" := l_IncidenceType."Incidence Code";
                        "Correspondig Code Description" := l_IncidenceType.Description;
                    end;
                end else begin
                    "Corresponding Code" := '';
                    "Correspondig Code Description" := '';
                end;
            end;
        }
        field(9; "Absence Status"; Option)
        {
            Caption = 'Absence Status';
            OptionCaption = 'Justified,Unjustified,Justification';
            OptionMembers = Justified,Unjustified,Justification;

            trigger OnValidate()
            begin

                if ("Absence Status" = "Absence Status"::Unjustified) and
                  ("Incidence Type" = "Incidence Type"::Default) then
                    Error(Text0005);


                /* //Normatica - 31.05.2012 - tem de poder deixar mudar
                IF Category = Category::Class THEN
                  IF "Incidence Type"= "Incidence Type"::Absence THEN
                    IF "Absence Status" = "Absence Status"::Justified THEN
                      ERROR(Text0013);
                */

            end;
        }
        field(10; "Responsibility Center"; Code[10])
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
        field(12; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = 'Class,Cantina,BUS,Schoolyard,Extra-scholar,Teacher';
            OptionMembers = Class,Cantine,BUS,Schoolyard,"Extra-scholar",Teacher;
        }
        field(14; "Correspondig Code Description"; Text[50])
        {
            Caption = 'Correspondig Code Description';
        }
        field(15; "Subcategory Description"; Text[50])
        {
            Caption = 'Subcategory Description';
        }
        field(16; "Justification Code"; Code[20])
        {
            Caption = 'Justification Code';
        }
        field(17; Delay; Boolean)
        {
            Caption = 'Delay';

            trigger OnValidate()
            begin
                if "Incidence Type" = "Incidence Type"::Default then
                    Error(Text0006, FieldCaption(Delay));


                if Delay and "Legal/Attendance" then
                    Error(Text0009, FieldCaption(Delay), FieldCaption("Legal/Attendance"));
            end;
        }
        field(40; "Legal/Attendance"; Boolean)
        {
            Caption = 'Legal/Attendance';

            trigger OnValidate()
            begin
                if "Incidence Type" = "Incidence Type"::Default then
                    Error(Text0006, FieldCaption("Legal/Attendance"));


                if Delay and "Legal/Attendance" then
                    Error(Text0009, FieldCaption(Delay), FieldCaption("Legal/Attendance"));
            end;
        }
        field(73101; Observations; Code[20])
        {
            Caption = 'Observations';
            TableRelation = Observation.Code WHERE("Line Type" = CONST(Cab),
                                                    "Observation Type" = FILTER("Incidence Student" | "Incidence Teacher"));

            trigger OnLookup()
            var
                l_Observation: Record Observation;
                l_SchoolYear: Record "School Year";
                FilterText: Text[1024];
            begin
                l_SchoolYear.Reset;
                l_SchoolYear.SetRange(Status, l_SchoolYear.Status::Active);
                if l_SchoolYear.FindFirst then
                    FilterText := l_SchoolYear."School Year";
                l_SchoolYear.Reset;
                l_SchoolYear.SetRange(Status, l_SchoolYear.Status::Planning);
                if l_SchoolYear.FindFirst then
                    if FilterText = '' then
                        FilterText := l_SchoolYear."School Year"
                    else
                        FilterText := FilterText + '|' + l_SchoolYear."School Year";

                l_Observation.Reset;
                l_Observation.SetFilter("Observation Type", '%1|%2', l_Observation."Observation Type"::"Incidence Student",
                l_Observation."Observation Type"::"Incidence Teacher");
                l_Observation.SetFilter("School Year", FilterText);

                if PAGE.RunModal(PAGE::"Student Inc. Observation List", l_Observation) = ACTION::LookupOK then
                    Observations := l_Observation.Code;
            end;
        }
    }

    keys
    {
        key(Key1; "School Year", "Schooling Year", Category, "Subcategory Code", "Incidence Code", "Justification Code", "Responsibility Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        l_IncidenceType: Record "Incidence Type";
        l_Class: Record Class;
    begin

        rAbsence.Reset;
        rAbsence.SetRange("School Year", "School Year");
        rAbsence.SetRange("Responsibility Center", "Responsibility Center");
        rAbsence.SetRange(Category, Category);
        rAbsence.SetRange("Subcategory Code", "Subcategory Code");
        rAbsence.SetRange("Incidence Type", "Incidence Type");
        rAbsence.SetRange("Incidence Code", "Incidence Code");
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Student);
        if rAbsence.FindSet then begin
            repeat
                if l_Class.Get(rAbsence.Class, "School Year") then begin
                    if l_Class."Schooling Year" = "Schooling Year" then
                        Error(Text0007);
                end;
            until rAbsence.Next = 0;
        end;

        rAbsence.Reset;
        rAbsence.SetRange("School Year", "School Year");
        rAbsence.SetRange("Responsibility Center", "Responsibility Center");
        rAbsence.SetRange(Category, Category);
        rAbsence.SetRange("Subcategory Code", "Subcategory Code");
        rAbsence.SetRange("Incidence Type", "Incidence Type");
        rAbsence.SetRange("Incidence Code", "Incidence Code");
        rAbsence.SetRange("Student/Teacher", rAbsence."Student/Teacher"::Teacher);
        if rAbsence.FindSet then begin
            Error(Text0007);
        end;




        l_IncidenceType.Reset;
        l_IncidenceType.SetRange("School Year", "School Year");
        l_IncidenceType.SetRange("Schooling Year", "Schooling Year");
        l_IncidenceType.SetRange(Category, Category);
        l_IncidenceType.SetRange("Subcategory Code", "Subcategory Code");
        l_IncidenceType.SetRange("Incidence Code", "Incidence Code");
        l_IncidenceType.SetRange("Responsibility Center", "Responsibility Center");
        l_IncidenceType.SetRange("Absence Status", "Absence Status"::Justification);
        l_IncidenceType.DeleteAll;

        cMasterTableWEB.DeleteIncidence(Rec, xRec);
    end;

    trigger OnInsert()
    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
    begin

        if "Incidence Code" = '' then
            Error(Text0010);

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";

        cMasterTableWEB.InsertIncidence(Rec, xRec);
    end;

    trigger OnModify()
    var
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
    begin
        cMasterTableWEB.ModifyIncidence(Rec, xRec);
    end;

    trigger OnRename()
    begin
        Error(Text0003, TableCaption);
    end;

    var
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0003: Label 'You cannot rename a %1.';
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        Text0005: Label 'The  Absence Status cannot be change for the Incidence Type Default. ';
        Text0006: Label 'You only can choose %1 incidences for the absence incidence type.';
        rAbsence: Record Absence;
        Text0007: Label 'This kind of Absence in already in use. Delete is not avaliable.';
        Text0008: Label 'The Incidence Type absence is not available for the category %1.';
        Text0009: Label 'Not allowed to have the %1 and %2 at same time.';
        Text0010: Label 'The Incidence Code field is mandatory.';
        Text0011: Label 'The Incidence Code field must not be blank.';
        Text0012: Label 'Not allowed for the category class and teacher.';
        Text0013: Label 'The Absence Status cannot be change for the Incidence Type Absence.';


    procedure GetSchoolYear(): Code[9]
    var
        l_SchoolYear: Record "School Year";
    begin
        l_SchoolYear.Reset;
        l_SchoolYear.SetRange(Status, l_SchoolYear.Status::Active);
        if l_SchoolYear.FindSet then
            exit(l_SchoolYear."School Year");
    end;
}

