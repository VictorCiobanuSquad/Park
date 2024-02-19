report 31009824 "Individual Absences List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './IndividualAbsencesList.rdlc';
    Caption = 'Individual Absences List';

    dataset
    {
        dataitem(Class; Class)
        {
            DataItemTableView = SORTING(Class, "School Year");
            column(Class_Class; Class)
            {
            }
            column(Class_School_Year; "School Year")
            {
            }
            dataitem(Registration; Registration)
            {
                DataItemLink = "School Year" = FIELD("School Year"), Class = FIELD(Class);
                DataItemTableView = SORTING("Student Code No.", "School Year", "Responsibility Center");
                column(varClassDirector; varClassDirector)
                {
                }
                column(varNameStud; varNameStud)
                {
                }
                column(EndingDate; EndingDate)
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(Registration__Student_Code_No__; "Student Code No.")
                {
                }
                column(BeginingDate; BeginingDate)
                {
                }
                column(nomeEscola; nomeEscola)
                {
                }
                //  column(CurrReport_PAGENO;CurrReport.PageNo)
                //  {
                //  }
                column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
                {
                }
                column(Class_DirectorCaption; Class_DirectorCaptionLbl)
                {
                }
                column(Ending_Date_Caption; Ending_Date_CaptionLbl)
                {
                }
                column(Registration__Student_Code_No__Caption; FieldCaption("Student Code No."))
                {
                }
                column(Begining_Date_Caption; Begining_Date_CaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Name_Caption; Name_CaptionLbl)
                {
                }
                column(Individual_Absences_ListCaption; Individual_Absences_ListCaptionLbl)
                {
                }
                column(Registration_School_Year; "School Year")
                {
                }
                column(Registration_Responsibility_Center; "Responsibility Center")
                {
                }
                column(Registration_Class; Class)
                {
                }
                column(Absence_DayCaption; Absence.FieldCaption(Day))
                {
                }
                column(VarTimeCaption; VarTimeCaptionLbl)
                {
                }
                column(Absence__Subcategory_Code_Caption; Absence.FieldCaption("Subcategory Code"))
                {
                }
                column(Absence__Absence_Status_Caption; Absence.FieldCaption("Absence Status"))
                {
                }
                column(varSubjectDescCaption; varSubjectDescCaptionLbl)
                {
                }
                column(VarCountCaption; VarCountCaptionLbl)
                {
                }
                column(Absence__Incidence_Description_Caption; Absence.FieldCaption("Incidence Description"))
                {
                }
                column(Absence_CategoryCaption; Absence.FieldCaption(Category))
                {
                }
                column(Absence__Justified_Description_Caption; Absence.FieldCaption("Justified Description"))
                {
                }
                column(Absence_ObservationsCaption; Absence.FieldCaption(Observations))
                {
                }
                dataitem(Absence; Absence)
                {
                    DataItemLink = "Student/Teacher Code No." = FIELD("Student Code No."), "School Year" = FIELD("School Year");
                    DataItemTableView = SORTING("Timetable Code", "School Year", "Study Plan", Class, "Absence Type", "Student/Teacher Code No.") ORDER(Ascending) WHERE("Student/Teacher" = FILTER(Student));
                    column(Absence_Day; Day)
                    {
                    }
                    column(Absence__Subcategory_Code_; "Subcategory Code")
                    {
                    }
                    column(Absence__Absence_Status_; "Absence Status")
                    {
                    }
                    column(varSubjectDesc; varSubjectDesc)
                    {
                    }
                    column(VarTime; VarTime)
                    {
                    }
                    column(VarCount; VarCount)
                    {
                    }
                    column(Absence__Incidence_Description_; "Incidence Description")
                    {
                    }
                    column(Absence_Category; Category)
                    {
                    }
                    column(Absence__Justified_Description_; "Justified Description")
                    {
                    }
                    column(Absence_Observations; Observations)
                    {
                    }
                    column(Absence_Timetable_Code; "Timetable Code")
                    {
                    }
                    column(Absence_School_Year; "School Year")
                    {
                    }
                    column(Absence_Study_Plan; "Study Plan")
                    {
                    }
                    column(Absence_Class; Class)
                    {
                    }
                    column(Absence_Type; Type)
                    {
                    }
                    column(Absence_Line_No__Timetable; "Line No. Timetable")
                    {
                    }
                    column(Absence_Incidence_Type; "Incidence Type")
                    {
                    }
                    column(Absence_Incidence_Code; "Incidence Code")
                    {
                    }
                    column(Absence_Student_Teacher; "Student/Teacher")
                    {
                    }
                    column(Absence_Student_Teacher_Code_No_; "Student/Teacher Code No.")
                    {
                    }
                    column(Absence_Responsibility_Center; "Responsibility Center")
                    {
                    }
                    column(Absence_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(VarTime);
                        Clear(varSubjectDesc);

                        // SUBJECT DESCRIPTION //
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Absence."Study Plan");
                        rCourseLines.SetRange("Subject Code", Absence.Subject);
                        if rCourseLines.FindSet then begin
                            if rCourseLines."Report Descripton" <> '' then
                                varSubjectDesc := rCourseLines."Report Descripton"
                            else
                                varSubjectDesc := rCourseLines."Subject Description";
                        end else begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange("School Year", varSchoolYear);
                            rStudyPlanLines.SetRange(Code, Absence."Study Plan");
                            rStudyPlanLines.SetRange("Subject Code", Absence.Subject);
                            if rStudyPlanLines.FindSet then begin
                                if rStudyPlanLines."Report Descripton" <> '' then
                                    varSubjectDesc := rStudyPlanLines."Report Descripton"
                                else
                                    varSubjectDesc := rStudyPlanLines."Subject Description";
                            end;
                        end;
                        /////////////////////////

                        // Subject Time Calender //

                        /*
                        rTimeTableLines.RESET;
                        rTimeTableLines.SETRANGE("Timetable Code",Absence."Timetable Code");
                        IF varClass <> '' THEN
                           rTimeTableLines.SETRANGE(Class,varClass)
                        ELSE
                           rTimeTableLines.SETRANGE(Class,Absence.Class);
                        rTimeTableLines.SETRANGE("Line No.",Absence."Line No. Timetable");
                        rTimeTableLines.SETRANGE(Subject,Absence.Subject);
                        IF rTimeTableLines.FINDSET THEN
                           VarTime := FORMAT(rTimeTableLines.Time);
                        
                        */
                        rCalendar.Reset;
                        rCalendar.SetRange(rCalendar."Timetable Code", Absence."Timetable Code");
                        if varClass <> '' then
                            rCalendar.SetRange(Class, varClass)
                        else
                            rCalendar.SetRange(Class, Absence.Class);
                        rCalendar.SetRange(rCalendar."Line No.", Absence."Line No. Timetable");
                        rCalendar.SetRange(Subject, Absence.Subject);
                        if rCalendar.FindSet then
                            VarTime := Format(rCalendar.Times);

                        //////////////////////////

                        VarCount += 1;

                    end;

                    trigger OnPreDataItem()
                    begin
                        if (BeginingDate <> 0D) and (EndingDate <> 0D) then
                            SetRange(Day, BeginingDate, EndingDate);
                        if varCategoryCode <> '' then
                            SetRange("Subcategory Code", varCategoryCode);
                        if vShowAll = false then
                            SetRange(Category, Absence.Category::Class);
                        if VarSubjectCode <> '' then
                            SetRange(Subject, VarSubjectCode);
                    end;
                }

                trigger OnAfterGetRecord()
                begin

                    rClass.Reset;
                    rClass.SetRange(Class, Registration.Class);
                    rClass.SetRange("School Year", varSchoolYear);
                    if rClass.FindSet then
                        varClassDirector := rClass."Class Director Name";

                    rStudents.Reset;
                    rStudents.SetRange("No.", Registration."Student Code No.");
                    if rStudents.FindSet then
                        varNameStud := rStudents.Name;

                    Clear(VarCount);
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Student Code No.");

                    if varStudentNo <> '' then SetRange("Student Code No.", varStudentNo);
                    if varSchoolYear = '' then varSchoolYear := cStudentsRegistration.GetShoolYearActive;
                    SetRange("School Year", varSchoolYear);
                    if varClass <> '' then SetRange(Class, varClass);
                end;
            }

            trigger OnPreDataItem()
            begin
                if (varClass = '') and (varStudentNo = '') then Error(Text0001);

                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);


                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.FindFirst then
                        nomeEscola := rSchool."School Name";
                end;



                if varClass <> '' then SetRange(Class, varClass);
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
                    field(varSchoolYear; varSchoolYear)
                    {
                        Caption = 'School Year';
                        Editable = false;
                    }
                    field(Class; varClass)
                    {
                        Caption = 'Class';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rClassTemp: Record Class temporary;
                            l_rStruEduCountry: Record "Structure Education Country";
                            l_rClass: Record Class;
                            l_rRegistrationClass: Record "Registration Class";
                        begin
                            if varStudentNo = '' then begin
                                l_rStruEduCountry.Reset;
                                if l_rStruEduCountry.FindSet then begin
                                    repeat
                                        l_rClass.Reset;
                                        l_rClass.SetRange("Schooling Year", l_rStruEduCountry."Schooling Year");
                                        if l_rClass.FindSet then begin
                                            repeat
                                                l_rClassTemp.Reset;
                                                l_rClassTemp.TransferFields(l_rClass);
                                                l_rClassTemp.Insert;
                                            until l_rClass.Next = 0;
                                        end;
                                    until l_rStruEduCountry.Next = 0;
                                    if PAGE.RunModal(PAGE::"Class List", l_rClassTemp) = ACTION::LookupOK then begin
                                        varClass := l_rClassTemp.Class;
                                        varSchoolYear := l_rClassTemp."School Year";
                                        if VarSchoolingYear = '' then
                                            VarSchoolingYear := l_rClassTemp."Schooling Year";
                                    end;
                                end;
                            end else begin
                                l_rStruEduCountry.Reset;
                                if l_rStruEduCountry.FindSet then begin
                                    repeat
                                        l_rRegistrationClass.Reset;
                                        l_rRegistrationClass.SetRange("Student Code No.", varStudentNo);
                                        l_rRegistrationClass.SetRange("Schooling Year", l_rStruEduCountry."Schooling Year");
                                        if l_rRegistrationClass.FindSet then begin
                                            repeat
                                                l_rClass.Reset;
                                                l_rClass.SetRange(Class, l_rRegistrationClass.Class);
                                                l_rClass.SetRange("Schooling Year", l_rStruEduCountry."Schooling Year");
                                                if l_rClass.FindSet then begin
                                                    l_rClassTemp.Reset;
                                                    l_rClassTemp.TransferFields(l_rClass);
                                                    l_rClassTemp.Insert;
                                                end;
                                            until l_rRegistrationClass.Next = 0;
                                        end;
                                    until l_rStruEduCountry.Next = 0;
                                    if PAGE.RunModal(PAGE::"Class List", l_rClassTemp) = ACTION::LookupOK then begin
                                        varClass := l_rClassTemp.Class;
                                        varSchoolYear := l_rClassTemp."School Year";
                                        if VarSchoolingYear = '' then
                                            VarSchoolingYear := l_rClassTemp."Schooling Year";
                                    end;
                                end;
                            end;
                        end;
                    }
                    field(varStudentNo; varStudentNo)
                    {
                        Caption = 'No.';
                        TableRelation = Students."No.";

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rStudentsTemp: Record Students temporary;
                            l_rStudents: Record Students;
                            l_rRegistration: Record Registration;
                        begin
                            if varClass <> '' then begin
                                l_rRegistration.Reset;
                                l_rRegistration.SetRange("Schooling Year", VarSchoolingYear);
                                l_rRegistration.SetRange(Class, varClass);
                                if l_rRegistration.Find('-') then begin
                                    repeat
                                        l_rStudents.Reset;
                                        l_rStudents.SetRange("No.", l_rRegistration."Student Code No.");
                                        if l_rStudents.Find('-') then begin
                                            l_rStudentsTemp.Reset;
                                            l_rStudentsTemp.TransferFields(l_rStudents);
                                            l_rStudentsTemp.Insert;
                                        end;
                                    until l_rRegistration.Next = 0;
                                    if PAGE.RunModal(PAGE::"Students List", l_rStudentsTemp) = ACTION::LookupOK then begin
                                        varStudentNo := l_rStudentsTemp."No.";
                                    end;
                                end;
                            end else begin
                                if PAGE.RunModal(PAGE::"Students List", l_rStudents) = ACTION::LookupOK then begin
                                    varStudentNo := l_rStudents."No.";
                                end;
                            end;
                        end;
                    }
                    field(VarSubjectCode; VarSubjectCode)
                    {
                        Caption = 'Subjects';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            l_rRegistrationSubjects: Record "Registration Subjects";
                            l_rSubjectsTemp: Record Subjects temporary;
                        begin
                            if varClass <> '' then begin
                                l_rRegistrationSubjects.Reset;
                                l_rRegistrationSubjects.SetRange(Class, varClass);
                                l_rRegistrationSubjects.SetRange("School Year", varSchoolYear);
                                l_rRegistrationSubjects.SetRange("Schooling Year", VarSchoolingYear);
                                l_rRegistrationSubjects.SetRange(Enroled, true);
                                if varStudentNo <> '' then
                                    l_rRegistrationSubjects.SetRange("Student Code No.", varStudentNo);
                                if l_rRegistrationSubjects.FindSet then begin
                                    repeat
                                        rSubject.Reset;
                                        rSubject.SetRange(Code, l_rRegistrationSubjects."Subjects Code");
                                        rSubject.SetRange(Type, rSubject.Type::Subject);
                                        if rSubject.FindFirst then begin
                                            l_rSubjectsTemp.Reset;
                                            l_rSubjectsTemp.SetRange(Code, rSubject.Code);
                                            l_rSubjectsTemp.SetRange(Type, rSubject.Type::Subject);
                                            if not l_rSubjectsTemp.FindFirst then begin
                                                l_rSubjectsTemp.Init;
                                                l_rSubjectsTemp.TransferFields(rSubject);
                                                l_rSubjectsTemp.Insert;
                                            end;
                                        end;
                                    until l_rRegistrationSubjects.Next = 0;
                                    l_rSubjectsTemp.Reset;
                                    if PAGE.RunModal(PAGE::"Subject List", l_rSubjectsTemp) = ACTION::LookupOK then begin
                                        VarSubjectCode := l_rSubjectsTemp.Code;
                                    end;
                                end;
                            end;
                        end;
                    }
                    field(varCategoryCode; varCategoryCode)
                    {
                        Caption = 'Category Code';
                        TableRelation = "Sub Type"."Subcategory Code";

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            rSubType.Reset;
                            rSubType.SetRange(Category, rSubType.Category::Class);
                            if rSubType.Find('-') then begin
                                if PAGE.RunModal(PAGE::Category, rSubType) = ACTION::LookupOK then
                                    varCategoryCode := rSubType."Subcategory Code";
                            end;
                        end;
                    }
                    field(BeginingDate; BeginingDate)
                    {
                        Caption = 'Begining Date';
                    }
                    field(EndingDate; EndingDate)
                    {
                        Caption = 'End Date';
                    }
                    field(vShowAll; vShowAll)
                    {
                        Caption = 'Show Incidences of Cantine, Bus and Schoolyard';
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

    var
        rClass: Record Class;
        rCourseLines: Record "Course Lines";
        rStudyPlanLines: Record "Study Plan Lines";
        rTimeTableLines: Record "Timetable Lines";
        rCalendar: Record Calendar;
        rSubType: Record "Sub Type";
        CompanyInfo: Record "Company Information";
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rSubject: Record Subjects;
        rStudents: Record Students;
        cStudentsRegistration: Codeunit "Students Registration";
        varClassDirector: Text[250];
        varSchoolYear: Code[20];
        varClass: Code[20];
        varSubjectDesc: Text[250];
        VarTime: Text[50];
        varNameStud: Text[250];
        varStudentNo: Code[20];
        varCategoryCode: Code[20];
        VarSubjectCode: Code[20];
        VarSchoolingYear: Code[20];
        VarCount: Integer;
        nomeEscola: Text[250];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        BeginingDate: Date;
        EndingDate: Date;
        cUserEducation: Codeunit "User Education";
        vShowAll: Boolean;
        Text0001: Label 'Fill Class or No.';
        Class_DirectorCaptionLbl: Label 'Class Director';
        Ending_Date_CaptionLbl: Label 'Ending Date:';
        Begining_Date_CaptionLbl: Label 'Begining Date:';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Name_CaptionLbl: Label 'Name:';
        Individual_Absences_ListCaptionLbl: Label 'Individual Absences List';
        VarTimeCaptionLbl: Label 'Time';
        varSubjectDescCaptionLbl: Label 'Subjects';
        VarCountCaptionLbl: Label 'Num';
}

