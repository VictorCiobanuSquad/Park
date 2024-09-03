table 52795 "Template Timetable"
{
    Caption = 'Template Timetable';
    DrillDownPageID = "Timetable Template";
    LookupPageID = "Timetable Template";

    fields
    {
        field(1; "School Year"; Code[9])
        {
            Caption = 'School Year';
            NotBlank = true;
            TableRelation = "School Year"."School Year";
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Lines';
            OptionMembers = Header,Lines;
        }
        field(3; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            NotBlank = true;
            TableRelation = IF (Type = CONST(Lines)) "Template Timetable"."Template Code";
        }
        field(4; Day; Integer)
        {
            Caption = 'Day';
            InitValue = 1;
            ValuesAllowed = 1, 2, 3, 4, 5, 6, 7;

            trigger OnValidate()
            begin
                "Week Description" := Day - 1;
            end;
        }
        field(5; Time; Option)
        {
            Caption = 'Time';
            OptionCaption = '1º Time,2º Time,3º Time,4º Time,5º Time,6º Time,7º Time,8º Time,9º Time,Not Assigned';
            OptionMembers = "1º Time","2º Time","3º Time","4º Time","5º Time","6º Time","7º Time","8º Time","9º Time","Not Assigned";
        }
        field(6; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(7; "Template Description"; Text[30])
        {
            Caption = 'Template Description';
        }
        field(8; "Week Description"; Option)
        {
            Caption = 'Week Description';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;

            trigger OnValidate()
            begin
                Day := "Week Description" + 1;
            end;
        }
        field(9; "Initial Time"; Time)
        {
            Caption = 'Initial Time';
        }
        field(10; "Finish Time"; Time)
        {
            Caption = 'Finish Time';
        }
        field(11; "Part of Day"; Option)
        {
            Caption = 'Part of Day';
            OptionCaption = ' ,Morning,Afternoon,Night';
            OptionMembers = " ",Morning,Afternoon,Night;
        }
        field(12; "Timetable Type"; Option)
        {
            Caption = 'Timetable Type';
            OptionCaption = 'Lesson,Other';
            OptionMembers = Lesson,Other;

            trigger OnValidate()
            begin
                if xRec."Timetable Type" <> "Timetable Type" then begin
                    if "Timetable Type" = "Timetable Type"::Lesson then
                        Category := 0;
                end;
            end;
        }
        field(13; "Line Header"; Integer)
        {
            Caption = 'Line Header';
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
        field(15; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = ' ,Cantine,Schoolyard,BUS';
            OptionMembers = " ",Cantine,Schoolyard,BUS;
        }
    }

    keys
    {
        key(Key1; "School Year", Type, "Template Code", Day, Time, "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "School Year", Type, Day, "Initial Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        rClass: Record Class;
        rTimetable: Record Timetable;
    begin

        if (Type = Type::Header) and ("Template Code" <> '') then begin
            rClass.Reset;
            rClass.SetRange("Template Code", "Template Code");
            rClass.SetRange("School Year", "School Year");
            if rClass.Find('-') then
                Error(Text001);

            rTimetable.Reset;
            rTimetable.SetRange("Timetable Code", "Template Code");
            rTimetable.SetRange("School Year", "School Year");
            if rTimetable.Find('-') then
                Error(Text002);

            rTemplateTimetable.Reset;
            rTemplateTimetable.SetRange("School Year", "School Year");
            rTemplateTimetable.SetRange(Type, rTemplateTimetable.Type::Lines);
            rTemplateTimetable.SetRange("Template Code", "Template Code");
            rTemplateTimetable.DeleteAll;
        end;
    end;

    trigger OnInsert()
    begin
        if Type = Type::Header then
            if rUserSetup.Get(UserId) then
                "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    var
        Text001: Label 'There already are Classes with this Template.';
        rTemplateTimetable: Record "Template Timetable";
        Text002: Label 'There already are Timetables with this Template.';
        Text003: Label 'Cannot use the template code, already in use.';
        RespCenter: Record "Responsibility Center";
        cUserEducation: Codeunit "User Education";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        Text0005: Label 'Copy only be available if there are only day''s for monday.';

    //[Scope('OnPrem')]
    procedure CopyDays()
    var
        rTemplateTimetable: Record "Template Timetable";
        rNewTemplateTimetable: Record "Template Timetable";
        i: Integer;
    begin
        rTemplateTimetable.Reset;
        rTemplateTimetable.SetRange("School Year", "School Year");
        rTemplateTimetable.SetRange(Type, Type::Lines);
        rTemplateTimetable.SetRange("Template Code", "Template Code");
        rTemplateTimetable.SetRange(Day, 2, 5);
        if rTemplateTimetable.FindFirst then
            Error(Text0005);

        for i := 2 to 5 do begin
            rTemplateTimetable.Reset;
            rTemplateTimetable.SetRange("School Year", "School Year");
            rTemplateTimetable.SetRange(Type, Type::Lines);
            rTemplateTimetable.SetRange("Template Code", "Template Code");
            rTemplateTimetable.SetRange(Day, 1);
            if rTemplateTimetable.FindSet then
                repeat
                    rNewTemplateTimetable.Init;
                    rNewTemplateTimetable.TransferFields(rTemplateTimetable);
                    rNewTemplateTimetable.Validate(Day, i);
                    rNewTemplateTimetable."Line No." := 0;
                    rNewTemplateTimetable.Insert(true);
                until rTemplateTimetable.Next = 0;
        end;
    end;
}

