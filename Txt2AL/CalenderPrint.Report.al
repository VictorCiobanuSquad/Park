report 31009840 "Calender Print"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CalenderPrint.rdlc';

    dataset
    {
        dataitem(Timetable; Timetable)
        {
            dataitem("Integer"; "Integer")
            {

                trigger OnAfterGetRecord()
                var
                    l_rTimetablesLinesTEMP: Record "Timetable Lines" temporary;
                    l_rTimetablesLines: Record "Timetable Lines";
                begin
                    Clear(int);
                    for int := 1 to 7 do begin
                        l_rTimetablesLines.Reset;
                        l_rTimetablesLines.SetRange("Day Description", int - 1);
                        if l_rTimetablesLines.FindSet then
                            vDayDescription[1, int] := l_rTimetablesLines."Day Description";
                    end;

                    l_rTimetablesLines.Reset;
                    l_rTimetablesLines.SetRange("Timetable Code", Timetable."Timetable Code");
                    if l_rTimetablesLines.FindSet then;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1);
                end;
            }
        }
        dataitem("Timetable Lines"; "Timetable Lines")
        {
            DataItemTableView = SORTING("Timetable Code", Day, "Start Hour");
            column(vDayDescription_1_1_; vDayDescription[1, 1])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_2_; vDayDescription[1, 2])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_3_; vDayDescription[1, 3])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_4_; vDayDescription[1, 4])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_5_; vDayDescription[1, 5])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_6_; vDayDescription[1, 6])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(vDayDescription_1_7_; vDayDescription[1, 7])
            {
                OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
                OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            }
            column(Timetable_Lines__Start_Hour_; "Start Hour")
            {
            }
            column(Timetable_Lines__End_Hour_; "End Hour")
            {
            }
            column(vSubject_1_1_; vSubject[1, 1])
            {
            }
            column(vSubject_1_2_; vSubject[1, 2])
            {
            }
            column(vSubject_1_3_; vSubject[1, 3])
            {
            }
            column(vSubject_1_4_; vSubject[1, 4])
            {
            }
            column(vSubject_1_5_; vSubject[1, 5])
            {
            }
            column(vSubject_1_6_; vSubject[1, 6])
            {
            }
            column(vSubject_1_7_; vSubject[1, 7])
            {
            }
            column(Timetable_Lines_Timetable_Code; "Timetable Code")
            {
            }
            column(Timetable_Lines_Class; Class)
            {
            }
            column(Timetable_Lines_Template_Code; "Template Code")
            {
            }
            column(Timetable_Lines_Line_No_; "Line No.")
            {
            }
            dataitem("Teacher Timetable Lines"; "Teacher Timetable Lines")
            {
                DataItemLink = "Timetable Code" = FIELD("Timetable Code"), "Timetable Line No." = FIELD("Line No."), Day = FIELD(Day);
            }

            trigger OnAfterGetRecord()
            begin
                if "Timetable Lines"."Day Description" = 0 then
                    vSubject[1, 1] := "Timetable Lines".Subject;
                if "Timetable Lines"."Day Description" = 1 then
                    vSubject[1, 2] := "Timetable Lines".Subject;
            end;
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

    trigger OnInitReport()
    begin
        Error('');
    end;

    var
        vDayDescription: array[1, 7] of Option;
        vSubject: array[1, 7] of Text[50];
        int: Integer;
}

