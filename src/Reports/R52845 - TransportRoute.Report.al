report 52845 "Transport Route"
{
    DefaultLayout = RDLC;
    RDLCLayout = './TransportRoute.rdlc';
    Caption = 'Transport Route';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Transport; Transport)
        {
            DataItemTableView = SORTING(Type, "Transport No.", "Line No.") WHERE(Type = CONST(Header));
            column(nomeEscola; nomeEscola)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(vTitle; vTitle)
            {
            }
            column(Transport__Transport_No__; "Transport No.")
            {
            }
            column(Transport_Description; Description)
            {
            }
            column(Transport__License_plate_; "License plate")
            {
            }
            column(Transport_Driver; Driver)
            {
            }
            column(Transport_Vendor; Vendor)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Stops__Estimated_Hour_Caption; Stops.FieldCaption("Estimated Hour"))
            {
            }
            column(Stops__Stop_Address_Caption; Stops.FieldCaption("Stop Address"))
            {
            }
            column(Transport__Transport_No__Caption; FieldCaption("Transport No."))
            {
            }
            column(Transport__License_plate_Caption; FieldCaption("License plate"))
            {
            }
            column(Transport_DriverCaption; FieldCaption(Driver))
            {
            }
            column(Transport_VendorCaption; FieldCaption(Vendor))
            {
            }
            column(Stops__Post_Code_Caption; Stops.FieldCaption("Post Code"))
            {
            }
            column(Stops_LocationCaption; Stops.FieldCaption(Location))
            {
            }
            column(Transport_Type; Type)
            {
            }
            column(Transport_Line_No_; "Line No.")
            {
            }
            column(vSpecificDay; vSpecificDay)
            {
            }
            dataitem(Stops; Transport)
            {
                DataItemLink = "Transport No." = FIELD("Transport No.");
                DataItemTableView = SORTING(Type, "Transport No.", "Line No.") WHERE(Type = FILTER(Lines));
                column(Stops__Estimated_Hour_; "Estimated Hour")
                {
                }
                column(Stops__Stop_Address_; "Stop Address")
                {
                }
                column(Stops__Post_Code_; "Post Code")
                {
                }
                column(Stops_Location; Location)
                {
                }
                column(Stops_Type; Type)
                {
                }
                column(Stops_Transport_No_; "Transport No.")
                {
                }
                column(Stops_Line_No_; "Line No.")
                {
                }
                dataitem("Students Non Lective Hours"; "Students Non Lective Hours")
                {
                    //DataItemLink = '';
                    DataItemTableView = SORTING("Student Code No.", "School Year", "Week Day", "Responsibility Center");
                    column(vStudentName; vStudentName)
                    {
                    }
                    column(Students_Non_Lective_Hours__Student_Code_No__; "Student Code No.")
                    {
                    }
                    column(vDay; vDay)
                    {
                    }
                    column(vClass; vClass)
                    {
                    }
                    column(Students_Non_Lective_Hours_School_Year; "School Year")
                    {
                    }
                    column(Students_Non_Lective_Hours_Week_Day; "Week Day")
                    {
                    }
                    column(intWD; intWD)
                    {
                    }
                    column(Students_Non_Lective_Hours_Responsibility_Center; "Responsibility Center")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if vStudent <> "Students Non Lective Hours"."Student Code No." then begin
                            Clear(vDay);
                            Show := false;
                        end;


                        if (("Students Non Lective Hours"."Collect Transport" = Stops."Transport No.") and
                           ("Students Non Lective Hours"."Estimated Colect Hour" = Stops."Estimated Hour")) or
                           (("Students Non Lective Hours"."Deliver Transport" = Stops."Transport No.") and
                           ("Students Non Lective Hours"."Estimated Deliver Hour" = Stops."Estimated Hour")) then begin

                            Show := true;
                            vDay := vDay + ' / ' + Format("Students Non Lective Hours"."Week Day");
                        end;

                        if rStudents.Get("Students Non Lective Hours"."Student Code No.") then vStudentName := rStudents.Name;

                        vStudent := "Students Non Lective Hours"."Student Code No.";
                        intWD := intWD + 1;
                        rRegistration.Reset;
                        rRegistration.SetRange(rRegistration."School Year", "School Year");
                        rRegistration.SetRange(rRegistration."Student Code No.", "Student Code No.");
                        rRegistration.SetRange(rRegistration.Status, rRegistration.Status::Subscribed);
                        if rRegistration.FindFirst then
                            vClass := rRegistration."Schooling Year" + '-' + rRegistration."Class Letter";
                    end;

                    trigger OnPreDataItem()
                    begin
                        //"Students Non Lective Hours".SETRANGE("Students Non Lective Hours"."School Year",vSchoolYear);
                        intWD := 0;
                    end;
                }
                dataitem("Students Non Lective Hours Day"; "Students Non Lective Hours")
                {
                    DataItemTableView = SORTING("Student Code No.", "School Year", "Week Day", "Responsibility Center");
                    column(vClass_Control1102065009; vClass)
                    {
                    }
                    column(vStudentName_Control1102065010; vStudentName)
                    {
                    }
                    column(Students_Non_Lective_Hours_Day__Student_Code_No__; "Student Code No.")
                    {
                    }
                    column(Students_Non_Lective_Hours_Day_School_Year; "School Year")
                    {
                    }
                    column(Students_Non_Lective_Hours_Day_Week_Day; "Week Day")
                    {
                    }
                    column(Students_Non_Lective_Hours_Day_Responsibility_Center; "Responsibility Center")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        rDate.Reset;
                        rDate.SetRange(rDate."Period Start", vSpecificDay);
                        if rDate.FindFirst then begin
                            if rDate."Period No." <> ("Students Non Lective Hours Day"."Week Day" + 1) then
                                CurrReport.Skip;
                        end;


                        if (("Students Non Lective Hours Day"."Collect Transport" = Stops."Transport No.") and
                           ("Students Non Lective Hours Day"."Estimated Colect Hour" = Stops."Estimated Hour")) or
                           (("Students Non Lective Hours Day"."Deliver Transport" = Stops."Transport No.") and
                           ("Students Non Lective Hours Day"."Estimated Deliver Hour" = Stops."Estimated Hour")) then begin

                            if rStudents.Get("Students Non Lective Hours Day"."Student Code No.") then vStudentName := rStudents.Name;
                            vStudent := "Students Non Lective Hours Day"."Student Code No.";

                            rRegistration.Reset;
                            rRegistration.SetRange(rRegistration."School Year", "School Year");
                            rRegistration.SetRange(rRegistration."Student Code No.", "Student Code No.");
                            rRegistration.SetRange(rRegistration.Status, rRegistration.Status::Subscribed);
                            if rRegistration.FindFirst then
                                vClass := rRegistration."Schooling Year" + '-' + rRegistration."Class Letter";


                            rTransportEntry.Reset;
                            rTransportEntry.SetRange(rTransportEntry."Entry Type", rTransportEntry."Entry Type"::"Student Transport");
                            rTransportEntry.SetRange(rTransportEntry."Student No.", "Students Non Lective Hours Day"."Student Code No.");
                            rTransportEntry.SetRange(rTransportEntry."Absence Day", vSpecificDay);
                            if rTransportEntry.FindLast then
                                if (((rTransportEntry."Collect Time" = Stops."Estimated Hour") and (rTransportEntry."Transport Collect Cancelled" = false))
                                   or
                                   ((rTransportEntry."Deliver Time" = Stops."Estimated Hour") and (rTransportEntry."Transport Deliver Cancelled" = false)))
                                   then
                                    CurrReport.Skip;


                        end else
                            CurrReport.Skip;
                    end;

                    trigger OnPreDataItem()
                    begin
                        //"Students Non Lective Hours Day".SETRANGE("Students Non Lective Hours Day"."School Year",vSchoolYear);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(vStudent);
                    Clear(vDay);
                    Clear(vClass);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                rTransportEntry.Reset;
                rTransportEntry.SetRange(rTransportEntry."School Year", vSchoolYear);//Normatica
                rTransportEntry.SetRange(rTransportEntry."Entry Type", rTransportEntry."Entry Type"::"Driver Absence");
                rTransportEntry.SetRange(rTransportEntry."Transport No.", Transport."Transport No.");
                if vSpecificDay <> 0D then rTransportEntry.SetRange(rTransportEntry."Absence Day", vSpecificDay);
                if rTransportEntry.FindLast then
                    Transport.Driver := rTransportEntry."New Driver";
            end;

            trigger OnPreDataItem()
            begin
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                if vTransport <> '' then
                    Transport.SetRange(Transport."Transport No.", vTransport);
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
                    field(vSchoolYear; vSchoolYear)
                    {
                        Caption = 'School Year';
                        TableRelation = "School Year";
                        ApplicationArea = All;
                    }
                    field(vTransport; vTransport)
                    {
                        Caption = 'Transport No.';
                        TableRelation = Transport."Transport No.";
                        ApplicationArea = All;
                    }
                    field(vSpecificDay; vSpecificDay)
                    {
                        Caption = 'Specific Day';
                        ApplicationArea = All;
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
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);

        //Filtros := classs.GETFILTERS;

        if vSpecificDay <> 0D then
            vTitle := StrSubstNo(Text0001, vSpecificDay)
        else
            vTitle := StrSubstNo(Text0001, '');
    end;

    var
        CompanyInfo: Record "Company Information";
        rStudents: Record Students;
        cUserEducation: Codeunit "User Education";
        rRespCenter: Record "Responsibility Center";
        rTransportEntry: Record "Transport & Lunch Entry ";
        nomeEscola: Text[128];
        rSchool: Record School;
        rRegistration: Record Registration;
        rDate: Record Date;
        Show: Boolean;
        vStudent: Code[20];
        vStudentName: Text[191];
        vDay: Text[250];
        vTransport: Code[20];
        vSchoolYear: Code[9];
        vClass: Text[30];
        vSpecificDay: Date;
        Text0001: Label 'Transport Route %1';
        vTitle: Text[100];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        intWD: Integer;
}

