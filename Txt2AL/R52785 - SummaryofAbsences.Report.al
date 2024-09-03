report 52785 "Summary of Absences"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SummaryofAbsences.rdlc';
    Caption = 'Summary of Absences';

    dataset
    {
        dataitem(Registration; Registration)
        {
            RequestFilterFields = Class, "Student Code No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(nomeEscola; nomeEscola)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Registration__Student_Code_No__; "Student Code No.")
            {
            }
            column(varNameStud; varNameStud)
            {
            }
            column(BeginingDate; BeginingDate)
            {
            }
            column(EndingDate; EndingDate)
            {
            }
            column(Summary_of_AbsencesCaption; Summary_of_AbsencesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Registration__Student_Code_No__Caption; FieldCaption("Student Code No."))
            {
            }
            column(Begining_Date_Caption; Begining_Date_CaptionLbl)
            {
            }
            column(Ending_Date_Caption; Ending_Date_CaptionLbl)
            {
            }
            column(Name_Caption; Name_CaptionLbl)
            {
            }
            column(Registration_School_Year; "School Year")
            {
            }
            column(Registration_Responsibility_Center; "Responsibility Center")
            {
            }
            column(Registration_Schooling_Year; "Schooling Year")
            {
            }
            dataitem("Registration Subjects"; "Registration Subjects")
            {
                DataItemLink = "Student Code No." = FIELD("Student Code No."), "School Year" = FIELD("School Year"), "Schooling Year" = FIELD("Schooling Year");
                DataItemTableView = SORTING("School Year", "Schooling Year", Class, Status, "Responsibility Center") WHERE(Status = FILTER(Cancelled | Transfer | Subscribed));
                RequestFilterFields = "Subjects Code";
                column(vArray_1_; vArray[1])
                {
                }
                column(vArray_2_; vArray[2])
                {
                }
                column(vArray_3_; vArray[3])
                {
                }
                column(vArray_4_; vArray[4])
                {
                }
                column(vArray_5_; vArray[5])
                {
                }
                column(vArray_6_; vArray[6])
                {
                }
                column(vArray_7_; vArray[7])
                {
                }
                column(vArray_8_; vArray[8])
                {
                }
                column(vArray_9_; vArray[9])
                {
                }
                column(vArray_10_; vArray[10])
                {
                }
                column(vClass; vClass)
                {
                }
                column(Registration_Subjects_Description; Description)
                {
                }
                column(Registration_Subjects_Status; Status)
                {
                }
                column(vArrayAbs_1_; vArrayAbs[1])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_2_; vArrayAbs[2])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_3_; vArrayAbs[3])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_4_; vArrayAbs[4])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_5_; vArrayAbs[5])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_6_; vArrayAbs[6])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_7_; vArrayAbs[7])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_8_; vArrayAbs[8])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_9_; vArrayAbs[9])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(vArrayAbs_10_; vArrayAbs[10])
                {
                    DecimalPlaces = 0 : 0;
                }
                column(text0002; text0002)
                {
                }
                column(vClassCaption; vClassCaptionLbl)
                {
                }
                column(Registration_Subjects_DescriptionCaption; FieldCaption(Description))
                {
                }
                column(Registration_Subjects_StatusCaption; FieldCaption(Status))
                {
                }
                column(Registration_Subjects_Student_Code_No_; "Student Code No.")
                {
                }
                column(Registration_Subjects_School_Year; "School Year")
                {
                }
                column(Registration_Subjects_Line_No_; "Line No.")
                {
                }
                column(Registration_Subjects_Schooling_Year; "Schooling Year")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                        CurrReport.Skip;


                    Clear(vArrayAbs);
                    for i := 1 to 9 do begin
                        if vcode[i] <> '' then begin
                            rAbsence.Reset;
                            rAbsence.SetCurrentKey("Timetable Code", "School Year", "Study Plan", Class, "Absence Type", "Student/Teacher Code No.");
                            if BeginingDate <> 0D then
                                rAbsence.SetRange(Day, BeginingDate, EndingDate)
                            else
                                rAbsence.SetRange("School Year", "Registration Subjects"."School Year");
                            rAbsence.SetRange("Student/Teacher Code No.", "Registration Subjects"."Student Code No.");
                            rAbsence.SetRange(Subject, "Registration Subjects"."Subjects Code");
                            rAbsence.SetRange("Subcategory Code", vcode[i]);
                            rAbsence.SetRange(Class, "Registration Subjects".Class);
                            if vMostraInci = 0 then
                                rAbsence.SetRange("Incidence Type", rAbsence."Incidence Type"::Default);
                            if vMostraInci = 1 then
                                rAbsence.SetRange("Incidence Type", rAbsence."Incidence Type"::Absence);

                            rAbsence.SetRange(Category, rAbsence.Category::Class);
                            if rAbsence.FindSet then
                                vArrayAbs[i] := rAbsence.Count;
                        end;
                    end;

                    for i := 1 to itotal - 1 do begin
                        vArrayAbs[itotal] += vArrayAbs[i];
                    end;


                    rClass.Reset;
                    rClass.SetRange(rClass.Class, "Registration Subjects".Class);
                    rClass.SetRange(rClass."School Year", "Registration Subjects"."School Year");
                    if rClass.FindFirst then
                        vClass := rClass."Schooling Year" + ' - ' + rClass."Class Letter";
                end;

                trigger OnPreDataItem()
                begin


                    LoopCount := 0;
                    rSubtype.Reset;
                    if varCategorycode <> '' then
                        rSubtype.SetRange("Subcategory Code", varCategorycode);
                    rSubtype.SetRange(Category, rSubtype.Category::Class);
                    if rSubtype.FindSet then
                        repeat
                            LoopCount := LoopCount + 1;
                            vArray[LoopCount] := rSubtype.Description;
                            vtype[LoopCount] := rSubtype.Category;
                            vcode[LoopCount] := rSubtype."Subcategory Code";
                        until (LoopCount = 9) or (rSubtype.Next = 0);
                    for i := 1 to 9 do begin
                        if vcode[i] = '' then begin
                            itotal := i;
                            i := 10;
                        end;
                    end;

                    vArray[itotal] := text0001;

                    // CurrReport.CreateTotals(vArrayAbs);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                rStudents.Reset;
                rStudents.SetRange("No.", "Student Code No.");
                if rStudents.FindSet then
                    varNameStud := rStudents.Name;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                LastFieldNo := FieldNo("Student Code No.");

                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;
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
                    group(Control1102065002)
                    {
                        ShowCaption = false;
                        field(BeginingDate; BeginingDate)
                        {
                            ApplicationArea = All;
                            Caption = 'Begining Date';
                        }
                        field(EndingDate; EndingDate)
                        {
                            ApplicationArea = All;
                            Caption = 'End Date';
                        }
                        field(varCategorycode; varCategorycode)
                        {
                            ApplicationArea = All;
                            Caption = 'Category Code';
                            TableRelation = "Sub Type"."Subcategory Code";

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                rSubtype.Reset;
                                rSubtype.SetRange(Category, rSubtype.Category::Class);
                                if rSubtype.Find('-') then begin
                                    if PAGE.RunModal(PAGE::Category, rSubtype) = ACTION::LookupOK then
                                        varCategorycode := rSubtype."Subcategory Code";
                                end;
                            end;
                        }
                        field(vMostraInci; vMostraInci)
                        {
                            ApplicationArea = All;
                            Caption = 'Show Incidence of type';
                            OptionCaption = 'Default,Absence,Both';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            vMostraInci := 2;
            EndingDate := WorkDate;
        end;
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInfo: Record "Company Information";
        vArray: array[10] of Text[60];
        LoopCount: Integer;
        rSubtype: Record "Sub Type";
        vArrayAbs: array[10] of Decimal;
        rAbsence: Record Absence;
        i: Integer;
        vtype: array[10] of Integer;
        vcode: array[10] of Code[20];
        itotal: Integer;
        text0001: Label 'Subject Total';
        text0002: Label 'Total';
        varSubtype: Code[60];
        BeginingDate: Date;
        EndingDate: Date;
        rStudents: Record Students;
        varNameStud: Text[60];
        varSubTypeType: Option Default,Absence;
        varCategorycode: Code[20];
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rClass: Record Class;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        vClass: Text[50];
        vMostraInci: Option Default,Absence,Both;
        Summary_of_AbsencesCaptionLbl: Label 'Summary of Absences';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Begining_Date_CaptionLbl: Label 'Begining Date:';
        Ending_Date_CaptionLbl: Label 'Ending Date:';
        Name_CaptionLbl: Label 'Name:';
        vClassCaptionLbl: Label 'Class';
}

