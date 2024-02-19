report 31009848 "Equipment Entry"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EquipmentEntry.rdlc';
    Caption = 'Equipment Entry';

    dataset
    {
        dataitem("Equipment Entry"; "Equipment Entry")
        {
            DataItemTableView = SORTING("Student/Teacher", "Student/Teacher Code No.", "Entry Type", "Timetable Code", "Timetable Line No.", "Equipment Type", "Equipment Code") WHERE(Open = CONST(false), Registered = CONST(true));
            RequestFilterFields = "Entry Type", "Equipment Code", "Student/Teacher", "Entry No.";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Equipment_Entry__Student_Teacher_Code_No__; "Student/Teacher Code No.")
            {
            }
            column(Equipment_Entry__Entry_Type_; "Entry Type")
            {
            }
            column(Equipment_Entry__Equipment_Type_; "Equipment Type")
            {
            }
            column(Equipment_Entry__Equipment_Code_; "Equipment Code")
            {
            }
            column(Equipment_Entry__Equipment_description_; "Equipment description")
            {
            }
            column(Equipment_Entry_Quantity; Quantity)
            {
            }
            column(Equipment_Entry__Available_Quantity_; "Available Quantity")
            {
            }
            column(varHourBegin; varHourBegin)
            {
            }
            column(varHourEnd; varHourEnd)
            {
            }
            column(varDate; varDate)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Lista_equipamentCaption; Lista_equipamentCaptionLbl)
            {
            }
            column(Equipment_Entry__Student_Teacher_Code_No__Caption; FieldCaption("Student/Teacher Code No."))
            {
            }
            column(Equipment_Entry__Entry_Type_Caption; FieldCaption("Entry Type"))
            {
            }
            column(Equipment_Entry__Equipment_Type_Caption; FieldCaption("Equipment Type"))
            {
            }
            column(Equipment_Entry__Equipment_Code_Caption; FieldCaption("Equipment Code"))
            {
            }
            column(Equipment_Entry__Equipment_description_Caption; FieldCaption("Equipment description"))
            {
            }
            column(Equipment_Entry_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Equipment_Entry__Available_Quantity_Caption; FieldCaption("Available Quantity"))
            {
            }
            column(Equipment_Entry_Entry_No_; "Entry No.")
            {
            }
            column(EE_int; int)
            {
            }

            trigger OnAfterGetRecord()
            begin
                rEquipmentEntry.Reset;
                rEquipmentEntry.Copy("Equipment Entry");
                int += 1;

                if "Student/Teacher" = "Student/Teacher"::Student then begin
                    rCalendar.Reset;
                    rCalendar.SetRange("Timetable Code", "Timetable Code");
                    rCalendar.SetRange("Line No.", "Timetable Line No.");
                    if rCalendar.FindFirst then begin
                        varHourBegin := rCalendar."Start Hour";
                        varHourEnd := rCalendar."End Hour";
                        varDate := rCalendar."Filter Period";
                    end;
                end else begin
                    rTimetableTeacher.Reset;
                    rTimetableTeacher.SetRange("Timetable Code", "Timetable Code");
                    rTimetableTeacher.SetRange("Timetable Line No.", "Timetable Line No.");
                    if rTimetableTeacher.FindFirst then begin
                        varHourBegin := rTimetableTeacher."Start Hour";
                        varHourEnd := rTimetableTeacher."End Hour";
                        varDate := rTimetableTeacher."Filter Period";
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(int);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(varBeginDate; varBeginDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Period';
                    }
                    field(varEndDate; varEndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Period';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            rRespCenter.Reset;
            rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
            nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
            varLocation := rRespCenter.City;
        end else begin
            rSchool.Reset;
            if rSchool.Find('-') then
                nomeEscola := rSchool."School Name";
            varLocation := rSchool.Location;
        end;
    end;

    var
        nomeEscola: Text[250];
        varLocation: Text[250];
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        CompanyInfo: Record "Company Information";
        cUserEducation: Codeunit "User Education";
        varHourBegin: Time;
        varHourEnd: Time;
        varBeginDate: Date;
        varEndDate: Date;
        varDate: Date;
        int: Integer;
        rCalendar: Record Calendar;
        rTimetableTeacher: Record "Timetable-Teacher";
        rEquipmentEntry: Record "Equipment Entry";
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Lista_equipamentCaptionLbl: Label 'Equipment List';
}

