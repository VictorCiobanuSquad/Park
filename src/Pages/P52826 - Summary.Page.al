#pragma implicitwith disable
page 52826 Summary
{
    Caption = 'Summary';
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Remarks;
    SourceTableView = WHERE("Type Remark" = FILTER(Summary));

    layout
    {
        area(content)
        {
            repeater(Control1102056000)
            {
                ShowCaption = false;
                field(Textline; Rec.Textline)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Summary';

                    trigger OnAssistEdit()
                    begin
                        if rCalendar.Class <> '' then begin
                            if rCalendar."Lecture Status" = rCalendar."Lecture Status"::Started then
                                varEditable := true;
                            if rCalendar."Lecture Status" = rCalendar."Lecture Status"::Summary then
                                varEditable := false;

                            //cRemarks.EditContactTextSummary("School Year", Class, Subject,
                            //"Sub-subject", "Schooling Year", "Study Plan Code", Day, "Calendar Line", "Timetable Code", varEditable);
                            CurrPage.Update(false);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Type Remark" := Rec."Type Remark"::Absence;
        Rec.Seperator := Rec.Seperator::"Carriage Return";
        Rec."Type Remark" := Rec."Type Remark"::Summary;

        //"Entry No." := cRemarks.GetLastNo;
        Rec."School Year" := rCalendar."School Year";
        Rec."Study Plan Code" := rCalendar."Study Plan";
        Rec."Type Education" := rCalendar.Type;
        Rec.Class := rCalendar.Class;
        Rec."Timetable Code" := rCalendar."Timetable Code";
        Rec."Calendar Line" := rCalendar."Line No.";
        Rec.Day := rCalendar."Filter Period";
        Rec.Subject := rCalendar.Subject;
        Rec."Sub-subject" := rCalendar."Sub-Subject Code";
    end;

    var
        rCalendar: Record Calendar;
        //cRemarks: Codeunit Codeunit52751;
        varEditable: Boolean;


    procedure SendHeader(pCalendar: Record Calendar)
    begin
        // This saves the header record in a global variable in the subform
        rCalendar := pCalendar;
    end;
}

#pragma implicitwith restore

