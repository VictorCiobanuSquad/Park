report 52772 "Students Subject"
{
    DefaultLayout = RDLC;
    RDLCLayout = './StudentsSubject.rdlc';
    Caption = 'Students Subject';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Registration Subjects"; "Registration Subjects")
        {
            DataItemTableView = SORTING("Subjects Code", "Student Code No.");
            RequestFilterFields = "Subjects Code", "School Year", Status, Class, Turn, "Mandatory/Optional Type";
            column(vTotal_Control1102065012Caption; vTotal_Control1102065012CaptionLbl)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Filtros; Filtros)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(TeacherName; TeacherName)
            {
            }
            column(Registration_Subjects_Description; Description)
            {
            }
            column(Registration_Subjects__Subjects_Code_; "Subjects Code")
            {
            }
            column(vTotal; vTotal)
            {
            }
            column(Students_SubjectCaption; Students_SubjectCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FiltersCaption; FiltersCaptionLbl)
            {
            }
            column(TeacherCaption; TeacherCaptionLbl)
            {
            }
            column(StatusCaption; StatusCaptionLbl)
            {
            }
            column(Class_No_Caption; Class_No_CaptionLbl)
            {
            }
            column(ClassCaption; ClassCaptionLbl)
            {
            }
            column(Students_NameCaption; Students.FieldCaption(Name))
            {
            }
            column(Registration_Subjects__Subjects_Code_Caption; FieldCaption("Subjects Code"))
            {
            }
            column(Students__No__Caption; Students__No__CaptionLbl)
            {
            }
            column(TurnoCaption; TurnoCaptionLbl)
            {
            }
            column(vTotalCaption; vTotalCaptionLbl)
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
            dataitem(Students; Students)
            {
                DataItemLink = "No." = FIELD("Student Code No.");
                DataItemTableView = SORTING("No.") ORDER(Descending);
                column(Students__No__; "No.")
                {
                }
                column(Students_Name; Name)
                {
                }
                column(vClass; vClass)
                {
                }
                column(Registration_Subjects___Class_No__; "Registration Subjects"."Class No.")
                {
                }
                column(Registration_Subjects__Status; rRegiSubjects.Status)
                {
                }
                column(statusText; statusText)
                {
                }
                column(Registration_Subjects__Turn; "Registration Subjects".Turn)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    vTotal := vTotal + 1;

                    rRegiSubjects.Reset;
                    rRegiSubjects.SetRange("School Year", "Registration Subjects"."School Year");
                    rRegiSubjects.SetRange("Line No.", "Registration Subjects"."Line No.");
                    rRegiSubjects.SetRange("Student Code No.", "Registration Subjects"."Student Code No.");
                    if rRegiSubjects.FindFirst then
                        statusText := Format(rRegiSubjects.Status);

                    if "Registration Subjects".GetFilter(Class) <> '' then begin
                        TempStudents.Init;
                        TempStudents.TransferFields(Students);
                        if not TempStudents.Insert then;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                rEduConfiguration: Record "Edu. Configuration";
            begin
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;
                Clear(vClass);
                rClass.Reset;
                rClass.SetRange(rClass.Class, "Registration Subjects".Class);
                rClass.SetRange(rClass."School Year", "Registration Subjects"."School Year");
                if rClass.FindFirst then
                    vClass := rClass."Schooling Year" + ' - ' + rClass."Class Letter";
                if GetFilter(Class) <> '' then begin
                    rTeacherClass.Reset;
                    rTeacherClass.SetRange("School Year", "Registration Subjects"."School Year");
                    rTeacherClass.SetRange(Class, "Registration Subjects".Class);
                    rTeacherClass.SetRange("Type Subject", rTeacherClass."Type Subject"::Subject);
                    rTeacherClass.SetRange("Subject Code", "Registration Subjects"."Subjects Code");
                    rTeacherClass.SetRange("Allow Assign Evaluations", true);
                    if rTeacherClass.FindFirst then
                        if rEduConfiguration.Get then begin
                            if rEduConfiguration."Full Name syntax" = 0 then begin
                                if rTeacherClass."Last Name 2" <> '' then
                                    TeacherName := rTeacherClass."Last Name" + ' ' + rTeacherClass."Last Name 2" + ', ' + rTeacherClass.Name
                                else
                                    TeacherName := rTeacherClass."Last Name" + ', ' + rTeacherClass.Name;
                            end else begin
                                if rTeacherClass."Last Name 2" <> '' then
                                    TeacherName := rTeacherClass.Name + ' ' + rTeacherClass."Last Name 2" + ' ' + rTeacherClass."Last Name"
                                else
                                    TeacherName := rTeacherClass.Name + ' ' + rTeacherClass."Last Name";
                            end;
                        end;
                end;
                if GetFilter(Class) <> '' then begin
                    TempRegistrationSubjects.Init;
                    TempRegistrationSubjects.TransferFields("Registration Subjects");
                    TempRegistrationSubjects.Insert;
                end;
            end;

            trigger OnPreDataItem()
            begin
                GlobalLanguage := 2070;
                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                //IF ShowWhat = 1 THEN
                "Registration Subjects".SetFilter("Registration Subjects".Status, '<>0');
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(TempStudents__No__; TempStudents."No.")
            {
            }
            column(TempStudents_Name; TempStudents.Name)
            {
            }
            column(vClass_Control1102065008; vClass)
            {
            }
            column(TempRegistrationSubjects__Class_No__; TempRegistrationSubjects."Class No.")
            {
            }
            column(TempRegistrationSubjects_Status; TempRegistrationSubjects.Status)
            {
            }
            column(vTotal_Control1102065012; vTotal)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Registration Subjects".GetFilter(Class) = '' then
                    CurrReport.Break;
                if Number = 1 then
                    TempStudents.Find('-')
                else
                    TempStudents.Next;

                TempRegistrationSubjects.Reset;
                TempRegistrationSubjects.SetRange("Student Code No.", TempStudents."No.");
                if TempRegistrationSubjects.FindFirst then;
            end;

            trigger OnPreDataItem()
            begin
                //tempstudents.reset;
                TempStudents.SetCurrentKey(Name);
                //TempStudents.ASCENDING(true);
                Integer.SetRange(Number, 1, TempStudents.Count);
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
                    Visible = false;
                    field(ShowWhat; ShowWhat)
                    {
                        ApplicationArea = All;
                        OptionCaption = 'Show all (Potential and Subscribed),Show Subscribed only';
                        ShowCaption = false;
                        Visible = false;
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

        Filtros := "Registration Subjects".GetFilters;
    end;

    var
        rSchool: Record School;
        rRespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        rClass: Record Class;
        rTeacherClass: Record "Teacher Class";
        TempStudents: Record Students temporary;
        TempRegistrationSubjects: Record "Registration Subjects" temporary;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[1024];
        Filtros: Text[1024];
        vClass: Text[50];
        vTotal: Integer;
        TeacherName: Text[250];
        ShowWhat: Option "0","1";
        Students_SubjectCaptionLbl: Label 'Students Subject';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        FiltersCaptionLbl: Label 'Filters';
        TeacherCaptionLbl: Label 'Teacher';
        StatusCaptionLbl: Label 'Status';
        Class_No_CaptionLbl: Label 'Class No.';
        ClassCaptionLbl: Label 'Class';
        Students__No__CaptionLbl: Label 'No.';
        TurnoCaptionLbl: Label 'Turno';
        vTotalCaptionLbl: Label 'Total';
        vTotal_Control1102065012CaptionLbl: Label 'Total';
        Lang: Record Language;
        rRegiSubjects: Record "Registration Subjects";
        statusText: Text;
}

