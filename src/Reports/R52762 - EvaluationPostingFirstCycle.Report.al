report 52762 "Evaluation Posting First Cycle"
{
    Caption = 'Evaluation Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Structure Education Country"; "Structure Education Country")
        {
            DataItemTableView = SORTING(Country, Level, "Schooling Year") WHERE(Country = CONST('PT'), Level = CONST("1º Cycle"));
            dataitem("Registration Class"; "Registration Class")
            {
                DataItemLink = "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING(Class, "School Year", "Schooling Year", "Study Plan Code", "Student Code No.", Type, "Line No.") WHERE(Status = CONST(Subscribed));
                RequestFilterFields = Class;
                dataitem(Timetable; Timetable)
                {
                    DataItemLink = "School Year" = FIELD("School Year"), "Study Plan" = FIELD("Study Plan Code"), Class = FIELD(Class);
                    DataItemTableView = SORTING("Study Plan", Class);
                    dataitem("Timetable Lines"; "Timetable Lines")
                    {
                        DataItemLink = "Timetable Code" = FIELD("Timetable Code");
                        DataItemTableView = SORTING("Timetable Code", Day, "Start Hour");

                        trigger OnAfterGetRecord()
                        begin

                            if (varOldDay <> "Timetable Lines".Day) then
                                varCountDays := varCountDays + 1;

                            varOldDay := "Timetable Lines".Day;
                        end;

                        trigger OnPreDataItem()
                        begin

                            Clear(varOldDay);
                            Clear(varCountDays);
                        end;
                    }
                }
                dataitem(Absence; Absence)
                {
                    DataItemLink = "School Year" = FIELD("School Year"), "Study Plan" = FIELD("Study Plan Code"), Class = FIELD(Class), "Student/Teacher Code No." = FIELD("Student Code No.");
                    DataItemTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, Day, Type, "Line No. Timetable", "Incidence Type", "Incidence Code", Category, "Subcategory Code", "Student/Teacher", "Student/Teacher Code No.", "Responsibility Center", "Line No.");

                    trigger OnAfterGetRecord()
                    begin

                        if (Absence."Incidence Code" <> '') and (Absence."Absence Status" = Absence."Absence Status"::Justified) then
                            varCountAbsenceInj := varCountAbsenceInj + 1;

                        if (Absence."Incidence Code" <> '') and (Absence."Absence Status" = Absence."Absence Status"::Unjustified) then
                            varCountAbsenceJus := varCountAbsenceJus + 1;
                    end;

                    trigger OnPostDataItem()
                    begin

                        rTransitionRules.Reset;
                        rTransitionRules.SetRange(Level, "Structure Education Country".Level);
                        rTransitionRules.SetRange("Validation Type", rTransitionRules."Validation Type"::Absence);
                        if rTransitionRules.Find('-') then begin
                            repeat
                                varFI := Abs(varCountAbsenceInj - varCountAbsenceJus);
                                varLFI := (varCountDays * rTransitionRules."Maximum Absence Injustified");

                                if (rTransitionRules.Rules = rTransitionRules.Rules::"FI>LFI") then
                                    if varFI > varLFI then begin
                                        fApproval(rTransitionRules);
                                    end else begin
                                        rRegistration.Reset;
                                        rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
                                        rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
                                        if rRegistration.Find('-') then begin
                                            rRegistration."Actual Status" := rRegistration."Actual Status"::"Registration Annulled";
                                            rRegistration.Modify;
                                        end;
                                    end;
                            until rTransitionRules.Next = 0;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin

                        Clear(varCountAbsenceInj);
                        Clear(varCountAbsenceJus);
                        Clear(varFI);
                        Clear(varLFI);
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message(Text0001);
    end;

    var
        Text0001: Label 'The evaluation process ended successfully';
        rTransitionRules: Record "Transition Rules";
        rRegistration: Record Registration;
        varOldDay: Integer;
        varCountDays: Integer;
        varCountAbsenceInj: Integer;
        varCountAbsenceJus: Integer;
        varFI: Integer;
        varLFI: Integer;


    procedure fApproval(pTransitionRules: Record "Transition Rules")
    begin
        if pTransitionRules."Not Approved" then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
            rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
            if rRegistration.Find('-') then begin
                rRegistration."Actual Status" := rRegistration."Actual Status"::Registered;
                rRegistration.Modify;
            end;
        end;

        if pTransitionRules.Retained then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
            rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
            if rRegistration.Find('-') then begin
                //      rRegistration."Transition Status" := rRegistration."Transition Status"::"Ret";
                rRegistration.Modify;
            end;
        end;

        if pTransitionRules.Excluded then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
            rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
            if rRegistration.Find('-') then begin
                rRegistration."Actual Status" := rRegistration."Actual Status"::"Not Transited";
                rRegistration.Modify;
            end;
        end;

        if pTransitionRules."Resume School Process" then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
            rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
            if rRegistration.Find('-') then begin
                rRegistration."Actual Status" := rRegistration."Actual Status"::"Not Concluded";
                rRegistration.Modify;
            end;
        end;

        if pTransitionRules."Exam Blocked" then begin
            rRegistration.Reset;
            rRegistration.SetRange("Student Code No.", "Registration Class"."Student Code No.");
            rRegistration.SetRange(Status, rRegistration.Status::Subscribed);
            if rRegistration.Find('-') then begin
                rRegistration."Actual Status" := rRegistration."Actual Status"::Concluded;
                rRegistration.Modify;
            end;
        end;
    end;
}

