table 31009810 "Equipment Entry"
{
    Caption = 'Equipment Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Order,Anulled,Returned,Extension';
            OptionMembers = " ","Order",Anulled,Returned,Extension;
        }
        field(3; "Timetable Code"; Code[20])
        {
            Caption = 'Timetable Code';
            NotBlank = true;
            TableRelation = IF ("Student/Teacher" = FILTER(Student)) Timetable."Timetable Code" WHERE("Timetable Type" = FILTER(Class))
            ELSE
            IF ("Student/Teacher" = FILTER(Teacher)) Timetable."Timetable Code" WHERE("Timetable Type" = FILTER(Teacher));
        }
        field(4; "Timetable Line No."; Integer)
        {
            Caption = 'Timetable Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Subject,Non scholar component,Non scholar hours';
            OptionMembers = " ",Subject,"Non scholar component","Non scholar hours";
        }
        field(6; "Student/Teacher"; Option)
        {
            Caption = 'Student/Teacher';
            OptionCaption = ' ,Student,Teacher';
            OptionMembers = " ",Student,Teacher;
        }
        field(7; "Student/Teacher Code No."; Code[20])
        {
            Caption = 'Student/Teacher Code No.';
            TableRelation = IF ("Student/Teacher" = FILTER(Student)) Students."No."
            ELSE
            IF ("Student/Teacher" = FILTER(Teacher)) Teacher."No.";
        }
        field(8; "Equipment Code"; Code[20])
        {
            Caption = 'Equipment Code';

            trigger OnLookup()
            begin
                Clear(fEquipmentList);
                if "Equipment Type" = "Equipment Type"::Single then begin
                    rEquipment.Reset;
                    rEquipment.SetRange(Type, "Equipment Type"::Single);
                    rEquipment.SetRange("Line No.", 0);
                    fEquipmentList.SetTableView(rEquipment);
                    fEquipmentList.updateForm("Equipment Type"::Single);
                    fEquipmentList.LookupMode(true);
                    fEquipmentList.RunModal;
                    fEquipmentList.GetRecord(rEquipment);
                    "Equipment Code" := rEquipment."Equipment No.";
                    "Equipment description" := rEquipment.Description;
                end;
                if "Equipment Type" = "Equipment Type"::Group then begin
                    rEquipment.Reset;
                    rEquipment.SetRange(Type, "Equipment Type"::Group);
                    rEquipment.SetRange("Line No.", 0);
                    fEquipmentList.SetTableView(rEquipment);
                    fEquipmentList.LookupMode(true);
                    fEquipmentList.updateForm("Equipment Type"::Group);
                    fEquipmentList.RunModal;
                    fEquipmentList.GetRecord(rEquipment);
                    "Equipment Code" := rEquipment."Equipment Group";
                    "Equipment description" := rEquipment.Description;
                end;
                "Available Quantity" := GetAvaiableQuant(Rec);
            end;

            trigger OnValidate()
            begin
                if "Equipment Code" <> '' then begin
                    if "Equipment Type" = "Equipment Type"::Single then begin
                        rEquipment.Reset;
                        rEquipment.SetRange(Type, "Equipment Type"::Single);
                        rEquipment.SetRange("Line No.", 0);
                        rEquipment.SetRange("Equipment No.", "Equipment Code");
                        if rEquipment.FindFirst then begin
                            "Equipment description" := rEquipment.Description;
                            Quantity := 0;
                        end;
                    end;
                    if "Equipment Type" = "Equipment Type"::Group then begin
                        rEquipment.Reset;
                        rEquipment.SetRange(Type, "Equipment Type"::Group);
                        rEquipment.SetRange("Line No.", 0);
                        rEquipment.SetRange("Equipment Group", "Equipment Code");
                        if rEquipment.FindFirst then begin
                            "Equipment description" := rEquipment.Description;
                            Quantity := 0;
                        end;
                    end;
                    "Available Quantity" := GetAvaiableQuant(Rec);
                end;
                if "Equipment Code" = '' then begin
                    "Equipment description" := '';
                    Quantity := 0;
                    "Available Quantity" := 0;
                end;
            end;
        }
        field(9; "Equipment Type"; Option)
        {
            Caption = 'Equipment type';
            OptionCaption = ' ,Single,Group';
            OptionMembers = " ",Single,Group;

            trigger OnValidate()
            begin
                if xRec."Equipment Type" <> "Equipment Type" then begin
                    "Equipment Code" := '';
                    "Equipment description" := '';
                    Quantity := 0;
                    "Available Quantity" := 0;
                end;
            end;
        }
        field(11; Quantity; Integer)
        {
            BlankZero = true;
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Quantity < 0 then
                    Error(Text0005);


                if (xRec.Quantity <> 0) and (Quantity <> 0) then
                    if GetAvaiableQuant(Rec) >= 0 then begin
                        if varExit then
                            "Available Quantity" := GetAvaiableQuant(Rec)
                        else
                            "Available Quantity" := GetAvaiableQuant(Rec) - Quantity;
                    end else
                        Error(Text0003);

                if (Quantity <> 0) and (xRec.Quantity = 0) then
                    if ("Available Quantity" - Quantity) >= 0 then
                        "Available Quantity" := "Available Quantity" - Quantity
                    else
                        Error(Text0003);

                if Quantity = 0 then
                    "Available Quantity" := GetAvaiableQuant(Rec);
            end;
        }
        field(12; "Available Quantity"; Integer)
        {
            BlankZero = true;
            Caption = 'Available Quantity';
            Editable = false;
        }
        field(13; "Equipment description"; Text[30])
        {
            Caption = 'Description';
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Registered,Anulled,Returned';
            OptionMembers = " ",Registered,Anulled,Returned;
        }
        field(15; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(16; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(17; Observations; Text[250])
        {
            Caption = 'Remarks';
        }
        field(18; Registered; Boolean)
        {
        }
        field(19; "Original Line No."; Integer)
        {
        }
        field(20; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
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
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Student/Teacher", "Student/Teacher Code No.", "Entry Type", "Timetable Code", "Timetable Line No.", "Equipment Type", "Equipment Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if not Open then
            Error(Text0002);
    end;

    trigger OnInsert()
    begin
        Open := true;
        "User Id" := UserId;
        Date := WorkDate;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    trigger OnModify()
    begin
        if (xRec.Status <> xRec.Status::Registered) and (xRec.Open <> true) then
            Error(Text0002);
    end;

    var
        fEquipmentList: Page "Equipment List";
        rEquipment: Record Equipment;
        rEquipmentEntry: Record "Equipment Entry";
        text0001: Label ' \@1@@@@@@@@@@@@@@@@@@@@@\';
        rRemarks: Record Remarks;
        Window: Dialog;
        LinesCount: Integer;
        totalRec: Integer;
        LinesCount1: Integer;
        totalRec1: Integer;
        xrecEquipmentEntry: Record "Equipment Entry";
        rEquipmentEntry1: Record "Equipment Entry";
        Text0002: Label 'Not Allowed';
        Text0003: Label 'There is no available amount of equipment to satisfy this request.';
        Text0004: Label 'Before Posting the User must define a value.';
        Text0005: Label 'Quantity of order must be higher than Zero.';
        rUserSetup: Record "User Setup";
        varExit: Boolean;

    //[Scope('OnPrem')]
    procedure GetAvaiableQuant(pRec: Record "Equipment Entry") AvailableQuant: Integer
    var
        l_rEquipmentEntry: Record "Equipment Entry";
    begin
        Clear(varExit);
        l_rEquipmentEntry.Reset;
        l_rEquipmentEntry.SetRange("Equipment Code", pRec."Equipment Code");
        l_rEquipmentEntry.SetRange("Equipment Type", pRec."Equipment Type");
        l_rEquipmentEntry.SetFilter("Entry No.", '<>%1', pRec."Entry No.");
        l_rEquipmentEntry.SetFilter(Status, '<>%1', pRec.Status::" ");
        l_rEquipmentEntry.SetRange("Entry Type", pRec."Entry Type"::Order);
        if l_rEquipmentEntry.FindSet then begin
            repeat
                varExit := ValidateHours(l_rEquipmentEntry."Timetable Code",
                                        l_rEquipmentEntry."Timetable Line No.",
                                        l_rEquipmentEntry."Student/Teacher");
            until l_rEquipmentEntry.Next = 0;
            if varExit then
                exit(l_rEquipmentEntry."Available Quantity" - Quantity)
            else begin
                rEquipment.Reset;
                rEquipment.SetRange(Type, pRec."Equipment Type");
                if pRec."Equipment Type" = "Equipment Type"::Single then
                    rEquipment.SetRange("Equipment No.", pRec."Equipment Code");
                if pRec."Equipment Type" = "Equipment Type"::Group then
                    rEquipment.SetRange("Equipment Group", pRec."Equipment Code");
                if rEquipment.FindFirst then
                    exit(rEquipment.Quantity);
            end;


        end else begin
            if pRec."Entry Type" = "Entry Type"::Order then begin
                rEquipment.Reset;
                rEquipment.SetRange(Type, pRec."Equipment Type");
                if pRec."Equipment Type" = "Equipment Type"::Single then
                    rEquipment.SetRange("Equipment No.", pRec."Equipment Code");
                if pRec."Equipment Type" = "Equipment Type"::Group then
                    rEquipment.SetRange("Equipment Group", pRec."Equipment Code");
                if rEquipment.FindFirst then
                    exit(rEquipment.Quantity);
            end;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ModifyAvaiableQuant(pTimetableCode: Code[20]; pTimetableLineno: Integer): Integer
    var
        l_Calendar: Record Calendar;
        l_TimetableTeacher: Record "Timetable-Teacher";
        l_Calendar2: Record Calendar;
        l_TimetableTeacher2: Record "Timetable-Teacher";
        l_rEquipmentEntry: Record "Equipment Entry";
        l_rEquipmentEntry2: Record "Equipment Entry";
        l_rEquipmentEntryTEMP: Record "Equipment Entry" temporary;
    begin
        l_rEquipmentEntry.Reset;
        l_rEquipmentEntry.SetRange("Equipment Code", "Equipment Code");
        l_rEquipmentEntry.SetRange("Equipment Type", "Equipment Type");
        l_rEquipmentEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
        l_rEquipmentEntry.SetRange(Open, false);
        l_rEquipmentEntry.SetFilter(Status, '<>%1', Status::" ");
        l_rEquipmentEntry.SetRange("Entry Type", "Entry Type"::Order);
        l_rEquipmentEntry.SetRange(Registered, true);
        if l_rEquipmentEntry.FindSet then begin
            repeat
                if l_rEquipmentEntry."Student/Teacher" = l_rEquipmentEntry."Student/Teacher"::Student then begin
                    if "Student/Teacher" = "Student/Teacher"::Student then begin
                        l_Calendar.Reset;
                        l_Calendar.SetRange("Timetable Code", pTimetableCode);
                        l_Calendar.SetRange("Line No.", pTimetableLineno);
                        if l_Calendar.FindFirst then begin
                            l_Calendar2.Reset;
                            l_Calendar2.SetRange("Filter Period", l_Calendar."Filter Period");
                            l_Calendar2.SetRange("Timetable Code", l_rEquipmentEntry."Timetable Code");
                            l_Calendar2.SetRange("Line No.", l_rEquipmentEntry."Timetable Line No.");
                            if l_Calendar2.FindFirst then begin
                                l_rEquipmentEntryTEMP.Init;
                                l_rEquipmentEntryTEMP.TransferFields(l_rEquipmentEntry);
                                l_rEquipmentEntryTEMP.Insert;
                            end;
                        end;
                    end;
                    if "Student/Teacher" = "Student/Teacher"::Teacher then begin
                        l_TimetableTeacher.Reset;
                        l_TimetableTeacher.SetRange("Timetable Code", pTimetableCode);
                        l_TimetableTeacher.SetRange("Timetable Line No.", pTimetableLineno);
                        if l_TimetableTeacher.FindFirst then begin
                            l_TimetableTeacher2.Reset;
                            l_TimetableTeacher2.SetRange("Filter Period", l_TimetableTeacher."Filter Period");
                            l_TimetableTeacher2.SetRange("Timetable Code", l_rEquipmentEntry."Timetable Code");
                            l_TimetableTeacher2.SetRange("Timetable Line No.", l_rEquipmentEntry."Timetable Line No.");
                            if l_TimetableTeacher2.FindFirst then begin
                                l_rEquipmentEntryTEMP.Init;
                                l_rEquipmentEntryTEMP.TransferFields(l_rEquipmentEntry);
                                l_rEquipmentEntryTEMP.Insert;
                            end;
                        end;
                    end;
                end;
                if l_rEquipmentEntry."Student/Teacher" = l_rEquipmentEntry."Student/Teacher"::Teacher then begin
                    l_TimetableTeacher.Reset;
                    l_TimetableTeacher.SetRange("Timetable Code", pTimetableCode);
                    l_TimetableTeacher.SetRange("Timetable Line No.", pTimetableLineno);
                    if l_TimetableTeacher.FindFirst then begin
                        l_TimetableTeacher2.Reset;
                        l_TimetableTeacher2.SetRange("Filter Period", l_TimetableTeacher."Filter Period");
                        l_TimetableTeacher2.SetRange("Timetable Code", l_rEquipmentEntry."Timetable Code");
                        l_TimetableTeacher2.SetRange("Timetable Line No.", l_rEquipmentEntry."Timetable Line No.");
                        if l_TimetableTeacher2.FindFirst then begin
                            l_rEquipmentEntryTEMP.Init;
                            l_rEquipmentEntryTEMP.TransferFields(l_rEquipmentEntry);
                            l_rEquipmentEntryTEMP.Insert;
                        end;
                    end;
                end;
            until l_rEquipmentEntry.Next = 0;
            l_rEquipmentEntryTEMP.Reset;
            l_rEquipmentEntryTEMP.SetCurrentKey("Entry No.");
            if l_rEquipmentEntryTEMP.FindLast then begin
                if l_rEquipmentEntryTEMP."Entry No." < "Entry No." then begin
                    if l_rEquipmentEntry2.Get(l_rEquipmentEntryTEMP."Entry No.") then begin
                        l_rEquipmentEntry2."Available Quantity" := Quantity + l_rEquipmentEntry2."Available Quantity";
                        l_rEquipmentEntry2.Modify;
                        exit(l_rEquipmentEntry2."Available Quantity");
                    end;
                end else
                    exit(GetAvaiableQuant(Rec));
            end else
                exit(GetAvaiableQuant(Rec));
        end;
    end;

    //[Scope('OnPrem')]
    procedure Post()
    var
        l_rEquipmentEntry: Record "Equipment Entry";
    begin
        Window.Open(rEquipmentEntry.TableCaption + ' ' + text0001);
        rEquipmentEntry.Reset;
        rEquipmentEntry.SetRange(Open, true);
        rEquipmentEntry.SetRange(Status, Status::Registered);
        if rEquipmentEntry.FindSet then begin
            totalRec := rEquipmentEntry.Count;
            repeat
                if rEquipmentEntry.Quantity = 0 then begin
                    Window.Close;
                    Error(Text0004);
                end;
                LinesCount += 1;
                Window.Update(1, Round(LinesCount / totalRec * 10000, 1));
                rEquipmentEntry."Posting Date" := WorkDate;
                rEquipmentEntry.Open := false;
                rEquipmentEntry.Registered := true;
                rEquipmentEntry.Modify;

                l_rEquipmentEntry.Reset;
                l_rEquipmentEntry.SetRange(Open, true);
                l_rEquipmentEntry.SetRange(Status, Status::" ");
                l_rEquipmentEntry.SetRange(Registered, false);
                if l_rEquipmentEntry.FindSet then begin
                    repeat
                        l_rEquipmentEntry."Available Quantity" := GetAvaiableQuant(rEquipmentEntry);
                        l_rEquipmentEntry.Modify;
                    until l_rEquipmentEntry.Next = 0;
                end;
            until rEquipmentEntry.Next = 0;
        end;
        rEquipmentEntry.Reset;
        rEquipmentEntry.SetRange(Open, false);
        rEquipmentEntry.SetRange(Status, Status::Anulled);
        rEquipmentEntry.SetRange(Registered, true);
        if rEquipmentEntry.FindSet then begin
            totalRec := rEquipmentEntry.Count;
            repeat
                LinesCount += 1;
                Window.Update(1, Round(LinesCount / totalRec * 10000, 1));
                rEquipmentEntry.Status := rEquipmentEntry.Status::" ";
                rEquipmentEntry.Modify;
                Init;
                TransferFields(rEquipmentEntry);
                "Entry No." := 0;
                "Posting Date" := WorkDate;
                "Entry Type" := "Entry Type"::Anulled;
                "Available Quantity" := ModifyAvaiableQuant(rEquipmentEntry."Timetable Code", rEquipmentEntry."Timetable Line No.");
                "Original Line No." := rEquipmentEntry."Entry No.";
                Status := rEquipmentEntry.Status::" ";
                Open := false;
                Insert;
            until rEquipmentEntry.Next = 0;
        end;
        rEquipmentEntry.Reset;
        rEquipmentEntry.SetRange(Open, false);
        rEquipmentEntry.SetRange(Status, Status::Returned);
        rEquipmentEntry.SetRange(Registered, true);
        if rEquipmentEntry.FindSet then begin
            totalRec := rEquipmentEntry.Count;
            repeat
                LinesCount += 1;
                Window.Update(1, Round(LinesCount / totalRec * 10000, 1));
                rEquipmentEntry.Status := rEquipmentEntry.Status::" ";
                rEquipmentEntry.Modify;
                Init;
                TransferFields(rEquipmentEntry);
                "Entry No." := 0;
                "Posting Date" := WorkDate;
                "Entry Type" := "Entry Type"::Returned;
                "Original Line No." := rEquipmentEntry."Entry No.";
                "Available Quantity" := ModifyAvaiableQuant(rEquipmentEntry."Timetable Code", rEquipmentEntry."Timetable Line No.");
                Status := rEquipmentEntry.Status::" ";
                Open := false;
                Insert;
            until rEquipmentEntry.Next = 0;
        end;

        Window.Close;
    end;

    //[Scope('OnPrem')]
    procedure UpdateObs()
    begin
        rRemarks.Reset;
        rRemarks.SetRange("Type Remark", rRemarks."Type Remark"::Equipment);
        rRemarks.SetRange("Equipment Entry No.", "Entry No.");
        rRemarks.SetRange("Line No.", 10000);
        if rRemarks.FindSet then begin
            Observations := rRemarks.Textline;
            Modify;
        end;
    end;

    //[Scope('OnPrem')]
    procedure ValidateHours(pTimetableCode: Code[20]; pTimetableLineno: Integer; pStudentTeacherOpt: Option " ",Student,Teacher): Boolean
    var
        l_Calendar: Record Calendar;
        l_TimetableTeacher: Record "Timetable-Teacher";
        l_Calendar2: Record Calendar;
        l_TimetableTeacher2: Record "Timetable-Teacher";
        l_EquipmentEntry: Record "Equipment Entry";
    begin
        if pStudentTeacherOpt = pStudentTeacherOpt::Student then begin
            l_Calendar.Reset;
            l_Calendar.SetRange("Timetable Code", pTimetableCode);
            l_Calendar.SetRange("Line No.", pTimetableLineno);
            if l_Calendar.FindFirst then begin
                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    l_Calendar2.Reset;
                    l_Calendar2.SetRange("Filter Period", l_Calendar."Filter Period");
                    l_Calendar2.SetRange("Timetable Code", "Timetable Code");
                    l_Calendar2.SetRange("Line No.", "Timetable Line No.");
                    if l_Calendar2.FindFirst then begin
                        if (l_Calendar2."Start Hour" >= l_Calendar."Start Hour") and (l_Calendar2."Start Hour" <= l_Calendar."End Hour") then begin
                            exit(true);
                        end;
                        if (l_Calendar2."Start Hour" <= l_Calendar."Start Hour") and (l_Calendar2."End Hour" >= l_Calendar."Start Hour") then begin
                            exit(true);
                        end;
                        exit(false);
                    end;
                end;
                if "Student/Teacher" = "Student/Teacher"::Teacher then begin
                    l_TimetableTeacher2.Reset;
                    l_TimetableTeacher2.SetRange("Timetable Code", "Timetable Code");
                    l_TimetableTeacher2.SetRange("Timetable Line No.", "Timetable Line No.");
                    l_TimetableTeacher2.SetRange("Filter Period", l_Calendar."Filter Period");
                    if l_TimetableTeacher2.FindFirst then begin
                        if (l_TimetableTeacher2."Start Hour" >= l_Calendar."Start Hour") and
                           (l_TimetableTeacher2."Start Hour" <= l_Calendar."End Hour") then begin
                            exit(true);
                        end;
                        if (l_TimetableTeacher2."Start Hour" <= l_Calendar."Start Hour") and
                           (l_TimetableTeacher2."End Hour" >= l_Calendar."Start Hour") then begin
                            exit(true);
                        end;
                        exit(false);
                    end;
                end;
            end;
        end;
        if pStudentTeacherOpt = pStudentTeacherOpt::Teacher then begin
            l_TimetableTeacher.Reset;
            l_TimetableTeacher.SetRange("Timetable Code", pTimetableCode);
            l_TimetableTeacher.SetRange("Timetable Line No.", pTimetableLineno);
            if l_TimetableTeacher.FindFirst then begin
                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    l_Calendar2.Reset;
                    l_Calendar2.SetRange("Filter Period", l_TimetableTeacher."Filter Period");
                    l_Calendar2.SetRange("Timetable Code", "Timetable Code");
                    l_Calendar2.SetRange("Line No.", "Timetable Line No.");
                    if l_Calendar2.FindFirst then begin
                        if (l_Calendar2."Start Hour" >= l_TimetableTeacher."Start Hour") and
                           (l_Calendar2."Start Hour" <= l_TimetableTeacher."End Hour") then begin
                            exit(true);
                        end;
                        if (l_Calendar2."Start Hour" <= l_TimetableTeacher."Start Hour") and
                           (l_Calendar2."End Hour" >= l_TimetableTeacher."Start Hour") then begin
                            exit(true);
                        end;
                        exit(false);
                    end;
                end;
                if "Student/Teacher" = "Student/Teacher"::Teacher then begin
                    l_TimetableTeacher2.Reset;
                    l_TimetableTeacher2.SetRange("Timetable Code", "Timetable Code");
                    l_TimetableTeacher2.SetRange("Timetable Line No.", "Timetable Line No.");
                    l_TimetableTeacher2.SetRange("Filter Period", l_TimetableTeacher."Filter Period");
                    if l_TimetableTeacher2.FindFirst then begin
                        if (l_TimetableTeacher2."Start Hour" >= l_TimetableTeacher."Start Hour") and
                           (l_TimetableTeacher2."Start Hour" <= l_TimetableTeacher."End Hour") then begin
                            exit(true);
                        end;
                        if (l_TimetableTeacher2."Start Hour" <= l_TimetableTeacher."Start Hour") and
                           (l_TimetableTeacher2."End Hour" >= l_TimetableTeacher."Start Hour") then begin
                            exit(true);
                        end;
                        exit(false);
                    end;
                end;
            end;
        end;
    end;
}

