#pragma implicitwith disable
page 52785 Class
{
    // IT001-CPA Específicos
    //      - Alteração Captions:
    //       - Old: Nº Diretor Turma -> New: Nº Professor Responsável
    //       - Old: Nome Diretor Turma -> New: Nome Professor Responsável

    Caption = 'Class';
    DelayedInsert = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Class;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Class Letter"; Rec."Class Letter")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    Editable = false;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan/Course Code';
                    Editable = "Study Plan CodeEditable";

                    trigger OnValidate()
                    begin
                        StudyPlanCodeOnAfterValidate;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Class Director No."; Rec."Class Director No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class Director No.';
                }
                field("Class Director Name"; Rec."Class Director Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class Director Name.';
                    Editable = false;
                }
                field("Class Secretary No."; Rec."Class Secretary No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Secretary Name"; Rec."Secretary Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Room; Rec.Room)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(SubForm; "Registration Class")
            {
                ApplicationArea = All;
                SubPageLink = Class = FIELD(Class),
                              "School Year" = FIELD("School Year"),
                              "Schooling Year" = FIELD("Schooling Year"),
                              "Study Plan Code" = FIELD("Study Plan Code"),
                              Type = FIELD(Type);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Class")
            {
                Caption = '&Class';
                Image = CustomerGroup;
                action("&Dimensions")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    var
                        lDefaultDimension: Record "Default Dimension";
                    begin
                        lDefaultDimension.Reset;
                        lDefaultDimension.SetRange("Table ID", 52763);
                        //lDefaultDimension.SETRANGE("No.",FORMAT("Dimension ID"));
                        lDefaultDimension.SetRange("No.", Rec.Class);
                        PAGE.RunModal(PAGE::"Default Dimensions", lDefaultDimension);
                    end;
                }
                action("&Observations")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Observations';
                    Image = Setup;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        //cuRemarks: Codeunit Codeunit52751;
                        lSchoolYear: Record "School Year";
                        l_rMoments: Record "Moments Assessment";
                        int: Integer;
                        tAssessment: Text[1024];
                    begin

                        if (Rec."School Year" <> '') or (Rec.Class <> '') or (Rec."Schooling Year" <> '') or (Rec."Study Plan Code" <> '') then begin
                            //
                            l_rMoments.Reset;
                            l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                            l_rMoments.SetRange("School Year", Rec."School Year");
                            l_rMoments.SetRange("Schooling Year", Rec."Schooling Year");
                            l_rMoments.SetRange("Responsibility Center", Rec."Responsibility Center");
                            if l_rMoments.FindSet then begin
                                repeat
                                    tAssessment := tAssessment + l_rMoments."Moment Code" + ','
                                until l_rMoments.Next = 0;
                            end else
                                Error(Text0012, Rec."School Year", Rec."Schooling Year");

                            if tAssessment <> '' then begin
                                int := StrMenu(tAssessment);
                                l_rMoments.Reset;
                                l_rMoments.SetCurrentKey("Schooling Year", "Sorting ID");
                                l_rMoments.SetRange("School Year", Rec."School Year");
                                l_rMoments.SetRange("Schooling Year", Rec."Schooling Year");
                                l_rMoments.SetRange("Responsibility Center", Rec."Responsibility Center");
                                if l_rMoments.FindSet and (int <> 0) then
                                    l_rMoments.Next := int - 1
                                else
                                    exit;

                            end;
                            //
                            /*if lSchoolYear.Get("School Year") then begin
                                if (lSchoolYear.Status = lSchoolYear.Status::Active) or (lSchoolYear.Status = lSchoolYear.Status::Closing) then
                                    cuRemarks.EditContactTextGClass("School Year", Class, "Schooling Year", "Study Plan Code", l_rMoments."Moment Code", true);
                                if (lSchoolYear.Status = lSchoolYear.Status::Closed) or (lSchoolYear.Status = lSchoolYear.Status::Planning) then
                                    cuRemarks.EditContactTextGClass("School Year", Class, "Schooling Year", "Study Plan Code", l_rMoments."Moment Code", false);
                            end;*/
                        end else
                            Message(Text0011);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = InsuranceRegisters;
                action("&Automatic Numbering")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Automatic Numbering';
                    Image = NumberGroup;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //Este If é só para Portugal
                        rRegistrationClass.SetRange(Class, Rec.Class);
                        rRegistrationClass.SetRange("School Year", Rec."School Year");
                        rRegistrationClass.SetRange("Schooling Year", Rec."Schooling Year");
                        rRegistrationClass.SetFilter(rRegistrationClass."Class No.", '<>%1', 0);
                        if rRegistrationClass.FindFirst then
                            Error(Text0030)
                        else
                            Rec.AssignNumbers();
                    end;
                }
                action("&Subscribe")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Subscribe';
                    Image = Register;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Normatica 2013.07.22 - Não deixar fazer este processo se o ano estiver fechado
                        rAnoLetivo.Reset;
                        rAnoLetivo.SetRange(rAnoLetivo."School Year", Rec."School Year");
                        rAnoLetivo.SetRange(rAnoLetivo.Status, rAnoLetivo.Status::Closed);
                        if rAnoLetivo.FindFirst then
                            Error(Text0015);
                        //Normatica 2013.07.22 - Fim

                        //CurrPage.SubForm.PAGE.GetRecord(rRegistrationClass);

                        if (rRegistrationClass.Status = rRegistrationClass.Status::" ") then
                            Rec.SubscribedRegistrationClass()
                        else
                            Error(Text005, rRegistrationClass.Status);
                    end;
                }
            }
            group("&Functions")
            {
                Caption = '&Functions';
                Image = ServiceSetup;
                action("T&eacher/Subject")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'T&eacher/Subject';
                    Image = UserCertificate;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rHorario: Record Timetable;
                        rStudyPlanLines: Record "Study Plan Lines";
                        rCourseLines: Record "Course Lines";
                        rCourseLinesTEMP: Record "Course Lines" temporary;
                        rStruEduCountry: Record "Structure Education Country";
                        l_rStruEduCountry: Record "Structure Education Country";
                        l_rHorarioProfessorLinhas: Record "Teacher Timetable Lines";
                        cStudentsRegistration: Codeunit "Students Registration";
                    begin

                        rStudyPlanLines.Reset;
                        rStudyPlanLines.FilterGroup(2);
                        rStudyPlanLines.SetRange(Code, Rec."Study Plan Code");
                        rStudyPlanLines.SetRange("School Year", Rec."School Year");
                        rStudyPlanLines.SetRange("Schooling Year", Rec."Schooling Year");
                        rStudyPlanLines.FilterGroup(0);
                        if rStudyPlanLines.Find('-') then begin
                            Clear(fTeacherSubject);
                            fTeacherSubject.funClass(Rec);

                            fTeacherSubject.SetTableView(rStudyPlanLines);
                            fTeacherSubject.Run;
                        end;



                        rCourseLinesTEMP.Reset;
                        rCourseLinesTEMP.DeleteAll;

                        //Quadriennal
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Rec."Study Plan Code");
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                        if rCourseLines.Find('-') then begin
                            repeat
                                rCourseLinesTEMP.Init;
                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                rCourseLinesTEMP."Temp Class" := Rec.Class;
                                rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                rCourseLinesTEMP.Insert;
                            until rCourseLines.Next = 0;
                        end;

                        //Anual
                        rCourseLines.Reset;
                        rCourseLines.SetRange(Code, Rec."Study Plan Code");
                        rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                        rCourseLines.SetRange("Schooling Year Begin", Rec."Schooling Year");
                        if rCourseLines.Find('-') then begin
                            repeat
                                rCourseLinesTEMP.Init;
                                rCourseLinesTEMP.TransferFields(rCourseLines);
                                rCourseLinesTEMP."Temp Class" := Rec.Class;
                                rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                rCourseLinesTEMP.Insert;
                            until rCourseLines.Next = 0;
                        end;

                        //Bienal E Triennal
                        rStruEduCountry.Reset;
                        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                        rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                        if rStruEduCountry.Find('-') then begin
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, Rec."Study Plan Code");
                            rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                            rCourseLines."Characterise Subjects"::Triennial);
                            rCourseLines.SetRange("Schooling Year Begin", Rec."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := Rec.Class;
                                    rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;
                            //ELSE BEGIN
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 1);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP."Temp Class" := Rec.Class;
                                        rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 2);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP."Temp Class" := Rec.Class;
                                        rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;
                            l_rStruEduCountry.Reset;
                            l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 1);
                            if l_rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP."Temp Class" := Rec.Class;
                                        rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                            end;


                            if rCourseLinesTEMP.Find('-') then begin
                                PAGE.RunModal(PAGE::"Subject Teacher Course", rCourseLinesTEMP);
                            end;


                        end;
                    end;
                }
                action("&Open Timetable")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Open Timetable';
                    Image = ProfileCalendar;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rHorario: Record Timetable;
                        rCalendario: Record Calendar;
                        fHorarioList: Page "Timetable List";
                        fCalendario: Page Calendar;
                    begin
                        rHorario.Reset;
                        rHorario.SetRange("School Year", Rec."School Year");
                        rHorario.SetRange("Study Plan", Rec."Study Plan Code");
                        rHorario.SetRange(Class, Rec.Class);
                        rHorario.SetRange(Type, Rec.Type);
                        if rHorario.Find('-') then begin
                            fHorarioList.SetTableView(rHorario);
                            fHorarioList.RunModal;
                        end else
                            Error(Text004, Rec.Class);
                    end;
                }
                action("As&pects")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'As&pects';
                    Image = Relationship;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        rStudyPlanLines: Record "Study Plan Lines";
                        rCourseLines: Record "Course Lines";
                        rCourseLinesTEMP: Record "Course Lines" temporary;
                        rStruEduCountry: Record "Structure Education Country";
                        l_rStruEduCountry: Record "Structure Education Country";
                        fClassAspectsCourse: Page "Class Aspects Course";
                        fClassAspects: Page "Class Aspects Study Lines";
                    begin
                        //CurrForm.SubForm.FORM.Aspects;

                        if Rec.Type = Rec.Type::Simple then begin
                            rStudyPlanLines.Reset;
                            rStudyPlanLines.SetRange(Code, Rec."Study Plan Code");
                            rStudyPlanLines.SetRange("School Year", Rec."School Year");
                            if rStudyPlanLines.Find('-') then begin
                                fClassAspects.GetClass(Rec.Class, Rec."School Year", Rec."Schooling Year");
                                fClassAspects.SetTableView(rStudyPlanLines);
                                fClassAspects.RunModal;
                            end;
                        end;

                        if Rec.Type = Rec.Type::Multi then begin
                            //
                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.DeleteAll;

                            //Quadriennal
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, Rec."Study Plan Code");
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Quadriennal);
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := Rec.Class;
                                    rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Anual
                            rCourseLines.Reset;
                            rCourseLines.SetRange(Code, Rec."Study Plan Code");
                            rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Annual);
                            rCourseLines.SetRange("Schooling Year Begin", Rec."Schooling Year");
                            if rCourseLines.Find('-') then begin
                                repeat
                                    rCourseLinesTEMP.Init;
                                    rCourseLinesTEMP.TransferFields(rCourseLines);
                                    rCourseLinesTEMP."Temp Class" := Rec.Class;
                                    rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                    rCourseLinesTEMP.Insert;
                                until rCourseLines.Next = 0;
                            end;

                            //Bienal E Triennal
                            rStruEduCountry.Reset;
                            rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                            rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                            rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                            if rStruEduCountry.Find('-') then begin
                                rCourseLines.Reset;
                                rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                rCourseLines.SetFilter("Characterise Subjects", '%1|%2', rCourseLines."Characterise Subjects"::Biennial,
                                rCourseLines."Characterise Subjects"::Triennial);
                                rCourseLines.SetRange("Schooling Year Begin", Rec."Schooling Year");
                                if rCourseLines.Find('-') then begin
                                    repeat
                                        rCourseLinesTEMP.Init;
                                        rCourseLinesTEMP.TransferFields(rCourseLines);
                                        rCourseLinesTEMP."Temp Class" := Rec.Class;
                                        rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                        rCourseLinesTEMP.Insert;
                                    until rCourseLines.Next = 0;
                                end;
                                //ELSE BEGIN
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Biennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP."Temp Class" := Rec.Class;
                                            rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 2);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP."Temp Class" := Rec.Class;
                                            rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                                l_rStruEduCountry.Reset;
                                l_rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
                                l_rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
                                l_rStruEduCountry.SetRange("Sorting ID", GetNoStructureCountry(Rec.Class, Rec."School Year") - 1);
                                if l_rStruEduCountry.Find('-') then begin
                                    rCourseLines.Reset;
                                    rCourseLines.SetRange(Code, Rec."Study Plan Code");
                                    rCourseLines.SetRange("Characterise Subjects", rCourseLines."Characterise Subjects"::Triennial);
                                    rCourseLines.SetRange("Schooling Year Begin", l_rStruEduCountry."Schooling Year");
                                    if rCourseLines.Find('-') then begin
                                        repeat
                                            rCourseLinesTEMP.Init;
                                            rCourseLinesTEMP.TransferFields(rCourseLines);
                                            rCourseLinesTEMP."Temp Class" := Rec.Class;
                                            rCourseLinesTEMP."Temp School Year" := Rec."School Year";
                                            rCourseLinesTEMP.Insert;
                                        until rCourseLines.Next = 0;
                                    end;
                                end;
                            end;
                            //
                            rCourseLinesTEMP.Reset;
                            rCourseLinesTEMP.SetRange(Code, Rec."Study Plan Code");
                            if rCourseLinesTEMP.Find('-') then begin
                                if PAGE.RunModal(PAGE::"Class Aspects Course", rCourseLinesTEMP) = ACTION::LookupOK then;
                                //      fClassAspectsCourse.GetClass(Class,"School Year","Schooling Year");
                                //      fClassAspectsCourse.SETTABLEVIEW(rCourseLinesTEMP);
                                //   fClassAspectsCourse.RUNMODAL;
                            end;


                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("R&egistration Students Sheets")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'R&egistration Students Sheets';
                    Image = Register;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Clear(ftemplates);
                        PageBreak := true;
                        rtemplates.Reset;
                        rtemplates.SetRange(Type, rtemplates.Type::"Registration Sheet");
                        ftemplates.SetTableView(rtemplates);
                        ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '', rtemplates.Type::"Registration Sheet", '', ''
                                                   , true);
                        ftemplates.LookupMode(true);
                        ftemplates.RunModal;
                    end;
                }
                action("Alunos - Contactos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Alunos - Contactos';
                    Image = Users;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(rClass);
                        REPORT.RunModal(52883, true, false, rClass);
                    end;
                }
                separator(Action1102065022)
                {
                }
                group("&Legal Reports")
                {
                    Caption = '&Legal Reports';
                    Visible = false;
                    group("&Primary")
                    {
                        Caption = '&Primary';
                        action("&Legal PRI - Transfer")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = '&Legal PRI - Transfer';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Primary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal Pri - Transfer");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Transfer", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Transfer", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("L&egal PRI - Qualifications")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'L&egal PRI - Qualifications';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Primary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal Pri - Actas Qualf");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Actas Qualf", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Actas Qualf", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Le&gal PRI - Historic")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Le&gal PRI - Historic';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Primary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal Pri - Historic");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Historic", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Historic", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Leg&al PRI - Dossier")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Leg&al PRI - Dossier';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Primary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal Pri - Dossier");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Dossier", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Dossier", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Legal PRI - Individual Report")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Legal PRI - Individual Report';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Primary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal Pri - Individual Report");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Individual Report", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal Pri - Individual Report", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                    }
                    group("&Lower Secondary")
                    {
                        Caption = '&Lower Secondary';
                        action("&Legal LS - Transfer")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = '&Legal LS - Transfer';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal LS - Transfer");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Transfer", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Transfer", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("L&egal LS - Qualificacions")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'L&egal LS - Qualificacions';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal LS - Qualificacions");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Qualificacions", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Qualificacions", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Le&gal LS - Historic")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Le&gal LS - Historic';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal LS - Historic");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Historic", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Historic", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Leg&al LS - Dossier")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Leg&al LS - Dossier';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal LS - Dossier");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Dossier", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal LS - Dossier", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                    }
                    group("&Upper Secondary")
                    {
                        Caption = '&Upper Secondary';
                        action("&Legal UPP - Transfer")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = '&Legal UPP - Transfer';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Upper Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal UPP - Transfer");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Transfer", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Transfer", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("L&egal UPP - Qualificacions")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'L&egal UPP - Qualificacions';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Upper Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal UPP - Actas Qualf");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Actas Qualf", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Actas Qualf", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Le&gal UPP - Historic")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Le&gal UPP - Historic';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Upper Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal UPP - Historic");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Historic", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Historic", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                        action("Leg&al UPP - Dossier")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Leg&al UPP - Dossier';

                            trigger OnAction()
                            begin
                                rStruEduCountry.Reset;
                                rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                                if rStruEduCountry.Find('-') then begin
                                    if rStruEduCountry."Edu. Level" <> rStruEduCountry."Edu. Level"::"Upper Secondary Edu." then
                                        Error(Text007)
                                    else begin
                                        Clear(ftemplates);
                                        PageBreak := true;
                                        rtemplates.Reset;
                                        rtemplates.SetRange(Type, rtemplates.Type::"Legal UPP - Dossier");
                                        ftemplates.SetTableView(rtemplates);
                                        if Rec."Responsibility Center" = '' then
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Dossier", '', '', true)
                                        else
                                            ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '',
                                            rtemplates.Type::"Legal UPP - Dossier", Rec."Responsibility Center", '', true);
                                        ftemplates.LookupMode(true);
                                        ftemplates.RunModal;
                                    end;
                                end;
                            end;
                        }
                    }
                }
            }
            action("Biographics &Record")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Biographics &Record';
                Image = InsuranceRegisters;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    vBioType: Option " ",,,,,,,,"Biographic Record Primary","Biographic Record Lower Secondary","Biographic Record Upper Secondary";
                begin

                    Clear(ftemplates);
                    PageBreak := true;
                    rStruEduCountry.Reset;
                    rStruEduCountry.SetRange("Schooling Year", Rec."Schooling Year");
                    if rStruEduCountry.Find('-') then
                        if rStruEduCountry."Edu. Level" = rStruEduCountry."Edu. Level"::"Primary Edu." then
                            vBioType := vBioType::"Biographic Record Primary";
                    if rStruEduCountry."Edu. Level" = rStruEduCountry."Edu. Level"::"Lower Secondary Edu." then
                        vBioType := vBioType::"Biographic Record Lower Secondary";
                    if rStruEduCountry."Edu. Level" = rStruEduCountry."Edu. Level"::"Upper Secondary Edu." then
                        vBioType := vBioType::"Biographic Record Upper Secondary";

                    rtemplates.Reset;
                    rtemplates.SetRange(Type, vBioType);
                    ftemplates.SetTableView(rtemplates);
                    ftemplates.SetFormStudents('', Rec."School Year", '', Rec."Schooling Year", Rec.Class, PageBreak, '', '', vBioType, '', '', true);
                    ftemplates.LookupMode(true);
                    ftemplates.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if not Rec.Closed then
            "Study Plan CodeEditable" := true
        else
            "Study Plan CodeEditable" := false;
    end;

    trigger OnInit()
    begin
        "Study Plan CodeEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Study Plan CodeEditable" := true;

        if REc.Class = '' then begin
            rEduConfiguration.Get;
            rEduConfiguration.TestField("Class Nos.");
            //Rec.Class := NoSeriesMgt.GetNextNo(rEduConfiguration."Class Nos.", WorkDate, false);
            //TODO：to test
            Rec.Class := CU_NoSeries.GetNextNo(rEduConfiguration."Class Nos.", WorkDate, false);

        end;
    end;

    var
        rRegistrationClass: Record "Registration Class";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseLines: Record "Course Lines";
        rEduConfiguration: Record "Edu. Configuration";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CU_NoSeries: Codeunit "No. Series";
        rCourseHeader: Record "Course Header";
        rRegistration: Record Registration;
        cUserEducation: Codeunit "User Education";
        rStruEduCountry: Record "Structure Education Country";
        cStudentsRegistration: Codeunit "Students Registration";
        Text002: Label 'Do you wish to change %1 from the class %2?';
        Text003: Label 'On class %1 there is no created calendar.';
        Text004: Label 'On class %1 there is no timetable.';
        rtemplates: Record Templates;
        PageBreak: Boolean;
        Text005: Label 'The student registration is already %1 !';
        Text006: Label 'The only available option is to subscribe the student.';
        Text007: Label 'This option for this schooling year is not valid, please choose another.';
        Text0010: Label 'The student belongs to another level of education / study plan, to access this feature, please use the functions of the student''s study plan.';
        Text0011: Label 'Not allowed to insert observation.';
        Text0012: Label 'There aren''t any moments for School year %1 and Schooling Year %2.';
        rClass: Record Class;
        Text0030: Label 'You can not assign automatic numbering. Fill in the numbers manually.';
        Attachment: Record "Attached Documents";
        Text0013: Label 'Successfully imported.';
        Text0014: Label 'Import Files';
        Text0015: Label 'Não pode executar este processo para anos letivos já fechados.';
        rAnoLetivo: Record "School Year";
        [InDataSet]
        "Study Plan CodeEditable": Boolean;
        ftemplates: Page Templates;
        fTeacherSubject: Page "Subject Teacher";


    procedure GetNoStructureCountry(pClass: Code[20]; pSchoolYear: Code[9]): Integer
    var
        rStruEduCountry: Record "Structure Education Country";
        rClass: Record Class;
        cStudentsRegistration: Codeunit "Students Registration";
    begin
        if rClass.Get(pClass, pSchoolYear) then;

        rStruEduCountry.Reset;
        rStruEduCountry.SetRange(Country, cStudentsRegistration.GetCountry);
        rStruEduCountry.SetRange(Type, rStruEduCountry.Type::Multi);
        if rStruEduCountry.Find('-') then begin
            repeat
                if rClass."Schooling Year" = rStruEduCountry."Schooling Year" then
                    exit(rStruEduCountry."Sorting ID");
            until rStruEduCountry.Next = 0;
        end;
    end;

    local procedure StudyPlanCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

