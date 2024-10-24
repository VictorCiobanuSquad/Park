#pragma implicitwith disable
page 52971 "Calendar Base Line"
{
    Caption = 'Calendar Base Subform';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(CurrentCalendarCode; CurrentCalendarCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Base Calendar Code';
                    Editable = false;
                    Visible = false;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date';
                    Editable = false;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Day';
                    Editable = false;
                }
                field(WeekNo; WeekNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Week No.';
                    Editable = false;
                    Visible = false;
                }
                field(Nonworking; Nonworking)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Nonworking';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Nonworking := TimetableCalendarMgt.CheckDateStatus(CurrentCalendarCode, Rec."Period Start", Description);
        WeekNo := Date2DWY(Rec."Period Start", 2);
        CurrentCalendarCodeOnFormat;
        PeriodStartOnFormat;
        PeriodNameOnFormat;
        DescriptionOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(TimetableCalendarMgt.FindDate(Which, Rec, ItemPeriodLength));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(TimetableCalendarMgt.NextDate(Steps, Rec, ItemPeriodLength));
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        Rec.SetFilter("Period Start", '>%1', 20000101D);
    end;

    var
        Item: Record Item;
        PeriodFormMgt: Codeunit PeriodPageManagement;
        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        Nonworking: Boolean;
        Description: Text[50];
        CurrentCalendarCode: Code[10];
        BaseCalendarChangeEDU: Record "Base Calendar ChangeEDU";
        WeekNo: Integer;
        TimetableCalendarMgt: Codeunit "Timetable Calendar Mgt";


    procedure SetCalendarCode(CalendarCode: Code[10])
    begin
        CurrentCalendarCode := CalendarCode;
        CurrPage.Update;
    end;


    procedure UpdateBaseCalendarChanges()
    begin
        BaseCalendarChangeEDU.Reset;
        BaseCalendarChangeEDU.SetRange("Base Calendar Code", CurrentCalendarCode);
        BaseCalendarChangeEDU.SetRange(Date, Rec."Period Start");
        BaseCalendarChangeEDU.SetRange(Type, BaseCalendarChangeEDU.Type::Lines);
        if BaseCalendarChangeEDU.Find('-') then
            BaseCalendarChangeEDU.Delete;

        BaseCalendarChangeEDU.Init;
        BaseCalendarChangeEDU."Base Calendar Code" := CurrentCalendarCode;
        BaseCalendarChangeEDU.Date := Rec."Period Start";
        BaseCalendarChangeEDU.Description := Description;
        BaseCalendarChangeEDU.Nonworking := Nonworking;
        BaseCalendarChangeEDU.Day := Rec."Period No.";
        BaseCalendarChangeEDU.Type := BaseCalendarChangeEDU.Type::Lines;
        BaseCalendarChangeEDU.Insert;
    end;


    procedure GetCurrentDate(): Date
    begin
        exit(Rec."Period Start");
    end;

    local procedure CurrentCalendarCodeOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure PeriodStartOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure PeriodNameOnFormat()
    begin
        if Nonworking then;
    end;

    local procedure DescriptionOnFormat()
    begin
        if Nonworking then;
    end;
}

#pragma implicitwith restore

