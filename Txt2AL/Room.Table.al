table 31009798 Room
{
    Caption = 'Room';
    DrillDownPageID = "Room List";
    LookupPageID = "Room List";

    fields
    {
        field(1; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
        }
        field(2; "Room Type"; Option)
        {
            Caption = 'Room Type';
            Description = 'MISI';
            OptionCaption = ' ,Regular,Laboratory,Infomatic,Workshop,Gym,Library,Videotheque,Recreation Room,Other';
            OptionMembers = " ",Regular,Laboratory,Infomatic,Workshop,Gym,Library,Videotheque,"Recreation Room",Other;
        }
        field(3; "Room Description"; Text[30])
        {
            Caption = 'Room Description';
        }
        field(4; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(5; "Responsibility Center"; Code[10])
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
        field(6; "Abbreviation Description"; Text[4])
        {
            Caption = 'Abbreviation Description';
            Description = 'Usada no Horario';
        }
        field(10; "Area"; Integer)
        {
            Caption = 'Area (m2)';
            Description = 'MISI - M2';
        }
        field(11; Capacity; Integer)
        {
            Caption = 'Reception Capacity (users)';
            Description = 'MISI - Nº Alunos';
        }
        field(12; "Average Users per Month"; Integer)
        {
            Caption = 'Average Users per Month';
            Description = 'MISI - Nº Alunos';
        }
        field(13; Operational; Option)
        {
            Caption = 'Operational';
            Description = 'MISI';
            OptionCaption = 'only in the Morning,only in the Afternoon,only at Night,Morning and Afternoon,Morning and Night,Afternoon and Night,Morning Afternoon and Night';
            OptionMembers = M,T,N,MT,MN,TN,MTN;
        }
    }

    keys
    {
        key(Key1; "Room Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        rClass.Reset;
        rClass.SetRange(Room, "Room Code");
        if rClass.FindFirst then
            Error(Text0005);

        rTimetableLines.Reset;
        rTimetableLines.SetRange(Room, "Room Code");
        if rTimetableLines.FindFirst then
            Error(Text0006);
    end;

    trigger OnInsert()
    begin
        if "Room Code" = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Room Nos.");
            NoSeriesMgt.InitSeries(rEduConfiguration."Room Nos.", xRec."No. Series", 0D, "Room Code", "No. Series");
        end;

        if rUserSetup.Get(UserId) then
            "Responsibility Center" := rUserSetup."Education Resp. Ctr. Filter";
    end;

    var
        rEduConfiguration: Record "Edu. Configuration";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cUserEducation: Codeunit "User Education";
        RespCenter: Record "Responsibility Center";
        Text0004: Label 'Your identification is set up to process from %1 %2 only.';
        rUserSetup: Record "User Setup";
        rClass: Record Class;
        Text0005: Label 'There already are Classes with the selected room.';
        Text0006: Label 'There already are Timetables with the selected room.';
        rTimetableLines: Record "Timetable Lines";

    //[Scope('OnPrem')]
    procedure AssistEdit(OldRoom: Record Room): Boolean
    var
        Room: Record Room;
    begin
        rEduConfiguration.Get;
        rEduConfiguration.TestField("Room Nos.");
        if NoSeriesMgt.SelectSeries(rEduConfiguration."Room Nos.", OldRoom."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("Room Code");
            Rec := Room;
            exit(true);
        end;
    end;
}

