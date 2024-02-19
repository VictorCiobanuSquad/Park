#pragma implicitwith disable
page 31009906 "Sub-Equipment-Entry"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Equipment Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1102065000)
            {
                ShowCaption = false;
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Entry TypeEditable";
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = TypeEditable;
                }
                field("Student/Teacher Code No."; Rec."Student/Teacher Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = StudentTeacherCodeNoEditable;
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Equipment TypeEditable";
                }
                field("Equipment Code"; Rec."Equipment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Equipment CodeEditable";
                }
                field("Equipment description"; Rec."Equipment description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Equipment descriptionEditable";
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = QuantityEditable;
                }
                field("Available Quantity"; Rec."Available Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Observations; Rec.Observations)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        //if "Entry No." <> 0 then
                        //cuRemarks.EditEquipmentLineText("Entry No.");

                        Rec.UpdateObs;
                    end;
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = statusEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if varRegistered then
            if (Rec.Status = Rec.Status::" ") and (Rec."Entry Type" <> Rec."Entry Type"::Order) then
                statusEditable := false
            else
                statusEditable := true
        else
            statusEditable := true;
    end;

    trigger OnInit()
    begin
        QuantityEditable := true;
        "Equipment CodeEditable" := true;
        "Equipment TypeEditable" := true;
        statusEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Timetable Code" := rCalendar."Timetable Code";
        Rec."Timetable Line No." := rCalendar."Line No.";
        Rec.Type := rCalendar."Type Subject";
        Rec."Entry Type" := Rec."Entry Type"::Order;
        Rec."Student/Teacher" := varStudentTeacher;
        Rec."Student/Teacher Code No." := varStudentTeacherNo;
    end;

    var
        rCalendar: Record Calendar;
        rEquipmentEntry: Record "Equipment Entry";
        rRemarks: Record Remarks;
        //cuRemarks: Codeunit Codeunit31009751;
        varStudentTeacherNo: Code[20];
        varStudentTeacher: Option;
        varRegistered: Boolean;
        recEquipmentEntry: Record "Equipment Entry";
        xrecEquipmentEntry: Record "Equipment Entry";
        [InDataSet]
        statusEditable: Boolean;
        [InDataSet]
        "Entry TypeEditable": Boolean;
        [InDataSet]
        TypeEditable: Boolean;
        [InDataSet]
        StudentTeacherCodeNoEditable: Boolean;
        [InDataSet]
        "Equipment TypeEditable": Boolean;
        [InDataSet]
        "Equipment CodeEditable": Boolean;
        [InDataSet]
        "Equipment descriptionEditable": Boolean;
        [InDataSet]
        QuantityEditable: Boolean;

    //[Scope('OnPrem')]
    procedure SendHeader(pCalendar: Record Calendar)
    begin
        rCalendar := pCalendar;
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure SendFilters(pStudentTeacher: Option; pStudentTeacherNo: Code[20]; pRegistered: Boolean)
    begin
        varStudentTeacher := pStudentTeacher;
        varStudentTeacherNo := pStudentTeacherNo;
        varRegistered := pRegistered;
        CurrPage.Update(false);
    end;

    //[Scope('OnPrem')]
    procedure EditableFunc(pStatus: Boolean)
    begin
        if pStatus then begin
            "Entry TypeEditable" := false;
            TypeEditable := false;
            StudentTeacherCodeNoEditable := false;
            "Equipment TypeEditable" := false;
            "Equipment CodeEditable" := false;
            "Equipment descriptionEditable" := false;
            QuantityEditable := false;
        end else begin
            "Entry TypeEditable" := false;
            TypeEditable := false;
            StudentTeacherCodeNoEditable := false;
            "Equipment descriptionEditable" := false;
            "Equipment TypeEditable" := true;
            "Equipment CodeEditable" := true;
            QuantityEditable := true;
        end;
    end;

    local procedure StatusOnActivate()
    begin
        if varRegistered then
            if (Rec.Status = Rec.Status::" ") and (Rec."Entry Type" <> Rec."Entry Type"::Order) then
                statusEditable := false
            else
                statusEditable := true
        else
            statusEditable := true;
    end;

    local procedure OnBeforePutRecord()
    begin
        if varRegistered then
            Rec.SetRange(Open, false)
        else
            Rec.SetRange(Open, true);
    end;
}

#pragma implicitwith restore

