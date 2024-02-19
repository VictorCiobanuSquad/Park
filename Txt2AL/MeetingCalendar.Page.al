#pragma implicitwith disable
page 31009979 "Meeting Calendar"
{
    Caption = 'Meeting Calendar';
    DataCaptionFields = "Filter Period", Meeting, Target;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Timetable-Teacher";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(vStartDate; vStartDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnValidate()
                    begin
                        vEndDate := vStartDate;
                        InsertFormLines;
                        vStartDateOnAfterValidate;
                    end;
                }
                field(vEndDate; vEndDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnValidate()
                    begin
                        InsertFormLines;
                        vEndDateOnAfterValidate;
                    end;
                }
                field(vMeeting; vMeeting)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Meeting';
                    OptionCaption = ' ,Class,Department,Head Department,Level';

                    trigger OnValidate()
                    begin
                        InsertFormLines;
                        vMeetingOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110015)
            {
                ShowCaption = false;
                field("Filter Period"; Rec."Filter Period")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Week Day"; Rec."Week Day")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Times; Rec.Times)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Start Hour"; Rec."Start Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("End Hour"; Rec."End Hour")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Meeting; Rec.Meeting)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Target; Rec.Target)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Minute")
            {
                Caption = '&Minute';
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    rTemplates: Record Templates;
                    fTemplates: Page Templates;
                begin
                    Clear(fTemplates);
                    rTemplates.Reset;
                    if Rec.Meeting = Rec.Meeting::Class then rTemplates.SetRange(Type, rTemplates.Type::"Class Meeting");
                    if Rec.Meeting = Rec.Meeting::Department then rTemplates.SetRange(Type, rTemplates.Type::"Department Meeting");
                    if Rec.Meeting = Rec.Meeting::"Head Department" then rTemplates.SetRange(Type, rTemplates.Type::"Head Department Meeting");
                    if Rec.Meeting = Rec.Meeting::Level then rTemplates.SetRange(Type, rTemplates.Type::"Level Meeting");
                    fTemplates.SetTableView(rTemplates);
                    fTemplates.SetFormMinutes(Rec);
                    fTemplates.LookupMode(true);
                    fTemplates.RunModal;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
    end;

    var
        vMeeting: Option " ",Class,Department,"Head Department",Level;
        vStartDate: Date;
        vEndDate: Date;
        cUserEducation: Codeunit "User Education";

    //[Scope('OnPrem')]
    procedure InsertFormLines()
    var
        l_TimetableTeacher: Record "Timetable-Teacher";
    begin
        Rec.Reset;
        Rec.DeleteAll;

        l_TimetableTeacher.Reset;
        l_TimetableTeacher.SetFilter(l_TimetableTeacher.Meeting, '<>0');
        if (vStartDate <> 0D) and (vEndDate <> 0D) then
            l_TimetableTeacher.SetRange(l_TimetableTeacher."Filter Period", vStartDate, vEndDate);
        if vMeeting <> 0 then
            l_TimetableTeacher.SetRange(l_TimetableTeacher.Meeting, vMeeting);
        if l_TimetableTeacher.FindSet then begin
            repeat
                Rec.SetRange("Filter Period", l_TimetableTeacher."Filter Period");
                Rec.SetRange(Subject, l_TimetableTeacher.Subject);
                Rec.SetRange("Start Hour", l_TimetableTeacher."Start Hour");
                Rec.SetRange(Meeting, l_TimetableTeacher.Meeting);
                Rec.SetRange(Target, l_TimetableTeacher.Target);
                Rec.SetRange(Level, l_TimetableTeacher.Level);
                if not Rec.FindFirst then begin
                    Rec.Init;
                    Rec.TransferFields(l_TimetableTeacher);
                    Rec."Teacher Name" := '';
                    Rec.Insert;
                end;
            until l_TimetableTeacher.Next = 0;
            Rec.SetRange("Filter Period");
            Rec.SetRange(Subject);
            Rec.SetRange("Start Hour");
            Rec.SetRange(Meeting);
            Rec.SetRange(Target);
            Rec.SetRange(Level);

        end;
    end;

    local procedure vStartDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure vEndDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure vMeetingOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

