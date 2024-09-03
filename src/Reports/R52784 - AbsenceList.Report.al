report 52784 "Absence List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    DefaultLayout = RDLC;
    RDLCLayout = './AbsenceList.rdlc';
    Caption = 'Absence List';

    dataset
    {
        dataitem(Absence; Absence)
        {
            DataItemTableView = SORTING("School Year", "Student/Teacher Code No.", Subject, "Subcategory Code");
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(rStudents_Name; rStudents.Name)
            {
            }
            column(Absence__Student_Teacher_Code_No__; "Student/Teacher Code No.")
            {
            }
            column(nomeEscola; nomeEscola)
            {
            }
            column(Absence_Subject; Subject)
            {
            }
            column(rSubject_Description; rSubject.Description)
            {
            }
            column(Absence__Subcategory_Code_; "Subcategory Code")
            {
            }
            column(rSubType_Description; rSubType.Description)
            {
            }
            column(Absence__Justified_Description_; "Justified Description")
            {
            }
            column(vClass; vClass)
            {
            }
            column(Absence_Observations; Observations)
            {
            }
            column(Absence__Absence_Status_; "Absence Status")
            {
            }
            column(Absence__Absence_Type_; "Absence Type")
            {
            }
            column(Absence_Day; Day)
            {
            }
            column(IcontadorPar; IcontadorPar)
            {
            }
            column(IcontadorParSub; IcontadorParSub)
            {
            }
            column(IcontadorTot; IcontadorTot)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Llista_d_absènciaCaption"; Llista_d_absènciaCaptionLbl)
            {
            }
            column(Absence__Justified_Description_Caption; FieldCaption("Justified Description"))
            {
            }
            column(ClasseCaption; ClasseCaptionLbl)
            {
            }
            column(Absence_ObservationsCaption; FieldCaption(Observations))
            {
            }
            column(Absence__Absence_Status_Caption; FieldCaption("Absence Status"))
            {
            }
            column(Absence__Absence_Type_Caption; FieldCaption("Absence Type"))
            {
            }
            column(Absence_DayCaption; FieldCaption(Day))
            {
            }
            column(Absence__Student_Teacher_Code_No__Caption; Absence__Student_Teacher_Code_No__CaptionLbl)
            {
            }
            column(Nom_de_l_AlumneCaption; Nom_de_l_AlumneCaptionLbl)
            {
            }
            column(Absence_SubjectCaption; FieldCaption(Subject))
            {
            }
            column(Absence__Subcategory_Code_Caption; FieldCaption("Subcategory Code"))
            {
            }
            column(Total_sub_tipusCaption; Total_sub_tipusCaptionLbl)
            {
            }
            column(Total_de_la_disciplinaCaption; Total_de_la_disciplinaCaptionLbl)
            {
            }
            column(Total_de_Faltes_de_l_AlumneCaption; Total_de_Faltes_de_l_AlumneCaptionLbl)
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
            column(Absence_Category; Category)
            {
            }
            column(Absence_Student_Teacher; "Student/Teacher")
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
                if "Responsibility Center" <> cUserEducation.GetEducationFilter(UserId) then
                    CurrReport.Skip;

                rStudents.Reset;
                rStudents.SetRange("No.", Absence."Student/Teacher Code No.");
                if rStudents.Find('-') then;

                rSubType.Reset;
                rSubType.SetRange("Subcategory Code", Absence."Subcategory Code");
                if rSubType.Find('-') then;


                rSubject.Reset;
                rSubject.SetRange(Code, Absence.Subject);
                if rSubject.Find('-') then;


                if "Student/Teacher Code No." <> VarStudentno then begin
                    IcontadorParSub := 0;
                    IcontadorPar := 0;
                    IcontadorTot := 0;

                end;

                if Subject <> VarSubject then begin
                    IcontadorPar := 0;
                    IcontadorParSub := 0;
                end;

                if "Subcategory Code" <> varSubjectType then begin
                    IcontadorPar := 0;
                end;

                IcontadorParSub := IcontadorParSub + 1;
                IcontadorPar := IcontadorPar + 1;
                IcontadorTot := IcontadorTot + 1;


                if
                //(Subject <>  VarSubject) OR
                ("Student/Teacher Code No." <> VarStudentno) then
                    if not "1stpage" then
                        CurrReport.NewPage;

                VarStudentno := "Student/Teacher Code No.";
                VarSubject := Subject;
                varSubjectType := "Subcategory Code";

                "1stpage" := false;


                rClass.Reset;
                rClass.SetRange(rClass.Class, Absence.Class);
                rClass.SetRange(rClass."School Year", Absence."School Year");
                if rClass.FindFirst then
                    vClass := rClass."Schooling Year" + ' - ' + rClass."Class Letter";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                LastFieldNo := FieldNo("Subcategory Code");
                "1stpage" := true;


                if cUserEducation.GetEducationFilter(UserId) <> '' then begin
                    rRespCenter.Reset;
                    rRespCenter.Get(cUserEducation.GetEducationFilter(UserId));
                    nomeEscola := rRespCenter.Name + ' ' + rRespCenter."Name 2";
                end else begin
                    rSchool.Reset;
                    if rSchool.Find('-') then
                        nomeEscola := rSchool."School Name";
                end;

                if varCategoryCode <> '' then
                    SetRange("Subcategory Code", varCategoryCode);
                if varClass <> '' then
                    SetRange(Class, varClass);
                if VarStudentno <> '' then begin
                    SetRange("Student/Teacher Code No.", VarStudentno);
                    SetRange("Student/Teacher", Absence."Student/Teacher"::Student);
                end;
                if VarSubject <> '' then
                    SetRange(Subject, VarSubject);
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
                        field(varSchoolYear; varSchoolYear)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'School Year';
                            Editable = false;
                        }
                        field(Class; varClass)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Class';

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                l_rClassTemp: Record Class temporary;
                                l_rStruEduCountry: Record "Structure Education Country";
                                l_rClass: Record Class;
                                l_rRegistrationClass: Record "Registration Class";
                            begin
                                if VarStudentno = '' then begin
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
                                            l_rRegistrationClass.SetRange("Student Code No.", VarStudentno);
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
                        field(VarStudentno; VarStudentno)
                        {
                            ApplicationArea = Basic, Suite;
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
                                            VarStudentno := l_rStudentsTemp."No.";
                                        end;
                                    end;
                                end else begin
                                    if PAGE.RunModal(PAGE::"Students List", l_rStudents) = ACTION::LookupOK then begin
                                        VarStudentno := l_rStudents."No.";
                                    end;
                                end;
                            end;
                        }
                        field(VarSubject; VarSubject)
                        {
                            ApplicationArea = Basic, Suite;
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
                                    if VarStudentno <> '' then
                                        l_rRegistrationSubjects.SetRange("Student Code No.", VarStudentno);
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
                                            VarSubject := l_rSubjectsTemp.Code;
                                        end;
                                    end;
                                end;
                            end;
                        }
                        field(varCategoryCode; varCategoryCode)
                        {
                            ApplicationArea = Basic, Suite;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInfo: Record "Company Information";
        IcontadorPar: Integer;
        IcontadorTot: Integer;
        IcontadorParSub: Integer;
        VarStudentno: Code[20];
        VarSubject: Code[20];
        varSubjectType: Code[20];
        varCategoryCode: Code[20];
        varClass: Code[20];
        VarSchoolingYear: Code[20];
        varSchoolYear: Code[20];
        "1stpage": Boolean;
        rSubType: Record "Sub Type";
        rSubject: Record Subjects;
        rStudents: Record Students;
        rRespCenter: Record "Responsibility Center";
        rSchool: Record School;
        rClass: Record Class;
        cUserEducation: Codeunit "User Education";
        nomeEscola: Text[128];
        vClass: Text[50];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        "Llista_d_absènciaCaptionLbl": Label 'Absence List';
        ClasseCaptionLbl: Label 'Class';
        Absence__Student_Teacher_Code_No__CaptionLbl: Label 'Student Code No.';
        Nom_de_l_AlumneCaptionLbl: Label 'Student Name';
        Total_sub_tipusCaptionLbl: Label 'Total Of Sub Type';
        Total_de_la_disciplinaCaptionLbl: Label 'Total Of Subject';
        Total_de_Faltes_de_l_AlumneCaptionLbl: Label 'Total Student Absence';
}

